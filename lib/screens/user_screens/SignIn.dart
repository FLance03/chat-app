import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/authentication_service.dart';
import 'package:flutter/gestures.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController(); 

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: "Email",
            )
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: "Password",
            )
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthenticationService>().signIn(
                email: emailController.text.trim(),
                password: passwordController.text.trim()
              );
            },
            child: Text('Sign In'),
          ),
          Text( "Don't have an account? "),
          Text.rich(
            TextSpan(
              text: "Sign up",
              style: TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
              ..onTap = (){
                Navigator.pushNamed(context, '/signup');
              }
            )
          )
        ],
      )
    );
  }
}