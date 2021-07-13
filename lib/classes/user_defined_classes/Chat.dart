import 'package:flutter/material.dart';
import '../classes.dart';

abstract class Chat {
  String id;
  bool isPM;

  Chat({this.id, this.isPM});

  dynamic getName();

  static Future<DocumentReference> createChat({User creator, List<User> members,bool isPM}) async {
    List<Map> nonAdmins = [];
    List<String> members_field = [];
    DocumentReference doc;

    if (isPM == null) {
      isPM = members.length == 1 ? true : false;
    }
    members.forEach((member) {
      nonAdmins.add({
        'id': member.id,
        'name': member.name,
      });
    });
    members_field = members.map((member) {
      return member.id;
    }).toList();
    members_field.add(creator.id);
    doc = await FirebaseFirestore.instance.collection('chats').add({
      'date_created': FieldValue.serverTimestamp(),
      'date_last_sent': null,
      'isPM': isPM,
      'last_message': null,
      'last_sender_id': null,
      'non-admins': nonAdmins,
      'admins': [
        {
          'id': creator.id,
          'name': creator.name,
        }
      ],
      'members': members_field,
      'name': "${creator.name}'s Group",
    }).catchError((e) => print("$e"));

    return doc;
  }

  void sendMessage({String message, User user}) {
    FirebaseFirestore.instance.collection('messages').add({
      'sender_name': user.name,
      'sender_id': user.id,
      'date_created': FieldValue.serverTimestamp(),
      'chat_id': this.id,
      'isPM': this.isPM,
      'content': message,
    }).catchError((e) => print("$e"));

    FirebaseFirestore.instance.collection("chats").doc(this.id).update({
      "last_message": message,
      "date_last_sent": FieldValue.serverTimestamp(),
      "last_sender_id": user.id,
    }).catchError((e) {
      print("$e");
    });
  }
}
