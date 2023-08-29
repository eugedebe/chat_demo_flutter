import 'package:flutter/material.dart';

class LoginLabels extends StatelessWidget {
  String question, task, route;

  LoginLabels(
      {required this.question,
      required this.task,
      required this.route,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Text(
          question,
          style: TextStyle(
              color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300),
        ),
        SizedBox(height: 15),
        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, route),
          child: Text(
            task,
            style: TextStyle(
                color: Colors.blue[600],
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          'Terms and Conditions',
          style: TextStyle(fontWeight: FontWeight.w200),
        ),
      ]),
    );
  }
}
