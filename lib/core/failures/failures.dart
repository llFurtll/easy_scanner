abstract class Failure {
  final String message;

  const Failure({
    required this.message
  });
}

class FolderExistsFailure extends Failure {
  FolderExistsFailure({required super.message});
}

class FolderErrorDeleteFailure extends Failure {
  FolderErrorDeleteFailure({required super.message});
}

class DocumentExistsFailure extends Failure {
  DocumentExistsFailure({required super.message});
}

class DocumentErrorDeleteFailure extends Failure {
  DocumentErrorDeleteFailure({required super.message});
}


class ImageDetectionFailure extends Failure {
  ImageDetectionFailure({required super.message});
}

class UseCaseFailure extends Failure {
  UseCaseFailure({required super.message});
}