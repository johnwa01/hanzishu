import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/utility.dart';


class InputZiHintPainter extends BasePainter {
  Color lineColor;
  Color completeColor;
  double screenWidth;
  bool showHint;
  String char;
  TypingType typingType;

  InputZiHintPainter({
    this.lineColor, this.completeColor, this.screenWidth, this.showHint, this.char, this.typingType
  });

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;
    this.width = screenWidth; // set the base class width variable

    if (showHint) {
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

    displayTextWithValue(note, 10.0, 0.0, 15.0 * getSizeRatio(), Colors.blue); // 18.0
  }

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

  displayHintMessage(double fontSize, String char) {
    var searchingZiId = DictionaryManager.getSearchingZiId(char);
    List<String> components = List<String>();
    DictionaryManager.getAllComponents(searchingZiId, components);

    var typingStrokes = "";
    if (components.length < 3) {
      typingStrokes = DictionaryManager.getAllTypingStrokes(components);
    }

    var leadComps = DictionaryManager.getAllLeadComponents(components);
    var leadTypingStrokes = "";
    if (leadComps.length < 3) {
      leadTypingStrokes = DictionaryManager.getLeadTypingStrokes(typingStrokes);
    }

    var compCodes= DictionaryManager.getAllComponentCodes(leadComps);
    var strokeCodes = DictionaryManager.getStrokeTypingCodes(leadTypingStrokes);
    var typingCodes = DictionaryManager.getOneTypingCode(compCodes, strokeCodes);

    double size = 18.0 * getSizeRatio();
    double halfSize = size/1.5;
    double xPosi = 10.0;

    for (int i = 0; i < components.length; i++) {
      if (i != 0) {
        xPosi += halfSize;
        displayTextWithValue(',', xPosi, 0.0, size, Colors.blue);
        xPosi += halfSize;
      }
      drawComponentZi(components[i], xPosi, 0.0, size, size, size, Colors.blue, true, 1);

      if (components[i] !=  leadComps[i]) {
        xPosi += size;
        displayTextWithValue('(', xPosi, 0.0, size, Colors.blue);
        xPosi += halfSize;
        drawComponentZi(
            leadComps[i],
            xPosi,
            0.0,
            size,
            size,
            size,
            Colors.blue,
            true,
            1);
        xPosi += size;
        displayTextWithValue(')', xPosi, 0.0, size, Colors.blue);
      }

      xPosi += size;
      displayTextWithValue(':', xPosi, 0.0, size, Colors.blue);
      xPosi += halfSize;

      displayTextWithValue(typingCodes[i], xPosi, 0.0, size, Colors.blue);
    }

    for (int j = 0; j < typingStrokes.length; j++) {
      xPosi += halfSize;
      displayTextWithValue(',', xPosi, 0.0, size, Colors.blue);
      xPosi += halfSize;
      drawStrokeZi(typingStrokes[j], xPosi, 0.0, size, size, size, Colors.blue, true, 1.0);
      xPosi += size;
      displayTextWithValue('>', xPosi, 0.0, size, Colors.blue);
      xPosi += halfSize;
      if (typingStrokes[j] != leadTypingStrokes[j]) {
        drawStrokeZi(
            leadTypingStrokes[j],
            xPosi,
            0.0,
            size,
            size,
            size,
            Colors.blue,
            true,
            1.0);
        xPosi += size;
        displayTextWithValue('>', xPosi, 0.0, size, Colors.blue);
        xPosi += halfSize;
      }

      displayTextWithValue(typingCodes[components.length + j], xPosi, 0.0, size, Colors.blue);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}