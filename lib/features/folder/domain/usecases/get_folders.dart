import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../../../../core/failures/failures.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/repositories/folder_repository_impl.dart';
import '../entities/folder.dart';
import '../repositories/folder_repository.dart';

@reflection
class GetFolders extends UseCase<List<Folder>, NoParams> with AutoInject {
  @Inject(nameSetter: "setRepository", type: FolderRepositoryImpl)
  late final FolderRepository repository;

  GetFolders() {
    super.inject();
  }

  @override
  Future<Result<Failure, List<Folder>>> call(NoParams params) async {
    return repository.find();
  }

  set setRepository(FolderRepository repository) {
    this.repository = repository;
  }
}