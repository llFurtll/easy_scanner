import '../../domain/entities/folder.dart';

class FolderModel extends Folder {
  const FolderModel({
    required super.name,
    required super.path,
    required super.size
  });

  factory FolderModel.fromEntity(Folder entity) {
    return FolderModel(name: entity.name, path: entity.path, size: entity.size);
  }

  static List<FolderModel> listEntity(List<Folder> entities) {
    return entities.map((entity) => FolderModel.fromEntity(entity)).toList();
  }
}