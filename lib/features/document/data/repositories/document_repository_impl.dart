import 'dart:async';

import 'package:easy_scanner/features/document/data/models/document_model.dart';
import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../../../../core/exceptions/custom_exceptions.dart';
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

  @override
  Future<Result<Failure, Document>> create({required String name, required String folder}) async {
    try {
      final result = await dataSource.create(name: name, folder: folder);
      return Right(result);
    } on DocumentExistsException catch (_) {
      return Left(DocumentExistsFailure(message: "document-exist"));
    }
  }

  @override
  Future<Result<Failure, bool>> delete({required List<Document> documents, required nameFolder}) async {
    try {
      final result = await dataSource.delete(documents: DocumentModel.listEntity(documents), nameFolder: nameFolder);
      return Right(result);
    } on DocumentErrorDeleteException catch (_) {
      return Left(DocumentErrorDeleteFailure(message: "error-delete-file"));
    }
  }
  
  set setDataSource(DocumentDataSource dataSource) {
    this.dataSource = dataSource;
  }
}