import 'package:dio/dio.dart';
import 'package:riverpod/riverpod.dart';

export 'package:dio/dio.dart' show DioError;

final dioProvider = Provider(
  (ref) => Dio(
    BaseOptions(
      baseUrl: 'http://localhost:4000',
    ),
  ),
);
