import '../../../../core/utils/result.dart';
import '../entities/movie_details_entity.dart';
import '../entities/movie_page_response_entity.dart';

abstract class MoviesRepository {
  Future<Result<MoviePageResponseEntity>> getNowPlaying({int page = 1});

  Future<Result<MoviePageResponseEntity>> getPopularMovies({int page = 1});

  Future<Result<MovieDetailsEntity>> getMovieDetails(int movieId);
}
