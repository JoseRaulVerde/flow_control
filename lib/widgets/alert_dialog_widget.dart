import 'package:flutter/material.dart';

class AlertDialogWidget extends StatelessWidget {
  final String title; 
  final String textInfo; 
  final String buttonTrue; 
  final String? buttonFalse; 

  const AlertDialogWidget({
    super.key, 
    required this.title, 
    required this.textInfo, 
    required this.buttonTrue, 
    this.buttonFalse
    });

  // Logica de widget Logout
  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text(title),
      content: Text(textInfo),
      actions: <Widget>[
         buttonFalse != null ?
        TextButton(
          child: Text(buttonFalse!),
          onPressed: () => Navigator.pop(context, false),
        )
        : SizedBox(),
        TextButton(
          child: Text(buttonTrue),
          onPressed: () {
            Navigator.pop(context, true);
          },
        )
      ],
    );
  }
}