import 'package:flutter/material.dart';
import 'dart:collection';
import '../../widgets/widgets.dart';
import '../screens.dart';
import '../../classes/classes.dart';

class MainMenuSearch extends StatefulWidget {
  User user;

  MainMenuSearch({this.user});
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
        title: Text('Create Group Chat'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        tooltip: 'Create Group',
        onPressed: () async {
          DocumentReference doc;
          Chat chat;

          if (this.addedUsers.length > 0) {
            doc = await Chat.createChat(
              creator: this.widget.user,
              members: this.addedUsers,
              isPM: false,
            );
            print(doc.id);
            chat = Group(
              id: doc.id,
            );
            return Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) =>
                GroupChat(
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
            height: 700,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(20),
                width: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Suggested',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance 
                          .collection("chats")
                          .where("members", arrayContains: this.widget.user.id)
                          .where('isPM', isEqualTo: true)
                          .orderBy('date_last_sent', descending: true)
                          .get(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          List<Widget> children = [];
                          String other;
                          
                          if (snapshot.hasData) {
                            List<User> suggested = [];
                            Map<String, dynamic> suggestedUser;
                            
                            for (int i=0 ; i<snapshot.data.docs.length && children.length<5 ;  i++){
                              // print(i);
                              // print(snapshot.data.docs[i].data());
                              // print(snapshot.data.docs[i].id);
                              suggestedUser = snapshot.data.docs[i].data()['admins'][0]['id']==this.widget.user.id ? 
                                              snapshot.data.docs[i].data()['non-admins'][0] : 
                                              snapshot.data.docs[i].data()['admins'][0];
                              if (suggested.indexWhere((suggested) => suggested.id==suggestedUser['id']) != -1 
                                        || this.addedUsers.indexWhere((addedUser) => addedUser.id==suggestedUser['id']) != -1){
                                continue;
                              }
                              print('thiss   $suggestedUser');
                              suggested.add(
                                User(
                                  id: suggestedUser['id'],
                                  name: suggestedUser['name'],
                                )
                              );
                            }
                            children = suggested.map( (user) { 
                              return GestureDetector(
                                onTap: () {
                                  print(user);
                                  print(suggested);
                                  setState(() {
                                    this.addedUsers.add(
                                      User(
                                        id: user.id,
                                        name: user.name,
                                      )
                                    );
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
                                  child: Text(
                                    user.name,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              );
                            }).toList();
                              // print(snapshot.data.docs[i].data()['admins']);
                              // suggestedUser = {
                              //   'name': 'sadad',
                              //   'id': 'sadad',
                              // };
                              // print(suggestedUser['name']);
                          } else if (snapshot.hasError) {
                            children = <Widget>[Text('Error: ${snapshot.error}'),];
                          } else {
                            children = const <Widget>[Text('Loading...'),];
                          }
                          
                          return Wrap(
                            runSpacing: 5.0,
                            spacing: 5.0,
                            children: children,
                          );
                        }
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Text(
                        'Added',
                        style: TextStyle(
                          fontSize: 17,
                        ),
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
                                  (addedUser) => addedUser.id == user.id
                                );
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
                                    user.name,
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
                        }).toList()
                      ),
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
