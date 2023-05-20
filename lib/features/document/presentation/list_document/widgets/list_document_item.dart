import 'package:flutter/material.dart';

import '../../../domain/entities/document.dart';

class ListDocumentItem extends StatelessWidget {
  final Document document;

  const ListDocumentItem({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(25.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300
            ),
            borderRadius: BorderRadius.circular(25.0)
          ),
          child: Row(
            children: [
              const Icon(Icons.picture_as_pdf, color: Colors.red),
              const SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      "Tamanho: ${document.size}",
                      style: const TextStyle(
                        color: Colors.grey
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}