import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import 'package:hanzishu/engine/lesson.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/data/phraselist.dart';
import 'package:hanzishu/data/zilist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';
import 'package:hanzishu/engine/generalmanager.dart';
import 'package:hanzishu/engine/componentmanager.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/engine/strokemanager.dart';
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
      displayHintMessage(18.0, char);
    }
    else {
      displayShiftKeyNote();
    }
  }

  displayShiftKeyNote() {
    String note;
    if (typingType == TypingType.LeadComponents) {
      note = "Note: use 'shift-z' to show components to keyboard mapping.";
    }
    else {
      note = "Note: use 'shift-a' to 'shift-y' to show expanded components. Use 'shift-z' to show mapping.";
    }

    displayTextWithValue(note, 10.0, 0.0, 18.0, Colors.blue);
  }

  displayHintMessage(double fontSize, String char) {
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

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}