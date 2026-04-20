import '../../../../../core/utils/constants.dart';

class TmdbConfigurationModel {
  const TmdbConfigurationModel({
    required this.secureBaseUrl,
    required this.posterSizes,
    required this.backdropSizes,
  });

  final String secureBaseUrl;
  final List<String> posterSizes;
  final List<String> backdropSizes;

  String resolvePosterSize() {
    if (posterSizes.contains(Settings.defaultPosterSize)) {
      return Settings.defaultPosterSize;
    }

    if (posterSizes.isNotEmpty) {
      return posterSizes.last;
    }

    return Settings.defaultPosterSize;
  }

  String resolveBackdropSize() {
    if (backdropSizes.contains(Settings.defaultBackdropSize)) {
      return Settings.defaultBackdropSize;
    }

    if (backdropSizes.isNotEmpty) {
      return backdropSizes.last;
    }

    return Settings.defaultBackdropSize;
  }
}
