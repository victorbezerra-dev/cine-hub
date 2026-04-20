import '../../../domain/entities/movie_entity.dart';

class MovieMapper {
  const MovieMapper._();

  static MovieEntity fromMap(
    Map<String, dynamic> map, {
    String? imageBaseUrl,
    String? posterSize,
    String? backdropSize,
  }) {
    final posterPath = map['poster_path'] as String?;
    final backdropPath = map['backdrop_path'] as String?;

    return MovieEntity(
      id: (map['id'] as num?)?.toInt() ?? 0,
      title: map['title'] as String? ?? '',
      overview: map['overview'] as String? ?? '',
      posterPath: posterPath,
      posterUrl: _buildImageUrl(
        baseUrl: imageBaseUrl,
        size: posterSize,
        imagePath: posterPath,
      ),
      backdropPath: backdropPath,
      backdropUrl: _buildImageUrl(
        baseUrl: imageBaseUrl,
        size: backdropSize,
        imagePath: backdropPath,
      ),
      releaseDate: map['release_date'] as String? ?? '',
      voteAverage: (map['vote_average'] as num?)?.toDouble() ?? 0,
      genreIds: ((map['genre_ids'] as List<dynamic>?) ?? const <dynamic>[])
          .map((genreId) => (genreId as num).toInt())
          .toList(),
      adult: map['adult'] as bool? ?? false,
      originalLanguage: map['original_language'] as String? ?? '',
      originalTitle: map['original_title'] as String? ?? '',
      popularity: (map['popularity'] as num?)?.toDouble() ?? 0,
      video: map['video'] as bool? ?? false,
      voteCount: (map['vote_count'] as num?)?.toInt() ?? 0,
    );
  }

  static String? _buildImageUrl({
    required String? baseUrl,
    required String? size,
    required String? imagePath,
  }) {
    if (baseUrl == null || baseUrl.isEmpty) {
      return null;
    }

    if (size == null || size.isEmpty) {
      return null;
    }

    if (imagePath == null || imagePath.isEmpty) {
      return null;
    }

    final normalizedPath = imagePath.startsWith('/')
        ? imagePath
        : '/$imagePath';

    return '$baseUrl$size$normalizedPath';
  }
}
