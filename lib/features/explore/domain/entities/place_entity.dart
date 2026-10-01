class PlaceEntity {
  final String placeId;
  final String name;
  final String? address;
  final double latitude;
  final double longitude;
  final double? rating;
  final int? userRatingCount;
  final List<String> types;
  final String? photoReference;

  const PlaceEntity({
    required this.placeId,
    required this.name,
    this.address,
    required this.latitude,
    required this.longitude,
    this.rating,
    this.userRatingCount,
    this.types = const [],
    this.photoReference,
  });
}