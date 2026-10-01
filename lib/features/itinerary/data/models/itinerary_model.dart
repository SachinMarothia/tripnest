import '../../domain/entities/itinerary_entity.dart';

class ItineraryModel extends ItineraryEntity {
  const ItineraryModel({
    required super.id,
    required super.tripId,
    required super.title,
    super.description,
    required super.date,
    super.hour,
    super.minute,
    super.location,
  });

  factory ItineraryModel.fromMap(
      Map<String, dynamic> map,
      String documentId,
      ) {
    return ItineraryModel(
      id: documentId,
      tripId: map['tripId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String?,
      date: DateTime.parse(
        map['date'] as String,
      ),
      hour: map['hour'] as int?,
      minute: map['minute'] as int?,
      location: map['location'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tripId': tripId,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'hour': hour,
      'minute': minute,
      'location': location,
    };
  }

  factory ItineraryModel.fromEntity(
      ItineraryEntity entity,
      ) {
    return ItineraryModel(
      id: entity.id,
      tripId: entity.tripId,
      title: entity.title,
      description: entity.description,
      date: entity.date,
      hour: entity.hour,
      minute: entity.minute,
      location: entity.location,
    );
  }
}