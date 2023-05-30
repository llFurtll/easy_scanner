import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class AwesomeDialogAdapter {
  static void showDialogMessage({
    required BuildContext context,
    required TypeDialog type,
    required String title,
    required String textMessage,
    required String textButton,
    Function()? onPressed
  }) {
    AwesomeDialog(
      context: context,
      dialogType: type.type,
      btnOkOnPress: onPressed ?? () {},
      btnOkText: textButton,
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
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 15.0),
          SizedBox(
            width: double.infinity,
            child: Text(
            textMessage,
              style: const TextStyle(
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
      btnOkColor: Colors.blue.shade700,
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
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 15.0),
          SizedBox(
            width: double.infinity,
            child: Text(
              desc,
              style: const TextStyle(
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center
            ),
          )
        ],
      ),
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