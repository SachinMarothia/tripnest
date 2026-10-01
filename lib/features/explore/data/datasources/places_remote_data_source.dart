import '../models/place_model.dart';

abstract class PlacesRemoteDataSource {
  Future<List<PlaceModel>> searchPlaces(String query);

  Future<PlaceModel> getPlaceDetails(String placeId);
}