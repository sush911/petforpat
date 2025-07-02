// features/auth/data/datasources/remote_datasource/user_remote_datasource.dart
import 'package:petforpat/core/network/api_client.dart';
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

    return UserModel.fromJson(response.data);
  }

  @override
  Future<void> register(UserModel user) async {
    await apiClient.post('/auth/register', user.toJson());
  }
}
