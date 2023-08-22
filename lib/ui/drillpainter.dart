import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/drill.dart';
import 'package:hanzishu/ui/positionmanager.dart';

class DrillPainter extends BasePainter {
  double screenWidth;
  ZiListType ziListType;
  DrillCategory drillCategory; //int filterId;
  int startingCenterZiId;

  DrillPainter(Color lineColor, Color completeColor, int centerId, bool shouldDrawCenter, double width, int startLessonId, int endLessonId, Map<int, PositionAndSize> sidePositionsCache, Map<int, List<int>> realGroupMembersCache, PositionAndSize centerPositionAndSizeCache, Map<int, bool> allLearnedZis, int compoundZiCurrentComponentId, ZiListType ziListType, DrillCategory drillCategory, int startingCenterZiId) {
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
    this.ziListType = ziListType;
    this.drillCategory = drillCategory; //this.filterId = filterId;
    this.startingCenterZiId = startingCenterZiId;
  }

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;

    isFromReviewPage = true;

    thePositionManager.setFrameWidth(getFrameWidth());
    //if (centerId != 1) {
    drawFrameWithColors(ZiListType.searching,
        getFrameWidth(), PositionManager.FrameLeftEdgeSize,
        PositionManager.FrameTopEdgeSize, Colors.cyan,
        Colors.lime, BasePainter.FrameLineWidth);
    //}
    //?theCurrentCenterZiId = centerId;
    drawZiGroup(centerId, ZiListType.searching, startingCenterZiId, drillCategory, reviewStartLessonId, reviewEndLessonId);

    // component list starts from 0, unlike zi list
    if (compoundZiCurrentComponentId >= 0) {
      // for compound zi animation action only
      drawCenterZi(compoundZiCurrentComponentId, ziListType);
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