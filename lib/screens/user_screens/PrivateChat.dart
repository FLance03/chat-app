import 'package:flutter/material.dart';
import 'dart:collection';
import '../../widgets/widgets.dart';
import '../../classes/classes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PrivateChat extends StatefulWidget {
  User user = User(
    id: "Tzt9xxCF3it4dCzvby40",
    name: "Alice",
  );
  
  Chat chat = Chat(
    id: 'w8RTtLLQM93tZ6PxyVLH',
    isPM: true,
    members: [
      'Tzt9xxCF3it4dCzvby40', 
      'Su80LbnaD0Szia4Yh7QM',
    ],
  );
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
              .collection("chats")
              .doc("Tzt9xxCF3it4dCzvby40")
              .get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshotChat) {

        if (snapshotChat.hasError) {
          return Text(snapshotChat.error.toString());
        }

        if (snapshotChat.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshotChat.data.data();
          String otherUserId;
          otherUserId = data['members'][0]==this.widget.user.id ? data['members'][1] : data['members'][0];
          return FutureBuilder(
            future: FirebaseFirestore.instance
                    .collection("users")
                    .doc(otherUserId)
                    .get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshotUser) {
              if (snapshotUser.hasError) {
                return Text(snapshotUser.error.toString());
              }
              if (snapshotUser.connectionState == ConnectionState.done) {
                return Scaffold(
                  appBar: ChatAppBar(
                    chat: this.widget.chat,
                    user: this.widget.user,
                  ),
                  body: ReuseChat(
                    chat: this.widget.chat,
                  ),
                );
              }
              return Text("loading");
            }
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