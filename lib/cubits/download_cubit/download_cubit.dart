import 'dart:developer';

import 'package:background_downloader/background_downloader.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../../helpers/callbacks/notification_tap_call_back.dart';

part 'download_state.dart';
part 'download_task_state_handler.dart';
class DownloadCubit extends Cubit<DownloadState> {
  DownloadCubit() : super(DownloadInitial());
  List<TaskWithUpdates> tasks = [];
  final FileDownloader _fileDownloader= FileDownloader();
  static DownloadCubit get(BuildContext context) => BlocProvider.of<DownloadCubit>(context);

  initialize() async {

    emit(DownloadLoadingState());
    _fileDownloader.resumeFromBackground();
    // configure notification for all tasks
    _fileDownloader
        .registerCallbacks(
            taskNotificationTapCallback: myNotificationTapCallback)
        .configureNotification(
            running: const TaskNotification('Downloading', 'file: {filename}'),
            complete:
                const TaskNotification('Download finished', 'file: {filename}'),
            progressBar: true);
    //configure global
    _fileDownloader.configure(globalConfig: [
      (Config.requestTimeout, const Duration(minutes: 3)),
    ], androidConfig: [
      (Config.useCacheDir, Config.never),(Config.runInForeground,Config.always)
    ], iOSConfig: [(Config.resourceTimeout, const Duration(hours: 24)),
      (Config.requestTimeout, const Duration(minutes: 3)),
      (Config.checkAvailableSpace,Config.always),
      (Config.localize, {'Cancel': 'Stop It'}),
    ]).then((result) => debugPrint('Configuration result = $result'));

    // Registering a callback and configure notifications
    _fileDownloader
        .configureNotificationForGroup(FileDownloader.defaultGroup,
            // For the main download button
            // which uses 'enqueue' and a default group
            running: const TaskNotification('Downloading {filename}',
                'File: {filename} - {progress} - speed {networkSpeed} and {timeRemaining} remaining'),
            complete: const TaskNotification(
                'Download {filename}', 'Download complete'),
            error: const TaskNotification(
                'Download {filename}', 'Download failed'),
            paused: const TaskNotification(
                'Download {filename}', 'Paused with metadata {metadata}'),
            progressBar: true)
        .configureNotification(
            // for the 'Download & Open' dog picture
            // which uses 'download' which is not the .defaultGroup
            // but the .await group so won't use the above config
            complete: const TaskNotification(
                'Download {filename}', 'Download complete'),
            tapOpensFile: false, progressBar: true); // dog can also open directly from tap
    // Listen to updates and process
    emit(DownloadInitial());
    FileDownloader().updates.listen((update) async {
      // DownloadTaskUpdateState downloadTaskUpdateState=
      tasks =_downloadStateUpdate( update,tasks);
     // ignore: prefer_const_constructors
     emit(DownloadTaskUpdateState());

    });
    getDownloadedTasks();

  }

  Future<List<TaskRecord>> getDownloadedTasks() async {
        emit(DownloadLoadingState());

      return _fileDownloader.database.allRecords()
          ..then((List<TaskRecord> records) {
            /// do nothing if there's no tasks in the database
            if (records.isEmpty) {
              emit(DownloadInitial());
          return;
        }

        /// Clear List so we can use it multiple times
            tasks.clear();
            for (TaskRecord record in records) {
              log('record:$record');
              final Task task = record.task;

              if (task is DownloadTask) tasks.add(TaskWithUpdates(task,statusUpdate: TaskStatusUpdate(task, record.status,record.exception),progressUpdate: TaskProgressUpdate(task, record.progress,record.expectedFileSize)));
            }

            /// emit success;
            emit(DownloadInitial());
          }).catchError((e) {
            /// emit error;
            emit(DownloadErrorState(e.toString()));
          });
      }

  exampleDownload() async {
    List<String> links = [
      'https://dev.hindawi.org/comics/stories/418171512160/418171512160.zip',
      'https://dev.hindawi.org/comics/stories/835105395106/835105395106.zip',
      'https://dev.hindawi.org/comics/stories/874162025974/874162025974.zip',
    ];

    for (String link in links) {
      await addDownloadTask(link, pop: false);
    }
  }

  addDownloadTask(String url, {bool pop = true}) async {
    emit(DownloadEnqueuedLoadingState());

    bool taskExists = tasks.any((element) => element.task.url==url);

    if (taskExists) {
      // Emit Error;
      emit(const DownloadEnqueuedErrorState('Task Already Exist!'));
      log('task exists');

      return;
    }
    // final String id = (tasks.isEmpty)?'1':(tasks.length+1).toString();
    final id =UniqueKey().toString();
    print(id);
    final DownloadTask task = await DownloadTask(
      url: url,
      taskId: id,
      allowPause: true,
      updates: Updates.statusAndProgress,
      baseDirectory: BaseDirectory.applicationDocuments
    ).withSuggestedFilename();
    try {
      await _fileDownloader.enqueue(task);
      tasks.add(TaskWithUpdates(task, statusUpdate: TaskStatusUpdate(task,TaskStatus.enqueued), progressUpdate: TaskProgressUpdate(task, 0),),);

      /// emit success;
      log('task enqueued');
      emit(DownloadTaskEnqueuedState(pop: pop));
    } catch (e, s) {
      log('$e\n$s');

      /// emit error;
      emit(DownloadEnqueuedErrorState(e.toString()));
    }
  }
 Future<bool> deleteDownloadTask(String taskId) async{
   try {
     bool cancel= await _fileDownloader.cancelTaskWithId(taskId);
        if(cancel) tasks.removeWhere((element) => element.task.taskId==taskId);
        print(tasks);
        // ignore: prefer_const_constructors
        emit(DownloadTaskUpdateState());
     return cancel;
    }
    catch(e){
     return false;
    }
  }
  Future<bool> deleteAllDownloadTasks() async {
   try{
     await FileDownloader().cancelTasksWithIds(tasks.map((e) => e.task.taskId).toList());
   await FileDownloader().database.deleteAllRecords();
    tasks=[];
    emit(const DownloadTaskUpdateState());
    return true;
   }
       catch(e){
     return false;
       }
  }
}
