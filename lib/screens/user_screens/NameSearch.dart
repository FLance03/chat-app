import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import '../../classes/classes.dart';

class NameSearch extends SearchDelegate<Chat> {
  User user;

  NameSearch({@required this.user});
  
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // User.findUser(
    //   text: query,
    // ).then((matchedUsers) {
    //   users = matchedUsers.where((user) => user.id != this.user.id).toList();
    // });
    // Group.findName(
    //   user: this.user,
    //   text: query,
    // ).then((matchedGroups) {
    //   groups = matchedGroups;
    // });
    return query=='' ? TabBlueprint() : FutureBuilder(
      future: Future.wait([
        User.findUser(
          text: query,
        ), 
        Group.findName(
          user: this.user,
          text: query,
        )
      ]),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return TabBlueprint(
            tabBarViews: [
              Container(
                child:
                Text('Loading...')
              ), 
              Container(
                child:
                Text('Loading...')
              ),
            ]
          );
        }else {
          List<User> users = snapshot.data[0];
          List<Group> groups = snapshot.data[1];

          users = users.where((user) => user.id != this.user.id).toList();
          return TabBlueprint(
            tabBarViews: [
              ListView(
                children: users.map<ListTile>(
                  (user) {
                    return ListTile(
                      title: Text(user.name),
                      onTap: () {
                        Chat chat;
                        FirebaseFirestore.instance
                          .collection('chats')
                          .where("members", arrayContains: this.user.id)
                          .where('isPM', isEqualTo: true)
                          .get()
                          .then((QuerySnapshot querySnapshot) async {
                            List<QueryDocumentSnapshot> rightSnapshot = querySnapshot.docs.where(
                                                                    (doc) => doc.data()['members'][0] == user.id ||
                                                                              doc.data()['members'][1] == user.id
                                                                    ).toList();
                            if (rightSnapshot.length == 0){
                              print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
                              chat = await Chat.createChat(
                                creator: this.user,
                                members: [user],
                              ).then((DocumentReference docRef) async {
                                return await docRef.get().then((DocumentSnapshot doc) {
                                  String chatName;

                                  chatName = doc.data()['admins'][0]['id']==this.user.id ? doc.data()['non-admins'][0]['name'] : doc.data()['admins'][0]['name'];
                                  return Private(
                                    id: doc.id,
                                    name: chatName,
                                  );
                                });
                              });
                            }else {
                              print('BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB');
                              String chatName;

                              chatName = rightSnapshot[0].data()['admins'][0]['id']==this.user.id ? 
                                          rightSnapshot[0].data()['non-admins'][0]['name'] : 
                                          rightSnapshot[0].data()['admins'][0]['name'];
                              print(rightSnapshot[0].id);
                              print(chatName);
                              chat = Private(
                                id: rightSnapshot[0].id,
                                name: chatName,
                              );
                              
                            }
                            close(context, chat);
                          });
                      },
                    );
                  }
                ).toList(),
              ), 
              ListView(
                children: groups.map<ListTile>(
                  (group) {
                    return ListTile(
                      title: StreamBuilder<String>(
                        stream: group.getName(),
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                          String text;
                          if (snapshot.hasError) {
                            text = 'Error';
                          }else {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none: 
                                text = 'Loading...';
                                break;
                              case ConnectionState.waiting: 
                                text = 'Loading...';
                                break;
                              case ConnectionState.active:
                                text = snapshot.data;
                                break;
                              case ConnectionState.done:
                                text = snapshot.data;
                                break;
                            }
                          }
                          return Text(text);
                        },
                      ),
                      onTap: () {
                        close(context, group);
                      },
                    );
                  }
                ).toList(),
              ), 
            ]
          );
        }
      }
    );
    return ListTile(title:Text('dsad'),onTap: ()=>close(context,Private(id:'dsd',name:'dfsf')));
    // ListTile(
    //     title: Text('Yoo'),
    //     onTap: () {
    //       close(context, users);
    //     });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return TabBlueprint();
  }

  Widget TabBlueprint({List<Widget> tabBarViews}) {
    tabBarViews ??= [Container(), Container()];

    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            appBar:TabBar(
                tabs: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person),
                      SizedBox(
                        width: 3,
                      ),
                      Tab(
                        text: 'Users',
                      ),
                    ],
                  ), 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.group),
                      SizedBox(
                        width: 5,
                      ),
                      Tab(
                        text: 'Group Chats',
                      ),
                    ],
                  ),
                  // Tab(
                  //   text: 'Users',
                  //   icon: Icon(Icons.person),
                  // ), 
                  // Tab(
                  //   text: 'Group Chats',
                  //   icon: Icon(Icons.group),
                  // ),
                ],
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[400],
              ),
            body: TabBarView(
              children: tabBarViews,
            ),
          );
        }
      ),
    );
  }
}
