import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../domain/entities/document.dart';

class DetailBottomSheetItem extends StatelessWidget {
  final Document document;

  const DetailBottomSheetItem({super.key, required this.document});

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
          _buildOpen(),
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

  Widget _buildOpen() {
    return Material(
      borderRadius: BorderRadius.circular(15.0),
      color: Colors.blue.shade900,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
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
        onTap: () {},
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
}