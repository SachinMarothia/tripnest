import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

import '../../../explore/data/datasources/local_destination_data.dart';
import '../../../explore/presentation/pages/destination_details_page.dart';
import '../../../trips/domain/entities/trip_entity.dart';
import '../../../trips/presentation/bloc/trips_bloc.dart';
import '../../../trips/presentation/bloc/trips_event.dart';
import '../../../trips/presentation/bloc/trips_state.dart';

import '../widgets/explore_destinations_section.dart';
import '../widgets/home_categories.dart';
import '../widgets/home_header.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/home_trip_stats.dart';
import '../widgets/upcoming_trip_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentTripIndex = 0;

  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthBloc>().state;

    if (authState is AuthAuthenticated) {
      context.read<TripsBloc>().add(
        TripsLoadRequested(
          userId: authState.user.id,
        ),
      );
    }
  }

  List<TripEntity> _getUpcomingTrips(
      List<TripEntity> trips,
      ) {
    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final upcomingTrips = trips.where((trip) {
      final endDate = DateTime(
        trip.endDate.year,
        trip.endDate.month,
        trip.endDate.day,
      );

      return !endDate.isBefore(today);
    }).toList();

    upcomingTrips.sort(
          (a, b) => a.startDate.compareTo(b.startDate),
    );

    return upcomingTrips;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(
                onProfileTap: () {
                  context.goNamed(RouteNames.profile);
                },
              ),

              const SizedBox(height: 14),

              HomeSearchBar(
                onTap: () {
                  context.goNamed(
                    RouteNames.explore,
                  );
                },
              ),

              const SizedBox(height: 12),

              HomeCategories(
                onCategorySelected: (category) {
                  context.goNamed(
                    RouteNames.explore,
                    queryParameters: {
                      'category': category,
                    },
                  );
                },
              ),
              const SizedBox(height: 18),

              BlocBuilder<TripsBloc, TripsState>(
                builder: (context, state) {
                  if (state is TripsLoaded) {
                    return HomeTripStats(trips: state.trips);
                  }

                  if (state is TripsLoading) {
                    return const SizedBox(
                      height: 120,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),

              const SizedBox(height: 22),
              Row(
                children: [
                  Text(
                    'Upcoming Trips',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      context.goNamed(
                        RouteNames.trips,
                      );
                    },
                    child: const Text('See All'),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              BlocBuilder<TripsBloc, TripsState>(
                builder: (context, state) {
                  if (state is TripsLoading) {
                    return const SizedBox(
                      height: 260,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (state is TripsFailure) {
                    return const _HomeTripMessage(
                      icon: Icons.error_outline_rounded,
                      message:
                      'Unable to load your upcoming trips.',
                    );
                  }

                  if (state is TripsLoaded) {
                    final upcomingTrips =
                    _getUpcomingTrips(state.trips);

                    if (upcomingTrips.isEmpty) {
                      return const _HomeTripMessage(
                        icon: Icons.luggage_outlined,
                        message: 'No upcoming trips yet.',
                      );
                    }

                    return Column(
                      children: [
                        SizedBox(
                          height: 220,
                          child: PageView.builder(
                            itemCount: upcomingTrips.length,
                            onPageChanged: (index) {
                              setState(() {
                                _currentTripIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              final trip =
                              upcomingTrips[index];

                              return Padding(
                                padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 2,
                                  vertical: 4,
                                ),
                                child: UpcomingTripCard(
                                  trip: trip,
                                  onTap: () {
                                    context.pushNamed(
                                      RouteNames.tripDetails,
                                      pathParameters: {
                                        'tripId': trip.id,
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),

                        if (upcomingTrips.length > 1) ...[
                          const SizedBox(height: 12),

                          _TripPageIndicator(
                            itemCount: upcomingTrips.length,
                            currentIndex: _currentTripIndex.clamp(
                              0,
                              upcomingTrips.length - 1,
                            ),
                          ),
                        ],
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 20),


              ExploreDestinationsSection(
                onSeeAllTap: () {
                  context.goNamed(RouteNames.explore);
                },
                onDestinationTap: (destinationName) {
                  for (final destination
                  in LocalDestinationData.destinations) {
                    if (destination.name.toLowerCase() ==
                        destinationName.toLowerCase()) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => DestinationDetailsPage(
                            destination: destination,
                          ),
                        ),
                      );
                      return;
                    }
                  }

                  // Fallback if the destination is not in curated data.
                  context.goNamed(RouteNames.explore);
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class _TripPageIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;

  const _TripPageIndicator({
    required this.itemCount,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
            (index) {
          final isSelected = index == currentIndex;

          return AnimatedContainer(
            duration: const Duration(
              milliseconds: 250,
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 3,
            ),
            width: isSelected ? 22 : 7,
            height: 7,
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }
}

class _HomeTripMessage extends StatelessWidget {
  final IconData icon;
  final String message;

  const _HomeTripMessage({
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 32,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}