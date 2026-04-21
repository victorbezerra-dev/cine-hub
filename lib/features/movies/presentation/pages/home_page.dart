import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/connectivity_provider.dart';
import '../../data/infra/tmdb_movies_repository_impl.dart';
import '../components/home/empty_section_state.dart';
import '../components/home/home_app_bar_title.dart';
import '../components/home/home_error_state.dart';
import '../components/home/home_inline_error_banner.dart';
import '../components/home/movie_card.dart';
import '../components/home/movie_carousel.dart';
import '../components/home/section_skeleton.dart';
import '../notifiers/favorites_notifier.dart';
import '../notifiers/paginated_movie_notifier.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  static const double _scrollEndThreshold = 24;
  static const double _scrollEdgeEpsilon = 8;
  static const int _autoScrollPreloadLimit = 500;

  final Map<String, ScrollController> _carouselControllers =
      <String, ScrollController>{};

  final Map<String, Timer> _carouselTimers = <String, Timer>{};
  final Map<String, bool> _carouselAutoScrollForward = <String, bool>{};
  final Map<String, bool> _carouselAutoScrollAnimating = <String, bool>{};

  @override
  void initState() {
    super.initState();

    Future.microtask(_loadHomeSections);
  }

  Future<void> _loadHomeSections() async {
    await Future.wait([
      ref.read(nowPlayingNotifierProvider.notifier).fetchInitial(),
      ref.read(popularMoviesNotifierProvider.notifier).fetchInitial(),
    ]);
  }

  @override
  void dispose() {
    for (final timer in _carouselTimers.values) {
      timer.cancel();
    }

    for (final controller in _carouselControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  ScrollController _getCarouselController(String sectionKey) {
    return _carouselControllers.putIfAbsent(sectionKey, () {
      final controller = ScrollController();
      controller.addListener(() => _handleScrollEnd(sectionKey));
      return controller;
    });
  }

  void _handleScrollEnd(String sectionKey) {
    final controller = _carouselControllers[sectionKey];
    if (controller == null || !controller.hasClients) return;

    if (_carouselAutoScrollAnimating[sectionKey] ?? false) return;

    if (controller.position.pixels >=
        controller.position.maxScrollExtent - _scrollEndThreshold) {
      if (sectionKey == 'now_playing') {
        ref.read(nowPlayingNotifierProvider.notifier).fetchNextPage();
      } else {
        ref.read(popularMoviesNotifierProvider.notifier).fetchNextPage();
      }
    }
  }

  void _configureAutoScroll({
    required String sectionKey,
    required double itemExtent,
    required bool enabled,
    required int loadedItemsCount,
  }) {
    if (!enabled) {
      _carouselTimers.remove(sectionKey)?.cancel();
      _carouselAutoScrollForward.remove(sectionKey);
      _carouselAutoScrollAnimating.remove(sectionKey);
      return;
    }

    if (_carouselTimers.containsKey(sectionKey)) {
      return;
    }

    final controller = _getCarouselController(sectionKey);
    _carouselAutoScrollForward.putIfAbsent(sectionKey, () => true);
    _carouselAutoScrollAnimating.putIfAbsent(sectionKey, () => false);

    _carouselTimers[sectionKey] = Timer.periodic(const Duration(seconds: 4), (
      timer,
    ) {
      if (!mounted || !controller.hasClients) return;

      final maxScroll = controller.position.maxScrollExtent;
      if (maxScroll <= 0) return;

      final isMovingForward = _carouselAutoScrollForward[sectionKey] ?? true;
      final currentOffset = controller.offset;
      double targetOffset;

      if (isMovingForward) {
        final nextOffset = currentOffset + itemExtent;

        if (nextOffset >= maxScroll - _scrollEdgeEpsilon) {
          if (loadedItemsCount < _autoScrollPreloadLimit) {
            ref.read(nowPlayingNotifierProvider.notifier).fetchNextPage();
          }

          final isAtEnd = currentOffset >= maxScroll - _scrollEdgeEpsilon;

          if (isAtEnd) {
            _carouselAutoScrollForward[sectionKey] = false;
            targetOffset = math.max(0, maxScroll - itemExtent);
          } else {
            targetOffset = maxScroll;
          }
        } else {
          targetOffset = nextOffset;
        }
      } else {
        final nextOffset = currentOffset - itemExtent;

        if (nextOffset <= _scrollEdgeEpsilon) {
          final isAtStart = currentOffset <= _scrollEdgeEpsilon;

          if (isAtStart) {
            _carouselAutoScrollForward[sectionKey] = true;
            targetOffset = math.min(maxScroll, itemExtent);
          } else {
            targetOffset = 0;
          }
        } else {
          targetOffset = nextOffset;
        }
      }

      if (targetOffset < 0) {
        targetOffset = 0;
      }

      if (targetOffset > maxScroll) {
        targetOffset = maxScroll;
      }

      if ((targetOffset - currentOffset).abs() < 1) {
        return;
      }

      _carouselAutoScrollAnimating[sectionKey] = true;

      controller
          .animateTo(
            targetOffset,
            duration: const Duration(milliseconds: 550),
            curve: Curves.easeInOut,
          )
          .whenComplete(() {
            _carouselAutoScrollAnimating[sectionKey] = false;
          });
    });
  }

  Widget _buildMovieCarousel({
    required String title,
    required List movies,
    required IconData fallbackIcon,
    required String sectionKey,
    required bool isLoadingMore,
    required Set<int> favoriteIds,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final cardWidth = math.min(170.0, math.max(130.0, screenWidth * 0.40));
        const itemSpacing = 12.0;

        final posterHeight = cardWidth * 1.75;
        final carouselHeight = posterHeight + 80;
        final controller = _getCarouselController(sectionKey);

        _configureAutoScroll(
          sectionKey: sectionKey,
          itemExtent: cardWidth + itemSpacing,
          enabled: sectionKey == 'now_playing' && movies.length > 1,
          loadedItemsCount: movies.length,
        );

        return MovieCarousel(
          title: title,
          itemCount: movies.length,
          carouselHeight: carouselHeight,
          controller: controller,
          isEmpty: movies.isEmpty,
          emptyChild: const EmptySectionState(),
          isLoadingMore: isLoadingMore,
          loadingCardWidth: cardWidth,
          itemBuilder: (_, index) => MovieCard(
            movie: movies[index],
            fallbackIcon: fallbackIcon,
            sectionKey: sectionKey,
            cardWidth: cardWidth,
            isFavorite: favoriteIds.contains(movies[index].id),
            onFavoriteTap: () => ref
                .read(favoritesNotifierProvider.notifier)
                .toggleFavorite(movies[index].id),
            onTap: () => context.push(
              '/movie/${movies[index].id}',
              extra: <String, dynamic>{
                'movie': movies[index],
                'heroTag': '$sectionKey-${movies[index].id}',
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: const [
        SectionSkeleton(title: 'Now Playing'),
        SizedBox(height: 28),
        SectionSkeleton(title: 'Popular Movies'),
      ],
    );
  }

  Future<void> _refreshAll() async {
    await _loadHomeSections();
  }

  @override
  Widget build(BuildContext context) {
    final nowPlayingState = ref.watch(nowPlayingNotifierProvider);
    final popularState = ref.watch(popularMoviesNotifierProvider);
    final favoriteIds = ref.watch(favoritesNotifierProvider);
    final isOffline = ref
        .watch(connectivityStatusProvider)
        .maybeWhen(data: (value) => !value, orElse: () => false);

    final isInitialLoading =
        nowPlayingState.isLoading && popularState.isLoading;

    final sectionErrors = [
      nowPlayingState.error,
      popularState.error,
    ].whereType<String>().where((message) => message.isNotEmpty);

    final allMovies = [...nowPlayingState.movies, ...popularState.movies];
    final offlineBannerMessage = isOffline && allMovies.isNotEmpty
        ? TmdbMoviesRepositoryImpl.offlineMessage
        : null;

    final combinedError = {...sectionErrors, ?offlineBannerMessage}.join('\n');

    final hasOnlyError =
        combinedError.isNotEmpty &&
        nowPlayingState.movies.isEmpty &&
        popularState.movies.isEmpty;

    return Scaffold(
      appBar: AppBar(titleSpacing: 0, title: const HomeAppBarTitle()),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: isInitialLoading
              ? _buildLoadingState()
              : hasOnlyError
              ? HomeErrorState(message: combinedError, onRetry: _refreshAll)
              : RefreshIndicator(
                  onRefresh: _refreshAll,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      if (combinedError.isNotEmpty)
                        HomeInlineErrorBanner(
                          message: combinedError,
                          onRetry: _refreshAll,
                        ),
                      _buildMovieCarousel(
                        title: 'Now Playing',
                        movies: nowPlayingState.movies,
                        fallbackIcon: Icons.local_fire_department_outlined,
                        sectionKey: 'now_playing',
                        isLoadingMore: nowPlayingState.isLoadingMore,
                        favoriteIds: favoriteIds,
                      ),
                      const SizedBox(height: 28),
                      _buildMovieCarousel(
                        title: 'Popular Movies',
                        movies: popularState.movies,
                        fallbackIcon: Icons.movie_outlined,
                        sectionKey: 'popular_movies',
                        isLoadingMore: popularState.isLoadingMore,
                        favoriteIds: favoriteIds,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
