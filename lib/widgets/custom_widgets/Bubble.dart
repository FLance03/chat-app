import 'package:flutter/material.dart';
import 'dart:collection';
import '../../widgets/widgets.dart';
import '../../classes/classes.dart';


class Bubble extends StatefulWidget {
  User sender, user;
  bool isPM;
  GetLastBubbleInterfaceHandle getLastBubbleInterfaceHandle;
  LastBubbleHandle lastBubbleHandle;
  String message;

  Bubble({@required sender, @required user, @required isPM, @required message, @required lastBubbleHandle, getLastBubbleInterfaceHandle}){
    this.sender = sender;
    this.user = user;
    this.isPM = isPM;
    this.message = message;
    this.lastBubbleHandle = lastBubbleHandle;
    this.getLastBubbleInterfaceHandle = getLastBubbleInterfaceHandle;
  }
  bool isSender(String senderId) {
    return senderId == this.user.id;
  }
  @override
  _Bubble createState() => _Bubble();
  
}
class _Bubble extends State<Bubble> {
  bool newRant, rebuilded=false;
  BubbleInterfaceHandle bubbleInterfaceHandle;
  List<double> circleSize = [10,10,10,10];

  bool newbubbleInterfaceHandle(String isNextSenderId) {
    // print("Halo :))");
    //   print("first:${this.widget.message}");
    if (this.widget.sender.id==isNextSenderId && mounted){
      // print("Halo :((");
      // print("second:${this.widget.message}");
      // print("dsadads${this.widget.sender.id} -- ${isNextSenderId}");
      // print("dsvsdvsv");
      if (this.widget.isSender(this.widget.sender.id)) {
        Future.delayed(Duration.zero, () async {
          setState(() {
            circleSize[2] = 0;
          });
        });
      }else {
        Future.delayed(Duration.zero, () async {
          setState(() {
            circleSize[3] = 0;
          });
        });
      }
      return true;
    }
    return false;
  }
  Widget build(BuildContext context) {
    Color bubbleColor = this.widget.isSender(this.widget.sender.id) ? Colors.lightBlue[200] : Colors.grey[200];

    if (!rebuilded) {
      rebuilded = true;
      // if (this.widget.getLastBubbleInterfaceHandle()==null){
      //   print("AHHH");
      // }
      // print("                  ${this.widget.sender.senderId}");
      if (this.widget.getLastBubbleInterfaceHandle()!=null && this.widget.getLastBubbleInterfaceHandle()(this.widget.sender.id)){

        newRant = false;
        if (this.widget.isSender(this.widget.sender.id)){
          this.circleSize[1] = 0;
        }else {
          this.circleSize[0] = 0;
        }
      }else {
        newRant = true;
      }
      this.widget.lastBubbleHandle(
        bubbleInterfaceHandle: newbubbleInterfaceHandle,
      );
    }
    
    // return ConstrainedBox(
    //   constraints: BoxConstraints(maxWidth: 225),
    //   child: 
    return Align(
        alignment: this.widget.isSender(this.widget.sender.id) ? Alignment.topRight : Alignment.topLeft,
        child: Container(
          margin: EdgeInsets.only(
            left: !this.widget.isSender(this.widget.sender.id) ? 10 : 0,
            right: this.widget.isSender(this.widget.sender.id) ? 10 : 0,
            bottom: 2,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 225),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                newRant ? Padding(padding: EdgeInsets.only(top: 5)) : SizedBox(),
                !this.widget.isSender(this.widget.sender.id) && !this.widget.isPM && newRant? 
                Text(
                  this.widget.sender.name,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black.withOpacity(0.9),
                    fontSize: DefaultTextStyle.of(context).style.fontSize * 0.9,
                  ),
                ) : SizedBox(),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(this.widget.message),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(circleSize[0]),
                      topRight: Radius.circular(circleSize[1]),
                      bottomRight: Radius.circular(circleSize[2]),
                      bottomLeft: Radius.circular(circleSize[3]),
                    ),
                  ),
                ),
              ]
            ),
          ),
        ),
      );
    // );
  }
}