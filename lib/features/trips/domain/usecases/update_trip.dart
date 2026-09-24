import '../entities/trip_entity.dart';
import '../repositories/trips_repository.dart';

class UpdateTrip {
  final TripsRepository repository;

  const UpdateTrip(this.repository);

  Future<TripEntity> call(TripEntity trip) {
    return repository.updateTrip(trip);
  }
}