import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showAlert(
    {required BuildContext context, required String title, String? subtitle}) {
  if (Platform.isAndroid) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(title),
              content: subtitle != null ? Text(subtitle) : null,
              actions: [
                MaterialButton(
                    child: Text('Ok'),
                    elevation: 5,
                    textColor: Colors.blue[200],
                    onPressed: () => Navigator.pop(context))
              ],
            ));
  } else {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text(title),
              content: subtitle != null ? Text(subtitle) : null,
              actions: [
                CupertinoDialogAction(
                    child: Text('Ok'),
                    isDefaultAction: true,
                    onPressed: () => Navigator.pop(context))
              ],
            ));
  }
}
