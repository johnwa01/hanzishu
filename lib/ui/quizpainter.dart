import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import 'package:hanzishu/engine/lesson.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/generalmanager.dart';
import 'package:hanzishu/ui/positionmanager.dart';

class QuizPainter extends BasePainter {
  static double FrameHeightToWidthRaitio = 1.2;
  static double FrameLeftEdgeSize = 4.0;
  static double FrameTopEdgePosition = 35.0;
  static double FrameLineWidth = 1.0;
  int theCreatedNumber = 0;
  var theTotalSideNumberOfZis = NumberOfZis(0, 0, 0, 0);
  var theDefaultTransparentFillColor = Colors
      .cyan; //UIColor(red: 0.7294, green: 0.9882, blue: 0.8941, alpha: 0.5);

  Color lineColor;
  Color completeColor;
  int centerId;
  //double completePercent;
  //double width;
  //Size canvasSize;
  double screenWidth;
  //double frameWidth;

  QuizPainter({
    this.lineColor, this.completeColor, this.centerId, /*this.completePercent, this.width*/
  });

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;
    
    //TODO: why its members are null?
    //var posiSize = PositionAndSize(100.0, 40.0, 35.0, 35.0, 15.0, 2.0);

    drawRootZi(centerId, 0.0, 0.0, size.width, size.height, size.width, /*posiSize.transX, posiSize.transY, posiSize.width, posiSize.height, posiSize.charFontSize,*/ Colors.cyan/*ziColor*/, /*isSingleColor:*/ true, 2.0,/*posiSize.lineWidth,*/ /*createFrame:*/ true, /*rootZiLearned*/true, /*withPinyin*/false, Colors.cyan /*TODO*/);
    // drawZiGroup(centerId);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}