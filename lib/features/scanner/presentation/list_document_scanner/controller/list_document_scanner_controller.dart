import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../../../../../core/adapters/awesome_dialog_adapter.dart';
import '../../../../../core/notifiers/list_notifier.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/widgets/loading.dart';
import '../../../../document/domain/usecases/get_create_document.dart';
import '../../../domain/entities/scanner.dart';
import '../../../domain/usecases/get_images.dart';
import '../widgets/document_scanner_item.dart';
import '../widgets/new_pdf_dialog.dart';

@reflection
class ListDocumentScannerController with AutoInject {
  // INJECTS
  @Inject(nameSetter: "setGetImages", global: true)
  late final GetImages getImages;

  @Inject(nameSetter: "setGetCreateDocument", global: true)
  late final GetCreateDocument getCreateDocument;

  // KEYS
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  // VARIABLES
  final scannersToDelete = <Scanner>[];
  final textController = TextEditingController();
  String folderName = "";
  
  // NOTIFIERS
  final scanners = ListNotifier<Scanner>(value: []);
  final isEdit = ValueNotifier(false);
  final messagePdf = ValueNotifier("");

  ListDocumentScannerController() {
    super.inject();
  }

  void showInfo() {
    AwesomeDialogAdapter.showDialogMessage(
      context: scaffoldKey.currentContext!,
      type: TypeDialog.info,
      title: "Estamos quase lá!",
      textMessage:  "Aqui você poderá realizar os escaneamentos "
                    "e no final será criado um PDF com todas as fotos!\n\n"
                    "Uma observação, que as imagens tem uma altura máxima "
                    "de 500px(pixels). Se a imagem ultrapassar o tamanho, a mesma "
                    "será reajustada no PDF, podendo gerar perda de qualidade.\n\n"
                    "Outro ponto importante que o PDF tem um limite total de 200 "
                    "páginas.",
      textButton: "Maravilha 🙂",
    );
  }

  void takeImages() async {
    final response = await getImages(NoParams());
    response.fold((left) => null, (right) {
      scanners.value.addAll(right);
      scanners.emit();
    });
  }

  void setNameFile() {
    showDialog(
      context: scaffoldKey.currentContext!,
      builder: (context) => NewPdfDialog(
        formKey: formKey,
        onSave: () {
          if (formKey.currentState?.validate() ?? false) {
            generatePdf();
          }
        },
        textController: textController,
      ),
    );
  }

  void generatePdf() async {
    String nameFile = textController.text;
    if (!nameFile.endsWith(".pdf")) {
      nameFile = "$nameFile.pdf";
    }

    Navigator.of(scaffoldKey.currentContext!).pop();

    messagePdf.value = "Aguarde, gerando o PDF...";

    showDialog(
      barrierDismissible: false,
      context: scaffoldKey.currentContext!,
      builder: (context) => Loading(message: messagePdf),
    );

    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        maxPages: 200,
        build: (pw.Context context) {
          return scanners.value.map(
            (item) => pw.Container(
              constraints: const pw.BoxConstraints(
                maxHeight: 500.0
              ),
              padding: const pw.EdgeInsets.only(bottom: 20.0),
              child: pw.Image(
                fit: pw.BoxFit.contain,
                pw.MemoryImage(
                  File(item.path).readAsBytesSync()
                )
              )
            )
          ).toList();
        }
      )
    );

    messagePdf.value = "Aguarde, criando PDF...";

    final response = await getCreateDocument(CreateDocumentParams(name: nameFile, folder: folderName));

    messagePdf.value = "Aguarde, salvando PDF...";

    bool isError = false;
    await response.fold(
      (left) {
        Navigator.of(scaffoldKey.currentContext!).pop();
        AwesomeDialogAdapter.showDialogMessage(
          context: scaffoldKey.currentContext!,
          type: TypeDialog.error,
          title: "Ah não :(",
          textMessage: left.message,
          textButton: "Beleza",
        );
        isError = true;
      },
      (right) async {
        final file = File(right.path);
        file.writeAsBytesSync(await pdf.save());
      }
    );

    if (isError) {
      return;
    }

    Navigator.of(scaffoldKey.currentContext!).pop();

    AwesomeDialogAdapter.showDialogMessage(
      context: scaffoldKey.currentContext!,
      type: TypeDialog.success,
      title: "Parabéns",
      textMessage: "Seu PDF foi criado com sucesso 🙂",
      textButton: "Show!",
      onPressed: () {
        Navigator.of(scaffoldKey.currentContext!).pop();
      }
    );
  }

  void setEdit() {
    isEdit.value = !isEdit.value;
  }

  void changeSelectItem(DocumentScannerItem item, bool isCheck) {
    if (isCheck) {
      scannersToDelete.add(item.scanner);
    } else {
      scannersToDelete.remove(item.scanner);
    }
  }

  void deleteScanners() {
    if (scannersToDelete.isEmpty) {
      AwesomeDialogAdapter.showDialogMessage(
        context: scaffoldKey.currentContext!,
        type: TypeDialog.warning,
        title: "Atenção",
        textMessage: "Você precisa selecionar pelo menos um item!",
        textButton: "Tudo bem!",
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
      btnOk: () {
        scanners.value.removeWhere((item) => scannersToDelete.contains(item));
        scannersToDelete.clear();
        isEdit.value = false;
        scanners.emit();

        AwesomeDialogAdapter.showDialogMessage(
          context: scaffoldKey.currentContext!,
          type: TypeDialog.success,
          title: "Finalizado",
          textMessage: "As fotos selecionadas foram removidas!",
          textButton: "Obrigado 🙂",
        );
      }
    );
  }

  void back() {
    if (scanners.value.isNotEmpty) {
        AwesomeDialogAdapter.showDialog(
        context: scaffoldKey.currentContext!,
        type: TypeDialog.warning,
        title: "Atenção",
        desc: "Se você sair sem gerar o PDF, as fotos serão perdidas!",
        textCancel: "Cancelar",
        textOk: "Tudo bem, quero sair!",
        btnCancel: () {},
        btnOk: () {
          Navigator.of(scaffoldKey.currentContext!).pop();
        }
      );
    } else {
      Navigator.of(scaffoldKey.currentContext!).pop();
    }
  }

  set setGetImages(GetImages getImages) {
    this.getImages = getImages;
  }

  set setGetCreateDocument(GetCreateDocument getCreateDocument) {
    this.getCreateDocument = getCreateDocument;
  }
}