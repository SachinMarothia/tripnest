import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/trip_entity.dart';

class TripModel extends TripEntity {
  const TripModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.origin,
    required super.destination,
    required super.startDate,
    required super.endDate,
    super.coverImageUrl,
    super.description,
    super.budget,
  });

  factory TripModel.fromMap(
      Map<String, dynamic> map,
      String id,
      ) {
    return TripModel(
      id: id,
      userId: map['userId'] as String,
      title: map['title'] as String,
      origin: map['origin'] as String,
      destination: map['destination'] as String,
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      coverImageUrl: map['coverImageUrl'] as String?,
      description: map['description'] as String?,
      budget: (map['budget'] as num?)?.toDouble(),
    );
  }

  factory TripModel.fromEntity(TripEntity trip) {
    return TripModel(
      id: trip.id,
      userId: trip.userId,
      title: trip.title,
      origin: trip.origin,
      destination: trip.destination,
      startDate: trip.startDate,
      endDate: trip.endDate,
      coverImageUrl: trip.coverImageUrl,
      description: trip.description,
      budget: trip.budget,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'origin': origin,
      'destination': destination,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'coverImageUrl': coverImageUrl,
      'description': description,
      'budget': budget,
    };
  }
}