import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../../../../core/failures/failures.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/repositories/document_repository_impl.dart';
import '../entities/document.dart';
import '../repositories/document_repository.dart';

@reflection
class GetDocuments extends UseCase<List<Document>, NoParams> with AutoInject {
  @Inject(nameSetter: "setRepository", type: DocumentRepositoryImpl)
  late final DocumentRepository repository;

  GetDocuments() {
    super.inject();
  }

  @override
  Future<Result<Failure, List<Document>>> call(NoParams params) async {
    return await repository.find();
  }

  set setRepository(DocumentRepository repository) {
    this.repository = repository;
  }
}