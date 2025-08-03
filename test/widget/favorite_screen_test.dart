/* // test/widget/favorite_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:petforpat/features/favorite/presentation/view_models/favorite_cubit.dart';
import 'package:petforpat/features/favorite/presentation/view_models/favorite_state.dart';
import 'package:petforpat/features/dashboard/domain/entities/pet_entity.dart';
import 'package:petforpat/features/favorite/presentation/views/favorite_screen.dart';
import 'package:petforpat/app/theme/theme_cubit.dart';

// Mocks
class MockFavoriteCubit extends Mock implements FavoriteCubit {}
class MockThemeCubit extends Mock implements ThemeCubit {}

void main() {
  late MockFavoriteCubit favoriteCubit;
  late MockThemeCubit themeCubit;

  setUp(() {
    favoriteCubit = MockFavoriteCubit();
    themeCubit = MockThemeCubit();

    // Return light ThemeData as your ThemeCubit emits ThemeData, not ThemeMode
    when(() => themeCubit.state).thenReturn(
      ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.teal,
      ),
    );

    // Stub toggleTheme to do nothing
    when(() => themeCubit.toggleTheme()).thenAnswer((_) async {});
  });

  // Helper PetEntity for testing
  final pet = PetEntity(
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

  testWidgets('renders loading indicator when loading', (tester) async {
    when(() => favoriteCubit.state).thenReturn(FavoriteState(loading: true));

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<FavoriteCubit>.value(value: favoriteCubit),
          BlocProvider<ThemeCubit>.value(value: themeCubit),
        ],
        child: const MaterialApp(home: FavoriteScreen()),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders error message when error occurs', (tester) async {
    when(() => favoriteCubit.state).thenReturn(FavoriteState(error: 'Error occurred'));

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<FavoriteCubit>.value(value: favoriteCubit),
          BlocProvider<ThemeCubit>.value(value: themeCubit),
        ],
        child: const MaterialApp(home: FavoriteScreen()),
      ),
    );

    expect(find.text('Error occurred'), findsOneWidget);
  });

  testWidgets('renders no favorites text when list is empty', (tester) async {
    when(() => favoriteCubit.state).thenReturn(FavoriteState(pets: []));

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<FavoriteCubit>.value(value: favoriteCubit),
          BlocProvider<ThemeCubit>.value(value: themeCubit),
        ],
        child: const MaterialApp(home: FavoriteScreen()),
      ),
    );

    expect(find.text('No favorites yet.'), findsOneWidget);
  });

  testWidgets('renders list of favorite pets', (tester) async {
    when(() => favoriteCubit.state).thenReturn(FavoriteState(pets: [pet]));

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<FavoriteCubit>.value(value: favoriteCubit),
          BlocProvider<ThemeCubit>.value(value: themeCubit),
        ],
        child: const MaterialApp(home: FavoriteScreen()),
      ),
    );

    expect(find.text('Buddy'), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsOneWidget);
  });

  testWidgets('toggleTheme is called when theme icon button tapped', (tester) async {
    when(() => favoriteCubit.state).thenReturn(FavoriteState(pets: []));

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<FavoriteCubit>.value(value: favoriteCubit),
          BlocProvider<ThemeCubit>.value(value: themeCubit),
        ],
        child: const MaterialApp(home: FavoriteScreen()),
      ),
    );

    final themeToggleButton = find.byIcon(Icons.nightlight_round);
    expect(themeToggleButton, findsOneWidget);

    await tester.tap(themeToggleButton);
    await tester.pump();

    verify(() => themeCubit.toggleTheme()).called(1);
  });

  testWidgets('delete icon calls toggleFavorite', (tester) async {
    when(() => favoriteCubit.state).thenReturn(FavoriteState(pets: [pet]));
    when(() => favoriteCubit.toggleFavorite(pet)).thenAnswer((_) async {});

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<FavoriteCubit>.value(value: favoriteCubit),
          BlocProvider<ThemeCubit>.value(value: themeCubit),
        ],
        child: const MaterialApp(home: FavoriteScreen()),
      ),
    );

    final deleteButton = find.byIcon(Icons.delete);
    expect(deleteButton, findsOneWidget);

    await tester.tap(deleteButton);
    await tester.pump();

    verify(() => favoriteCubit.toggleFavorite(pet)).called(1);
  });
}
 */