import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/errors/client_http_failures.dart';
import '../../../../core/network/interfaces/i_http_client.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/movie_details_entity.dart';
import '../../domain/entities/movie_page_response_entity.dart';
import '../infra/interfaces/movies_remote_data_source.dart';
import 'mappers/movie_details_mapper.dart';
import 'mappers/movie_page_response_mapper.dart';
import 'mappers/tmdb_configuration_mapper.dart';
import 'models/tmdb_configuration_model.dart';

class TmdbMoviesRemoteDataSourceImpl implements MoviesRemoteDataSource {
  TmdbMoviesRemoteDataSourceImpl(this._client);

  final IHttpClient _client;
  Future<TmdbConfigurationModel>? _configurationRequest;

  @override
  Future<MoviePageResponseEntity> getNowPlaying({int page = 1}) async {
    final response = await _getJsonMap(
      path: Settings.nowPlayingPath,
      page: page,
    );
    final configuration = await _getConfiguration();

    return MoviePageResponseMapper.fromMap(
      response,
      imageBaseUrl: configuration.secureBaseUrl,
      posterSize: configuration.resolvePosterSize(),
      backdropSize: configuration.resolveBackdropSize(),
    );
  }

  @override
  Future<MoviePageResponseEntity> getPopularMovies({int page = 1}) async {
    final response = await _getJsonMap(
      path: Settings.popularMoviesPath,
      page: page,
    );
    final configuration = await _getConfiguration();

    return MoviePageResponseMapper.fromMap(
      response,
      imageBaseUrl: configuration.secureBaseUrl,
      posterSize: configuration.resolvePosterSize(),
      backdropSize: configuration.resolveBackdropSize(),
    );
  }

  @override
  Future<MovieDetailsEntity> getMovieDetails(int movieId) async {
    final response = await _getJsonMap(
      path: Settings.movieDetailsPath(movieId),
    );
    final configuration = await _getConfiguration();

    return MovieDetailsMapper.fromMap(
      response,
      imageBaseUrl: configuration.secureBaseUrl,
      posterSize: configuration.resolvePosterSize(),
      backdropSize: configuration.resolveBackdropSize(),
    );
  }

  Future<TmdbConfigurationModel> _getConfiguration() {
    _configurationRequest ??= _fetchConfiguration();
    return _configurationRequest!;
  }

  Future<TmdbConfigurationModel> _fetchConfiguration() async {
    final response = await _getJsonMap(path: Settings.configurationPath);
    return TmdbConfigurationMapper.fromMap(response);
  }

  Future<Map<String, dynamic>> _getJsonMap({
    required String path,
    int? page,
  }) async {
    try {
      final response = await _client.get(
        path,
        queryParameters: <String, String>{
          'language': Settings.language,
          if (page != null) 'page': '$page',
        },
      );

      if (response is! Response<dynamic>) {
        throw RepositoryFailure(message: 'Invalid HTTP response from client.');
      }

      final statusCode = response.statusCode;
      if (statusCode == null || statusCode < 200 || statusCode >= 300) {
        throw RepositoryFailure(
          message:
              'TMDB request failed (statusCode: $statusCode, body: ${response.data})',
        );
      }

      final decodedBody = _decodeResponseBody(response.data);

      if (decodedBody is! Map<String, dynamic>) {
        throw RepositoryFailure(message: 'Invalid response from TMDB API.');
      }

      return decodedBody;
    } on DioException catch (exception) {
      throw DioFailure(exception);
    }
  }

  dynamic _decodeResponseBody(dynamic responseData) {
    if (responseData is String) {
      return jsonDecode(responseData);
    }

    return responseData;
  }
}
