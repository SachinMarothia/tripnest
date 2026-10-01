import '../entities/place_entity.dart';
import '../repositories/places_repository.dart';

class GetPlaceDetails {
  final PlacesRepository repository;

  GetPlaceDetails(this.repository);

  Future<PlaceEntity> call(String placeId) async {
    return await repository.getPlaceDetails(placeId);
  }
}