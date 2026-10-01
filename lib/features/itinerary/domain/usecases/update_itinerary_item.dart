import '../entities/itinerary_entity.dart';
import '../repositories/itinerary_repository.dart';

class UpdateItineraryItem {
  final ItineraryRepository repository;

  UpdateItineraryItem(this.repository);

  Future<void> call(ItineraryEntity item) async {
    await repository.updateItineraryItem(item);
  }
}