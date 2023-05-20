import 'dart:io';

import 'package:flutter/material.dart';
import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../../core/adapters/awesome_dialog_adapter.dart';
import '../../../../../core/notifiers/list_notifier.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/scanner.dart';
import '../../../domain/usecases/get_images.dart';
import '../widgets/document_scanner_item.dart';

@reflection
class ListDocumentScannerController with AutoInject {
  // INJECTS
  @Inject(nameSetter: "setGetImages")
  late GetImages getImages;

  // KEYS
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // VARIABLES
  final scannersToDelete = <Scanner>[];
  
  // NOTIFIERS
  final scanners = ListNotifier<Scanner>(value: []);
  final isEdit = ValueNotifier(false);
  final messagePdf = ValueNotifier("Aguarde, gerando o PDF...");

  ListDocumentScannerController() {
    super.inject();
  }

  void showInfo() {
    AwesomeDialogAdapter.showDialog(
      context: scaffoldKey.currentContext!,
      type: TypeDialog.info,
      title: "Estamos quase lá!",
      desc: "Aqui você poderá realizar os escaneamentos "
            "e no final será criado um PDF com todas as fotos!",
      textCancel: "Fechar",
      textOk: "Maravilha 🙂",
      btnCancel: () {},
      btnOk: () {}
    );
  }

  void takeImages() async {
    final response = await getImages(NoParams());
    response.fold((left) => null, (right) {
      scanners.value.addAll(right);
      scanners.emit();
    });
  }

  void generatePdf() {
    showDialog(
      barrierDismissible: false,
      context: scaffoldKey.currentContext!,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0)
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(width: 20.0),
                  ValueListenableBuilder(
                    valueListenable: messagePdf,
                    builder: (context, value, child) => Text(value),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    return;

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.ListView(
            children: scanners.value.map(
              (item) => pw.Image(
                pw.MemoryImage(
                  File(item.path).readAsBytesSync()
                )
              )
            ).toList(),
            padding: const pw.EdgeInsets.all(5.0),
            spacing: 10.0
          );
        }
      )
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
      AwesomeDialogAdapter.showDialog(
        context: scaffoldKey.currentContext!,
        type: TypeDialog.warning,
        title: "Atenção",
        desc: "Você precisa selecionar pelo menos um item!",
        textCancel: "Fechar",
        textOk: "Tudo bem!",
        btnCancel: () {},
        btnOk: () async {}
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

        AwesomeDialogAdapter.showDialog(
          context: scaffoldKey.currentContext!,
          type: TypeDialog.success,
          title: "Finalizado",
          desc: "As fotos selecionadas foram removidas!",
          textCancel: "Fechar",
          textOk: "Obrigado 🙂",
          btnCancel: () {},
          btnOk: () {}
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
}