import 'dart:io';

import 'package:chat_demo_app/models/conversation_message.dart';
import 'package:chat_demo_app/services/auth_service.dart';
import 'package:chat_demo_app/services/chat_service.dart';
import 'package:chat_demo_app/services/socket_service.dart';
import 'package:chat_demo_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;
  bool hasConversation = true;
  List<ChatMessage> _conversationHistory = [];

  Future<void> getConversation() async {
    List<ConversationMessage> conversation =
        await chatService.getConversation();
    _conversationHistory = conversation
        .map((e) => ChatMessage(
            text: e.message,
            uid: e.from,
            animationController: AnimationController(
                vsync: this, duration: Duration(milliseconds: 1))
              ..forward()))
        .toList();
    hasConversation = true;
    setState(() {});
  }

  @override
  void initState() {
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);
    this.socketService.socket.on('personal-message', _listenMessage);
    getConversation();

    super.initState();
  }

  void _listenMessage(dynamic payload) {
    ChatMessage newMessage = ChatMessage(
        text: payload['message'],
        uid: payload['from'],
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 300)));
    setState(() {
      _conversationHistory.insert(0, newMessage);
    });
    newMessage.animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    for (ChatMessage message in _conversationHistory) {
      message.animationController.dispose();
    }
    this.socketService.socket.off('personal-message');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context);
    return !hasConversation
        ? Scaffold(
            body: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              elevation: 1,
              centerTitle: true,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    maxRadius: 12,
                    child: Text(
                      chatService.userTo!.name.substring(0, 2),
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    chatService.userTo!.name!,
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
                  physics: const BouncingScrollPhysics(),
                  itemCount: _conversationHistory.length,
                  itemBuilder: (_, i) => _conversationHistory[i],
                  reverse: true,
                )),
                const Divider(
                  height: 1,
                ),
                _InputChat(
                  onSubmitteMessage: (String text) async {
                    final newMessage = ChatMessage(
                      text: text,
                      uid: authService.user!.uid,
                      animationController: AnimationController(
                          vsync: this,
                          duration: const Duration(milliseconds: 500)),
                    );
                    _conversationHistory.insert(0, newMessage);
                    newMessage.animationController.forward();
                    setState(() {});
                    this.socketService.socket.emit('personal-message', {
                      'from': authService.user!.uid!,
                      'to': chatService.userTo!.uid,
                      'message': text
                    });
                  },
                )
              ],
            )),
          );
  }
}

// ignore: must_be_immutable
class _InputChat extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
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
              onSubmitted: (String text) {},
              onChanged: (String text) {},
              decoration: const InputDecoration.collapsed(hintText: 'Send...'),
              focusNode: _focusNode,
            ),
          ),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child:
                  // Platform.isIOS
                  //     ? CupertinoButton(child: const Text('Send'), onPressed: () {})
                  //     :
                  MaterialButton(
                onPressed: () {
                  _textEditingController.text.trim().isEmpty
                      ? null
                      : _handleSubmit();
                },
                child: const Text('Send'),
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
