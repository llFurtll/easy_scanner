import 'dart:io';

import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';

import '../databases/storage.dart';
import '../exceptions/custom_exceptions.dart';

enum TypeEdgeDetection {
  camera,
  gallery
}

abstract class EdgeDetectionAdapter {
  Future<String> getImage(TypeEdgeDetection type);
}

@reflection
class EdgeDetectionAdapterImpl extends EdgeDetectionAdapter {
  @Inject(nameSetter: "setDataSource", type: DirectoryStorage)
  late final Storage<Directory> storage;

  @override
  Future<String> getImage(TypeEdgeDetection type) async {
    try {
      final defaultPath = await storage.getStorage();
      final finalPath = Directory("${defaultPath.path}/tmp_images");
      if (!finalPath.existsSync()) {
        finalPath.createSync();
      }
      final nameFile = "${UniqueKey().hashCode}.jpeg";
      final pathFile = "${finalPath.path}/$nameFile";

      late final bool success;
      switch (type) {
        case TypeEdgeDetection.camera:
          success = await EdgeDetection.detectEdge(pathFile);
          break;
        default:
          success = await EdgeDetection.detectEdgeFromGallery(pathFile);
          break;
      }

      if (!success) {
        throw const GenerateImageException("error-generate-image");  
      }

      return pathFile;
    } catch (_) {
      throw const GenerateImageException("error-generate-image");
    }
  }

  set setDataSource(Storage<Directory> storage) {
    this.storage = storage;
  }
}