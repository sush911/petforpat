import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // for date formatting
import 'package:petforpat/app/service_locator/service_locator.dart';
import 'package:petforpat/features/notification/domain/usecases/get_notification_usecase.dart';
import 'package:petforpat/features/notification/presentation/view_models/notification_bloc.dart';
import 'package:petforpat/features/notification/presentation/view_models/notification_event.dart';
import 'package:petforpat/features/notification/presentation/view_models/notification_state.dart';

// Main Notification Screen
class NotificationView extends StatelessWidget {
  final String? userId;

  const NotificationView({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2B3A),
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: const Color(0xFF253746),
      ),
      body: BlocProvider(
        create: (_) =>
        NotificationBloc(sl<GetNotificationsUseCase>())..add(LoadNotifications(userId ?? '')),
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
                    ));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: state.notifications.length,
                separatorBuilder: (_, __) => const Divider(color: Colors.white12),
                itemBuilder: (_, i) =>
                    NotificationTile(notification: state.notifications[i]),
              );
            } else if (state is NotificationError) {
              return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.redAccent),
                  ));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}


// NotificationTile Widget for each notification
class NotificationTile extends StatelessWidget {
  final dynamic notification; // replace with your notification model type

  const NotificationTile({super.key, required this.notification});

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} min ago';
    if (difference.inHours < 24) return '${difference.inHours} hrs ago';
    if (difference.inDays < 7) return '${difference.inDays} days ago';

    return DateFormat('MMM d, yyyy').format(time);
  }

  IconData _iconForType(String type) {
    switch (type.toLowerCase()) {
      case 'adoption':
        return Icons.pets;
      case 'announcement':
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime createdAt = notification.createdAt is DateTime
        ? notification.createdAt
        : DateTime.tryParse(notification.createdAt.toString()) ?? DateTime.now();

    return Card(
      color: const Color(0xFF2A3A50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent.shade700,
          child: Icon(_iconForType(notification.type), color: Colors.white),
        ),
        title: Text(
          notification.title ?? 'No Title',
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.message ?? '',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  (notification.userId == null || notification.userId == '')
                      ? 'Global Notification'
                      : 'Sent to You',
                  style: const TextStyle(
                      color: Colors.blueAccent, fontWeight: FontWeight.w500),
                ),
                Text(
                  _formatTime(createdAt),
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        trailing: notification.isRead == true
            ? const Icon(Icons.check_circle, color: Colors.greenAccent)
            : const Icon(Icons.circle_outlined, color: Colors.grey),
        onTap: () {
          // Add your onTap logic here, maybe mark notification as read?
        },
      ),
    );
  }
}
