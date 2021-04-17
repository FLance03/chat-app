import 'dart:collection';
import 'package:flutter/material.dart';
import '../classes.dart';

class Chat {
  ListQueue<MessageGroup> messageGroups;

  Chat(){
    this.messageGroups = ListQueue();
  }
  Chat.fromMessageGroup(ListQueue<MessageGroup>  newMessageGroup){
    messageGroups = newMessageGroup;
  }

  static Chat makeMessageGroup(List<Message> messages) {
    List<MessageGroup> messageGroup = [];
    String pastSenderId = '';

    messages.forEach((message) {
      if (pastSenderId != message.sender.id){
        messageGroup.add(MessageGroup(
          [message]
        ));
      }else {
        messageGroup.last.messages.add(message);
      }
    });
    return Chat.fromMessageGroup(ListQueue.from(messageGroup));
  }

  List<MessageGroup> getMessageGroup(User sender){
    return messageGroups.where((e) => e.messages[0].sender.id == sender.id);
  }
  void add(Chat otherChat) {
    messageGroups.addAll(otherChat.messageGroups);
  }
  
}