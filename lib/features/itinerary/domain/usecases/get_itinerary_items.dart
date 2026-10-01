import '../entities/itinerary_entity.dart';
import '../repositories/itinerary_repository.dart';

class GetItineraryItems {
  final ItineraryRepository repository;

  GetItineraryItems(this.repository);

  Future<List<ItineraryEntity>> call(String tripId) async {
    return await repository.getItineraryItems(tripId);
  }
}