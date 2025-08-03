/* import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:petforpat/features/adoption/domain/entities/adoption_request.dart';
import 'package:petforpat/features/adoption/presentation/view_models/adoption_bloc.dart';
import 'package:petforpat/features/adoption/presentation/view_models/adoption_event.dart';
import 'package:petforpat/features/adoption/presentation/view_models/adoption_state.dart';
import 'package:petforpat/features/adoption/presentation/views/adoption_screen.dart';
import 'package:bloc_test/bloc_test.dart';

class MockAdoptionBloc extends MockBloc<AdoptionEvent, AdoptionState>
    implements AdoptionBloc {}

void main() {
  late MockAdoptionBloc mockBloc;

  setUp(() {
    mockBloc = MockAdoptionBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AdoptionBloc>.value(
        value: mockBloc,
        child: const AdoptionScreen(
          petId: 'pet123',
          petName: 'Buddy',
          petType: 'Dog',
        ),
      ),
    );
  }

  testWidgets('renders all form fields and submits valid form', (tester) async {
    when(() => mockBloc.state).thenReturn(AdoptionInitial());
    whenListen(mockBloc, Stream<AdoptionState>.empty());

    await tester.pumpWidget(createWidgetUnderTest());

    // Fill form fields
    await tester.enterText(find.byKey(const Key('Full Name')), 'John Doe');
    await tester.enterText(find.byKey(const Key('Citizenship Number')), '123456789');
    await tester.enterText(find.byKey(const Key('Phone Number')), '9876543210');
    await tester.enterText(find.byKey(const Key('Email')), 'john@example.com');
    await tester.enterText(find.byKey(const Key('Home Address')), '123 Main St');
    await tester.enterText(find.byKey(const Key('Reason for Adoption')), 'I love animals.');

    // Check checkboxes
    await tester.tap(find.text('I accept the terms and conditions'));
    await tester.pump();
    await tester.tap(find.text('Information is correct'));
    await tester.pump();

    // Submit form
    await tester.tap(find.text('Submit Adoption Request'));
    await tester.pump();

    // Verify that SubmitAdoptionEvent is added
    verify(
          () => mockBloc.add(
        SubmitAdoptionEvent(
          AdoptionRequest(
            petId: 'pet123',
            petName: 'Buddy',
            petType: 'Dog',
            fullName: 'John Doe',
            citizenshipNumber: '123456789',
            phoneNumber: '9876543210',
            email: 'john@example.com',
            homeAddress: '123 Main St',
            reason: 'I love animals.',
          ),
        ),
      ),
    ).called(1);
  });

  testWidgets('shows error snackbar when checkboxes not checked', (tester) async {
    when(() => mockBloc.state).thenReturn(AdoptionInitial());
    whenListen(mockBloc, Stream<AdoptionState>.empty());

    await tester.pumpWidget(createWidgetUnderTest());

    // Fill form fields
    await tester.enterText(find.byKey(const Key('Full Name')), 'John Doe');
    await tester.enterText(find.byKey(const Key('Citizenship Number')), '123456789');
    await tester.enterText(find.byKey(const Key('Phone Number')), '9876543210');
    await tester.enterText(find.byKey(const Key('Email')), 'john@example.com');
    await tester.enterText(find.byKey(const Key('Home Address')), '123 Main St');
    await tester.enterText(find.byKey(const Key('Reason for Adoption')), 'I love animals.');

    // Don't check any boxes

    // Tap submit
    await tester.tap(find.text('Submit Adoption Request'));
    await tester.pump();

    // Expect a snackbar
    expect(find.text('Please accept terms and confirm information is correct'), findsOneWidget);
  });
} */
