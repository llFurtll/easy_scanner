class FolderExistsException implements Exception {
  final String message;

  const FolderExistsException(this.message);
}

class FolderErrorDeleteException implements Exception {
  final String message;

  const FolderErrorDeleteException(this.message);
}