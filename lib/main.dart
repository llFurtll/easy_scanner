import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import 'features/document/presentation/list_document/pages/list_document_page.dart';
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
      home: ListDocumentPage(),
    )
  );
}
