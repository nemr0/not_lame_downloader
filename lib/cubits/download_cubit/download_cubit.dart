import 'dart:developer';

import 'package:background_downloader/background_downloader.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../helpers/callbacks/notification_tap_call_back.dart';

part 'download_state.dart';

class DownloadCubit extends Cubit<DownloadState> {
  DownloadCubit() : super(DownloadInitial());
  List<DownloadTask>tasks =[];
  static get(BuildContext context) => BlocProvider.of<DownloadCubit>(context);
  initialize(){
    // configure notification for all tasks
    FileDownloader().configureNotification(
        running: const TaskNotification('Downloading', 'file: {filename}'),
        complete: const TaskNotification('Download finished', 'file: {filename}'),
        progressBar: true
    );
    //configure global
    FileDownloader().configure(globalConfig: [
      (Config.requestTimeout, const Duration(seconds: 100)),
    ], androidConfig: [
      (Config.useCacheDir, Config.whenAble),
    ], iOSConfig: [
      (Config.localize, {'Cancel': 'Stop It'}),
    ]).then((result) => debugPrint('Configuration result = $result'));

    // Registering a callback and configure notifications
    FileDownloader()
        .registerCallbacks(
        taskNotificationTapCallback: myNotificationTapCallback)
        .configureNotificationForGroup(FileDownloader.defaultGroup,
        // For the main download button
        // which uses 'enqueue' and a default group
        running: const TaskNotification('Download {filename}',
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
        tapOpensFile: true); // dog can also open directly from tap
    // Listen to updates and process
    FileDownloader().updates.listen((update) {
      switch (update) {
        case TaskStatusUpdate _:
          for(int i=0;i<tasks.length;i++){
            if(tasks[i]==update.task){
              tasks[i]==update.task;
              // ignore: prefer_const_constructors
              emit( DownloadTaskUpdateState(update));
              break;
            }
          }


        case TaskProgressUpdate _:

        // ignore: prefer_const_constructors
          emit( DownloadTaskUpdateState(update));
      }
    });
  }
  getDownloadedFiles()async{
   await FileDownloader().database.allRecords().then((value){
     /// do nothing if there's no tasks in the database
     if(value.isEmpty)return;
     /// Clear List so we can use it multiple times
     tasks.clear();
     for (TaskRecord record in value){
       final Task task=record.task;
      if (task is DownloadTask){
        tasks.add(task);
      }
     }
     /// emit success;
     emit(DownloadInitial());
   }).catchError((e){
     /// emit error;
     emit(DownloadErrorState(e.toString()));
   });

  }
  addDownloadTask(String url,) async {


emit(DownloadEnqueuedLoadingState());


       bool taskExists= tasks.any((element) => url==element.url);

        if(taskExists){
          // Emit Error;
            emit(const DownloadEnqueuedErrorState('Task Already Exist!'));
            log('task exists');

          return;
        }
        final String id = tasks.isEmpty?'1':tasks.length.toString();
        final DownloadTask task=DownloadTask(url: url,
        taskId: id,
        allowPause: true,
          updates: Updates.statusAndProgress
        );
        try{
        await FileDownloader().enqueue(task);
        tasks.add(task);
        /// emit success;
          log('task enqueued');
          emit(DownloadTaskEnqueuedState());
        }
            catch (e,s){
          log('$e\n$s');
          /// emit error;
              emit(DownloadEnqueuedErrorState(e.toString()));
            }

  }



}
