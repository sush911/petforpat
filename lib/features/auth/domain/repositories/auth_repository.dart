abstract class AuthRepository {
  Future<void> register(Map<String, dynamic> userData);
  Future<String> login(String username, String password);
}
