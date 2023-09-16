import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../helpers/callbacks/notification_tap_call_back.dart';

class NotificationNavigator extends HookWidget {
  const NotificationNavigator(this.child, {super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    /// Process the user tapping on a notification by printing a message
    void myNotificationTapCallback(
        Task task, NotificationType notificationType) {
      debugPrint(
          'Tapped notification $notificationType for taskId ${task.taskId}');
    }

    useEffect(() {
      FileDownloader().registerCallbacks(
          taskNotificationTapCallback: myNotificationTapCallback);
      return null;
    });
    return const Placeholder();
  }
}
