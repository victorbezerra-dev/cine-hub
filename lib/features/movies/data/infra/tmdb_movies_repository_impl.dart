import '../../../../core/utils/result.dart';
import '../../domain/entities/movie_page_response_entity.dart';
import '../../domain/repositories/movies_repository.dart';
import '../infra/interfaces/movies_local_data_source.dart';
import '../infra/interfaces/movies_remote_data_source.dart';

class TmdbMoviesRepositoryImpl implements MoviesRepository {
  TmdbMoviesRepositoryImpl(this._remoteDataSource, this._localDataSource);

  final MoviesRemoteDataSource _remoteDataSource;
  final MoviesLocalDataSource _localDataSource;

  @override
  Future<Result<MoviePageResponseEntity>> getNowPlaying({int page = 1}) async {
    try {
      final localResult = await _localDataSource.getNowPlaying(page: page);
      if (localResult != null) {
        return Success<MoviePageResponseEntity>(localResult);
      }

      final result = await _remoteDataSource.getNowPlaying(page: page);
      await _localDataSource.saveNowPlaying(result);
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
      final localResult = await _localDataSource.getPopularMovies(page: page);
      if (localResult != null) {
        return Success<MoviePageResponseEntity>(localResult);
      }

      final result = await _remoteDataSource.getPopularMovies(page: page);
      await _localDataSource.savePopularMovies(result);
      return Success<MoviePageResponseEntity>(result);
    } catch (exception) {
      return Error<MoviePageResponseEntity>(Exception(exception.toString()));
    }
  }
}
