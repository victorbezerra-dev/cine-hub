import '../../domain/entities/movie_details_entity.dart';

class MovieDetailsState {
  const MovieDetailsState({
    this.isLoading = false,
    this.details,
    this.error,
    this.paletteColorValue,
    this.reloadVersion = 0,
  });

  final bool isLoading;
  final MovieDetailsEntity? details;
  final String? error;
  final int? paletteColorValue;
  final int reloadVersion;

  MovieDetailsState copyWith({
    bool? isLoading,
    MovieDetailsEntity? details,
    String? error,
    bool clearError = false,
    int? paletteColorValue,
    bool clearPalette = false,
    int? reloadVersion,
  }) {
    return MovieDetailsState(
      isLoading: isLoading ?? this.isLoading,
      details: details ?? this.details,
      error: clearError ? null : error ?? this.error,
      paletteColorValue: clearPalette
          ? null
          : paletteColorValue ?? this.paletteColorValue,
      reloadVersion: reloadVersion ?? this.reloadVersion,
    );
  }
}
