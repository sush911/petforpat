import 'package:petforpat/features/notification/domain/entities/notification_entity.dart';

class NotificationModel {
  final String? userId;
  final String id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    this.userId,
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      userId: json['userId'] as String?,
      id: json['_id'] as String, // ✅ plain string
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      isRead: json['isRead'] as bool,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }


  NotificationEntity toEntity() {
    return NotificationEntity(
      userId: userId,
      id: id,
      title: title,
      message: message,
      type: type,
      isRead: isRead,
      createdAt: createdAt,
    );
  }
}
