import 'package:petforpat/core/network/api_client.dart';
import 'package:petforpat/features/auth/data/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<void> register(UserModel user);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiClient apiClient;

  UserRemoteDataSourceImpl(this.apiClient);

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await apiClient.post('/login', {
      'email': email, // ✅ Changed from 'username' to 'email'
      'password': password,
    });

    return UserModel.fromJson(response.data);
  }

  @override
  Future<void> register(UserModel user) async {
    await apiClient.post('/register', {
      'name': user.name,
      'email': user.email,
      'password': user.password,
    });
  }
}
