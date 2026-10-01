import '../../domain/entities/place_entity.dart';
import '../../domain/repositories/places_repository.dart';
import '../datasources/places_remote_data_source.dart';

class PlacesRepositoryImpl implements PlacesRepository {
  final PlacesRemoteDataSource remoteDataSource;

  PlacesRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<PlaceEntity>> searchPlaces(String query) async {
    return await remoteDataSource.searchPlaces(query);
  }

  @override
  Future<PlaceEntity> getPlaceDetails(String placeId) async {
    return await remoteDataSource.getPlaceDetails(placeId);
  }
}