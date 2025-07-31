
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petforpat/features/notification/domain/entities/notification_entity.dart';

class NotificationTile extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: notification.isRead ? Colors.grey[850] : Colors.blueGrey[800],
      child: ListTile(
        title: Text(notification.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(notification.message, style: const TextStyle(color: Colors.white70)),
        trailing: Icon(
          notification.type == 'adoption' ? Icons.pets : Icons.announcement,
          color: Colors.lightBlueAccent,
        ),
      ),
    );
  }
}
