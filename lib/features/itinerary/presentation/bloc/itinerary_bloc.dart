import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/add_itinerary_item.dart';
import '../../domain/usecases/delete_itinerary_item.dart';
import '../../domain/usecases/get_itinerary_items.dart';
import '../../domain/usecases/update_itinerary_item.dart';
import 'itinerary_event.dart';
import 'itinerary_state.dart';

class ItineraryBloc
    extends Bloc<ItineraryEvent, ItineraryState> {
  final GetItineraryItems getItineraryItems;
  final AddItineraryItem addItineraryItem;
  final UpdateItineraryItem updateItineraryItem;
  final DeleteItineraryItem deleteItineraryItem;

  ItineraryBloc({
    required this.getItineraryItems,
    required this.addItineraryItem,
    required this.updateItineraryItem,
    required this.deleteItineraryItem,
  }) : super(const ItineraryInitial()) {
    on<ItineraryLoadRequested>(_onLoadRequested);
    on<ItineraryAddRequested>(_onAddRequested);
    on<ItineraryUpdateRequested>(_onUpdateRequested);
    on<ItineraryDeleteRequested>(_onDeleteRequested);
  }

  Future<void> _onLoadRequested(
      ItineraryLoadRequested event,
      Emitter<ItineraryState> emit,
      ) async {
    emit(const ItineraryLoading());

    try {
      final items = await getItineraryItems(
        event.tripId,
      );

      emit(
        ItineraryLoaded(
          items: items,
        ),
      );
    } catch (e) {
      emit(
        ItineraryFailure(
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _onAddRequested(
      ItineraryAddRequested event,
      Emitter<ItineraryState> emit,
      ) async {
    emit(const ItineraryLoading());

    try {
      await addItineraryItem(event.item);

      emit(
        const ItineraryOperationSuccess(
          message: 'Itinerary item added successfully.',
        ),
      );

      add(
        ItineraryLoadRequested(
          tripId: event.item.tripId,
        ),
      );
    } catch (e) {
      emit(
        ItineraryFailure(
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUpdateRequested(
      ItineraryUpdateRequested event,
      Emitter<ItineraryState> emit,
      ) async {
    emit(const ItineraryLoading());

    try {
      await updateItineraryItem(event.item);

      emit(
        const ItineraryOperationSuccess(
          message: 'Itinerary item updated successfully.',
        ),
      );

      add(
        ItineraryLoadRequested(
          tripId: event.item.tripId,
        ),
      );
    } catch (e) {
      emit(
        ItineraryFailure(
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteRequested(
      ItineraryDeleteRequested event,
      Emitter<ItineraryState> emit,
      ) async {
    emit(const ItineraryLoading());

    try {
      await deleteItineraryItem(
        tripId: event.tripId,
        itemId: event.itemId,
      );

      emit(
        const ItineraryOperationSuccess(
          message: 'Itinerary item deleted successfully.',
        ),
      );

      add(
        ItineraryLoadRequested(
          tripId: event.tripId,
        ),
      );
    } catch (e) {
      emit(
        ItineraryFailure(
          message: e.toString(),
        ),
      );
    }
  }
}