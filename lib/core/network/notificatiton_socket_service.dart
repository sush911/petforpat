import 'package:flutter/foundation.dart';
import 'package:petforpat/features/notification/data/models/notification_model.dart';
import 'package:petforpat/features/notification/presentation/view_models/notification_bloc.dart';
import 'package:petforpat/features/notification/presentation/view_models/notification_event.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class NotificationSocketService with ChangeNotifier {
  IO.Socket? _socket;
  final List<NotificationModel> _liveNotifications = [];
  final NotificationBloc notificationBloc;
  bool _isDisposed = false; // Track disposal state

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
      if (userId != null && userId.isNotEmpty) {
        _socket!.emit('join', userId);
      }
    });

    _socket!.on('new-notification', (data) {
      if (_isDisposed) return; // Don't act if disposed

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

      try {
        notifyListeners(); // Safe because of _isDisposed guard
      } catch (e) {
        print('⚠️ Tried to notifyListeners after dispose: $e');
      }

      notificationBloc.add(NewNotificationReceived(notification));
    });

    _socket!.onDisconnect((_) => print('🔴 Socket disconnected'));
  }

  void disposeSocket() {
    _isDisposed = true;

    // Remove socket event listeners
    _socket?.off('new-notification');
    _socket?.off('connect');
    _socket?.off('disconnect');

    // Clean up socket
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  @override
  void dispose() {
    disposeSocket(); // Ensure clean shutdown
    super.dispose();
  }
}
