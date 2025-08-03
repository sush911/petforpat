import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petforpat/features/notification/domain/entities/notification_entity.dart';

class NotificationTile extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationTile({super.key, required this.notification});

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} min ago';
    if (difference.inHours < 24) return '${difference.inHours} hrs ago';
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
    return Card(
      color: const Color(0xFF2A3A50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.blueAccent.shade700,
          child: Icon(
            _iconForType(notification.type),
            color: Colors.white,
            size: 24,
          ),
        ),
        title: Text(
          notification.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.message,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    notification.userId == null ? 'Global' : 'Personal',
                    style: const TextStyle(color: Colors.blueAccent),
                  ),
                  Text(
                    _formatTime(notification.createdAt),
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              )
            ],
          ),
        ),
        trailing: Icon(
          notification.isRead ? Icons.check_circle : Icons.circle_outlined,
          color: notification.isRead ? Colors.greenAccent : Colors.grey,
        ),
        onTap: () {
          // Optional: Add mark as read or detail navigation
        },
      ),
    );
  }
}
