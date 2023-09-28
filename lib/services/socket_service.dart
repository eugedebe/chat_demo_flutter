import 'package:chat_demo_app/global/enviroments.dart';
import 'package:chat_demo_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService extends ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  ServerStatus get serverStatus => _serverStatus;
  late IO.Socket _socket;
  IO.Socket get socket => _socket;

  bool _isConnected = false;

  bool get isConnected => _isConnected;

  set isConneted(bool value) {
    _isConnected = value;
    notifyListeners();
  }

  void connect() async {
    final token = await AuthService.getToken();
    _socket =
        // IO.io('https://server-socket-demo-bands-4aee4e88d63c.herokuapp.com/', {
        IO.io(Enviroments.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {'x-token': token}
    });
    _socket.onConnect((_) {
      _serverStatus = ServerStatus.Online;
      _isConnected = true;
      notifyListeners();
      // socket.emit('msg', 'test');
    });
    // socket.on('event', (data) => print(data));
    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.Offline;
      _isConnected = false;

      notifyListeners();
    });

    _socket.on('messageFromServer', (payload) {
      print('messageFromServer');
      print(payload);
    });
  }

  void disconnect() {
    _socket.disconnect();
  }
}
