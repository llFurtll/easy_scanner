class FolderExistsException implements Exception {
  final String message;

  const FolderExistsException(this.message);
}

class FolderErrorDeleteException implements Exception {
  final String message;

  const FolderErrorDeleteException(this.message);
}

class DocumentExistsException implements Exception {
  final String message;

  const DocumentExistsException(this.message);
}

class DocumentErrorDeleteException implements Exception {
  final String message;

  const DocumentErrorDeleteException(this.message);
}

class GenerateImageException implements Exception {
  final String message;

  const GenerateImageException(this.message);
}