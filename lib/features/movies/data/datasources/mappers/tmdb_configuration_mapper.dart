import '../../../../../core/utils/constants.dart';
import '../models/tmdb_configuration_model.dart';

class TmdbConfigurationMapper {
  static TmdbConfigurationModel fromMap(Map<String, dynamic> map) {
    final images = map['images'];

    if (images is! Map<String, dynamic>) {
      return const TmdbConfigurationModel(
        secureBaseUrl: 'https://image.tmdb.org/t/p/',
        posterSizes: <String>[Settings.defaultPosterSize],
        backdropSizes: <String>[Settings.defaultBackdropSize],
      );
    }

    final secureBaseUrl =
        (images['secure_base_url'] as String?)?.trim().isNotEmpty == true
        ? images['secure_base_url'] as String
        : 'https://image.tmdb.org/t/p/';

    final posterSizes = (images['poster_sizes'] as List<dynamic>? ?? const [])
        .whereType<String>()
        .toList();

    final backdropSizes =
        (images['backdrop_sizes'] as List<dynamic>? ?? const [])
            .whereType<String>()
            .toList();

    return TmdbConfigurationModel(
      secureBaseUrl: secureBaseUrl,
      posterSizes: posterSizes.isNotEmpty
          ? posterSizes
          : const <String>[Settings.defaultPosterSize],
      backdropSizes: backdropSizes.isNotEmpty
          ? backdropSizes
          : const <String>[Settings.defaultBackdropSize],
    );
  }
}
