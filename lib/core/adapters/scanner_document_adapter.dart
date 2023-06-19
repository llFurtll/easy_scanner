import 'dart:io';

import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:reflect_inject/global/instances.dart';

import '../exceptions/custom_exceptions.dart';

abstract class ScannerDocumentAdapter {
  Future<List<String>> getImages();
}

@reflection
class ScannerDocumentAdapterImpl extends ScannerDocumentAdapter {

  @override
  Future<List<String>> getImages() async {
    try {
      final dirTemp = Directory.systemTemp;
      final nameFile = UniqueKey().hashCode;
      final file = File("${dirTemp.path}/$nameFile.jpeg");

      final success = await EdgeDetection.detectEdge(
        file.path,
        androidScanTitle: "Escolher foto",
        androidCropTitle: "Cortar Imagem",
        androidCropBlackWhiteTitle: "Preto e Branco",
        androidCropReset: "Original"
      );

      if (success) {
        return [file.path];
      }

      return [];
    } catch (_) {
      throw const GenerateImageException("error-generate-image");
    }
  }
}