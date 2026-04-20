import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/custom_dio/custom_dio.dart';
import '../network/interfaces/i_http_client.dart';
import '../utils/constants.dart';
import 'dio_provider.dart';

final httpClientProvider = Provider<IHttpClient>((ref) {
  final dio = ref.watch(dioProvider);
  return CustomDio(dio, Settings.baseUrl);
});
