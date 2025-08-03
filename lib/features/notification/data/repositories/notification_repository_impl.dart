import 'package:petforpat/features/notification/data/datasources/remote_datasource/notification_remote_datasource.dart';
import 'package:petforpat/features/notification/domain/entities/notification_entity.dart';
import 'package:petforpat/features/notification/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<NotificationEntity>> getUserNotifications(String userId) async {
    return await remoteDataSource.fetchNotifications(userId);
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await remoteDataSource.deleteNotification(notificationId);
  }
}
