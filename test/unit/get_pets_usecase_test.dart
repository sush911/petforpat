import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:petforpat/features/dashboard/domain/entities/pet_entity.dart';
import 'package:petforpat/features/dashboard/domain/repositories/pet_repository.dart';
import 'package:petforpat/features/dashboard/domain/usecases/get_pets_usecase.dart';

// Mock class generated using mockito
class MockPetRepository extends Mock implements PetRepository {}

void main() {
  late GetPetsUseCase usecase;
  late MockPetRepository mockPetRepository;

  setUp(() {
    mockPetRepository = MockPetRepository();
    usecase = GetPetsUseCase(mockPetRepository);
  });

  final tPets = <PetEntity>[
    // You can create dummy PetEntity instances here or use a mock
  ];

  test('should get list of pets from repository without parameters', () async {
    // arrange
    when(mockPetRepository.getPets(
      search: null,
      category: null,
      forceRefresh: false,
    )).thenAnswer((_) async => tPets);

    // act
    final result = await usecase.call();

    // assert
    expect(result, tPets);
    verify(mockPetRepository.getPets(
      search: null,
      category: null,
      forceRefresh: false,
    ));
    verifyNoMoreInteractions(mockPetRepository);
  });

  test('should get list of pets with parameters', () async {
    // arrange
    const search = 'dog';
    const category = 'puppies';
    const forceRefresh = true;

    when(mockPetRepository.getPets(
      search: search,
      category: category,
      forceRefresh: forceRefresh,
    )).thenAnswer((_) async => tPets);

    // act
    final result = await usecase.call(
      search: search,
      category: category,
      forceRefresh: forceRefresh,
    );

    // assert
    expect(result, tPets);
    verify(mockPetRepository.getPets(
      search: search,
      category: category,
      forceRefresh: forceRefresh,
    ));
    verifyNoMoreInteractions(mockPetRepository);
  });
}
