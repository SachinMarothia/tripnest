class DestinationModel {
  final String name;
  final String state;
  final String category;
  final String description;
  final String imagePath;

  // Details screen data
  final String overview;
  final String bestTimeToVisit;
  final String recommendedDays;
  final List<String> highlights;

  const DestinationModel({
    required this.name,
    required this.state,
    required this.category,
    required this.description,
    required this.imagePath,
    required this.overview,
    required this.bestTimeToVisit,
    required this.recommendedDays,
    required this.highlights,
  });
}