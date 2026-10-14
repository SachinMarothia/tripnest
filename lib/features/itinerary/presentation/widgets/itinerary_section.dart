import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/itinerary_entity.dart';
import '../bloc/itinerary_bloc.dart';
import '../bloc/itinerary_event.dart';
import '../bloc/itinerary_state.dart';
import '../pages/add_itinerary_item_page.dart';
import 'itinerary_day_card.dart';

class ItinerarySection extends StatelessWidget {
  final String tripId;
  final String destination;
  final DateTime tripStartDate;
  final DateTime tripEndDate;

  const ItinerarySection({
    super.key,
    required this.destination,
    required this.tripStartDate,
    required this.tripEndDate,
    required this.tripId,
  });

  Map<DateTime, List<ItineraryEntity>> _groupByDate(
    List<ItineraryEntity> items,
  ) {
    final grouped = <DateTime, List<ItineraryEntity>>{};

    for (final item in items) {
      final date = DateTime(item.date.year, item.date.month, item.date.day);

      grouped.putIfAbsent(date, () => []).add(item);
    }

    final sortedDates = grouped.keys.toList()..sort();

    for (final activities in grouped.values) {
      activities.sort((a, b) {
        final aHasTime = a.hour != null && a.minute != null;
        final bHasTime = b.hour != null && b.minute != null;

        if (!aHasTime && !bHasTime) return 0;
        if (!aHasTime) return 1;
        if (!bHasTime) return -1;

        final aMinutes = a.hour! * 60 + a.minute!;
        final bMinutes = b.hour! * 60 + b.minute!;

        return aMinutes.compareTo(bMinutes);
      });
    }

    return {
      for (final date in sortedDates)
        date: grouped[date]!
          ..sort((a, b) {
            final aMinutes = (a.hour ?? 0) * 60 + (a.minute ?? 0);
            final bMinutes = (b.hour ?? 0) * 60 + (b.minute ?? 0);
            return aMinutes.compareTo(bMinutes);
          }),
    };
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Itinerary',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            FilledButton.icon(
              onPressed: () async {
                final itineraryBloc = context.read<ItineraryBloc>();

                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: itineraryBloc,
                      child: AddItineraryItemPage(
                        tripId: tripId,
                        tripStartDate: tripStartDate,
                        tripEndDate: tripEndDate,
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add'),
            ),
          ],
        ),

        const SizedBox(height: 16),

        BlocBuilder<ItineraryBloc, ItineraryState>(
          builder: (context, state) {
            if (state is ItineraryInitial || state is ItineraryLoading) {
              return const _ItineraryLoading();
            }

            if (state is ItineraryFailure) {
              return _ItineraryError(message: state.message);
            }

            if (state is ItineraryLoaded) {
              if (state.items.isEmpty) {
                return _EmptyItinerary(destination: destination);
              }

              final groupedActivities = _groupByDate(state.items);
              final days = groupedActivities.entries.toList();

              return Column(
                children: [
                  for (int index = 0; index < days.length; index++)
                    ItineraryDayCard(
                      date: days[index].key,
                      dayNumber:
                          DateTime.utc(
                                days[index].key.year,
                                days[index].key.month,
                                days[index].key.day,
                              )
                              .difference(
                                DateTime.utc(
                                  tripStartDate.year,
                                  tripStartDate.month,
                                  tripStartDate.day,
                                ),
                              )
                              .inDays +
                          1,
                      activities: days[index].value,
                      onEdit: (activity) {
                        _editActivity(
                          context,
                          activity,
                          tripStartDate,
                          tripEndDate,
                        );
                      },
                      onDelete: (activity) {
                        _deleteActivity(context, activity);
                      },
                    ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

class _ItineraryLoading extends StatelessWidget {
  const _ItineraryLoading();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 180,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _EmptyItinerary extends StatelessWidget {
  final String destination;

  const _EmptyItinerary({required this.destination});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.route_outlined,
              size: 32,
              color: colorScheme.primary,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Plan your $destination itinerary',
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 8),

          Text(
            'Start adding activities and places '
            'for each day of your trip.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ItineraryError extends StatelessWidget {
  final String message;

  const _ItineraryError({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: colorScheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _deleteActivity(
    BuildContext context,
    ItineraryEntity activity,
    ) async {
  final shouldDelete = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Delete Activity?'),
        content: Text(
          'Are you sure you want to delete '
              '"${activity.title}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(false);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(true);
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );

  if (shouldDelete != true || !context.mounted) {
    return;
  }

  context.read<ItineraryBloc>().add(
    ItineraryDeleteRequested(
      tripId: activity.tripId,
      itemId: activity.id,
    ),
  );
}

Future<void> _editActivity(
    BuildContext context,
    ItineraryEntity activity,
    DateTime startDate,
    DateTime endDate,
    ) async {
  final itineraryBloc = context.read<ItineraryBloc>();

  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => BlocProvider.value(
        value: itineraryBloc,
        child: AddItineraryItemPage(
          tripId: activity.tripId,
          tripStartDate: startDate,
          tripEndDate: endDate,
          activity: activity,
        ),
      ),
    ),
  );
}