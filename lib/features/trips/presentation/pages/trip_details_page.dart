import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../bloc/trips_bloc.dart';
import '../bloc/trips_event.dart';
import '../bloc/trips_state.dart';

class TripDetailsPage extends StatefulWidget {
  final String tripId;

  const TripDetailsPage({
    super.key,
    required this.tripId,
  });

  @override
  State<TripDetailsPage> createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends State<TripDetailsPage> {
  @override
  void initState() {
    super.initState();

    context.read<TripsBloc>().add(
      TripDetailsRequested(
        tripId: widget.tripId,
      ),
    );
  }

  Future<void> _showDeleteConfirmation() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Trip?'),
          content: const Text(
            'This trip will be permanently deleted. This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) {
      return;
    }

    context.read<TripsBloc>().add(
      TripDeleteRequested(
        tripId: widget.tripId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Details'),
        actions: [
          IconButton(
            onPressed: _showDeleteConfirmation,
            tooltip: 'Delete trip',
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: BlocConsumer<TripsBloc, TripsState>(
        listener: (context, state) {
          if (state is TripOperationSuccess) {
            Navigator.of(context).pop(true);
          }


          if (state is TripsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }

        },
        builder: (context, state) {
          if (state is TripsInitial || state is TripsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is TripsFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (state is TripDetailsLoaded) {
            final trip = state.trip;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  const SizedBox(height: 24),

                  _DetailRow(
                    icon: Icons.trip_origin_rounded,
                    label: 'From',
                    value: trip.origin,
                  ),

                  const SizedBox(height: 16),

                  _DetailRow(
                    icon: Icons.location_on_outlined,
                    label: 'To',
                    value: trip.destination,
                  ),

                  const SizedBox(height: 16),

                  _DetailRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Start Date',
                    value: _formatDate(trip.startDate),
                  ),

                  const SizedBox(height: 16),

                  _DetailRow(
                    icon: Icons.event_outlined,
                    label: 'End Date',
                    value: _formatDate(trip.endDate),
                  ),

                  if (trip.description != null &&
                      trip.description!.isNotEmpty) ...[
                    const SizedBox(height: 24),

                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      trip.description!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final wasUpdated = await context.pushNamed<bool>(
                            RouteNames.editTrip,
                            pathParameters: {
                              'tripId': trip.id,
                            },
                            extra: trip,
                          );

                          if (wasUpdated == true && context.mounted) {
                            context.read<TripsBloc>().add(
                              TripDetailsRequested(
                                tripId: trip.id,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Edit Trip'),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge,
              ),

              const SizedBox(height: 4),

              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}