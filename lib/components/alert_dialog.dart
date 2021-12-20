import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Alert? alertDialog({required BuildContext context, required String title, required String description}){
  Alert(
    context: context,
    type: AlertType.error,
    title: title,
    desc: description,
    buttons: [
      DialogButton(
        child: const Text(
          "Cancel",
          style:TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        width: 120,
      )
    ],
  ).show();
  return null;
}