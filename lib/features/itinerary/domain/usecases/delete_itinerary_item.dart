import '../repositories/itinerary_repository.dart';

class DeleteItineraryItem {
  final ItineraryRepository repository;

  DeleteItineraryItem(this.repository);

  Future<void> call({
    required String tripId,
    required String itemId,
  }) async {
    await repository.deleteItineraryItem(
      tripId: tripId,
      itemId: itemId,
    );
  }
}