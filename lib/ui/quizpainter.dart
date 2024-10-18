import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/engine/zimanager.dart';

class QuizPainter extends BasePainter {
  static double FrameHeightToWidthRaitio = 1.2;
  static double FrameLeftEdgeSize = 4.0;
  static double FrameTopEdgePosition = 35.0;
  static double FrameLineWidth = 1.0;
  int theCreatedNumber = 0;
  var theTotalSideNumberOfZis = NumberOfZis(0, 0, 0, 0);
  var theDefaultTransparentFillColor = Colors
      .cyan; //UIColor(red: 0.7294, green: 0.9882, blue: 0.8941, alpha: 0.5);

  late Color lineColor;
  late Color completeColor;
  int centerId = -1;
  //double completePercent;
  //double width;
  //Size canvasSize;
  double? screenWidth;
  //double frameWidth;

  bool? withNonCharFrame;

  QuizPainter({
    required this.lineColor, required this.completeColor, required this.centerId, required this.withNonCharFrame/*this.completePercent, this.width*/
  });

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;

    //TODO: why its members are null?
    //var posiSize = PositionAndSize(100.0, 40.0, 35.0, 35.0, 15.0, 2.0);

    if (withNonCharFrame!) {
      var paint1 = Paint()
        ..color = this.completeColor!   //Color(0xff638965)
        ..style = PaintingStyle.fill;
      //a rectangle
      canvas.drawRect(Offset(0, 0) & Size(size.width, size.height), paint1);
    }

    drawRootZi(centerId, ZiListType.zi, 0.0, 0.0, size.width, size.height, size.width, /*posiSize.transX, posiSize.transY, posiSize.width, posiSize.height, posiSize.charFontSize,*/ this.lineColor as MaterialColor/*ziColor*/, /*isSingleColor:*/ true, size.width * 0.05,/*posiSize.lineWidth,*/ /*createFrame:*/ true, /*rootZiLearned*/false, /*withPinyin*/false, Colors.cyan /*TODO*/, true);
    // drawZiGroup(centerId);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}