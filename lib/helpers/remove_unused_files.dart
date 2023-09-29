import 'dart:io';
/// Removes Un processable files from files List of Application Document Directory
///------------------------------------
/// Removing the following Files:
/// - 'GetStorage.bak'
/// - 'GetStorage.gs'
/// - '.DS_Store'
List<FileSystemEntity> removeUnusedFilesFromDocumentDirectory(List<FileSystemEntity> files) {

  files.removeWhere((element) =>
  element.path.split(Platform.pathSeparator).last == 'GetStorage.bak' ||
      element.path.split(Platform.pathSeparator).last == 'GetStorage.gs' ||
      element.path.split(Platform.pathSeparator).last == '.DS_Store');

  return files;
}