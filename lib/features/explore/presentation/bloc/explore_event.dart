abstract class ExploreEvent {
  const ExploreEvent();
}

class ExploreSearchRequested extends ExploreEvent {
  final String query;

  const ExploreSearchRequested(this.query);
}

class ExplorePlaceDetailsRequested extends ExploreEvent {
  final String placeId;

  const ExplorePlaceDetailsRequested(this.placeId);
}

class ExploreCleared extends ExploreEvent {
  const ExploreCleared();
}