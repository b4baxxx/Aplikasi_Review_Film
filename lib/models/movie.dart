class Movie {
  final String name;
  final String location;
  final String description;
  final String built;
  final String genre;
  final String imageAsset;
  final List<String> imageUrls;
  bool isFavorite;

  Movie({
    required this.name,
    required this.location,
    required this.description,
    required this.built,
    required this.genre,
    required this.imageAsset,
    required this.imageUrls,
    this.isFavorite = false,
  });

}
