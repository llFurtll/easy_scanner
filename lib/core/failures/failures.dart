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

class UseCaseFailure extends Failure {
  UseCaseFailure({required super.message});
}