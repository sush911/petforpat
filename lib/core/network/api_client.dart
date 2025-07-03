import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio) {
    _dio.options.baseUrl = "http://10.0.2.2:5000/api";
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('REQUEST[${options.method}] => PATH: ${options.baseUrl}${options.path}');
        print('DATA: ${options.data}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        print('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
        handler.next(response);
      },
      onError: (DioError e, handler) {
        print('ERROR[${e.response?.statusCode}] => MESSAGE: ${e.message}');
        handler.next(e);
      },
    ));
  }

  Future<Response> post(String path, dynamic data) async {
    return _dio.post(path, data: data);
  }

  Future<Response> get(String path) async {
    return _dio.get(path);
  }
}
