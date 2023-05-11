import 'dart:async';

import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../../../../core/failures/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/document.dart';
import '../../domain/repositories/document_repository.dart';
import '../datasources/document_data_source.dart';

@reflection
class DocumentRepositoryImpl extends DocumentRepository with AutoInject {
  @Inject(nameSetter: "setDataSource", type: DocumentDataSourceImpl)
  late final DocumentDataSource dataSource;

  DocumentRepositoryImpl() {
    super.inject();
  }

  @override
  Future<Result<Failure, List<Document>>> find(String folder) async {
    final result = await dataSource.find(folder);
    return Right(result);
  }

  set setDataSource(DocumentDataSource dataSource) {
    this.dataSource = dataSource;
  }
}