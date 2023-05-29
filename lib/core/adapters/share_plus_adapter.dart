import 'dart:io';

import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';
import 'package:share_plus/share_plus.dart';

import 'path_adapter.dart';

abstract class SharePlusAdapter {
  Future<void> share(File file);
}

@reflection
class SharePlusAdapterImpl extends SharePlusAdapter with AutoInject {
  @Inject(nameSetter: "setPath", type: PathAdapterImpl, global: true)
  late final PathAdapter pathAdapter;

  SharePlusAdapterImpl() {
    super.inject();
  }

  @override
  Future<void> share(File file) async {
    try {
      XFile xFile = XFile(file.path);

      Share.shareXFiles([xFile], text: pathAdapter.basename(xFile.path));
    } catch (_) {

    }
  }

  set setPath(PathAdapter pathAdapter) {
    this.pathAdapter = pathAdapter;
  }
}