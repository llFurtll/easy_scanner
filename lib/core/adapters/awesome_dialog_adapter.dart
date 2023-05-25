import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class AwesomeDialogAdapter {
  static void showDialogMessage({
    required BuildContext context,
    required TypeDialog type,
    required String title,
    required String textMessage,
    required String textButton
  }) {
    AwesomeDialog(
      context: context,
      dialogType: type.type,
      btnOkOnPress: () {},
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          Text(
            textMessage,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          )
        ],
      ),
      btnOkColor: Colors.blue.shade700
    ).show();
  }

  static void showDialog(
    {
      required BuildContext context,
      required TypeDialog type,
      required String title,
      required String desc,
      required String textCancel,
      required String textOk,
      required Function() btnCancel,
      required Function() btnOk,
    }
  ) {
    AwesomeDialog(
      context: context,
      dialogType: type.type,
      title: title,
      desc: desc,
      btnCancelText: textCancel,
      btnOkText: textOk,
      btnCancelOnPress: btnCancel,
      btnOkOnPress: btnOk,
    ).show();
  }
}

class TypeDialog {
  const TypeDialog._(this.type);

  final DialogType type;

  static const info = TypeDialog._(DialogType.info);
  static const infoReverse = TypeDialog._(DialogType.infoReverse);
  static const warning = TypeDialog._(DialogType.warning);
  static const error = TypeDialog._(DialogType.error);
  static const success = TypeDialog._(DialogType.success);
  static const noHeader = TypeDialog._(DialogType.noHeader);
  static const question = TypeDialog._(DialogType.question);
}