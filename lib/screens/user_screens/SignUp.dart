import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/authentication_service.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  signMeUp() {
    if (formKey.currentState.validate()) {
      Map<String, String> userInfoMap = {
        "name": userNameTextEditingController.text,
        "email": emailTextEditingController.text
      };

      HelperFuntions.saveUserEmailSharedPreference(
          emailTextEditingController.text);
      HelperFuntions.saveUserNameSharedPreference(
          userNameTextEditingController.text);

      setState(() {
        isLoading = true;
      });
      authMethods
          .signUpwithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFuntions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Authenticate()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 90,
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: UserNameValidator.validate,
                              controller: userNameTextEditingController,
                              decoration: textFieldInputDecoration("Username"),
                              style: simpleTextStyle(),
                            ),
                            TextFormField(
                              validator: EmailValidator.validate,
                              controller: emailTextEditingController,
                              decoration: textFieldInputDecoration("Email"),
                              style: simpleTextStyle(),
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
                        onTap: () {
                          signMeUp();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          decoration: BoxDecoration(
                              color: Colors.indigo,
                              borderRadius: BorderRadius.circular(30)),
                          child: Text(
                            "Sign Up",
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
                            "Already have an account? ",
                            style: mediumTextStyle(),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "Sign in now",
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
}
