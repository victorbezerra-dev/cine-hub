import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/movie_details_entity.dart';
import '../../domain/entities/movie_page_response_entity.dart';
import '../infra/interfaces/movies_local_data_source.dart';
import 'mappers/movie_details_mapper.dart';
import 'mappers/movie_page_response_local_mapper.dart';

class MoviesLocalDataSourceImpl implements MoviesLocalDataSource {
  MoviesLocalDataSourceImpl(this._preferences);

  static const Duration _cacheTtl = Duration(hours: 1);
  static const String _savedAtField = 'savedAt';
  static const String _payloadField = 'payload';

  final SharedPreferences _preferences;

  @override
  Future<MoviePageResponseEntity?> getNowPlaying({int page = 1}) async {
    return _read(_nowPlayingKey(page));
  }

  @override
  Future<MoviePageResponseEntity?> getPopularMovies({int page = 1}) async {
    return _read(_popularKey(page));
  }

  @override
  Future<MovieDetailsEntity?> getMovieDetails(int movieId) async {
    final decoded = await _readCacheMap(_movieDetailsKey(movieId));
    if (decoded == null) {
      return null;
    }

    return MovieDetailsMapper.fromLocalMap(decoded);
  }

  @override
  Future<void> saveNowPlaying(MoviePageResponseEntity response) async {
    await _write(_nowPlayingKey(response.page), response);
  }

  @override
  Future<void> savePopularMovies(MoviePageResponseEntity response) async {
    await _write(_popularKey(response.page), response);
  }

  @override
  Future<void> saveMovieDetails(MovieDetailsEntity response) async {
    await _writeCacheMap(
      _movieDetailsKey(response.id),
      MovieDetailsMapper.toMap(response),
    );
  }

  Future<MoviePageResponseEntity?> _read(String key) async {
    final decoded = await _readCacheMap(key);
    if (decoded == null) {
      return null;
    }

    return MoviePageResponseLocalMapper.fromMap(decoded);
  }

  Future<void> _write(String key, MoviePageResponseEntity response) async {
    await _writeCacheMap(key, MoviePageResponseLocalMapper.toMap(response));
  }

  Future<Map<String, dynamic>?> _readCacheMap(String key) async {
    final rawValue = _preferences.getString(key);
    if (rawValue == null || rawValue.isEmpty) {
      return null;
    }

    final decoded = jsonDecode(rawValue);
    if (decoded is! Map<String, dynamic>) {
      await _preferences.remove(key);
      return null;
    }

    final savedAt = decoded[_savedAtField];
    final payload = decoded[_payloadField];

    if (savedAt is! int || payload is! Map<String, dynamic>) {
      await _preferences.remove(key);
      return null;
    }

    final expiresAt = DateTime.fromMillisecondsSinceEpoch(
      savedAt,
    ).add(_cacheTtl);

    if (DateTime.now().isAfter(expiresAt)) {
      await _preferences.remove(key);
      return null;
    }

    return payload;
  }

  Future<void> _writeCacheMap(String key, Map<String, dynamic> payload) async {
    final encoded = jsonEncode({
      _savedAtField: DateTime.now().millisecondsSinceEpoch,
      _payloadField: payload,
    });

    await _preferences.setString(key, encoded);
  }

  String _nowPlayingKey(int page) => 'movies_cache_now_playing_$page';

  String _popularKey(int page) => 'movies_cache_popular_$page';

  String _movieDetailsKey(int movieId) => 'movies_cache_details_$movieId';
}
