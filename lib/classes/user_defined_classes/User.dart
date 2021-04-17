import 'package:flutter/material.dart';
import '../classes.dart';

class User {
  String name, id;
  
  User({this.id, this.name});

  
  static Future<List<User>> findUser({String text, int maxCount}) {
    List<User> retVal = [];
    String lastCharacter;

    text = text.trim().toLowerCase();
    lastCharacter = text.substring(text.length-1, text.length);
    return FirebaseFirestore.instance
    .collection("users")
    .limit(maxCount)
    .where("name", isGreaterThanOrEqualTo: text)
    .where("name", isLessThan: text.replaceRange(text.length-1, 
                                                text.length, 
                                                String.fromCharCode(lastCharacter.codeUnitAt(0)+1)
                                                ) // Replace last character with the next code unit
          )
    .get() // Query Starts with "term"
    .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((DocumentSnapshot  doc) {
        retVal.add(
          User(
            id: doc.id,
            name: doc["name"],
          ),
        );
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
}