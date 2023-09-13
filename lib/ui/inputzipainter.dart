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

  int breakoutIndex;

  Color lineColor;
  Color completeColor;
  int lessonId;
  double screenWidth;

  var breakoutPositions;
  bool isBreakoutPositionsOnly;

  InputZiPainter({
    this.lineColor, this.completeColor, this.lessonId, this.screenWidth
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
    if (theCurrentZiCandidates != null) {
      double x = 0.0;

      var activeCandidatesLength = min(InputZiManager.maxTypingCandidates, theCurrentZiCandidates.length);

      if (activeCandidatesLength > 7) {  // Temp: for testing, leave 7 for test
        activeCandidatesLength = 7;
      }
      var widthSizeRatio = Utility.getSizeRatio(screenWidth);
      for (int i = 0; i < activeCandidatesLength; i++) {
           displayOneCandidate(theCurrentZiCandidates[i], x, 0.0, 30.0 * widthSizeRatio);
           displayTextWithValue((i+1).toString(), x + 30.0 * getSizeRatio(), 5.0 * widthSizeRatio, 12.0 * getSizeRatio(), Colors.black);
           x += (30.0 * widthSizeRatio * theCurrentZiCandidates[i].length + 23.0 * widthSizeRatio);
      }

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

  displayOneCandidate(String candidate, double x, double y, double fontSize) {
    displayTextWithValue(candidate, x, y, fontSize, Colors.blue);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
