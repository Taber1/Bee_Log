import 'package:flutter/material.dart';
import 'package:bee_log/main.dart';

showAlertDialog(BuildContext context, e) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      navigatorKey.currentState.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Error"),
    content: Text(e.toString()),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
