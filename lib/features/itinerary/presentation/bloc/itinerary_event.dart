import '../../domain/entities/itinerary_entity.dart';

abstract class ItineraryEvent {
  const ItineraryEvent();
}

class ItineraryLoadRequested extends ItineraryEvent {
  final String tripId;

  const ItineraryLoadRequested({
    required this.tripId,
  });
}

class ItineraryAddRequested extends ItineraryEvent {
  final ItineraryEntity item;

  const ItineraryAddRequested({
    required this.item,
  });
}

class ItineraryUpdateRequested extends ItineraryEvent {
  final ItineraryEntity item;

  const ItineraryUpdateRequested({
    required this.item,
  });
}

class ItineraryDeleteRequested extends ItineraryEvent {
  final String tripId;
  final String itemId;

  const ItineraryDeleteRequested({
    required this.tripId,
    required this.itemId,
  });
}