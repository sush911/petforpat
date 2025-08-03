// domain/entities/notification_entity.dart
class NotificationEntity {
  final String? userId; // <-- make nullable
  final String id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime createdAt;

  NotificationEntity({
    this.userId, // <-- optional
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });
}
