import 'dart:io';

import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../../../../core/adapters/path_adapter.dart';
import '../../../../core/databases/storage.dart';
import '../../../../core/exceptions/custom_exceptions.dart';
import '../../../../core/utils/get_file_size.dart';
import '../models/folder_model.dart';

abstract class FolderDataSource {
  Future<List<FolderModel>> find();
  Future<FolderModel> create(String name);
}

@reflection
class FolderDataSourceImpl extends FolderDataSource with AutoInject {
  @Inject(nameSetter: "setDataSource", type: DirectoryStorage)
  late final Storage<Directory> storage;

  @Inject(nameSetter: "setPath", type: PathAdapterImpl)
  late final PathAdapter pathAdapter;


  FolderDataSourceImpl() {
    super.inject();
  }

  @override
  Future<List<FolderModel>> find() async {
    List<FolderModel> result = [];

    final directory = await storage.getStorage();
    for (FileSystemEntity folder in directory.listSync()) {
      if (FileSystemEntity.isDirectorySync(folder.path)) {
        String size = await getFileSize(folder.path);
        result.add(
          FolderModel(
            name: pathAdapter.basename(folder.path),
            path: folder.path,
            size: size
          )
        );
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
  
  @override
  Future<FolderModel> create(String name) async {
    final directory = await storage.getStorage();
    final newFolder = Directory("${directory.path}/name");
    if (newFolder.existsSync()) {
      throw const FolderExistsException("folder-exists");
    }

    newFolder.createSync();
    String size = await getFileSize(newFolder.path);
    return FolderModel(
      name: name,
      path: newFolder.path,
      size: size
    );
  }
}