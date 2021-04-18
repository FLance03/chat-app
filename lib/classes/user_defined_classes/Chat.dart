import 'dart:collection';
import 'package:flutter/material.dart';
import '../classes.dart';

class Chat {
  String id;
  bool isPM;
  List<String> members = [];
  
  Chat({this.id, this.isPM, this.members});

  String getName(User user) {
    return user.id==members[0] ? members[1] : members[0];
  }

  void sendMessage({String message, User user}) {
    FirebaseFirestore.instance
    .collection('messages')
    .add({
      'sender_name': user.name,
      'sender_id': user.id,
      'date_created': FieldValue.serverTimestamp(),
      'chat_id': this.id,
      'isPM': this.isPM,
      'content': message,
    })
    .catchError((e) => print("$e"));
  }

}