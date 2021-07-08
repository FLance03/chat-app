import 'dart:collection';
import 'package:flutter/material.dart';
import '../classes.dart';

class Group extends Chat{

  Group({String id}):
    super(
      id: id, 
      isPM: false,
    );
  
  Stream<String> getName() {
    return FirebaseFirestore.instance
    .collection("chats")
    .doc(this.id)
    .snapshots()
    .map<String>((DocumentSnapshot doc){
      return doc.data()['name'];
    });
  }
  void updateGroupName({String name}) {
    FirebaseFirestore.instance
    .collection("chats")
    .doc(this.id)
    .update({
      "name": name,
    }).catchError((e){
      print("$e");
    });
  }

  Future<List<User>> findPossibleUser({String text, int maxCount}) async{
    List<User> users = await User.findUser(
      text: text,
      maxCount: maxCount,
    );
    return FirebaseFirestore.instance
    .collection('chats')
    .doc(this.id)
    .get()
    .then((DocumentSnapshot doc) {
      List<User> retVal = [];
      users.forEach((user) { 
        print(user.id);
        if (doc["admins"].indexWhere((admin) => admin["id"]==user.id)==-1
         && doc["non-admins"].indexWhere((nonAdmin) => nonAdmin["id"]==user.id)==-1 ){
          retVal.add(user);
        }
      });
      return retVal;
    }).catchError((e) {
      print("$e");
    });
  }
  void addUserToGroupChat({User user}) {
    FirebaseFirestore.instance
    .collection('chats')
    .doc(this.id)
    .update({
      "non-admins": FieldValue.arrayUnion([{
        "id": user.id,
        "name": user.name,
      }])
    }).catchError((e){
      print("$e");
    });
  }

  Stream<List<User>> getAdmins() {
    return FirebaseFirestore.instance
    .collection("chats")
    .doc(this.id)
    .snapshots()
    .map<List<User>>((DocumentSnapshot doc) {
      List<dynamic> admins = doc.data()['admins'];
      admins = admins.map((admin) => User(
        id: admin['id'],
        name: admin['name'],
      )).toList();
      admins.sort((left,right) => left.name.compareTo(right.name));
      return admins;
    });
    // .get()
    // .then((DocumentSnapshot doc) {
    //   List<dynamic> admins = doc.data()['admins'];
    //   print(admins);
    //   return admins.map((admin) => User(
    //     id: admin['id'],
    //     name: admin['name'],
    //   )).toList();
    // })
    // .catchError((e) {
    //   print("$e");
    // });
  }
  Widget StreamAdminDependency({@required User user, 
                                @required Widget waiting, 
                                @required Widget outputPositive, 
                                @required Widget outputNegative}) {
    return StreamBuilder<List<User>>(
      stream: this.getAdmins(),
      builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return waiting;
        }
        if (snapshot.data.indexWhere((admin) => admin.id==user.id) == -1) {
          return outputNegative;
        }else {
          return outputPositive;
        }
      }
    );
  }
  Stream<List<User>> getNonAdmins() {
    return FirebaseFirestore.instance
    .collection("chats")
    .doc(this.id)
    .snapshots()
    .map<List<User>>((DocumentSnapshot doc){
      List<dynamic> nonAdmins = doc.data()['non-admins'];
      nonAdmins = nonAdmins.map((nonAdmin) => User(
        id: nonAdmin['id'],
        name: nonAdmin['name'],
      )).toList();
      nonAdmins.sort((left,right) => left.name.compareTo(right.name));
      return nonAdmins;
    });
  }
  
  Future<void> MakeAdmin({User user}) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    return FirebaseFirestore.instance
    .collection("chats")
    .doc(this.id)
    .get()
    .then((DocumentSnapshot doc) {
      batch.update(doc.reference, {
        "admins": FieldValue.arrayUnion([{
          "id": user.id,
          "name": user.name,
        }])
      });
      batch.update(doc.reference, {
        'non-admins': FieldValue.arrayRemove([{
          "id": user.id,
          "name": user.name,
        }])
      });
      return batch.commit();
    });
  }

  Future<void> RemoveAdmin({User user}) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    return FirebaseFirestore.instance
    .collection("chats")
    .doc(this.id)
    .get()
    .then((DocumentSnapshot doc) {
      batch.update(doc.reference, {
        "non-admins": FieldValue.arrayUnion([{
          "id": user.id,
          "name": user.name,
        }])
      });
      batch.update(doc.reference, {
        'admins': FieldValue.arrayRemove([{
          "id": user.id,
          "name": user.name,
        }])
      });
      return batch.commit();
    });
  }

  Future<void> KickUser({User user}) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    return FirebaseFirestore.instance
    .collection("chats")
    .doc(this.id)
    .get()
    .then((DocumentSnapshot doc) {
      batch.update(doc.reference, {
        "non-admins": FieldValue.arrayRemove([{
          "id": user.id,
          "name": user.name,
        }])
      });
      batch.update(doc.reference, {
        'admins': FieldValue.arrayRemove([{
          "id": user.id,
          "name": user.name,
        }])
      });
      return batch.commit();
    });
  }

}