import 'dart:developer';

import 'package:not_lame_downloader/cubits/download_cubit/download_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:not_lame_downloader/helpers/extensions/context_extension.dart';
import 'package:not_lame_downloader/screens/widgets/downloading_task_widget.dart';
printTasks(List<TaskWithUpdates> tasks){

  String printString =('\n------------------------------------\nTasks:(');
  for(TaskWithUpdates task in tasks){
    printString+='(taskID:${task.task.taskId},status:${task.statusUpdate?.status.name},progress:${task.progressUpdate?.progress})';
  }
  printString+=')\n------------------------------------';
log(printString);
}
class DownloadTasksPage extends StatelessWidget {
  const DownloadTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadCubit, DownloadState>(builder: (context, state) {

      final List<TaskWithUpdates> tasks = DownloadCubit.get(context).tasks;
      // printTasks(tasks);
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: (state is DownloadLoadingState)
            ? ListView.builder(
                itemCount: 4,
                physics: const NeverScrollableScrollPhysics(),
                itemExtent: context.height / 9,
                itemBuilder: (BuildContext context, int index) =>
                    const LoadingDownloadTaskWidget(),
              )
            : (tasks.isEmpty)
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
                    itemBuilder: (context, index) =>
                       DownloadTaskWidget(
                        taskWithUpdates: tasks[index],
                      ),
                    ),
      );
    });
  }
}
