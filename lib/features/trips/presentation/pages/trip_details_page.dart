import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../itinerary/presentation/bloc/itinerary_bloc.dart';
import '../../../itinerary/presentation/bloc/itinerary_event.dart';
import '../../../itinerary/presentation/widgets/itinerary_section.dart';
import '../bloc/trips_bloc.dart';
import '../bloc/trips_event.dart';
import '../bloc/trips_state.dart';
import '../widgets/trip_details_header.dart';
import '../widgets/trip_details_tabs.dart';
import '../widgets/trip_overview_card.dart';

class TripDetailsPage extends StatefulWidget {
  final String tripId;

  const TripDetailsPage({
    super.key,
    required this.tripId,
  });

  @override
  State<TripDetailsPage> createState() =>
      _TripDetailsPageState();
}

class _TripDetailsPageState
    extends State<TripDetailsPage> {
  bool _tripWasUpdated = false;

  TripDetailsTab _selectedTab =
      TripDetailsTab.overview;

  @override
  void initState() {
    super.initState();

    context.read<TripsBloc>().add(
      TripDetailsRequested(
        tripId: widget.tripId,
      ),
    );

    context.read<ItineraryBloc>().add(
      ItineraryLoadRequested(
        tripId: widget.tripId,
      ),
    );
  }

  Future<void> _showDeleteConfirmation() async {
    final shouldDelete =
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Trip?',
          ),
          content: const Text(
            'This trip will be permanently deleted. '
                'This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(false);
              },
              child: const Text(
                'Cancel',
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(true);
              },
              child: const Text(
                'Delete',
              ),
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

  Future<void> _editTrip(
      dynamic trip,
      ) async {
    final wasUpdated =
    await context.pushNamed<bool>(
      RouteNames.editTrip,
      pathParameters: {
        'tripId': trip.id,
      },
      extra: trip,
    );

    if (wasUpdated == true &&
        mounted) {
      _tripWasUpdated = true;

      context.read<TripsBloc>().add(
        TripDetailsRequested(
          tripId: trip.id,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (
          didPop,
          result,
          ) {
        if (didPop) return;

        Navigator.of(context).pop(
          _tripWasUpdated,
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Trip Details',
          ),
          actions: [
            IconButton(
              onPressed:
              _showDeleteConfirmation,
              tooltip: 'Delete trip',
              icon: const Icon(
                Icons.delete_outline,
              ),
            ),
          ],
        ),
        body:
        BlocConsumer<TripsBloc, TripsState>(
          listener: (context, state) {
            if (state
            is TripOperationSuccess) {
              Navigator.of(context).pop(
                true,
              );
            }

            if (state is TripsFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is TripsInitial ||
                state is TripsLoading) {
              return const Center(
                child:
                CircularProgressIndicator(),
              );
            }

            if (state is TripsFailure) {
              return Center(
                child: Padding(
                  padding:
                  const EdgeInsets.all(
                    24,
                  ),
                  child: Text(
                    state.message,
                    textAlign:
                    TextAlign.center,
                  ),
                ),
              );
            }

            if (state
            is TripDetailsLoaded) {
              final trip = state.trip;

              return SingleChildScrollView(
                padding:
                const EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  32,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    TripDetailsHeader(
                      trip: trip,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    TripDetailsTabs(
                      selectedTab:
                      _selectedTab,
                      onChanged: (tab) {
                        setState(() {
                          _selectedTab =
                              tab;
                        });
                      },
                    ),

                    const SizedBox(
                      height: 28,
                    ),

                    if (_selectedTab ==
                        TripDetailsTab
                            .overview) ...[
                      _buildOverview(
                        context,
                        trip,
                      ),
                    ] else ...[
                      ItinerarySection(
                        destination: trip.destination,
                      ),
                    ],
                  ],
                ),
              );
            }

            return const SizedBox
                .shrink();
          },
        ),
      ),
    );
  }

  Widget _buildOverview(
      BuildContext context,
      dynamic trip,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          'Trip Overview',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(
            fontWeight:
            FontWeight.w700,
          ),
        ),

        const SizedBox(
          height: 16,
        ),

        TripOverviewCard(
          trip: trip,
        ),

        const SizedBox(
          height: 24,
        ),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              _editTrip(trip);
            },
            icon: const Icon(
              Icons.edit_outlined,
            ),
            label: const Text(
              'Edit Trip',
            ),
          ),
        ),
      ],
    );
  }
}

class _ItineraryPlaceholder
    extends StatelessWidget {
  final String destination;

  const _ItineraryPlaceholder({
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;

    final textTheme =
        Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          'Itinerary',
          style:
          textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(
          height: 16,
        ),

        Container(
          width: double.infinity,
          padding:
          const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 40,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius:
            BorderRadius.circular(24),
            border: Border.all(
              color:
              colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: colorScheme
                      .primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.route_outlined,
                  size: 32,
                  color:
                  colorScheme.primary,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Text(
                'Plan your $destination itinerary',
                textAlign:
                TextAlign.center,
                style: textTheme
                    .titleMedium
                    ?.copyWith(
                  fontWeight:
                  FontWeight.w700,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              Text(
                'Add activities, places and plans '
                    'for each day of your trip.',
                textAlign:
                TextAlign.center,
                style: textTheme
                    .bodyMedium
                    ?.copyWith(
                  color: colorScheme
                      .onSurfaceVariant,
                  height: 1.4,
                ),
              ),

              const SizedBox(
                height: 22,
              ),

              FilledButton.icon(
                onPressed: null,
                icon: const Icon(
                  Icons.add_rounded,
                ),
                label: const Text(
                  'Add Activity',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}