import 'package:chat_demo_app/pages/pages.dart';
import 'package:chat_demo_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return Center(child: Text('Loading...'));
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authserviceProvider =
        Provider.of<AuthService>(context, listen: false);
    final isAuthenticated = await authserviceProvider.isLoggedIn();

    if (isAuthenticated) {
      //todo connect to socket service
      // Navigator.pushReplacementNamed(context, 'users');
      // to avoid animationtransition between page instead of navitaor push replacemennamed we do the following:
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => UsersPage(),
              transitionDuration: Duration(microseconds: 0)));
    } else {
      // Navigator.pushReplacementNamed(context, 'login');
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => LoginPage(),
              transitionDuration: Duration(microseconds: 0)));
    }
  }
}
