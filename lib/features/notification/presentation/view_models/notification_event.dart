import 'package:petforpat/features/notification/data/models/notification_model.dart';

abstract class NotificationEvent {}

class LoadNotifications extends NotificationEvent {
  final String userId;
  LoadNotifications(this.userId);
}

class NewNotificationReceived extends NotificationEvent {
  final NotificationModel notification;
  NewNotificationReceived(this.notification);
}

class DeleteNotification extends NotificationEvent {
  final String notificationId;
  final String userId; // if needed to reload or for backend auth

  DeleteNotification(this.notificationId, this.userId);
}
