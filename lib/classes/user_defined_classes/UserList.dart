import 'package:flutter/material.dart';
import '../classes.dart';

class UserList {
  List<User> userList;
  
  UserList({this.userList});

  List<User> findUser(String text, int maxCount) {
    List<User> retVal;

    retVal = userList.where((e) => e.senderName.toLowerCase().contains(text.toLowerCase()));
    return List();
  }
}