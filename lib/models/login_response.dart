import 'package:chat_demo_app/models/user.dart';

class LoginResponse {
  bool ok;
  User user;
  String token;

  LoginResponse({required this.ok, required this.user, required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> jsonData) =>
      LoginResponse(
          ok: jsonData['ok'],
          user: User.FromJson(jsonData['user']),
          token: jsonData['token']);
}
