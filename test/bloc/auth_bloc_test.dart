import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:petforpat/features/auth/domain/entities/user.dart';
import 'package:petforpat/features/auth/domain/entities/register_user.dart';
import 'package:petforpat/features/auth/domain/usecases/login_usecase.dart';
import 'package:petforpat/features/auth/domain/usecases/register_usecase.dart';

import '../../lib/app/shared_pref/shared_pref_service.dart';
import '../../lib/features/auth/presentation/view_models/auth_bloc.dart';

// Mock classes using Mockito
class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockRegisterUseCase extends Mock implements RegisterUseCase {}
class MockSharedPrefService extends Mock implements SharedPrefService {}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockSharedPrefService mockSharedPrefService;
  late AuthBloc authBloc;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockRegisterUseCase = MockRegisterUseCase();
    mockSharedPrefService = MockSharedPrefService();
    authBloc = AuthBloc(
      loginUseCase: mockLoginUseCase,
      registerUseCase: mockRegisterUseCase,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc Tests', () {
    // Test: Successful Login
    test('emits AuthLoading and AuthSuccess on successful login', () async {
      final user = User(id: '1', name: 'John Doe', username: 'john_doe', email: 'john@example.com', token: 'token');

      // Correctly mock the loginUseCase to return a Future<User?> object
      when(mockLoginUseCase('john@example.com', 'password'))
          .thenAnswer((_) async => user);

      final expected = [
        AuthLoading(),
        AuthSuccess(user),
      ];

      // Act & Assert
      expectLater(authBloc.stream, emitsInOrder(expected));

      // Trigger event
      authBloc.add(LoginRequested('john@example.com', 'password'));
    });

    // Test: Failed Login
    test('emits AuthLoading and AuthFailure on login failure', () async {
      when(mockLoginUseCase('john@example.com', 'wrong_password'))
          .thenThrow(Exception('Login failed'));

      final expected = [
        AuthLoading(),
        AuthFailure('Login failed'),
      ];

      // Act & Assert
      expectLater(authBloc.stream, emitsInOrder(expected));

      // Trigger event
      authBloc.add(LoginRequested('john@example.com', 'wrong_password'));
    });

    // Test: Successful Registration
    test('emits AuthLoading and RegisterSuccess on successful registration', () async {
      final registerUser = RegisterUser(username: 'john_doe', email: 'john@example.com', password: 'password');

      // Correctly mock registerUseCase
      when(mockRegisterUseCase(registerUser)).thenAnswer((_) async => {});

      final expected = [
        AuthLoading(),
        RegisterSuccess(),
      ];

      // Act & Assert
      expectLater(authBloc.stream, emitsInOrder(expected));

      // Trigger event
      authBloc.add(RegisterRequested(registerUser));
    });

    // Test: Failed Registration
    test('emits AuthLoading and AuthFailure on registration failure', () async {
      final registerUser = RegisterUser(username: 'john_doe', email: 'john@example.com', password: 'password');

      when(mockRegisterUseCase(registerUser)).thenThrow(Exception('Registration failed'));

      final expected = [
        AuthLoading(),
        AuthFailure('Registration failed'),
      ];

      // Act & Assert
      expectLater(authBloc.stream, emitsInOrder(expected));

      // Trigger event
      authBloc.add(RegisterRequested(registerUser));
    });
  });
}
