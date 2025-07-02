import '../entities/user.dart';
import '../repositories/user_repository.dart';

class LoginUseCase {
  final UserRepository repository;

  LoginUseCase(this.repository);

  Future<User?> call(String username, String password) {
    return repository.login(username, password);
  }
}
