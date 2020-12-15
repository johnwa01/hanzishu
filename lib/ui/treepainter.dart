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

class TreePainter extends BasePainter {
  Color lineColor;
  Color completeColor;
  int centerId;
  //double completePercent;
  double width;
  //Size canvasSize;
  double screenWidth;
  //double frameWidth;

  TreePainter({
    this.lineColor, this.completeColor, this.centerId, /*this.completePercent,*/ this.width
  });

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;

    isFromReviewPage = false;

    thePositionManager.setFrameWidth(getFrameWidth());
    drawFrameWithColors(
        getFrameWidth(), BasePainter.FrameLeftEdgeSize, BasePainter.FrameTopEdgePosition, Colors.cyan,
        Colors.lime, BasePainter.FrameLineWidth);
    drawZiGroup(centerId, theCurrentLessonId, theCurrentLessonId);
  }

  double getFrameWidth() {
    return width - 10.0;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}