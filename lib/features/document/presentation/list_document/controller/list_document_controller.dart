import 'package:flutter/material.dart';
import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../../../domain/entities/document.dart';
import '../../../domain/usecases/get_documents.dart';

@reflection
class ListDocumentController with AutoInject {
  // INJECT
  @Inject(nameSetter: "setGetDocuments")
  late final GetDocuments getDocuments;
  
  // NOTIFIERS
  final isLoading = ValueNotifier(true);

  // VARIABLES
  final List<Document> documents = [];

  ListDocumentController() {
    super.inject();
  }

  void loadDocuments(String folder) async {
    final result = await getDocuments(GetDocumentsParams(folder: folder));
    result.fold((left) => null, (right) => documents.addAll(right));
    documents.add(const Document(name: "Minha CNH", path: ""));
    documents.add(const Document(name: "Meu RG", path: ""));
    isLoading.value = false;
  }

  set setGetDocuments(GetDocuments getDocuments) {
    this.getDocuments = getDocuments;
  }
}