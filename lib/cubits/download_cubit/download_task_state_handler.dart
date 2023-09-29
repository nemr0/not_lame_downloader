part of 'download_cubit.dart';

DownloadTaskUpdateState _downloadStateUpdate(DownloadState state,TaskUpdate update){
  List<TaskProgressStatus> updateList=[];
  if(state is DownloadTaskUpdateState) {
    updateList .addAll(  (state).updateList??[]);
  }
  switch(update){
    case TaskStatusUpdate():
      if(updateList.isEmpty){
        updateList.add(TaskProgressStatus(update.task, statusUpdate: update));
      }
      else{
        final int index = updateList.indexWhere(
                (element) => element.task.taskId == update.task.taskId);
        if (index == -1) {
          updateList
              .add(TaskProgressStatus(update.task, statusUpdate: update));
        } else {
          updateList[index] =
              updateList[index].copyWith(statusUpdate: update);
        }
      }
    case TaskProgressUpdate():
      if(updateList.isEmpty){
        updateList.add(TaskProgressStatus(update.task, progressUpdate: update));
      }
      else{
        final int index = updateList.indexWhere(
                (element) => element.task.taskId == update.task.taskId);
        if (index == -1) {
          updateList.add(
              TaskProgressStatus(update.task, progressUpdate: update));
        } else {
          updateList[index] =
              updateList[index].copyWith(progressUpdate: update);
        }
      }

  }
  return DownloadTaskUpdateState(updateList: updateList);
}