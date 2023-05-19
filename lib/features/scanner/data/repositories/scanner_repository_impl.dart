import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../../../../core/adapters/edge_detection_adapter.dart';
import '../../../../core/exceptions/custom_exceptions.dart';
import '../../../../core/failures/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/scanner.dart';
import '../../domain/repositories/scanner_repository.dart';

@reflection
class ScannerRepositoryImpl extends ScannerRepository with AutoInject {
  @Inject(nameSetter: "setEdgeDetection", type: EdgeDetectionAdapterImpl)
  late final EdgeDetectionAdapter edgeDetection;

  ScannerRepositoryImpl() {
    super.inject();
  }

  @override
  Future<Result<Failure, Scanner>> getCamera() async {
    try {
      final detection = await edgeDetection.getImage(TypeEdgeDetection.camera);
      final scanner = Scanner(path: detection);
      return Right(scanner);
    } on GenerateImageException catch (e) {
      return Left(ImageDetectionFailure(message: e.message));
    }
  }

  @override
  Future<Result<Failure, Scanner>> getGallery() async {
    try {
      final detection = await edgeDetection.getImage(TypeEdgeDetection.gallery);
      final scanner = Scanner(path: detection);
      return Right(scanner);
    } on GenerateImageException catch (e) {
      return Left(ImageDetectionFailure(message: e.message));
    }
  }

  set setEdgeDetection(EdgeDetectionAdapter edgeDetection) {
    this.edgeDetection = edgeDetection;
  }
}