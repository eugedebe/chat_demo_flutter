import 'package:flutter/material.dart';

class CustomInputTextField extends StatelessWidget {
  Icon? prefixIcon;
  String? hint;
  final TextEditingController textEditingController;
  TextInputType? keyboardType;
  final bool isPassword;

  CustomInputTextField(
      {required this.textEditingController,
      this.isPassword = false,
      this.prefixIcon,
      this.hint,
      this.keyboardType,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset(2, 5),
                  blurRadius: 5)
            ]),
        child: TextField(
          controller: textEditingController,
          autocorrect: false,
          keyboardType: keyboardType,
          obscureText: isPassword,

          decoration: InputDecoration(
              prefixIcon: prefixIcon, border: InputBorder.none, hintText: hint),

          // obscureText: true,
        ));
  }
}
