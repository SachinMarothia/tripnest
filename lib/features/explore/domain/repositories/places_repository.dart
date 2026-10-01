import '../entities/place_entity.dart';

abstract class PlacesRepository {
  Future<List<PlaceEntity>> searchPlaces(String query);

  Future<PlaceEntity> getPlaceDetails(String placeId);
}