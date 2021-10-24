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
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/utility.dart';


class InputZiComponentPainter extends BasePainter {
  static var lessonLeftEdge = xYLength(10.0);

  int breakoutIndex;

  Color lineColor;
  Color completeColor;
  int currentIndex; //lessonId;  //TODO: zi index
  double screenWidth;
  TypingType typingType;

  var breakoutPositions;
  bool isBreakoutPositionsOnly;

  InputZiComponentPainter({
    this.lineColor, this.completeColor, this.currentIndex, this.screenWidth, this.typingType
  });

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;
    this.width = screenWidth;  // set the base class width variable
    isBreakoutPositionsOnly = false;
    PrimitiveWrapper contentLength; // not used

    displayComponents(size);
  }

  displayComponents(Size size) {
    String instruction;
    if (typingType == TypingType.ThreeOrMoreComponents) {
      instruction = "Type the given character. Input the components of the character in sequence through keyboard.";
    }
    else if (typingType == TypingType.TwoComponents) {
      instruction = "Type the given character. Input its two components first, then the last stroke from the 1st as well as the 2nd component.";
    }
    else if (typingType == TypingType.OneComponent) {
      instruction = "Type the given character. Input its only component first, then up to 3 strokes: 1st, 2nd, and last stroke.";
    }

    double x = 5.0;
    double y = 0.0;
    displayTextWithValue(instruction, x, y, 20.0, Colors.blue);

    var zi = theInputZiManager.getZiWithComponentsAndStrokes(typingType, currentIndex);
    var length = zi.componentCodes.length;

    y += 100.0;
    String text = "Please type: ";

    displayTextWithValue(text, x, y, 20.0, Colors.blue);
    x += 110.0;
    text = zi.zi;
    displayTextWithValue(text, x, y - 25.0, 40.0, Colors.blue);
    x += 55.0;
    displayTextWithValue(". Hint: ", x, y, 20.0, Colors.blue);
    x += 60.0;

    for (int i = 0; i < length; i++) {
      displayOneComponent(zi.componentCodes[i], x, y, size, 30.0);
      x += 30.0;
    }

    y += 15.0;
    //displayTextWithValue("Note:" + zi.comment, 5.0, y, 20.0, Colors.blue);
  }

  displayOneComponent(String componentCode, double x, double y, Size size, double fontSize) {
    var componentId = theComponentManager.getComponentIdByCode(componentCode);
    drawComponentZi(componentId, x, y, 20.0, 30.0, 30.0, /*posiSize.transX, posiSize.transY, posiSize.width, posiSize.height, posiSize.charFontSize,*/ Colors.blue /*ziColor*/, /*isSingleColor:*/ true, 2.5);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
