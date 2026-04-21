import '../../domain/entities/movie_details_entity.dart';

class MovieDetailsState {
  const MovieDetailsState({
    this.isLoading = false,
    this.details,
    this.error,
    this.paletteColorValue,
  });

  final bool isLoading;
  final MovieDetailsEntity? details;
  final String? error;
  final int? paletteColorValue;

  MovieDetailsState copyWith({
    bool? isLoading,
    MovieDetailsEntity? details,
    String? error,
    bool clearError = false,
    int? paletteColorValue,
    bool clearPalette = false,
  }) {
    return MovieDetailsState(
      isLoading: isLoading ?? this.isLoading,
      details: details ?? this.details,
      error: clearError ? null : error ?? this.error,
      paletteColorValue: clearPalette
          ? null
          : paletteColorValue ?? this.paletteColorValue,
    );
  }
}
