import 'dart:collection';
import 'package:flutter/material.dart';
import '../classes.dart';

class Chat {
  ListQueue<MessageGroup> messageGroups;

  Chat(this.messageGroups);

  List<MessageGroup> getMessageGroup(String senderId){
    return messageGroups.where((e) => e.senderId == senderId);
  }
}