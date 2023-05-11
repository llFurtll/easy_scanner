import 'dart:io';

import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../../../../core/adapters/path_adapter.dart';
import '../../../../core/databases/storage.dart';
import '../models/document_model.dart';

abstract class DocumentDataSource {
  Future<List<DocumentModel>> find(String folder);
}

@reflection
class DocumentDataSourceImpl extends DocumentDataSource with AutoInject {
  @Inject(nameSetter: "setDataSource", type: DirectoryStorage)
  late final Storage<Directory> storage;

  @Inject(nameSetter: "setPath", type: PathAdapterImpl)
  late final PathAdapter pathAdapter;

  DocumentDataSourceImpl() {
    super.inject();
  }

  @override
  Future<List<DocumentModel>> find(String folder) async {
    List<DocumentModel> result = [];
    final directory = await storage.getStorage();
    final folderSelect = Directory("${directory.path}/$folder");
    if (folderSelect.existsSync()) {
      for (FileSystemEntity file in folderSelect.listSync()) {
        if (file is File) {
          result.add(
            DocumentModel(
              name: pathAdapter.basename(file.path),
              path: file.path
            )
          );
        }
      }
    }

    return result;
  }

  set setDataSource(Storage<Directory> storage) {
    this.storage = storage;
  }
  
  set setPath(PathAdapter pathAdapter) {
    this.pathAdapter = pathAdapter;
  }
}