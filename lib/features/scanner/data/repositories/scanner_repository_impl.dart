import '../../domain/entities/scanner.dart';
import '../../../../core/result/result.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/repositories/scanner_repository.dart';

class ScannerRepositoryImpl extends ScannerRepository {
  @override
  Future<Result<Failure, Scanner>> generate() async {
    // TODO: implement generate
    throw UnimplementedError();
  }
}