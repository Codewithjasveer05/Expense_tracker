import 'package:flutter/material.dart';

class BudgetDialog extends StatefulWidget {
  const BudgetDialog({super.key, required this.initial});

  final double initial;

  @override
  State<BudgetDialog> createState() => _BudgetDialogState();
}

class _BudgetDialogState extends State<BudgetDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _controller = TextEditingController(
      text: initial <= 0
          ? ''
          : (initial == initial.roundToDouble()
              ? initial.toStringAsFixed(0)
              : initial.toString()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final text = _controller.text.trim();
    final value = text.isEmpty ? 0.0 : double.tryParse(text);
    if (value == null || value < 0) return;
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Monthly budget'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Amount',
              prefixText: '₹ ',
            ),
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 8),
          Text(
            'Leave empty or enter 0 to remove the budget.',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}