import 'dart:io';

import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../../../../core/adapters/path_adapter.dart';
import '../../../../core/databases/storage.dart';
import '../../../../core/exceptions/custom_exceptions.dart';
import '../../../../core/utils/get_file_size.dart';
import '../models/document_model.dart';

abstract class DocumentDataSource {
  Future<List<DocumentModel>> find(String folder);
  Future<DocumentModel> create({
    required String name,
    required String folder
  });
  Future<bool> delete({
    required List<DocumentModel> documents,
    required nameFolder
  });
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
              path: file.path,
              size: await getFileSize(file.path)
            )
          );
        }
      }
    }

    return result;
  }

  @override
  Future<DocumentModel> create({required String name, required String folder}) async {
    final directory = await storage.getStorage();
    final folderSelect = Directory("${directory.path}/$folder");
    final pathDocument = File("${folderSelect.path}/$name");
    if (pathDocument.existsSync()) {
      throw const DocumentExistsException("");
    }
    pathDocument.createSync();
    return DocumentModel(name: name, path: pathDocument.path, size: await getFileSize(pathDocument.path));
  }

  @override
  Future<bool> delete({required List<DocumentModel> documents, required nameFolder}) async {
    try {
      final pathsToDelete = documents.map((e) => e.path).toList();
      final directory = await storage.getStorage();
      final folderDirectory = Directory("${directory.path}/$nameFolder");
      for (FileSystemEntity document in folderDirectory.listSync()) {
        if (pathsToDelete.contains(document.path)) {
          document.deleteSync();
        }
      }
    } catch (_) {
      throw const DocumentErrorDeleteException("");
    }

    return true;
  }

  set setDataSource(Storage<Directory> storage) {
    this.storage = storage;
  }
  
  set setPath(PathAdapter pathAdapter) {
    this.pathAdapter = pathAdapter;
  }
}