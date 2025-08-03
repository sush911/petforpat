import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:petforpat/features/auth/presentation/view_models/auth_bloc.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_event.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_state.dart';
import 'package:petforpat/features/auth/domain/repositories/auth_repository.dart';
import 'package:petforpat/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:petforpat/features/auth/domain/entities/user_entity.dart';

import 'auth_bloc_test.mocks.dart';



@GenerateMocks([AuthRepository, UpdateProfileUseCase])
void main() {
  late MockAuthRepository mockAuthRepository;
  late MockUpdateProfileUseCase mockUpdateProfileUseCase;
  late AuthBloc authBloc;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockUpdateProfileUseCase = MockUpdateProfileUseCase();

    authBloc = AuthBloc(
      authRepository: mockAuthRepository,
      updateProfileUseCase: mockUpdateProfileUseCase,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when login succeeds',
      build: () {
        when(mockAuthRepository.login('user', 'pass'))
            .thenAnswer((_) async => 'mock_token');
        return authBloc;
      },
      act: (bloc) => bloc.add(LoginRequested(username: 'user', password: 'pass')),
      expect: () => [
        AuthLoading(),
        AuthAuthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when login fails',
      build: () {
        when(mockAuthRepository.login('user', 'wrong'))
            .thenThrow(Exception('Invalid credentials'));
        return authBloc;
      },
      act: (bloc) => bloc.add(LoginRequested(username: 'user', password: 'wrong')),
      expect: () => [
        AuthLoading(),
        isA<AuthError>(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when registration succeeds',
      build: () {
        when(mockAuthRepository.register(any)).thenAnswer((_) async => Future.value());
        return authBloc;
      },
      act: (bloc) {
        final userData = {
          'id': '1',
          'username': 'newuser',
          'email': 'newuser@example.com',
          'phoneNumber': '1234567890',
          'firstName': 'John',
          'lastName': 'Doe',
          'address': '123 Main St',
        };
        bloc.add(RegisterRequested(userData: userData));
      },
      expect: () => [
        AuthLoading(),
        AuthAuthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthProfileUpdated] when profile is fetched successfully',
      build: () {
        final user = UserEntity(
          id: '1',
          username: 'user1',
          email: 'user1@example.com',
          phoneNumber: '1234567890',
          firstName: 'Jane',
          lastName: 'Smith',
          address: '456 Elm St',
          profileImage: '/images/avatar.jpg',
        );
        when(mockAuthRepository.getCurrentUser()).thenAnswer((_) async => user);
        return authBloc;
      },
      act: (bloc) => bloc.add(FetchProfileEvent()),
      expect: () => [
        AuthLoading(),
        isA<AuthProfileUpdated>(),
      ],
    );
  });
}
