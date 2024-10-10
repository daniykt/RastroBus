import 'package:dio/dio.dart';
import 'package:flutter_loggy_dio/flutter_loggy_dio.dart';

Dio buildDioClient(String base) {
  final dio = Dio()..options = BaseOptions(baseUrl: base);

  dio.interceptors.addAll(
    [
      //TokenInterceptor(),
      LoggyDioInterceptor(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ),
    ],
  );

  return dio;
}
