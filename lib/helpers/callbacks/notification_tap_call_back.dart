import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/cupertino.dart' show debugPrint, showCupertinoModalPopup;
import 'package:not_lame_downloader/main.dart';

import '../../screens/widgets/modal_popups/downloading_task_modal_popup.dart';

/// Process the user tapping on a notification by printing a message
void myNotificationTapCallback(Task task, NotificationType notificationType) {

    navigatorKey.currentState?.popUntil((route) => route.isFirst);
    showCupertinoModalPopup(
        context: navigatorKey.currentContext!,
        builder: (context) => DownloadTaskDetailsModalPopup(
          taskID: task.taskId,
        ));

  debugPrint(
      'Tapped notification $notificationType for taskId ${task.taskId}');
}
