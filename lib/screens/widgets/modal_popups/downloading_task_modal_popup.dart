
import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' show Colors,Material;
import 'package:not_lame_downloader/screens/widgets/modal_popups/modal_popups.dart';
import 'package:share_plus/share_plus.dart';

class DownloadTaskDetailsModalPopup extends StatelessWidget {
  const DownloadTaskDetailsModalPopup({super.key, required this.task, required this.progress,  this.remainingTime});

  final DownloadTask task;
  final double? progress;
  final String? remainingTime;
  @override
  Widget build(BuildContext context) {
    return ModalPopups(
      title: '#${task.filename}',
      heightRatio: .5,
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Text.rich(TextSpan(
                    text:
                    '\nCreation Time: ${task.creationTime.toLocal().toString().split('.').first}\n\n',
                    style: const TextStyle(fontSize: 14),
                    children: [
                      TextSpan(
                          text:
                          'Directory: ${task.directory.isEmpty ? 'unknown' : task.directory}\n\n'),
                      const TextSpan(text: 'Url: '),
                      TextSpan(
                        text: '${task.url.isEmpty ? 'unknown' : task.url}\n\n',
                        style: task.url.isEmpty
                            ? null
                            : const TextStyle(color: CupertinoColors.systemBlue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = task.url.isEmpty
                              ? null
                              : () => Share.shareUri(
                            Uri.parse(task.url),
                          ),
                      ),
                      TextSpan(text: 'Remaining Time/Status: $remainingTime\n\n'),
                      TextSpan(text: 'Progress: ${progress==null?'unknown':'${(progress!*100).toInt()}%'}'),
                    ])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
