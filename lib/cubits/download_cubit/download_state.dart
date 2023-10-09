part of 'download_cubit.dart';

sealed class DownloadState extends Equatable {
  const DownloadState();

  @override
  List<Object> get props => const [];
}

class DownloadInitial extends DownloadState {}

class DownloadLoadingState extends DownloadState {
  @override
  List<Object> get props => const [];
}

class DownloadEnqueuedLoadingState extends DownloadLoadingState {}

class DownloadErrorState extends DownloadState {
  final String error;

  const DownloadErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class DownloadEnqueuedErrorState extends DownloadErrorState {
  const DownloadEnqueuedErrorState(super.error);
}

class DownloadTaskEnqueuedState extends DownloadState {
  final bool pop;

  const DownloadTaskEnqueuedState({this.pop = true});

  @override
  List<Object> get props => [pop];
}

class DownloadTaskUpdateState extends DownloadState {

  const DownloadTaskUpdateState();


  @override
  List<Object> get props => [UniqueKey()];
}

class TaskWithUpdates extends Equatable{

  final DownloadTask task;
  final TaskStatusUpdate statusUpdate;
  final TaskProgressUpdate progressUpdate;

  const TaskWithUpdates(this.task, { required this.statusUpdate, required this.progressUpdate});

  TaskWithUpdates copyWith(
      { TaskStatusUpdate? statusUpdate, TaskProgressUpdate? progressUpdate}) =>
      TaskWithUpdates(
          task, statusUpdate: statusUpdate ?? this.statusUpdate,
          progressUpdate: progressUpdate ?? this.progressUpdate);

  @override
  List<Object?> get props => [task.taskId,statusUpdate,progressUpdate];
}

// typedef TaskWithUpdates=(Task task, TaskProgressUpdate? progressUpdate,TaskStatusUpdate? status);