import 'package:dio/dio.dart';

class HttpClient {
  final Dio _dio = Dio();

  Future<Response> get(String path) async {
    return await _dio.get(path);
  }
}
