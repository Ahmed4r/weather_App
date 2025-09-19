import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class CustomAlert {
  static showSuccessAlert(BuildContext context, title, desc) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.rightSlide,
        title: title,
        desc: desc,
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
    });
  }

  static showErrorAlert(BuildContext context, title, desc) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: title,
        desc: desc,
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
    });
  }

  static showWarningAlert(BuildContext context, title, desc) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: title,
        desc: desc,
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
    });
  }
}
