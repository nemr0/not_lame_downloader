import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';

import '../../helpers/remove_unused_files.dart';

part 'file_states.dart';

class FileCubit extends Cubit<DownloadedLoaderState> {
  FileCubit() : super(DownloadedLoaderInitial());
  late final Directory documentDirectory;
  List<FileSystemEntity> files=[];

  initializeOrUpdate({bool firstLoad = false}) async {
    if (firstLoad) {
      documentDirectory = await getApplicationDocumentsDirectory();
    }
    else{
      files.clear();
    }
    files .addAll(removeUnusedFilesFromDocumentDirectory(documentDirectory.listSync()));


    log('DownloadCubit: documentDirectory.path:${documentDirectory.path}, files:${files.toString()}');
  }
}


