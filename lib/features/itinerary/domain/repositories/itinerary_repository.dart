import '../entities/itinerary_entity.dart';

abstract class ItineraryRepository {
  Future<List<ItineraryEntity>> getItineraryItems(String tripId);

  Future<void> addItineraryItem(ItineraryEntity item);

  Future<void> updateItineraryItem(ItineraryEntity item);

  Future<void> deleteItineraryItem({
    required String tripId,
    required String itemId,
  });
}