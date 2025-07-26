import 'dart:io';
import 'package:dio/dio.dart';
import 'package:petforpat/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthRemoteDataSource {
  Future<void> register(Map<String, dynamic> userData);
  Future<String> login(String username, String password);
  Future<UserModel> updateProfile(Map<String, dynamic> data, File? image);
  Future<UserModel> getCurrentUser();
  Future<void> loadToken();   // Load token on app start
  Future<void> clearToken(); // ✅ Clear token on logout
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  static const String _tokenKey = 'auth_token';

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<void> register(Map<String, dynamic> userData) async {
    try {
      print('📤 Sending register request: $userData');
      final response = await dio.post('/users/register', data: userData);
      print('📥 Register response: ${response.data}');
      if (response.statusCode != 200 && response.statusCode != 201) {
        final errorMessage = response.data['message'] ?? 'Registration failed';
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('❌ Register error: ${e.response?.data}');
        throw Exception(e.response?.data['message'] ?? 'Registration error');
      } else {
        print('❌ Network error during registration: ${e.message}');
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  @override
  Future<String> login(String username, String password) async {
    try {
      print('📤 Logging in with username: $username');
      final response = await dio.post('/users/login', data: {
        'username': username,
        'password': password,
      });
      print('📥 Login response: ${response.data}');
      if (response.statusCode == 200) {
        final token = response.data['token'];
        if (token != null) {
          dio.options.headers['Authorization'] = 'Bearer $token';
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_tokenKey, token);
          return token;
        } else {
          throw Exception('Invalid login response: token not found');
        }
      } else {
        throw Exception(response.data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('❌ Login error: ${e.response?.data}');
        throw Exception(e.response?.data['message'] ?? 'Login error');
      } else {
        print('❌ Network error during login: ${e.message}');
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  @override
  Future<UserModel> updateProfile(Map<String, dynamic> data, File? image) async {
    try {
      final formData = FormData.fromMap({
        ...data,
        if (image != null)
          'profileImage': await MultipartFile.fromFile(
            image.path,
            filename: 'profile.jpg',
          ),
      });

      final response = await dio.put('/users/profile', data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception(response.data['message'] ?? 'Update profile failed');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['error'] ?? 'Update profile failed');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await dio.get('/users/profile');
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch user profile');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to fetch user profile');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  @override
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    if (token != null) {
      dio.options.headers['Authorization'] = 'Bearer $token';
      print('✅ Auth token loaded and set: $token');
    } else {
      print('⚠️ No token found in storage.');
    }
  }

  @override
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    dio.options.headers.remove('Authorization');
    print('🚪 Token cleared from storage and Dio headers.');
  }
}
