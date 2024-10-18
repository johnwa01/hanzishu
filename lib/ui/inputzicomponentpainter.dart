import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/engine/inputzi.dart';

//NOTE: Right now NOT used by InputZiPage.
class InputZiComponentPainter extends BasePainter {
  static var lessonLeftEdge = 10.0;

  int breakoutIndex = -1;

  Color? lineColor;
  late Color completeColor;
  int currentIndex = -1; //lessonId;  //TODO: zi index
  double screenWidth = 0.0;
  late TypingType typingType;

  late var breakoutPositions;
  bool isBreakoutPositionsOnly = false;

  InputZiComponentPainter({
    required this.lineColor, required this.completeColor, required this.currentIndex, required this.screenWidth, required this.typingType
  });

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;
    this.width = screenWidth;  // set the base class width variable
    isBreakoutPositionsOnly = false;

    displayComponents(size);
  }

  displayComponents(Size size) {
    double x = 5.0;
    double y = 0.0;
    /*
    String instruction;
    //if (typingType == TypingType.GiveItATry) {
    //  instruction = "Type the given character. Use hint as needed.";
    //}
    //TODO: do we still need this? No new types listed here.
    if (typingType == TypingType.LeadComponents) {
      instruction = "Type the given character. Use hint as needed.";
    }
    else if (typingType == TypingType.ExpandedComponents) {
      instruction = "Type the given character. Use hint as needed.";
    }

    displayTextWithValue(instruction, x, y, 20.0, Colors.blue);
    */

    var zi = theInputZiManager.getZiWithComponentsAndStrokes(typingType, currentIndex, 0);
    var length = zi.componentCodes.length;

    y += 100.0;
    String text = "Please type: ";

    displayTextWithValue(text, x, y, 20.0, Colors.blue, false);
    x += 110.0;
    text = zi.zi;
    displayTextWithValue(text, x, y - 25.0, 40.0, Colors.blue, false);
    x += 55.0;
    displayTextWithValue(". Hint: ", x, y, 20.0, Colors.blue, false);
    x += 60.0;

    for (int i = 0; i < length; i++) {
      displayOneComponent(zi.componentCodes[i], x, y, size, 30.0);
      x += 30.0;
    }

    y += 15.0;
    //displayTextWithValue("Note:" + zi.comment, 5.0, y, 20.0, Colors.blue);
  }

  displayOneComponent(String componentCode, double x, double y, Size size, double fontSize) {
    var componentId = theComponentManager.getLeadComponentIdByCode(componentCode);
    drawLeadComponentZi(componentId, x, y, 20.0, 30.0, 30.0, /*posiSize.transX, posiSize.transY, posiSize.width, posiSize.height, posiSize.charFontSize,*/ Colors.blue /*ziColor*/, /*isSingleColor:*/ true, 2.5);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
