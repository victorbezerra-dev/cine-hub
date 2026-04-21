import 'dart:convert';
import 'package:cine_hub/features/movies/data/datasources/movies_local_data_source_impl.dart';
import 'package:cine_hub/features/movies/domain/entities/movie_details_entity.dart';
import 'package:cine_hub/features/movies/domain/entities/movie_page_response_entity.dart';
import 'package:cine_hub/features/movies/domain/entities/movie_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MoviesLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockPreferences;

  setUp(() {
    mockPreferences = MockSharedPreferences();
    dataSource = MoviesLocalDataSourceImpl(mockPreferences);
  });

  final tMovieEntity = MovieEntity(
    id: 1,
    title: 'Test Movie',
    overview: 'Overview',
    posterPath: '/path.jpg',
    posterUrl: 'https://image.tmdb.org/t/p/w500/path.jpg',
    backdropPath: '/backdrop.jpg',
    backdropUrl: 'https://image.tmdb.org/t/p/w780/backdrop.jpg',
    releaseDate: '2023-01-01',
    voteAverage: 8.5,
    genreIds: [1],
    adult: false,
    originalLanguage: 'en',
    originalTitle: 'Test Movie',
    popularity: 10.0,
    video: false,
    voteCount: 100,
  );

  final tMoviePageResponse = MoviePageResponseEntity(
    page: 1,
    results: [tMovieEntity],
    totalPages: 1,
    totalResults: 1,
  );

  final tMovieDetails = MovieDetailsEntity(
    id: 1,
    title: 'Test Movie',
    overview: 'Overview',
    posterPath: '/path.jpg',
    posterUrl: 'https://image.tmdb.org/t/p/w500/path.jpg',
    backdropPath: '/backdrop.jpg',
    backdropUrl: 'https://image.tmdb.org/t/p/w780/backdrop.jpg',
    releaseDate: '2023-01-01',
    voteAverage: 8.5,
    voteCount: 100,
    genres: [const MovieGenreEntity(id: 1, name: 'Action')],
    originalLanguage: 'en',
    originalTitle: 'Test Movie',
    popularity: 10.0,
    adult: false,
    video: false,
  );

  group('getNowPlaying', () {
    test('should return MoviePageResponseEntity when there is a valid cached value', () async {
      final key = 'movies_cache_now_playing_1';
      final cacheData = {
        'savedAt': DateTime.now().millisecondsSinceEpoch,
        'payload': {
          'page': 1,
          'results': [
            {
              'id': 1,
              'title': 'Test Movie',
              'overview': 'Overview',
              'poster_path': '/path.jpg',
              'backdrop_path': '/backdrop.jpg',
              'release_date': '2023-01-01',
              'vote_average': 8.5,
              'genre_ids': [1],
              'adult': false,
              'original_language': 'en',
              'original_title': 'Test Movie',
              'popularity': 10.0,
              'video': false,
              'vote_count': 100,
            }
          ],
          'total_pages': 1,
          'total_results': 1,
        }
      };
      when(() => mockPreferences.getString(key)).thenReturn(jsonEncode(cacheData));

      final result = await dataSource.getNowPlaying(page: 1);

      expect(result, isA<MoviePageResponseEntity>());
      expect(result?.results.first.title, 'Test Movie');
    });

    test('should return null when cache is expired', () async {
      final key = 'movies_cache_now_playing_1';
      final expiredDate = DateTime.now().subtract(const Duration(hours: 2)).millisecondsSinceEpoch;
      final cacheData = {
        'savedAt': expiredDate,
        'payload': {'page': 1, 'results': [], 'total_pages': 1, 'total_results': 0}
      };
      when(() => mockPreferences.getString(key)).thenReturn(jsonEncode(cacheData));
      when(() => mockPreferences.remove(key)).thenAnswer((_) async => true);

      final result = await dataSource.getNowPlaying(page: 1);

      expect(result, isNull);
      verify(() => mockPreferences.remove(key)).called(1);
    });
  });

  group('saveNowPlaying', () {
    test('should call SharedPreferences to save data', () async {
      when(() => mockPreferences.setString(any(), any())).thenAnswer((_) async => true);

      await dataSource.saveNowPlaying(tMoviePageResponse);

      verify(() => mockPreferences.setString(any(that: contains('now_playing')), any())).called(1);
    });
  });

  group('saveMovieDetails', () {
    test('should call SharedPreferences to save movie details', () async {
      when(() => mockPreferences.setString(any(), any())).thenAnswer((_) async => true);

      await dataSource.saveMovieDetails(tMovieDetails);

      verify(() => mockPreferences.setString(any(that: contains('details')), any())).called(1);
    });
  });
}
