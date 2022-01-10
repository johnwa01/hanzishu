import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import 'package:hanzishu/engine/lesson.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/generalmanager.dart';
import 'package:hanzishu/engine/lessonmanager.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/utility.dart';

class BreakoutPainter extends BasePainter {
  static var lessonLeftEdge = xYLength(10.0);

  int breakoutIndex;

  Color lineColor;
  Color completeColor;
  int lessonId;
  double screenWidth;

  var breakoutPositions;
  bool isBreakoutPositionsOnly;

  BreakoutPainter({
    this.lineColor, this.completeColor, this.lessonId, this.screenWidth
  });

  @override
  void paint(Canvas canvas, Size size) {
    width = screenWidth;
    this.canvas = canvas;
    //this.width = size.width;
    isBreakoutPositionsOnly = false;
    displayCharacterDecomposing(lessonId);
  }

  Map<int, PositionAndSize> getBreakoutPositions(int lessonId) {
    breakoutIndex = 0;

    breakoutPositions = theLessonManager.getBreakoutPositions(lessonId);
    isBreakoutPositionsOnly = true;

    displayCharacterDecomposing(lessonId);
    return breakoutPositions;
  }

  displayCharacterDecomposing(int lessonId) {
    var lesson = theLessonList[lessonId];

    var numberOfNewAnalysisChars = lesson.getNumberOfNewAnalysisChars();
    var sharedTitleLength = xYLength(170.0);
    var contentLength = numberOfNewAnalysisChars * xYLength(180.0) + sharedTitleLength;

    var yPositionWrapper = YPositionWrapper(xYLength(100.0));  //170.0

    for (var i = 0; i <= (lesson.convCharsIds.length - 1); i++) {
      if (!isBreakoutPositionsOnly) {
        drawLine(xYLength(10.0), yPositionWrapper.yPosi - xYLength(20.0),
            xYLength(600.0), yPositionWrapper.yPosi - xYLength(20.0),
            Colors.amber, 1);
      }
      var ziId = lesson.convCharsIds[i];
      var zi = theZiManager.getZi(ziId);
      if (zi != null && zi.type == "h") {
        displayOneCharDissembling(yPositionWrapper, ziId, ZiListType.zi, 0);
      }
    }

    if (!isBreakoutPositionsOnly) {
      LessonManager.SetSectionCompleted(lessonId, LessonSection.Decomposing);
    }
  }

  displayOneCharDissembling(YPositionWrapper yPositionWrapper, int ziId, ZiListType listType, int maxRecurLevel) {
    LessonManager.clearComponentsStructure();
    drawZiAndComponentsDissembling(0, 0, ziId, listType, lessonLeftEdge, yPositionWrapper.yPosi);

    yPositionWrapper.yPosi += xYLength(30.0);
    yPositionWrapper.yPosi = LessonManager.getNextYPosition(yPositionWrapper.yPosi);
  }

  // for dissembly only
  drawZiAndComponentsDissembling(int recurLevel, int indexInLevel, int id, ZiListType listType, double transX, double transY) {
    var posiSize2 = PositionAndSize(transX, transY, thePositionManager.getZiSize(ZiOrCharSize.assembleDissembleSize), thePositionManager.getZiSize(ZiOrCharSize.assembleDissembleSize), thePositionManager.getCharFontSize(ZiOrCharSize.assembleDissembleSize), thePositionManager.getZiLineWidth(ZiOrCharSize.assembleDissembleSize));

    var analyzeZiYSize = thePositionManager.getZiSize(ZiOrCharSize.assembleDissembleSize);  //CGFloat(30.0)
    var analyzeZiYGap = 0.5 * analyzeZiYSize;    //CGFloat(15.0)

    if (recurLevel > 0) {
      if (theCurrentZiComponents[recurLevel] < theCurrentZiComponents[recurLevel-1]-1) {
        theCurrentZiComponents[recurLevel] = theCurrentZiComponents[recurLevel-1]-1;
      }

      if (!isBreakoutPositionsOnly) {
        drawLine(transX - xYLength(100.0-40.0), transY + analyzeZiYGap + (analyzeZiYSize + analyzeZiYGap) * (theCurrentZiComponents[recurLevel-1]-1), transX - xYLength(10.0), transY + analyzeZiYGap + (analyzeZiYSize + analyzeZiYGap) * (theCurrentZiComponents[recurLevel]), Colors.amber, 2);
      }
    }

    posiSize2.transY += (analyzeZiYSize + analyzeZiYGap) *
        (theCurrentZiComponents[recurLevel]);

    if (isBreakoutPositionsOnly) {
      breakoutIndex += 1;
      breakoutPositions[Utility.getUniqueNumberFromId(breakoutIndex, id, listType)] = posiSize2;
    }
    else {
      var withPinyin = false;

      drawRootZi(
          id,
          listType, //ZiListType.zi,
          posiSize2.transX,
          posiSize2.transY,
          posiSize2.width,
          posiSize2.height,
          posiSize2.charFontSize,
          Colors.brown, /*isSingleColor:*/
          false,
          posiSize2.lineWidth, /*createFrame:*/
          true,
          /*hasRootZiLearned:*/
          false,
          withPinyin,
          Colors.blue,
          true);
    }

    theCurrentZiComponents[recurLevel] = theCurrentZiComponents[recurLevel] + 1;

    var composits = getComposits(id, listType);

    if (composits != null && composits.length > 0)
    {
      var newRecurLevel = recurLevel + 1;

      for (var i = 0; i < composits.length; i++) {
        drawZiAndComponentsDissembling(newRecurLevel, i, composits[i].id, composits[i].listType, posiSize2.transX + xYLength(100.0), transY); // transY is the original value
      }

    }
  }

  List<IdAndListTypePair> getComposits(int id, ZiListType listType) {
    List<IdAndListTypePair> pairList = [];

    if (listType == ZiListType.searching) {
      return theDictionaryManager.getComposits(id);
    }
    else if (listType == ZiListType.zi) {
      var zi = theZiManager.getZi(id);
      if (zi.type == "h")
      {
        var composits = theZiManager.getZiComponents(id);
        var count = composits.length;
        if (count > 0) {
          for (var i = 0; i < count; i++) {
            pairList.add(IdAndListTypePair(composits[i], ZiListType.zi));
          }
          return pairList;
        }
      }
    }

    return null;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}