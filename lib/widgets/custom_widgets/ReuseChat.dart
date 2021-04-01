import 'package:flutter/material.dart';
import 'dart:collection';
import '../../widgets/widgets.dart';
import '../../classes/classes.dart';

class ReuseChat extends StatefulWidget {
  ListQueue <Rant> rants;
  Chat chatContext;
  bool isPM;

  ReuseChat({@required this.rants, @required this.chatContext, @required this.isPM});

  @override
  _ReuseChat createState() => _ReuseChat();
  
}
class _ReuseChat extends State<ReuseChat> {
  TextEditingController messageController = new TextEditingController();

  Widget build(BuildContext context) {
    InitializeRants();
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
              child: Column(
                children: this.widget.rants.toList()
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
  void InitializeRants() {
    for (int i=0 ; i<this.widget.chatContext.messageGroups.length ; i++){
      this.widget.rants.add(
        Rant(
          chatHeads: this.widget.chatContext.messageGroups.elementAt(i),
          isSender: i%2==0 ? true : false,
          isPM: this.widget.isPM,
        )
      );
    }
  }
}