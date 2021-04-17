import 'package:flutter/material.dart';
import 'dart:collection';
import '../../widgets/widgets.dart';
import '../../classes/classes.dart';
class ChatAppBar extends StatefulWidget with PreferredSizeWidget{
  Chat chat;
  User user;

  ChatAppBar({@required this.chat, @required this.user});

  @override
  _ChatAppBar createState() => _ChatAppBar();
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  
}
class _ChatAppBar extends State<ChatAppBar> {
  TextEditingController groupNameController;

  @override
  void initState() {
    groupNameController = new TextEditingController(text: this.widget.chat.getName(this.widget.user));
  }
  Widget build(BuildContext context){
    return AppBar(
      title: GestureDetector(
        onTap: this.widget.chat.isPM ? (){} : () {
          return showDialog<void>(
            context: context,
            barrierDismissible: true, 
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Change Group Name'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      TextField(
                        controller: groupNameController,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Change'),
                    onPressed: () {
                      if (groupNameController.text != ''){
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              );
            }
          );
        },
        child: Text(this.widget.chat.getName(this.widget.user)),
      ),
      leading: CircleAvatar(
        radius: 15,
        child: ClipOval(
          child: Image.asset('assets/noodles.PNG'),
        ),
      ),
      leadingWidth: 40,
      actions: [
        Builder(
          builder: (context) => Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.group),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ),
      ],
    );
  }
}