abstract class NotificationEvent {}

class LoadNotifications extends NotificationEvent {
  final String userId;

  LoadNotifications(this.userId);
}
