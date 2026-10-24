import 'expense_category.dart';

class Expense {
  final String id;
  final String title;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;
  final String note;

  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.note = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category.name,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as String,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: ExpenseCategory.values.firstWhere(
        (c) => c.name == map['category'],
        orElse: () => ExpenseCategory.other,
      ),
      date: DateTime.parse(map['date'] as String),
      note: (map['note'] as String?) ?? '',
    );
  }
}