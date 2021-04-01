import 'package:flutter/material.dart';
import 'dart:collection';
import '../../widgets/widgets.dart';
import '../../classes/classes.dart';

class PrivateChat extends StatefulWidget {
  @override
  _PrivateChat createState() => _PrivateChat();
  
}
class _PrivateChat extends State<PrivateChat> {
  TextEditingController messageController = new TextEditingController();
  ListQueue <Rant> rants = ListQueue();
  Chat chatContext = Chat(ListQueue.from([
    MessageGroup(
      'A',
      [
        Message('message A'),
        Message('message A'),
      ]
    ),
    MessageGroup(
      'B',
      [
        Message('message B'),
        Message('message B'),
        Message('message B'),
      ]
    ),
    MessageGroup(
      'C',
      [
        Message('message C'),
      ]
    ),
    MessageGroup(
      'D',
      [
        Message('message D'),
        Message('message D'),
        Message('message D'),
        Message('message D'),
      ]
    ),
  ]));

  Widget build(BuildContext context) {
    return ReuseChat(
      rants: rants,
      chatContext: chatContext,
      isPM: true,
    );
  }
}