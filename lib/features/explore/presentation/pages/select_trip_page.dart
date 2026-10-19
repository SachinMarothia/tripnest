
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../../itinerary/presentation/bloc/itinerary_bloc.dart';
import '../../../itinerary/presentation/pages/add_itinerary_item_page.dart';
import '../../../trips/presentation/bloc/trips_bloc.dart';
import '../../../trips/presentation/bloc/trips_event.dart';
import '../../../trips/presentation/bloc/trips_state.dart';
import '../../domain/entities/place_entity.dart';

class SelectTripPage extends StatelessWidget {
  final PlaceEntity place;

  const SelectTripPage({
    super.key,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Select Trip')),
        body: const Center(
          child: Text('Please log in to view your trips.'),
        ),
      );
    }

    return BlocProvider(
      create: (_) => sl<TripsBloc>()
        ..add(TripsLoadRequested(userId: user.uid)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select Trip'),
        ),
        body: BlocBuilder<TripsBloc, TripsState>(
          builder: (context, state) {
            if (state is TripsLoading ||
                state is TripsInitial) {
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
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'No trips found. Create a trip first.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.trips.length,
                separatorBuilder: (_, _) =>
                const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final trip = state.trips[index];

                  return Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.luggage_outlined,
                      ),
                      title: Text(trip.destination),
                      subtitle: Text(
                        '${trip.startDate.day}/${trip.startDate.month}/${trip.startDate.year}'
                            ' - '
                            '${trip.endDate.day}/${trip.endDate.month}/${trip.endDate.year}',
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                      ),
                      onTap: () async {
                        final saved = await Navigator.of(context).push<bool>(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => sl<ItineraryBloc>(),
                              child: AddItineraryItemPage(
                                tripId: trip.id,
                                tripStartDate: trip.startDate,
                                tripEndDate: trip.endDate,
                                initialPlace: place,
                              ),
                            ),
                          ),
                        );

                        if (!context.mounted || saved != true) return;

                        Navigator.of(context).pop(true);
                      },
                    ),
                  );
                },
              );
            }

            return const Center(
              child: Text('Unable to display trips.'),
            );
          },
        ),
      ),
    );
  }
}
