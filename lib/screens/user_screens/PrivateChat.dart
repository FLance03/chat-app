import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import '../../classes/classes.dart';

class PrivateChat extends StatefulWidget {
  @override
  _PrivateChat createState() => _PrivateChat();
  
}
class _PrivateChat extends State<PrivateChat> {
  TextEditingController messageController = new TextEditingController();

  Chat chatContext = Chat([
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
  ]);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Elon Musk'),
        leading: CircleAvatar(
          radius: 15,
          child: ClipOval(
            child: Image.asset('assets/noodles.PNG'),
          ),
        ),
        leadingWidth: 40,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.group),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 9,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: LeftRightMessage(
                messages: chatContext,
                isSender: true,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.lightBlue,
              padding: EdgeInsets.only(bottom: 3),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Icon(Icons.emoji_emotions_outlined),
                  ),
                  Expanded(
                    flex: 8,
                    child: TextField(
                    controller: messageController,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        // border: InputBorder.none,
                        hintText: 'Type a message...',
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}