import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import '../../classes/classes.dart';

class SearchAddUser extends StatefulWidget {
  Group chat;
  User user;

  SearchAddUser({@required this.chat, @required this.user});
  @override
  _SearchAddUser createState() => _SearchAddUser();
}
class _SearchAddUser extends State<SearchAddUser> {
  TextEditingController textController = TextEditingController();
  List<Widget> possibleUsersWidget = [];

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add User'),
      content: Container(
        height: 250,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: TextField(
                        controller: textController,
                        textAlign: TextAlign.left,
                        // onChanged: (String value) {
                        //   print('a');
                        //   findUser(5);
                        // },
                        decoration: InputDecoration(
                          hintText: 'Search to add user...',
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: TextButton(
                        onPressed: () => findUser(textController.text, 5),
                        child: Text('Search',
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue[400]),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )
                          )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: ListView(
                  children: possibleUsersWidget,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Add'),
          onPressed: () {
            if (textController.text != ''){
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
  void findUser (String term, int maxUser) async{
    List<User> possibleUsers = await this.widget.chat.findPossibleUser(
                                            text: term,
                                            maxCount: 5,
                                          );
    
    possibleUsersWidget = [];
    for (int i=0 ; i<possibleUsers.length ; i++){
      setState(() {
        possibleUsersWidget.add(
          ListTile(
            title:Text(possibleUsers[i].name),
            trailing: TextButton(
              onPressed: () {
                this.widget.chat.addUserToGroupChat(
                  user: possibleUsers[i],
                );
                Navigator.of(context).pop();
              },
              child: Text('Add',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )
                )
              ),
            ),
          ),
        );
      });
    }
  }
  
}