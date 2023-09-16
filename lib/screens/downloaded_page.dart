import 'package:background_downloader/background_downloader.dart';
import 'package:not_lame_downloader/cubits/download_cubit/download_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DownloadedPage extends StatelessWidget {
  const DownloadedPage({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<DownloadCubit,DownloadState>(
      listener: (context,state){
        if(state is DownloadTaskUpdateState){
          final update=state.update;
          if(update is TaskStatusUpdate){
            print(update.status);
          }
          else{
            print(update);
          }
        }
      },
      builder: (context,state) {
        final List<DownloadTask> tasks=DownloadCubit.get(context).tasks;
        print(tasks);
        return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context,index){
          return Container(
            height: 20,
            width: 30,
            color: CupertinoColors.systemRed,);
        });
      }
    );
  }
}
