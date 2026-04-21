import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/movies/data/datasources/movies_local_data_source_impl.dart';
import '../../features/movies/data/infra/interfaces/movies_local_data_source.dart';
import 'shared_preferences_provider.dart';

final moviesLocalDataSourceProvider = Provider<MoviesLocalDataSource>((ref) {
  final instance = ref.watch(sharedPreferencesProvider);

  return MoviesLocalDataSourceImpl(instance);
});
