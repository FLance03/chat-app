import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import '../../classes/classes.dart';

class SearchAddUser extends StatefulWidget {
  @override
  _SearchAddUser createState() => _SearchAddUser();
}
class _SearchAddUser extends State<SearchAddUser> {
  TextEditingController textController = TextEditingController();
  UserList users = UserList();
  List<Widget> possibleUsersWidget = [];

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Change Group Name'),
      content: ListView(
          shrinkWrap: true,
          children: [
            TextField(
              controller: textController,
              textAlign: TextAlign.left,
              onChanged: (String value) {
                print('a');
                findUser(5);
              },
              decoration: InputDecoration(
                hintText: 'Search to add user...',
              ),
            ),
            ...possibleUsersWidget,
          ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Change'),
          onPressed: () {
            if (textController.text != ''){
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
  void findUser(int maxUser) {
    List<User> possibleUsers = users.findUser(textController.text,5);
    possibleUsersWidget = [];

    for (int i=0 ; i<possibleUsers.length ; i++){
      setState(() {
        possibleUsersWidget.add(
          ListTile(
            title:Text(possibleUsers[i].senderName),
          ),
        );
      });
    }
  }
  
}