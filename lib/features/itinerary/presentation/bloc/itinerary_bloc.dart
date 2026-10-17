import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/itinerary_entity.dart';
import '../../domain/usecases/add_itinerary_item.dart';
import '../../domain/usecases/delete_itinerary_item.dart';
import '../../domain/usecases/get_itinerary_items.dart';
import '../../domain/usecases/update_itinerary_item.dart';
import 'itinerary_event.dart';
import 'itinerary_state.dart';

class ItineraryBloc extends Bloc<ItineraryEvent, ItineraryState> {
  final GetItineraryItems getItineraryItems;
  final AddItineraryItem addItineraryItem;
  final UpdateItineraryItem updateItineraryItem;
  final DeleteItineraryItem deleteItineraryItem;
  List<ItineraryEntity> _cachedItems = [];
  List<ItineraryEntity> get cachedItems =>
      List.unmodifiable(_cachedItems);

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
    if (_cachedItems.isEmpty) {
      emit(const ItineraryLoading());
    }

    try {
      final items = await getItineraryItems(event.tripId);

      // Store the latest activities in memory
      _cachedItems = items;

      emit(ItineraryLoaded(items: items));
    } catch (e) {
      emit(ItineraryFailure(message: e.toString()));
    }
  }

  Future<void> _onAddRequested(
      ItineraryAddRequested event,
      Emitter<ItineraryState> emit,
      ) async {
    emit(const ItineraryLoading());

    try {
      debugPrint('ITINERARY: Starting save');

      await addItineraryItem(event.item).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw TimeoutException(
            'Saving is taking too long. Please check your connection.',
          );
        },
      );

      debugPrint('ITINERARY: Firestore save completed');

      emit(
        const ItineraryOperationSuccess(
          message: 'Itinerary item added successfully.',
        ),
      );

      debugPrint('ITINERARY: Success state emitted');

      add(ItineraryLoadRequested(tripId: event.item.tripId));
    } catch (e, stackTrace) {
      debugPrint('ITINERARY SAVE ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      emit(ItineraryFailure(message: e.toString()));
    }
  }

  Future<void> _onUpdateRequested(
    ItineraryUpdateRequested event,
    Emitter<ItineraryState> emit,
  ) async {
    try {
      await updateItineraryItem(event.item);

      emit(
        const ItineraryOperationSuccess(
          message: 'Itinerary item updated successfully.',
        ),
      );

      add(ItineraryLoadRequested(tripId: event.item.tripId));
    } catch (e) {
      emit(ItineraryFailure(message: e.toString()));
    }
  }

  Future<void> _onDeleteRequested(
    ItineraryDeleteRequested event,
    Emitter<ItineraryState> emit,
  ) async {
    emit(const ItineraryLoading());

    try {
      await deleteItineraryItem(tripId: event.tripId, itemId: event.itemId);

      emit(
        const ItineraryOperationSuccess(
          message: 'Itinerary item deleted successfully.',
        ),
      );

      add(ItineraryLoadRequested(tripId: event.tripId));
    } catch (e) {
      emit(ItineraryFailure(message: e.toString()));
    }
  }
}
