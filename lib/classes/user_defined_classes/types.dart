import 'package:flutter/material.dart';

// enum incrementDecrement {
//   increment,
//   decrement,
// }

typedef BubbleInterfaceHandle<T> = bool Function(String isNextSenderId);
typedef LastBubbleHandle<T> = void Function({@required BubbleInterfaceHandle bubleInterfaceHandle});
typedef GetLastBubbleInterfaceHandle<T> = BubbleInterfaceHandle Function();

