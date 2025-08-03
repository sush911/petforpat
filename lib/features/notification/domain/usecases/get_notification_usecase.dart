
import 'package:petforpat/features/notification/domain/entities/notification_entity.dart';
import 'package:petforpat/features/notification/domain/repositories/notification_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<List<NotificationEntity>> call(String userId) {
    return repository.getUserNotifications(userId);
  }
}
