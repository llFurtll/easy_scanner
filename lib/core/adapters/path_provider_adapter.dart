import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:reflect_inject/global/instances.dart';

abstract class PathProviderAdapter {
  Future<Directory> getDirectory();
}

@reflection
class PathProviderAdapterImpl extends PathProviderAdapter {
  @override
  Future<Directory> getDirectory() async {
    final directoryApplication = await getApplicationDocumentsDirectory();
    final documentsDirectory =
      Directory("${directoryApplication.path}/documents");
    if (!documentsDirectory.existsSync()) {
      documentsDirectory.createSync();
    }

    return documentsDirectory;
  }
}
