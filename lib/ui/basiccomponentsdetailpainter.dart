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

    if (sizeRatio > 1.25) {
      sizeRatio = 1.25;
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
      displayTextWithValue("'" + groupLetter + "' " + getString(386) + ":", lessonLeftEdge, yPositionWrapper.value,
          applyRatio(28.0), Colors.brown, false);
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
    var comp = ComponentManager.getComponent(id);
    if (comp == null) {
      return;
    }

    var cardLeft = applyRatio(20.0);
    var cardTop = yPositionWrapper.value + applyRatio(12.0);
    var cardWidth = screenWidth - applyRatio(40.0);
    var cardHeight = applyRatio(190.0);

    var rootSize = thePositionManager.getZiSize(ZiOrCharSize.assembleDissembleSize);
    var rootFontSize = thePositionManager.getCharFontSize(ZiOrCharSize.assembleDissembleSize);
    var labelFontSize = applyRatio(17.0);
    var valueFontSize = applyRatio(18.0);
    var smallValueFontSize = applyRatio(17.0);

    var rootX = cardLeft + applyRatio(18.0);
    var rootY = cardTop + applyRatio(18.0);
    var labelX = cardLeft + applyRatio(112.0);
    var valueX = cardLeft + applyRatio(205.0);
    var row1Y = cardTop + applyRatio(24.0);
    var row2Y = cardTop + applyRatio(54.0);
    var row3Y = cardTop + applyRatio(84.0);
    var row4Y = cardTop + applyRatio(114.0);
    var row5Y = cardTop + applyRatio(144.0);

    var speechX = valueX;
    var speechY = row2Y;

    if (!isInfoOnly) {
      final rect = Rect.fromLTWH(cardLeft, cardTop, cardWidth, cardHeight);
      final rrect = RRect.fromRectAndRadius(rect, Radius.circular(applyRatio(16.0)));
      final fillPaint = Paint()..color = Colors.white.withOpacity(0.86);
      final borderPaint = Paint()
        ..color = Colors.black.withOpacity(0.08)
        ..style = PaintingStyle.stroke
        ..strokeWidth = applyRatio(1.0);
      canvas!.drawRRect(rrect, fillPaint);
      canvas!.drawRRect(rrect, borderPaint);

      drawRootZi(
          id,
          ZiListType.component,
          rootX,
          rootY,
          rootSize,
          rootSize,
          rootFontSize,
          Colors.brown,
          false,
          thePositionManager.getZiLineWidth(ZiOrCharSize.assembleDissembleSize),
          true,
          false,
          false,
          Colors.blue,
          true);

      displayTextWithValue(getString(385) /*"Name"*/ + ":", labelX, row1Y,
          labelFontSize, Colors.black87, false);
      displayTextWithValue(comp.charOrNameOfNonchar, valueX, row1Y,
          valueFontSize, Colors.blue, false);


      displayTextWithValue(getString(85) /*"Sound"*/ + ":", labelX, row2Y,
          labelFontSize, Colors.black87, false);

      DisplayIcon(
          iconSpeechStrokes,
          speechX,
          speechY,
          labelFontSize,
          labelFontSize,
          Colors.amber,
          applyRatio(2.0));

      displayTextWithValue(comp.pinyin, speechX + applyRatio(34.0), row2Y,
          smallValueFontSize, Colors.blue, false);

      displayTextWithValue(getString(86) /*"Meaning"*/ + ":", labelX, row3Y,
          labelFontSize, Colors.black87, false);
      displayTextWithValue(comp.meaning, valueX, row3Y,
          valueFontSize, Colors.blue, false);

      var strokePosiSize = PositionAndSize(
          labelX,
          row4Y,
          valueFontSize,
          valueFontSize,
          valueFontSize,
          applyRatio(1.0));

      displayCompStrokes(id, ZiListType.component, strokePosiSize, applyRatio(1.0));
      //var row4Y = cardTop + applyRatio(122.0);

      if (comp.isChar) {
        var searchingZiIndex =
        DictionaryManager.getSearchingZiId(comp.charOrNameOfNonchar);

        if (searchingZiIndex > 0) {
          var codePosiSize = PositionAndSize(
              labelX,
              row5Y,
              valueFontSize,
              valueFontSize,
              valueFontSize,
              applyRatio(1.0));

          displayTypingCode(searchingZiIndex, codePosiSize);
        }
      }
    }
    else {
      listOfSpeechIconInfo.add(
          SpeechIconInfo(ZiListType.component, id, speechX, speechY));
    }

    yPositionWrapper.value = cardTop + cardHeight;
  }

  displayOneZiHelper(int id, String type, double transX, PrimitiveWrapper yPositionWrapper, bool isInfoOnly, List<SpeechIconInfo> listOfSpeechIconInfo) {
    // Kept for compatibility with older callers. The compact card layout is now
    // handled directly in displayOneZi().
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