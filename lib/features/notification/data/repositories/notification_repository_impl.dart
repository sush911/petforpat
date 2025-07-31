
import 'package:petforpat/features/notification/data/datasources/remote_datasource/notification_remote_datasource.dart';
import 'package:petforpat/features/notification/domain/entities/notification_entity.dart';
import 'package:petforpat/features/notification/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remote;

  NotificationRepositoryImpl(this.remote);

  @override
  Future<List<NotificationEntity>> getUserNotifications(String userId) {
    return remote.fetchNotifications(userId);
  }
}
