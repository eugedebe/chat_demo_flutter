import 'package:chat_demo_app/models/user.dart';
import 'package:chat_demo_app/services/auth_service.dart';
import 'package:chat_demo_app/services/chat_service.dart';
import 'package:chat_demo_app/services/socket_service.dart';
import 'package:chat_demo_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsersPage extends StatefulWidget {
  UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<User> users = [];
  late RefreshController _refreshController;
  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    // users = await UserService().getUsers();
    _loadUsers();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authServiceProvider = Provider.of<AuthService>(context);
    final socketServicen = Provider.of<SocketService>(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text(
            authServiceProvider.user!.name,
            style: TextStyle(color: Colors.black54),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.black,
            ),
            onPressed: () {
              //TODO: DISCONNECT FROM SOCKET SERVER
              final socketService =
                  Provider.of<SocketService>(context, listen: false);
              AuthService.deleteToken();
              socketService.disconnect();
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: !socketServicen.isConnected
                  ? Icon(Icons.offline_bolt, color: Colors.red)
                  : Icon(Icons.check_circle, color: Colors.blue[400]),
            )
          ],
        ),
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _loadUsers,
          header: WaterDropHeader(
            complete: Icon(
              Icons.check,
              color: Colors.blue[400],
            ),
            waterDropColor: Colors.blue,
          ),
          child: _listViewUsers(),
        )
        // _listViewUsers(),
        );
  }

  void _loadUsers() async {
    users = await UserService().getUsers();
    // await Future.delayed(Duration(microseconds: 1000));
    _refreshController.refreshCompleted();
    setState(() {});
  }

  ListView _listViewUsers() {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, i) => _UserTile(
              user: users[i],
            ),
        separatorBuilder: (_, i) => const Divider(),
        itemCount: users.length);
  }
}

class _UserTile extends StatelessWidget {
  _UserTile({super.key, required this.user});
  User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      leading: CircleAvatar(
        child: Text(user.name.substring(0, 2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: user.online ? Colors.green : Colors.red),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.userTo = user;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }
}
