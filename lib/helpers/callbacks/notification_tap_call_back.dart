import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/cupertino.dart' show debugPrint;
import 'package:not_lame_downloader/main.dart';

/// Process the user tapping on a notification by printing a message
void myNotificationTapCallback(Task task, NotificationType notificationType) {
  if(notificationType==NotificationType.complete){
    navigatorKey.currentState?.popUntil((route) => route.isFirst);

  }
  debugPrint(
      'Tapped notification $notificationType for taskId ${task.taskId}');
}
