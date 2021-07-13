import 'dart:collection';
import 'package:flutter/material.dart';
import '../classes.dart';

class Group extends Chat{

  Group({String id}):
    super(
      id: id, 
      isPM: false,
    );
  
  static Future<List<Group>> findName({@required User user, String text='', int maxCount=-1}) async{
    List<Group> retVal = [];
    String lastCharacter;

    if (maxCount == -1) {
      maxCount = 999;
    }
    text = text.trim().toLowerCase();
    lastCharacter = text.substring(text.length - 1, text.length);
    await FirebaseFirestore.instance
      .collection('chats')
      .where('name', isGreaterThanOrEqualTo: text.toUpperCase())
      .where("name", isLessThanOrEqualTo: text.replaceRange(
                              text.length - 1,
                              text.length,
                              String.fromCharCode(lastCharacter.codeUnitAt(0) +
                                  1)) )
      .where('members', arrayContains: user.id)
      .orderBy('name')
      .get()
      .then((QuerySnapshot querySnapshot) {
        text = text.toLowerCase();
        querySnapshot.docs.forEach((DocumentSnapshot doc) {
          String data = doc['name'].toString().trim().toLowerCase();
          if (!doc['isPM'] && (text==data || (text.compareTo(data)==-1 && 
                              text.replaceRange(
                              text.length - 1,
                              text.length,
                              String.fromCharCode(lastCharacter.codeUnitAt(0) +
                                  1)).compareTo(data)==1)) // Not PM and either equal to or within interval
          ){
            retVal.add(
              Group(
                id: doc.id,
              ),
            );
          }
        });
      });
      return retVal;
    }

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