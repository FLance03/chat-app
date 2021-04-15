import 'package:flutter/material.dart';
import 'dart:collection';
import '../../widgets/widgets.dart';
import '../../classes/classes.dart';


class Bubble extends StatefulWidget {
  bool isPM;
  GetLastBubbleInterfaceHandle getLastBubbleInterfaceHandle;
  LastBubbleHandle lastBubbleHandle;
  String senderId, message;

  Bubble({@required senderId, @required isPM, @required message, @required lastBubbleHandle, getLastBubbleInterfaceHandle}){
    this.senderId = senderId;
    this.isPM = isPM;
    this.message = message;
    this.lastBubbleHandle = lastBubbleHandle;
    this.getLastBubbleInterfaceHandle = getLastBubbleInterfaceHandle;
  }
  bool isSender(String senderId) {
    return senderId == 'Tzt9xxCF3it4dCzvby40';
  }
  @override
  _Bubble createState() => _Bubble();
  
}
class _Bubble extends State<Bubble> {
  bool newRant, rebuilded=false;
  BubbleInterfaceHandle bubbleInterfaceHandle;
  List<double> circleSize = [10,10,10,10];

  bool newbubbleInterfaceHandle(String isNextSenderId) {
    print("Halo :))");
      print("first:${this.widget.message}");
    if (this.widget.senderId == isNextSenderId){
      print("Halo :((");
      print("second:${this.widget.message}");
      print("dsadads${this.widget.senderId} -- ${isNextSenderId}");
      print("dsvsdvsv");
      if (this.widget.isSender(this.widget.senderId)) {
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
    Color bubbleColor = this.widget.isSender(this.widget.senderId) ? Colors.lightBlue[200] : Colors.grey[200];

    if (!rebuilded) {
      rebuilded = true;
      if (this.widget.getLastBubbleInterfaceHandle()==null){
        print("AHHH");
      }
      print("                  ${this.widget.senderId}");
      if (this.widget.getLastBubbleInterfaceHandle()!=null && this.widget.getLastBubbleInterfaceHandle()(this.widget.senderId)){

        newRant = false;
        if (this.widget.isSender(this.widget.senderId)){
          this.circleSize[1] = 0;
        }else {
          this.circleSize[0] = 0;
        }
      }else {
        newRant = true;
      }
      this.widget.lastBubbleHandle(
        bubleInterfaceHandle: newbubbleInterfaceHandle,
      );
    }
    
    // return ConstrainedBox(
    //   constraints: BoxConstraints(maxWidth: 225),
    //   child: 
    print("HEREEEEEEEEE");
    return Align(
        alignment: this.widget.isSender(this.widget.senderId) ? Alignment.topRight : Alignment.topLeft,
        child: Container(
          margin: EdgeInsets.only(
            left: !this.widget.isSender(this.widget.senderId) ? 10 : 0,
            right: this.widget.isSender(this.widget.senderId) ? 10 : 0,
            bottom: 2,
          ),
          child: Column(
            children: [
              !this.widget.isSender(this.widget.senderId) && !this.widget.isPM && newRant ? Text(
                "Elon",
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
      );
    // );
  }
}