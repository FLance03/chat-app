import 'dart:collection';
import 'package:flutter/material.dart';
import '../classes.dart';

class Group extends Chat{
  String name;
  List<String> members = [], admins = [];

  Group({String id, bool isPM, List<String> members, List<String> admins, String name}):
    this.name = name,
    this.admins = admins,
    super(
      id: id, 
      isPM: isPM, 
      members: members,
    );
  
  String getName(User user) {
    return name;
  }

  Future<List<User>> findPossibleUser({String text, int maxCount}) async{
    List<User> users = await User.findUser(
      text: text,
      maxCount: maxCount,
    );
    List<User> retVal = [];
    users.forEach((user) { 
      if (members.indexWhere((member) => member==user.id) == -1){
        retVal.add(user);
      }
    });
    return retVal;
  }
  void addUserToGroupChat({User user}) {
    FirebaseFirestore.instance
    .collection('chats')
    .doc('${this.id}')
    .update({
      "members": FieldValue.arrayUnion([user.id])
    }).then((result){
      members.add(user.id);
    }).catchError((e){
      print(e);
    });
  }
}