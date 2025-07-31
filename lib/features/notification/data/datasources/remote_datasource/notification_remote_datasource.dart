
import 'package:petforpat/features/notification/domain/entities/notification_entity.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationEntity>> fetchNotifications(String userId);
}
