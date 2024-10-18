import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/data/phraselist.dart';
import 'package:hanzishu/data/searchingzilist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/engine/component.dart';
import 'package:hanzishu/engine/componentmanager.dart';

class BasicComponentsDetailPainter extends BasePainter {
  var lessonLeftEdge;

  int breakoutIndex = -1;

  Color lineColor = Colors.blue;
  Color completeColor = Colors.blue;
  //int lessonId;
  int keyGroup = -1;
  int keyIndex = -1;
  double screenWidth = 0.0;

  var breakoutPositions;
  bool isBreakoutPositionsOnly = false;

  BasicComponentsDetailPainter({
    required this.lineColor, required this.completeColor, required this.keyGroup, required this.keyIndex, required this.screenWidth
  });

  double getSizeRatio() {
    var defaultSize = screenWidth / 16.0; // equivalent to the original hardcoded value of 25.0
    var sizeRatio = defaultSize / 25.0;

    if (sizeRatio > 2) {
      sizeRatio = 2;
    }

    return sizeRatio;
  }

  double applyRatio(double value) {
    return value * getSizeRatio();
  }

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;
    this.width = screenWidth;  // set the base class width variable
    isBreakoutPositionsOnly = false;
    PrimitiveWrapper contentLength = PrimitiveWrapper(0.0); // not used
    lessonLeftEdge = applyRatio(10.0);
    List<SpeechIconInfo> incoInfos = <SpeechIconInfo>[];
    displayAllZi(keyGroup, keyIndex, false, incoInfos, contentLength);
  }

  displayAllZi(keyGroup, keyIndex, bool isInfoOnly, List<SpeechIconInfo> listOfSpeechIconInfo, PrimitiveWrapper contentLength) {
    //var lesson = theLessonList[lessonId];
    int length = 0;
    var yPositionWrapper = PrimitiveWrapper(0.0);  //170.0
    if (lessonLeftEdge == null) {
      lessonLeftEdge = applyRatio(10.0);
    }

    // for title
    yPositionWrapper.value += applyRatio(20.0);
    if (!isInfoOnly) {
      var groupLetter = ComponentManager.getLetterByGroupAndIndex(keyGroup, keyIndex);
      displayTextWithValue("'" + groupLetter + "' " + getString(386) + " " + getString(384)/*"Hanzi Basic Components"*/, lessonLeftEdge, yPositionWrapper.value,
          thePositionManager.getCharFontSize(
              ZiOrCharSize.defaultSize), Colors.brown, false);
    }
    yPositionWrapper.value += (thePositionManager.getCharFontSize(
        ZiOrCharSize.defaultSize) + applyRatio(15.0));

    var categoryLetter = Component.getComponentCategoryFromGroupAndIndex(keyGroup, keyIndex);
    var sortedCompIds = ComponentManager.getSortedComponentsForCategory(categoryLetter);
    length = sortedCompIds.length;
    if (length > 0) {
      for (int compId in sortedCompIds) {
          displayOneZi(yPositionWrapper, compId, CharType.BasicChar, isInfoOnly, listOfSpeechIconInfo);
      }

      yPositionWrapper.value += applyRatio(20.0);
      if (!isInfoOnly) {
        drawLine(0.0, yPositionWrapper.value, applyRatio(600.0),
            yPositionWrapper.value, Colors.grey, applyRatio(1));
      }
    }

    if (isInfoOnly) {
      contentLength.value = yPositionWrapper.value;
    }

  }

  displayOneZi(PrimitiveWrapper yPositionWrapper, int id, String type, bool isInfoOnly, List<SpeechIconInfo> listOfSpeechIconInfo) {
    var fontSize = thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize);
    yPositionWrapper.value += applyRatio(20.0);
    displayOneZiHelper(id, type, applyRatio(20.0), yPositionWrapper, isInfoOnly, listOfSpeechIconInfo);

    yPositionWrapper.value += applyRatio(30.0);

    if (!isInfoOnly) {
      var posiSize = PositionAndSize(applyRatio(20.0), yPositionWrapper.value, fontSize, fontSize, fontSize, applyRatio(1.0));
      displayCompStrokes(id, ZiListType.component, posiSize, applyRatio(1.0));
    }

    var comp = ComponentManager.getComponent(id);
    if (comp!.isChar) {
      var searchingZiIndex = DictionaryManager.getSearchingZiId(
          comp!.charOrNameOfNonchar);
      if (searchingZiIndex > 0) {
        yPositionWrapper.value += applyRatio(30.0);
        if (!isInfoOnly) {
          //var fontSize = thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize);
          var posiSize = PositionAndSize(applyRatio(20.0), yPositionWrapper.value, fontSize, fontSize, fontSize, applyRatio(1.0));
          displayTypingCode(searchingZiIndex, posiSize);
        }
      }
    }

    yPositionWrapper.value += applyRatio(30.0);

    yPositionWrapper.value += applyRatio(20.0);
    if (!isInfoOnly) {
      drawLine(lessonLeftEdge + applyRatio(20.0), yPositionWrapper.value, applyRatio(600.0),
          yPositionWrapper.value, Colors.grey, applyRatio(1));
    }
  }

  displayOneZiHelper(int id, String type, double transX, PrimitiveWrapper yPositionWrapper, bool isInfoOnly, List<SpeechIconInfo> listOfSpeechIconInfo) {
    var name;
    var pinyin;
    var meaning;

    var comp = ComponentManager.getComponent(id);
    if (!isInfoOnly) {
      drawRootZi(
          id,
          ZiListType.component,
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
      name = comp!.charOrNameOfNonchar;
      pinyin = comp!.pinyin;
      meaning = comp!.meaning;
    }
    transX +=
    (thePositionManager.getCharFontSize(ZiOrCharSize.assembleDissembleSize) +
        applyRatio(10.0));

    yPositionWrapper.value += applyRatio(50.0); //35.0

    // display name
    if (!isInfoOnly) {
      displayTextWithValue(
          getString(385) /*"Name"*/ + ": ", applyRatio(20.0),
          yPositionWrapper.value,
          thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize),
          Colors.black, false);
      displayTextWithValue(
          name, applyRatio(20.0 + 160.0), yPositionWrapper.value,  // 20 + 90
          thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize),
          Colors.blue, false);
      checkAndUpdateYPosi(yPositionWrapper, "Name: ", meaning, applyRatio(8.0),
        thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize));
    }

    transX = applyRatio(20.0);
    yPositionWrapper.value += applyRatio(33.0);
    if (!isInfoOnly) {
      displayTextWithValue(getString(85)/*"Sound"*/ + ": ", transX, yPositionWrapper.value,
          thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize),
          Colors.black, false);
    }

    transX += applyRatio(160.0); //60
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
          Colors.blue, false);
      transX += (8.0 * pinyin.length + applyRatio(10.0));
    }

    yPositionWrapper.value += applyRatio(30.0);

    // display meaning
    if (!isInfoOnly) {
      displayTextWithValue(
          getString(86) /*"Meaning"*/ + ": ", applyRatio(20.0),
          yPositionWrapper.value,
          thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize),
          Colors.black, false);
      displayTextWithValue(
          meaning, applyRatio(20.0 + 160.0), yPositionWrapper.value, // 20 + 90
          thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize),
          Colors.blue, false);
      checkAndUpdateYPosi(
          yPositionWrapper, "Meaning: ", meaning, applyRatio(8.0),
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