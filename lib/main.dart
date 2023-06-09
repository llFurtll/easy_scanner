import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import 'features/document/presentation/list_document/pages/list_document_page.dart';
import 'features/folder/presentation/list_folder/pages/list_folder_page.dart';
import 'features/scanner/presentation/list_document_scanner/pages/list_document_scanner_page.dart';
import 'features/sobre/presentation/sobre.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'main.reflectable.dart';

void main() {
  AutoInject.init(initializeReflectable);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.blue.shade700
    )
  );

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/splash",
      routes: {
        "/": (context) => const ListFolderPage(),
        "/splash": (context) => const SplashPage(),
        "/documents": (context) => const ListDocumentPage(),
        "/scanners": (context) => const ListDocumentScannerPage(),
        "/sobre": (context) => const SobrePage()
      },
    )
  );
}
