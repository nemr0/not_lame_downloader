import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:not_lame_downloader/helpers/extensions/context_extension.dart';
import 'package:not_lame_downloader/helpers/overlays/toast.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../app_assets.dart';
import '../../cubits/download_cubit/download_cubit.dart';
import 'modal_popups/downloading_task_modal_popup.dart';

class LoadingDownloadTaskWidget extends StatelessWidget {
  const LoadingDownloadTaskWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      effect: ShimmerEffect(
          baseColor: CupertinoTheme.of(context).barBackgroundColor),
      enabled: true,
      child: SizedBox(
        height: context.height / 9,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
              color:
                  CupertinoTheme.of(context).barBackgroundColor.withOpacity(.7),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Image.asset(
                      AppAssets.assets_file_png,
                      color: CupertinoTheme.of(context).brightness ==
                              Brightness.dark
                          ? CupertinoColors.extraLightBackgroundGray
                          : CupertinoColors.darkBackgroundGray,
                      height: 40,
                    ),
                  ),
                  const Spacer(
                    flex: 11,
                  )
                ],
              )),
        ),
      ),
    );
  }
}

class DownloadTaskWidget extends HookWidget {
  const DownloadTaskWidget(
      {super.key, required this.taskWithUpdates});

  final TaskWithUpdates taskWithUpdates;


  @override
  Widget build(BuildContext context) {
    final double? progress = taskWithUpdates.progressUpdate?.progress;
    final TaskStatus? status = taskWithUpdates.statusUpdate?.status;
    final bool showProgress = (status != null)
        ? (status == TaskStatus.complete)
            ? false
            : progress != null &&
                progress != 1.0 &&
                progress >= 0 &&
                progress < 1
        : false;
    final bool noUpdates =
        (taskWithUpdates.statusUpdate == null && taskWithUpdates.progressUpdate == null) ||
            (taskWithUpdates.statusUpdate == null && progress == 1);

    final isPaused = useState(noUpdates ? true : false);
    final String? remainingTime =
        taskWithUpdates.progressUpdate?.timeRemaining.toString().split('.').first ==
                '-0:00:01'
            ? 'unknown'
            : taskWithUpdates.progressUpdate?.timeRemaining.toString().split('.').first;
    final String? statusName = taskWithUpdates.statusUpdate?.status.name;
    // final statusFuture =
    //     useFuture(FileDownloader().database.recordForId(task.taskId));
    return CupertinoContextMenu.builder(
        enableHapticFeedback: true,
        actions: [
          CupertinoContextMenuAction(
              onPressed: () {
                DownloadCubit.get(context)
                    .deleteDownloadTask(taskWithUpdates.task.taskId)
                    .then((value) {
                  if (!value) {
                    showToast(context, 'Couldn\'t Remove #${taskWithUpdates.task.filename}');
                  }
                });
                Navigator.of(context).pop();
              },
              isDestructiveAction: true,
              trailingIcon: CupertinoIcons.delete,
              child:  Text(status==TaskStatus.canceled?'Delete':'Cancel'))
        ],
        builder: (BuildContext context, Animation<double> animation) => Padding(
            padding: const EdgeInsets.all(12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CupertinoButton(
                  padding: const EdgeInsets.all(15),
                  color: CupertinoTheme.of(context)
                      .barBackgroundColor
                      .withOpacity(.7),
                  onPressed: () {
                    // showCupertinoModalPopup(
                    //     context: context,
                    //     builder: (context) => DownloadTaskDetailsModalPopup(
                    //           taskID: taskWithUpdates.task.taskId,
                    //         ));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Image.asset(
                          AppAssets.assets_file_png,
                          color: CupertinoTheme.of(context).brightness ==
                                  Brightness.dark
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
                                text: taskWithUpdates.task.filename,
                                style: TextStyle(
                                    color: CupertinoTheme.of(context)
                                        .textTheme
                                        .textStyle
                                        .color),
                                children: [
                                  if (status != TaskStatus.complete &&
                                          progress != 1
                                      // &&
                                      // statusFuture.data?.status !=
                                      //     TaskStatus.complete
                                      )
                                    TextSpan(text: '\n⏳: $remainingTime'),
                                  if (status != TaskStatus.complete &&
                                          progress != 1
                                      // &&
                                      // statusFuture.data?.status !=
                                      //     TaskStatus.complete
                                      )
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
                                    .resume(taskWithUpdates.task)
                                    .then((value) => isPaused.value = !value);
                              } else {
                                isPaused.value = true;
                                FileDownloader()
                                    .pause(taskWithUpdates.task)
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
                              progressColor:
                                  CupertinoTheme.of(context).primaryColor,
                            ),
                          ),
                        ),

                      /// if paused
                      if ((progress == -5 || noUpdates)
                          // &&
                          // statusFuture.data?.status != TaskStatus.complete
                          )
                        Expanded(
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () async {
                              if (isPaused.value) {
                                isPaused.value = false;
                                FileDownloader()
                                    .resume(taskWithUpdates.task)
                                    .then((value) => isPaused.value = !value);
                              } else {
                                isPaused.value = true;
                                FileDownloader()
                                    .pause(taskWithUpdates.task)
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
            )));
  }
}
