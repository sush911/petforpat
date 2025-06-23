// user_repository.dart
import '../entities/register_user.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<void> register(RegisterUser user); // Make sure this matches
  Future<User?> login(String username, String password);
}
