import 'dart:collection';
import 'package:flutter/material.dart';
import '../classes.dart';

abstract class Chat {
  String id;
  bool isPM;
  
  Chat({this.id, this.isPM});

  dynamic getName();
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