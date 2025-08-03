import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:petforpat/features/dashboard/domain/usecases/get_pets_usecase.dart';
import 'package:petforpat/features/dashboard/domain/entities/pet_entity.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/dashboard_bloc.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/dashboard_event.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/dashboard_state.dart';

import 'dashboard_bloc_test.mocks.dart'; // <-- This will work after build_runner runs

@GenerateMocks([GetPetsUseCase])
void main() {
  late MockGetPetsUseCase mockGetPetsUseCase;
  late DashboardBloc dashboardBloc;

  setUp(() {
    mockGetPetsUseCase = MockGetPetsUseCase();
    dashboardBloc = DashboardBloc(mockGetPetsUseCase);
  });

  tearDown(() {
    dashboardBloc.close();
  });

  final pets = [
    PetEntity(
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
    ),
    PetEntity(
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
    ),
  ];

  test('initial state should be DashboardInitial', () {
    expect(dashboardBloc.state, DashboardInitial());
  });

  test('emits [DashboardLoading, DashboardLoaded] when pets loaded successfully', () async {
    when(mockGetPetsUseCase.call(
      search: anyNamed('search'),
      category: anyNamed('category'),
      forceRefresh: anyNamed('forceRefresh'),
    )).thenAnswer((_) async => pets);

    final expectedStates = [
      DashboardLoading(),
      DashboardLoaded(pets),
    ];

    final emittedStates = <DashboardState>[];
    final subscription = dashboardBloc.stream.listen(emittedStates.add);

    dashboardBloc.add(LoadPetsEvent());

    await Future.delayed(Duration.zero);

    expect(emittedStates, expectedStates);

    verify(mockGetPetsUseCase.call(
      search: null,
      category: null,
      forceRefresh: false,
    )).called(1);

    await subscription.cancel();
  });

  test('emits [DashboardLoading, DashboardError] when usecase throws exception', () async {
    when(mockGetPetsUseCase.call(
      search: anyNamed('search'),
      category: anyNamed('category'),
      forceRefresh: anyNamed('forceRefresh'),
    )).thenThrow(Exception('Failed to fetch'));

    final emittedStates = <DashboardState>[];
    final subscription = dashboardBloc.stream.listen(emittedStates.add);

    dashboardBloc.add(LoadPetsEvent());

    await Future.delayed(Duration.zero);

    expect(emittedStates.length, 2);
    expect(emittedStates[0], DashboardLoading());
    expect(emittedStates[1], isA<DashboardError>());

    await subscription.cancel();
  });
}
