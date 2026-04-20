import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/providers/movies_repository_provider.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/entities/movie_page_response_entity.dart';
import '../../domain/repositories/movies_repository.dart';
import '../states/home_state.dart';

final homeNotifierProvider = StateNotifierProvider<HomeNotifier, HomeState>((
  ref,
) {
  final repository = ref.watch(moviesRepositoryProvider);
  return HomeNotifier(repository);
});

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier(this._repository) : super(const HomeState());

  final MoviesRepository _repository;

  Future<void> fetchMovies() async {
    if (Settings.tmdbReadAccessToken.isEmpty) {
      debugPrint('[HomeNotifier] TMDB_READ_ACCESS_TOKEN is not configured.');

      state = state.copyWith(
        nowPlaying: const <MovieEntity>[],
        popular: const <MovieEntity>[],
        isLoading: false,
        error: 'Unable to load movies at the moment.',
      );
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    final nowPlayingResult = await _repository.getNowPlaying();
    final popularResult = await _repository.getPopularMovies();

    List<MovieEntity> nowPlayingMovies = const <MovieEntity>[];
    List<MovieEntity> popularMovies = const <MovieEntity>[];
    final errors = <String>[];

    switch (nowPlayingResult) {
      case Success<MoviePageResponseEntity>(:final data):
        nowPlayingMovies = data.results;
      case Error<MoviePageResponseEntity>(:final exception):
        debugPrint(
          '[HomeNotifier] Failed to fetch now playing movies: $exception',
        );
        errors.add('Failed to load now playing movies.');
    }

    switch (popularResult) {
      case Success<MoviePageResponseEntity>(:final data):
        popularMovies = data.results;
      case Error<MoviePageResponseEntity>(:final exception):
        debugPrint('[HomeNotifier] Failed to fetch popular movies: $exception');
        errors.add('Failed to load popular movies.');
    }

    state = state.copyWith(
      nowPlaying: nowPlayingMovies,
      popular: popularMovies,
      isLoading: false,
      error: errors.isEmpty ? null : errors.join('\n'),
    );
  }
}
