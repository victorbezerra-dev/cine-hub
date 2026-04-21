import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palette_generator_master/palette_generator_master.dart';

import '../../domain/entities/movie_details_entity.dart';
import '../../domain/entities/movie_entity.dart';
import '../components/movie_details/movie_details_app_bar.dart';
import '../components/movie_details/movie_details_content.dart';
import '../components/home/home_error_state.dart';
import '../notifiers/favorites_notifier.dart';
import '../notifiers/movie_details_notifier.dart';

class MovieDetailsPage extends ConsumerStatefulWidget {
  const MovieDetailsPage({
    super.key,
    required this.movieId,
    required this.heroTag,
    this.initialMovie,
  });

  final int movieId;
  final String heroTag;
  final MovieEntity? initialMovie;

  @override
  ConsumerState<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends ConsumerState<MovieDetailsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(movieDetailsNotifierProvider(widget.movieId).notifier)
          .load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(movieDetailsNotifierProvider(widget.movieId));
    final notifier = ref.read(
      movieDetailsNotifierProvider(widget.movieId).notifier,
    );
    final favoriteIds = ref.watch(favoritesNotifierProvider);
    final isFavorite = favoriteIds.contains(widget.movieId);
    final details = state.details;
    final paletteColor = state.paletteColorValue != null
        ? Color(state.paletteColorValue!)
        : const Color(0xFF121212);

    if (details != null) {
      _updatePalette(details, notifier);
    } else if (widget.initialMovie != null) {
      _updatePaletteFromImage(
        widget.initialMovie!.backdropUrl ?? widget.initialMovie!.posterUrl,
        notifier,
      );
    }

    if (state.isLoading && details == null && widget.initialMovie == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (state.error != null && details == null && widget.initialMovie == null) {
      return Scaffold(
        body: HomeErrorState(message: state.error!, onRetry: notifier.load),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MovieDetailsAppBar(
            heroTag: widget.heroTag,
            movieId: widget.movieId,
            paletteColor: paletteColor,
            isFavorite: isFavorite,
            onFavoriteTap: () => ref
                .read(favoritesNotifierProvider.notifier)
                .toggleFavorite(widget.movieId),
            details: details,
            initialMovie: widget.initialMovie,
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    paletteColor.withValues(alpha: 0.32),
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                child: MovieDetailsContent(
                  state: state,
                  isFavorite: isFavorite,
                  onRetry: notifier.load,
                  details: details,
                  initialMovie: widget.initialMovie,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => ref
            .read(favoritesNotifierProvider.notifier)
            .toggleFavorite(widget.movieId),
        icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
        label: Text(isFavorite ? 'Favorited' : 'Favorite'),
      ),
    );
  }

  Future<void> _updatePalette(
    MovieDetailsEntity details,
    MovieDetailsNotifier notifier,
  ) async {
    await _updatePaletteFromImage(
      details.backdropUrl ?? details.posterUrl,
      notifier,
    );
  }

  Future<void> _updatePaletteFromImage(
    String? imageUrl,
    MovieDetailsNotifier notifier,
  ) async {
    if (imageUrl == null || imageUrl.isEmpty) return;
    if (ref
            .read(movieDetailsNotifierProvider(widget.movieId))
            .paletteColorValue !=
        null) {
      return;
    }

    final palette = await PaletteGeneratorMaster.fromImageProvider(
      NetworkImage(imageUrl),
      size: const Size(300, 170),
    );

    notifier.setPaletteColor(
      palette.darkVibrantColor?.color.toARGB32() ??
          palette.dominantColor?.color.toARGB32() ??
          const Color(0xFF1C1C1C).toARGB32(),
    );
  }
}
