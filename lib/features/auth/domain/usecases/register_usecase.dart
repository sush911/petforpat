import '../entities/register_user.dart';
import '../repositories/user_repository.dart';

class RegisterUseCase {
  final UserRepository repository;

  RegisterUseCase(this.repository);

  Future<void> call(RegisterUser registerUser) async {
    await repository.register(registerUser);
  }
}
