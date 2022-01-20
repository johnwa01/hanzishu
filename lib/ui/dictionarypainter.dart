import 'package:flutter/material.dart';
import 'package:hanzishu/data/searchingzilist.dart';
import 'dart:math';
import 'dart:ui';
import 'package:hanzishu/engine/lesson.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/dictionary.dart';
import 'package:hanzishu/engine/generalmanager.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/data/firstzilist.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/engine/componentmanager.dart';
import 'package:hanzishu/ui/breakoutpainter.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';

class DictionaryPainter extends BreakoutPainter {
  Color lineColor;
  double screenWidth;
  DictionaryStage dicStage;
  int firstZiIndex;  // different meaning for different stage
  int searchingZiIndex;
  BuildContext context;
  int compoundZiCurrentComponentId;
  ZiListType ziListType;

  static int firstZiCount = theFirstZiList.length; // started with 0
  static int totalSearchingZiCount = theSearchingZiList.length; // started with 0. first one is not real.
  static int minCharsForStrokeIndex = 15;

  Map<int, PositionAndSize> dicBreakoutPositions = Map();

  DictionaryPainter(Color lineColor, double width, DictionaryStage dicStage, int firstZiIndex, int searchingZiIndex, BuildContext context, int compoundZiCurrentComponentId, ZiListType ziListType, bool shouldDrawCenter) {
    this.lineColor = lineColor;
    this.width = width;
    //this.screenWidth,
    this.dicStage = dicStage;

    this.firstZiIndex = firstZiIndex;
    this.searchingZiIndex = searchingZiIndex;
    this.context = context;
    this.compoundZiCurrentComponentId = compoundZiCurrentComponentId;
    this.ziListType = ziListType;
    this.shouldDrawCenter = shouldDrawCenter;
  }

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;

    if (this.dicStage == DictionaryStage.firstzis) {
      displayTextWithValue("Basic Character Table[首字表]", 10.0, 5.0, 20.0, Colors.blueGrey);

      // below should match dictionaryPage
      //var searchPosiAndSize = PositionAndSize(width - 150.0, 5.0, 40.0, 40.0, 0.0, 0.0);
      //displayTextWithValue("Search", searchPosiAndSize.transX, searchPosiAndSize.transY, searchPosiAndSize.width / 2.0, Colors.lightBlue);

      // below should match dictionaryPage
      var helpPosiAndSize = PositionAndSize(width - 70.0, 5.0, 40.0, 40.0, 0.0, 0.0);
      displayTextWithValue("Help", helpPosiAndSize.transX, helpPosiAndSize.transY, helpPosiAndSize.width / 2.0, Colors.lightBlue);

      DisplayFirstZis();
    }
    else if (this.dicStage == DictionaryStage.searchingzis) {
      DisplayNavigationPath(DictionaryStage.searchingzis);
      // seems no need to show this line of text
      //displayTextWithValue("Zi Picking Table (检字表)", 10.0, 40.0, 20.0, Colors.blueGrey); //Character Searching Table
      DisplaySearchingZis(firstZiIndex);
    }
    else if (this.dicStage == DictionaryStage.detailedzi) {
      DisplayNavigationPath(DictionaryStage.detailedzi);
      //displayTextWithValue("Character:", 10.0, 5.0, 25.0, Colors.blueAccent);
      DisplayDetailedZi(searchingZiIndex);
    }
    else if (this.dicStage == DictionaryStage.help) {
 //     DisplayNavigationPath(DictionaryStage.help);
 //     DisplayHelp();
    }
  }

/*
  DisplayHelp() {
    //TODO: Need to implement in a different way so that the text will show naturally.
    double fontSize = 18.0;
    displayTextWithValue("Steps to find a Chinese character:", 10.0, 40.0, 20.0, Colors.blueAccent);

    displayTextWithValue("1. From the First Character Table (首字表), starting from the 6th position, tap the 1st First Character that this character contains. Ex: For Character '你'， tap '小' which is the only/1st First Character it contains.", 10.0, 68.0, fontSize, Colors.blueAccent);

    displayTextWithValue("1a. If the character's 1st First Character is '口' and it also contains other First Character(s), tap the next First Character. Ex: For character '听'， skip '口' and tap '斤'.", 10.0, 190.0, fontSize, Colors.blueAccent);

    //TODO: need a simple match chart to show na, shu gou, di, etc.
    displayTextWithValue("1b. If the character doesn't contain any First Character, tap a stroke in the table before the 6th position that matches the first stroke of the character. Note that all the turning strokes match to '乙'. Ex: For character '长'， tap stroke '一'.", 10.0, 300.0, fontSize, Colors.blueAccent);

    displayTextWithValue("2. With ONE TAP above, you will see the character you are looking for in a list. Otherwise, the dictionary doesn't support this character.", 10.0, 421.0, fontSize, Colors.blueAccent);
    displayTextWithValue("3. You can then choose the character to see its detailed info.", 10.0, 493.0, fontSize, Colors.blueAccent);
  }
*/

  DisplayNavigationPath(DictionaryStage stage) {

    displayTextWithValue("@", 10.0, 5.0, 25.0, Colors.blueAccent);
    displayTextWithValue("->", 35.0, 5.0, 25.0, Colors.blueAccent);

    if (stage == DictionaryStage.searchingzis || stage == DictionaryStage.detailedzi) {
      // TODO: this line should be called in page so that it'll persist the firstZiIndex value
      //if (firstZiIndex == -1) {
      //  firstZiIndex = Dictionary.getFirstZiIndexByPickingZiIndex(searchingZiIndex);
      //}

      if (firstZiIndex >= 0) {
        var searchingZiIndex = theFirstZiList[firstZiIndex].searchingZiId;
        displayTextWithValue(
            theSearchingZiList[searchingZiIndex].char, 70.0, 5.0, 25.0,
            Colors.blueAccent);
      }
    }
    else if (stage == DictionaryStage.help) {
      //var searchingId = theFirstZiList[firstZiIndex].searchingZiId;
      displayTextWithValue("Help", 70.0, 5.0, 25.0, Colors.blueAccent);
    }

    if (stage == DictionaryStage.detailedzi) {
      displayTextWithValue("->", 105.0, 5.0, 25.0, Colors.blueAccent);
      displayTextWithValue(theSearchingZiList[searchingZiIndex].char, 140.0, 5.0, 25.0, Colors.blueAccent);
    }
  }

  DisplayHelpPath() {
    displayTextWithValue("@", 10.0, 5.0, 25.0, Colors.blueAccent);
    displayTextWithValue("->", 35.0, 5.0, 20.0, Colors.blueAccent);
    displayTextWithValue("Help", 60.0, 5.0, 20.0, Colors.blueAccent);
  }

  displayTypingCode(int searchingZiIndex, double yPosi) {
    var typingCode = DictionaryManager.getTypingCode(searchingZiIndex);
    displayTextWithValue(
        "[Typing Code] " + typingCode, 10.0, yPosi, 20.0, Colors.blue[800]);
  }

  DisplayDetailedZi(int ziIndex) {
    thePositionManager.setFrameWidth(getFrameWidth());

    //drawFrameWithColors(
    //    getFrameWidth(), PositionManager.FrameLeftEdgeSize,
    //    PositionManager.FrameTopEdgeSize, Colors.cyan,
    //    Colors.lime, BasePainter.FrameLineWidth);

    var detailedZi = theSearchingZiList[ziIndex];

    var posi = PositionManager.getDicAnimatedZiPositionAndSize();

    if (compoundZiCurrentComponentId > 0) {
      // for compound zi animation action only
      //compoundZiCurrentComponentId

      if (ziListType == ZiListType.searching) {
        // in this case, compoundZiCurrentComponentId is actually the id of a searchingZi itself (not a component), that is, detailedZi.
        if (shouldDrawCenter) {
          var ziChar = DictionaryManager.getChar(compoundZiCurrentComponentId);
          displayTextWithValue(ziChar, posi.transX, posi.transY, posi.charFontSize, Colors.blue);
        }
      }
      else {
        drawComponentZiById(compoundZiCurrentComponentId, posi.transX, posi.transY + 25.0, posi.charFontSize, posi.charFontSize, posi.charFontSize, Colors.blue, false, posi.lineWidth);
      }
    }

    // Note: same position as button action in page.
    var posiAndSizeBihua = PositionManager.getDicAnimationBrushPositionAndSize();
    DisplayIcon(
        iconPenStrokes,
        posiAndSizeBihua.transX,
        posiAndSizeBihua.transY,
        posiAndSizeBihua.width,
        posiAndSizeBihua.height,
        Colors.amber,
        2.0);

    //Need to match the yPosi in DictionaryPage.
    displayTextWithValue("[Sound] ", 10.0, 210.0, 20.0, Colors.blue);
    DisplayIcon(iconSpeechStrokes, 90.0, 210.0, 20.0, 20.0, Colors.amber/*MaterialColor ofColor*/, 2.0/*ziLineWidth*/);
    displayTextWithValue(detailedZi.pinyin, 115.0, 210.0, 20.0, Colors.blue);

    displayTextWithValue("[Meaning] " + detailedZi.meaning, 10.0, 250.0, 20.0, Colors.blue);

    displayComponentsOrStrokes(ziIndex, 290.0);

    displayTypingCode(ziIndex, 330.0);

    displayTextWithValue("[Break out] ", 10.0, 370.0, 20.0, Colors.blue);
    bool isGetPositionOnly = false;
    displayCharBreakout(ziIndex, isGetPositionOnly);
  }

  displayComponentsOrStrokes(int id, double yPosi) {
    var comps = List<String>();
    DictionaryManager.getAllComponents(id, comps);
    if (comps.length == 1) {
      displayTextWithValue("[Strokes] ", 10.0, yPosi, 20.0, Colors.blue);
      var comp = ComponentManager.getComponentByCode(comps[0]);
      drawStrokeZiList(
          comp.strokesString,
          130.0,
          yPosi,
          20.0,
          20.0,
          20.0,
          this.lineColor,
          true,
          20.0 * 0.05);
    }
    else {
      displayTextWithValue("[Components] ", 10.0, yPosi, 20.0, Colors.blue);
      drawComponentZiList(
          comps,
          160.0,
          yPosi,
          20.0,
          20.0,
          20.0,
          this.lineColor,
          true,
          20.0 * 0.05);
    }
  }

  displayCharBreakout(int ziId, bool isGetPositionOnly) {
    breakoutIndex = 0;
    isBreakoutPositionsOnly = isGetPositionOnly;
    //displayTextWithValue("[Break out] ", 10.0, 370.0, 20.0, Colors.blue);
    var yPositionWrapper = YPositionWrapper(xYLength(405.0));  //170.0
    displayOneCharDissembling(yPositionWrapper, ziId, ZiListType.searching, 0);
  }

  displayWholeStrokes() {

  }

  Map<int, PositionAndSize> getDicBreakoutPositions(int ziId) {
    breakoutIndex = 0;

    // give it a space, which will be filled up by a run of displayCharBreakout later with no show
    breakoutPositions = dicBreakoutPositions; //theLessonManager.getBreakoutPositions(lessonId);
    isBreakoutPositionsOnly = true;

    displayCharBreakout(ziId, true);
    return breakoutPositions;
  }

  DisplayFirstZis() {
    double fontSize;
    var textColor;
    String charStr;
    double yPosi;

    for (var j = 0; j < 16; j++) {
      for (var i = 0; i < 12 /*realGroupMembers.length*/; i++) {
        int firstZiId = j * 12 + i;
        if (firstZiId >= firstZiCount) {
          return;
        }

        fontSize = 25.0;
        if (theFirstZiList[firstZiId].char[0] == '[') {
          fontSize = 20.0;
        }

        charStr = theFirstZiList[firstZiId].char;
        if (charStr[0] == "[") {
          textColor = Colors.redAccent;
          yPosi = 60.0 + j * (25.0 + 5.0) /*- 25.0 * 0.25*/;
        }
        else {
          textColor = Colors.blueAccent;
          yPosi =  60.0 + j * (25.0 + 5.0) - 25.0 * 0.25;
        }

        displayTextWithValue(charStr, 20.0 + i * (25.0 + 5.0), yPosi, fontSize, textColor);
      }
    }
  }

  static void getSearchingParameters(int numberOfZi, PrimitiveWrapper actualColumnCount, PositionAndSize startPosition) {
    int columnCount = 8;
    double fontSize = 45.0;
    double rowStartPosition = 85.0;
    double xStartPosition = 12.0;

    if (numberOfZi > 40 && numberOfZi <= 80) {
      columnCount = 9;
      fontSize = 40.0;
      rowStartPosition = 80.0;
    }
    else if (numberOfZi > 80 && numberOfZi <= 120) {
      columnCount = 10;
      fontSize = 35.0;
      rowStartPosition = 75.0;
    }
    else if (numberOfZi > 120 && numberOfZi <= 135) {
      columnCount = 11;
      fontSize = 30.0;
      rowStartPosition = 70.0;
    }
    else if (numberOfZi > 135) {
      columnCount = 12;
      fontSize = 28.0;
      rowStartPosition = 65.0;
    }

    actualColumnCount.value = columnCount;
    startPosition.transX = xStartPosition;
    startPosition.transY = rowStartPosition;
    startPosition.width = fontSize + 5.0;
    startPosition.height = fontSize + 5.0;
    startPosition.charFontSize = fontSize;
    startPosition.lineWidth = 1.0;
  }

  // Note: searchingZis display uses firstZiIndex as input to show all the zis belonging to the firstZiIndex.
  DisplaySearchingZis(int firstZiIndex) {
    var length = getSearchingZiCount(firstZiIndex);
    var searchingZiId = theFirstZiList[firstZiIndex].searchingZiId;
    PrimitiveWrapper actualColumnCount = new PrimitiveWrapper(0);
    PositionAndSize startPosition = new PositionAndSize(0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

    DictionaryPainter.getSearchingParameters(length, actualColumnCount, startPosition);

    //int baseStrokeCount = theSearchingZiList[searchingZiId].strokeCount;
    int newCharCount = 0;
    int previousStrokeCount = 0;
    int currentStrokeCount = 0;
    double strokeIndexFontSize = 20.0;

    String strokeIndexStr;

    var count = 0;
    for (var j = 0; j < 16; j++) {
      for (var i = 0; i < actualColumnCount.value; i++) {  //12
        //int firstZiId = j * 12 + i;
        var searchingZi = theSearchingZiList[searchingZiId];
        // Feel it makes it more complicated & confusion by subtracting baseStrokeCount.
        currentStrokeCount = searchingZi.strokeCount;

        if ((previousStrokeCount == 0 && currentStrokeCount != previousStrokeCount) || (newCharCount >= minCharsForStrokeIndex && currentStrokeCount != previousStrokeCount)) {
          strokeIndexStr = "(" + currentStrokeCount.toString() + ")";
          displayTextWithValue(strokeIndexStr, startPosition.transX + i * startPosition.width, startPosition.transY + j * startPosition.height /*- startPosition.charFontSize * 0.25*/, strokeIndexFontSize, Colors.brown);
          newCharCount = 0;
          previousStrokeCount = currentStrokeCount;
        }
        else {
          //displayTextWithValue(searchingZi.char, 20.0 + i * 30.0, 90.0 + j * 30.0 - 25.0 * 0.25, 25.0, Colors.blueAccent);
          displayTextWithValue(searchingZi.char, startPosition.transX + i * startPosition.width, startPosition.transY + j * startPosition.height - startPosition.charFontSize * 0.25, startPosition.charFontSize, Colors.blueAccent);
          newCharCount++;
          previousStrokeCount = currentStrokeCount;
          searchingZiId++;
          count++;
          if (count >= length) {
            return;
          }
        }
      }
    }
  }

  static int getSearchingZiCount(int firstZiIndex) {
    var searchingZiId = theFirstZiList[firstZiIndex].searchingZiId;
    var nextSearchingZiId;
    int searchingZiCount = 0;

    if (firstZiIndex > firstZiCount - 1) {
      searchingZiCount = -1;
    }
    else if (firstZiIndex < firstZiCount - 1) {
      nextSearchingZiId = theFirstZiList[firstZiIndex + 1].searchingZiId;
      searchingZiCount = nextSearchingZiId - searchingZiId;
    }
    else {  // last firstZi entry
      // the total count includes the first non-zi one
      searchingZiCount = totalSearchingZiCount - searchingZiId;
    }

    return searchingZiCount;
  }

  double getFrameWidth() {
    return width - 10.0;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
