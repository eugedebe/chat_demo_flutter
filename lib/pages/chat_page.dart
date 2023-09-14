import 'dart:io';

import 'package:chat_demo_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final List<ChatMessage> _conversationHistory = [];

  @override
  void dispose() {
    // TODO: implement dispose
    for (ChatMessage message in _conversationHistory) {
      message.animationController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              maxRadius: 12,
              child: Text(
                "Lu",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Melissa Flore',
              style: TextStyle(color: Colors.black87, fontSize: 12),
            )
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
          child: Column(
        children: [
          Flexible(
              child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: _conversationHistory.length,
            itemBuilder: (_, i) => _conversationHistory[i],
            reverse: true,
          )),
          Divider(
            height: 1,
          ),
          _InputChat(
            onSubmitteMessage: (String text) async {
              final newMessage = ChatMessage(
                text: text,
                uid: '123',
                animationController: AnimationController(
                    vsync: this, duration: Duration(milliseconds: 500)),
              );
              _conversationHistory.insert(0, newMessage);
              newMessage.animationController.forward();
              setState(() {});
            },
          )
        ],
      )),
    );
  }
}

class _InputChat extends StatefulWidget {
  var onSubmitteMessage;
  _InputChat({
    required this.onSubmitteMessage,
    super.key,
  });

  @override
  State<_InputChat> createState() => _InputChatState();
}

class _InputChatState extends State<_InputChat> {
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;
  @override
  void initState() {
    // TODO: implement initState
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.orange[50],
      child: SafeArea(
          child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(children: [
          Flexible(
            child: TextField(
              controller: _textEditingController,
              onSubmitted: (String text) {
                print(text);
              },
              onChanged: (String text) {
                print(text);
              },
              decoration: InputDecoration.collapsed(hintText: 'Send...'),
              focusNode: _focusNode,
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS
                  ? CupertinoButton(child: Text('Send'), onPressed: () {})
                  : MaterialButton(
                      onPressed: () {
                        _textEditingController.text.trim().isEmpty
                            ? null
                            : _handleSubmit();
                      },
                      child: Text('Send'),
                    ))
        ]),
      )),
    );
  }

  void _handleSubmit() {
    _focusNode.requestFocus;
    widget.onSubmitteMessage(_textEditingController.text);
    _textEditingController.clear();
    ;
  }
}
