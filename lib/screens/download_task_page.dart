import 'package:background_downloader/background_downloader.dart';
import 'package:not_lame_downloader/cubits/download_cubit/download_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:not_lame_downloader/helpers/extensions/context_extension.dart';
import 'package:not_lame_downloader/screens/widgets/downloading_task_widget.dart';

class DownloadTasksPage extends StatelessWidget {
  const DownloadTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadCubit, DownloadState>(builder: (context, state) {
      final List<TaskProgressStatus>? updateList =
          state is DownloadTaskUpdateState ? (state).updateList : null;
      final List<DownloadTask> tasks = DownloadCubit.get(context).tasks;
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
                    itemBuilder: (context, index) {
                      final TaskProgressStatus? update = updateList?.firstWhere(
                          (element) => element.task.taskId == tasks[index].taskId,
                          orElse: () => TaskProgressStatus(tasks[index]));
                      return DownloadTaskWidget(
                        task: tasks[index],
                        update: update,
                      );
                    }),
      );
    });
  }
}
