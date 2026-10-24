import 'package:flutter/foundation.dart';

import '../models/expense.dart';
import '../models/expense_category.dart';
import '../services/storage_service.dart';

class ExpenseProvider extends ChangeNotifier {
  ExpenseProvider(this._storage);

  final StorageService _storage;

  List<Expense> _expenses = [];
  double _budget = 0;
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  static bool _sameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  // ---------- Loading ----------
  Future<void> load() async {
    _expenses = await _storage.loadExpenses();
    _budget = await _storage.loadBudget();
    notifyListeners();
  }

  // ---------- Getters ----------
  DateTime get month => _month;
  double get budget => _budget;

  bool get isCurrentMonth => _sameMonth(_month, DateTime.now());

  List<Expense> get monthExpenses {
    final list = _expenses.where((e) => _sameMonth(e.date, _month)).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  double get monthTotal =>
      monthExpenses.fold<double>(0, (sum, e) => sum + e.amount);

  /// Category totals for the selected month, biggest first.
  List<MapEntry<ExpenseCategory, double>> get categoryTotals {
    final Map<ExpenseCategory, double> totals = {};
    for (final e in monthExpenses) {
      totals[e.category] = (totals[e.category] ?? 0) + e.amount;
    }
    final entries = totals.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }

  /// Totals for the last [count] months, ending at the selected month.
  List<MapEntry<DateTime, double>> lastMonthsTotals(int count) {
    return List.generate(count, (i) {
      final m = DateTime(_month.year, _month.month - (count - 1 - i));
      final total = _expenses
          .where((e) => _sameMonth(e.date, m))
          .fold<double>(0, (sum, e) => sum + e.amount);
      return MapEntry(m, total);
    });
  }

  // ---------- Month navigation ----------
  void previousMonth() {
    _month = DateTime(_month.year, _month.month - 1);
    notifyListeners();
  }

  void nextMonth() {
    if (isCurrentMonth) return;
    _month = DateTime(_month.year, _month.month + 1);
    notifyListeners();
  }

  // ---------- Expenses ----------
  String newId() => DateTime.now().microsecondsSinceEpoch.toString();

  Future<void> addExpense(Expense expense) async {
    _expenses.add(expense);
    notifyListeners();
    await _storage.saveExpenses(_expenses);
  }

  Future<void> updateExpense(Expense expense) async {
    final index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index == -1) return;
    _expenses[index] = expense;
    notifyListeners();
    await _storage.saveExpenses(_expenses);
  }

  Future<void> deleteExpense(String id) async {
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
    await _storage.saveExpenses(_expenses);
  }

  // ---------- Budget ----------
  Future<void> setBudget(double value) async {
    _budget = value;
    notifyListeners();
    await _storage.saveBudget(value);
  }
}