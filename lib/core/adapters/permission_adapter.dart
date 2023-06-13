import 'package:permission_handler/permission_handler.dart';
import 'package:reflect_inject/global/instances.dart';

abstract class PermissionAdapter {
  Future<void> requestPermissions();
  Future<bool> requestPermission(TypePermission permission);
  Future<List<TypePermission>> request(List<TypePermission> permissions);
  Future<void> openConfigApp();
}

@reflection
class PermissionAdapterImpl extends PermissionAdapter {
  @override
  Future<void> requestPermissions() async {
    for (final permission in TypePermission.getAllPermissions()) {
      await permission.permission.request();
    }
  }

  @override
  Future<bool> requestPermission(TypePermission permission) async {
    await permission.permission.request();
    return await permission.permission.isGranted;
  }

  @override
  Future<List<TypePermission>> request(List<TypePermission> permissions) async {
    final result = <TypePermission>[];
    for (TypePermission permission in permissions) {
      await permission.permission.request();
      if (!await permission.permission.isGranted) {
        result.add(permission);
      }
    }

    return result;
  }

  @override
  Future<void> openConfigApp() async {
    await openAppSettings();
  }
}

class TypePermission {
  TypePermission._(this.permission);

  final Permission permission;

  static TypePermission camera = TypePermission._(Permission.camera);

  static List<TypePermission> getAllPermissions() => [camera];
}