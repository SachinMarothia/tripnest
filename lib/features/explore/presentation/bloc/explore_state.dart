import '../../domain/entities/place_entity.dart';

abstract class ExploreState {
  const ExploreState();
}

class ExploreInitial extends ExploreState {
  const ExploreInitial();
}

class ExploreLoading extends ExploreState {
  const ExploreLoading();
}

class ExplorePlacesLoaded extends ExploreState {
  final List<PlaceEntity> places;

  const ExplorePlacesLoaded(this.places);
}

class ExplorePlaceDetailsLoaded extends ExploreState {
  final PlaceEntity place;

  const ExplorePlaceDetailsLoaded(this.place);
}

class ExploreFailure extends ExploreState {
  final String message;

  const ExploreFailure(this.message);
}