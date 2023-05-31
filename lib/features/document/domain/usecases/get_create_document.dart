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
class GetCreateDocument extends UseCase<Document, CreateDocumentParams> with AutoInject {
  @Inject(nameSetter: "setRepository", type: DocumentRepositoryImpl, global: true)
  late final DocumentRepository repository;

  GetCreateDocument() {
    super.inject();
  }

  @override
  Future<Result<Failure, Document>> call(CreateDocumentParams params) async {
    final response = await repository.create(name: params.name, folder: params.folder);

    return response.fold(
      (left) => Left(
        UseCaseFailure(
          message: "O nome utilizado já existe, por favor escolha um novo nome!"
        )
      ),
      (right) => Right(right)
    );
  }

  set setRepository(DocumentRepository repository) {
    this.repository = repository;
  }
}

class CreateDocumentParams extends Params {
  final String name;
  final String folder;

  CreateDocumentParams({
    required this.name,
    required this.folder
  });
}