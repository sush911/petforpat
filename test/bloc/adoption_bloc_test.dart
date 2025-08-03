import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:petforpat/features/adoption/domain/entities/adoption_request.dart';
import 'package:petforpat/features/adoption/domain/usecases/submit_adoption_request.dart';
import 'package:petforpat/features/adoption/presentation/view_models/adoption_bloc.dart';
import 'package:petforpat/features/adoption/presentation/view_models/adoption_event.dart';
import 'package:petforpat/features/adoption/presentation/view_models/adoption_state.dart';

import 'adoption_bloc_test.mocks.dart';

@GenerateMocks([SubmitAdoptionRequestUseCase])
void main() {
  late MockSubmitAdoptionRequestUseCase mockUseCase;
  late AdoptionBloc adoptionBloc;

  setUp(() {
    mockUseCase = MockSubmitAdoptionRequestUseCase();
    adoptionBloc = AdoptionBloc(mockUseCase);
  });

  tearDown(() {
    adoptionBloc.close();
  });

  final request = AdoptionRequest(
    petId: '1',
    petName: 'Buddy',
    petType: 'Dog',
    fullName: 'John Doe',
    citizenshipNumber: '1234567890',
    phoneNumber: '9876543210',
    email: 'john@example.com',
    homeAddress: '123 Dog Street',
    reason: 'I love dogs!',
  );

  test('initial state is AdoptionInitial', () {
    expect(adoptionBloc.state, equals(AdoptionInitial()));
  });

  blocTest<AdoptionBloc, AdoptionState>(
    'emits [AdoptionLoading, AdoptionSuccess] when submission is successful',
    build: () {
      when(mockUseCase.call(request)).thenAnswer((_) async {});
      return adoptionBloc;
    },
    act: (bloc) => bloc.add(SubmitAdoptionEvent(request)),
    expect: () => [AdoptionLoading(), AdoptionSuccess()],
    verify: (_) => verify(mockUseCase.call(request)).called(1),
  );

  blocTest<AdoptionBloc, AdoptionState>(
    'emits [AdoptionLoading, AdoptionError] when submission fails',
    build: () {
      when(mockUseCase.call(request)).thenThrow(Exception('Submission failed'));
      return adoptionBloc;
    },
    act: (bloc) => bloc.add(SubmitAdoptionEvent(request)),
    expect: () => [
      AdoptionLoading(),
      isA<AdoptionError>().having((e) => e.message, 'message', contains('Submission failed'))
    ],
    verify: (_) => verify(mockUseCase.call(request)).called(1),
  );
}
