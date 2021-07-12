import 'package:flutter/material.dart';
import 'dart:collection';
import '../../widgets/widgets.dart';
import '../../classes/classes.dart';

class GroupChat extends StatefulWidget {
  final User user;
  final Chat chat;

  GroupChat({@required this.user, this.chat});
  @override
  _GroupChat createState() => _GroupChat();
}

class _GroupChat extends State<GroupChat> {
  TextEditingController messageController = new TextEditingController();
  ListQueue<Rant> rants = ListQueue();
  // Chat chatContext = Chat(ListQueue.from([
  //   MessageGroup(
  //     User(
  //       senderId: 'A1',
  //       senderName: 'Alice',
  //     ),
  //     [
  //       Message('message A'),
  //       Message('message A'),
  //     ]
  //   ),
  //   MessageGroup(
  //     User(
  //       senderId: 'B1',
  //       senderName: 'Bob',
  //     ),
  //     [
  //       Message('message B'),
  //       Message('message B'),
  //       Message('message B'),
  //     ]
  //   ),
  //   MessageGroup(
  //     User(
  //       senderId: 'C1',
  //       senderName: 'Charlie',
  //     ),
  //     [
  //       Message('message C'),
  //     ]
  //   ),
  //   MessageGroup(
  //     User(
  //       senderId: 'D1',
  //       senderName: 'Drake',
  //     ),
  //     [
  //       Message('message D'),
  //       Message('message D'),
  //       Message('message D'),
  //       Message('message D'),
  //     ]
  //   ),
  // ]));

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(
        chat: this.widget.chat,
        user: this.widget.user,
      ),
      body: ReuseChat(
        chat: this.widget.chat,
        user: this.widget.user,
      ),
      endDrawer: ChatEndDrawer(
        chat: this.widget.chat,
        user: this.widget.user,
      ),
    );
    // return Scaffold(
    //   appBar: ChatAppBar(
    //     originalGroupName: 'Test',
    //     isPM: false,
    //   ),
    //   body: ReuseChat(
    //     chatId: 'w8RTtLLQM93tZ6PxyVLH',
    //     isPM: false,
    //   ),
    //   endDrawer: ChatEndDrawer(),
    // );
  }
}
