import '../entities/trip_entity.dart';
import '../repositories/trips_repository.dart';

class GetTrips {
  final TripsRepository repository;

  const GetTrips(this.repository);

  Future<List<TripEntity>> call(String userId) {
    return repository.getTrips(userId);
  }
}