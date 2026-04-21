import 'package:cine_hub/core/errors/client_http_failures.dart';
import 'package:cine_hub/core/network/connectivity_service.dart';
import 'package:cine_hub/core/utils/result.dart';
import 'package:cine_hub/features/movies/data/infra/interfaces/movies_local_data_source.dart';
import 'package:cine_hub/features/movies/data/infra/interfaces/movies_remote_data_source.dart';
import 'package:cine_hub/features/movies/data/infra/tmdb_movies_repository_impl.dart';
import 'package:cine_hub/features/movies/domain/entities/movie_details_entity.dart';
import 'package:cine_hub/features/movies/domain/entities/movie_entity.dart';
import 'package:cine_hub/features/movies/domain/entities/movie_page_response_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements MoviesRemoteDataSource {}

class MockLocalDataSource extends Mock implements MoviesLocalDataSource {}

class MockConnectivityService extends Mock implements ConnectivityService {}

void main() {
  late TmdbMoviesRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockConnectivityService mockConnectivityService;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockConnectivityService = MockConnectivityService();
    repository = TmdbMoviesRepositoryImpl(
      mockRemoteDataSource,
      mockLocalDataSource,
      mockConnectivityService,
    );
  });

  final tMoviePageResponse = MoviePageResponseEntity(
    page: 1,
    results: [
      MovieEntity(
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
      ),
    ],
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
    test(
      'should return Success when online and remote call is successful',
      () async {
        when(
          () => mockConnectivityService.isOnline,
        ).thenAnswer((_) async => true);
        when(
          () => mockLocalDataSource.getNowPlaying(page: 1),
        ).thenAnswer((_) async => null);
        when(
          () => mockRemoteDataSource.getNowPlaying(page: 1),
        ).thenAnswer((_) async => tMoviePageResponse);
        when(
          () => mockLocalDataSource.saveNowPlaying(any()),
        ).thenAnswer((_) async => {});

        final result = await repository.getNowPlaying(page: 1);

        expect(result, isA<Success<MoviePageResponseEntity>>());
        verify(() => mockRemoteDataSource.getNowPlaying(page: 1)).called(1);
        verify(
          () => mockLocalDataSource.saveNowPlaying(tMoviePageResponse),
        ).called(1);
      },
    );

    test(
      'should return CachedFallbackSuccess when offline and local data exists',
      () async {
        when(
          () => mockConnectivityService.isOnline,
        ).thenAnswer((_) async => false);
        when(
          () => mockLocalDataSource.getNowPlaying(page: 1),
        ).thenAnswer((_) async => tMoviePageResponse);

        final result = await repository.getNowPlaying(page: 1);

        expect(result, isA<CachedFallbackSuccess<MoviePageResponseEntity>>());
        expect((result as CachedFallbackSuccess).data, tMoviePageResponse);
      },
    );

    test('should return Error when offline and no local data', () async {
      when(
        () => mockConnectivityService.isOnline,
      ).thenAnswer((_) async => false);
      when(
        () => mockLocalDataSource.getNowPlaying(page: 1),
      ).thenAnswer((_) async => null);

      final result = await repository.getNowPlaying(page: 1);

      expect(result, isA<Error<MoviePageResponseEntity>>());
      expect((result as Error).exception, isA<NoInternetConection>());
    });
  });

  group('getMovieDetails', () {
    test(
      'should return Success when online and remote call is successful',
      () async {
        when(
          () => mockConnectivityService.isOnline,
        ).thenAnswer((_) async => true);
        when(
          () => mockLocalDataSource.getMovieDetails(1),
        ).thenAnswer((_) async => null);
        when(
          () => mockRemoteDataSource.getMovieDetails(1),
        ).thenAnswer((_) async => tMovieDetails);
        when(
          () => mockLocalDataSource.saveMovieDetails(any()),
        ).thenAnswer((_) async => {});

        final result = await repository.getMovieDetails(1);

        expect(result, isA<Success<MovieDetailsEntity>>());
        verify(() => mockRemoteDataSource.getMovieDetails(1)).called(1);
        verify(
          () => mockLocalDataSource.saveMovieDetails(tMovieDetails),
        ).called(1);
      },
    );
  });

  setUpAll(() {
    registerFallbackValue(tMoviePageResponse);
    registerFallbackValue(tMovieDetails);
  });
}
