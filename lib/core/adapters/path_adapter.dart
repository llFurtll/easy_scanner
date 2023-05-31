import 'package:reflect_inject/global/instances.dart';
import 'package:path/path.dart' as aux_path;

abstract class PathAdapter {
  String basename(String path);
  String extension(String path);
}

@reflection
class PathAdapterImpl extends PathAdapter {
  @override
  String basename(String path) {
    return aux_path.basename(path);
  }

  @override
  String extension(String path) {
    return aux_path.extension(path);
  }
}
