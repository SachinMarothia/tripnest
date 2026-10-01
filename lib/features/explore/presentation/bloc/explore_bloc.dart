import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_place_details.dart';
import '../../domain/usecases/search_places.dart';
import 'explore_event.dart';
import 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final SearchPlaces searchPlaces;
  final GetPlaceDetails getPlaceDetails;

  ExploreBloc({
    required this.searchPlaces,
    required this.getPlaceDetails,
  }) : super(const ExploreInitial()) {
    on<ExploreSearchRequested>(_onSearchRequested);
    on<ExplorePlaceDetailsRequested>(_onPlaceDetailsRequested);
    on<ExploreCleared>(_onCleared);
  }

  Future<void> _onSearchRequested(
      ExploreSearchRequested event,
      Emitter<ExploreState> emit,
      ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(const ExploreInitial());
      return;
    }

    emit(const ExploreLoading());

    try {
      final places = await searchPlaces(query);

      emit(ExplorePlacesLoaded(places));
    } catch (e) {
      emit(
        const ExploreFailure(
          'Unable to search places. Please try again.',
        ),
      );
    }
  }

  Future<void> _onPlaceDetailsRequested(
      ExplorePlaceDetailsRequested event,
      Emitter<ExploreState> emit,
      ) async {
    emit(const ExploreLoading());

    try {
      final place = await getPlaceDetails(event.placeId);

      emit(ExplorePlaceDetailsLoaded(place));
    } catch (e) {
      emit(
        const ExploreFailure(
          'Unable to load place details. Please try again.',
        ),
      );
    }
  }

  void _onCleared(
      ExploreCleared event,
      Emitter<ExploreState> emit,
      ) {
    emit(const ExploreInitial());
  }
}