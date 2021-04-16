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
    //this.width = size.width;
    isBreakoutPositionsOnly = false;
    displayAllZi(lessonId);
  }

  displayAllZi(int lessonId) {
    var lesson = theLessonList[lessonId];

    var yPositionWrapper = PrimitiveWrapper(xYLength(100.0));  //170.0

    for (int charId in lesson.charsIds) {
      var zi = theZiManager.getZi(charId);
      if (theZiManager.containSameSubType(zi.type, CharType.BasicChar)) {
        displayOneZi(yPositionWrapper, charId, CharType.BasicChar);
      }
    }

    for (int charId in lesson.convCharsIds) {
      var zi = theZiManager.getZi(charId);
      if (theZiManager.containSameSubType(zi.type, CharType.BasicChar)) {
        displayOneZi(yPositionWrapper, charId, CharType.BasicChar);
      }
    }

    for (int charId in lesson.comps) {
      displayOneZi(yPositionWrapper, charId, CharType.BasicNonchar);
    }

    for (int charId in lesson.charsIds) {
      var zi = theZiManager.getZi(charId);
      if (theZiManager.containSameSubType(zi.type, CharType.CompositChar)) {
        displayOneZi(yPositionWrapper, charId, CharType.CompositChar);
      }
    }

    for (int charId in lesson.convCharsIds) {
      var zi = theZiManager.getZi(charId);
      if (theZiManager.containSameSubType(zi.type, CharType.CompositChar)) {
        displayOneZi(yPositionWrapper, charId, CharType.CompositChar);
      }
    }

    for (int phraseId in lesson.phraseIds) {
      displayOneZi(yPositionWrapper, phraseId, CharType.Phrase);
    }

  }

  displayOneZi(PrimitiveWrapper yPositionWrapper, int id, String type) {
    displayOneZiHelper(id, type, lessonLeftEdge, yPositionWrapper.value);

    yPositionWrapper.value += xYLength(30.0);
    yPositionWrapper.value = LessonManager.getNextYPosition(yPositionWrapper.value);
  }

  displayOneZiHelper(int id, String type, double transX, double transY) {
    var pinyin;
    var meaning;

    if (type == CharType.Phrase) {
      displayTextWithValue(thePhraseList[id].chars, transX, transY, thePositionManager.getCharFontSize(ZiOrCharSize.assembleDissembleSize), Colors.blue);
//      pinyin = "[" + thePhraseList[id].pinyin + "]";
//      meaning = thePhraseList[id].meaning;
//      transX += thePhraseList[id].chars.length * 40.0;
    }
    else {
      drawRootZi(
          id,
          transX,
          transY,
          thePositionManager.getZiSize(ZiOrCharSize.assembleDissembleSize),
          thePositionManager.getZiSize(ZiOrCharSize.assembleDissembleSize),
          thePositionManager.getCharFontSize(ZiOrCharSize.assembleDissembleSize),
          Colors.brown, /*isSingleColor:*/
          false,
          thePositionManager.getZiLineWidth(ZiOrCharSize.assembleDissembleSize), /*createFrame:*/
          true,
          /*hasRootZiLearned:*/
          false,
          false,
          Colors.blue,
          true);
//      pinyin = "[" + theZiList[id].pinyin + "]";
//      meaning = theZiList[id].meaning;
//      transX += 40.0;
    }

    // display speech icon

    // display pinyin
    //displayTextWithValue(pinyin, transX, transY, thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize), Colors.blue);
    //transX += pinyin.length * 20.0 + 10.0;

    // display meaning
    //displayTextWithValue(meaning, transX, transY, thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize), Colors.blue);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}