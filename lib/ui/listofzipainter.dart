import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import 'package:hanzishu/engine/lesson.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/data/phraselist.dart';
import 'package:hanzishu/data/zilist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/generalmanager.dart';
import 'package:hanzishu/engine/lessonmanager.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/utility.dart';

class SpeechIconInfo {
  bool isPhrase;
  int id;
  double xPosi;
  double yPosi;
  SpeechIconInfo(isPhrase, int id, double xPosi, double yPosi) {
    this.isPhrase = isPhrase;
    this.id = id;
    this.xPosi = xPosi;
    this.yPosi = yPosi;
  }
}

class ListOfZiPainter extends BasePainter {
  static var lessonLeftEdge = xYLength(10.0);

  int breakoutIndex;

  Color lineColor;
  Color completeColor;
  int lessonId;
  double screenWidth;

  var breakoutPositions;
  bool isBreakoutPositionsOnly;

  ListOfZiPainter({
    this.lineColor, this.completeColor, this.lessonId, this.screenWidth
  });

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;
    this.width = screenWidth;  // set the base class width variable
    isBreakoutPositionsOnly = false;
    displayAllZi(lessonId, false, null);
  }

  displayAllZi(int lessonId, bool isInfoOnly, List<SpeechIconInfo> listOfSpeechIconInfo) {
    var lesson = theLessonList[lessonId];
    int length = 0;
    var yPositionWrapper = PrimitiveWrapper(xYLength(0.0));  //170.0

    length = lesson.charsIds.length;
    if (length > 0) {
      yPositionWrapper.value += xYLength(20.0);
      if (!isInfoOnly) {
        displayTextWithValue("Basic Zi", lessonLeftEdge, yPositionWrapper.value,
            thePositionManager.getCharFontSize(
                ZiOrCharSize.defaultSize), Colors.blue);
      }
      yPositionWrapper.value += (thePositionManager.getCharFontSize(
          ZiOrCharSize.defaultSize) + 15.0);

      for (int charId in lesson.charsIds) {
        var zi = theZiManager.getZi(charId);
        if (theZiManager.containSameSubType(zi.type, CharType.BasicChar)) {
          displayOneZi(yPositionWrapper, charId, CharType.BasicChar, isInfoOnly, listOfSpeechIconInfo);
        }
      }

      if (lesson.convCharsIds.length == 0 && !isInfoOnly) {
        drawLine(0.0, yPositionWrapper.value, xYLength(600.0),
            yPositionWrapper.value, Colors.grey, 1);
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
        drawLine(0.0, yPositionWrapper.value, xYLength(600.0),
            yPositionWrapper.value, Colors.grey, 1);
      }
    }

    length = lesson.comps.length;
    if (length > 0) {
      yPositionWrapper.value += xYLength(20.0);
      if (!isInfoOnly) {
        displayTextWithValue(
            "Basic Non-zi", lessonLeftEdge, yPositionWrapper.value,
            thePositionManager.getCharFontSize(
                ZiOrCharSize.defaultSize), Colors.blue);
      }
      yPositionWrapper.value += (thePositionManager.getCharFontSize(
          ZiOrCharSize.defaultSize) + 15.0);

      for (int charId in lesson.comps) {
        displayOneZi(yPositionWrapper, charId, CharType.BasicNonchar, isInfoOnly, listOfSpeechIconInfo);
      }

      if (!isInfoOnly) {
        drawLine(0.0, yPositionWrapper.value, xYLength(600.0),
            yPositionWrapper.value, Colors.grey, 1);
      }
    }

    length = lesson.charsIds.length;
    if (length > 0) {
      yPositionWrapper.value += xYLength(20.0);
      if (!isInfoOnly) {
        displayTextWithValue(
            "Zi", lessonLeftEdge, yPositionWrapper.value,
            thePositionManager.getCharFontSize(
                ZiOrCharSize.defaultSize), Colors.blue);
      }
      yPositionWrapper.value += (thePositionManager.getCharFontSize(
          ZiOrCharSize.defaultSize) + 15.0);
      double xLineStarting = lessonLeftEdge + 20.0;

      for (int charId in lesson.charsIds) {
        var zi = theZiManager.getZi(charId);
        if (theZiManager.containSameSubType(zi.type, CharType.CompositChar)) {
          displayOneZi(yPositionWrapper, charId, CharType.CompositChar, isInfoOnly, listOfSpeechIconInfo);
        }
      }

      if (lesson.convCharsIds.length == 0 && !isInfoOnly) {
        drawLine(0.0, yPositionWrapper.value, xYLength(600.0),
            yPositionWrapper.value, Colors.grey, 1);
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
        drawLine(0.0, yPositionWrapper.value, xYLength(600.0),
            yPositionWrapper.value, Colors.grey, 1);
      }
    }

    length = lesson.phraseIds.length;
    if (length > 0) {
      yPositionWrapper.value += xYLength(20.0);
      if (!isInfoOnly) {
        displayTextWithValue(
            "Zi Groups", lessonLeftEdge, yPositionWrapper.value,
            thePositionManager.getCharFontSize(
                ZiOrCharSize.defaultSize), Colors.blue);
      }
      yPositionWrapper.value += (thePositionManager.getCharFontSize(
          ZiOrCharSize.defaultSize) + 15.0);

      for (int phraseId in lesson.phraseIds) {
        displayOneZi(yPositionWrapper, phraseId, CharType.Phrase, isInfoOnly, listOfSpeechIconInfo);
      }

      if (!isInfoOnly) {
        drawLine(0.0, yPositionWrapper.value, xYLength(600.0),
            yPositionWrapper.value, Colors.grey, 1);
      }
    }
  }

  displayOneZi(PrimitiveWrapper yPositionWrapper, int id, String type, bool isInfoOnly, List<SpeechIconInfo> listOfSpeechIconInfo) {
    yPositionWrapper.value += xYLength(20.0);
    displayOneZiHelper(id, type, lessonLeftEdge + 20.0, yPositionWrapper.value, isInfoOnly, listOfSpeechIconInfo);
    yPositionWrapper.value += xYLength(50.0);

    var posi = PositionAndSize(lessonLeftEdge + 20.0, yPositionWrapper.value,
        thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize), thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize), 0.0, 1.0);
    if(!isInfoOnly) {
      DisplayHint(id, type == CharType.Phrase, posi);
    }
    yPositionWrapper.value += xYLength(60.0);

    if (!isInfoOnly) {
      drawLine(lessonLeftEdge + 20.0, yPositionWrapper.value, xYLength(600.0),
          yPositionWrapper.value, Colors.grey, 1);
    }
  }

  displayOneZiHelper(int id, String type, double transX, double transY, bool isInfoOnly, List<SpeechIconInfo> listOfSpeechIconInfo) {
    var pinyin;
    var meaning;

    if (type == CharType.Phrase) {
      if (!isInfoOnly) {
        displayTextWithValue(thePhraseList[id].chars, transX, transY - 20.0,
            thePositionManager.getCharFontSize(
                ZiOrCharSize.assembleDissembleSize), Colors.blue);
        pinyin = "[" + thePhraseList[id].getPinyin() + "]";
        meaning = thePhraseList[id].meaning;
      }
      transX += (thePhraseList[id].chars.length * thePositionManager.getCharFontSize(ZiOrCharSize.assembleDissembleSize) + 10.0);
    }
    else {
      if (!isInfoOnly) {
        drawRootZi(
            id,
            transX,
            transY,
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
        pinyin = "[" + theZiList[id].pinyin + "]";
        meaning = theZiList[id].meaning;
      }
      transX += (thePositionManager.getCharFontSize(ZiOrCharSize.assembleDissembleSize) + 10.0);
    }

    // display speech icon
    if (!isInfoOnly) {
      DisplayIcon(iconSpeechStrokes, transX, transY, thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize), thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize), Colors.amber/*MaterialColor ofColor*/, 2.0/*ziLineWidth*/);
    }
    else {
      // save the icon infor.
      var speechIconInfo = SpeechIconInfo(type == CharType.Phrase, id, transX, transY);
      listOfSpeechIconInfo.add(speechIconInfo);
    }
    transX += 30.0;

    // display pinyin
    if (!isInfoOnly) {
      displayTextWithValue(pinyin, transX, transY, thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize), Colors.blue);
      transX += (8.0 * pinyin.length + 10.0);
    }

    // display meaning
    if (!isInfoOnly) {
      displayTextWithValue(meaning, transX, transY, thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize), Colors.blue);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}