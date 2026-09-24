import '../../domain/entities/trip_entity.dart';

abstract class TripsEvent {
  const TripsEvent();
}

class TripsLoadRequested extends TripsEvent {
  final String userId;

  const TripsLoadRequested({
    required this.userId,
  });
}

class TripCreateRequested extends TripsEvent {
  final TripEntity trip;

  const TripCreateRequested({
    required this.trip,
  });
}

class TripDetailsRequested extends TripsEvent {
  final String tripId;

  const TripDetailsRequested({
    required this.tripId,
  });
}

class TripUpdateRequested extends TripsEvent {
  final TripEntity trip;

  const TripUpdateRequested({
    required this.trip,
  });
}

class TripDeleteRequested extends TripsEvent {
  final String tripId;

  const TripDeleteRequested({
    required this.tripId,
  });
}