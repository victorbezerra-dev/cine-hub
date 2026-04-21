import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/movie_page_response_entity.dart';
import '../infra/interfaces/movies_local_data_source.dart';
import 'mappers/movie_page_response_local_mapper.dart';

class MoviesLocalDataSourceImpl implements MoviesLocalDataSource {
  MoviesLocalDataSourceImpl(this._preferences);

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
  Future<void> saveNowPlaying(MoviePageResponseEntity response) async {
    await _write(_nowPlayingKey(response.page), response);
  }

  @override
  Future<void> savePopularMovies(MoviePageResponseEntity response) async {
    await _write(_popularKey(response.page), response);
  }

  Future<MoviePageResponseEntity?> _read(String key) async {
    final rawValue = _preferences.getString(key);
    if (rawValue == null || rawValue.isEmpty) {
      return null;
    }

    final decoded = jsonDecode(rawValue);
    if (decoded is! Map<String, dynamic>) {
      return null;
    }

    return MoviePageResponseLocalMapper.fromMap(decoded);
  }

  Future<void> _write(String key, MoviePageResponseEntity response) async {
    final encoded = jsonEncode(MoviePageResponseLocalMapper.toMap(response));
    await _preferences.setString(key, encoded);
  }

  String _nowPlayingKey(int page) => 'movies_cache_now_playing_$page';

  String _popularKey(int page) => 'movies_cache_popular_$page';
}
