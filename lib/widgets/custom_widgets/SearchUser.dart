import 'package:flutter/material.dart';
import 'dart:collection';
import '../../widgets/widgets.dart';
import '../../classes/classes.dart';

class SearchUser extends StatefulWidget {
  AddUserHandle handle;
  User user;
  List<User> addedUsers;

  SearchUser({@required this.handle, @required this.user, @required this.addedUsers});
  @override
  _SearchUser createState() => _SearchUser();
  
}
class _SearchUser extends State<SearchUser> {
  List<User> userChoices = [];
  bool willIgnore = true;
  TextEditingController searchController = TextEditingController();
  Widget build(BuildContext context) {
    return Positioned.fill(
      top: 25,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                hintText: 'Search User',
                contentPadding: EdgeInsets.only(top: 20.0),
                prefixIcon: Icon(
                  Icons.search,
                ),
              ),
              onChanged: (String searchName) {
                if (searchName == ''){
                  setState((){
                    this.willIgnore = true;
                  });
                }
              },
              onSubmitted: (String searchName) async {
                await User.findUser(
                  text: searchName,
                  maxCount: 20,
                ).then(
                  (List<User> users) {
                    users = users.where((user) => user.id != this.widget.user.id && this.widget.addedUsers.indexWhere((addedUser) => addedUser.id==user.id)==-1).toList();
                    if (users.length > 0){
                      setState((){
                        this.willIgnore = false;
                        this.userChoices = users;
                      });
                    }
                  }
                );
              }
            ),
            IgnorePointer(
              ignoring: this.willIgnore,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 400,
                ),
                  child: ListView.builder(
                    // scrollDirection: Axis.vertical,
                    // shrinkWrap: true,
                    itemCount: this.userChoices.length,
                    itemBuilder: (BuildContext context, index) {
                      return Card(
                        margin: EdgeInsets.only(top: 1),
                        child: ListTile(
                          title: Text(this.userChoices[index].name),
                          onTap: () {
                            this.widget.handle(
                              newUser: this.userChoices[index]
                            );
                            this.userChoices = [];
                            this.searchController.text = '';
                            setState(() {
                              this.willIgnore = true;
                            });
                          },
                        )
                      );
                    }
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}