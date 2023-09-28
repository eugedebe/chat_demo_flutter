import 'package:chat_demo_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {super.key,
      required this.text,
      required this.uid,
      required this.animationController});
  final String text, uid;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of<AuthService>(context, listen: false);
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor:
            CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child: uid == authService.user!.uid
              ? _MyMessageBubble(text: text)
              : _YourMessageBubble(
                  text: text,
                ),
        ),
      ),
    );
  }
}

class _YourMessageBubble extends StatelessWidget {
  String text;
  _YourMessageBubble({super.key, required this.text});

  @override
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 4, right: 60, left: 6),
        padding: EdgeInsets.all(8),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 71, 208, 140),
            borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}

class _MyMessageBubble extends StatelessWidget {
  String text;
  _MyMessageBubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 4, left: 60, right: 6),
        padding: EdgeInsets.all(8),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        decoration: BoxDecoration(
            color: Color(0xff4d9EF6), borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
