import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import '../../classes/classes.dart';

import 'package:emoji_picker/emoji_picker.dart';

class MessageInput extends StatefulWidget {
  Chat chat;
  User user;

  MessageInput({@required this.chat, @required this.user});
  @override
  _MessageInput createState() => _MessageInput();
}

class _MessageInput extends State<MessageInput> {
  bool showSticker = false;
  TextEditingController messageController = new TextEditingController();

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Container(
        color: Colors.blue[100],
        padding: EdgeInsets.only(bottom: 3),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Future.delayed(Duration(milliseconds: 50), () {
                        setState(() {
                          showSticker = !showSticker;
                        });
                      });
                    },
                    icon: Icon(Icons.emoji_emotions_outlined),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: TextField(
                    onTap: () {
                      print("HIOOOOOOOOIIIII");
                      setState(() {
                        showSticker = false;
                      });
                    },
                    // focusNode: focus,
                    controller: messageController,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      // border: InputBorder.none,
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () {
                      this.widget.chat.sendMessage(
                        message: messageController.text,
                        user: this.widget.user,
                      );
                      FocusScope.of(context).unfocus();
                      messageController.text = '';
                    },
                    icon: Icon(Icons.send),
                  ),
                ),
              ],
            ),
            showSticker ? buildSticker() : SizedBox(),
          ],
        ),
      ),
    );
  }
  
  
  Future<bool> onBackPress() {
    if (showSticker) {
      setState(() {
        showSticker = false;
      });
      return Future.value(false);
    } 
    return Future.value(true);
  }
   Widget buildSticker() {
    return EmojiPicker(
      rows: 3,
      columns: 7,
      buttonMode: ButtonMode.MATERIAL,
      numRecommended: 10,
      onEmojiSelected: (emoji, category) {
        print(emoji.emoji);
        messageController.text = "${messageController.text}${emoji.emoji}";
      },
    );
  }
}