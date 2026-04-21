import '../../../domain/entities/movie_page_response_entity.dart';

abstract class MoviesLocalDataSource {
  Future<MoviePageResponseEntity?> getNowPlaying({int page = 1});

  Future<MoviePageResponseEntity?> getPopularMovies({int page = 1});

  Future<void> saveNowPlaying(MoviePageResponseEntity response);

  Future<void> savePopularMovies(MoviePageResponseEntity response);
}
