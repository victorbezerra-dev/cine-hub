class MovieGenreEntity {
  const MovieGenreEntity({required this.id, required this.name});

  final int id;
  final String name;
}

class MovieDetailsEntity {
  const MovieDetailsEntity({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.posterUrl,
    required this.backdropPath,
    required this.backdropUrl,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.genres,
    required this.originalLanguage,
    required this.originalTitle,
    required this.popularity,
    required this.adult,
    required this.video,
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
  final int voteCount;
  final List<MovieGenreEntity> genres;
  final String originalLanguage;
  final String originalTitle;
  final double popularity;
  final bool adult;
  final bool video;
}
