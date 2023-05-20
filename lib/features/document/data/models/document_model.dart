import '../../domain/entities/document.dart';

class DocumentModel extends Document {
  DocumentModel({
    required super.name,
    required super.path,
    required super.size
  });

  factory DocumentModel.fromEntity(Document entity) {
    return DocumentModel(name: entity.name, path: entity.path, size: entity.size);
  }

  static List<DocumentModel> listEntity(List<Document> entities) {
    return entities.map((entity) => DocumentModel.fromEntity(entity)).toList();
  }
}