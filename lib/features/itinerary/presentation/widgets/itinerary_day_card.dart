import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/itinerary_entity.dart';
import '../bloc/itinerary_bloc.dart';
import '../bloc/itinerary_event.dart';

class ItineraryDayCard extends StatelessWidget {
  final DateTime date;
  final int dayNumber;
  final List<ItineraryEntity> activities;
  final ValueChanged<ItineraryEntity> onEdit;
  final ValueChanged<ItineraryEntity> onDelete;

  const ItineraryDayCard({
    super.key,
    required this.date,
    required this.dayNumber,
    required this.activities,
    required this.onEdit,
    required this.onDelete,
  });

  void _toggleActivityCompletion(
      BuildContext context,
      ItineraryEntity activity,
      ) {
    final updatedActivity = ItineraryEntity(
      id: activity.id,
      tripId: activity.tripId,
      title: activity.title,
      description: activity.description,
      date: activity.date,
      hour: activity.hour,
      minute: activity.minute,
      location: activity.location,
      latitude: activity.latitude,
      longitude: activity.longitude,
      isCompleted: !activity.isCompleted,
    );

    context.read<ItineraryBloc>().add(
      ItineraryUpdateRequested(item: updatedActivity),
    );
  }



  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatTime(BuildContext context, ItineraryEntity item) {
    if (item.hour == null || item.minute == null) {
      return 'Time not set';
    }

    return TimeOfDay(hour: item.hour!, minute: item.minute!).format(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final totalActivities = activities.length;

    final completedActivities = activities
        .where((activity) => activity.isCompleted)
        .length;

    final progress = totalActivities == 0
        ? 0.0
        : completedActivities / totalActivities;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'DAY $dayNumber',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _formatDate(date),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        if (totalActivities > 0) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Progress',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$completedActivities of $totalActivities completed',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            borderRadius: BorderRadius.circular(8),
            backgroundColor: colorScheme.surfaceContainerHighest,
            color: colorScheme.primary,
          ),

          const SizedBox(height: 16),
        ],

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            children: [
              for (int i = 0; i < activities.length; i++)
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _TimelineIndicator(isLast: i == activities.length - 1),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _ActivityTile(
                            activity: activities[i],
                            time: _formatTime(context, activities[i]),
                            onEdit: () => onEdit(activities[i]),
                            onDelete: () => onDelete(activities[i]),
                            onToggleCompletion: () =>
                                _toggleActivityCompletion(context, activities[i]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final ItineraryEntity activity;
  final String time;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleCompletion;

  const _ActivityTile({
    required this.activity,
    required this.time,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleCompletion,
  });

  Future<void> _openLocation(ItineraryEntity activity) async {
    final double? latitude = activity.latitude;
    final double? longitude = activity.longitude;

    Uri mapUri;

    if (latitude != null && longitude != null) {
      mapUri = Uri.https(
        'www.google.com',
        '/maps/search/',
        {
          'api': '1',
          'query': '$latitude,$longitude',
        },
      );
    } else {
      final location = activity.location?.trim();

      if (location == null || location.isEmpty) {
        return;
      }

      mapUri = Uri.https(
        'www.google.com',
        '/maps/search/',
        {
          'api': '1',
          'query': location,
        },
      );
    }

    if (!await launchUrl(
      mapUri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not open location');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(Icons.place_outlined, color: colorScheme.primary),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: activity.isCompleted,
                    onChanged: (_) => onToggleCompletion(),
                    visualDensity: VisualDensity.compact,
                  ),

                  const SizedBox(width: 4),

                  Expanded(
                    child: Text(
                      activity.title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        decoration: activity.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: activity.isCompleted
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Activity Time
              Row(
                children: [
                  Icon(
                    Icons.access_time_outlined,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    time,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              // Clickable Activity Location
              if (activity.location != null &&
                  activity.location!.trim().isNotEmpty) ...[
                const SizedBox(height: 6),

                InkWell(
                  onTap: () => _openLocation(activity),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: colorScheme.primary,
                        ),

                        const SizedBox(width: 6),

                        Expanded(
                          child: Text(
                            activity.location!,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),

                        const SizedBox(width: 6),

                        Icon(
                          Icons.open_in_new_rounded,
                          size: 14,
                          color: colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              // Activity Description
              if (activity.description != null &&
                  activity.description!.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(activity.description!, style: textTheme.bodyMedium),
              ],
            ],
          ),
        ),

        // Edit / Delete Activity Menu
        PopupMenuButton<String>(
          tooltip: 'Activity options',
          icon: const Icon(Icons.more_vert_rounded),
          onSelected: (value) {
            if (value == 'edit') {
              onEdit();
            } else if (value == 'delete') {
              onDelete();
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined),
                  SizedBox(width: 12),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline),
                  SizedBox(width: 12),
                  Text('Delete'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TimelineIndicator extends StatelessWidget {
  final bool isLast;

  const _TimelineIndicator({required this.isLast});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return SizedBox(
      width: 24,
      child: Column(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.2), width: 3),
            ),
          ),
          if (!isLast)
            Expanded(
              child: Container(width: 2, color: color.withValues(alpha: 0.25)),
            ),
        ],
      ),
    );
  }
}
