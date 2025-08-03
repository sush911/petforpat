import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:petforpat/features/notification/domain/entities/notification_entity.dart';
import 'package:petforpat/features/notification/domain/usecases/delete_notification_usecase.dart';
import 'package:petforpat/features/notification/domain/usecases/get_notification_usecase.dart';
import 'package:petforpat/features/notification/data/models/notification_model.dart';
import 'package:petforpat/features/notification/presentation/view_models/notification_bloc.dart';
import 'package:petforpat/features/notification/presentation/view_models/notification_event.dart';
import 'package:petforpat/features/notification/presentation/view_models/notification_state.dart';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// --- MOCKS ---

class MockGetNotificationsUseCase extends Mock implements GetNotificationsUseCase {}

class MockDeleteNotificationUseCase extends Mock implements DeleteNotificationUseCase {}

class FakeNotificationSoundHelper {
  static Future<void> playSound() async {
    // Do nothing in tests
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // 👈 Initialize bindings

  late NotificationBloc bloc;
  late MockGetNotificationsUseCase mockGetNotifications;
  late MockDeleteNotificationUseCase mockDeleteNotification;

  setUp(() {
    mockGetNotifications = MockGetNotificationsUseCase();
    mockDeleteNotification = MockDeleteNotificationUseCase();

    bloc = NotificationBloc(mockGetNotifications, mockDeleteNotification);
  });

  final sampleNotificationModel = NotificationModel(
    userId: 'u1',
    id: 'n1',
    title: 'New Pet Available',
    message: 'A new dog has been added near you!',
    type: 'info',
    isRead: false,
    createdAt: DateTime.now(),
  );

  final sampleEntity = sampleNotificationModel.toEntity();

  group('NotificationBloc', () {
    blocTest<NotificationBloc, NotificationState>(
      'emits [NotificationLoading, NotificationLoaded] when LoadNotifications succeeds',
      build: () {
        when(mockGetNotifications('u1')).thenAnswer((_) async => [sampleEntity]);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadNotifications('u1')),
      expect: () => [
        NotificationLoading(),
        isA<NotificationLoaded>().having((s) => s.notifications.length, 'notifications length', 1),
      ],
    );

    blocTest<NotificationBloc, NotificationState>(
      'emits updated list when NewNotificationReceived is added',
      build: () {
        return bloc;
      },
      seed: () => NotificationLoaded([]),
      act: (bloc) => bloc.add(NewNotificationReceived(sampleNotificationModel)),
      expect: () => [
        isA<NotificationLoaded>().having((s) => s.notifications.first.id, 'first ID', sampleEntity.id),
      ],
    );

    blocTest<NotificationBloc, NotificationState>(
      'emits [NotificationLoaded] with item removed on DeleteNotification',
      build: () {
        when(mockDeleteNotification('n1')).thenAnswer((_) async => null);
        return bloc;
      },
      seed: () => NotificationLoaded([sampleEntity]),
      act: (bloc) => bloc.add(DeleteNotification('n1', 'u1')),
      expect: () => [
        isA<NotificationLoaded>().having((s) => s.notifications.isEmpty, 'empty', true),
      ],
    );

    blocTest<NotificationBloc, NotificationState>(
      'emits NotificationError when DeleteNotification throws',
      build: () {
        when(mockDeleteNotification('n1')).thenThrow(Exception('Delete failed'));
        return bloc;
      },
      seed: () => NotificationLoaded([sampleEntity]),
      act: (bloc) => bloc.add(DeleteNotification('n1', 'u1')),
      expect: () => [
        isA<NotificationError>().having((e) => e.message, 'message', contains('Failed to delete')),
      ],
    );
  });
}
