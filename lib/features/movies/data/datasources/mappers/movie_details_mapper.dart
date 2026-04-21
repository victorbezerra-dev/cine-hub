import '../../../../../core/utils/constants.dart';
import '../../../domain/entities/movie_details_entity.dart';

class MovieDetailsMapper {
  const MovieDetailsMapper._();

  static MovieDetailsEntity fromMap(
    Map<String, dynamic> map, {
    String? imageBaseUrl,
    String? posterSize,
    String? backdropSize,
  }) {
    final posterPath = map['poster_path'] as String?;
    final backdropPath = map['backdrop_path'] as String?;

    return MovieDetailsEntity(
      id: (map['id'] as num?)?.toInt() ?? 0,
      title: map['title'] as String? ?? '',
      overview: map['overview'] as String? ?? '',
      posterPath: posterPath,
      posterUrl: _buildImageUrl(
        baseUrl: imageBaseUrl ?? Settings.imageBaseUrl,
        size: posterSize ?? Settings.defaultPosterSize,
        imagePath: posterPath,
      ),
      backdropPath: backdropPath,
      backdropUrl: _buildImageUrl(
        baseUrl: imageBaseUrl ?? Settings.imageBaseUrl,
        size: backdropSize ?? Settings.defaultBackdropSize,
        imagePath: backdropPath,
      ),
      releaseDate: map['release_date'] as String? ?? '',
      voteAverage: (map['vote_average'] as num?)?.toDouble() ?? 0,
      voteCount: (map['vote_count'] as num?)?.toInt() ?? 0,
      genres: ((map['genres'] as List<dynamic>?) ?? const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(
            (genreMap) => MovieGenreEntity(
              id: (genreMap['id'] as num?)?.toInt() ?? 0,
              name: genreMap['name'] as String? ?? '',
            ),
          )
          .toList(),
      originalLanguage: map['original_language'] as String? ?? '',
      originalTitle: map['original_title'] as String? ?? '',
      popularity: (map['popularity'] as num?)?.toDouble() ?? 0,
      adult: map['adult'] as bool? ?? false,
      video: map['video'] as bool? ?? false,
    );
  }

  static Map<String, dynamic> toMap(MovieDetailsEntity movie) {
    return <String, dynamic>{
      'id': movie.id,
      'title': movie.title,
      'overview': movie.overview,
      'poster_path': movie.posterPath,
      'poster_url': movie.posterUrl,
      'backdrop_path': movie.backdropPath,
      'backdrop_url': movie.backdropUrl,
      'release_date': movie.releaseDate,
      'vote_average': movie.voteAverage,
      'vote_count': movie.voteCount,
      'genres': movie.genres
          .map((genre) => <String, dynamic>{'id': genre.id, 'name': genre.name})
          .toList(),
      'original_language': movie.originalLanguage,
      'original_title': movie.originalTitle,
      'popularity': movie.popularity,
      'adult': movie.adult,
      'video': movie.video,
    };
  }

  static MovieDetailsEntity fromLocalMap(Map<String, dynamic> map) {
    return MovieDetailsEntity(
      id: (map['id'] as num?)?.toInt() ?? 0,
      title: map['title'] as String? ?? '',
      overview: map['overview'] as String? ?? '',
      posterPath: map['poster_path'] as String?,
      posterUrl: map['poster_url'] as String?,
      backdropPath: map['backdrop_path'] as String?,
      backdropUrl: map['backdrop_url'] as String?,
      releaseDate: map['release_date'] as String? ?? '',
      voteAverage: (map['vote_average'] as num?)?.toDouble() ?? 0,
      voteCount: (map['vote_count'] as num?)?.toInt() ?? 0,
      genres: ((map['genres'] as List<dynamic>?) ?? const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(
            (genreMap) => MovieGenreEntity(
              id: (genreMap['id'] as num?)?.toInt() ?? 0,
              name: genreMap['name'] as String? ?? '',
            ),
          )
          .toList(),
      originalLanguage: map['original_language'] as String? ?? '',
      originalTitle: map['original_title'] as String? ?? '',
      popularity: (map['popularity'] as num?)?.toDouble() ?? 0,
      adult: map['adult'] as bool? ?? false,
      video: map['video'] as bool? ?? false,
    );
  }

  static String? _buildImageUrl({
    required String? baseUrl,
    required String? size,
    required String? imagePath,
  }) {
    if (baseUrl == null || baseUrl.isEmpty) return null;
    if (size == null || size.isEmpty) return null;
    if (imagePath == null || imagePath.isEmpty) return null;

    final normalizedPath = imagePath.startsWith('/')
        ? imagePath
        : '/$imagePath';
    return '$baseUrl$size$normalizedPath';
  }
}
