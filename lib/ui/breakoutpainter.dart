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

//TODO: replace it with PrimitiveWrapper
class YPositionWrapper {
  double yPosi;

  YPositionWrapper(double yPosi) {
    this.yPosi = yPosi;
  }
}

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
    this.canvas = canvas;
    //this.width = size.width;

    isBreakoutPositionsOnly = false;
    displayCharacterDecomposing(lessonId);
    //displayLessonCharacterAssemingbling(lessonId);  //TODO: not working yet
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
            Colors.amber, 2);
      }
      var ziId = lesson.convCharsIds[i];
      var zi = theZiManager.getZi(ziId);
      if (zi != null && zi.type == "h") {
        displayOneCharDissembling(yPositionWrapper, ziId, 0);
      }
    }

    if (!isBreakoutPositionsOnly) {
      LessonManager.SetSectionCompleted(lessonId, LessonSection.Decomposing);
    }
  }

  displayOneCharDissembling(YPositionWrapper yPositionWrapper, int ziId, int maxRecurLevel) {
    LessonManager.clearComponentsStructure();
    drawZiAndComponentsDissembling(0, 0, ziId, lessonLeftEdge, yPositionWrapper.yPosi);

    yPositionWrapper.yPosi += xYLength(30.0);
    yPositionWrapper.yPosi = LessonManager.getNextYPosition(yPositionWrapper.yPosi);
  }

  // for dissembly only
  drawZiAndComponentsDissembling(int recurLevel, int indexInLevel, int id, double transX, double transY) {
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
      breakoutPositions[Utility.getUniqueNumberFromId(breakoutIndex, id)] = posiSize2;
    }
    else {
      var withPinyin = false;

      drawRootZi(
          id,
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

    var zi = theZiManager.getZi(id);
    if (zi.type == "h")
    {
      var newRecurLevel = recurLevel + 1;
      var components = theZiManager.getZiComponents(id);
      var count = components.length;
      if (count > 0) {
        for (var i = 0; i <= (count-1); i++) {
          drawZiAndComponentsDissembling(newRecurLevel, i, components[i], posiSize2.transX + xYLength(100.0), transY); // transY is the original value
        }
      }
    }
  }

  displayLessonCharacterAssemingbling(int lessonId) {
    displayCharacterAssembling(lessonId);
  }

  displayCharacterAssembling(int id) {
    var lesson = theLessonList[id];

    var numberOfNewAnalysisChars = lesson.getNumberOfNewAnalysisChars();
    var sharedTitleLength = xYLength(120.0);
    var contentLength = numberOfNewAnalysisChars * xYLength(180.0) + sharedTitleLength;

    var yPositionWrapper = YPositionWrapper(xYLength(50.0));

    for (var i = 0; i <= (lesson.convCharsIds.length - 1); i++) {
      drawLine(xYLength(10.0), yPositionWrapper.yPosi + xYLength(30.0), xYLength(600.0), yPositionWrapper.yPosi + xYLength(30.0), Colors.amber, 1);
      var ziId = lesson.convCharsIds[i];
      if (theZiManager.isHechenZi(ziId)) {
        displayOneCharAssembling(yPositionWrapper, ziId, 0);
      }
    }

    LessonManager.SetSectionCompleted(id, LessonSection.Assembling);
  }

  displayOneCharAssembling(YPositionWrapper yPositionWrapper, int ziId, int maxRecurLevel) {
    //theAreDrawingAnalyzeComponents = true;
    LessonManager.clearComponentsStructure();
    //var transX = xPosi;

    drawZiAndComponentsAssembly(0, 0, ziId, lessonLeftEdge, yPositionWrapper.yPosi, 0);

    yPositionWrapper.yPosi += xYLength(30.0);
    yPositionWrapper.yPosi = LessonManager.getNextYPosition(yPositionWrapper.yPosi);
    //theAreDrawingAnalyzeComponents = false;
  }

  // maxRecurLevel == 0 means no limit
  drawZiAndComponentsAssembly(int recurLevel, int indexInLevel, int id, double transX, double transY, int maxRecurLevel) {
    var posiSize2 = PositionAndSize(transX, transY, PositionManager.ZiSizes[ZiOrCharSize.assembleDissembleSize], PositionManager.ZiSizes[ZiOrCharSize.assembleDissembleSize], PositionManager.CharFontSizes[ZiOrCharSize.assembleDissembleSize], PositionManager.ZiLineWidth[ZiOrCharSize.assembleDissembleSize]);

    var withPinyin = false;

    theCurrentZiComponents[recurLevel] = theCurrentZiComponents[recurLevel] + 1;

    var originalTransY = posiSize2.transY;

    var zi = theZiManager.getZi(id);
    if (zi.type == "h")
    {
      //theIsInSidingArea = true
      var newRecurLevel = recurLevel + 1;
      //if (maxRecurLevel == 0 || newRecurLevel < maxRecurLevel) {
        var components = theZiManager.getZiComponents(id);
        var count = components.length;
        if (count > 0) {
          for (var i = 0; i <= (count-1); i++) {
            drawZiAndComponentsAssembly(newRecurLevel, i, components[i], transX, posiSize2.transY, maxRecurLevel);
          }
        }
      //}
    }

    var analyzeZiYSize = thePositionManager.getZiSize(ZiOrCharSize.assembleDissembleSize);  //CGFloat(30.0)
    var analyzeZiYGap = 0.5 * analyzeZiYSize;    //CGFloat(15.0)

    // align on right side
    var deepestLevel = 3;
    if (maxRecurLevel != 0) {
      deepestLevel = maxRecurLevel;
    }
    var currentTransX = transX + xYLength(100.0) * (deepestLevel - recurLevel);

    if (recurLevel > 0) {
      var currentZiComponentMinusOne = theCurrentZiComponents[recurLevel-1];
      if (recurLevel == 1) {
        // Since the final zi shows on the bottom, therefore add one unit of y space
        currentZiComponentMinusOne = currentZiComponentMinusOne + 1;
      }
      drawLine(currentTransX + 40.0, currentTransX + 85.0, transY + analyzeZiYGap + (analyzeZiYSize + analyzeZiYGap) * theCurrentZiComponents[recurLevel], transY + analyzeZiYGap + (analyzeZiYSize + analyzeZiYGap) * currentZiComponentMinusOne, Colors.amber, 1);
    }

    var currentZiComponent = theCurrentZiComponents[recurLevel];
    if (recurLevel == 0) {
      // Since the final zi shows on the bottom, therefore add one unit of y space
      currentZiComponent = currentZiComponent + 1;
    }

    drawRootZi(
        id,
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

    drawRootZi(id, currentTransX, originalTransY + (analyzeZiYSize + analyzeZiYGap) * currentZiComponent, posiSize2.width, posiSize2.height, posiSize2.charFontSize, Colors.brown, false, posiSize2.lineWidth, true, false, withPinyin, Colors.blue, true);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}