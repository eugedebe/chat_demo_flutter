import 'dart:convert';

import 'package:chat_demo_app/models/user.dart';
import 'package:chat_demo_app/services/auth_service.dart';
import 'package:http/http.dart' as http;

import '../global/enviroments.dart';

class UserService {
  Future<List<User>> getUsers({int from = 0}) async {
    try {
      String? token = await AuthService.getToken();
      if (token == null || token.isEmpty) {
        return [];
      }

      final uri = Uri.parse('${Enviroments.apiUrl}/users?from=$from');
      final resp = await http.get(uri,
          headers: {'Content-Type': 'application/json', 'x-token': token});
      if (resp.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(resp.body);
        List<User> users = (jsonResponse['users'] as List<dynamic>)
            .map((e) => User.FromJson(e as Map<String, dynamic>))
            .toList()
            .cast<User>();

        return users;
      } else {
        return [];
      }
    } catch (e) {
      print('Error while trying to fetch the users: ${e}');
      return [];
    }
  }
}
