import 'dart:convert';

import 'package:chat_demo_app/global/enviroments.dart';
import 'package:chat_demo_app/models/login_response.dart';
import 'package:chat_demo_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  User? user;
  bool _authenticating = false;
  final _storage = FlutterSecureStorage();

  bool get authenticating => _authenticating;
  set authenticating(bool value) {
    _authenticating = value;
    notifyListeners();
  }

  static Future<String?> getToken() async {
    final _storage = new FlutterSecureStorage();
    return await _storage.read(key: 'token');
  }

  static Future deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    authenticating = true;
    final data = {'email': email, 'password': password};

    final uri = Uri.parse('${Enviroments.apiUrl}/login');
    final resp = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    if (resp.statusCode == 200) {
      final LoginResponse loginResponse =
          LoginResponse.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);

      user = loginResponse.user;
      await _saveToken(loginResponse.token);
      authenticating = false;
      return true;
    }
    authenticating = false;
    return false;
  }

  Future _saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future _logout() async {
    await _storage.delete(key: 'token');
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    if (token == null) {
      return false;
    }

    final uri = Uri.parse('${Enviroments.apiUrl}/login/renew');
    final resp = await http.get(uri,
        headers: {'Content-Type': 'application/json', 'x-token': token});
    if (resp.statusCode == 200) {
      final LoginResponse loginResponse =
          LoginResponse.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);

      user = loginResponse.user;
      await _saveToken(loginResponse.token);
      return true;
    } else {
      _logout();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    authenticating = true;
    final data = {'name': name, 'email': email, 'password': password};

    final uri = Uri.parse('${Enviroments.apiUrl}/login/new');
    final resp = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    if (resp.statusCode == 200) {
      final LoginResponse loginResponse =
          LoginResponse.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);

      user = loginResponse.user;
      await _saveToken(loginResponse.token);
      authenticating = false;
      return true;
    }
    authenticating = false;
    return false;
  }
}
