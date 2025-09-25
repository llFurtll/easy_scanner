import 'package:flutter/material.dart';

class NewFolder extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Function() onPressed;
  final TextEditingController controller;

  const NewFolder({
    super.key,
    required this.formKey,
    required this.onPressed,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0)
          )
        ),
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(context),
            const SizedBox(height: 10.0),
            _buildForm(),
            const SizedBox(height: 10.0),
            _buildDone()
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Criar nova pasta",
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
    );
  }

  Widget _buildForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Nome da pasta",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16.0
            ),
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            controller: controller,
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
          )
        ],
      )
    );
  }

  Widget _buildDone() {
    return SizedBox(
      height: 60.0,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 10.0,
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0)
          ),
        ),
        onPressed: onPressed,
        child: const Text("Salvar")
      ),
    );
  }
}