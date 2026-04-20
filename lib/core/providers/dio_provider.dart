import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/constants.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      headers: <String, String>{
        'Authorization': 'Bearer ${Settings.tmdbReadAccessToken}',
        'Content-Type': 'application/json;charset=utf-8',
      },
    ),
  );
});
