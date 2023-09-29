import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../app_assets.dart';
import '../../cubits/download_cubit/download_cubit.dart';
import 'modal_popups/downloading_task_modal_popup.dart';

class DownloadTaskWidget extends HookWidget {
  const DownloadTaskWidget(
      {super.key, required this.task, required this.update});

  final TaskProgressStatus? update;
  final DownloadTask task;

  @override
  Widget build(BuildContext context) {
    final double? progress = update?.progressUpdate?.progress;
    final TaskStatus? status=update?.statusUpdate?.status;
    final bool showProgress = (status != null)
        ? (status == TaskStatus.complete)
            ? false
            :  progress != null && progress != 1.0 && progress > 0 && progress < 1:false;
    final bool noUpdates=(update?.statusUpdate==null&&update?.progressUpdate==null)||(update?.statusUpdate==null&&progress==1);

    final isPaused = useState(noUpdates?true:false);
    final String? remainingTime =
        update?.progressUpdate?.timeRemaining.toString().split('.').first ==
                '-0:00:01'
            ? 'unknown'
            : update?.progressUpdate?.timeRemaining.toString().split('.').first;
    final String? statusName = update?.statusUpdate?.status.name;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CupertinoButton(
            padding: const EdgeInsets.all(15),
            color: CupertinoTheme.of(context).barBackgroundColor.withOpacity(.7),
            onPressed: () {
              showCupertinoModalPopup(
                  context: context,
                  builder: (context) => DownloadTaskDetailsModalPopup(
                        task: task,
                        progress: progress,
                        remainingTime: remainingTime,
                      ));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Image.asset(
                    AppAssets.assets_file_png,
                    color:
                        CupertinoTheme.of(context).brightness == Brightness.dark
                            ? CupertinoColors.extraLightBackgroundGray
                            : CupertinoColors.darkBackgroundGray,
                    height: 40,
                  ),
                ),
                const Spacer(),
                // const Spacer(),
                Expanded(
                    flex: 7,
                    child: Text.rich(
                      TextSpan(
                          text: task.filename,
                          style: TextStyle(
                              color: CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle
                                  .color),
                          children: [
                            if (status !=
                                TaskStatus.complete&&progress!=1)
                              TextSpan(text: '\n⏳: $remainingTime'),
                            if(status!=TaskStatus.complete&&progress!=1)
                            TextSpan(text: '\nStatus: $statusName')
                          ]),
                      overflow: TextOverflow.clip,
                    )),
                const Spacer(),
                if (showProgress)
                  Expanded(
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        if (isPaused.value) {
                          isPaused.value = false;
                          FileDownloader()
                              .resume(task)
                              .then((value) => isPaused.value = !value);
                        } else {
                          isPaused.value = true;
                          FileDownloader()
                              .pause(task)
                              .then((value) => isPaused.value = value);
                        }
                      },
                      child: CircularPercentIndicator(
                        percent: progress,
                        radius: 20,
                        center: Icon(
                          isPaused.value
                              ? CupertinoIcons.play_fill
                              : CupertinoIcons.pause_fill,
                          size: 18,
                        ),
                        lineWidth: 3,
                        restartAnimation: true,
                        progressColor: CupertinoTheme.of(context).primaryColor,
                      ),
                    ),
                  ),
                /// if paused
                if(progress==-5||noUpdates)
                  CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        if (isPaused.value) {
                          isPaused.value = false;
                          FileDownloader()
                              .resume(task)
                              .then((value) => isPaused.value = !value);
                        } else {
                          isPaused.value = true;
                          FileDownloader()
                              .pause(task)
                              .then((value) => isPaused.value = value);
                        }
                      },
                  child: Icon(
                    isPaused.value
                        ? CupertinoIcons.play_fill
                        : CupertinoIcons.pause_fill,
                    size: 18,
                  ),
                  ),
                /// If Download Succeeded
                if (!showProgress && progress == 1)
                  const Icon(
                    CupertinoIcons.check_mark_circled_solid,
                    color: CupertinoColors.activeGreen,
                    size: 40,
                  ),

                /// If Download Failed
                if (!showProgress && progress == -1)
                  const Icon(
                    CupertinoIcons.xmark_circle_fill,
                    color: CupertinoColors.destructiveRed,
                    size: 40,
                  ),
                const Spacer(),
              ],
            )),
      ),
    );
  }
}
