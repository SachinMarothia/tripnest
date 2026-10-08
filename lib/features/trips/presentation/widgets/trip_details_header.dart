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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final duration =
        trip.endDate.difference(trip.startDate).inDays + 1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(
                alpha: 0.65,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'MY TRIP',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),

          const SizedBox(height: 18),

          Text(
            trip.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.onPrimaryContainer,
            ),
          ),

          const SizedBox(height: 22),

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.flight_rounded,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: 50,
                      height: 1,
                      color: colorScheme.primary.withValues(
                        alpha: 0.35,
                      ),
                    ),
                  ],
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

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  icon: Icons.calendar_month_outlined,
                  label: 'Duration',
                  value:
                  '$duration ${duration == 1 ? 'day' : 'days'}',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryItem(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Budget',
                  value: trip.budget == null
                      ? 'Not set'
                      : '₹${trip.budget!.toStringAsFixed(0)}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onPrimaryContainer.withValues(
              alpha: 0.65,
            ),
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          location,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: alignment == CrossAxisAlignment.end
              ? TextAlign.end
              : TextAlign.start,
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(
          alpha: 0.65,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 21,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}