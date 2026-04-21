import 'package:cine_hub/core/utils/result.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/providers/movies_repository_provider.dart';
import '../../domain/entities/movie_page_response_entity.dart';
import '../states/pagined_movies_state.dart';

final nowPlayingNotifierProvider =
    StateNotifierProvider<PaginatedMoviesNotifier, PaginatedMoviesState>((ref) {
      final repository = ref.watch(moviesRepositoryProvider);

      return PaginatedMoviesNotifier(
        sectionLabel: 'now playing',
        fetchPage: ({int page = 1}) => repository.getNowPlaying(page: page),
      );
    });

final popularMoviesNotifierProvider =
    StateNotifierProvider<PaginatedMoviesNotifier, PaginatedMoviesState>((ref) {
      final repository = ref.watch(moviesRepositoryProvider);

      return PaginatedMoviesNotifier(
        sectionLabel: 'popular',
        fetchPage: ({int page = 1}) => repository.getPopularMovies(page: page),
      );
    });

typedef FetchMoviesPage =
    Future<Result<MoviePageResponseEntity>> Function({int page});

class PaginatedMoviesNotifier extends StateNotifier<PaginatedMoviesState> {
  static const Duration _minimumRetryLoadingDuration = Duration(seconds: 2);

  PaginatedMoviesNotifier({required this.sectionLabel, required this.fetchPage})
    : super(const PaginatedMoviesState());

  final String sectionLabel;
  final FetchMoviesPage fetchPage;

  Future<void> fetchInitial() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await Future.wait<Object?>([
      fetchPage(page: 1),
      Future<void>.delayed(_minimumRetryLoadingDuration),
    ]).then((values) => values.first as Result<MoviePageResponseEntity>);

    switch (result) {
      case Success<MoviePageResponseEntity>(:final data):
        state = state.copyWith(
          movies: data.results,
          currentPage: data.page,
          totalPages: data.totalPages,
          isLoading: false,
        );

      case Error<MoviePageResponseEntity>():
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to load $sectionLabel movies',
        );
    }
  }

  Future<void> fetchNextPage() async {
    if (!_canLoadMore()) return;

    state = state.copyWith(isLoadingMore: true);

    final nextPage = state.currentPage + 1;
    final result = await fetchPage(page: nextPage);

    switch (result) {
      case Success<MoviePageResponseEntity>(:final data):
        state = state.copyWith(
          movies: [...state.movies, ...data.results],
          currentPage: data.page,
          totalPages: data.totalPages,
        );

      case Error<MoviePageResponseEntity>():
        state = state.copyWith(
          error: 'Failed to load more $sectionLabel movies',
        );
    }

    state = state.copyWith(isLoadingMore: false);
  }

  bool _canLoadMore() {
    if (state.isLoading) return false;
    if (state.isLoadingMore) return false;
    if (state.currentPage >= state.totalPages) return false;

    return true;
  }
}
