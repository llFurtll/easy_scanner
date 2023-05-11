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

  ListFolderController() {
    super.inject();
  }

  void loadFolders() async {
    final result = await getFolders(NoParams());
    result.fold((left) => null, (right) => folders.addAll(right));
    isLoading.value = false;
  }

  void newFolder() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: scaffoldKey.currentContext!,
      builder: (context) => const NewFolder(),
    );
  }

  set setGetFolders(GetFolders getFolders) {
    this.getFolders = getFolders;
  }

  set setGetCreateFolder(GetCreateFolder getCreateFolder) {
    this.getCreateFolder = getCreateFolder;
  }
}