import 'package:flutter/material.dart';
import 'dart:collection';
import '../../widgets/widgets.dart';
import '../../classes/classes.dart';


class ReuseChat extends StatefulWidget {
  ListQueue <Rant> rants;
  bool isPM;

  ReuseChat({@required this.rants, @required this.isPM});

  @override
  _ReuseChat createState() => _ReuseChat();
  
}
class _ReuseChat extends State<ReuseChat> {
  TextEditingController messageController = new TextEditingController();
  Chat chatContext;

  Widget build(BuildContext context) {
    InitializeRants();
    return Column(
      children: [
        Expanded(
          flex: 9,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              // children: this.widget.rants.toList()
              children: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                        .collection('messages')
                        .where('chat_id', isEqualTo: 'w8RTtLLQM93tZ6PxyVLH')
                        .orderBy('date_created', descending: true)
                        .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }
                  List<Message> messages = [];
                  snapshot.data.docs.map((doc) => messages.add(
                    Message(
                      sender: User(
                        senderId: doc['sender_id'],
                        senderName: doc['sender_name'],
                      ),
                      message: doc['content'],
                    )
                  ));
                  chatContext.add(Chat.makeMessageGroup(messages));
                  return Rant(
                    chatHeads: this.widget.chatContext.messageGroups.elementAt(i),
                    isSender: i%2==0 ? true : false,
                    isPM: this.widget.isPM,
                  );
                }
              ),
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