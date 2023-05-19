import 'package:flutter/material.dart';
import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../../../../../core/adapters/awesome_dialog_adapter.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/scanner.dart';
import '../../../domain/usecases/get_scanner_camera.dart';
import '../../../domain/usecases/get_scanner_gallery.dart';

@reflection
class ListDocumentScannerController with AutoInject {
  // INJECTS
  @Inject(nameSetter: "setGetScannerCamera")
  late GetScannerCamera getScannerCamera;

  @Inject(nameSetter: "setGetScannerGallery")
  late GetScannerGallery getScannerGallery;

  // KEYS
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  // VARIABLES
  final List<Scanner> scanners = [];

  ListDocumentScannerController() {
    super.inject();
  }

  void showInfo() {
    AwesomeDialogAdapter.showDialog(
      context: scaffoldKey.currentContext!,
      type: TypeDialog.info,
      title: "Estamos quase lá!",
      desc: "Aqui você poderá realizar os escaneamentos "
            "e no final será criado um PDF com todos os documentos escaneados!",
      textCancel: "Fechar",
      textOk: "Maravilha 🙂",
      btnCancel: () {},
      btnOk: () {}
    );
  }

  void toCamera() async {
    final response = await getScannerCamera(NoParams());
    response.fold((left) => null, (right) => scanners.add(right));
    print(scanners);
  }

  void toGallery() async {
    final response = await getScannerGallery(NoParams());
    response.fold((left) => null, (right) => scanners.add(right));
    print(scanners);
  }

  set setGetScannerCamera(GetScannerCamera getScannerCamera) {
    this.getScannerCamera = getScannerCamera;
  }

  set setGetScannerGallery(GetScannerGallery getScannerGallery) {
    this.getScannerGallery = getScannerGallery;
  }
}