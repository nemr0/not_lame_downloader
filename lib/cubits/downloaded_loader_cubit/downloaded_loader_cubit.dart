import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';

part 'downloaded_loader_state.dart';

class DownloadedLoaderCubit extends Cubit<DownloadedLoaderState> {
  DownloadedLoaderCubit() : super(DownloadedLoaderInitial());
  late final Directory documentDirectory;
  late final List<FileSystemEntity> files;

  initializeOrUpdate({bool firstLoad = false}) async {
    if (firstLoad) documentDirectory = await getApplicationDocumentsDirectory();
    print(documentDirectory.path);
    files = documentDirectory.listSync();

    files.removeWhere((element) =>
        element.path.split(Platform.pathSeparator).last == 'GetStorage.gs');
    files.removeWhere((element) =>
        element.path.split(Platform.pathSeparator).last == 'GetStorage.bak');

    log('DownloadCubit: documentDirectory.path:${documentDirectory.path}, files:${files.toString()}');
  }
}
