import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/authentication_service.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/screens/screens.dart';
import 'package:chat_app/classes/classes.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream mobileStreamChat;
  User userObj;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFuntions.getUserNameSharedPreference();
    databaseMethods.getUserbyUsername(Constants.myName).then((value){
      userObj = new User(id: value.docs[0].id.toString(), 
                        name: value.docs[0].data()["name"]);
      databaseMethods.getChatRooms(userObj.id).then((value) {
        mobileStreamChat = value;
        print("getchatrooms");
      });
      setState(() {
        print(
            "this is name ${userObj.name} and id ${userObj.id}");
      });
    });
  }

  Widget chatRoomList() {
    return StreamBuilder(
      stream: mobileStreamChat,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  print('lololol ${snapshot.data.docs[index].id}');
                  return ChatRoomsTile(
                    userObj: userObj, // get from chatrooms
                    chatRoomObj: snapshot.data.docs[index].data,
                    isPM: snapshot.data.docs[index].data()['isPM'],
                  );
                });
        } else {
          print("noData");
          return Container();
        }
        // return snapshot.hasData
            // ? ListView.builder(
            //     itemCount: snapshot.data.docs.length,
            //     shrinkWrap: true,
            //     itemBuilder: (context, index) {
            //       print("powerrangers");
            //       return ChatRoomsTile(
            //         userName: snapshot.data.docs[index].data['chatRoomId']
            //             .toString()
            //             .replaceAll("_", "")
            //             .replaceAll(Constants.myName, ""),
            //         chatRoomId: snapshot.data.docs[index].data["chatRoomId"],
            //       );
            //     })
            // : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(context),
      appBar: AppBar(
        title: Text(
          "Chat App",
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: ()  {
              User user;
              showSearch(
                context: context, 
                delegate: NameSearch(user: this.userObj),
              ).then((Chat chat) {
                if (chat != null) {
                  if (chat.isPM) {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                        PrivateChat(
                          user:
User(
    id: "Su80LbnaD0Szia4Yh7QM",
    name: "bob",
  ),
                          chat: chat,
                        )
                    ));
                  }else {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                        GroupChat(
                          user: 
  User(
    id: "Su80LbnaD0Szia4Yh7QM",
    name: "bob",
  ),
                          chat: chat,
                        )
                    ));
                  }
                }
              });
            },
          ),
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MainMenuSearch()));
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  ChatRoomsTile({@required this.userObj, @required this.chatRoomObj, this.isPM});
  final User userObj;
  final Object chatRoomObj;
  final bool isPM;

  @override
  Widget build(BuildContext context) {
    String displayname;
    if(isPM == true){
      displayname = findPrivateChatPerson(context, chatRoomObj, userObj).name;
    }
    return GestureDetector(
      onTap: (){ isChatPM(context, isPM, chatRoomObj, userObj); },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30)),
              // child: Text(userObj.name.substring(0, 1),
              child: Text(displayname.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
            ),
            SizedBox(
              width: 12,
            ),
            Text(displayname,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }

  findPrivateChatPerson(context, chatRoomObj, userObj){
    String chatUserID;
    String chatUserName;

    if(chatRoomObj()["admins"][0]["name"] == userObj.name){
      chatUserID = chatRoomObj()["non-admins"][0]["id"];
      chatUserName = chatRoomObj()["non-admins"][0]["name"];
    } else {
      chatUserID = chatRoomObj()['admins'][0]['id'];
      chatUserName = chatRoomObj()['admins'][0]['name'];
    }

    print(chatUserName);

    return Private(id: chatUserID, name: chatUserName);
  }

  isChatPM(context, isPM, chatRoomObj, userObj){
    print("test");
    if(isPM == true){
      return Navigator.push(context, MaterialPageRoute(
        builder: (context) => PrivateChat(
          user: userObj,
          chat: findPrivateChatPerson(context, chatRoomObj, userObj), // inefficient? store display name retval and call here
        )
      ));
    } else {
      return Navigator.push(context, MaterialPageRoute(
        builder: (context) => GroupChat(
          user: userObj,
          chat: Group(id: chatRoomObj().id),
        )
      ));
    }
  }
}

//drawer
Widget drawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          padding: EdgeInsets.zero,
          child: Container(
            color: Theme.of(context).primaryColor,
            child: Align(
              alignment: Alignment.centerLeft,
              child: UserAccountsDrawerHeader(
                accountEmail: FittedBox(
                  child: Text(
                    "student@gmail.com", // placeholder
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                accountName: FittedBox(
                  child: Text(
                    "student", // placeholder
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Theme.of(context).accentColor,
                ),
              ),
            ),
          ),
        ),
        Container(
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text(
                'Sign Out',
                style: Theme.of(context).textTheme.headline6,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Authenticate()));
              },
            ),
          ),
        ),
      ],
    ),
  );
}
