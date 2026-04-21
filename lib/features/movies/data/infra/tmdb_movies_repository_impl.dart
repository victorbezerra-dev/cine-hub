import 'package:dio/dio.dart';

import '../../../../core/errors/client_http_failures.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/movie_details_entity.dart';
import '../../domain/entities/movie_page_response_entity.dart';
import '../../domain/repositories/movies_repository.dart';
import '../infra/interfaces/movies_local_data_source.dart';
import '../infra/interfaces/movies_remote_data_source.dart';

class TmdbMoviesRepositoryImpl implements MoviesRepository {
  TmdbMoviesRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._connectivityService,
  );

  static const String offlineMessage =
      'You are offline 😄 Showing saved movies. Tap "Retry" when your connection is back.';

  final MoviesRemoteDataSource _remoteDataSource;
  final MoviesLocalDataSource _localDataSource;
  final ConnectivityService _connectivityService;

  @override
  Future<Result<MoviePageResponseEntity>> getNowPlaying({int page = 1}) async {
    return _fetchMoviesPage(
      loadLocal: () => _localDataSource.getNowPlaying(page: page),
      loadRemote: () => _remoteDataSource.getNowPlaying(page: page),
      saveLocal: _localDataSource.saveNowPlaying,
    );
  }

  @override
  Future<Result<MoviePageResponseEntity>> getPopularMovies({
    int page = 1,
  }) async {
    return _fetchMoviesPage(
      loadLocal: () => _localDataSource.getPopularMovies(page: page),
      loadRemote: () => _remoteDataSource.getPopularMovies(page: page),
      saveLocal: _localDataSource.savePopularMovies,
    );
  }

  @override
  Future<Result<MovieDetailsEntity>> getMovieDetails(int movieId) async {
    final localResult = await _localDataSource.getMovieDetails(movieId);

    if (!await _connectivityService.isOnline) {
      if (localResult != null) {
        return CachedFallbackSuccess<MovieDetailsEntity>(
          localResult,
          message: offlineMessage,
        );
      }

      return Error<MovieDetailsEntity>(
        NoInternetConection(message: offlineMessage),
      );
    }

    try {
      final result = await _remoteDataSource.getMovieDetails(movieId);
      await _localDataSource.saveMovieDetails(result);
      return Success<MovieDetailsEntity>(result);
    } catch (exception) {
      if (_isOfflineError(exception)) {
        if (localResult != null) {
          return CachedFallbackSuccess<MovieDetailsEntity>(
            localResult,
            message: offlineMessage,
          );
        }

        return Error<MovieDetailsEntity>(
          NoInternetConection(message: offlineMessage),
        );
      }

      return Error<MovieDetailsEntity>(Exception(exception.toString()));
    }
  }

  Future<Result<MoviePageResponseEntity>> _fetchMoviesPage({
    required Future<MoviePageResponseEntity?> Function() loadLocal,
    required Future<MoviePageResponseEntity> Function() loadRemote,
    required Future<void> Function(MoviePageResponseEntity page) saveLocal,
  }) async {
    final localResult = await loadLocal();

    if (!await _connectivityService.isOnline) {
      if (localResult != null) {
        return CachedFallbackSuccess<MoviePageResponseEntity>(
          localResult,
          message: offlineMessage,
        );
      }

      return Error<MoviePageResponseEntity>(
        NoInternetConection(message: offlineMessage),
      );
    }

    try {
      final result = await loadRemote();
      await saveLocal(result);
      return Success<MoviePageResponseEntity>(result);
    } catch (exception) {
      if (_isOfflineError(exception)) {
        if (localResult != null) {
          return CachedFallbackSuccess<MoviePageResponseEntity>(
            localResult,
            message: offlineMessage,
          );
        }

        return Error<MoviePageResponseEntity>(
          NoInternetConection(message: offlineMessage),
        );
      }

      return Error<MoviePageResponseEntity>(Exception(exception.toString()));
    }
  }

  bool _isOfflineError(Object exception) {
    return exception is NoInternetConection ||
        (exception is DioFailure &&
            exception.type == DioExceptionType.connectionError) ||
        exception.toString().toLowerCase().contains('socketexception') ||
        exception.toString().toLowerCase().contains('connection error');
  }
}
