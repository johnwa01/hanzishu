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

class ListOfZiPainter extends BasePainter {
  var lessonLeftEdge;

  int breakoutIndex = -1;

  late Color lineColor;
  late Color completeColor;
  int lessonId = -1;
  double? screenWidth;

  var breakoutPositions;
  bool? isBreakoutPositionsOnly;

  ListOfZiPainter({
    required this.lineColor, required this.completeColor, required this.lessonId, required this.screenWidth
  });

  double getSizeRatio() {
    var defaultSize = screenWidth! / 16.0; // equivalent to the original hardcoded value of 25.0
    return defaultSize / 25.0;
  }

  double applyRatio(double value) {
    return value * getSizeRatio();
  }

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;
    this.width = screenWidth!;  // set the base class width variable
    isBreakoutPositionsOnly = false;
    PrimitiveWrapper contentLength = PrimitiveWrapper(0.0); // not used
    lessonLeftEdge = applyRatio(10.0);
    displayAllZi(lessonId, false, <SpeechIconInfo>[], contentLength);
  }

  displayAllZi(int lessonId, bool isInfoOnly, List<SpeechIconInfo> listOfSpeechIconInfo, PrimitiveWrapper contentLength) {
    var lesson = theLessonList[lessonId];
    int length = 0;
    var yPositionWrapper = PrimitiveWrapper(0.0);  //170.0
    if (lessonLeftEdge == null) {
      lessonLeftEdge = applyRatio(10.0);
    }
    var defaultFontSize = thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize);

    // for title
    if (lesson.charsIds.length > 0 || lesson.convCharsIds.length > 0) {
      yPositionWrapper.value += applyRatio(20.0);
      if (!isInfoOnly) {
        displayTextWithValue(getString(81)/*"Basic Characters (Components)"*/, lessonLeftEdge, yPositionWrapper.value,
            thePositionManager.getCharFontSize(
                ZiOrCharSize.defaultSize), Colors.brown, false);
      }
      yPositionWrapper.value += (thePositionManager.getCharFontSize(
          ZiOrCharSize.defaultSize) + applyRatio(15.0));
    }

    length = lesson.charsIds.length;
    if (length > 0) {
      for (int charId in lesson.charsIds) {
        var zi = theZiManager.getZi(charId);
        if (theZiManager.containSameSubType(zi.type, CharType.BasicChar)) {
          displayOneZi(yPositionWrapper, charId, CharType.BasicChar, isInfoOnly, listOfSpeechIconInfo);
        }
      }

      if (lesson.convCharsIds.length == 0 && !isInfoOnly) {
        drawLine(0.0, yPositionWrapper.value, applyRatio(600.0),
            yPositionWrapper.value, Colors.grey, applyRatio(1));
      }
    }

    length = lesson.convCharsIds.length;
    if (length > 0) {
      for (int charId in lesson.convCharsIds) {
        var zi = theZiManager.getZi(charId);
        if (theZiManager.containSameSubType(zi.type, CharType.BasicChar)) {
          displayOneZi(yPositionWrapper, charId, CharType.BasicChar, isInfoOnly, listOfSpeechIconInfo);
        }
      }

      if (!isInfoOnly) {
        drawLine(0.0, yPositionWrapper.value, applyRatio(600.0),
            yPositionWrapper.value, Colors.grey, applyRatio(1));
      }
    }

    /*
    length = lesson.comps.length;
    if (length > 0) {
      yPositionWrapper.value += applyRatio(20.0);
      if (!isInfoOnly) {
        displayTextWithValue(
            getString(82)/*"Basic Non-Characters (Components)"*/, lessonLeftEdge, yPositionWrapper.value,
            thePositionManager.getCharFontSize(
                ZiOrCharSize.defaultSize), Colors.brown);  //blue
      }
      yPositionWrapper.value += (thePositionManager.getCharFontSize(
          ZiOrCharSize.defaultSize) + applyRatio(15.0));

      for (int charId in lesson.comps) {
        displayOneZi(yPositionWrapper, charId, CharType.BasicNonchar, isInfoOnly, listOfSpeechIconInfo);
      }

      if (!isInfoOnly) {
        drawLine(0.0, yPositionWrapper.value, applyRatio(600.0),
            yPositionWrapper.value, Colors.grey, applyRatio(1));
      }
    }
    */

    // for title only. could be empty title, but better than mixed with the previous content
    if (lesson.charsIds.length > 0 || lesson.convCharsIds.length > 0) {
      yPositionWrapper.value += applyRatio(20.0);
      if (!isInfoOnly) {
        displayTextWithValue(
            getString(83)/*"Characters"*/, lessonLeftEdge, yPositionWrapper.value,
            thePositionManager.getCharFontSize(
                ZiOrCharSize.defaultSize), Colors.brown, false);
      }
      yPositionWrapper.value += (thePositionManager.getCharFontSize(
          ZiOrCharSize.defaultSize) + applyRatio(15.0));
    }

    length = lesson.charsIds.length;
    if (length > 0) {
      for (int charId in lesson.charsIds) {
        var zi = theZiManager.getZi(charId);
        if (theZiManager.containSameSubType(zi.type, CharType.CompositChar)) {
          displayOneZi(yPositionWrapper, charId, CharType.CompositChar, isInfoOnly, listOfSpeechIconInfo);
        }
      }

      if (lesson.convCharsIds.length == 0 && !isInfoOnly) {
        drawLine(0.0, yPositionWrapper.value, applyRatio(600.0),
            yPositionWrapper.value, Colors.grey, applyRatio(1));
      }
    }

    length = lesson.convCharsIds.length;
    if (length > 0) {
      for (int charId in lesson.convCharsIds) {
        var zi = theZiManager.getZi(charId);
        if (theZiManager.containSameSubType(zi.type, CharType.CompositChar)) {
          displayOneZi(yPositionWrapper, charId, CharType.CompositChar, isInfoOnly, listOfSpeechIconInfo);
        }
      }

      if (!isInfoOnly) {
        drawLine(0.0, yPositionWrapper.value, applyRatio(600.0),
            yPositionWrapper.value, Colors.grey, 1);
      }
    }

    /* Not display them anymore to focus on words
    length = lesson.phraseIds.length;
    if (length > 0) {
      yPositionWrapper.value += applyRatio(20.0);
      if (!isInfoOnly) {
        displayTextWithValue(
            getString(84)/*"Character Groups"*/, lessonLeftEdge, yPositionWrapper.value,
            thePositionManager.getCharFontSize(
                ZiOrCharSize.defaultSize), Colors.brown);
      }
      yPositionWrapper.value += (thePositionManager.getCharFontSize(
          ZiOrCharSize.defaultSize) + applyRatio(15.0));

      for (int phraseId in lesson.phraseIds) {
        displayOneZi(yPositionWrapper, phraseId, CharType.Phrase, isInfoOnly, listOfSpeechIconInfo);
      }

      if (!isInfoOnly) {
        drawLine(0.0, yPositionWrapper.value, applyRatio(600.0),
            yPositionWrapper.value, Colors.grey, applyRatio(1));
      }
    }
    */

    if (theIsFromLessonContinuedSection) {
      /*
      if (!isInfoOnly) {
        displayTextWithValue(
            getString(285) /*"Continue"*/, applyRatio(50.0),
            yPositionWrapper.value,
            defaultFontSize, Colors.white);
        //skip section text
        displayTextWithValue(
            getString(401) /*"Skip section"*/, applyRatio(screenWidth - 100.0),
            applyRatio(10.0),
            defaultFontSize, Colors.white);
      }
      */
      yPositionWrapper.value +=
          defaultFontSize + applyRatio(1) + applyRatio(15);
    }

    if (isInfoOnly) {
      contentLength.value = yPositionWrapper.value;
    }
  }

  displayOneZi(PrimitiveWrapper yPositionWrapper, int id, String type, bool isInfoOnly, List<SpeechIconInfo> listOfSpeechIconInfo) {
    yPositionWrapper.value += applyRatio(20.0);
    displayOneZiHelper(id, type, /*lessonLeftEdge +*/ applyRatio(20.0), yPositionWrapper, isInfoOnly, listOfSpeechIconInfo);

    if (type != CharType.Phrase) {
      yPositionWrapper.value += applyRatio(30.0);

      if (!isInfoOnly) {
        var fontSize = thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize);
        //if (theSearchingZiList[id].isBasicZi()) {
        //  var fontSize = thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize);
        //  var posiSize = PositionAndSize(applyRatio(20.0), yPositionWrapper.value, fontSize, fontSize, fontSize, applyRatio(1.0));
        //  displayCompStrokes(id, ZiListType.zi, posiSize, applyRatio(1.0));
        //}
        //else {
          var searchingZiId = DictionaryManager.getSearchingZiId(
              theSearchingZiList[id].char);
          if (searchingZiId != -1) {
            var posiSize = PositionAndSize(applyRatio(20.0), yPositionWrapper.value, fontSize, fontSize, fontSize, applyRatio(1.0));
            displayFullComponents(searchingZiId, posiSize, applyRatio(1.0), true);
          }
        //}
      }

      if (!theZiManager.getZi(id).isStrokeOrNonChar()) {
        var searchingZiIndex = DictionaryManager.getSearchingZiId(
            theSearchingZiList[id].char);
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
    var posi = PositionAndSize(/*lessonLeftEdge + */ applyRatio(20.0), yPositionWrapper.value,
        thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize), thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize), 0.0, applyRatio(1.0));
    if(!isInfoOnly) {
      DisplayHint(ZiListType.zi, id, type == CharType.Phrase, posi, false);
    }
    yPositionWrapper.value += applyRatio(60.0);

    if (!isInfoOnly) {
      drawLine(lessonLeftEdge + applyRatio(20.0), yPositionWrapper.value, applyRatio(600.0),
          yPositionWrapper.value, Colors.grey, applyRatio(1));
    }
  }

  displayOneZiHelper(int id, String type, double transX, PrimitiveWrapper yPositionWrapper, bool isInfoOnly, List<SpeechIconInfo> listOfSpeechIconInfo) {
    var pinyin;
    var meaning;

    if (type == CharType.Phrase) {
      if (!isInfoOnly) {
        displayTextWithValue(thePhraseList[id].chars, transX,
            yPositionWrapper.value - applyRatio(20.0),
            thePositionManager.getCharFontSize(
                ZiOrCharSize.assembleDissembleSize), Colors.blue, false);
        pinyin = thePhraseList[id].getPinyin();
        meaning = thePhraseList[id].meaning;
      }
      transX += (thePhraseList[id].chars.length *
          thePositionManager.getCharFontSize(
              ZiOrCharSize.assembleDissembleSize) + applyRatio(10.0));
    }
    else {
      if (!isInfoOnly) {
        drawRootZi(
            id,
            ZiListType.zi,
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
        pinyin = theSearchingZiList[id].pinyin;
        meaning = theSearchingZiList[id].meaning;
      }
      transX +=
      (thePositionManager.getCharFontSize(ZiOrCharSize.assembleDissembleSize) +
          applyRatio(10.0));
    }

    transX = applyRatio(20.0);
    yPositionWrapper.value += applyRatio(33.0);
    if (!isInfoOnly) {
      displayTextWithValue(getString(85)/*"Sound"*/ + ": ", transX, yPositionWrapper.value,
          thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize),
          Colors.black, false);
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
          ZiListType.zi, id, transX, yPositionWrapper.value);
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
          getString(86)/*"Meaning"*/ + ": ", applyRatio(20.0), yPositionWrapper.value,
          thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize),
          Colors.black, false);
      displayTextWithValue(
          meaning, applyRatio(20.0 + 90.0), yPositionWrapper.value,
          thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize),
          Colors.blue, false);

      checkAndUpdateYPosi(yPositionWrapper, "Meaning: ", meaning, applyRatio(8.0),
        thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize));
    }
  }

  checkAndUpdateYPosi(PrimitiveWrapper yPositionWrapper, String prefix, String str, double fontWidth, double fontSize) {
    var len = (applyRatio(20.0) + prefix.length * fontWidth + str.length * fontWidth + applyRatio(8.0));
    if (len > screenWidth!) {
      var mul = (len ~/ screenWidth!);
      yPositionWrapper.value += fontSize * mul;
    }
  }

  displayButton(PrimitiveWrapper contentLength) {
    displayTextWithValue(
        '[' + getString(285) /*"Continue"*/ + ']', applyRatio(150.0),
        contentLength.value,
        applyRatio(15.0), Colors.black, false);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}