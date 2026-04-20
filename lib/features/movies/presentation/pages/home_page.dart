import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/network/custom_dio/custom_dio.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/result.dart';
import '../../data/datasources/movies_remote_data_source_impl.dart';
import '../../data/infra/tmdb_movies_repository_impl.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/entities/movie_page_response_entity.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MovieEntity> _nowPlayingMovies = const <MovieEntity>[];
  List<MovieEntity> _popularMovies = const <MovieEntity>[];

  @override
  void initState() {
    super.initState();
    _runTests();
  }

  Future<void> _runTests() async {
    if (Settings.tmdbReadAccessToken.isEmpty) {
      setState(() {
        _nowPlayingMovies = const <MovieEntity>[];
        _popularMovies = const <MovieEntity>[];
      });
      return;
    }

    final dio = Dio(
      BaseOptions(
        headers: <String, String>{
          'Authorization': 'Bearer ${Settings.tmdbReadAccessToken}',
          'Content-Type': 'application/json;charset=utf-8',
        },
      ),
    );

    final client = CustomDio(dio, Settings.baseUrl);
    final datasource = TmdbMoviesRemoteDataSourceImpl(client);
    final repository = TmdbMoviesRepositoryImpl(datasource);

    final nowPlayingResult = await repository.getNowPlaying();
    final popularResult = await repository.getPopularMovies();

    final List<MovieEntity> nowPlayingMovies;
    final List<MovieEntity> popularMovies;

    switch (nowPlayingResult) {
      case Success<MoviePageResponseEntity>(:final data):
        nowPlayingMovies = data.results;
      case Error<MoviePageResponseEntity>():
        nowPlayingMovies = const <MovieEntity>[];
    }

    switch (popularResult) {
      case Success<MoviePageResponseEntity>(:final data):
        popularMovies = data.results;
      case Error<MoviePageResponseEntity>():
        popularMovies = const <MovieEntity>[];
    }

    setState(() {
      _nowPlayingMovies = nowPlayingMovies;
      _popularMovies = popularMovies;
    });
  }

  Widget _buildMovieTile(MovieEntity movie, IconData fallbackIcon) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: SizedBox(
        width: 50,
        height: 75,
        child: movie.posterUrl != null && movie.posterUrl!.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  movie.posterUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Icon(fallbackIcon),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return const Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                ),
              )
            : Icon(fallbackIcon),
      ),
      title: Text(movie.title),
      subtitle: Text(
        movie.releaseDate.isEmpty ? 'No release date' : movie.releaseDate,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildMovieSection({
    required String title,
    required List<MovieEntity> movies,
    required IconData fallbackIcon,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: movies.isEmpty
                ? const Center(child: Text('No movies available'))
                : ListView.builder(
                    itemCount: movies.length,
                    itemBuilder: (_, index) =>
                        _buildMovieTile(movies[index], fallbackIcon),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movies Repository Test')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMovieSection(
              title: 'Now Playing',
              movies: _nowPlayingMovies,
              fallbackIcon: Icons.local_fire_department_outlined,
            ),
            const SizedBox(height: 16),
            _buildMovieSection(
              title: 'Popular Movies',
              movies: _popularMovies,
              fallbackIcon: Icons.movie_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
