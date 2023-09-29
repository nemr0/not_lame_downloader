import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';

import '../../helpers/remove_unused_files.dart';

part 'downloaded_loader_state.dart';

class DownloadedLoaderCubit extends Cubit<DownloadedLoaderState> {
  DownloadedLoaderCubit() : super(DownloadedLoaderInitial());
  late final Directory documentDirectory;
  late final List<FileSystemEntity> files;

  initializeOrUpdate({bool firstLoad = false}) async {
    if (firstLoad) documentDirectory = await getApplicationDocumentsDirectory();
    files = removeUnusedFilesFromDocumentDirectory(documentDirectory.listSync());


    log('DownloadCubit: documentDirectory.path:${documentDirectory.path}, files:${files.toString()}');
  }
}


