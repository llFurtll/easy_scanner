import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../../../../core/failures/failures.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/repositories/folder_repository_impl.dart';
import '../entities/folder.dart';
import '../repositories/folder_repository.dart';

@reflection
class GetDeleteFolders extends UseCase<bool, DeleteFoldersParams> with AutoInject {
  @Inject(nameSetter: "setRepository", type: FolderRepositoryImpl, global: true)
  late final FolderRepository repository;

  GetDeleteFolders() {
    super.inject();
  }

  @override
  Future<Result<Failure, bool>> call(params) async {
    final result = await repository.delete(params.folders);
    return result.fold(
      (left) => Left(
        UseCaseFailure(
          message: "Aconteceu algum problema :(! Por favor tente novamente!)"
        )
      ),
      (right) => Right(right)
    );
  }
  
  set setRepository(FolderRepository repository) {
    this.repository = repository;
  }
}

class DeleteFoldersParams extends Params {
  final List<Folder> folders;

  DeleteFoldersParams({
    required this.folders
  });
}