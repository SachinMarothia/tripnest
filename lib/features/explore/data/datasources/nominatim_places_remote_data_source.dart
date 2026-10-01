import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/place_model.dart';
import 'places_remote_data_source.dart';

class NominatimPlacesRemoteDataSource
    implements PlacesRemoteDataSource {
  final http.Client client;

  NominatimPlacesRemoteDataSource({
    required this.client,
  });

  static const String _baseUrl =
      'https://nominatim.openstreetmap.org';

  @override
  Future<List<PlaceModel>> searchPlaces(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      return [];
    }

    final uri = Uri.parse(
      '$_baseUrl/search',
    ).replace(
      queryParameters: {
        'q': trimmedQuery,
        'format': 'jsonv2',
        'addressdetails': '1',
        'limit': '10',
      },
    );

    final response = await client.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'TripMate Flutter App',
      },
    );

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      final List<dynamic> json =
      jsonDecode(response.body);

      return json
          .map(
            (item) => PlaceModel.fromNominatimJson(
          item as Map<String, dynamic>,
        ),
      )
          .toList();
    }

    throw Exception(
      'Failed to search places. '
          'Status code: ${response.statusCode}',
    );
  }

  @override
  Future<PlaceModel> getPlaceDetails(String placeId) async {
    final parts = placeId.split('_');

    if (parts.length != 2) {
      throw Exception('Invalid place ID.');
    }

    final osmType = parts[0];
    final osmId = parts[1];

    final typePrefix = switch (osmType) {
      'node' => 'N',
      'way' => 'W',
      'relation' => 'R',
      _ => throw Exception('Unsupported OSM type.'),
    };

    final uri = Uri.parse(
      '$_baseUrl/lookup',
    ).replace(
      queryParameters: {
        'osm_ids': '$typePrefix$osmId',
        'format': 'jsonv2',
        'addressdetails': '1',
        'extratags': '1',
        'namedetails': '1',
      },
    );

    final response = await client.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'TripMate Flutter App',
      },
    );

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        'Failed to load place details. '
            'Status code: ${response.statusCode}',
      );
    }

    final List<dynamic> json =
    jsonDecode(response.body);

    if (json.isEmpty) {
      throw Exception('Place details not found.');
    }

    return PlaceModel.fromNominatimJson(
      json.first as Map<String, dynamic>,
    );
  }
}