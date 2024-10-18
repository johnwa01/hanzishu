import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/engine/zimanager.dart';


class OneRootZiPainter extends BasePainter {
  int ziId = -1;
  late ZiListType ziListType;
  late double screenWidth;
  double fontSize = 0.0;
  late Color ziColor;

  OneRootZiPainter({
    required this.ziId, required this.ziListType, required this.screenWidth, required this.fontSize, required this.ziColor
  });

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;
    this.width = screenWidth; // set the base class width variable

    drawRootZi(
        ziId,
        ziListType,
        0.0, //posi.transX,
        0.0, //posi.transY,
        fontSize, //posi.width,
        fontSize, //posi.height,
        fontSize, //posi.charFontSize,
        ziColor as MaterialColor, //Colors.brown,
        false,
        1.0, //posi.lineWidth,
        false, //createFrame,
        false,
        false, //withPinyin,
        Colors.blue, //frameFillColor,
        true);
    }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}