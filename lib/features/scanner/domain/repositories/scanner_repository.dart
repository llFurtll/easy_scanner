import '../../../../core/failures/failures.dart';
import '../../../../core/result/result.dart';
import '../entities/scanner.dart';

abstract class ScannerRepository {
  Future<Result<Failure, List<Scanner>>> getImages();
}