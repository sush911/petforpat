import 'package:dio/dio.dart';
import '../../models/user_model.dart';

class UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSource(this.dio);

  Future<UserModel> login(String username, String password) async {
    final response = await dio.post('/login', data: {
      'username': username,
      'password': password,
    });

    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<UserModel> register(String username, String email, String password) async {
    final response = await dio.post('/register', data: {
      'username': username,
      'email': email,
      'password': password,
    });

    if (response.statusCode == 201) {
      return UserModel.fromJson(response.data);
    } else {
      throw Exception('Failed to register');
    }
  }
}
