import 'package:chat_demo_app/helpers/show_alerts.dart';
import 'package:chat_demo_app/services/auth_service.dart';
import 'package:chat_demo_app/widgets/custom_button_1.dart';
import 'package:chat_demo_app/widgets/custom_input_text_field.dart';
import 'package:chat_demo_app/widgets/login_labels.dart';
import 'package:chat_demo_app/widgets/logo_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: size.height * 0.85,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LogoLogin(),
                  _LoginForm(),
                  LoginLabels(
                    question: "Don't have an account?",
                    task: 'Create an account',
                    route: 'register',
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm({super.key});

  @override
  State<_LoginForm> createState() => __LoginFormState();
}

class __LoginFormState extends State<_LoginForm> {
  late TextEditingController emailInputController;
  late TextEditingController passwordInputController;
  @override
  void initState() {
    emailInputController = TextEditingController();
    passwordInputController = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthService authServiceProvider = Provider.of<AuthService>(context);
    return Container(
      margin: EdgeInsets.only(
        top: 20,
      ),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(children: [
        CustomInputTextField(
          keyboardType: TextInputType.emailAddress,
          textEditingController: emailInputController,
          hint: 'Email',
          prefixIcon: Icon(Icons.mail_outline),
        ),
        CustomInputTextField(
          keyboardType: TextInputType.visiblePassword,
          textEditingController: passwordInputController,
          hint: 'Password',
          isPassword: true,
          prefixIcon: Icon(Icons.lock),
        ),
        CustomButton1(
          labelTextStyle: authServiceProvider.authenticating == true
              ? TextStyle(color: Colors.black87, fontSize: 20)
              : TextStyle(color: Colors.white, fontSize: 20),
          label: authServiceProvider.authenticating == true
              ? 'Logging in'
              : 'Login',
          onPressed: authServiceProvider.authenticating == true
              ? null
              : () async {
                  FocusScope.of(context).unfocus();
                  final bool loginOk = await authServiceProvider.login(
                      emailInputController.text.trim(),
                      passwordInputController.text);
                  if (loginOk) {
                    Navigator.pushReplacementNamed(context, 'users');
                  } else {
                    showAlert(
                        context: context,
                        title: 'Incorrect login ',
                        subtitle: 'Review your credentials');
                  }
                },
        )
      ]),
    );
  }
}
