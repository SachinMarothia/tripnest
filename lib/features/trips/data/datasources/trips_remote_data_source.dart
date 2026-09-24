import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/trip_model.dart';

class TripsRemoteDataSource {
  final FirebaseFirestore firestore;

  const TripsRemoteDataSource({
    required this.firestore,
  });

  CollectionReference<Map<String, dynamic>> get _tripsCollection {
    return firestore.collection('trips');
  }

  Future<TripModel> createTrip(TripModel trip) async {
    final document = _tripsCollection.doc();

    await document.set(
      trip.toMap(),
    );

    return TripModel(
      id: document.id,
      userId: trip.userId,
      title: trip.title,
      origin: trip.origin,
      destination: trip.destination,
      startDate: trip.startDate,
      endDate: trip.endDate,
      coverImageUrl: trip.coverImageUrl,
      description: trip.description,
    );
  }

  Future<List<TripModel>> getTrips(String userId) async {
    final snapshot = await _tripsCollection
        .where(
      'userId',
      isEqualTo: userId,
    )
        .get();

    return snapshot.docs.map((document) {
      return TripModel.fromMap(
        document.data(),
        document.id,
      );
    }).toList();
  }

  Future<TripModel?> getTripById(String tripId) async {
    final document = await _tripsCollection.doc(tripId).get();

    if (!document.exists) {
      return null;
    }

    final data = document.data();

    if (data == null) {
      return null;
    }

    return TripModel.fromMap(
      data,
      document.id,
    );
  }

  Future<TripModel> updateTrip(TripModel trip) async {
    await _tripsCollection.doc(trip.id).update(
      trip.toMap(),
    );

    return trip;
  }

  Future<void> deleteTrip(String tripId) async {
    await _tripsCollection.doc(tripId).delete();
  }
}