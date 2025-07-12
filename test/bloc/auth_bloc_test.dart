import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';  // Use hive_test package to initialize Hive in memory

import 'package:petforpat/features/auth/domain/entities/user.dart';
import 'package:petforpat/features/auth/domain/usecases/login_usecase.dart';
import 'package:petforpat/features/auth/domain/usecases/register_usecase.dart';

import '../../lib/features/auth/presentation/view_models/auth_bloc.dart';
;

// Mock classes
class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockRegisterUseCase extends Mock implements RegisterUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthBloc authBloc;
  late MockLoginUseCase mockLoginUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late Box box;

  setUp(() async {
    // Initialize Hive in memory before each test
    await setUpTestHive();

    box = await Hive.openBox('profileInstalled');

    mockLoginUseCase = MockLoginUseCase();
    mockRegisterUseCase = MockRegisterUseCase();

    authBloc = AuthBloc(
      loginUseCase: mockLoginUseCase,
      registerUseCase: mockRegisterUseCase,
      profileBox: box,  // Inject in-memory box
    );
  });

  tearDown(() async {
    await box.close();
    await tearDownTestHive();
  });

  group('AuthBloc login tests', () {
    final testUser = User(
      id: '1',
      name: 'Test User',
      username: 'testuser',
      email: 'test@example.com',
      token: 'abc123token',
    );

    test('emits [AuthLoading, AuthSuccess] when login succeeds', () async {
      when(() => mockLoginUseCase.call('test@example.com', 'password'))
          .thenAnswer((_) async => testUser);

      // Listen for emitted states
      final expectedStates = [
        const AuthLoading(),
        AuthSuccess(testUser),
      ];

      expectLater(authBloc.stream, emitsInOrder(expectedStates));

      authBloc.add(const LoginRequested('test@example.com', 'password'));
    });

    test('emits [AuthLoading, AuthFailure] when login fails', () async {
      when(() => mockLoginUseCase.call('test@example.com', 'wrongpassword'))
          .thenAnswer((_) async => null);

      final expectedStates = [
        const AuthLoading(),
        const AuthFailure('Invalid email or password'),
      ];

      expectLater(authBloc.stream, emitsInOrder(expectedStates));

      authBloc.add(const LoginRequested('test@example.com', 'wrongpassword'));
    });
  });
}
