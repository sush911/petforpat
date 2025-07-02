import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> login(String username, String password);
  Future<void> register(UserModel user);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiClient apiClient;

  UserRemoteDataSourceImpl(this.apiClient);

  @override
  Future<UserModel> login(String username, String password) async {
    final response = await apiClient.post('/auth/login', {
      'username': username,
      'password': password,
    });

    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data);
    } else {
      throw Exception('Failed to login');
    }
  }

  @override
  Future<void> register(UserModel user) async {
    final response = await apiClient.post('/auth/register', user.toJson());

    if (response.statusCode != 201) {
      throw Exception('Failed to register');
    }
  }
}
