import 'package:dio/dio.dart';
import 'package:riverpod/riverpod.dart';

export 'package:dio/dio.dart' show DioError;

typedef DioOptions = Options;

final dioProvider = Provider((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:4000',
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (DioError e, handler) {
        // TODO: Handle DioErrorType.other errors
        return handler.next(e);
      },
    ),
  );

  return dio;
});
