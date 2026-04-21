import '../../../domain/entities/movie_entity.dart';
import '../../../domain/entities/movie_page_response_entity.dart';

class MoviePageResponseLocalMapper {
  const MoviePageResponseLocalMapper._();

  static Map<String, dynamic> toMap(MoviePageResponseEntity entity) {
    return <String, dynamic>{
      'page': entity.page,
      'results': entity.results.map(_movieToMap).toList(),
      'total_pages': entity.totalPages,
      'total_results': entity.totalResults,
    };
  }

  static MoviePageResponseEntity fromMap(Map<String, dynamic> map) {
    return MoviePageResponseEntity(
      page: (map['page'] as num?)?.toInt() ?? 1,
      results: ((map['results'] as List<dynamic>?) ?? const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(_movieFromMap)
          .toList(),
      totalPages: (map['total_pages'] as num?)?.toInt() ?? 0,
      totalResults: (map['total_results'] as num?)?.toInt() ?? 0,
    );
  }

  static Map<String, dynamic> _movieToMap(MovieEntity movie) {
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
      'genre_ids': movie.genreIds,
      'adult': movie.adult,
      'original_language': movie.originalLanguage,
      'original_title': movie.originalTitle,
      'popularity': movie.popularity,
      'video': movie.video,
      'vote_count': movie.voteCount,
    };
  }

  static MovieEntity _movieFromMap(Map<String, dynamic> map) {
    return MovieEntity(
      id: (map['id'] as num?)?.toInt() ?? 0,
      title: map['title'] as String? ?? '',
      overview: map['overview'] as String? ?? '',
      posterPath: map['poster_path'] as String?,
      posterUrl: map['poster_url'] as String?,
      backdropPath: map['backdrop_path'] as String?,
      backdropUrl: map['backdrop_url'] as String?,
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
}
