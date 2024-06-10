import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/engine/zimanager.dart';


class OneRootZiPainter extends BasePainter {
  int ziId;
  ZiListType ziListType;
  double screenWidth;
  double fontSize;
  Color ziColor;

  OneRootZiPainter({
    this.ziId, this.ziListType, this.screenWidth, this.fontSize, this.ziColor
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
        ziColor, //Colors.brown,
        false,
        1.0, //posi.lineWidth,
        false, //createFrame,
        false,
        false, //withPinyin,
        null, //frameFillColor,
        true);
    }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}