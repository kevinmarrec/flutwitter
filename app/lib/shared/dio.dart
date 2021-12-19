import 'package:dio/dio.dart';
import 'package:riverpod/riverpod.dart';

final dioProvider = Provider(
  (ref) => Dio(
    BaseOptions(
      baseUrl: 'http://localhost:4000',
    ),
  ),
);
