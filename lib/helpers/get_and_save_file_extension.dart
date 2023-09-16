import 'dart:io';
import 'dart:typed_data';

import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

Future<void> getAndSaveExtension(String path) async {
  String? mimeType = lookupMimeType(path);
  if (mimeType == null) {
    FileSystemEntity file = (await getApplicationDocumentsDirectory())
        .listSync()
        .firstWhere((element) => element.path == path);
    Uint8List fileBytes = File(path).readAsBytesSync();
    String extension = extensionFromMime(
        lookupMimeType(path, headerBytes: fileBytes).toString());
    file.renameSync('${file.path}.$extension');
  }
}
