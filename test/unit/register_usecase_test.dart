import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:petforpat/features/auth/domain/entities/register_user.dart';
import 'package:petforpat/features/auth/domain/usecases/register_usecase.dart';

import '../mocks/user_repository_test.mocks.dart';

void main() {
  late RegisterUseCase registerUseCase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    registerUseCase = RegisterUseCase(mockUserRepository);
  });

  test('should call register on repository with correct user', () async {
    final registerUser = RegisterUser(
      username: 'johndoe',
      email: 'john@example.com',
      password: 'password123',
    );

    // Arrange: when register is called, return Future<void>
    when(mockUserRepository.register(registerUser))
        .thenAnswer((_) async => Future.value());

    // Act
    await registerUseCase(registerUser);

    // Assert
    verify(mockUserRepository.register(registerUser)).called(1);
    verifyNoMoreInteractions(mockUserRepository);
  });
}
