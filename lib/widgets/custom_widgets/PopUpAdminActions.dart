import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import '../../classes/classes.dart';

class AdminAction {
  String title;
  String icon;

  AdminAction({this.title, this.icon});
}

class PopUpAdminActions extends StatelessWidget {
  bool isAdmin;
  User user;
  Group chat;

  PopUpAdminActions({@required this.isAdmin, @required this.user, @required this.chat});

  Widget build (BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String result) {
        switch (result) {
          case 'Admin': this.chat.MakeAdmin(user: user); break;
          case 'User': this.chat.RemoveAdmin(user: user); break;
          case 'Kick': this.chat.KickUser(user: user); break;
        }
      },
      itemBuilder: (BuildContext context) => [
        isAdmin ? PopupMenuItem<String>(
          value: 'User',
          child: Text('Remove Admin Privilege'),
        )       : PopupMenuItem<String>(
          value: 'Admin',
          child: Text('Make Admin'),
        ),
        PopupMenuItem<String>(
          value: 'Kick',
          child: Text('Kick User'),
        ),
      ],
    );
  }
  
}