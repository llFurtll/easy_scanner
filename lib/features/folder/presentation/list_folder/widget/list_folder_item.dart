import 'package:flutter/material.dart';
import 'package:msh_checkbox/msh_checkbox.dart';

import '../../../domain/entities/folder.dart';

// ignore: must_be_immutable
class ListFolderItem extends StatelessWidget {
  final Folder folder;
  final ValueNotifier<bool> notifier;
  final Function(ListFolderItem item, bool isCheck) onChanged;
  final Function() afterPop;
  
  bool isCheck = false;

  ListFolderItem({
    super.key,
    required this.folder,
    required this.notifier,
    required this.onChanged,
    required this.afterPop
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (context, value, child) {
        if (value && isCheck) {
          isCheck = false;
        }
        return Row(
          children: [
            value ? Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return MSHCheckbox(
                    value: isCheck,
                    style: MSHCheckboxStyle.fillFade,
                    onChanged: (selected) {
                      setState(() {
                        isCheck = selected;
                        onChanged(this, isCheck);
                      });
                    },
                  );
                },
              )
            ) : const SizedBox.shrink(),
            Expanded(
              child: Material(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(25.0),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(
                    context, "/documents", arguments: folder.name
                  ).then((_) => afterPop()),
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
                              Text(
                                "Tamanho: ${folder.size}",
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
              )
            )
          ],
        );
      },
    );
  }
}