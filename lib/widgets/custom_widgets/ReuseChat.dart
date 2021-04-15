import 'package:flutter/material.dart';
import 'dart:collection';
import '../../widgets/widgets.dart';
import '../../classes/classes.dart';


class ReuseChat extends StatefulWidget {
  String chatId;
  bool isPM;
  BubbleInterfaceHandle bubbleInterfaceHandle;

  ReuseChat({@required this.chatId, @required this.isPM});

  @override
  _ReuseChat createState() => _ReuseChat();
  
}
class _ReuseChat extends State<ReuseChat> {
  TextEditingController messageController = new TextEditingController();
  Chat chatContext;

  void lastBubbleHandle({@required BubbleInterfaceHandle bubleInterfaceHandle}){
    print("Halo --__--");
    print(bubleInterfaceHandle);
    this.widget.bubbleInterfaceHandle = bubleInterfaceHandle;
    print(this.widget.bubbleInterfaceHandle);
  }
  BubbleInterfaceHandle getLastBubbleInterfaceHandle() {
    return this.widget.bubbleInterfaceHandle;
  }
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 9,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                        .collection('messages')
                        .where('chat_id', isEqualTo: this.widget.chatId)
                        .orderBy('date_created')
                        .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
    print(this.widget.bubbleInterfaceHandle);
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
                        return Bubble(
                          senderId: doc.data()['sender_id'],
                          isPM: true,
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
}