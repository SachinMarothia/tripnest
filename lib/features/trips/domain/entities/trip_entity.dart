class TripEntity {
  final String id;
  final String userId;
  final String title;

  final String origin;
  final String destination;

  final DateTime startDate;
  final DateTime endDate;

  final String? coverImageUrl;
  final String? description;
  final double? budget;

  const TripEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.origin,
    required this.destination,
    required this.startDate,
    required this.endDate,
    this.coverImageUrl,
    this.description,
    this.budget,
  });
}