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
  TextEditingController groupNameController = new TextEditingController();

  Widget build(BuildContext context){
    return AppBar(
      title: this.widget.chat.isPM ? PrivateChatName() : OnClickGroupName(),
      leading: (ModalRoute.of(context)?.canPop ?? false) ? BackButton() : null,
      // ModalRoute.of(context)?.canPop means execute method canPop of ModalRoute.of(context) when latter is not null
      // A ?? B means return B iff A is null to begin with
      actions: [
        this.widget.chat.isPM ? SizedBox() : Builder(
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
  Widget PrivateChatName() {
    Private private = this.widget.chat;
    return Text(private.getName());
  }
  Widget GroupChatName() {
    Group group = this.widget.chat;
    return StreamBuilder(
      stream: group.getName(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading Group Name...");
        }
        if (!snapshot.hasData){
          return Text("Loading Group Name...");
        }
        this.groupNameController.text = snapshot.data;
        return Text(snapshot.data);
      }
    );
  }
  Widget OnClickGroupName() {
    Group group = this.widget.chat;
    return group.StreamAdminDependency(
      user: this.widget.user,
      waiting: Text("Loading Group Name..."),
      outputNegative: GroupChatName(),
      outputPositive: GestureDetector(
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
                        Group group = this.widget.chat;
                        group.updateGroupName(
                          name: groupNameController.text,
                        );
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              );
            }
          );
        },
        child: GroupChatName(),
      ),
    );
  }
}