import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:petforpat/app/service_locator/service_locator.dart';
import 'package:petforpat/features/notification/domain/usecases/delete_notification_usecase.dart';
import 'package:petforpat/features/notification/domain/usecases/get_notification_usecase.dart';
import 'package:petforpat/features/notification/presentation/view_models/notification_bloc.dart';
import 'package:petforpat/features/notification/presentation/view_models/notification_event.dart';
import 'package:petforpat/features/notification/presentation/view_models/notification_state.dart';
import 'package:petforpat/features/notification/presentation/widgets/notification_title.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class NotificationView extends StatefulWidget {
  final String? userId;

  const NotificationView({super.key, this.userId});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  late NotificationBloc _notificationBloc;
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    _notificationBloc = NotificationBloc(
      sl<GetNotificationsUseCase>(),
      sl<DeleteNotificationUseCase>(),
    );

    _notificationBloc.add(LoadNotifications(widget.userId ?? ''));

    socket = IO.io('http://192.168.10.70:3001', {
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.connect();

    socket.onConnect((_) {
      debugPrint('🔌 Socket connected');
      socket.emit('join', widget.userId);
    });

    socket.on('new-notification', (data) {
      debugPrint('📨 New notification received');
      _notificationBloc.add(LoadNotifications(widget.userId ?? ''));
    });

    socket.onDisconnect((_) => debugPrint('❌ Socket disconnected'));
  }

  @override
  void dispose() {
    socket.dispose();
    _notificationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2B3A),
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: const Color(0xFF253746),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _notificationBloc.add(LoadNotifications(widget.userId ?? ''));
            },
          ),
        ],
      ),
      body: BlocProvider.value(
        value: _notificationBloc,
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationLoaded) {
              if (state.notifications.isEmpty) {
                return const Center(
                  child: Text(
                    'No notifications yet',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: state.notifications.length,
                separatorBuilder: (_, __) => const Divider(color: Colors.white12),
                itemBuilder: (_, i) {
                  final notification = state.notifications[i];
                  return Dismissible(
                    key: Key(notification.id),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) {
                      _notificationBloc.add(
                        DeleteNotification(notification.id, widget.userId ?? ''),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Notification deleted')),
                      );
                    },
                    child: NotificationTile(notification: notification),
                  );
                },
              );
            } else if (state is NotificationError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
