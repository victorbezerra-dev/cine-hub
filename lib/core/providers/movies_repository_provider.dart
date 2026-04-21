import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/movies/data/infra/tmdb_movies_repository_impl.dart';
import '../../features/movies/domain/repositories/movies_repository.dart';
import 'connectivity_provider.dart';
import 'movies_local_data_source_provider.dart';
import 'movies_remote_data_source_provider.dart';

final moviesRepositoryProvider = Provider<MoviesRepository>((ref) {
  final remoteDataSource = ref.watch(moviesRemoteDataSourceProvider);
  final localDataSource = ref.watch(moviesLocalDataSourceProvider);
  final connectivityService = ref.watch(connectivityServiceProvider);

  return TmdbMoviesRepositoryImpl(
    remoteDataSource,
    localDataSource,
    connectivityService,
  );
});
