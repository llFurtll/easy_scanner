class FolderExistsException implements Exception {
  final String message;

  const FolderExistsException(this.message);
}