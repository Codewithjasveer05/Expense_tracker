import 'package:flutter/material.dart';

import '../utils/formatters.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.total,
    required this.budget,
    required this.onEditBudget,
  });

  final double total;
  final double budget;
  final VoidCallback onEditBudget;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasBudget = budget > 0;
    final isOver = hasBudget && total > budget;
    final progress = hasBudget ? (total / budget).clamp(0.0, 1.0) : 0.0;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [scheme.primary, scheme.primary.withOpacity(0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Spent this month',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            Formatters.money(total),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          if (hasBudget) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.white24,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isOver ? Colors.redAccent : Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    isOver
                        ? 'Over budget by ${Formatters.money(total - budget)}'
                        : '${Formatters.money(budget - total)} left of '
                            '${Formatters.money(budget)}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: onEditBudget,
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  child: const Text('Edit'),
                ),
              ],
            ),
          ] else
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: onEditBudget,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white54),
                ),
                icon: const Icon(Icons.flag_outlined, size: 18),
                label: const Text('Set monthly budget'),
              ),
            ),
        ],
      ),
    );
  }
}