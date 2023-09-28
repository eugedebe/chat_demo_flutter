import 'dart:convert';

import 'package:chat_demo_app/global/enviroments.dart';
import 'package:chat_demo_app/models/conversation_message.dart';
import 'package:chat_demo_app/models/user.dart';
import 'package:chat_demo_app/services/auth_service.dart';
import 'package:chat_demo_app/widgets/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  User? userTo;

  Future<List<ConversationMessage>> getConversation() async {
    try {
      String? token = await AuthService.getToken();
      if (token == null || token.isEmpty) {
        return [];
      }

      final uri = Uri.parse('${Enviroments.apiUrl}/messages/${userTo!.uid}');
      final resp = await http.get(uri,
          headers: {'Content-Type': 'application/json', 'x-token': token});
      if (resp.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(resp.body);
        List<ConversationMessage> conversation = (jsonResponse['conversation']
                as List<dynamic>)
            .map((e) => ConversationMessage.FromJson(e as Map<String, dynamic>))
            .toList()
            .cast<ConversationMessage>();
        return conversation;
      } else {
        return [];
      }
    } catch (e) {
      print('Error while trying to fetch the conversation: ${e}');
      return [];
    }
  }
}
