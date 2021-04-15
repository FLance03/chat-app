import 'package:flutter/material.dart';
import '../classes.dart';

class Message {
  String message;
  User sender;
  var date_created;
  
  Message({this.sender, this.message});
}