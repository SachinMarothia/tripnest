import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/create_trip.dart';
import '../../domain/usecases/delete_trip.dart';
import '../../domain/usecases/get_trip.dart';
import '../../domain/usecases/get_trip_by_id.dart';
import '../../domain/usecases/update_trip.dart';
import 'trips_event.dart';
import 'trips_state.dart';

class TripsBloc extends Bloc<TripsEvent, TripsState> {
  final CreateTrip createTrip;
  final GetTrips getTrips;
  final GetTripById getTripById;
  final UpdateTrip updateTrip;
  final DeleteTrip deleteTrip;

  TripsBloc({
    required this.createTrip,
    required this.getTrips,
    required this.getTripById,
    required this.updateTrip,
    required this.deleteTrip,
  }) : super(const TripsInitial()) {
    on<TripsLoadRequested>(_onTripsLoadRequested);
    on<TripCreateRequested>(_onTripCreateRequested);
    on<TripDetailsRequested>(_onTripDetailsRequested);
    on<TripUpdateRequested>(_onTripUpdateRequested);
    on<TripDeleteRequested>(_onTripDeleteRequested);
  }

  Future<void> _onTripsLoadRequested(
      TripsLoadRequested event,
      Emitter<TripsState> emit,
      ) async {
    emit(const TripsLoading());

    try {
      final trips = await getTrips(event.userId);

      emit(
        TripsLoaded(
          trips: trips,
        ),
      );
    } catch (e) {
      emit(
        TripsFailure(
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _onTripCreateRequested(
      TripCreateRequested event,
      Emitter<TripsState> emit,
      ) async {
    emit(const TripsLoading());

    try {
      await createTrip(event.trip);

      emit(
        const TripOperationSuccess(
          message: 'Trip created successfully.',
        ),
      );
    } catch (e) {
      emit(
        TripsFailure(
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _onTripDetailsRequested(
      TripDetailsRequested event,
      Emitter<TripsState> emit,
      ) async {
    emit(const TripsLoading());

    try {
      final trip = await getTripById(event.tripId);

      if (trip == null) {
        emit(
          const TripsFailure(
            message: 'Trip not found.',
          ),
        );
        return;
      }

      emit(
        TripDetailsLoaded(
          trip: trip,
        ),
      );
    } catch (e) {
      emit(
        TripsFailure(
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _onTripUpdateRequested(
      TripUpdateRequested event,
      Emitter<TripsState> emit,
      ) async {
    emit(const TripsLoading());

    try {
      await updateTrip(event.trip);

      emit(
        const TripOperationSuccess(
          message: 'Trip updated successfully.',
        ),
      );
    } catch (e) {
      emit(
        TripsFailure(
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _onTripDeleteRequested(
      TripDeleteRequested event,
      Emitter<TripsState> emit,
      ) async {
    emit(const TripsLoading());

    try {
      await deleteTrip(event.tripId);

      emit(
        const TripOperationSuccess(
          message: 'Trip deleted successfully.',
        ),
      );
    } catch (e) {
      emit(
        TripsFailure(
          message: e.toString(),
        ),
      );
    }
  }
}