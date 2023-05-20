import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../../../../core/failures/failures.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/repositories/document_repository_impl.dart';
import '../entities/document.dart';
import '../repositories/document_repository.dart';

@reflection
class GetDeleteDocument extends UseCase<bool, DeleteDocumentParams> with AutoInject {
  @Inject(nameSetter: "setRepository", type: DocumentRepositoryImpl)
  late final DocumentRepository repository;

  GetDeleteDocument() {
    super.inject();
  }

  @override
  Future<Result<Failure, bool>> call(DeleteDocumentParams params) async {
    final result = await repository.delete(documents: params.documents, nameFolder: params.nameFolder);
    return result.fold(
      (left) => Left(
        UseCaseFailure(
          message: "Aconteceu algum problema :(! Por favor tente novamente!)"
        )
      ),
      (right) => Right(right)
    );
  }

  set setRepository(DocumentRepository repository) {
    this.repository = repository;
  }
}

class DeleteDocumentParams extends Params {
  final List<Document> documents;
  final String nameFolder;

  DeleteDocumentParams({
    required this.documents,
    required this.nameFolder
  });
}