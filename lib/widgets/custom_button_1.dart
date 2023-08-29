import 'package:flutter/material.dart';

class CustomButton1 extends StatelessWidget {
  String label;
  var onPressed;
  CustomButton1({
    required this.label,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        shape: StadiumBorder(),
        elevation: 2,
        color: Colors.blue[700],
        onPressed: onPressed,
        child: Container(
            width: double.infinity,
            child: Center(
                child: Text(
              label,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ))));
  }
}
