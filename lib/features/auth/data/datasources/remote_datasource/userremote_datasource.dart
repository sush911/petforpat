import 'package:dio/dio.dart';
import '../../models/user_model.dart';

class UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSource({required this.dio});

  Future<UserModel> login(String email, String password) async {
    final response = await dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });

    return UserModel.fromJson(response.data['user']);
  }

  Future<UserModel> register(String name, String email, String password) async {
    final response = await dio.post('/auth/register', data: {
      'name': name,
      'email': email,
      'password': password,
    });

    return UserModel.fromJson(response.data['user']);
  }
}
