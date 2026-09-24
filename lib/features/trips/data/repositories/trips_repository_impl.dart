import '../../domain/entities/trip_entity.dart';
import '../../domain/repositories/trips_repository.dart';
import '../datasources/trips_remote_data_source.dart';
import '../models/trip_model.dart';

class TripsRepositoryImpl implements TripsRepository {
  final TripsRemoteDataSource remoteDataSource;

  const TripsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<TripEntity> createTrip(TripEntity trip) async {
    final tripModel = TripModel.fromEntity(trip);

    return await remoteDataSource.createTrip(tripModel);
  }

  @override
  Future<List<TripEntity>> getTrips(String userId) async {
    return await remoteDataSource.getTrips(userId);
  }

  @override
  Future<TripEntity?> getTripById(String tripId) async {
    return await remoteDataSource.getTripById(tripId);
  }

  @override
  Future<TripEntity> updateTrip(TripEntity trip) async {
    final tripModel = TripModel.fromEntity(trip);

    return await remoteDataSource.updateTrip(tripModel);
  }

  @override
  Future<void> deleteTrip(String tripId) async {
    await remoteDataSource.deleteTrip(tripId);
  }
}