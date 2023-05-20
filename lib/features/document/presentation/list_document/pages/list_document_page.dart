import 'package:flutter/material.dart';
import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../controller/list_document_controller.dart';
import '../widgets/list_document_item.dart';

@reflection
class ListDocumentPage extends StatefulWidget with AutoInject {
  @Inject(nameSetter: "setController")
  late final ListDocumentController controller;

  ListDocumentPage({super.key}) {
    super.inject();
  }

  @override
  ListDocumentPageState createState() => ListDocumentPageState();

  set setController(ListDocumentController controller) {
    this.controller = controller;
  }
}

class ListDocumentPageState extends State<ListDocumentPage> {

  @override
  void didChangeDependencies() {
    final folder = ModalRoute.of(context)!.settings.arguments as String;
    widget.controller.nameFolder = folder;
    widget.controller.loadDocuments(folder);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    widget.controller.documents.clear();
    widget.controller.isLoading.value = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.controller.scaffoldKey,
      appBar: _buildAppBar(),
      body: ValueListenableBuilder<bool>(
        valueListenable: widget.controller.isLoading,
        builder: (context, value, child) {
          if (value) {
            return const Center(child: CircularProgressIndicator());
          }

          final isEmpty = widget.controller.documents.isEmpty;

          if (isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
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

          final items = widget.controller.documents;
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
                    onPressed: widget.controller.setEdit,
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    child: ValueListenableBuilder(
                      valueListenable: widget.controller.isEdit,
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
                      notifier: widget.controller.isEdit,
                      onChanged: widget.controller.changeSelectItem,
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
      valueListenable: widget.controller.isEdit,
      builder: (context, value, child) {
        return FloatingActionButton(
          onPressed: value ?
            widget.controller.defeleteDocuments :
            () => Navigator.of(context).pushNamed(
              "/scanners",
              arguments: widget.controller.nameFolder
            ).then((_) => widget.controller.loadDocuments(widget.controller.nameFolder)),
          backgroundColor: value ? Colors.red : Colors.blue.shade700,
          child: Icon(value ? Icons.delete : Icons.add),
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
      title: Text(widget.controller.nameFolder),
      titleTextStyle: const TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.bold
      ),
    );
  }
}