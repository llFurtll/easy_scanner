import '../../../../core/failures/failures.dart';
import '../../../../core/result/result.dart';
import '../entities/folder.dart';

abstract class FolderRepository {
  Future<Result<Failure, List<Folder>>> find();
  Future<Result<Failure, Folder>> create(String name);
  Future<Result<Failure, bool>> delete(List<Folder> folders);
}