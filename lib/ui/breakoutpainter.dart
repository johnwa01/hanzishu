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

  int breakoutIndex;

  Color lineColor;
  Color completeColor;
  int lessonId;
  String wordsStudy;
  double screenWidth;

  var breakoutPositions;
  bool isBreakoutPositionsOnly;

  BreakoutPainter({
    this.lineColor, this.completeColor, this.lessonId, this.wordsStudy, this.screenWidth
  });

  @override
  void paint(Canvas canvas, Size size) {
    width = screenWidth;
    lessonLeftEdge = applyRatio(10.0);
    this.canvas = canvas;
    //this.width = size.width;
    isBreakoutPositionsOnly = false;
    displayCharacterDecomposing(lessonId, null);
  }

  double getSizeRatio() {
    var defaultSize = screenWidth / 16.0; // equivalent to the original hardcoded value of 25.0
    return defaultSize / 25.0;
  }

  double applyRatio(double value) {
    return value * getSizeRatio();
  }

  Map<int, PositionAndSize> getBreakoutPositions(int lessonId, YPositionWrapper yPositionWrapper) {
    breakoutIndex = 0;

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
            yPositionWrapper, ziId, ziListType, 0, false);
      }
    }

    var defaultFontSize = thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize);
    if (!isBreakoutPositionsOnly) {
      if (theIsFromLessonContinuedSection) {
        displayTextWithValue(
            getString(285) /*"Continue"*/, applyRatio(50.0),
            yPositionWrapper.yPosi,
            defaultFontSize, Colors.white);
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

  displayOneCharDissembling(YPositionWrapper yPositionWrapper, int ziId, ZiListType listType, int maxRecurLevel, bool showBreakoutDetails) {
    LessonManager.clearComponentsStructure();
    if (lessonLeftEdge == null) {
      lessonLeftEdge = applyRatio(10.0);
    }

    drawZiAndComponentsDissembling(0, 0, ziId, listType, lessonLeftEdge, yPositionWrapper.yPosi, showBreakoutDetails);

    yPositionWrapper.yPosi += applyRatio(20.0);
    yPositionWrapper.yPosi = LessonManager.getNextYPosition(yPositionWrapper.yPosi);
  }

  // for dissembly only
  drawZiAndComponentsDissembling(int recurLevel, int indexInLevel, int id, ZiListType listType, double transX, double transY, bool showBreakoutDetails) {
    // note: didn't apply sizeRatio to height/width. a bit better without applying it.
    var posiSize2 = PositionAndSize(transX, transY, thePositionManager.getZiSize(ZiOrCharSize.assembleDissembleSize), thePositionManager.getZiSize(ZiOrCharSize.assembleDissembleSize), thePositionManager.getCharFontSize(ZiOrCharSize.assembleDissembleSize), thePositionManager.getZiLineWidth(ZiOrCharSize.assembleDissembleSize));

    var analyzeZiYSize = thePositionManager.getZiSize(ZiOrCharSize.assembleDissembleSize);  //CGFloat(30.0)
    var analyzeZiYGap = 0.5 * analyzeZiYSize;    //CGFloat(15.0)

    if (recurLevel > 0) {
      if (theCurrentZiComponents[recurLevel] < theCurrentZiComponents[recurLevel-1]-1) {
        theCurrentZiComponents[recurLevel] = theCurrentZiComponents[recurLevel-1]-1;
      }

      if (!isBreakoutPositionsOnly) {
        drawLine(transX - applyRatio(89.0-40.0), transY + analyzeZiYGap + (analyzeZiYSize + analyzeZiYGap) * (theCurrentZiComponents[recurLevel-1]-1), transX - applyRatio(10.0), transY + analyzeZiYGap + (analyzeZiYSize + analyzeZiYGap) * (theCurrentZiComponents[recurLevel]), Colors.amber, applyRatio(2));
      }
    }

    posiSize2.transY += (analyzeZiYSize + analyzeZiYGap) *
        (theCurrentZiComponents[recurLevel]);

    if (isBreakoutPositionsOnly) {
      breakoutIndex += 1;
      //posiSize2.width *= getSizeRatio();
      //posiSize2.height *= getSizeRatio();
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

      if (showBreakoutDetails && recurLevel == 1) {
        var ziOrComp;
        if (listType == ZiListType.searching) {
          ziOrComp = theSearchingZiList[id];
        }
        else if (listType == ZiListType.component) {
          ziOrComp = theComponentList[id];
        }
        //else if (listType == ZiListType.custom) {
          // show detail is not used currently for custom
        //  var searchingZiId = ZiManager.findIdFromChar(listType, wordsStudy[id]);
        //  ziOrComp = theSearchingZiList[searchingZiId];
        //}

        if (ziOrComp != null) {
          String pinyinAndMeaning = Zi.formatPinyinAndMeaning(
              ziOrComp.pinyin, ziOrComp.meaning);
          displayTextWithValue(
              pinyinAndMeaning, posiSize2.transX + posiSize2.charFontSize * 1.1,
              posiSize2.transY, posiSize2.charFontSize / 1.7, Colors.blue);
        }
      }
    }

    theCurrentZiComponents[recurLevel] = theCurrentZiComponents[recurLevel] + 1;

    var composits = getComposits(id, listType, wordsStudy);

    if (composits != null && composits.length > 0)
    {
      var newRecurLevel = recurLevel + 1;

      // if showBreakoutDetails, stop at recurLevel 1
      if (!showBreakoutDetails || (showBreakoutDetails && newRecurLevel <= 1)) {
        var size = 89.0 * getSizeRatio(); //100 // length of each layer
        for (var i = 0; i < composits.length; i++) {
          drawZiAndComponentsDissembling(newRecurLevel, i, composits[i].id, composits[i].listType, posiSize2.transX + size, transY, showBreakoutDetails); // transY is the original value
        }
      }

    }
  }

  List<IdAndListTypePair> getComposits(int id, ZiListType listType, String wordsStudy) {
    List<IdAndListTypePair> pairList = [];

    if (listType == ZiListType.searching) {
      return theDictionaryManager.getComposits(id);
    }
    //else if (listType == ZiListType.custom) {
    //  var searchingZiId = ZiManager.findIdFromChar(ZiListType.searching, wordsStudy[id]);
    //  return theDictionaryManager.getComposits(searchingZiId);
    //}
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