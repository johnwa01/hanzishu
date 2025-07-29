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
    if (theCurrentZiCandidates != null) {
      double x = 0.0;

      var activeCandidatesLength = min(InputZiManager.maxTypingCandidates, theCurrentZiCandidates.length);

      //if (activeCandidatesLength > InputZiManager.maxTypingCandidates) {  // Temp: for testing, leave 7 for test
      //  activeCandidatesLength = InputZiManager.maxTypingCandidates;
      //}
      var widthSizeRatio = Utility.getSizeRatio(screenWidth);
      for (int i = 0; i < activeCandidatesLength; i++) {
                  displayOneCandidate(theCurrentZiCandidates[i], x, 0.0, 20.0 * widthSizeRatio);
                  //displayTextWithValue((i+1).toString(), x + 30.0 * getSizeRatio(), 5.0 * widthSizeRatio, 12.0 * getSizeRatio(), Colors.black, false);
                  //x += (30.0 * widthSizeRatio * theCurrentZiCandidates[i].length + 18.0 * widthSizeRatio);
                  x += 20.0 * getSizeRatio() * theCurrentZiCandidates[i].length;
                  displayTextWithValue((i+1).toString(), x /*+ 30.0 * getSizeRatio()*/, 5.0 * widthSizeRatio, 12.0 * getSizeRatio(), Colors.black, false);
                  x += (18.0 * widthSizeRatio);
      }

      // note: the 20.0 arrow position calculation is fixed here, not change with candidates' font sizes
      x = (InputZiManager.maxTypingCandidates * (20.0 + 14.0 + 12.0) + 12.0)* getSizeRatio();

      displayTextWithValue('<', x, 0.0, 20.0 * getSizeRatio(), this.lineColor, false);
      x += (20.0 + 14.0) * getSizeRatio();

      displayTextWithValue('>', x, 0.0, 20.0 * getSizeRatio(), this.completeColor, false);

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
    var widthSizeRatio = Utility.getSizeRatio(screenWidth);
    var chars = candidate.characters;
    //for (int i = 0; i < chars.length; i++) {
    int i = 0;
    for (var char in chars) {
      displayTextWithValue(char, x + i * 20.0 * getSizeRatio(), y, fontSize, Colors.blue, false);
      i++;
    }
  }

  //displayOneCandidate(String candidate, double x, double y, double fontSize) {
  //  displayTextWithValue(candidate, x, y, fontSize, Colors.blue, false);
  //}

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
