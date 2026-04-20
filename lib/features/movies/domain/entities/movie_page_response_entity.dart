import 'movie_entity.dart';

class MoviePageResponseEntity {
  const MoviePageResponseEntity({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  final int page;
  final List<MovieEntity> results;
  final int totalPages;
  final int totalResults;
}
