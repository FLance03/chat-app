import 'package:flutter/material.dart';
import 'dart:collection';
import '../../widgets/widgets.dart';
import '../../classes/classes.dart';

class ChatEndDrawer extends StatelessWidget {
  Group chat;
  User user;

  ChatEndDrawer({@required this.chat, @required this.user});
  Widget build(BuildContext context){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('SpaceX'),
          ),
          ListTile(
            title: Text('Add Members'),
            onTap: () {
              return showDialog<void>(
                context: context,
                barrierDismissible: true, 
                builder: (BuildContext context) {
                  return SearchAddUser(
                    chat: this.chat,
                    user: this.user,
                  );
                }
              );
            },
          ),
              FutureBuilder<List<User>>(
                future: chat.getAdmins(),
                builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ExpansionTile(
                      title: Text("Admins"),
                      children: snapshot.data.map((admin) => ListTile(
                      title: Text(admin.name),
                      trailing: PopUpAdminActions(
                        isAdmin: true,
                      ),
                    )).toList()
                    );
                  }
                  return Text("loading");
                },
              ),
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
          ExpansionTile(
            title: Text('Members'),
            children: [
              ListTile(
                title: Text('Member C'),
                trailing: PopUpAdminActions(
                  isAdmin: false,
                ),
              ),
              ListTile(
                title: Text('Member D'),
                trailing: PopUpAdminActions(
                  isAdmin: false,
                ),
              ),
              ListTile(
                title: Text('Member E'),
                trailing: PopUpAdminActions(
                  isAdmin: false,
                ),
              ),
              ListTile(
                title: Text('Member F'),
                trailing: PopUpAdminActions(
                  isAdmin: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}