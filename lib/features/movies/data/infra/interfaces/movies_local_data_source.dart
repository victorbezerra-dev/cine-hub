import '../../../domain/entities/movie_details_entity.dart';
import '../../../domain/entities/movie_page_response_entity.dart';

abstract class MoviesLocalDataSource {
  Future<MoviePageResponseEntity?> getNowPlaying({int page = 1});

  Future<MoviePageResponseEntity?> getPopularMovies({int page = 1});

  Future<MovieDetailsEntity?> getMovieDetails(int movieId);

  Future<void> saveNowPlaying(MoviePageResponseEntity response);

  Future<void> savePopularMovies(MoviePageResponseEntity response);

  Future<void> saveMovieDetails(MovieDetailsEntity response);
}
