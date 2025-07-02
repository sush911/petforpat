import '../../domain/entities/register_user.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/remote_datasource/userremote_datasource.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> register(RegisterUser user) async {
    final userModel = UserModel(
      id: '',  // leave empty, backend assigns id
      username: user.username,
      email: user.email,
      password: user.password,
      token: '',
    );

    await remoteDataSource.register(userModel);
  }

  @override
  Future<User?> login(String username, String password) async {
    final userModel = await remoteDataSource.login(username, password);
    return userModel.toEntity();
  }
}
