import 'package:cloud_firestore/cloud_firestore.dart';
import '../../classes/classes.dart';

class DatabaseMethods {
  getUserbyUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  getUserbyUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  getChatRooms(String userId) async { // chatroom get
    return FirebaseFirestore.instance // accesses chatroom list, goes to members and find matching userID
        .collection("chats")
        .where("members", arrayContains: userId)
        .snapshots();
  }
}
