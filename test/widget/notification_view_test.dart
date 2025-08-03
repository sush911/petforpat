/*
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petforpat/features/notification/presentation/view_models/notification_bloc.dart';
import 'package:petforpat/features/notification/presentation/view_models/notification_state.dart';
import 'package:petforpat/features/notification/presentation/view_models/notification_event.dart';
import 'package:petforpat/features/notification/domain/entities/notification_entity.dart';

import '../../lib/features/notification/presentation/views/notification_view.dart';

class MockNotificationBloc extends Mock implements NotificationBloc {}

void main() {
  late MockNotificationBloc mockBloc;

  setUp(() {
    mockBloc = MockNotificationBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<NotificationBloc>.value(
        value: mockBloc,
        child: const NotificationView(userId: 'user123'),
      ),
    );
  }

  testWidgets('shows loading indicator', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(NotificationLoading());
    whenListen(mockBloc, Stream<NotificationState>.fromIterable([NotificationLoading()]));

    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });



  testWidgets('shows error message', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(NotificationError('Failed to load'));
    whenListen(
      mockBloc,
      Stream<NotificationState>.fromIterable([
        NotificationError('Failed to load'),
      ]),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.text('Failed to load'), findsOneWidget);
  });
}
*/