import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../../../../core/exceptions/custom_exceptions.dart';
import '../../../../core/failures/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/folder.dart';
import '../../domain/repositories/folder_repository.dart';
import '../datasources/folder_data_source.dart';

@reflection
class FolderRepositoryImpl extends FolderRepository with AutoInject {
  @Inject(nameSetter: "setDataSource", type: FolderDataSourceImpl)
  late final FolderDataSource dataSource;

  FolderRepositoryImpl() {
    super.inject();
  }

  @override
  Future<Result<Failure, List<Folder>>> find() async {
    final result = await dataSource.find();
    return Right(result);
  }

  @override
  Future<Result<Failure, Folder>> create(String name) async {
    try {
      final result = await dataSource.create(name);
      return Right(result);
    } on FolderExistsException catch(e) {
      return Left(FolderExistsFailure(message: e.message));
    }
  }

  set setDataSource(FolderDataSource dataSource) {
    this.dataSource = dataSource;
  }
}