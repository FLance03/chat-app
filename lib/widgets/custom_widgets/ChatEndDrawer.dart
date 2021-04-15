import 'package:flutter/material.dart';
import 'dart:collection';
import '../../widgets/widgets.dart';
import '../../classes/classes.dart';

class ChatEndDrawer extends StatelessWidget {
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
                  return SearchAddUser();
                }
              );
            },
          ),
          ExpansionTile(
            title: Text('Members'),
            children: [
              ListTile(
                title: Text('Member A'),
                trailing: PopUpAdminActions(),
              ),
              ListTile(
                title: Text('Member B'),
                trailing: PopUpAdminActions(),
              ),
              ListTile(
                title: Text('Member C'),
                trailing: PopUpAdminActions(),
              ),
              ListTile(
                title: Text('Member D'),
                trailing: PopUpAdminActions(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}