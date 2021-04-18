import 'package:flutter/material.dart';
import 'dart:collection';
import '../../widgets/widgets.dart';
import '../../classes/classes.dart';

class GroupChat extends StatefulWidget {
  User user = User(
    id: "Tzt9xxCF3it4dCzvby40",
    name: "Alice",
  );
  
  Group chat = Group(
    id: 'w8RTtLLQM93tZ6PxyVLH',
    name: 'The First Group',
    isPM: false,
    members: [
      'Tzt9xxCF3it4dCzvby40', 
      'Su80LbnaD0Szia4Yh7QM',
    ],
    admins: [
      'Tzt9xxCF3it4dCzvby40',
    ]
  );

  GroupChat({@required user});
  @override
  _GroupChat createState() => _GroupChat();
  
}
class _GroupChat extends State<GroupChat> {
  TextEditingController messageController = new TextEditingController();
  ListQueue <Rant> rants = ListQueue();
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
    return FutureBuilder(
      future: FirebaseFirestore.instance
              .collection("chats")
              .doc("w8RTtLLQM93tZ6PxyVLH")
              .get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
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
        }

        return Text("loading");
      },
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