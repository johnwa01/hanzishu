import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/engine/inputzimanager.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/utility.dart';

class InputZiPainter extends BasePainter {
  static var lessonLeftEdge;

  int breakoutIndex = -1;

  late Color lineColor;
  late Color completeColor;
  int lessonId = -1;
  double screenWidth = 0.0;

  late var breakoutPositions;
  late bool isBreakoutPositionsOnly;

  InputZiPainter({
    required this.lineColor, required this.completeColor, required this.lessonId, required this.screenWidth
  });

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;
    this.width = screenWidth;  // set the base class width variable
    isBreakoutPositionsOnly = false;
    lessonLeftEdge = 10.0 * getSizeRatio();
    displayCandidates();
  }

  displayCandidates() {
    if (theCurrentZiCandidates != null && theCurrentZiCandidates.length != 0) {
      double x = InputZiManager.getBeginningLength(); // 0.0

      var activeCandidatesLength = min(InputZiManager.maxTypingCandidates, theCurrentZiCandidates.length);

      //if (activeCandidatesLength > InputZiManager.maxTypingCandidates) {  // Temp: for testing, leave 7 for test
      //  activeCandidatesLength = InputZiManager.maxTypingCandidates;
      //}
      var widthSizeRatio = Utility.getSizeRatio(screenWidth);
      for (int i = 0; i < activeCandidatesLength; i++) {
                  x = displayOneCandidate(theCurrentZiCandidates[i], x, 0.0, 0.0 * widthSizeRatio);
                  //displayTextWithValue((i+1).toString(), x + 30.0 * getSizeRatio(), 5.0 * widthSizeRatio, 12.0 * getSizeRatio(), Colors.black, false);
                  //x += (30.0 * widthSizeRatio * theCurrentZiCandidates[i].length + 18.0 * widthSizeRatio);
                  ///x += 20.0 * getSizeRatio() * theCurrentZiCandidates[i].length;
                  displayTextWithValue((i+1).toString(), x /*+ 30.0 * getSizeRatio()*/, 5.0 * widthSizeRatio, 12.0 * getSizeRatio(), Colors.black, false);
                  x += (InputZiManager.getCandidateIndexLength() * widthSizeRatio); // 18.0
      }

      // note: the 20.0 arrow position calculation is fixed here, not change with candidates' font sizes
      x = InputZiManager.getCandidateLeftArrowXPosition() * getSizeRatio();

      //var temp = InputZiManager.getMaxTotalCandidateLength() * getSizeRatio();
      // Y 5.0 to make arrow move down to bit to be in center
      displayTextWithValue('<', x, 4.0 * getSizeRatio(), 20.0 * getSizeRatio(), this.lineColor, false);
      x = InputZiManager.getCandidateRightArrowXPosition() * getSizeRatio(); // 20.0 + 14.0

      displayTextWithValue('>', x, 4.0 * getSizeRatio(), 20.0 * getSizeRatio(), this.completeColor, false);

      /* Temp: for testing component stroke drawing only
      if (globalTestDoubleByteCode.length == 2) {
        if (ComponentManager.getComponentByCode(globalTestDoubleByteCode) != null) {
          drawComponentZi(
              globalTestDoubleByteCode,
              x,
              0.0,
              60.0,
              60.0,
              60.0, /*posiSize.transX, posiSize.transY, posiSize.width, posiSize.height, posiSize.charFontSize,*/
              this.lineColor /*ziColor*/, /*isSingleColor:*/
              true,
              60.0 * 0.05);
        }
      }
      //Note: to test 31 strokes
      if (globalTestDoubleByteCode.length == 1) {
        if (StrokeManager.getStrokeByCode(globalTestDoubleByteCode) != null) {
          drawStrokeZi(
              globalTestDoubleByteCode,
              x,
              0.0,
              60.0,
              60.0,
              60.0, /*posiSize.transX, posiSize.transY, posiSize.width, posiSize.height, posiSize.charFontSize,*/
              this.lineColor /*ziColor*/, /*isSingleColor:*/
              true,
              60.0 * 0.05);
        }
      }
      */
    }
  }

  double displayOneCandidate(String candidate, double x, double y, double fontSize) {
    //var widthSizeRatio = Utility.getSizeRatio(screenWidth);
    String chars = candidate; //.toUpperCase();
    double size = 0.0;
    //double updatedY;
    double updatedX = x;

    int spacePosi = chars.indexOf(' ');
    String realCandidate;
    String typingCode = "";
    if (spacePosi < 0) {
      realCandidate = chars;
    }
    else {
      realCandidate = chars.substring(0, spacePosi);
      int len = chars.length - spacePosi - 1;
      if (len > 4 ) {
        len = 4;
      }
      typingCode = chars.substring(spacePosi + 1, spacePosi + 1 + len);
    }

    size = InputZiManager.getCandidateHanziLength();
    size *= getSizeRatio();
    for (var char in realCandidate.characters) {
      displayTextWithValue(
          char, updatedX, y, size, Colors.blue, false);
      updatedX += size;
    }
    if (spacePosi >= 0) {
      displayTextWithValue(
            typingCode.toUpperCase(), x, y + 35.0 * getSizeRatio(), size/2,
            Colors.blue, false);
    }

    return updatedX;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
