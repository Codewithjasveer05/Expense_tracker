import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../utils/formatters.dart';
import '../widgets/budget_dialog.dart';
import '../widgets/empty_state.dart';
import '../widgets/expense_tile.dart';
import '../widgets/summary_card.dart';
import 'add_expense_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _editBudget(BuildContext context) async {
    final provider = context.read<ExpenseProvider>();
    final result = await showDialog<double>(
      context: context,
      builder: (_) => BudgetDialog(initial: provider.budget),
    );
    if (result != null) {
      await provider.setBudget(result);
    }
  }

  void _openForm(BuildContext context, [Expense? expense]) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AddExpenseScreen(expense: expense)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final expenses = provider.monthExpenses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PennyPilot'),
        actions: [
          IconButton(
            tooltip: 'Statistics',
            icon: const Icon(Icons.bar_chart_rounded),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const StatsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _MonthSelector(provider: provider),
          SummaryCard(
            total: provider.monthTotal,
            budget: provider.budget,
            onEditBudget: () => _editBudget(context),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: expenses.isEmpty
                ? const EmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];
                      return Dismissible(
                        key: ValueKey(expense.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (_) {
                          provider.deleteExpense(expense.id);
                          ScaffoldMessenger.of(context)
                            ..clearSnackBars()
                            ..showSnackBar(
                              SnackBar(
                                content: Text('Deleted "${expense.title}"'),
                                action: SnackBarAction(
                                  label: 'UNDO',
                                  onPressed: () =>
                                      provider.addExpense(expense),
                                ),
                              ),
                            );
                        },
                        child: ExpenseTile(
                          expense: expense,
                          onTap: () => _openForm(context, expense),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Add expense'),
      ),
    );
  }
}

class _MonthSelector extends StatelessWidget {
  const _MonthSelector({required this.provider});

  final ExpenseProvider provider;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: provider.previousMonth,
        ),
        Text(
          Formatters.monthYear(provider.month),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: provider.isCurrentMonth ? null : provider.nextMonth,
        ),
      ],
    );
  }
}