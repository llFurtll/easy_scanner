import 'dart:io';

import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../adapters/path_provider_adapter.dart';

abstract class Storage<T> {
  Future<T> getStorage();
}

@reflection
class DirectoryStorage extends Storage<Directory> with AutoInject {
  @Inject(nameSetter: "setProvider", type: PathProviderAdapterImpl, global: true)
  late final PathProviderAdapter provider;

  DirectoryStorage() {
    super.inject();
  }

  @override
  Future<Directory> getStorage() async {
    return await provider.getDirectory();
  }

  set setProvider(PathProviderAdapter provider) {
    this.provider = provider;
  }
}
