import '../entities/user.dart';
import '../repositories/user_repository.dart';

class RegisterUseCase {
  final UserRepository repository;

  RegisterUseCase(this.repository);

  Future<void> call(User user) async {
    await repository.register(user);
  }
}
