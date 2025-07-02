
import '../entities/register_user.dart';
import '../repositories/user_repository.dart';

class RegisterUseCase {
  final UserRepository repository;

  RegisterUseCase(this.repository);

  Future<void> call(RegisterUser user) {
    return repository.register(user);
  }
}
