import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/errors/general_failures.dart';
import '../../../../core/providers/movies_repository_provider.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/movie_details_entity.dart';
import '../states/movie_details_state.dart';

final movieDetailsNotifierProvider = StateNotifierProvider.autoDispose
    .family<MovieDetailsNotifier, MovieDetailsState, int>((ref, movieId) {
      final repository = ref.watch(moviesRepositoryProvider);
      return MovieDetailsNotifier(
        movieId: movieId,
        fetchDetails: () => repository.getMovieDetails(movieId),
      );
    });

class MovieDetailsNotifier extends StateNotifier<MovieDetailsState> {
  MovieDetailsNotifier({required this.movieId, required this.fetchDetails})
    : super(const MovieDetailsState());

  final int movieId;
  final Future<Result<MovieDetailsEntity>> Function() fetchDetails;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await fetchDetails();

    switch (result) {
      case CachedFallbackSuccess<MovieDetailsEntity>(
        :final data,
        :final message,
      ):
        state = state.copyWith(isLoading: false, details: data, error: message);

      case Success<MovieDetailsEntity>(:final data):
        state = state.copyWith(
          isLoading: false,
          details: data,
          clearError: true,
        );

      case Error<MovieDetailsEntity>(:final exception):
        state = state.copyWith(
          isLoading: false,
          error: _resolveErrorMessage(
            exception,
            fallbackMessage: 'Failed to load movie details',
          ),
        );
    }
  }

  void setPaletteColor(int? colorValue) {
    state = state.copyWith(paletteColorValue: colorValue);
  }

  String _resolveErrorMessage(
    Exception exception, {
    required String fallbackMessage,
  }) {
    final message = switch (exception) {
      final Failure failure when (failure.message ?? '').trim().isNotEmpty =>
        failure.message!.trim(),
      _ => exception.toString().replaceFirst('Exception: ', '').trim(),
    };

    if (message.isEmpty || message == 'Exception') {
      return fallbackMessage;
    }

    return message;
  }
}
