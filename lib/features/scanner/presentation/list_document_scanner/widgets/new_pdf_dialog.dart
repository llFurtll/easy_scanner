import 'package:flutter/material.dart';

class NewPdfDialog extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Function() onSave;
  final TextEditingController textController;

  const NewPdfDialog({super.key, required this.formKey, required this.onSave, required this.textController});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Form(
          key: formKey,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0)
              ),
              padding: const EdgeInsets.all(15.0),
              margin: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Nome do arquivo",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade200,
                          foregroundColor: Colors.black,
                          shape: const CircleBorder()
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Icon(Icons.close)
                      )
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: textController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.blue.shade700
                        )
                      ),
                    ),
                    maxLength: 20,
                    validator: (value) {
                      return value == null || value.isEmpty ? "Campo obrigatório" : null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    height: 60.0,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 10.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)
                        ),
                      ),
                      onPressed: onSave,
                      child: const Text("Gerar PDF")
                    ),
                  )
                ],
              ),
            )
          ),
        )
      )
    );
  }

}