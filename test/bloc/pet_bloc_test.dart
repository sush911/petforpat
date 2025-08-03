import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:petforpat/features/dashboard/domain/usecases/get_pets_usecase.dart';
import 'package:petforpat/features/dashboard/domain/usecases/get_pet_usecase.dart';
import 'package:petforpat/features/dashboard/domain/entities/pet_entity.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/pet_bloc.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/pet_event.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/pet_state.dart';

import 'pet_bloc_test.mocks.dart';

@GenerateMocks([GetPetsUseCase, GetPetUseCase])
void main() {
  late MockGetPetsUseCase mockGetPetsUseCase;
  late MockGetPetUseCase mockGetPetUseCase;
  late PetBloc petBloc;
  late PetDetailBloc petDetailBloc;

  setUp(() {
    mockGetPetsUseCase = MockGetPetsUseCase();
    mockGetPetUseCase = MockGetPetUseCase();
    petBloc = PetBloc(getPetsUseCase: mockGetPetsUseCase);
    petDetailBloc = PetDetailBloc(getPetUseCase: mockGetPetUseCase);
  });

  tearDown(() {
    petBloc.close();
    petDetailBloc.close();
  });

  final pet1 = PetEntity(
    id: '1',
    name: 'Buddy',
    type: 'Dog',
    age: 3,
    sex: 'Male',
    breed: 'Beagle',
    location: 'NY',
    imageUrl: 'url1',
    ownerPhoneNumber: '1234567890',
    description: 'Friendly dog',
  );

  final pet2 = PetEntity(
    id: '2',
    name: 'Mittens',
    type: 'Cat',
    age: 2,
    sex: 'Female',
    breed: 'Siamese',
    location: 'LA',
    imageUrl: 'url2',
    ownerPhoneNumber: '0987654321',
    description: 'Cute cat',
  );

  group('PetBloc', () {
    test('initial state is PetInitial', () {
      expect(petBloc.state, PetInitial());
    });

    test('emits [PetLoading, PetLoaded] when getPetsUseCase succeeds', () async {
      when(mockGetPetsUseCase(
        search: anyNamed('search'),
        category: anyNamed('category'),
        forceRefresh: anyNamed('forceRefresh'),
      )).thenAnswer((_) async => [pet1, pet2]);

      final emitted = <PetState>[];
      final sub = petBloc.stream.listen(emitted.add);

      petBloc.add(LoadPetsEvent());

      await Future.delayed(Duration.zero);

      expect(emitted, [PetLoading(), PetLoaded([pet1, pet2])]);

      await sub.cancel();
    });

    test('emits [PetLoading, PetError] when getPetsUseCase throws', () async {
      when(mockGetPetsUseCase(
        search: anyNamed('search'),
        category: anyNamed('category'),
        forceRefresh: anyNamed('forceRefresh'),
      )).thenThrow(Exception('Error'));

      final emitted = <PetState>[];
      final sub = petBloc.stream.listen(emitted.add);

      petBloc.add(LoadPetsEvent());

      await Future.delayed(Duration.zero);

      expect(emitted.first, isA<PetLoading>());
      expect(emitted.last, isA<PetError>());

      await sub.cancel();
    });
  });

  group('PetDetailBloc', () {
    test('initial state is PetDetailInitial', () {
      expect(petDetailBloc.state, PetDetailInitial());
    });

    test('emits [PetDetailLoading, PetDetailLoaded] when getPetUseCase succeeds', () async {
      when(mockGetPetUseCase('1')).thenAnswer((_) async => pet1);

      final emitted = <PetDetailState>[];
      final sub = petDetailBloc.stream.listen(emitted.add);

      petDetailBloc.add(LoadPetDetailEvent('1'));

      await Future.delayed(Duration.zero);

      expect(emitted, [PetDetailLoading(), PetDetailLoaded(pet1)]);

      await sub.cancel();
    });

    test('emits [PetDetailLoading, PetDetailError] when getPetUseCase fails', () async {
      when(mockGetPetUseCase('1')).thenThrow(Exception('Failed to load pet'));

      final emitted = <PetDetailState>[];
      final sub = petDetailBloc.stream.listen(emitted.add);

      petDetailBloc.add(LoadPetDetailEvent('1'));

      await Future.delayed(Duration.zero);

      expect(emitted.first, isA<PetDetailLoading>());
      expect(emitted.last, isA<PetDetailError>());

      await sub.cancel();
    });
  });
}
