import 'package:flutter/material.dart';
import '../../classes/classes.dart';

class Rant extends StatelessWidget {
  bool isSender,isPM;
  MessageGroup chatHeads;

  Rant({@required this.isSender, @required this.chatHeads, @required this.isPM});

  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: isSender ? Alignment.topRight : Alignment.topLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 225),
            child: Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Align(
                    alignment: isSender ? Alignment.topRight : Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: ProduceMessages(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  List<Container> ProduceMessages(BuildContext context) {
    List<Container> messageWidgets = [];
    double bubbleCircleSize = 10;
    int bubbleMarginSize = isSender ? 0 : 1;
    Color bubbleColor = isSender ? Colors.lightBlue[200] : Colors.grey[200];
    
    if (!isPM && !isSender){
      messageWidgets.add(
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: bubbleMarginSize,
                child: SizedBox(
                ),
              ),
              Expanded(
                flex: 10 - bubbleMarginSize,
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    "Elon",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.black.withOpacity(0.9),
                      fontSize: DefaultTextStyle.of(context).style.fontSize * 0.9,
                    ),
                  )
                ),
              )
            ],
          ),
        ),
      );
    }
    for (int i=0 ; i<chatHeads.messages.length ; i++){
      messageWidgets.add(
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isSender ? SizedBox() : Expanded(
                flex: bubbleMarginSize,
                child: SizedBox(
                  child: i!=chatHeads.messages.length-1 ? SizedBox() : Container(
                    child: CircleAvatar(
                      radius: 20,
                      child: ClipOval(
                        child: Image.asset('assets/noodles.PNG'),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 10 - bubbleMarginSize,
                child: Container(
                  margin: EdgeInsets.only(
                    left: !isSender? 10 : 0,
                    right: isSender? 10 : 0,
                    bottom: 2,
                  ),
                  padding: EdgeInsets.all(10),
                  child: Text(chatHeads.messages[i].message),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.only(
                      topLeft: i==0 || isSender ? Radius.circular(bubbleCircleSize) : Radius.circular(0),
                      bottomLeft: i==chatHeads.messages.length-1 || isSender ? Radius.circular(bubbleCircleSize) : Radius.circular(0),
                      topRight: i==0 || !isSender ? Radius.circular(bubbleCircleSize) : Radius.circular(0),
                      bottomRight: i==chatHeads.messages.length-1 || !isSender ? Radius.circular(bubbleCircleSize) : Radius.circular(0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      );
    }
    if (chatHeads.messages.length > 0){
      messageWidgets.add(Container(height: 10));
    }
    return messageWidgets;
  }
}