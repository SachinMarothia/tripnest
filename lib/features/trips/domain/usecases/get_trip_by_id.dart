import '../entities/trip_entity.dart';
import '../repositories/trips_repository.dart';

class GetTripById {
  final TripsRepository repository;

  const GetTripById(this.repository);

  Future<TripEntity?> call(String tripId) {
    return repository.getTripById(tripId);
  }
}