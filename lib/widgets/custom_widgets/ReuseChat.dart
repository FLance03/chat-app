import 'package:flutter/material.dart';
import 'dart:collection';
import '../../widgets/widgets.dart';
import '../../classes/classes.dart';


class ReuseChat extends StatefulWidget {
  Chat chat;
  User user;

  ReuseChat({@required this.chat, @required this.user});

  @override
  _ReuseChat createState() => _ReuseChat();
  
}
class _ReuseChat extends State<ReuseChat> {
  TextEditingController messageController = new TextEditingController();
  BubbleInterfaceHandle bubbleInterfaceHandle;
  Chat chatContext;

  void lastBubbleHandle({@required BubbleInterfaceHandle bubbleInterfaceHandle}){
    // print("Halo --__--");
    // print(bubleInterfaceHandle);
    this.bubbleInterfaceHandle = bubbleInterfaceHandle;
    // print(this.widget.bubbleInterfaceHandle);
  }
  BubbleInterfaceHandle getLastBubbleInterfaceHandle() {
    return this.bubbleInterfaceHandle;
  }
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                        .collection('messages')
                        .where('chat_id', isEqualTo: this.widget.chat.id)
                        .orderBy('date_created')
                        .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
    // print(this.widget.bubbleInterfaceHandle);
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }
                  if (!snapshot.hasData){
                    return Text("Loading");
                  }
                  // List<Message> messages = [];
                  // snapshot.data.docs.map((doc) => messages.add(
                  //   Message(
                  //     sender: User(
                  //       senderId: doc['sender_id'],
                  //       senderName: doc['sender_name'],
                  //     ),
                  //     message: doc['content'],
                  //   )
                  // ));
                  // chatContext.add(Chat.makeMessageGroup(messages));
                  return Column(
                    children: snapshot.data.docs.map(
                      (doc) {
                        User sender = User(
                          id: doc.data()['sender_id'],
                          name: doc.data()['sender_name'],
                        );
                        return Bubble(
                          sender: sender,
                          isPM: this.widget.chat.isPM,
                          message: doc.data()['content'],
                          lastBubbleHandle: lastBubbleHandle,
                          getLastBubbleInterfaceHandle: getLastBubbleInterfaceHandle,
                        );
                      }
                    ).toList()
                  );
                }
              ),
            ),
          ),
        ),
        Container(
          color: Colors.blue[100],
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
                child: GestureDetector(
                  onTap: () {
                    this.widget.chat.sendMessage(
                      message: messageController.text,
                      user: this.widget.user,
                    );
                    FocusScope.of(context).unfocus();
                    messageController.text = '';
                  },
                  child: Icon(Icons.send),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}