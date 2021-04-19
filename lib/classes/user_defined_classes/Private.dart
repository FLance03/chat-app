import 'dart:collection';
import 'package:flutter/material.dart';
import '../classes.dart';

class Private extends Chat{
  String name;
  
  Private({String id, String name}):
    this.name = name,
    super(
      id: id, 
      isPM: true,
    );
  String getName() {
    return name;
  }
}