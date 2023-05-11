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
class GetCreateFolder extends UseCase<Folder, CreateFolderParams> with AutoInject {
  @Inject(nameSetter: "setRepository", type: FolderRepositoryImpl)
  late final FolderRepository repository;

  GetCreateFolder() {
    super.inject();
  }

  @override
  Future<Result<Failure, Folder>> call(params) async {
    return await repository.create(params.name);
  }
  
  set setRepository(FolderRepository repository) {
    this.repository = repository;
  }
}

class CreateFolderParams extends Params {
  final String name;

  CreateFolderParams({
    required this.name
  });
}