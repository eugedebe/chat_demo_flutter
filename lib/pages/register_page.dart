import 'package:chat_demo_app/helpers/show_alerts.dart';
import 'package:chat_demo_app/services/auth_service.dart';
import 'package:chat_demo_app/services/socket_service.dart';
import 'package:chat_demo_app/widgets/custom_button_1.dart';
import 'package:chat_demo_app/widgets/custom_input_text_field.dart';
import 'package:chat_demo_app/widgets/login_labels.dart';
import 'package:chat_demo_app/widgets/logo_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LogoLogin(),
                    _RegisterForm(),
                    LoginLabels(
                      question: "I already have an account?",
                      task: 'Log in',
                      route: 'login',
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm({super.key});

  @override
  State<_RegisterForm> createState() => __RegisterFormState();
}

class __RegisterFormState extends State<_RegisterForm> {
  late TextEditingController emailInputController;
  late TextEditingController nameInputController;
  late TextEditingController passwordInputController;
  late TextEditingController confirmPasswordInputController;

  @override
  void initState() {
    nameInputController = TextEditingController();
    emailInputController = TextEditingController();
    passwordInputController = TextEditingController();
    confirmPasswordInputController = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authServiceProvider = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: EdgeInsets.only(
        top: 20,
      ),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(children: [
        CustomInputTextField(
          keyboardType: TextInputType.text,
          textEditingController: nameInputController,
          hint: 'User Name',
          prefixIcon: Icon(Icons.perm_identity),
        ),
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
        CustomInputTextField(
          keyboardType: TextInputType.visiblePassword,
          textEditingController: confirmPasswordInputController,
          hint: 'Confirm Password',
          isPassword: true,
          prefixIcon: Icon(Icons.lock),
        ),
        CustomButton1(
          label: 'Register',
          onPressed: authServiceProvider.authenticating
              ? null
              : () async {
                  bool registerOk = await authServiceProvider.register(
                      nameInputController.text,
                      emailInputController.text,
                      passwordInputController.text);
                  if (registerOk) {
                    socketService.connect();
                    Navigator.pushReplacementNamed(context, 'users');
                  } else {
                    showAlert(
                        context: context,
                        title: 'Could not register ',
                        subtitle: '');
                  }
                },
        )
      ]),
    );
  }
}
