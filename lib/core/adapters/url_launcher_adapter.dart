import 'package:open_file/open_file.dart';
import 'package:reflect_inject/global/instances.dart';

abstract class UrlLauncherAdapter {
  Future<bool> openPdf(String path);
}

@reflection
class UrlLauncherAdapterImpl extends UrlLauncherAdapter {
  @override
  Future<bool> openPdf(String path) async {
    try {
      final result = await OpenFile.open(path);
      if (result.message.contains("denied")) {
        return false;
      }
    } catch (e) {
      return false;
    }

    return true;
  }
}