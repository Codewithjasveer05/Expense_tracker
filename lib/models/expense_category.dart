import 'package:flutter/material.dart';

enum ExpenseCategory {
  food,
  transport,
  shopping,
  bills,
  health,
  entertainment,
  other,
}

extension ExpenseCategoryX on ExpenseCategory {
  String get label {
    switch (this) {
      case ExpenseCategory.food:
        return 'Food';
      case ExpenseCategory.transport:
        return 'Transport';
      case ExpenseCategory.shopping:
        return 'Shopping';
      case ExpenseCategory.bills:
        return 'Bills';
      case ExpenseCategory.health:
        return 'Health';
      case ExpenseCategory.entertainment:
        return 'Fun';
      case ExpenseCategory.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case ExpenseCategory.food:
        return Icons.restaurant;
      case ExpenseCategory.transport:
        return Icons.directions_bus;
      case ExpenseCategory.shopping:
        return Icons.shopping_bag;
      case ExpenseCategory.bills:
        return Icons.receipt_long;
      case ExpenseCategory.health:
        return Icons.favorite;
      case ExpenseCategory.entertainment:
        return Icons.movie;
      case ExpenseCategory.other:
        return Icons.category;
    }
  }

  Color get color {
    switch (this) {
      case ExpenseCategory.food:
        return Colors.orange;
      case ExpenseCategory.transport:
        return Colors.blue;
      case ExpenseCategory.shopping:
        return Colors.pink;
      case ExpenseCategory.bills:
        return Colors.indigo;
      case ExpenseCategory.health:
        return Colors.red;
      case ExpenseCategory.entertainment:
        return Colors.purple;
      case ExpenseCategory.other:
        return Colors.blueGrey;
    }
  }
}