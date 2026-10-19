
import 'package:flutter/material.dart';

import '../../domain/entities/expense_entity.dart';

class ExpenseSummaryCard extends StatelessWidget {
  final double? budget;
  final List<ExpenseEntity> expenses;

  const ExpenseSummaryCard({
    super.key,
    required this.budget,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final totalSpent = expenses.fold<double>(
      0,
          (sum, expense) => sum + expense.amount,
    );

    final hasBudget = budget != null && budget! > 0;
    final totalBudget = hasBudget ? budget! : 0.0;
    final remaining = totalBudget - totalSpent;

    final progress = hasBudget
        ? (totalSpent / totalBudget).clamp(0.0, 1.0)
        : 0.0;

    final isOverBudget = hasBudget && remaining < 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trip Budget',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _amountColumn(
                    context,
                    'Total Budget',
                    hasBudget
                        ? _formatAmount(totalBudget)
                        : 'Not set',
                  ),
                ),
                Expanded(
                  child: _amountColumn(
                    context,
                    'Total Spent',
                    _formatAmount(totalSpent),
                  ),
                ),
              ],
            ),

            if (hasBudget) ...[
              const SizedBox(height: 24),

              LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                borderRadius: BorderRadius.circular(8),
                color: isOverBudget
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(totalSpent / totalBudget * 100).toStringAsFixed(1)}% used',
                    style: theme.textTheme.bodySmall,
                  ),
                  Flexible(
                    child: Text(
                      isOverBudget
                          ? '${_formatAmount(-remaining)} over budget'
                          : '${_formatAmount(remaining)} remaining',
                      textAlign: TextAlign.end,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isOverBudget
                            ? theme.colorScheme.error
                            : theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _amountColumn(
      BuildContext context,
      String label,
      String value,
      ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _formatAmount(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }
}
