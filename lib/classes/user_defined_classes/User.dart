import 'package:flutter/material.dart';
import '../classes.dart';

class User {
  String name, id, email;

  User({this.id, this.name, this.email});

  static Future<List<User>> findUser({String text='', int maxCount = -1}) {
    List<User> retVal = [];
    String lastCharacter;

    if (maxCount == -1) {
      maxCount = 999;
    }
    text = text.trim().toLowerCase();
    lastCharacter = text.substring(text.length - 1, text.length);
    return FirebaseFirestore.instance
        .collection("users")
        .limit(maxCount)
        .where("name", isGreaterThanOrEqualTo: text)
        .where("name",
            isLessThan: text.replaceRange(
                text.length - 1,
                text.length,
                String.fromCharCode(lastCharacter.codeUnitAt(0) +
                    1)) // Replace last character with the next code unit
            )
        .get() // Query Starts with "term"
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((DocumentSnapshot doc) {
          String data = doc['name'].toString().trim().toLowerCase();
          if (text==data || (text.compareTo(data)==-1 && 
                              text.replaceRange(
                              text.length - 1,
                              text.length,
                              String.fromCharCode(lastCharacter.codeUnitAt(0) +
                                  1)).compareTo(data)==1) // Not PM and either equal to or within interval
          ){
            retVal.add(
              User(
                id: doc.id,
                name: doc["name"],
              ),
            );
          }
        });
      return retVal;
    });
    // return [
    //   User(id: '1',name: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'),
    //   User(id: '2',name: 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'),
    //   User(id: '3',name: 'vvvvvvvvvvvvvvvvvvvvvvvvvvv'),
    //   User(id: '4',name: 'cccccccccccccccccccccccccccccccccc'),
    //   User(id: '5',name: 'ddddddddddddddddddddddddddddddd'),
    // ];
  }

  String titleCaseName() {
    String retVal = '';
    bool wasSpace = true;

    for (int i = 0; i < this.name.length; i++) {
      retVal += wasSpace ? this.name[i].toUpperCase() : this.name[i];
      wasSpace = this.name[i] == ' ' ? true : false;
    }
    return retVal;
  }
}
