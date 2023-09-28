import 'dart:convert';

class ConversationMessage {
  String from, to, message, timeStamp;
  ConversationMessage(
      {required this.from,
      required this.to,
      required this.message,
      required this.timeStamp});

  factory ConversationMessage.FromJson(Map<String, dynamic> jsonData) {
    return ConversationMessage(
        from: jsonData['from'],
        to: jsonData['to'],
        timeStamp: jsonData['createdAt'],
        message: jsonData['message']);
  }
}
