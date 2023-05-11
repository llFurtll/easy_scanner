import '../../../../core/failures/failures.dart';
import '../../../../core/result/result.dart';
import '../entities/folder.dart';

abstract class FolderRepository {
  Future<Result<Failure, List<Folder>>> find();
}