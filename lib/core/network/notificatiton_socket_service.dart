import 'package:flutter/foundation.dart';
import 'package:petforpat/features/notification/data/models/notification_model.dart';
import 'package:petforpat/features/notification/presentation/view_models/notification_bloc.dart';
import 'package:petforpat/features/notification/presentation/view_models/notification_event.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class NotificationSocketService with ChangeNotifier {
  IO.Socket? _socket;
  final List<NotificationModel> _liveNotifications = [];
  final NotificationBloc notificationBloc;

  List<NotificationModel> get liveNotifications => _liveNotifications;

  NotificationSocketService(this.notificationBloc);

  void initSocket([String? userId]) {
    _socket = IO.io(
      'http://192.168.10.69:3001',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      print('🔌 Socket connected');

      // Only join if userId is provided
      if (userId != null && userId.isNotEmpty) {
        _socket!.emit('join', userId);
      }
    });

    _socket!.on('new-notification', (data) {
      print('📩 New Notification: $data');

      final notification = NotificationModel(
        id: data['_id'],
        userId: data['userId'],
        title: data['title'],
        message: data['message'],
        type: data['type'],
        isRead: data['isRead'],
        createdAt: DateTime.parse(data['createdAt']),
      );

      _liveNotifications.insert(0, notification);
      notifyListeners();

      notificationBloc.add(NewNotificationReceived(notification));
    });

    _socket!.onDisconnect((_) => print('🔴 Socket disconnected'));
  }

  void disposeSocket() {
    _socket?.disconnect();
    _socket?.dispose();
  }
}

