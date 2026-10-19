
import 'package:flutter/material.dart';

import '../../../trips/domain/entities/trip_entity.dart';

class HomeTripStats extends StatelessWidget {
  final List<TripEntity> trips;

  const HomeTripStats({
    super.key,
    required this.trips,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final upcoming = trips.where((trip) {
      final start = DateUtils.dateOnly(trip.startDate);
      return start.isAfter(today);
    }).length;

    final ongoing = trips.where((trip) {
      final start = DateUtils.dateOnly(trip.startDate);
      final end = DateUtils.dateOnly(trip.endDate);

      return !today.isBefore(start) && !today.isAfter(end);
    }).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Travel Overview',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Total Trips',
                value: trips.length,
                icon: Icons.luggage_outlined,
                color: colors.primary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                label: 'Upcoming',
                value: upcoming,
                icon: Icons.calendar_month_outlined,
                color: colors.primary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                label: 'Ongoing',
                value: ongoing,
                icon: Icons.location_on_outlined,
                color: colors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}


class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(height: 5),
          Text(
            value.toString().padLeft(2, '0'),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colors.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

