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
  @override
  List<Object> get props => [];
}

class DownloadTaskUpdateState extends DownloadState {
  final TaskStatusUpdate? statusUpdate;
  final TaskProgressUpdate? progressUpdate;

  const DownloadTaskUpdateState({this.statusUpdate, this.progressUpdate});

  DownloadTaskUpdateState copyWith(
          {TaskStatusUpdate? statusUpdate,
          TaskProgressUpdate? progressUpdate}) =>
      DownloadTaskUpdateState(statusUpdate:statusUpdate ?? this.statusUpdate,
          progressUpdate:progressUpdate ?? this.progressUpdate);

  @override
  List<Object> get props =>
      [statusUpdate.toString(), progressUpdate.toString()];
}
