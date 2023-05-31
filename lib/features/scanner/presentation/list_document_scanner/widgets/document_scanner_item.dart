import 'dart:io';

import 'package:flutter/material.dart';
import 'package:msh_checkbox/msh_checkbox.dart';

import '../../../domain/entities/scanner.dart';

// ignore: must_be_immutable
class DocumentScannerItem extends StatelessWidget {
  final Scanner scanner;
  final ValueNotifier<bool> notifier;
  final int position;
  final Function(DocumentScannerItem item, bool isCheck) onChanged;
  
  bool isCheck = false;

  DocumentScannerItem({
    super.key,
    required this.scanner,
    required this.notifier,
    required this.position,
    required this.onChanged
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
                  onTap: () {
                    showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Material(
                                borderRadius: BorderRadius.circular(15.0),
                                clipBehavior: Clip.antiAlias,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxHeight: MediaQuery.of(context).size.height * 0.8
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0)
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Image.file(File(scanner.path)),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: const CircleBorder()
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Icon(Icons.close, size: 25.0)
                              )
                            ],
                          ),
                        );
                      },
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
                        const Icon(Icons.image_rounded),
                        const SizedBox(width: 20.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Foto $position",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                "Tamanho: ${scanner.size}",
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