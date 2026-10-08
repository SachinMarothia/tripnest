import '../../domain/entities/itinerary_entity.dart';

abstract class ItineraryState {
  const ItineraryState();
}

class ItineraryInitial extends ItineraryState {
  const ItineraryInitial();
}

class ItineraryLoading extends ItineraryState {
  const ItineraryLoading();
}

class ItineraryLoaded extends ItineraryState {
  final List<ItineraryEntity> items;

  const ItineraryLoaded({
    required this.items,
  });
}

class ItineraryOperationSuccess extends ItineraryState {
  final String message;

  const ItineraryOperationSuccess({
    required this.message,
  });
}

class ItineraryFailure extends ItineraryState {
  final String message;

  const ItineraryFailure({
    required this.message,
  });
}