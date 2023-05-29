import 'dart:io';

import '../../../../../core/adapters/awesome_dialog_adapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../../../../../core/adapters/share_plus_adapter.dart';
import '../../../../../core/adapters/url_launcher_adapter.dart';
import '../../../domain/entities/document.dart';

@reflection
class DetailBottomSheetItem extends StatelessWidget with AutoInject {
  @Inject(nameSetter: "setLauncher", type: UrlLauncherAdapterImpl, global: true)
  late final UrlLauncherAdapter launcherAdapter;

  @Inject(nameSetter: "setShare", type: SharePlusAdapterImpl, global: true)
  late final SharePlusAdapter sharePlusAdapter;

  final Document document;

  DetailBottomSheetItem({super.key, required this.document}) {
    super.inject();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.loose,
              clipBehavior: Clip.none,
              children: [
                _buildDocument(),
                _buildName(context),
                _buildSize(context)
              ],
            )
          ),
          _buildOpen(context),
          const SizedBox(height: 15.0),
          _buildCompartilhar()
        ],
      ),
    );
  }

  Widget _buildDocument() {
    return 
      Positioned(
        top: -50,
        child: SvgPicture.asset(
          "lib/assets/preview-pdf.svg",
          width: 150.0
        ),
      );
  }

  Widget _buildName(BuildContext context) {
    final sizePhone = MediaQuery.of(context).size.width;
    final sizeWithoutPadding = sizePhone - 170 - 30;

    return Positioned(
      left: 170.0,
      top: 10.0,
      child: SizedBox(
        width: sizeWithoutPadding,
        child: Text(
          document.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  Widget _buildSize(BuildContext context) {
    final sizePhone = MediaQuery.of(context).size.width;
    final sizeWithoutPadding = sizePhone - 170 - 30;

    return Positioned(
      left: 170.0,
      top: 70.0,
      child: SizedBox(
        width: sizeWithoutPadding,
        child: Text(
          "Tamanho: ${document.size}",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.grey
          ),
        ),
      )
    );
  }

  Widget _buildOpen(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15.0),
      color: Colors.blue.shade900,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          final result = await launcherAdapter.openPdf(document.path);
          if (result.isNotEmpty) {
            Future.value()
              .then((value) {
                AwesomeDialogAdapter.showDialogMessage(
                  context: context,
                  type: TypeDialog.info,
                  title: "Atenção",
                  textMessage: result,
                  textButton: "Tudo bem!",
                );
              }
            );
          }
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10.0),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            children: const [
              Icon(Icons.file_open_rounded, color: Colors.white, size: 25.0),
              SizedBox(width: 5.0),
              Text(
                "Abrir PDF",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight:  FontWeight.bold,
                  fontSize: 18.0
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  Widget _buildCompartilhar() {
    return Material(
      borderRadius: BorderRadius.circular(15.0),
      color: Colors.blue.shade700,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => sharePlusAdapter.share(File(document.path)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10.0),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            children: const [
              Icon(Icons.ios_share_rounded, color: Colors.white, size: 25.0),
              SizedBox(width: 5.0),
              Text(
                "Compartilhar",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight:  FontWeight.bold,
                  fontSize: 18.0
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  set setLauncher(UrlLauncherAdapter launcherAdapter) {
    this.launcherAdapter = launcherAdapter;
  }

  set setShare(SharePlusAdapter sharePlusAdapter) {
    this.sharePlusAdapter = sharePlusAdapter;
  }
}