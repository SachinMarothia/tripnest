import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../itinerary/presentation/bloc/itinerary_bloc.dart';
import '../../../itinerary/presentation/bloc/itinerary_event.dart';
import '../../../itinerary/presentation/widgets/itinerary_section.dart';
import '../../domain/entities/trip_entity.dart';
import '../bloc/trips_bloc.dart';
import '../bloc/trips_event.dart';
import '../bloc/trips_state.dart';
import '../widgets/trip_details_header.dart';
import '../widgets/trip_details_tabs.dart';
import '../widgets/trip_overview_card.dart';

class TripDetailsPage extends StatefulWidget {
  final String tripId;

  const TripDetailsPage({super.key, required this.tripId});

  @override
  State<TripDetailsPage> createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends State<TripDetailsPage> {
  bool _tripWasUpdated = false;
  bool _allowPop = false;

  TripDetailsTab _selectedTab = TripDetailsTab.overview;

  @override
  void initState() {
    super.initState();

    context.read<TripsBloc>().add(TripDetailsRequested(tripId: widget.tripId));

    context.read<ItineraryBloc>().add(
      ItineraryLoadRequested(tripId: widget.tripId),
    );
  }



  void _goBack() {
    if (!mounted || _allowPop) return;

    setState(() {
      _allowPop = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.pop(_tripWasUpdated);
      }
    });
  }




  Future<void> _showDeleteConfirmation() async {
    final colors = Theme.of(context).colorScheme;

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.delete_outline_rounded,
                color: colors.error,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text('Delete Trip?'),
              ),
            ],
          ),
          content: const Text(
            'This trip will be permanently deleted. '
                'This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colors.error,
                foregroundColor: colors.onError,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Delete Trip'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) return;

    context.read<TripsBloc>().add(
      TripDeleteRequested(tripId: widget.tripId),
    );
  }


  Future<void> _editTrip(dynamic trip) async {
    final wasUpdated = await context.pushNamed<bool>(
      RouteNames.editTrip,
      pathParameters: {'tripId': trip.id},
      extra: trip,
    );

    if (wasUpdated == true && mounted) {
      _tripWasUpdated = true;

      context.read<TripsBloc>().add(TripDetailsRequested(tripId: trip.id));
    }
  }

  @override
  Widget build(BuildContext context) {



    return PopScope(
      canPop: _allowPop,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _goBack();
        }
      },
      child: Scaffold(



      appBar: AppBar(
          title: const Text('Trip Details'),

        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _goBack,
        ),

        actions: [

            IconButton(
              onPressed: _showDeleteConfirmation,
              tooltip: 'Delete trip',
              icon: Icon(
                Icons.delete_outline_rounded,
                color: Theme.of(context).colorScheme.error,
              ),
            ),

          ],
        ),
        body: BlocConsumer<TripsBloc, TripsState>(
          listener: (context, state) {

            if (state is TripOperationSuccess) {
              _tripWasUpdated = true;
              _goBack();
            }


            if (state is TripsFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is TripsInitial || state is TripsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TripsFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(state.message, textAlign: TextAlign.center),
                ),
              );
            }

            if (state is TripDetailsLoaded) {
              final trip = state.trip;

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TripDetailsHeader(trip: trip),

                    const SizedBox(height: 20),

                    TripDetailsTabs(
                      selectedTab: _selectedTab,
                      onChanged: (tab) {
                        setState(() {
                          _selectedTab = tab;
                        });
                      },
                    ),

                    const SizedBox(height: 18),

                    if (_selectedTab == TripDetailsTab.overview) ...[
                      _buildOverview(context, trip),
                    ] else ...[
                      ItinerarySection(
                        tripId: trip.id,
                        destination: trip.destination,
                        tripStartDate: trip.startDate,
                        tripEndDate: trip.endDate,
                      ),
                    ],
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _openExpenses(TripEntity trip) {
    context.pushNamed(
      RouteNames.expenses,
      pathParameters: {'tripId': trip.id},
      extra: trip.budget,
    );
  }

  Widget _buildOverview(BuildContext context, TripEntity trip) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        TripOverviewCard(trip: trip),

        const SizedBox(height: 14),

        Material(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: () => _openExpenses(trip),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outlineVariant
                      .withValues(alpha: 0.55),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Expense Tracker',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Manage your trip expenses',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),


        const SizedBox(height: 14),


        SizedBox(
          width: double.infinity,
          height: 46,
          child: OutlinedButton.icon(
            onPressed: () => _editTrip(trip),
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text(
              'Edit Trip',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              side: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .outlineVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }
}