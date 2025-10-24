import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';
import 'package:hanzishu/engine/componentmanager.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/engine/inputzimanager.dart';
import 'package:hanzishu/data/componenttypinglist.dart';
import 'package:hanzishu/utility.dart';


class InputZiHintPainter extends BasePainter {
  late Color lineColor;
  late Color completeColor;
  double screenWidth = 0.0;
  HintType showHint = HintType.None;
  int selectedCompIndex = -1;
  String char = '';
  late TypingType typingType;
  int ziIndex = -1;

  InputZiHintPainter({
    required this.lineColor, required this.completeColor, required this.screenWidth, required this.showHint, required this.selectedCompIndex, /*this.selectedCategoryIndex, this.selectedSubcategoryIndex,*/ required this.char, required this.typingType, required this.ziIndex
  });

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;
    this.width = screenWidth; // set the base class width variable

    if (showHint == HintType.Hint1 || showHint == HintType.Hint2 || showHint == HintType.Hint3) {
      // Need to match the inputzipage's prompt string
      displayHintMessage(13.0 * 1.2 * getSizeRatio(), char, ziIndex);  // 18.0
    }
    else {
      //TODO: displayShiftKeyNote();
    }
  }

  displayShiftKeyNote() {
    String note;

    if (typingType == TypingType.LeadComponents) {
      note = getString(281)/*"Note: Type uppercase letter Z to show components to keyboard mapping."*/;
    }
    else {
      note = getString(282)/*"Note: Type uppercase letter A to Y to show Expanded Components. Type Z to show mapping."*/;
    }

    displayTextWithValue(note, 10.0, 0.0, 15.0 * getSizeRatio(), Colors.blue, false); // 18.0
  }

  displayHintMessage(double fontSize, String char, int ziIndex) {
    List<String> typingComponentsAndSubComp = [];
    if (char == "从前") { // two special phrase examples
      typingComponentsAndSubComp = ["Ha", "Ha", "Mb", "Im"];
    }
    else if (char == "中国人") {
      typingComponentsAndSubComp = ["Jd", "Ja", "Ha"];
    }
    else if (char == "淇") {
      typingComponentsAndSubComp = ["Mi", "Wh", "Fa"];
    }
    else {
      typingComponentsAndSubComp = ComponentManager
          .getTypingComponentsAndSubComp(char);
    }

    double size = 24 * getSizeRatio(); //14.4
    if (showHint == HintType.Hint2) {
      size = 20 * getSizeRatio(); //14.4
    }
    double halfSize = size/1.2;
    double xPosi = 8.0 * getSizeRatio(); //10.0

    if (showHint == HintType.Hint3) {
      xPosi += size * 1.7; // one time deal
    }

    xPosi += fontSize * 1.8 * ziIndex; // 2.0 in inputzipage?

    if (typingComponentsAndSubComp.isEmpty) {
      // "Note: hint unavailable
      displayTextWithValue(getString(527), xPosi, 0.0, size / 1.3, Colors.blue, false);
      return;
    }

    // non-existin char in searchingzilist
    if (typingComponentsAndSubComp.length == 0) {
      if (showHint == HintType.Hint3 || showHint == HintType.Hint2 || showHint == HintType.Hint1) {
        // fine the code from inputzilist
        var code = InputZiManager.getInputCodeByCharFromInputList(char);
        displayTextWithValue(code.toUpperCase(), xPosi, 0.0, size, Colors.blue, false);
      }
      return;
    }

    var compColor;

    for (int i = 0; i < typingComponentsAndSubComp.length; i++) {
      compColor = Colors.blue;
      if (selectedCompIndex == (i + 1)) {
        compColor = Colors.orange; //Colors.purple;
      }

      if (i != 0) {
        xPosi += halfSize / 1.5;
      }

      var comp = typingComponentsAndSubComp[i];
      if (showHint != HintType.Hint3) {
        drawComponentZi(
            comp,
            xPosi,
            0.0,
            size,
            size,
            size,
            compColor,
            true,
            1);
        xPosi += size * 1.2;
      }


      if (showHint == HintType.Hint2) {
        displayTextWithValue('(', xPosi, 0.0, size, compColor, false);
        xPosi += halfSize / 1.5;
        var typingCode = ComponentManager.getTypingCode(comp);
        displayTextWithValue(
            typingCode!.toUpperCase(), xPosi, 0.0, size, compColor, false);

        xPosi += size; //* 1.2;
        displayTextWithValue(')', xPosi, 0.0, size, compColor, false);
        //xPosi += halfSize / 1.5;
      }
      if (showHint == HintType.Hint3) {
        //displayTextWithValue('(', xPosi, 0.0, size, compColor, false);
        //xPosi += halfSize / 1.5;
        var typingCode = ComponentManager.getTypingCode(comp);
        displayTextWithValue(
            typingCode!.toUpperCase(), xPosi, 0.0, size, compColor, false);

        xPosi += halfSize / 4; //* 1.2;
        //displayTextWithValue(')', xPosi, 0.0, size, compColor, false);
        //xPosi += halfSize / 1.5;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}