import 'package:flutter/material.dart';
import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../controller/list_folder_controller.dart';
import '../widget/list_folder_item.dart';

class ListFolderPage extends StatefulWidget {
  const ListFolderPage({super.key});

  @override
  State<StatefulWidget> createState() => ListFolderPageState();
}

@reflection
class ListFolderPageState extends State<ListFolderPage> with AutoInject {
  @Inject(nameSetter: "setController")
  late final ListFolderController controller;

  ListFolderPageState() {
    super.inject();
  }

  @override
  void initState() {
    super.initState();
    controller.loadFolders();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        key: controller.scaffoldKey,
        appBar: _buildAppBar(),
        body: ValueListenableBuilder<bool>(
          valueListenable: controller.isLoading,
          builder: (context, value, child) {
            if (value) {
              return const Center(child: CircularProgressIndicator());
            }

            final isEmpty = controller.folders.isEmpty;

            if (isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "lib/assets/folder.svg",
                      width: 150.0,
                    ),
                    const Text(
                      "No momento você não criou nenhuma pasta 🙂",
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

            final items = controller.folders;
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
                      itemBuilder: (context, index) => ListFolderItem(
                        folder: items[index],
                        notifier: controller.isEdit,
                        onChanged: controller.changeSelectItem,
                        afterPop: controller.loadFolders,
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
      ),
    );
  }

  Widget _buildFab() {
    return ValueListenableBuilder(
      valueListenable: controller.isEdit,
      builder: (context, value, child) {
        return FloatingActionButton(
          onPressed: value ? controller.deleteFolders :  controller.newFolder,
          backgroundColor: value ? Colors.red : Colors.blue.shade700,
          child: Icon(value ? Icons.delete : Icons.add, color: Colors.white),
        );
      },
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
      actions: [
        IconButton(onPressed: () {
          Navigator.of(context).pushNamed("/sobre");
        },
        color: Colors.white,
        icon: const Icon(Icons.info))
      ],
    );
  }

  set setController(ListFolderController controller) {
    this.controller = controller;
  }
}