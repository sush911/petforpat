/* // test/widget/pet_detail_page_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:petforpat/features/dashboard/domain/entities/pet_entity.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/pet_bloc.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/pet_event.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/pet_state.dart';
import 'package:petforpat/features/favorite/presentation/view_models/favorite_cubit.dart';
import 'package:petforpat/features/favorite/presentation/views/favorite_screen.dart';
import 'package:petforpat/features/adoption/presentation/views/adoption_screen.dart';
import 'package:petforpat/features/dashboard/presentation/views/pet_detail_page.dart';

class MockPetDetailBloc extends Mock implements PetDetailBloc {}
class FakePetDetailEvent extends Fake implements PetDetailEvent {}
class FakePetDetailState extends Fake implements PetDetailState {}

class MockFavoriteCubit extends Mock implements FavoriteCubit {}

void main() {
  late MockPetDetailBloc petDetailBloc;
  late MockFavoriteCubit favoriteCubit;

  setUpAll(() {
    registerFallbackValue(FakePetDetailEvent());
    registerFallbackValue(FakePetDetailState());
  });

  setUp(() {
    petDetailBloc = MockPetDetailBloc();
    favoriteCubit = MockFavoriteCubit();
  });

  final testPet = PetEntity(
    id: '1',
    name: 'Buddy',
    type: 'Dog',
    age: 3,
    sex: 'Male',
    breed: 'Golden Retriever',
    location: 'New York',
    imageUrl: '/images/buddy.jpg',
    ownerPhoneNumber: '1234567890',
    description: 'Friendly dog',
  );

  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PetDetailBloc>.value(value: petDetailBloc),
        BlocProvider<FavoriteCubit>.value(value: favoriteCubit),
      ],
      child: const MaterialApp(
        home: PetDetailPage(petId: '1'),
      ),
    );
  }

  testWidgets('dispatches LoadPetDetailEvent on init', (tester) async {
    when(() => petDetailBloc.state).thenReturn(PetDetailLoading());
    when(() => petDetailBloc.add(any())).thenReturn(null);

    when(() => favoriteCubit.isFavorite(any())).thenAnswer((_) async => false);

    await tester.pumpWidget(createWidgetUnderTest());

    verify(() => petDetailBloc.add(LoadPetDetailEvent('1'))).called(1);
  });

  testWidgets('shows loading indicator when state is PetDetailLoading', (tester) async {
    when(() => petDetailBloc.state).thenReturn(PetDetailLoading());
    when(() => favoriteCubit.isFavorite(any())).thenAnswer((_) async => false);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // Start frame

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message when state is PetDetailError', (tester) async {
    when(() => petDetailBloc.state).thenReturn(PetDetailError('Error loading pet'));
    when(() => favoriteCubit.isFavorite(any())).thenAnswer((_) async => false);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('Error: Error loading pet'), findsOneWidget);
  });

  testWidgets('displays pet details when state is PetDetailLoaded', (tester) async {
    when(() => petDetailBloc.state).thenReturn(PetDetailLoaded(testPet));
    when(() => favoriteCubit.isFavorite(testPet.id)).thenAnswer((_) async => true);
    when(() => favoriteCubit.toggleFavorite(testPet)).thenAnswer((_) async {});

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // For FutureBuilder

    expect(find.text('Buddy'), findsOneWidget);
    expect(find.text('Golden Retriever'), findsOneWidget);
    expect(find.text('3 years'), findsOneWidget);
    expect(find.text('Male'), findsOneWidget);
    expect(find.text('New York'), findsOneWidget);
    expect(find.text('1234567890'), findsOneWidget);
    expect(find.text('Friendly dog'), findsOneWidget);

    // Favorite icon should be filled because isFavorite = true
    final favoriteIcon = find.byIcon(Icons.favorite);
    expect(favoriteIcon, findsOneWidget);

    // Adopt button present
    expect(find.text('Adopt'), findsOneWidget);
  });

  testWidgets('tapping favorite button toggles favorite and shows snackbar', (tester) async {
    when(() => petDetailBloc.state).thenReturn(PetDetailLoaded(testPet));
    when(() => favoriteCubit.isFavorite(testPet.id)).thenAnswer((_) async => false);
    when(() => favoriteCubit.toggleFavorite(testPet)).thenAnswer((_) async {});

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // FutureBuilder

    final favoriteButton = find.widgetWithIcon(ElevatedButton, Icons.favorite_border);
    expect(favoriteButton, findsOneWidget);

    await tester.tap(favoriteButton);
    await tester.pump(); // Rebuild UI after setState

    verify(() => favoriteCubit.toggleFavorite(testPet)).called(1);
  });

  testWidgets('tapping adopt button navigates to AdoptionScreen', (tester) async {
    when(() => petDetailBloc.state).thenReturn(PetDetailLoaded(testPet));
    when(() => favoriteCubit.isFavorite(testPet.id)).thenAnswer((_) async => false);
    when(() => favoriteCubit.toggleFavorite(testPet)).thenAnswer((_) async {});

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    final adoptButton = find.widgetWithIcon(ElevatedButton, Icons.pets);
    expect(adoptButton, findsOneWidget);

    await tester.tap(adoptButton);
    await tester.pumpAndSettle();

    expect(find.byType(AdoptionScreen), findsOneWidget);
    expect(find.text('Buddy'), findsOneWidget);
  });

  testWidgets('app bar buttons navigate correctly and show snackbar', (tester) async {
    when(() => petDetailBloc.state).thenReturn(PetDetailLoaded(testPet));
    when(() => favoriteCubit.isFavorite(testPet.id)).thenAnswer((_) async => false);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Tap favorite icon button in app bar - should navigate to FavoriteScreen
    final favoriteIconButton = find.byTooltip('Favorites');
    expect(favoriteIconButton, findsOneWidget);
    await tester.tap(favoriteIconButton);
    await tester.pumpAndSettle();

    expect(find.byType(FavoriteScreen), findsOneWidget);

    // Go back
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Tap adoption icon button - should show snackbar because no pet info passed
    final adoptionIconButton = find.byTooltip('Adoption');
    expect(adoptionIconButton, findsOneWidget);

    await tester.tap(adoptionIconButton);
    await tester.pump(); // Start snackbar animation

    expect(find.text('Please open a pet detail to adopt!'), findsOneWidget);
  });
}
   */