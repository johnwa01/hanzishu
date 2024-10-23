import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/drill.dart';
import 'package:hanzishu/ui/positionmanager.dart';

class DrillPainter extends BasePainter {
  double screenWidth = 0.0;
  ZiListType? ziListType;
  DrillCategory? drillCategory; //int filterId;
  int startingCenterZiId = -1;
  late CenterZiRelatedBottum centerZiRelatedBottum;
  late Map<int, PositionAndSize> drillBreakoutPositions = Map();

  DrillPainter(Color lineColor, Color completeColor, int centerId, bool shouldDrawCenter, double width, int startLessonId, int endLessonId, Map<int, PositionAndSize> sidePositionsCache, Map<int, List<int>> realGroupMembersCache, PositionAndSize? centerPositionAndSizeCache, Map<int, bool> allLearnedZis, int compoundZiCurrentComponentId, ZiListType? ziListType, DrillCategory? drillCategory, int startingCenterZiId, CenterZiRelatedBottum centerZiRelatedBottum, bool isFromReviewPage) {
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
    this.centerZiRelatedBottum = centerZiRelatedBottum;
    this.isFromReviewPage = isFromReviewPage;
  }

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;

    thePositionManager.setFrameWidth(getFrameWidth());
    //if (centerId != 1) {
    drawFrameWithColors(ZiListType.searching,
        getFrameWidth(), PositionManager.FrameLeftEdgeSize,
        PositionManager.FrameTopEdgeSize, Colors.cyan,
        Colors.lime, BasePainter.FrameLineWidth);
    //}
    //?theCurrentCenterZiId = centerId;
    centerZiRelatedBottum.breakoutPositions = drillBreakoutPositions;
    drawZiGroup(centerId, ZiListType.searching, startingCenterZiId, drillCategory!, reviewStartLessonId, reviewEndLessonId, centerZiRelatedBottum);

    // component list starts from 0, unlike zi list
    if (compoundZiCurrentComponentId >= 0) {
      // for compound zi animation action only
      drawCenterZi(compoundZiCurrentComponentId, ziListType!);
    }
  }

  double getFrameWidth() {
    return width - 10.0;
  }

  Map<int, PositionAndSize> getDrillBreakoutPositions() { // searchingZi id has been assigned in currentCenterZiRelated
    // give it a space, which will be filled up by a run of displayCharBreakout later with no show
    centerZiRelatedBottum.breakoutPositions = drillBreakoutPositions; //theLessonManager.getBreakoutPositions(lessonId);
    bool isBreakoutPositionsOnly = true;

    var posi = thePositionManager.getHintPosi();
    var yPositionWrapper = YPositionWrapper(posi.transY);

    displayOneCharDissembling(
        yPositionWrapper,
        centerZiRelatedBottum.searchingZiId,
        ZiListType.searching,
        0,
        false,
        isBreakoutPositionsOnly,
        centerZiRelatedBottum.breakoutPositions);

    //displayCharBreakout(ziId, true); // get positions only
    return drillBreakoutPositions;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}