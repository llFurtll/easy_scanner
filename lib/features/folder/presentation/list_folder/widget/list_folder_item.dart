import 'package:flutter/material.dart';

import '../../../domain/entities/folder.dart';

class ListFolderItem extends StatelessWidget {
  final Folder folder;

  const ListFolderItem({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(25.0),
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context, "/documents", arguments: folder.name
        ),
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
              const Icon(Icons.folder_rounded, color: Colors.red),
              const SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      folder.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5.0),
                    const Text(
                      "Tamanho: 3.4 MB",
                      style: TextStyle(
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