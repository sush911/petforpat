// user_repository_impl.dart
import '../../domain/entities/register_user.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/local_datasource/userlocal_datasource.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl(this.localDataSource);

  @override
  Future<void> register(RegisterUser user) async {
    final existingUser = localDataSource.getUser(user.username);
    if (existingUser != null) {
      throw Exception('User already exists');
    }

    final userModel = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: user.username,
      email: user.email,
      password: user.password,
      token: 'dummy_token', // replace with actual token logic if available
    );

    await localDataSource.saveUser(userModel);
  }

  @override
  Future<User?> login(String username, String password) async {
    final userModel = localDataSource.getUser(username);
    if (userModel == null) {
      return null;
    }

    if (userModel.password == password) {
      return userModel.toEntity();
    }

    return null;
  }
}
