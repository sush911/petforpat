import '../entities/user.dart';
import '../repositories/user_repository.dart';

class LoginUseCase {
  final UserRepository repository;

  LoginUseCase(this.repository);

  Future<User?> call(String email, String password) {
    return repository.login(email, password);
  }
}
