import 'package:flutter/material.dart';

// enum incrementDecrement {
//   increment,
//   decrement,
// }

typedef BubbleInterfaceHandle<T> = bool Function(String isNextSenderId);
typedef LastBubbleHandle<T> = void Function({@required BubbleInterfaceHandle bubbleInterfaceHandle});
typedef GetLastBubbleInterfaceHandle<T> = BubbleInterfaceHandle Function();

