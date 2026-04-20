import '../../domain/entities/movie_entity.dart';

class HomeState {
  const HomeState({
    this.nowPlaying = const <MovieEntity>[],
    this.popular = const <MovieEntity>[],
    this.isLoading = false,
    this.error,
  });

  final List<MovieEntity> nowPlaying;
  final List<MovieEntity> popular;
  final bool isLoading;
  final String? error;

  HomeState copyWith({
    List<MovieEntity>? nowPlaying,
    List<MovieEntity>? popular,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return HomeState(
      nowPlaying: nowPlaying ?? this.nowPlaying,
      popular: popular ?? this.popular,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
