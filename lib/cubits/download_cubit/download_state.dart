part of 'download_cubit.dart';

sealed class DownloadState extends Equatable {
  const DownloadState();
}

class DownloadInitial extends DownloadState {
  @override
  List<Object> get props => const [];
}

class DownloadLoadingState extends DownloadState {
  @override
  List<Object> get props => const [];
}
class DownloadEnqueuedLoadingState extends DownloadLoadingState{

}

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
  final TaskUpdate update;

  const DownloadTaskUpdateState(this.update);

  @override
  List<Object> get props => [update];
}
