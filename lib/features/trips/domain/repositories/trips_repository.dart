import '../entities/trip_entity.dart';

abstract class TripsRepository {
  Future<TripEntity> createTrip(TripEntity trip);

  Future<List<TripEntity>> getTrips(String userId);

  Future<TripEntity?> getTripById(String tripId);

  Future<TripEntity> updateTrip(TripEntity trip);

  Future<void> deleteTrip(String tripId);
}