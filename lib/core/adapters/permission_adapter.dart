import 'package:permission_handler/permission_handler.dart';

abstract class PermissionAdapter {
  Future<void> requestPermissions();
}

class PermissionAdapterImpl extends PermissionAdapter {
  @override
  Future<void> requestPermissions() async {
    for (final permission in TypePermission.getAllPermissions()) {
      await permission.permission.request();
    }
  }
}

class TypePermission {
  TypePermission._(this.permission);

  final Permission permission;

  static TypePermission camera = TypePermission._(Permission.camera);
  static TypePermission storage = TypePermission._(Permission.manageExternalStorage);

  static List<TypePermission> getAllPermissions() => [camera, storage];
}