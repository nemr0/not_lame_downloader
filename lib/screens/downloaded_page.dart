import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:not_lame_downloader/app_assets.dart';
import 'package:not_lame_downloader/cubits/download_cubit/download_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DownloadedPage extends StatelessWidget {
  const DownloadedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DownloadCubit, DownloadState>(
        listener: (context, state) {
      if (state is DownloadTaskUpdateState) {
        print('Progress:${state.progressUpdate?.progress}\nStatus:${state.statusUpdate?.status}');
        //   final update = state;
        //   if (update is TaskStatusUpdate) {
        //     print(update.status);
        //   } else {
        //     print(update);
        //   }
      }
    }, builder: (context, state) {
      final List<DownloadTask> tasks = DownloadCubit.get(context).tasks;

      print(tasks);
      return (tasks.isEmpty)
          ? Center(
              child: Text(
              'No Downloads is added :)',
              style: CupertinoTheme.of(context)
                  .textTheme
                  .tabLabelTextStyle
                  .copyWith(fontSize: 16),
            ))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final DownloadTask task = tasks[index];
                return DownloadTaskWidget(
                  task: task,
                  updateState: (state is DownloadTaskUpdateState)
                      ? (state.statusUpdate?.task == task)
                          ? state
                          : null
                      : null,
                );
              });
    });
  }
}

class DownloadTaskWidget extends HookWidget {
  const DownloadTaskWidget(
      {super.key, required this.task, required this.updateState});

  final DownloadTaskUpdateState? updateState;
  final DownloadTask task;

  @override
  Widget build(BuildContext context) {


  final double? progress=updateState?.progressUpdate?.progress;
  final String? status=updateState?.statusUpdate?.status.name;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: CupertinoButton(
          color: CupertinoTheme.of(context).barBackgroundColor,
          child: Column(
            children: [
              Text(task.filename),
              if(progress!=null)
              CircularProgressIndicator(value: progress,),

            ],
          ),
          onPressed: () {}),
    );
  }
}
