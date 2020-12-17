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

  double screenWidth;

  TreePainter(Color lineColor, Color completeColor, int centerId, double width, Map<int, PositionAndSize> sidePositionsCache, Map<int, List<int>>realGroupMembersCache,   PositionAndSize centerPositionAndSizeCache) {
    this.lineColor = lineColor;
    this.completeColor = completeColor;
    this.centerId = centerId;
    this.width = width;
    this.sidePositionsCache = sidePositionsCache;
    this.realGroupMembersCache = realGroupMembersCache;
    this.centerPositionAndSizeCache = centerPositionAndSizeCache;
  }

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