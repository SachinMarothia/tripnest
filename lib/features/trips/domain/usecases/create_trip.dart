import '../entities/trip_entity.dart';
import '../repositories/trips_repository.dart';

class CreateTrip {
  final TripsRepository repository;

  const CreateTrip(this.repository);

  Future<TripEntity> call(TripEntity trip) {
    return repository.createTrip(trip);
  }
}