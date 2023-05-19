import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../controller/list_document_scanner_controller.dart';

@reflection
// ignore: must_be_immutable
class ListDocumentScanner extends StatefulWidget with AutoInject {
  @Inject(nameSetter: "setController")
  late ListDocumentScannerController controller;

  ListDocumentScanner({super.key}) {
    super.inject();
  }

  @override
  ListDocumentScannerState createState() => ListDocumentScannerState();

  set setController(ListDocumentScannerController controller) {
    this.controller = controller;
  }
}

class ListDocumentScannerState extends State<ListDocumentScanner> {

  @override
  void dispose() {
    widget.controller.scanners.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.controller.scaffoldKey,
      appBar: _buildAppBar(),
      floatingActionButton: _buildFab(),
    );
  }

  Widget _buildFab() {
    return SpeedDial(
      backgroundColor: Colors.blue.shade700,
      icon: Icons.arrow_upward,
      activeIcon: Icons.arrow_downward,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.camera),
          label: "Usar a câmera",
          onTap: widget.controller.toCamera
        ),
        SpeedDialChild(
          child: const Icon(Icons.photo),
          label: "Usar a galeria",
          onTap: widget.controller.toGallery
        )
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      toolbarHeight: 100.0,
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(150.0)
        )
      ),
      backgroundColor: Colors.blue.shade700,
      title: const Text("Tirar fotos"),
      titleTextStyle: const TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.bold
      ),
      actions: [
        IconButton(
          onPressed: widget.controller.showInfo,
          icon: const Icon(Icons.info)
        )
      ],
    );
  }
}