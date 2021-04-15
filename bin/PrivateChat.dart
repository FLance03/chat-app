import 'package:flutter/material.dart';
import 'dart:collection';
import '../../widgets/widgets.dart';
import '../../classes/classes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PrivateChat extends StatefulWidget {
  @override
  _PrivateChat createState() => _PrivateChat();
  
}
class _PrivateChat extends State<PrivateChat> {
  TextEditingController messageController = new TextEditingController();
  ListQueue <Rant> rants = ListQueue();
  DocumentSnapshot lastMessage;
  Chat chatContext = Chat();
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

    // FirebaseFirestore.instance
    //   .collection('messages')
    //   .where('chat_id', isEqualTo: 'w8RTtLLQM93tZ6PxyVLH')
    //   .orderBy('date_created', descending: true)
    //   .startAfterDocument(lastMessage)
    //   .get()
    //   .then((QuerySnapshot  querySnapshot) {
    //     querySnapshot.docs.map((doc) => messages.add(
    //       Message(
    //         sender: User(
    //           senderId: doc['sender_id'],
    //           senderName: doc['sender_name'],
    //         ),
    //         message: doc['content'],
    //       )
    //     ));
    //     setState(() {
    //       lastMessage = querySnapshot.docs.last;
    //     });
    //   });

    return FutureBuilder(
      future: FirebaseFirestore.instance
              .collection("users")
              .doc("Tzt9xxCF3it4dCzvby40")
              .get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return Scaffold(
            appBar: ChatAppBar(
              originalGroupName: 'Test',
              isPM: true,
              name: data['name'],
            ),
            body: StreamBuilder<QuerySnapshot>(
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
                if (mounted){
                  setState(() {
                    chatContext.add(Chat.makeMessageGroup(messages));
                  });
                }
                return ReuseChat(
                  rants: rants,
                  chatContext: chatContext,
                  isPM: true,
                );
              }
            ),
            endDrawer: ChatEndDrawer(),
          );
        }

        return Text("loading");
      },
      // builder: (context, snapshot) {
      //   return Scaffold(
      //     appBar: ChatAppBar(
      //       originalGroupName: 'Test',
      //       isPM: true,
      //     ),
      //     body: ReuseChat(
      //       rants: rants,
      //       chatContext: chatContext,
      //       isPM: true,
      //     ),
      //     endDrawer: ChatEndDrawer(),
      //   );
      // }
    );
  }
}