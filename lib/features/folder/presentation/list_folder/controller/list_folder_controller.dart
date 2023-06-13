import 'package:easy_scanner/core/adapters/awesome_dialog_adapter.dart';
import 'package:easy_scanner/core/adapters/permission_adapter.dart';
import 'package:flutter/material.dart';
import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/folder.dart';
import '../../../domain/usecases/get_create_folder.dart';
import '../../../domain/usecases/get_delete_folders.dart';
import '../../../domain/usecases/get_folders.dart';
import '../widget/list_folder_item.dart';
import '../widget/new_folder.dart';

@reflection
class ListFolderController with AutoInject {
  // INJECT
  @Inject(nameSetter: "setGetFolders", global: true)
  late final GetFolders getFolders;

  @Inject(nameSetter: "setGetCreateFolder", global: true)
  late final GetCreateFolder getCreateFolder;

  @Inject(nameSetter: "setGetDeleteFolder", global: true)
  late final GetDeleteFolders getDeleteFolders;

  @Inject(nameSetter: "setPermission", type: PermissionAdapterImpl, global: true)
  late final PermissionAdapter permissionAdapter;
  
  // NOTIFIERS
  final isLoading = ValueNotifier(false);
  final isEdit = ValueNotifier(false);

  // VARIABLES
  final List<Folder> folders = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  final foldersToDelete = <Folder>[];

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

  void newFolder() async {
    final acceptAll = await permissionAdapter.request([
      TypePermission.camera
    ]);
    if (acceptAll.isNotEmpty) {
      bool hasCamera = acceptAll.contains(TypePermission.camera);

      AwesomeDialogAdapter.showDialog(
        context: scaffoldKey.currentContext!,
        type: TypeDialog.info,
        title: "Atenção!",
        desc: "O EasyScanner necessita dessas permissões para seu funcionamento: \n\n"
              "${hasCamera ? 'Câmera\n' : ''}",
        textCancel: "Fechar",
        textOk: "Abrir configurações",
        btnCancel: () {},
        btnOk: permissionAdapter.openConfigApp
      ); 

      return;
    }

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
          AwesomeDialogAdapter.showDialogMessage(
            context: scaffoldKey.currentContext!,
            type: TypeDialog.error,
            title: "Ah não :(",
            textMessage: left.message,
            textButton: "Beleza",
          );
        },
        (right) {
          Navigator.of(scaffoldKey.currentContext!).pop();
          loadFolders();
          AwesomeDialogAdapter.showDialogMessage(
            context: scaffoldKey.currentContext!,
            type: TypeDialog.success,
            title: "Parabéns",
            textMessage: "Sua nova pasta foi criada 🙂",
            textButton: "Obrigado 🙂"
          );
        }
      );
    }
  }

  void deleteFolders() {
    if (foldersToDelete.isEmpty) {
      AwesomeDialogAdapter.showDialog(
        context: scaffoldKey.currentContext!,
        type: TypeDialog.warning,
        title: "Atenção",
        desc: "Você precisa selecionar pelo menos um item!",
        textCancel: "Fechar",
        textOk: "Tudo bem!",
        btnCancel: () {},
        btnOk: () async {}
      );

      return;
    }

    AwesomeDialogAdapter.showDialog(
      context: scaffoldKey.currentContext!,
      type: TypeDialog.question,
      title: "Cuidado",
      desc: "Certeza que você deseja prosseguir? Seus dados deletados serão perdidos!",
      textCancel: "Não quero",
      textOk: "Pode continuar",
      btnCancel: () {
        isEdit.value = false;
      },
      btnOk: () async {
        final response = await getDeleteFolders(
          DeleteFoldersParams(folders: foldersToDelete)
        );
        response.fold(
          (left) {
            AwesomeDialogAdapter.showDialogMessage(
              context: scaffoldKey.currentContext!,
              type: TypeDialog.error,
              title: "Ah não :(",
              textMessage: left.message,
              textButton: "Beleza",
            );
          },
          (right) {
            loadFolders();
            foldersToDelete.clear();
            isEdit.value = false;
            AwesomeDialogAdapter.showDialogMessage(
              context: scaffoldKey.currentContext!,
              type: TypeDialog.success,
              title: "Finalizado",
              textMessage: "As pastas solicitadas foram removidas!",
              textButton: "Obrigado 🙂",
            );
          }
        );
      }
    );
  }

  void changeSelectItem(ListFolderItem item, bool isCheck) {
    if (isCheck) {
      foldersToDelete.add(item.folder);
    } else {
      foldersToDelete.remove(item.folder);
    }
  }

  void setEdit() {
    foldersToDelete.clear();
    isEdit.value = !isEdit.value;
  }

  set setGetFolders(GetFolders getFolders) {
    this.getFolders = getFolders;
  }

  set setGetCreateFolder(GetCreateFolder getCreateFolder) {
    this.getCreateFolder = getCreateFolder;
  }

  set setGetDeleteFolder(GetDeleteFolders getDeleteFolders) {
    this.getDeleteFolders = getDeleteFolders;
  }

  set setPermission(PermissionAdapter permissionAdapter) {
    this.permissionAdapter = permissionAdapter;
  }
}