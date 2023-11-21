import 'package:flutter/material.dart';
import 'package:hanzishu/engine/drill.dart';
import 'dart:ui';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/ui/breakoutpainter.dart';

class TreePainter extends BasePainter {
  double screenWidth;
  CenterZiRelated centerZiRelated;
  //Animation<double> _animation; // not used ?

  TreePainter(Color lineColor, Color completeColor, int centerId, bool shouldDrawCenter, double width, Map<int, PositionAndSize> sidePositionsCache, Map<int, List<int>>realGroupMembersCache,   PositionAndSize centerPositionAndSizeCache, Map<int, bool> allLearnedZis, Map<int, bool> newInLesson, int compoundZiCurrentComponentId, CenterZiRelated centerZiRelated) {
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
    this.centerZiRelated = centerZiRelated;
    //this._progress = _progress;
  }

  double getSizeRatio() {
    var defaultSize = width / 16.0; // equivalent to the original hardcoded value of 25.0
    return defaultSize / 25.0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);

    isFromReviewPage = false;

    thePositionManager.setFrameWidth(getFrameWidth());
    thePositionManager.setFrameTopEdgeSizeWithRatio(getSizeRatio());

    drawFrameWithColors(ZiListType.zi,
        getFrameWidth(), PositionManager.FrameLeftEdgeSize, PositionManager.FrameTopEdgeSize, Colors.cyan,
        Colors.lime, BasePainter.FrameLineWidth);
    drawZiGroup(centerId, ZiListType.zi, 1, DrillCategory.all/*not used here*/, theCurrentLessonId, theCurrentLessonId, centerZiRelated);

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