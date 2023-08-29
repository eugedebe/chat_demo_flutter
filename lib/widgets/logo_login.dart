import 'package:flutter/material.dart';

class LogoLogin extends StatelessWidget {
  const LogoLogin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 50),
        width: 170,
        child: Column(
          children: [
            Image(image: AssetImage('assets/images/tag-logo.png')),
            SizedBox(
              height: 20,
            ),
            Text(
              'Messenger',
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
