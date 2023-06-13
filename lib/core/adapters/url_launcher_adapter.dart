import 'package:open_filex/open_filex.dart';
import 'package:reflect_inject/global/instances.dart';

abstract class UrlLauncherAdapter {
  Future<String> openPdf(String path);
}

@reflection
class UrlLauncherAdapterImpl extends UrlLauncherAdapter {
  @override
  Future<String> openPdf(String path) async {
    try {
      final result = await OpenFilex.open(path);
      switch (result.type) {
        case ResultType.fileNotFound:
          return "O arquivo não foi encontrado!";
        case ResultType.noAppToOpen:
          return "Seu dispositivo não contém um aplicativo para ser aberto o PDF!";
        case ResultType.permissionDenied:
          return "O EasyScanner não tem permissão para ler o "
                  "armazenamento do dispotivo, por favor autorize a permissão "
                  "nas configurações do aplicativo e tente novamente!";
        case ResultType.error:
          return "Não foi possível abrir o PDF, por favor tente novamente!";
        default:
          return "";
      }
    } catch (e) {
      return "Não foi possível abrir o PDF, por favor tente novamente!";
    }
  }
}