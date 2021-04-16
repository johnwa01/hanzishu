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
  Animation<double> _animation;

  TreePainter(Color lineColor, Color completeColor, int centerId, bool shouldDrawCenter, double width, Map<int, PositionAndSize> sidePositionsCache, Map<int, List<int>>realGroupMembersCache,   PositionAndSize centerPositionAndSizeCache, Map<int, bool> allLearnedZis, Map<int, bool> newInLesson, int compoundZiCurrentComponentId) {
    this.lineColor = lineColor;
    this.completeColor = completeColor;
    this.centerId = centerId;
    this.shouldDrawCenter = shouldDrawCenter;
    this.width = width;
    this.sidePositionsCache = sidePositionsCache;
    this.realGroupMembersCache = realGroupMembersCache;
    this.centerPositionAndSizeCache = centerPositionAndSizeCache;
    this.allLearnedZis = allLearnedZis;
    this.newInLesson = newInLesson;
    this.compoundZiCurrentComponentId = compoundZiCurrentComponentId;
    //this._progress = _progress;
  }

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);

    isFromReviewPage = false;

    thePositionManager.setFrameWidth(getFrameWidth());
    drawFrameWithColors(
        getFrameWidth(), PositionManager.FrameLeftEdgeSize, PositionManager.FrameTopEdgeSize, Colors.cyan,
        Colors.lime, BasePainter.FrameLineWidth);
    drawZiGroup(centerId, theCurrentLessonId, theCurrentLessonId);

    if (compoundZiCurrentComponentId > 0) {
      // for compound zi animation action only
      drawCenterZi(compoundZiCurrentComponentId);
    }
  }

  double getFrameWidth() {
    return width - 10.0;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}