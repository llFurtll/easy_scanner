import 'dart:async';

import '../../../../core/failures/failures.dart';
import '../../../../core/result/result.dart';
import '../entities/document.dart';

abstract class DocumentRepository {
  Future<Result<Failure, List<Document>>> find(String folder);
  Future<Result<Failure, Document>> create({required String name, required String folder});
  Future<Result<Failure, bool>> delete({required List<Document> documents, required nameFolder});
}