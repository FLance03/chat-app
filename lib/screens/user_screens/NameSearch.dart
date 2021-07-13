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
    return FutureBuilder(
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

          groups.forEach((element) {print(element.id);});
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
                            if (querySnapshot.docs.length == 0){
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
                              chat = Private(
                                id: querySnapshot.docs[0].id,
                                name: querySnapshot.docs[0]['name'],
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
                tabs: <Tab>[Tab(text: 'Users'), Tab(text: 'Group Chats')],
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
