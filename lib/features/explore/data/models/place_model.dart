import '../../domain/entities/place_entity.dart';

class PlaceModel extends PlaceEntity {
  const PlaceModel({
    required super.placeId,
    required super.name,
    super.address,
    required super.latitude,
    required super.longitude,
    super.rating,
    super.userRatingCount,
    super.types,
    super.photoReference,
  });

  /// Converts Nominatim / OpenStreetMap JSON
  /// into our application's PlaceModel.
  factory PlaceModel.fromNominatimJson(
      Map<String, dynamic> json,
      ) {
    final address =
    json['address'] as Map<String, dynamic>?;

    return PlaceModel(
      placeId: _createPlaceId(json),

      name: _extractPlaceName(
        json,
        address,
      ),

      address: json['display_name'] as String?,

      latitude: _parseDouble(
        json['lat'],
      ),

      longitude: _parseDouble(
        json['lon'],
      ),

      // Nominatim search does not provide the
      // Google-style rating information we used before.
      rating: null,

      userRatingCount: null,

      types: _extractTypes(json),

      // Nominatim does not provide a Google-style
      // photo reference.
      photoReference: null,
    );
  }

  static String _createPlaceId(
      Map<String, dynamic> json,
      ) {
    final osmType =
        json['osm_type']?.toString() ?? '';

    final osmId =
        json['osm_id']?.toString() ?? '';

    if (osmType.isNotEmpty && osmId.isNotEmpty) {
      return '${osmType}_$osmId';
    }

    return json['place_id']?.toString() ?? '';
  }

  static String _extractPlaceName(
      Map<String, dynamic> json,
      Map<String, dynamic>? address,
      ) {
    final name = json['name']?.toString();

    if (name != null && name.trim().isNotEmpty) {
      return name;
    }

    if (address != null) {
      final possibleNames = [
        address['attraction'],
        address['tourism'],
        address['city'],
        address['town'],
        address['village'],
        address['municipality'],
        address['state'],
      ];

      for (final value in possibleNames) {
        if (value != null &&
            value.toString().trim().isNotEmpty) {
          return value.toString();
        }
      }
    }

    final displayName =
    json['display_name']?.toString();

    if (displayName != null &&
        displayName.trim().isNotEmpty) {
      return displayName
          .split(',')
          .first
          .trim();
    }

    return 'Unknown place';
  }

  static double _parseDouble(
      dynamic value,
      ) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value?.toString() ?? '',
    ) ??
        0.0;
  }

  static List<String> _extractTypes(
      Map<String, dynamic> json,
      ) {
    final types = <String>[];

    final category =
    json['category']?.toString();

    final type =
    json['type']?.toString();

    if (category != null &&
        category.isNotEmpty) {
      types.add(category);
    }

    if (type != null &&
        type.isNotEmpty &&
        !types.contains(type)) {
      types.add(type);
    }

    return types;
  }
}