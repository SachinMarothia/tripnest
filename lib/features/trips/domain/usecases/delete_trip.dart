import '../repositories/trips_repository.dart';

class DeleteTrip {
  final TripsRepository repository;

  const DeleteTrip(this.repository);

  Future<void> call(String tripId) {
    return repository.deleteTrip(tripId);
  }
}