import 'package:flutter/material.dart';
import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../controller/list_folder_controller.dart';
import '../widget/list_folder_item.dart';

@reflection
class ListFolderPage extends StatefulWidget with AutoInject {
  @Inject(nameSetter: "setController")
  late final ListFolderController controller;

  ListFolderPage({super.key}) {
    super.inject();
  }

  @override
  State<StatefulWidget> createState() => ListFolderPageState();

  set setController(ListFolderController controller) {
    this.controller = controller;
  }
}

class ListFolderPageState extends State<ListFolderPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.loadFolders();
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

          final isEmpty = widget.controller.folders.isEmpty;

          if (isEmpty) {
            return const Center(child: Text("Nenhuma pasta encontrada!"));
          } 

          final items = widget.controller.folders;
          return ListView.separated(
            padding: const EdgeInsets.all(35.0),
            itemCount: items.length,
            itemBuilder: (context, index) => ListFolderItem(
              folder: items[index]
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
      onPressed: () => widget.controller.newFolder(),
      backgroundColor: Colors.blue.shade700,
      child: const Icon(Icons.add),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 100.0,
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(150.0)
        )
      ),
      backgroundColor: Colors.blue.shade700,
      title: const Text("Pastas"),
      titleTextStyle: const TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.bold
      ),
    );
  }
}