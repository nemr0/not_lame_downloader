import 'dart:developer';

import 'package:not_lame_downloader/cubits/download_cubit/download_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:not_lame_downloader/helpers/extensions/context_extension.dart';
import 'package:not_lame_downloader/screens/widgets/downloading_task_widget.dart';
printTasks(List<TaskWithUpdates> tasks){

  String printString =('\n------------------------------------\nTasks:(');
  for(TaskWithUpdates task in tasks){
    printString+='(taskID:${task.task.taskId},status:${task.statusUpdate.status.name},progress:${task.progressUpdate.progress})';
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
      return CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async=> await
              DownloadCubit.get(context).getDownloadedTasks(),
          ),
          (state is DownloadLoadingState)
                ? SliverList(delegate: SliverChildBuilderDelegate((BuildContext context, int index) =>
            const LoadingDownloadTaskWidget(),
                    childCount: 4,
                    )
                  )
                : (tasks.isEmpty)
                    ? SliverToBoxAdapter(
                      child: SizedBox(
                        height: context.height*.75,
                        width: context.width*.7,
                        child: Center(
                            child: Text(
                            'No Downloads is added :)',
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .tabLabelTextStyle
                                .copyWith(fontSize: 16),
                          )),
                      ),
                    )
                    : SliverList(
delegate: SliverChildBuilderDelegate(   (context, index) =>
    DownloadTaskWidget(
      taskWithUpdates: tasks[index],
    ),                       childCount: tasks.length,

                        ),),

        ],
      );
    });
  }
}
