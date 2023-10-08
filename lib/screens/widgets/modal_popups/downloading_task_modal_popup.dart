
import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' show Colors,Material;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:not_lame_downloader/cubits/download_cubit/download_cubit.dart';
import 'package:not_lame_downloader/helpers/overlays/toast.dart';
import 'package:not_lame_downloader/screens/widgets/modal_popups/modal_popups.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DownloadTaskDetailsModalPopup extends HookWidget {
  const DownloadTaskDetailsModalPopup({super.key, required this.taskID});

  final String taskID;
  @override
  Widget build(BuildContext context) {
    final record=useState<TaskRecord?>(null);
    final recordError=useState<dynamic>(null);
    useEffect(() {
      FileDownloader().database.recordForId(taskID).then((value) {
        print('record: $value');
        if(value==null){
          showToast(context, 'Task is removed');
          Navigator.pop(context);
          DownloadCubit.get(context).deleteDownloadTask(taskID);
        }
        else {
          record.value = value;
        }
      }).catchError((e) {
        recordError.value = e;
        print('recordError: $e');

      });
      return null;
    },const[]);
    final bool loading=record.value==null&&recordError.value==null;
    return Skeletonizer(
      enabled: loading,
      child: ModalPopups(
        title:loading?const CupertinoActivityIndicator(): Text('#${record.value?.task.filename}'),
        heightRatio: .5,
        trailing:loading?null:record.value?.status==TaskStatus.complete? CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () async => FileDownloader().openFile(filePath: await record.value?.task.filePath()) ,
          child: const Icon(CupertinoIcons.doc_text_search),
        ):null,
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

                        TextSpan(text: ' Creation Time: ${record.value?.task.creationTime.toLocal().toString().split('.').first}\n\n'),

                        const WidgetSpan(child: Icon(CupertinoIcons.doc_text_fill,size: 20,),),
                        TextSpan(
                            text:
                            ' Directory: ${record.value?.task.baseDirectory.name ?? 'unknown'}\n\n'),
                        const WidgetSpan(child: Icon(CupertinoIcons.link,size: 20,),),

                        const TextSpan(text: ' Url: '),
                        TextSpan(
                          text: '${record.value?.task.url ?? 'unknown'}\n\n',
                          style: record.value?.task.url==null
                              ? null
                              : const TextStyle(color: CupertinoColors.systemBlue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = record.value?.task.url==null
                                ? null
                                : () => Share.shareUri(
                              Uri.parse(record.value!.task.url),
                            ),
                        ),
                        const WidgetSpan(child: Icon(CupertinoIcons.app_badge_fill,size: 20,),),

                        TextSpan(text: ' Status: ${record.value?.status.name}\n\n'),
                        const WidgetSpan(child: Icon(CupertinoIcons.percent,size: 20,),),

                        TextSpan(text: ' Progress: ${record.value?.progress==null?'unknown':'${(record.value!.progress*100).toInt()}%'}'),
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
