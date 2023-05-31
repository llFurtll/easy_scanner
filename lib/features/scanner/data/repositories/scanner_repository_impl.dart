import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../../../../core/adapters/scanner_document_adapter.dart';
import '../../../../core/exceptions/custom_exceptions.dart';
import '../../../../core/failures/failures.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/get_file_size.dart';
import '../../domain/entities/scanner.dart';
import '../../domain/repositories/scanner_repository.dart';

@reflection
class ScannerRepositoryImpl extends ScannerRepository with AutoInject {
  @Inject(nameSetter: "setScannerDocument", type: ScannerDocumentAdapterImpl)
  late final ScannerDocumentAdapter scannerDocument;

  ScannerRepositoryImpl() {
    super.inject();
  }

  @override
  Future<Result<Failure, List<Scanner>>> getImages() async {
    try {
      final list = <Scanner>[];
      final detection = await scannerDocument.getImages();
      for (String path in detection) {
        list.add(Scanner(path: path, size: await getFileSize(path)));
      }
      return Right(list);
    } on GenerateImageException catch (e) {
      return Left(ImageDetectionFailure(message: e.message));
    }
  }

  set setScannerDocument(ScannerDocumentAdapter scannerDocument) {
    this.scannerDocument = scannerDocument;
  }
}