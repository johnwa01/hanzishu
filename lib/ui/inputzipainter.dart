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

class InputZiPainter extends BasePainter {
  static var lessonLeftEdge = xYLength(10.0);

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
    PrimitiveWrapper contentLength; // not used

    displayCandidates();
  }

  displayCandidates() {
    if (theCurrentZiCandidates != null) {
      double x = 0.0;

      for (int i = 0; i < theCurrentZiCandidates.length; i++) {
        displayOneCandidate(theCurrentZiCandidates[i], x, 0.0, 30.0);
        x += (30.0 * theCurrentZiCandidates[i].length + 25.0);
      }
    }
    /*
    displayOneCandidate("好", 0.0, 0.0, 30.0);
    */
  }

  displayOneCandidate(String candidate, double x, double y, double fontSize) {
    displayTextWithValue(candidate, x, y, fontSize, Colors.blue);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
