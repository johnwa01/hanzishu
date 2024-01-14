import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';
import 'package:hanzishu/engine/componentmanager.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/utility.dart';


class InputZiHintPainter extends BasePainter {
  Color lineColor;
  Color completeColor;
  double screenWidth;
  bool showHint;
  bool showFullHint;
  String char;
  TypingType typingType;

  InputZiHintPainter({
    this.lineColor, this.completeColor, this.screenWidth, this.showHint, this.showFullHint, this.char, this.typingType
  });

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;
    this.width = screenWidth; // set the base class width variable

    if (showHint || showFullHint) {
      displayHintMessage(15.0 * getSizeRatio(), char);  // 18.0
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

  /*
  displayHintMessage_old(double fontSize, String char) {
    var searchingZiId = DictionaryManager.getSearchingZiId(char);
    List<String> components = List<String>();
    DictionaryManager.getAllComponents(searchingZiId, components);

    double size = 18.0;
    double xPosi = 10.0;

    drawComponentZiList(
        components,
        xPosi,
        0.0,
        size,
        size,
        size,
        Colors.cyan,
        true,
        1);

    xPosi += size * components.length;

    var typingStrokes = "";
    if (components.length < 3) {
      displayTextWithValue(" (", xPosi, 0.0, size, Colors.cyan);
      xPosi += size;
      typingStrokes = DictionaryManager.getAllTypingStrokes(components);
      drawStrokeZiList(
          typingStrokes,
          xPosi,
          0.0,
          size,
          size,
          size,
          Colors.cyan,
          true,
          1.0);
      xPosi += size * 1.3 * typingStrokes.length;
      displayTextWithValue(") ", xPosi, 0.0, size, Colors.cyan);
      xPosi += size;
    }

    displayTextWithValue(" -> ", xPosi, 0.0, size, Colors.cyan);
    xPosi += size * 1.5;

    var leadComps = DictionaryManager.getAllLeadComponents(components);
    var leadTypingStrokes = "";
    if (leadComps.length < 3) {
      leadTypingStrokes = DictionaryManager.getLeadTypingStrokes(typingStrokes);
    }

    if (!DictionaryManager.isSameComps(components, leadComps) || !DictionaryManager.isSameStrokes(typingStrokes, leadTypingStrokes)) {
      drawComponentZiList(
          leadComps,
          xPosi,
          0.0,
          size,
          size,
          size,
          Colors.cyan,
          true,
          1);

      xPosi += size * leadComps.length;

      if (leadComps.length < 3) {
        displayTextWithValue(" (", xPosi, 0.0, size, Colors.cyan);
        xPosi += size;
        drawStrokeZiList(
            leadTypingStrokes,
            xPosi,
            0.0,
            size,
            size,
            size,
            Colors.cyan,
            true,
            1.0);
        xPosi += size * 1.3 * leadTypingStrokes.length;
        displayTextWithValue(") ", xPosi, 0.0, size, Colors.cyan);
        xPosi += size;
      }

      displayTextWithValue(" -> ", xPosi, 0.0, size, Colors.cyan);
      xPosi += size * 1.5;
    }

    var compCodes= DictionaryManager.getAllComponentCodes(leadComps);
    var strokeCodes = DictionaryManager.getStrokeTypingCodes(leadTypingStrokes);
    var typingCodes = DictionaryManager.getOneTypingCode(compCodes, strokeCodes);
    displayTextWithValue(typingCodes, xPosi, 0.0, size, Colors.cyan);
  }
*/

  displayHintMessage(double fontSize, String char) {
    var searchingZiId = DictionaryManager.getSearchingZiId(char);
    List<String> components = List<String>();
    DictionaryManager.getAllComponents(searchingZiId, components);

    var subComponents;
    if (components.length < 3) {
      subComponents = ComponentManager.getSubComponents(components);
    }

    double size = 24 * getSizeRatio(); //14.4
    if (showFullHint == true) {
      size = 20 * getSizeRatio(); //14.4
    }
    double halfSize = size/1.2;
    double xPosi = 8.0; //10.0

    for (int i = 0; i < components.length; i++) {
      if (i != 0) {
        xPosi += halfSize / 1.5;
      //  displayTextWithValue(',', xPosi, 0.0, size, Colors.blue);
      //  xPosi += halfSize / 1.5;
      }

      var comp = components[i];
      drawComponentZi(comp, xPosi, 0.0, size, size, size, Colors.blue, true, 1);

      xPosi += size * 1.2;
      if (showFullHint) {
        displayTextWithValue('(', xPosi, 0.0, size, Colors.blue, false);
        xPosi += halfSize / 1.5;
        var typingCode = ComponentManager.getTypingCode(comp);
        displayTextWithValue(
            typingCode.toUpperCase(), xPosi, 0.0, size, Colors.blue, false);

        xPosi += size; //* 1.2;
        displayTextWithValue(')', xPosi, 0.0, size, Colors.blue, false);
        //xPosi += halfSize / 1.5;
      }
    }

    if (subComponents != null) {
      for (int i = 0; i < subComponents.length; i++) {

          xPosi += halfSize / 1.3;
          //displayTextWithValue(',', xPosi, 0.0, size, Colors.blue);
          //xPosi += halfSize;

        var comp = subComponents[i];
        drawComponentZi(
            comp,
            xPosi,
            0.0,
            size,
            size,
            size,
            Colors.blue,
            true,
            1);

        xPosi += size * 1.2;
        if (showFullHint) {
          displayTextWithValue('(', xPosi, 0.0, size, Colors.blue, false);
          xPosi += halfSize / 1.5;
          var typingCode = ComponentManager.getTypingCode(comp);

          displayTextWithValue(
              typingCode.toUpperCase(), xPosi, 0.0, size, Colors.blue, false);
          xPosi += size;
          displayTextWithValue(')', xPosi, 0.0, size, Colors.blue, false);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}