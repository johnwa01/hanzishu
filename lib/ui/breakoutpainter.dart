import 'package:flutter/material.dart';
import 'package:hanzishu/data/componentlist.dart';
import 'dart:ui';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/engine/zi.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/lessonmanager.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/data/searchingzilist.dart';

class BreakoutPainter extends BasePainter {
  var lessonLeftEdge;

  //PrimitiveWrapper breakoutIndex;

  Color lineColor;
  Color completeColor;
  int lessonId;
  String wordsStudy;
  double screenWidth;

  var breakoutPositions;
  bool isBreakoutPositionsOnly = false;

  BreakoutPainter({
    required this.lineColor, required this.completeColor, required this.lessonId, required this.wordsStudy, required this.screenWidth
  });

  @override
  void paint(Canvas canvas, Size size) {
    width = screenWidth;
    lessonLeftEdge = applyRatio(10.0);
    this.canvas = canvas;
    //this.width = size.width;
    isBreakoutPositionsOnly = false;
    YPositionWrapper yPosi = YPositionWrapper(0.0);
    displayCharacterDecomposing(lessonId, yPosi);
  }

  double getSizeRatio() {
    var defaultSize = screenWidth / 16.0; // equivalent to the original hardcoded value of 25.0
    return defaultSize / 25.0;
  }

  double applyRatio(double value) {
    return value * getSizeRatio();
  }

  Map<int, PositionAndSize> getBreakoutPositions(int lessonId, YPositionWrapper yPositionWrapper) {
    //breakoutIndex.value = 0;

    breakoutPositions = theLessonManager.getBreakoutPositions(lessonId);

    isBreakoutPositionsOnly = true;
    displayCharacterDecomposing(lessonId, yPositionWrapper); //will only display due to above 'true' condition, only calculate contentHeight and positions.
    return breakoutPositions;
  }

  displayCharacterDecomposing(int lessonId, YPositionWrapper contentHeight) {
    var lesson = theLessonList[lessonId];

    var yPositionWrapper = YPositionWrapper(applyRatio(20.0));  //170.0


    ZiListType ziListType;
    if (lessonId == 0) {
      ziListType = ZiListType.searching;
      var wordsStudyLength = wordsStudy.length;
      // only do it once, including position only
      if (lesson.convCharsIds.length == 0) {
        for (int i = 0; i < wordsStudyLength; i++) {
          lesson.convCharsIds.add(
              ZiManager.findIdFromChar(ZiListType.searching, wordsStudy[i]));
        }
      }
    }
    else {
      ziListType = ZiListType.zi;
    }
    var wordsLength = lesson.convCharsIds.length - 1;

    for (var i = 0; i <= wordsLength; i++) {
      if (!isBreakoutPositionsOnly && i != 0) {
        drawLine(applyRatio(10.0), yPositionWrapper.yPosi - applyRatio(20.0),
            applyRatio(600.0), yPositionWrapper.yPosi - applyRatio(20.0),
            Colors.amber, applyRatio(1));
      }

      var ziId = lesson.convCharsIds[i];
      var zi;
      if (ziListType == ZiListType.zi) {
        zi = theZiManager.getZi(ziId);
      }
      //else { // custom
      //  ziId = i;
      //}

      if (ziListType == ZiListType.searching || (zi != null && zi.type == "h")) {
        displayOneCharDissembling(
            yPositionWrapper, ziId, ziListType, 0, false, isBreakoutPositionsOnly, breakoutPositions);
      }
    }

    var defaultFontSize = thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize);
    if (!isBreakoutPositionsOnly) {
      if (theIsFromLessonContinuedSection) {
        displayTextWithValue(
            getString(285) /*"Continue"*/, applyRatio(50.0),
            yPositionWrapper.yPosi,
            defaultFontSize, Colors.white, false);
      }
    }
    yPositionWrapper.yPosi += defaultFontSize + applyRatio(1) + applyRatio(15);

    if (isBreakoutPositionsOnly) {
      contentHeight.yPosi = yPositionWrapper.yPosi;
    }

    if (!isBreakoutPositionsOnly) {
      LessonManager.SetSectionCompleted(lessonId, LessonSection.Decomposing);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}