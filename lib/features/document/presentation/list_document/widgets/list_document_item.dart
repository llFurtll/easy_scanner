import 'package:flutter/material.dart';
import 'package:msh_checkbox/msh_checkbox.dart';

import '../../../domain/entities/document.dart';
import 'detail_bottom_sheet_item.dart';

// ignore: must_be_immutable
class ListDocumentItem extends StatelessWidget {
  final Document document;
  final ValueNotifier<bool> notifier;
  final Function(ListDocumentItem item, bool isCheck) onChanged;

  bool isCheck = false;

  ListDocumentItem({super.key, required this.document, required this.notifier, required this.onChanged});

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
                  onTap: () {
                    showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0)
                        )
                      ),
                      constraints: const BoxConstraints(
                        maxHeight: 250.0
                      ),
                      context: context,
                      builder: (context) => DetailBottomSheetItem(document: document),
                    );
                  },
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
              )
            )
          ]
        );
      }
    );
  }
}