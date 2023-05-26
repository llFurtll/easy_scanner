import 'package:easy_scanner/core/adapters/permission_adapter.dart';
import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

@reflection
class SplashController with AutoInject {
  @Inject(nameSetter: "setPermission", type: PermissionAdapterImpl, global: true)
  late final PermissionAdapter permissionAdapter;

  SplashController() {
    super.inject();
  }

  Future<void> init() async {
    await permissionAdapter.requestPermissions();
  }

  set setPermission(PermissionAdapter permissionAdapter) {
    this.permissionAdapter = permissionAdapter;
  }
}