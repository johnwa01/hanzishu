import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';
import 'package:hanzishu/engine/componentmanager.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/data/componenttypinglist.dart';
import 'package:hanzishu/utility.dart';


class InputZiHintPainter extends BasePainter {
  Color lineColor;
  Color completeColor;
  double screenWidth;
  int showHint;
  int selectedCompIndex;
  //int selectedCategoryIndex;
  //int selectedSubcategoryIndex;
  String char;
  TypingType typingType;

  InputZiHintPainter({
    this.lineColor, this.completeColor, this.screenWidth, this.showHint, this.selectedCompIndex, /*this.selectedCategoryIndex, this.selectedSubcategoryIndex,*/ this.char, this.typingType
  });

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;
    this.width = screenWidth; // set the base class width variable

    if (showHint == 1 || showHint == 2) {
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
    //var searchingZiId = DictionaryManager.getSearchingZiId(char);
    //List<String> components = List<String>();
    //DictionaryManager.getAllComponents(searchingZiId, components);
    var typingComponentsAndSubComp = ComponentManager.getTypingComponentsAndSubComp(char);

    double size = 24 * getSizeRatio(); //14.4
    if (showHint == 2) {
      size = 20 * getSizeRatio(); //14.4
    }
    double halfSize = size/1.2;
    double xPosi = 8.0; //10.0
    var compColor;

    for (int i = 0; i < typingComponentsAndSubComp.length; i++) {
      compColor = Colors.blue;
      if (selectedCompIndex == (i + 1)) {
        compColor = Colors.purple;
      }

      if (i != 0) {
        xPosi += halfSize / 1.5;
      //  displayTextWithValue(',', xPosi, 0.0, size, Colors.blue);
      //  xPosi += halfSize / 1.5;
      }

      var comp = typingComponentsAndSubComp[i];
      drawComponentZi(comp, xPosi, 0.0, size, size, size, compColor, true, 1);

      xPosi += size * 1.2;
      if (showHint == 2) {
        displayTextWithValue('(', xPosi, 0.0, size, compColor, false);
        xPosi += halfSize / 1.5;
        var typingCode = ComponentManager.getTypingCode(comp);
        displayTextWithValue(
            typingCode.toUpperCase(), xPosi, 0.0, size, compColor, false);

        xPosi += size; //* 1.2;
        displayTextWithValue(')', xPosi, 0.0, size, compColor, false);
        //xPosi += halfSize / 1.5;
      }
    }
  }

  /*
  displayCompCategories(String correctCompCategory, int selectedCategoryIndex) {
    double size = 20.0;
    double xPosi = 0.0;
    double yPosi = 40.0;
    String categoryName;

    for (int i = 0; i < 3/*theComponentCategoryList.length*/; i++) {
        categoryName = getString(theComponentCategoryList[i].categoryNameLocaleStringId);
        displayTextWithValue(categoryName, xPosi, yPosi, size, Colors.blue, false);
        xPosi += 5 * size;
    }
  }
  */

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}