import '../../../../core/utils/result.dart';
import '../../domain/entities/movie_page_response_entity.dart';
import '../../domain/repositories/movies_repository.dart';
import '../infra/interfaces/movies_remote_data_source.dart';

class TmdbMoviesRepositoryImpl implements MoviesRepository {
  TmdbMoviesRepositoryImpl(this._remoteDataSource);

  final MoviesRemoteDataSource _remoteDataSource;

  @override
  Future<Result<MoviePageResponseEntity>> getNowPlaying({int page = 1}) async {
    try {
      final result = await _remoteDataSource.getNowPlaying(page: page);
      return Success<MoviePageResponseEntity>(result);
    } catch (exception) {
      return Error<MoviePageResponseEntity>(Exception(exception.toString()));
    }
  }

  @override
  Future<Result<MoviePageResponseEntity>> getPopularMovies({
    int page = 1,
  }) async {
    try {
      final result = await _remoteDataSource.getPopularMovies(page: page);
      return Success<MoviePageResponseEntity>(result);
    } catch (exception) {
      return Error<MoviePageResponseEntity>(Exception(exception.toString()));
    }
  }
}
