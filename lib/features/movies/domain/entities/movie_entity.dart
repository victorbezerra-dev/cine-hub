class MovieEntity {
  const MovieEntity({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.posterUrl,
    required this.backdropPath,
    required this.backdropUrl,
    required this.releaseDate,
    required this.voteAverage,
    required this.genreIds,
    required this.adult,
    required this.originalLanguage,
    required this.originalTitle,
    required this.popularity,
    required this.video,
    required this.voteCount,
  });

  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? posterUrl;
  final String? backdropPath;
  final String? backdropUrl;
  final String releaseDate;
  final double voteAverage;
  final List<int> genreIds;
  final bool adult;
  final String originalLanguage;
  final String originalTitle;
  final double popularity;
  final bool video;
  final int voteCount;
}
