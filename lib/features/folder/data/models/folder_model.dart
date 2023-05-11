import '../../domain/entities/folder.dart';

class FolderModel extends Folder {
  const FolderModel({
    required super.name,
    required super.path,
    required super.size
  });
}