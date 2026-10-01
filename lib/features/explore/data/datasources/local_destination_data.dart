import '../models/destination_model.dart';

abstract final class LocalDestinationData {
  LocalDestinationData._();

  static const List<DestinationModel> destinations = [
    DestinationModel(
      name: 'Goa',
      state: 'Goa',
      category: 'Beaches',
      description: 'Beaches, nightlife and coastal escapes',
      imagePath: 'assets/images/destinations/goa.png',
      overview:
      'Goa is known for its beautiful coastline, vibrant culture, '
          'historic architecture, local food and relaxed atmosphere. '
          'It offers a mix of beaches, sightseeing, entertainment and '
          'peaceful coastal experiences.',
      bestTimeToVisit: 'Nov - Feb',
      recommendedDays: '3 - 5 Days',
      highlights: [
        'Baga Beach',
        'Palolem Beach',
        'Old Goa',
        'Panaji',
        'Water Sports',
      ],
    ),

    DestinationModel(
      name: 'Jaipur',
      state: 'Rajasthan',
      category: 'Cities',
      description: 'Heritage, forts and royal architecture',
      imagePath: 'assets/images/destinations/jaipur.png',
      overview:
      'Jaipur is famous for its royal heritage, historic forts, '
          'palaces, colourful markets and traditional Rajasthani culture. '
          'The city combines historic architecture with a lively modern '
          'travel experience.',
      bestTimeToVisit: 'Oct - Mar',
      recommendedDays: '2 - 4 Days',
      highlights: [
        'Amber Fort',
        'Hawa Mahal',
        'City Palace',
        'Jal Mahal',
        'Nahargarh Fort',
      ],
    ),

    DestinationModel(
      name: 'Kerala',
      state: 'Kerala',
      category: 'Nature',
      description: 'Nature, backwaters and peaceful escapes',
      imagePath: 'assets/images/destinations/kerala.png',
      overview:
      'Kerala offers tropical landscapes, peaceful backwaters, '
          'hill stations, beaches and rich local culture. It is well '
          'known for scenic journeys and nature-focused travel.',
      bestTimeToVisit: 'Sep - Mar',
      recommendedDays: '5 - 7 Days',
      highlights: [
        'Munnar',
        'Alleppey',
        'Kochi',
        'Varkala',
        'Backwaters',
      ],
    ),

    DestinationModel(
      name: 'Manali',
      state: 'Himachal Pradesh',
      category: 'Mountains',
      description: 'Mountains, valleys and adventure',
      imagePath: 'assets/images/destinations/manali.png',
      overview:
      'Manali is a popular Himalayan destination surrounded by '
          'mountains, valleys and rivers. It is known for scenic views, '
          'adventure activities and nearby mountain attractions.',
      bestTimeToVisit: 'Mar - Jun',
      recommendedDays: '3 - 5 Days',
      highlights: [
        'Solang Valley',
        'Old Manali',
        'Hadimba Temple',
        'Rohtang Pass',
        'Mall Road',
      ],
    ),
  ];
}