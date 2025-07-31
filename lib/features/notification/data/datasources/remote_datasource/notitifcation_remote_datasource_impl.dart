import 'package:dio/dio.dart';
import 'package:petforpat/features/notification/data/datasources/remote_datasource/notification_remote_datasource.dart';
import 'package:petforpat/features/notification/data/models/notification_model.dart';
import 'package:petforpat/features/notification/domain/entities/notification_entity.dart';

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio dio;

  NotificationRemoteDataSourceImpl(this.dio);

  @override
  Future<List<NotificationEntity>> fetchNotifications(String userId) async {
    final response = await dio.get('/notifications/$userId');
    final data = List<Map<String, dynamic>>.from(response.data);

    return data.map((json) => NotificationModel.fromJson(json).toEntity()).toList();
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await dio.delete('/notifications/$notificationId');
  }
}
