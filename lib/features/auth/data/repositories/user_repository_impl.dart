import 'package:petforpat/features/auth/data/datasources/local_datasource/userlocal_datasource.dart';
import 'package:petforpat/features/auth/data/datasources/remote_datasource/userremote_datasource.dart';
import 'package:petforpat/features/auth/data/models/user_model.dart';
import 'package:petforpat/features/auth/domain/entities/register_user.dart';
import 'package:petforpat/features/auth/domain/entities/user.dart';
import 'package:petforpat/features/auth/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<void> register(RegisterUser user) async {
    final userModel = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: user.username,
      username: user.username,
      email: user.email,
      password: user.password,
      token: '',
    );

    await remoteDataSource.register(userModel);
    await localDataSource.saveUser(userModel);
  }

  @override
  Future<User?> login(String email, String password) async {
    try {
      final userModel = await remoteDataSource.login(email, password);
      await localDataSource.saveUser(userModel);
      return userModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
