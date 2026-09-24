import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/trips_bloc.dart';
import '../bloc/trips_event.dart';
import '../bloc/trips_state.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips'),
      ),
      body: BlocBuilder<TripsBloc, TripsState>(
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

          if (state is TripsLoaded) {
            if (state.trips.isEmpty) {
              return const Center(
                child: Text(
                  'No trips yet.',
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.trips.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final trip = state.trips[index];

                return Card(
                  child: ListTile(
                    onTap: () async {
                      final shouldRefresh = await context.pushNamed<bool>(
                        RouteNames.tripDetails,
                        pathParameters: {
                          'tripId': trip.id,
                        },
                      );

                      if (shouldRefresh == true && context.mounted) {
                        final authState = context.read<AuthBloc>().state;

                        if (authState is AuthAuthenticated) {
                          context.read<TripsBloc>().add(
                            TripsLoadRequested(
                              userId: authState.user.id,
                            ),
                          );
                        }
                      }
                    },
                    leading: const Icon(
                      Icons.flight_takeoff_rounded,
                    ),
                    title: Text(trip.title),
                    subtitle: Text(
                      '${trip.origin} → ${trip.destination}',
                    ),
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.pushNamed(
            RouteNames.createTrip,
            extra: context.read<TripsBloc>(),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Trip'),
      ),
    );
  }
}