import 'package:flutter/material.dart';
import '../classes.dart';

class Chat {
  List<MessageGroup> messageGroups;

  Chat(this.messageGroups);

  List<MessageGroup> getMessageGroup(String senderId){
    return messageGroups.where((e) => e.senderId == senderId);
  }
}