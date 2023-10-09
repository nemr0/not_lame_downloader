part of 'download_cubit.dart';

List<TaskWithUpdates> _downloadStateUpdate(TaskUpdate update, List<TaskWithUpdates> tasks) {
 final int index = tasks.indexWhere((element) => element.task.taskId == update.task.taskId);

  switch (update) {
    case TaskStatusUpdate():
      if(update.status==TaskStatus.failed){
        print(update.exception);
      }
      // if index not found
      if (index == -1) {
        tasks.add(TaskWithUpdates(update.task as DownloadTask, statusUpdate: update,progressUpdate: TaskProgressUpdate(update.task, -1)));
      } else {
        tasks[index] = tasks[index].copyWith(statusUpdate: update);
      }
    print('${update.task.taskId}:${update.status.name}');
    case TaskProgressUpdate():
      // if index not found
      if (index == -1) {
        tasks.add(TaskWithUpdates(update.task as DownloadTask, statusUpdate: TaskStatusUpdate(update.task, TaskStatus.running), progressUpdate: update));
      } else {
        tasks[index] = tasks[index].copyWith(progressUpdate: update);
      }
      print('${update.task.taskId}:${update.progress}');

  }
  return tasks;
}
