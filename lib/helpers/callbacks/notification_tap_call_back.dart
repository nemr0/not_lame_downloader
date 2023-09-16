import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/cupertino.dart' show debugPrint;

/// Process the user tapping on a notification by printing a message
void myNotificationTapCallback(Task task, NotificationType notificationType) {
  debugPrint(
      'Tapped notification $notificationType for taskId ${task.taskId}');
}