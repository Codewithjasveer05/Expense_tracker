import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/expense_provider.dart';
import '../utils/formatters.dart';
import '../widgets/category_bar.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final categories = provider.categoryTotals;
    final total = provider.monthTotal;
    final months = provider.lastMonthsTotals(6);

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            Formatters.monthYear(provider.month),
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            Formatters.money(total),
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 24),
          const Text(
            'Last 6 months',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _MonthlyBars(data: months),
          const SizedBox(height: 28),
          const Text(
            'By category',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          if (categories.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No data for this month yet.',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            )
          else
            ...categories.map(
              (entry) => CategoryBar(
                category: entry.key,
                amount: entry.value,
                fraction: total == 0 ? 0 : entry.value / total,
              ),
            ),
        ],
      ),
    );
  }
}

class _MonthlyBars extends StatelessWidget {
  const _MonthlyBars({required this.data});

  final List<MapEntry<DateTime, double>> data;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final maxValue = data.fold<double>(0, (a, b) => a > b.value ? a : b.value);
    const double maxBarHeight = 110;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((entry) {
          final barHeight =
              maxValue == 0 ? 4.0 : (entry.value / maxValue) * maxBarHeight + 4;
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  entry.value == 0 ? '' : Formatters.compact(entry.value),
                  style: const TextStyle(fontSize: 11),
                ),
                const SizedBox(height: 4),
                Container(
                  height: barHeight,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  Formatters.shortMonth(entry.key),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}