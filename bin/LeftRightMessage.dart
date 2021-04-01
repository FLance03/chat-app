import 'package:flutter/material.dart';
import 'dart:collection';
import '../../widgets/widgets.dart';
import '../../classes/classes.dart';

class LeftRightMessage extends StatelessWidget {
  Chat messages;
  bool isSender;

  LeftRightMessage({this.messages, this.isSender});
  
  Widget build(BuildContext context){
    
    return Column(
      children: ProduceRants(),
    );
  }
  List<Rant> ProduceRants() {
    return List.generate(
      messages.messageGroups.length, 
      (index) => Rant(
        chatHeads: null,
        isSender: null,
      ),
    );
  }
}
