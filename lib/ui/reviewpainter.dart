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
  double screenWidth;
  Animation<double> _animation;

  ReviewPainter(Color lineColor, Color completeColor, int centerId, bool shouldDrawCenter, double width, int startLessonId, int endLessonId, Map<int, PositionAndSize> sidePositionsCache, Map<int, List<int>> realGroupMembersCache, PositionAndSize centerPositionAndSizeCache, Map<int, bool> allLearnedZis, int compoundZiCurrentComponentId) {
    this.lineColor = lineColor;
    this.completeColor = completeColor;
    this.centerId = centerId; /*this.completePercent,*/
    this.shouldDrawCenter = shouldDrawCenter;
    this.width = width;
    this.reviewStartLessonId = startLessonId;
    this.reviewEndLessonId = endLessonId;
    this.sidePositionsCache = sidePositionsCache;
    this.realGroupMembersCache = realGroupMembersCache;
    this.centerPositionAndSizeCache = centerPositionAndSizeCache;
    this.allLearnedZis = allLearnedZis;
    this.compoundZiCurrentComponentId = compoundZiCurrentComponentId;
  }

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;

    isFromReviewPage = true;

    thePositionManager.setFrameWidth(getFrameWidth());
    //if (centerId != 1) {
      drawFrameWithColors(
          getFrameWidth(), PositionManager.FrameLeftEdgeSize,
          PositionManager.FrameTopEdgeSize, Colors.cyan,
          Colors.lime, BasePainter.FrameLineWidth);
    //}
    //?theCurrentCenterZiId = centerId;
    drawZiGroup(centerId, reviewStartLessonId, reviewEndLessonId);

    if (compoundZiCurrentComponentId > 0) {
      // for compound zi animation action only
      drawCenterZi(compoundZiCurrentComponentId, ZiListType.zi);
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