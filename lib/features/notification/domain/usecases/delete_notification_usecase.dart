import 'package:petforpat/features/notification/domain/repositories/notification_repository.dart';

class DeleteNotificationUseCase {
  final NotificationRepository repository;

  DeleteNotificationUseCase(this.repository);

  Future<void> call(String notificationId) async {
    return await repository.deleteNotification(notificationId);
  }
}
