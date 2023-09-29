
import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' show Colors,Material;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:not_lame_downloader/screens/widgets/modal_popups/modal_popups.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DownloadTaskDetailsModalPopup extends HookWidget {
  const DownloadTaskDetailsModalPopup({super.key, required this.taskID});

  final String taskID;
  @override
  Widget build(BuildContext context) {
    final record=useFuture(FileDownloader().database.recordForId(taskID));
    final bool loading=record.hasData==false&&record.hasError==false;
    return Skeletonizer(
      enabled: loading,
      child: ModalPopups(
        title:loading?const CupertinoActivityIndicator(): Text('#${record.data?.task.filename}'),
        heightRatio: .5,
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Text.rich(

                    TextSpan(
                      text:
                      '\n',
                      style: const TextStyle(fontSize: 14),
                      children: [
                        // TextSpan(text: '\')
                        const WidgetSpan(child: Icon(CupertinoIcons.time_solid,size: 20,),),

                        TextSpan(text: ' Creation Time: ${record.data?.task.creationTime.toLocal().toString().split('.').first}\n\n'),

                        const WidgetSpan(child: Icon(CupertinoIcons.doc_text_fill,size: 20,),),
                        TextSpan(
                            text:
                            ' Directory: ${record.data?.task.baseDirectory.name ?? 'unknown'}\n\n'),
                        const WidgetSpan(child: Icon(CupertinoIcons.link,size: 20,),),

                        const TextSpan(text: ' Url: '),
                        TextSpan(
                          text: '${record.data?.task.url ?? 'unknown'}\n\n',
                          style: record.data?.task.url==null
                              ? null
                              : const TextStyle(color: CupertinoColors.systemBlue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = record.data?.task.url==null
                                ? null
                                : () => Share.shareUri(
                              Uri.parse(record.data!.task.url),
                            ),
                        ),
                        const WidgetSpan(child: Icon(CupertinoIcons.app_badge_fill,size: 20,),),

                        TextSpan(text: ' Status: ${record.data?.status.name}\n\n'),
                        const WidgetSpan(child: Icon(CupertinoIcons.percent,size: 20,),),

                        TextSpan(text: ' Progress: ${record.data?.progress==null?'unknown':'${(record.data!.progress*100).toInt()}%'}'),
                      ],),maxLines: 12,),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
