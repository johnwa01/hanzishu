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

class ReviewPainter extends BasePainter {
  Color lineColor;
  Color completeColor;
  int centerId;
  //double completePercent;
  double width;
  //Size canvasSize;
  double screenWidth;
  //double frameWidth;

  ReviewPainter(Color lineColor, Color completeColor, int centerId, double width, int startLessonId, int endLessonId) {
    this.lineColor = lineColor;
    this.completeColor = completeColor;
    this.centerId = centerId; /*this.completePercent,*/
    this.width = width;
    this.reviewStartLessonId = startLessonId;
    this.reviewEndLessonId = endLessonId;
  }

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;

    thePositionManager.setFrameWidth(getFrameWidth());
    if (centerId != 1) {
      drawFrameWithColors(
          getFrameWidth(), BasePainter.FrameLeftEdgeSize,
          BasePainter.FrameTopEdgePosition, Colors.cyan,
          Colors.lime, BasePainter.FrameLineWidth);
    }
    drawZiGroup(centerId, reviewStartLessonId, reviewEndLessonId);
  }

  double getFrameWidth() {
    return width - 10.0;
  }



  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}