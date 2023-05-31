import 'package:flutter/material.dart';
import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../../../../../core/adapters/awesome_dialog_adapter.dart';
import '../../../domain/entities/document.dart';
import '../../../domain/usecases/get_delete_document.dart';
import '../../../domain/usecases/get_documents.dart';
import '../widgets/list_document_item.dart';

@reflection
class ListDocumentController with AutoInject {
  // INJECT
  @Inject(nameSetter: "setGetDocuments", global: true)
  late final GetDocuments getDocuments;

  @Inject(nameSetter: "setGetDeleteDocument", global: true)
  late final GetDeleteDocument getDeleteDocument;
  
  // NOTIFIERS
  final isLoading = ValueNotifier(true);
  final isEdit = ValueNotifier(false);

  // VARIABLES
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final documents = <Document>[];
  final documentsToDelete = <Document>[];
  String nameFolder = "";

  ListDocumentController() {
    super.inject();
  }

  void loadDocuments(String folder) async {
    documents.clear();
    isLoading.value = true;
    final result = await getDocuments(GetDocumentsParams(folder: folder));
    result.fold((left) => null, (right) => documents.addAll(right));
    isLoading.value = false;
  }

  void setEdit() {
    documentsToDelete.clear();
    isEdit.value = !isEdit.value;
  }

  void changeSelectItem(ListDocumentItem item, bool isCheck) {
    if (isCheck) {
      documentsToDelete.add(item.document);
    } else {
      documentsToDelete.remove(item.document);
    }
  }

  void defeleteDocuments() {
    if (documentsToDelete.isEmpty) {
      AwesomeDialogAdapter.showDialogMessage(
        context: scaffoldKey.currentContext!,
        type: TypeDialog.warning,
        title: "Atenção",
        textMessage: "Você precisa selecionar pelo menos um item!",
        textButton: "Tudo bem!"
      );

      return;
    }

    AwesomeDialogAdapter.showDialog(
      context: scaffoldKey.currentContext!,
      type: TypeDialog.question,
      title: "Cuidado",
      desc: "Certeza que você deseja prosseguir? Seus dados deletados serão perdidos!",
      textCancel: "Não quero",
      textOk: "Pode continuar",
      btnCancel: () {
        isEdit.value = false;
      },
      btnOk: () async {
        final response = await getDeleteDocument(
          DeleteDocumentParams(documents: documentsToDelete, nameFolder: nameFolder)
        );
        response.fold(
          (left) {
            AwesomeDialogAdapter.showDialog(
              context: scaffoldKey.currentContext!,
              type: TypeDialog.error,
              title: "Ah não :(",
              desc: left.message,
              textCancel: "Fechar",
              textOk: "Beleza",
              btnCancel: () {},
              btnOk: () {}
            );
          },
          (right) {
            loadDocuments(nameFolder);
            documentsToDelete.clear();
            isEdit.value = false;
            AwesomeDialogAdapter.showDialogMessage(
              context: scaffoldKey.currentContext!,
              type: TypeDialog.success,
              title: "Finalizado",
              textMessage: "Os documentos solicitados foram removidos!",
              textButton: "Obrigado 🙂",
            );
          }
        );
      }
    );
  }

  set setGetDocuments(GetDocuments getDocuments) {
    this.getDocuments = getDocuments;
  }

  set setGetDeleteDocument(GetDeleteDocument getDeleteDocument) {
    this.getDeleteDocument = getDeleteDocument;
  }
}