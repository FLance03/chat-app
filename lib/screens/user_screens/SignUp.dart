import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/authentication_service.dart';
import 'package:flutter/gestures.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String warningText = '';
    return Scaffold(
      body: Column(
        children: [
          Text(warningText),
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
          TextField(
            controller: confirmpwdController,
            decoration: InputDecoration(
              labelText: "Confirm Password",
            )
          ),
          ElevatedButton(
            onPressed: () {
              print(passwordController.text);
              print(confirmpwdController.text);
              if(passwordController.text == confirmpwdController.text){
                context.read<AuthenticationService>().signUp(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim()
                );
                Navigator.pop(context);
              } else {
                warningText = 'Password does not match!';
                emailController.text = passwordController.text = confirmpwdController.text = '';
              }
            },
            child: Text('Sign Up'),
          ),
          Text( "Have an account? "),
          Text.rich(
            TextSpan(
              text: "Sign in",
              style: TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
              ..onTap = (){
                Navigator.pop(context);
              }
            )
          )
        ],
      )
    );
  }
}
