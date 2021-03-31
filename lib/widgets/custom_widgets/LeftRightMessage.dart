import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import '../../classes/classes.dart';

class LeftRightMessage extends StatelessWidget {
  Chat messages;
  bool isSender;

  LeftRightMessage({this.messages, this.isSender});
  
  Widget build(BuildContext context){
    
    return Column(
      children: ProduceRants(),
      // [
      //   Rant(
      //     chatHeads: messages.messageGroups[0],
      //     isSender: false,
      //   ),
      //   Rant(
      //     chatHeads: messages.messageGroups[1],
      //     isSender: true,
      //   ),
      // ],
    );
  }
  List<Rant> ProduceRants() {
    return List.generate(
      messages.messageGroups.length, 
      (index) => Rant(
        chatHeads: messages.messageGroups[index],
        isSender: index%2==0 ? true : false,
      ),
    );
  }
  // Chat messages;
  // bool isSender;

  // LeftRightMessage({this.messages, this.isSender});
  
  // Widget build(BuildContext context){
  //   return Align(
  //     alignment: isSender ? Alignment.topRight : Alignment.topLeft,
  //     child: Column(
  //       children: [
  //         ConstrainedBox(
  //           constraints: BoxConstraints(maxWidth: 225),
  //           child: Row(
  //             children: [
  //               Expanded(
  //                 flex: 8,
  //                 child: Rant(
  //                   isSender: isSender,
  //                   messages: [
  //                     'HaloHaloHaloHaloHaloHaloHaloHaloHaloHaloHaloHaloHaloHaloHaloHaloHaloHaloHaloHaloHaloHaloHaloHaloHaloHaloHaloHaloHalo',
  //                     'Halo',
  //                     'Halo',
  //                     'Halo',
  //                     'Halo',
  //                     'Halo',
  //                     'Halo',
  //                     'Halo',
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
