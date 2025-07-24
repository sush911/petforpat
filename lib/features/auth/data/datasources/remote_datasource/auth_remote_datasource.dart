import 'package:dio/dio.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<void> register(Map<String, dynamic> userData) async {
    try {
      final response = await dio.post('/register', data: userData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Optional: check if response.data contains any message
        return;
      } else {
        final errorMessage = response.data['message'] ?? 'Registration failed';
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final error = e.response?.data['message'] ?? 'Registration error';
        throw Exception(error);
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  Future<String> login(String username, String password) async {
    try {
      final response = await dio.post('/login', data: {
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200) {
        final token = response.data['token'];
        if (token != null) {
          return token;
        } else {
          throw Exception('Invalid login response: token not found');
        }
      } else {
        throw Exception('Login failed: ${response.data['message']}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Login error');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }
}
