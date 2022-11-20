import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';
import 'package:hanzishu/engine/component.dart';
import 'package:hanzishu/engine/componentmanager.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/utility.dart';



class BasicComponentsDetailPainter extends BasePainter {
  var lessonLeftEdge;

  int breakoutIndex;

  Color lineColor;
  Color completeColor;
  //int lessonId;
  int keyGroup;
  int keyIndex;
  double screenWidth;

  var breakoutPositions;
  bool isBreakoutPositionsOnly;

  BasicComponentsDetailPainter({
    this.lineColor, this.completeColor, this.keyGroup, this.keyIndex, this.screenWidth
  });

  double getSizeRatio() {
    var defaultSize = screenWidth / 16.0; // equivalent to the original hardcoded value of 25.0
    return defaultSize / 25.0;
  }

  double applyRatio(double value) {
    return value * getSizeRatio();
  }

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;
    this.width = screenWidth;  // set the base class width variable
    isBreakoutPositionsOnly = false;
    PrimitiveWrapper contentLength; // not used
    lessonLeftEdge = applyRatio(10.0);
    int lessonId = 1;
    displayAllZi(keyGroup, keyIndex, false, null, contentLength);
  }

  displayAllZi(int keyGroup, int keyIndex, bool isInfoOnly, List<SpeechIconInfo> listOfSpeechIconInfo, PrimitiveWrapper contentLength) {
    int lessonId = 1; //TODO: temp
    var lesson = theLessonList[lessonId];
    int length = 0;
    var yPositionWrapper = PrimitiveWrapper(0.0);  //170.0
    if (lessonLeftEdge == null) {
      lessonLeftEdge = applyRatio(10.0);
    }

    var categoryLetter = Component.getComponentCategoryFromGroupAndIndex(keyGroup, keyIndex);

    yPositionWrapper.value += applyRatio(20.0);
    if (!isInfoOnly) {
        displayTextWithValue(
            getString(82)/*"Basic Non-Characters (Components)"*/, lessonLeftEdge, yPositionWrapper.value,
            thePositionManager.getCharFontSize(
                ZiOrCharSize.defaultSize), Colors.brown);  //blue
    }
    yPositionWrapper.value += (thePositionManager.getCharFontSize(
        ZiOrCharSize.defaultSize) + applyRatio(15.0));

    var sortedCompIds = ComponentManager.getSortedComponentsForCategory(categoryLetter);
    var count = sortedCompIds.length;

    //TODO: use mapped list
    for (var i= 0; i <= (count-1); i++) {
        displayOneZi(yPositionWrapper,  sortedCompIds[i]/*TODO: hardcoded for now. charId*/, CharType.BasicChar, isInfoOnly, listOfSpeechIconInfo);
    }

    if (!isInfoOnly) {
        drawLine(0.0, yPositionWrapper.value, applyRatio(600.0),
            yPositionWrapper.value, Colors.grey, applyRatio(1));
    }
  }

  displayOneZi(PrimitiveWrapper yPositionWrapper, int id, String type, bool isInfoOnly, List<SpeechIconInfo> listOfSpeechIconInfo) {
    yPositionWrapper.value += applyRatio(20.0);
    displayOneZiHelper(id, type, /*lessonLeftEdge +*/ applyRatio(20.0), yPositionWrapper, isInfoOnly, listOfSpeechIconInfo);

    if (type != CharType.Phrase) {
      yPositionWrapper.value += applyRatio(30.0);

      if (!isInfoOnly) {
        var fontSize = thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize);
        var posiSize = PositionAndSize(applyRatio(20.0), yPositionWrapper.value, fontSize, fontSize, fontSize, applyRatio(1.0));
        displayCompStrokes(id, ZiListType.component, posiSize, applyRatio(1.0));
      }

      var comp = ComponentManager.getComponent(id);
      if (comp.isChar/*!theZiManager.getZi(id).isStrokeOrNonChar()*/) {
        var searchingZiIndex = DictionaryManager.getSearchingZiId(
            comp.charOrNameOfNonchar);
        if (searchingZiIndex > 0) {
          yPositionWrapper.value += applyRatio(30.0);
          if (!isInfoOnly) {
            var fontSize = thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize);
            var posiSize = PositionAndSize(applyRatio(20.0), yPositionWrapper.value, fontSize, fontSize, fontSize, applyRatio(1.0));
            displayTypingCode(searchingZiIndex, posiSize);
          }
        }
      }
    }

    yPositionWrapper.value += applyRatio(30.0);

    if (!isInfoOnly) {
      drawLine(lessonLeftEdge + applyRatio(20.0), yPositionWrapper.value, applyRatio(600.0),
          yPositionWrapper.value, Colors.grey, applyRatio(1));
    }
  }

  displayOneZiHelper(int id, String type, double transX, PrimitiveWrapper yPositionWrapper, bool isInfoOnly, List<SpeechIconInfo> listOfSpeechIconInfo) {
    var pinyin;
    var meaning;

    var comp = ComponentManager.getComponent(id);
    if (!isInfoOnly) {
      drawRootZi(
            id,
            ZiListType.component, // .zi
            transX,
            yPositionWrapper.value,
            thePositionManager.getZiSize(ZiOrCharSize.assembleDissembleSize),
            thePositionManager.getZiSize(ZiOrCharSize.assembleDissembleSize),
            thePositionManager.getCharFontSize(
                ZiOrCharSize.assembleDissembleSize),
            Colors.brown, /*isSingleColor:*/
            false,
            thePositionManager.getZiLineWidth(
                ZiOrCharSize.assembleDissembleSize), /*createFrame:*/
            true,
            /*hasRootZiLearned:*/
            false,
            false,
            Colors.blue,
            true);
        pinyin = comp.pinyin; //theZiList[id].pinyin;
        meaning = comp.meaning; //theZiList[id].meaning;
    }
    transX +=
    (thePositionManager.getCharFontSize(ZiOrCharSize.assembleDissembleSize) +
        applyRatio(10.0));

    transX = applyRatio(20.0);
    yPositionWrapper.value += applyRatio(36.0); //33.0
    if (!isInfoOnly) {
      displayTextWithValue(getString(85)/*"Sound"*/ + ": ", transX, yPositionWrapper.value,
          thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize),
          Colors.black);
    }

    transX += applyRatio(60.0);
    // display speech icon
    if (!isInfoOnly) {
      DisplayIcon(
          iconSpeechStrokes,
          transX,
          yPositionWrapper.value,
          thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize),
          thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize),
          Colors.amber /*MaterialColor ofColor*/,
          applyRatio(2.0) /*ziLineWidth*/);
    }
    else {
      // save the icon infor.
      var speechIconInfo = SpeechIconInfo(
          ZiListType.component, id, transX, yPositionWrapper.value);
      listOfSpeechIconInfo.add(speechIconInfo);
    }
    transX += applyRatio(30.0);

    // display pinyin
    if (!isInfoOnly) {
      displayTextWithValue(pinyin, transX, yPositionWrapper.value,
          thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize),
          Colors.blue);
      transX += (8.0 * pinyin.length + applyRatio(10.0));
    }

    yPositionWrapper.value += applyRatio(30.0);

    // display meaning
    if (!isInfoOnly) {
      displayTextWithValue(
          getString(86)/*"Meaning"*/ + ": ", applyRatio(20.0), yPositionWrapper.value,
          thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize),
          Colors.black);
      displayTextWithValue(
          meaning, applyRatio(20.0 + 90.0), yPositionWrapper.value,
          thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize),
          Colors.blue);

      checkAndUpdateYPosi(yPositionWrapper, "Meaning: ", meaning, applyRatio(8.0),
          thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize));
    }
  }

  checkAndUpdateYPosi(PrimitiveWrapper yPositionWrapper, String prefix, String str, double fontWidth, double fontSize) {
    var len = (applyRatio(20.0) + prefix.length * fontWidth + str.length * fontWidth + applyRatio(8.0));
    if (len > screenWidth) {
      var mul = (len ~/ screenWidth);
      yPositionWrapper.value += fontSize * mul;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}