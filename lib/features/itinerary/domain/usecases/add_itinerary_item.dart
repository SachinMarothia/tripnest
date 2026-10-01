import '../entities/itinerary_entity.dart';
import '../repositories/itinerary_repository.dart';

class AddItineraryItem {
  final ItineraryRepository repository;

  AddItineraryItem(this.repository);

  Future<void> call(ItineraryEntity item) async {
    await repository.addItineraryItem(item);
  }
}