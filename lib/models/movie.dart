class Movie {
  final String name;
  final String description;
  final String built;
  final String type;
  final String imageAsset;
  bool isFavorite;

  Movie({
    required this.name,
    required this.description,
    required this.built,
    required this.type,
    required this.imageAsset,
    this.isFavorite = false,
  });

}
