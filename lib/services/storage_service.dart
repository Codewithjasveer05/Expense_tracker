import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/expense.dart';

class StorageService {
  static const String _expensesKey = 'expenses';
  static const String _budgetKey = 'budget';

  Future<List<Expense>> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_expensesKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => Expense.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(expenses.map((e) => e.toMap()).toList());
    await prefs.setString(_expensesKey, encoded);
  }

  Future<double> loadBudget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_budgetKey) ?? 0;
  }

  Future<void> saveBudget(double budget) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_budgetKey, budget);
  }
}