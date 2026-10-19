
import 'package:flutter/material.dart';

import '../../domain/entities/trip_entity.dart';

class TripDetailsHeader extends StatelessWidget {
  final TripEntity trip;

  const TripDetailsHeader({
    super.key,
    required this.trip,
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
      statusColor = colors.tertiary;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status and trip label
          Row(
            children: [
              Icon(
                Icons.luggage_outlined,
                color: colors.onPrimaryContainer,
                size: 18,
              ),
              const SizedBox(width: 7),
              Text(
                'TRIP OVERVIEW',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colors.onPrimaryContainer,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: colors.surface.withValues(alpha: 0.80),
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

          const SizedBox(height: 13),

          // Trip title
          Text(
            trip.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colors.onPrimaryContainer,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 16),

          // Origin and destination
          Row(
            children: [
              Expanded(
                child: _LocationItem(
                  label: 'FROM',
                  location: trip.origin,
                  alignment: CrossAxisAlignment.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: colors.onPrimaryContainer,
                  size: 21,
                ),
              ),
              Expanded(
                child: _LocationItem(
                  label: 'TO',
                  location: trip.destination,
                  alignment: CrossAxisAlignment.end,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Divider(
            height: 1,
            color: colors.onPrimaryContainer.withValues(alpha: 0.15),
          ),

          const SizedBox(height: 13),

          // Dates
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 17,
                color: colors.onPrimaryContainer,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${_formatDate(trip.startDate)} - '
                      '${_formatDate(trip.endDate)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 11),

          // Duration and budget
          Row(
            children: [
              Icon(
                Icons.schedule_outlined,
                size: 17,
                color: colors.onPrimaryContainer,
              ),
              const SizedBox(width: 7),
              Text(
                '$duration ${duration == 1 ? 'day' : 'days'}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 17,
                color: colors.onPrimaryContainer,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  trip.budget == null
                      ? 'Budget not set'
                      : '₹${trip.budget!.toStringAsFixed(0)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onPrimaryContainer,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _LocationItem extends StatelessWidget {
  final String label;
  final String location;
  final CrossAxisAlignment alignment;

  const _LocationItem({
    required this.label,
    required this.location,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: colors.onPrimaryContainer.withValues(alpha: 0.7),
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          location,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: alignment == CrossAxisAlignment.end
              ? TextAlign.end
              : TextAlign.start,
          style: textTheme.titleMedium?.copyWith(
            color: colors.onPrimaryContainer,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
