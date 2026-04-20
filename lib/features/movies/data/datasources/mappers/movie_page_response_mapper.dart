import '../../../domain/entities/movie_page_response_entity.dart';
import 'movie_mapper.dart';

class MoviePageResponseMapper {
  const MoviePageResponseMapper._();

  static MoviePageResponseEntity fromMap(
    Map<String, dynamic> map, {
    String? imageBaseUrl,
    String? posterSize,
    String? backdropSize,
  }) {
    return MoviePageResponseEntity(
      page: (map['page'] as num?)?.toInt() ?? 1,
      results: ((map['results'] as List<dynamic>?) ?? const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(
            (movie) => MovieMapper.fromMap(
              movie,
              imageBaseUrl: imageBaseUrl,
              posterSize: posterSize,
              backdropSize: backdropSize,
            ),
          )
          .toList(),
      totalPages: (map['total_pages'] as num?)?.toInt() ?? 0,
      totalResults: (map['total_results'] as num?)?.toInt() ?? 0,
    );
  }
}
