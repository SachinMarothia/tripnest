import '../../domain/entities/itinerary_entity.dart';
import '../../domain/repositories/itinerary_repository.dart';
import '../datasources/itinerary_remote_data_source.dart';
import '../models/itinerary_model.dart';

class ItineraryRepositoryImpl
    implements ItineraryRepository {
  final ItineraryRemoteDataSource remoteDataSource;

  ItineraryRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<ItineraryEntity>> getItineraryItems(
      String tripId,
      ) async {
    return await remoteDataSource.getItineraryItems(
      tripId,
    );
  }

  @override
  Future<void> addItineraryItem(
      ItineraryEntity item,
      ) async {
    final model = ItineraryModel.fromEntity(item);

    await remoteDataSource.addItineraryItem(
      model,
    );
  }

  @override
  Future<void> updateItineraryItem(
      ItineraryEntity item,
      ) async {
    final model = ItineraryModel.fromEntity(item);

    await remoteDataSource.updateItineraryItem(
      model,
    );
  }

  @override
  Future<void> deleteItineraryItem({
    required String tripId,
    required String itemId,
  }) async {
    await remoteDataSource.deleteItineraryItem(
      tripId: tripId,
      itemId: itemId,
    );
  }
}