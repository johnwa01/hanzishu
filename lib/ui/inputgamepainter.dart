import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';
import 'package:hanzishu/engine/componentmanager.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/data/componenttypinglist.dart';
import 'package:hanzishu/utility.dart';
import 'dart:math';


class InputGamePainter extends BasePainter {
  String currentChar;
  double height;
  double screenWidth;

  InputGamePainter({
    required this.currentChar, required this.height, required this.screenWidth
  });

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;
    this.width = screenWidth; // set the base class width variable

    displayCurrentMessage(currentChar);  // 18.0
  }

  displayCurrentMessage(String char) {
    var randX = Random().nextInt(12);
    var randY = Random().nextInt(5) ;
    double xPosi = width * randX / 12.0;
    double yPosi = height * randY / 6.0;

    displayTextWithValue(char, xPosi, yPosi, 30.0, Colors.black, false);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}