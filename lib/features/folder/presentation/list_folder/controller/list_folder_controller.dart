import 'package:flutter/material.dart';
import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/folder.dart';
import '../../../domain/usecases/get_create_folder.dart';
import '../../../domain/usecases/get_folders.dart';
import '../widget/new_folder.dart';

@reflection
class ListFolderController with AutoInject {
  // INJECT
  @Inject(nameSetter: "setGetFolders")
  late final GetFolders getFolders;

  @Inject(nameSetter: "setGetCreateFolder")
  late final GetCreateFolder getCreateFolder;
  
  // NOTIFIERS
  final isLoading = ValueNotifier(true);

  // VARIABLES
  final List<Folder> folders = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final textController = TextEditingController();

  ListFolderController() {
    super.inject();
  }

  void loadFolders() async {
    folders.clear();
    isLoading.value = true;
    final result = await getFolders(NoParams());
    result.fold((left) => null, (right) => folders.addAll(right));
    isLoading.value = false;
  }

  void newFolder() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: scaffoldKey.currentContext!,
      builder: (context) => NewFolder(
        formKey: formKey,
        onPressed: saveFolder,
        controller: textController,
      ),
    );
  }

  void saveFolder() async {
    if (formKey.currentState?.validate() ?? false) {
      final nameFolder = textController.text;
      textController.clear();
      final result = await getCreateFolder(CreateFolderParams(name: nameFolder));
      result.fold(
        (left) {
          Navigator.of(scaffoldKey.currentContext!).pop();
          ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(left.message)
            )
          );
        },
        (right) {
          Navigator.of(scaffoldKey.currentContext!).pop();
          loadFolders();
        }
      );
    }
  }

  set setGetFolders(GetFolders getFolders) {
    this.getFolders = getFolders;
  }

  set setGetCreateFolder(GetCreateFolder getCreateFolder) {
    this.getCreateFolder = getCreateFolder;
  }
}