import 'dart:io';

import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../adapters/path_provider_adapter.dart';

abstract class DataSource<T> {
  Future<T> getDataSource();
}

@reflection
class DirectoryDataSource extends DataSource<Directory> with AutoInject {
  @Inject(nameSetter: "setProvider", type: PathProviderAdapterImpl)
  late final PathProviderAdapter provider;

  DirectoryDataSource() {
    super.inject();
  }

  @override
  Future<Directory> getDataSource() async {
    return await provider.getDirectory();
  }

  set setProvider(PathProviderAdapter provider) {
    this.provider = provider;
  }
}
