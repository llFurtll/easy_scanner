import 'package:flutter/material.dart';
import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../controller/list_document_controller.dart';
import '../widgets/list_document_item.dart';

class ListDocumentPage extends StatefulWidget {
  const ListDocumentPage({super.key});

  @override
  ListDocumentPageState createState() => ListDocumentPageState();
}

@reflection
class ListDocumentPageState extends State<ListDocumentPage> with AutoInject {
  @Inject(nameSetter: "setController")
  late final ListDocumentController controller;

  ListDocumentPageState() {
    super.inject();
  }

  @override
  void didChangeDependencies() {
    final folder = ModalRoute.of(context)!.settings.arguments as String;
    controller.nameFolder = folder;
    controller.loadDocuments(folder);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: _buildAppBar(),
      body: ValueListenableBuilder<bool>(
        valueListenable: controller.isLoading,
        builder: (context, value, child) {
          if (value) {
            return const Center(child: CircularProgressIndicator());
          }

          final isEmpty = controller.documents.isEmpty;

          if (isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.picture_as_pdf_rounded,
                    size: 150.0,
                    color: Colors.red,
                  ),
                  Text(
                    "No momento você não criou nenhum documento 🙂",
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

          final items = controller.documents;
          return Container(
            padding: const EdgeInsets.only(
              left: 35.0,
              right: 35.0 
            ),
            child: Column(
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
                    itemCount: items.length,
                    itemBuilder: (context, index) => ListDocumentItem(
                      document: items[index],
                      notifier: controller.isEdit,
                      onChanged: controller.changeSelectItem,
                    ),
                    separatorBuilder: (context, index) => const SizedBox(height: 15.0),
                  ),
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: _buildFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }

  Widget _buildFab() {
    return ValueListenableBuilder(
      valueListenable: controller.isEdit,
      builder: (context, value, child) {
        return FloatingActionButton(
          onPressed: value ?
            controller.defeleteDocuments :
            () => Navigator.of(context).pushNamed(
              "/scanners",
              arguments: controller.nameFolder
            ).then((_) => controller.loadDocuments(controller.nameFolder)),
          backgroundColor: value ? Colors.red : Colors.blue.shade700,
          child: Icon(value ? Icons.delete : Icons.add, color: Colors.white),
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
      backgroundColor: Colors.blue.shade700,
      title: Text(controller.nameFolder),
      titleTextStyle: const TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.bold
      ),
      foregroundColor: Colors.white,
    );
  }

  set setController(ListDocumentController controller) {
    this.controller = controller;
  }
}