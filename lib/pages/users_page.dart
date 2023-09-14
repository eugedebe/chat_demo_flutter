import 'package:chat_demo_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsersPage extends StatefulWidget {
  UsersPage({super.key});
  final users = [
    User(
      email: 'maria@fdsfd.com',
      iod: '1',
      name: 'Maria',
      online: true,
    ),
    User(
      email: 'peter@fdsfd.com',
      iod: '2',
      name: 'Peter',
      online: true,
    ),
    User(
      email: 'francine@fdsfd.com',
      iod: '3',
      name: 'francine',
      online: false,
    ),
  ];

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late RefreshController _refreshController;
  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text(
            "my name",
            style: TextStyle(color: Colors.black54),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {},
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child:
                  // Icon(Icons.offline_bolt, color: Colors.red),
                  Icon(Icons.check_circle, color: Colors.blue[400]),
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
    await Future.delayed(Duration(microseconds: 1000));
    _refreshController.refreshCompleted();
  }

  ListView _listViewUsers() {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, i) => _UserTile(
              user: widget.users[i],
            ),
        separatorBuilder: (_, i) => const Divider(),
        itemCount: widget.users.length);
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
    );
  }
}
