
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/trip_entity.dart';
import '../bloc/trips_bloc.dart';
import '../bloc/trips_event.dart';
import '../bloc/trips_state.dart';
import '../widgets/trip_card.dart';

enum _TripFilter {
  all,
  upcoming,
  ongoing,
  completed,
}

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  _TripFilter _selectedFilter = _TripFilter.all;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  void _loadTrips() {
    final authState = context.read<AuthBloc>().state;

    if (authState is AuthAuthenticated) {
      context.read<TripsBloc>().add(
        TripsLoadRequested(userId: authState.user.id),
      );
    }
  }

  List<TripEntity> _filterTrips(List<TripEntity> trips) {
    final today = DateUtils.dateOnly(DateTime.now());

    final filtered = trips.where((trip) {
      final start = DateUtils.dateOnly(trip.startDate);
      final end = DateUtils.dateOnly(trip.endDate);

      switch (_selectedFilter) {
        case _TripFilter.all:
          return true;
        case _TripFilter.upcoming:
          return start.isAfter(today);
        case _TripFilter.ongoing:
          return !today.isBefore(start) && !today.isAfter(end);
        case _TripFilter.completed:
          return end.isBefore(today);
      }
    }).toList();

    filtered.sort(
          (a, b) => a.startDate.compareTo(b.startDate),
    );

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<TripsBloc, TripsState>(
          builder: (context, state) {
            if (state is TripsInitial || state is TripsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is TripsFailure) {
              return _TripsMessage(
                icon: Icons.error_outline_rounded,
                title: 'Unable to load trips',
                description: state.message,
                buttonLabel: 'Try Again',
                onPressed: _loadTrips,
              );
            }

            if (state is TripsLoaded) {
              final filteredTrips = _filterTrips(state.trips);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      20, 18, 20, 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                'My Trips',
                                style: theme.textTheme.headlineSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Your journeys, all in one place',
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(
                              alpha: 0.10,
                            ),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Icon(
                            Icons.luggage_outlined,
                            color: colors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      20, 8, 20, 12,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Your journeys',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${state.trips.length} '
                              '${state.trips.length == 1 ? 'trip' : 'trips'}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 44,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      children: [
                        _buildFilterChip('All', _TripFilter.all),
                        _buildFilterChip(
                          'Upcoming',
                          _TripFilter.upcoming,
                        ),
                        _buildFilterChip(
                          'Ongoing',
                          _TripFilter.ongoing,
                        ),
                        _buildFilterChip(
                          'Completed',
                          _TripFilter.completed,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  Expanded(
                    child: filteredTrips.isEmpty
                        ? _TripsMessage(
                      icon: Icons.luggage_outlined,
                      title: state.trips.isEmpty
                          ? 'No trips yet'
                          : 'No ${_selectedFilter.name} trips',
                      description: state.trips.isEmpty
                          ? 'Your travel adventures will appear here.'
                          : 'Try another filter to see your trips.',
                    )
                        : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        20, 4, 20, 110,
                      ),
                      itemCount: filteredTrips.length,
                      separatorBuilder: (_, _) =>
                      const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final trip = filteredTrips[index];

                        return TripCard(
                          trip: trip,
                          onTap: () async {
                            final shouldRefresh =
                            await context.pushNamed<bool>(
                              RouteNames.tripDetails,
                              pathParameters: {
                                'tripId': trip.id,
                              },
                            );

                            if (shouldRefresh == true &&
                                context.mounted) {
                              _loadTrips();
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, _TripFilter filter) {
    final colors = Theme.of(context).colorScheme;
    final selected = _selectedFilter == filter;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) {
          setState(() {
            _selectedFilter = filter;
          });
        },
        showCheckmark: false,
        backgroundColor: colors.surface,
        selectedColor: colors.primary.withValues(alpha: 0.12),
        side: BorderSide(
          color: selected
              ? colors.primary
              : colors.outlineVariant.withValues(alpha: 0.6),
        ),
        labelStyle: TextStyle(
          color: selected ? colors.primary : colors.onSurfaceVariant,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

class _TripsMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? buttonLabel;
  final VoidCallback? onPressed;

  const _TripsMessage({
    required this.icon,
    required this.title,
    required this.description,
    this.buttonLabel,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                color: colors.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            if (buttonLabel != null && onPressed != null) ...[
              const SizedBox(height: 18),
              FilledButton(
                onPressed: onPressed,
                child: Text(buttonLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
