import '../../domain/entities/trip_entity.dart';

abstract class TripsState {
  const TripsState();
}

class TripsInitial extends TripsState {
  const TripsInitial();
}

class TripsLoading extends TripsState {
  const TripsLoading();
}

class TripsLoaded extends TripsState {
  final List<TripEntity> trips;

  const TripsLoaded({
    required this.trips,
  });
}

class TripDetailsLoaded extends TripsState {
  final TripEntity trip;

  const TripDetailsLoaded({
    required this.trip,
  });
}

class TripOperationSuccess extends TripsState {
  final String message;

  const TripOperationSuccess({
    required this.message,
  });
}

class TripsFailure extends TripsState {
  final String message;

  const TripsFailure({
    required this.message,
  });
}