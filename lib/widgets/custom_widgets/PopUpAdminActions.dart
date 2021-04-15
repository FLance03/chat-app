import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import '../../classes/classes.dart';

class AdminAction {
  String title;
  String icon;

  AdminAction({this.title, this.icon});
}

class PopUpAdminActions extends StatelessWidget {
  Widget build (BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String result) {
        switch (result) {
          case 'Admin': ManageChat.MakeAdmin(); break;
          case 'User': ManageChat.MakeUser(); break;
          case 'Kick': ManageChat.KickUser(); break;
        }
        ManageChat.MakeAdmin();
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'Admin',
          child: Text('Make Admin'),
        ),
        PopupMenuItem<String>(
          value: 'User',
          child: Text('Make User'),
        ),
        PopupMenuItem<String>(
          value: 'Kick',
          child: Text('Kick User'),
        ),
      ],
    );
  }
}