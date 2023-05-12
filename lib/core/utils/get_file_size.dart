import 'dart:io';
import 'dart:math';

Future<String> getFileSize(String path) async {
  var file = File(path);
  int bytes = await file.length();
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1024)).floor();
  return "${((bytes / pow(1024, i)))} ${suffixes[i]}";
}

Future<String> getFileFolder(String path) async {
  final dir = Directory(path);
  int totalBytes = 0;
  for (FileSystemEntity file in dir.listSync()) {
    if (file is File) {
      totalBytes += file.lengthSync();
    }
  }

  if (totalBytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(totalBytes) / log(1024)).floor();
  return "${((totalBytes / pow(1024, i)))} ${suffixes[i]}";
}