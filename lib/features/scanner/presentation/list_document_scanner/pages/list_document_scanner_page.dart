import 'package:easy_scanner/features/scanner/presentation/list_document_scanner/widgets/document_scanner_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../controller/list_document_scanner_controller.dart';

// ignore: must_be_immutable
class ListDocumentScannerPage extends StatefulWidget {
  const ListDocumentScannerPage({super.key});

  @override
  ListDocumentScannerPageState createState() => ListDocumentScannerPageState();
}

@reflection
class ListDocumentScannerPageState extends State<ListDocumentScannerPage> with AutoInject {
  @Inject(nameSetter: "setController")
  late ListDocumentScannerController controller;

  ListDocumentScannerPageState() {
    super.inject();
  }

  @override
  void didChangeDependencies() {
    controller.folderName = ModalRoute.of(context)!.settings.arguments as String;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFab(),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.only(
        left: 35.0,
        right: 35.0 
      ),
      child: ValueListenableBuilder(
        valueListenable: controller.scanners,
        builder: (context, value, child) {
          if (value.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.image, size: 150.0),
                  Text(
                    "No momento você não tirou nenhuma foto 🙂",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                    ),
                    maxLines: null,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            );
          }

          return Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: controller.setEdit,
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  child: ValueListenableBuilder(
                    valueListenable: controller.isEdit,
                    builder: (context, value, child) {
                      return Text(value ? "Cancelar" : "Editar");
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: value.length,
                  itemBuilder: (context, index) => DocumentScannerItem(
                    scanner: value[index],
                    notifier: controller.isEdit,
                    position: index + 1,
                    onChanged: controller.changeSelectItem,
                  ),
                  separatorBuilder: (context, index) => const SizedBox(height: 15.0),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildFab() {
    return ValueListenableBuilder(
      valueListenable: controller.isEdit,
      builder: (context, value, child) {
        if (value) {
          return FloatingActionButton(
            onPressed: controller.deleteScanners,
            backgroundColor: Colors.red,
            child: const Icon(Icons.delete),
          );
        }

        return ValueListenableBuilder(
          valueListenable: controller.scanners,
          builder: (context, value, child) {
            return SpeedDial(
              spaceBetweenChildren: 5.0,
              backgroundColor: Colors.blue.shade700,
              icon: Icons.arrow_upward,
              activeIcon: Icons.arrow_downward,
              overlayColor: Colors.black,
              overlayOpacity: 0.5,
              children: [
                SpeedDialChild(
                  child: const Icon(Icons.camera),
                  label: "Tirar foto",
                  onTap: controller.takeImages
                ),
                SpeedDialChild(
                  child: const Icon(Icons.picture_as_pdf),
                  label: "Gerar PDF",
                  onTap: controller.setNameFile,
                  visible: value.isNotEmpty
                )
              ],
            );
          },
        );
      },
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
      leading: IconButton(
        onPressed: controller.back,
        icon: const Icon(Icons.arrow_back),
      ),
      backgroundColor: Colors.blue.shade700,
      title: const Text("Tirar fotos"),
      titleTextStyle: const TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.bold
      ),
      actions: [
        IconButton(
          onPressed: controller.showInfo,
          icon: const Icon(Icons.info)
        )
      ],
    );
  }

  set setController(ListDocumentScannerController controller) {
    this.controller = controller;
  }
}