import 'package:flutter/material.dart';
import 'dart:collection';
import '../../widgets/widgets.dart';
import '../screens.dart';
import '../../classes/classes.dart';

class MainMenuSearch extends StatefulWidget {
  User user = User(
    id: "Su80LbnaD0Szia4Yh7QM",
    name: "bob",
  );

  // MainMenuSearch({this.user});
  @override
  _MainMenuSearch createState() => _MainMenuSearch();
}

class _MainMenuSearch extends State<MainMenuSearch> {
  List<User> addedUsers = [];
  AddUserHandle SearchedUser({User newUser}) {
    setState(() {
      addedUsers.add(newUser);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Create New Conversation'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        tooltip: 'Create Conversation',
        onPressed: () async {
          DocumentReference doc;
          Chat chat;

          if (this.addedUsers.length > 0) {
            doc = await Chat.createChat(
              creator: this.widget.user,
              members: this.addedUsers,
            );
            print(doc.id);
            if (this.addedUsers.length == 1) {
            chat = await doc.get().then((DocumentSnapshot snapshot) {
              String chatName;

              chatName = snapshot.data()['admins'][0]['id']==this.widget.user.id ? snapshot.data()['non-admins'][0]['name'] : snapshot.data()['admins'][0]['name'];
              return Private(
                id: doc.id,
                name: chatName,
              );
            });
          }else {
            chat = Group(
              id: doc.id,
            );
          }
          return Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) =>
              this.addedUsers.length == 1 ?
                PrivateChat(
                  user: this.widget.user,
                  chat: chat,
                )
              : GroupChat(
                  user: this.widget.user,
                  chat: chat,
                )
          ));
          }
        }
      ),
      body: Stack(
        children: [
          Positioned(
            top: 100,
            height: 200,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(20),
                width: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Added',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Wrap(
                          runSpacing: 5.0,
                          spacing: 5.0,
                          children: addedUsers.map<Widget>((user) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  this.addedUsers.removeWhere(
                                      (addedUser) => addedUser.id == user.id);
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey[600],
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                margin: EdgeInsets.all(2.0),
                                padding: EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      user.titleCaseName(),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      ' X',
                                      style: TextStyle(
                                        color: Colors.red[300],
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList()),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SearchUser(
            user: this.widget.user,
            addedUsers: addedUsers,
            handle: SearchedUser,
          ),
        ],
      ),
    );
  }
}
