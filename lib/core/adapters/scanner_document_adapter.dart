import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:reflect_inject/global/instances.dart';

import '../exceptions/custom_exceptions.dart';

abstract class ScannerDocumentAdapter {
  Future<List<String>> getImages();
}

@reflection
class ScannerDocumentAdapterImpl extends ScannerDocumentAdapter{
  @override
  Future<List<String>> getImages() async {
    try {
      final images = await CunningDocumentScanner.getPictures();

      return images ?? [];
    } catch (_) {
      throw const GenerateImageException("error-generate-image");
    }
  }
}