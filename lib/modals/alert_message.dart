import 'package:flow_control/widgets/alert_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final log = Logger();

Future<void> showAlertModal(BuildContext context, String message ) async {

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialogWidget(title: 'Advertencia', textInfo: message, buttonTrue: "OK");
    },
  );
}