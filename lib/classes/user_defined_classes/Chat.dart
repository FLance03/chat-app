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
}