
import 'package:flutter/material.dart';

import '../../domain/entities/trip_entity.dart';

class TripCard extends StatelessWidget {
  final TripEntity trip;
  final VoidCallback onTap;

  const TripCard({
    super.key,
    required this.trip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final start = DateUtils.dateOnly(trip.startDate);
    final end = DateUtils.dateOnly(trip.endDate);
    final today = DateUtils.dateOnly(DateTime.now());

    final duration = end.difference(start).inDays + 1;

    final String status;
    final Color statusColor;

    if (today.isAfter(end)) {
      status = 'Completed';
      statusColor = colors.onSurfaceVariant;
    } else if (today.isBefore(start)) {
      status = 'Upcoming';
      statusColor = colors.primary;
    } else {
      status = 'Ongoing';
      statusColor = Colors.orange;
    }

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: colors.outlineVariant.withValues(
                alpha: 0.55,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trip title and status
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(
                        alpha: 0.10,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.luggage_outlined,
                      color: colors.primary,
                      size: 21,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      trip.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),

                  const SizedBox(width: 6),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Route
              Row(
                children: [
                  Icon(
                    Icons.route_rounded,
                    size: 19,
                    color: colors.primary,
                  ),

                  const SizedBox(width: 9),

                  Expanded(
                    child: Text(
                      '${trip.origin}  →  ${trip.destination}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  Icon(
                    Icons.chevron_right_rounded,
                    size: 21,
                    color: colors.onSurfaceVariant,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Divider(
                height: 1,
                color: colors.outlineVariant.withValues(
                  alpha: 0.45,
                ),
              ),

              const SizedBox(height: 12),

              // Date, duration and budget
              Row(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    size: 16,
                    color: colors.onSurfaceVariant,
                  ),

                  const SizedBox(width: 5),

                  Flexible(
                    child: Text(
                      '${_formatDate(trip.startDate)} - '
                          '${_formatDate(trip.endDate)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    '• $duration ${duration == 1 ? 'day' : 'days'}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),

                  if (trip.budget != null) ...[
                    const Spacer(),

                    Text(
                      '₹${_formatBudget(trip.budget!)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return '${date.day} ${months[date.month - 1]}';
  }

  static String _formatBudget(double value) {
    if (value >= 100000) {
      final amount = value / 100000;
      return '${amount.toStringAsFixed(
        value % 100000 == 0 ? 0 : 1,
      )}L';
    }

    if (value >= 1000) {
      final amount = value / 1000;
      return '${amount.toStringAsFixed(
        value % 1000 == 0 ? 0 : 1,
      )}K';
    }

    return value.toStringAsFixed(0);
  }
}
