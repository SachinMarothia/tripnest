import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/itinerary_bloc.dart';
import '../bloc/itinerary_state.dart';

class ItinerarySection extends StatelessWidget {
  final String destination;

  const ItinerarySection({
    super.key,
    required this.destination,
  });

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
              onPressed: null,
              icon: const Icon(
                Icons.add_rounded,
              ),
              label: const Text(
                'Add',
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        BlocBuilder<ItineraryBloc, ItineraryState>(
          builder: (context, state) {
            if (state is ItineraryInitial ||
                state is ItineraryLoading) {
              return const _ItineraryLoading();
            }

            if (state is ItineraryFailure) {
              return _ItineraryError(
                message: state.message,
              );
            }

            if (state is ItineraryLoaded) {
              if (state.items.isEmpty) {
                return _EmptyItinerary(
                  destination: destination,
                );
              }

              return Column(
                children: state.items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 12,
                    ),
                    child: _TemporaryItineraryItem(
                      title: item.title,
                      location: item.location,
                    ),
                  );
                }).toList(),
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
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _EmptyItinerary extends StatelessWidget {
  final String destination;

  const _EmptyItinerary({
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 40,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
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
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
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

  const _ItineraryError({
    required this.message,
  });

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
              style: TextStyle(
                color: colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TemporaryItineraryItem extends StatelessWidget {
  final String title;
  final String? location;

  const _TemporaryItineraryItem({
    required this.title,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.place_outlined,
              color: colorScheme.primary,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (location != null &&
                    location!.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    location!,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}