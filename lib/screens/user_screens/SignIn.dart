import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/screens/user_screens/chatRoomScreen.dart';
import 'package:chat_app/services/authentication_service.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;
  String _error;

  signIn() {
    if (formKey.currentState.validate()) {
      try {
        HelperFuntions.saveUserEmailSharedPreference(
            emailTextEditingController.text);

        databaseMethods
            .getUserbyUserEmail(emailTextEditingController.text)
            .then((val) {
          snapshotUserInfo = val;
          HelperFuntions.saveUserNameSharedPreference(
              snapshotUserInfo.docs[0].data()["name"]);
        });

        setState(() {
          isLoading = true;
        });
        authMethods
            .signInWithEmailAndPassword(emailTextEditingController.text,
                passwordTextEditingController.text)
            .then((val) {
          if (val != null) {
            HelperFuntions.saveUserLoggedInSharedPreference(true);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => ChatRoom()));
          }
        });
      } catch (e) {
        setState(() {
          _error = e.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                showAlert(),
                SizedBox(
                  height: 90,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: EmailValidator.validate,
                        controller: emailTextEditingController,
                        decoration: textFieldInputDecoration("Email"),
                        style: simpleTextStyle(),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: PasswordValidator.validate,
                        controller: passwordTextEditingController,
                        decoration: textFieldInputDecoration("Password"),
                        style: simpleTextStyle(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () async {
                    signIn();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(
                      "Sign In",
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: mediumTextStyle(),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Register now",
                          style: mediumTextStyle(),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showAlert() {
    if (_error != null) {
      setState(() {
        _error = null;
      });
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error),
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }
}
