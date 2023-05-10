import 'dart:io';

import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../../../../core/adapters/path_adapter.dart';
import '../../../../core/datasources/datasource.dart';
import '../models/document_model.dart';

abstract class DocumentDataSource {
  Future<List<DocumentModel>> find();
}

@reflection
class DocumentDataSourceImpl extends DocumentDataSource with AutoInject {
  @Inject(nameSetter: "setDataSource", type: DirectoryDataSource)
  late final DataSource<Directory> dataSource;

  @Inject(nameSetter: "setPath", type: PathAdapterImpl)
  late final PathAdapter pathAdapter;

  DocumentDataSourceImpl() {
    super.inject();
  }

  @override
  Future<List<DocumentModel>> find() async {
    List<DocumentModel> result = [];
    Directory directory = await dataSource.getDataSource();
    for (FileSystemEntity file in directory.listSync()) {
      if (file is File) {
        result.add(
          DocumentModel(
            name: pathAdapter.basename(file.path),
            path: file.path
          )
        );
      }
    }

    return result;
  }

  set setDataSource(DataSource<Directory> dataSource) {
    this.dataSource = dataSource;
  }
  
  set setPath(PathAdapter pathAdapter) {
    this.pathAdapter = pathAdapter;
  }
}