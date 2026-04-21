import 'package:cine_hub/core/errors/client_http_failures.dart';
import 'package:cine_hub/core/network/interfaces/i_http_client.dart';
import 'package:cine_hub/core/utils/constants.dart';
import 'package:cine_hub/features/movies/data/datasources/movies_remote_data_source_impl.dart';
import 'package:cine_hub/features/movies/domain/entities/movie_details_entity.dart';
import 'package:cine_hub/features/movies/domain/entities/movie_page_response_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements IHttpClient {}

void main() {
  late TmdbMoviesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TmdbMoviesRemoteDataSourceImpl(mockHttpClient);
  });

  const tConfigurationResponse = {
    'images': {
      'secure_base_url': 'https://image.tmdb.org/t/p/',
      'poster_sizes': ['w500'],
      'backdrop_sizes': ['w780'],
    },
  };

  const tMoviePageResponse = {
    'page': 1,
    'results': [
      {
        'id': 1,
        'title': 'Test Movie',
        'overview': 'Test Overview',
        'poster_path': '/path.jpg',
        'backdrop_path': '/backdrop.jpg',
        'release_date': '2023-01-01',
        'vote_average': 8.5,
      },
    ],
    'total_pages': 1,
    'total_results': 1,
  };

  const tMovieDetailsResponse = {
    'id': 1,
    'title': 'Test Movie',
    'overview': 'Test Overview',
    'poster_path': '/path.jpg',
    'backdrop_path': '/backdrop.jpg',
    'release_date': '2023-01-01',
    'vote_average': 8.5,
    'genres': [
      {'id': 1, 'name': 'Action'},
    ],
    'runtime': 120,
    'tagline': 'Test Tagline',
  };

  group('getNowPlaying', () {
    test(
      'should return MoviePageResponseEntity when the call is successful',
      () async {
        when(
          () => mockHttpClient.get(
            Settings.configurationPath,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: tConfigurationResponse,
            requestOptions: RequestOptions(),
            statusCode: 200,
          ),
        );
        when(
          () => mockHttpClient.get(
            Settings.nowPlayingPath,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: tMoviePageResponse,
            requestOptions: RequestOptions(),
            statusCode: 200,
          ),
        );

        final result = await dataSource.getNowPlaying(page: 1);

        expect(result, isA<MoviePageResponseEntity>());
        expect(result.results.first.title, 'Test Movie');
        verify(
          () => mockHttpClient.get(
            Settings.nowPlayingPath,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).called(1);
      },
    );

    test('should throw RepositoryFailure when statusCode is not 200', () async {
      when(
        () => mockHttpClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: {},
          requestOptions: RequestOptions(),
          statusCode: 404,
        ),
      );

      final call = dataSource.getNowPlaying();

      expect(() => call, throwsA(isA<RepositoryFailure>()));
    });
  });

  group('getPopularMovies', () {
    test(
      'should return MoviePageResponseEntity when the call is successful',
      () async {
        when(
          () => mockHttpClient.get(
            Settings.configurationPath,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: tConfigurationResponse,
            requestOptions: RequestOptions(),
            statusCode: 200,
          ),
        );
        when(
          () => mockHttpClient.get(
            Settings.popularMoviesPath,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: tMoviePageResponse,
            requestOptions: RequestOptions(),
            statusCode: 200,
          ),
        );

        final result = await dataSource.getPopularMovies(page: 1);

        expect(result, isA<MoviePageResponseEntity>());
        verify(
          () => mockHttpClient.get(
            Settings.popularMoviesPath,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).called(1);
      },
    );
  });

  group('getMovieDetails', () {
    test(
      'should return MovieDetailsEntity when the call is successful',
      () async {
        final movieId = 1;
        when(
          () => mockHttpClient.get(
            Settings.configurationPath,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: tConfigurationResponse,
            requestOptions: RequestOptions(),
            statusCode: 200,
          ),
        );
        when(
          () => mockHttpClient.get(
            Settings.movieDetailsPath(movieId),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: tMovieDetailsResponse,
            requestOptions: RequestOptions(),
            statusCode: 200,
          ),
        );

        final result = await dataSource.getMovieDetails(movieId);

        expect(result, isA<MovieDetailsEntity>());
        expect(result.id, movieId);
      },
    );
  });
}
