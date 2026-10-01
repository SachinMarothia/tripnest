class ItineraryEntity {
  final String id;
  final String tripId;
  final String title;
  final String? description;
  final DateTime date;
  final int? hour;
  final int? minute;
  final String? location;

  const ItineraryEntity({
    required this.id,
    required this.tripId,
    required this.title,
    this.description,
    required this.date,
    this.hour,
    this.minute,
    this.location,
  });
}