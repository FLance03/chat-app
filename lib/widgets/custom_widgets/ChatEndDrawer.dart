import 'package:chat_app/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/widgets.dart';
import '../../classes/classes.dart';

class ChatEndDrawer extends StatelessWidget {
  Group chat;
  User user;

  ChatEndDrawer({@required this.chat, @required this.user});
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('SpaceX'), // chat title
          ),
          this.chat.StreamAdminDependency(
                user: this.user,
                waiting: Text("Loading..."),
                outputNegative: SizedBox(),
                outputPositive: ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.group_add),
                      SizedBox(width: 10),
                      Text('Add Members'),
                    ],
                  ),
                  onTap: () {
                    return showDialog<void>(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return SearchAddUser(
                            chat: this.chat,
                            user: this.user,
                          );
                        });
                  },
                ),
              ),
          StreamBuilder<List<User>>(
            stream: chat.getAdmins(),
            builder:
                (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading Admins...");
              }
              if (!snapshot.hasData) {
                return Text("Loading Admins...");
              }
              if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                bool userIsAdmin = false;
                snapshot.data.forEach((admin) {
                  if (admin.id == user.id) {
                    userIsAdmin = true;
                  }
                });
                return ExpansionTile(
                  title: Text("Admins"),
                  children: snapshot.data.map<Widget>((admin) {
                    if (!userIsAdmin || admin.id == user.id) {
                      return ListTile(
                        title: Text(admin.name),
                        trailing: SizedBox(),
                      );
                    } else {
                      return ListTile(
                        title: Text(admin.name),
                        trailing: PopUpAdminActions(
                          user: admin,
                          chat: chat,
                          isAdmin: true,
                        ),
                      );
                    }
                    // return admin.id==user.id ? SizedBox() : ListTile(
                    //   title: Text(admin.name),
                    //   trailing: this.chat.StreamAdminDependency(
                    //     user: this.user,
                    //     waiting: Text("Fetching Admin Data..."),
                    //     outputNegative: SizedBox(),
                    //     outputPositive: PopUpAdminActions(
                    //       user: admin,
                    //       chat: chat,
                    //       isAdmin: true,
                    //     ),
                    //   ),
                    // );
                  }).toList(),
                );
              }
              return SizedBox();
            },
          ),
          StreamBuilder<List<User>>(
            stream: chat.getNonAdmins(),
            builder:
                (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading Non-Admins...");
              }
              if (!snapshot.hasData) {
                return Text("Loading Non-Admins...");
              }
              if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                bool userIsAdmin = true;
                snapshot.data.forEach((nonAdmin) {
                  if (nonAdmin.id == user.id) {
                    userIsAdmin = false;
                  }
                });
                return ExpansionTile(
                  title: Text("Non-Admins"),
                  children: snapshot.data.map<Widget>((nonAdmin) {
                    if (!userIsAdmin) {
                      return ListTile(
                        title: Text(nonAdmin.name),
                        trailing: SizedBox(),
                      );
                    } else {
                      return ListTile(
                        title: Text(nonAdmin.name),
                        trailing: PopUpAdminActions(
                          user: nonAdmin,
                          chat: chat,
                          isAdmin: false,
                        ),
                      );
                    }
                  }).toList(),
                );
              }
              return SizedBox();
            },
          ),
          ElevatedButton(
              onPressed: () {
                context.read<AuthMethods>().signOut();
              },
              child: Text("Sign Out")),
          // [
          //   ListTile(
          //     title: Text('Member A'),
          //     trailing: PopUpAdminActions(
          //       isAdmin: true,
          //     ),
          //   ),
          //   ListTile(
          //     title: Text('Member B'),
          //     trailing: PopUpAdminActions(
          //       isAdmin: true,
          //     ),
          //   ),
          // ],

          // ExpansionTile(
          //   title: Text('Members'),
          //   children: [
          //     ListTile(
          //       title: Text('Member C'),
          //       trailing: PopUpAdminActions(
          //         isAdmin: false,
          //       ),
          //     ),
          //     ListTile(
          //       title: Text('Member D'),
          //       trailing: PopUpAdminActions(
          //         isAdmin: false,
          //       ),
          //     ),
          //     ListTile(
          //       title: Text('Member E'),
          //       trailing: PopUpAdminActions(
          //         isAdmin: false,
          //       ),
          //     ),
          //     ListTile(
          //       title: Text('Member F'),
          //       trailing: PopUpAdminActions(
          //         isAdmin: false,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
