import 'package:flutter/material.dart';

import '../models/expense_category.dart';
import '../utils/formatters.dart';

class CategoryBar extends StatelessWidget {
  const CategoryBar({
    super.key,
    required this.category,
    required this.amount,
    required this.fraction,
  });

  final ExpenseCategory category;
  final double amount;
  final double fraction; // 0.0 to 1.0

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Icon(category.icon, color: category.color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  category.label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                '${Formatters.money(amount)}  '
                '(${(fraction * 100).toStringAsFixed(0)}%)',
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 8,
              backgroundColor: category.color.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation<Color>(category.color),
            ),
          ),
        ],
      ),
    );
  }
}