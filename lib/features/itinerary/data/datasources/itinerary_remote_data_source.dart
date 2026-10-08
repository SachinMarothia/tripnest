import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/itinerary_model.dart';

abstract class ItineraryRemoteDataSource {
  Future<List<ItineraryModel>> getItineraryItems(
      String tripId,
      );

  Future<void> addItineraryItem(
      ItineraryModel item,
      );

  Future<void> updateItineraryItem(
      ItineraryModel item,
      );

  Future<void> deleteItineraryItem({
    required String tripId,
    required String itemId,
  });
}

class ItineraryRemoteDataSourceImpl
    implements ItineraryRemoteDataSource {
  final FirebaseFirestore firestore;

  ItineraryRemoteDataSourceImpl({
    required this.firestore,
  });

  CollectionReference<Map<String, dynamic>>
  _itineraryCollection(String tripId) {
    return firestore
        .collection('trips')
        .doc(tripId)
        .collection('itinerary');
  }

  @override
  Future<List<ItineraryModel>> getItineraryItems(
      String tripId,
      ) async {
    final snapshot = await _itineraryCollection(
      tripId,
    ).get();

    final items = snapshot.docs.map((doc) {
      return ItineraryModel.fromMap(
        doc.data(),
        doc.id,
      );
    }).toList();

    items.sort((a, b) {
      final dateComparison =
      a.date.compareTo(b.date);

      if (dateComparison != 0) {
        return dateComparison;
      }

      final aMinutes =
          (a.hour ?? 0) * 60 + (a.minute ?? 0);

      final bMinutes =
          (b.hour ?? 0) * 60 + (b.minute ?? 0);

      return aMinutes.compareTo(bMinutes);
    });

    return items;
  }

  @override
  Future<void> addItineraryItem(
      ItineraryModel item,
      ) async {
    await _itineraryCollection(
      item.tripId,
    ).add(
      item.toMap(),
    );
  }

  @override
  Future<void> updateItineraryItem(
      ItineraryModel item,
      ) async {
    if (item.id.isEmpty) {
      throw Exception(
        'Itinerary item ID is required for update.',
      );
    }

    await _itineraryCollection(
      item.tripId,
    ).doc(item.id).update(
      item.toMap(),
    );
  }

  @override
  Future<void> deleteItineraryItem({
    required String tripId,
    required String itemId,
  }) async {
    await _itineraryCollection(
      tripId,
    ).doc(itemId).delete();
  }
}