import 'package:petforpat/features/auth/data/datasources/remote_datasource/auth_remote_datasource.dart';
import 'package:petforpat/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> register(Map<String, dynamic> userData) {
    return remoteDataSource.register(userData);
  }

  @override
  Future<String> login(String username, String password) {
    return remoteDataSource.login(username, password);
  }
}
