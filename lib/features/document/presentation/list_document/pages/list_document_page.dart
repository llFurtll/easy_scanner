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
    widget.controller.loadDocuments(folder);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.documents.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ValueListenableBuilder<bool>(
        valueListenable: widget.controller.isLoading,
        builder: (context, value, child) {
          if (value) {
            return const Center(child: CircularProgressIndicator());
          }

          final isEmpty = widget.controller.documents.isEmpty;

          if (isEmpty) {
            return const Center(child: Text("Nenhum documento encontrado!"));
          } 

          final items = widget.controller.documents;
          return ListView.separated(
            padding: const EdgeInsets.all(35.0),
            itemCount: items.length,
            itemBuilder: (context, index) => ListDocumentItem(
              document: items[index]
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 15.0),
          );
        },
      ),
      floatingActionButton: _buildFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: Colors.blue.shade700,
      child: const Icon(Icons.add),
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
      title: const Text("Documentos"),
      titleTextStyle: const TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.bold
      ),
    );
  }
}