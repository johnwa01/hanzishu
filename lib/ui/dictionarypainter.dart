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

enum DictionaryStage {
  firstzis,
  searchingzis,
  detailedzi,
  search,
  help,
  chineseHelp
}

class DictionaryPainter extends BasePainter {
  Color lineColor;
  double screenWidth;
  DictionaryStage dicStage;
  int firstZiIndex;  // different meaning for different stage
  int searchingZiIndex;

  static int firstZiCount = theFirstZiList.length; // started with 0
  static int totalSearchingZiCount = theSearchingZiList.length; // started with 0. first one is not real.

  DictionaryPainter(Color lineColor, double width, DictionaryStage dicStage, int firstZiIndex, int searchingZiIndex) {
    this.lineColor = lineColor;
    this.width = width;
    //this.screenWidth,
    this.dicStage = dicStage;

    this.firstZiIndex = firstZiIndex;
    this.searchingZiIndex = searchingZiIndex;
  }

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;

    if (this.dicStage == DictionaryStage.firstzis) {
      displayTextWithValue("First Zi Table (首字表)", 10.0, 5.0, 20.0, Colors.blueGrey);

      // below should match dictionaryPage
      var searchPosiAndSize = PositionAndSize(width - 150.0, 5.0, 40.0, 40.0, 0.0, 0.0);
      displayTextWithValue("Search", searchPosiAndSize.transX, searchPosiAndSize.transY, searchPosiAndSize.width / 2.0, Colors.lightBlue);

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
      DisplayNavigationPath(DictionaryStage.help);
      DisplayHelp();
    }
  }

  DisplayHelp() {
    displayTextWithValue("Steps to find a zi:", 10.0, 50.0, 25.0, Colors.blueAccent);

    displayTextWithValue("1. From 'First Zi Table', starting from the fifth 'first zi', find the 'first zi' that this zi contains.", 10.0, 95.0, 20.0, Colors.blueAccent);
    displayTextWithValue("   Ex: For zi '好'， find '女' as its 'first zi'. ", 10.0, 140.0, 20.0, Colors.blueAccent);
    displayTextWithValue("1a. If the zi's 'first zi' is '' and it contains other 'first zi', choose the other as 'first zi'.", 10.0, 165.0, 20.0, Colors.blueAccent);
    displayTextWithValue("   Ex: For zi '听'， (skip '口' and) find '斤' as its 'first zi'. ", 10.0, 215.0, 20.0, Colors.blueAccent);
    displayTextWithValue("1b. If you can't find a 'first zi', use the first stroke of the zi to match it to one of the five single stroke 'first zi' at the beginning of the table.", 10.0, 265.0, 20.0, Colors.blueAccent);
    displayTextWithValue("    Note that all the turning strokes match to '乙'.", 10.0, 330.0, 20.0, Colors.blueAccent);
    displayTextWithValue("   Ex: For zi '长'， find '一' as its 'first zi'. ", 10.0, 380.0, 20.0, Colors.blueAccent);
    displayTextWithValue("2. Click the 'first zi' to go to 'Searching Zi Table'.", 10.0, 420.0, 20.0, Colors.blueAccent);
    displayTextWithValue("3. From the 'Searching Zi Table', find/click the zi you are looking for.", 10.0, 470.0, 20.0, Colors.blueAccent);
  }

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

  DisplayDetailedZi(int ziIndex) {
    thePositionManager.setFrameWidth(getFrameWidth());

    //drawFrameWithColors(
    //    getFrameWidth(), PositionManager.FrameLeftEdgeSize,
    //    PositionManager.FrameTopEdgeSize, Colors.cyan,
    //    Colors.lime, BasePainter.FrameLineWidth);

    var detailedZi = theSearchingZiList[ziIndex];

    displayTextWithValue(detailedZi.char, 100.0, 100.0,
        thePositionManager.getCharFontSize(ZiOrCharSize.centerSize) * 2,
        Colors.blue);

    DisplayIcon(iconSpeechStrokes, 70.0, 358.0, 30.0, 30.0, Colors.amber/*MaterialColor ofColor*/, 2.0/*ziLineWidth*/);
    displayTextWithValue(detailedZi.pinyin, 105.0, 350.0,
        thePositionManager.getCharFontSize(ZiOrCharSize.newCharsSize),
        Colors.blue);

    displayTextWithValue(detailedZi.meaning, 70.0, 390.0,
        thePositionManager.getCharFontSize(ZiOrCharSize.newCharsSize),
        Colors.blue);

    // annotate
    // bihua or 2 assembly units for the zi
  }

  DisplayFirstZis() {
    double fontSize;
    var textColor;
    String charStr;

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
        }
        else {
          textColor = Colors.blueAccent;
        }

        displayTextWithValue(charStr, 20.0 + i * 30.0, 60.0 + j * 30.0 - 25.0 * 0.25, fontSize, textColor);
      }
    }
  }

  // Note: searchingZis display uses firstZiIndex as input to show all the zis belonging to the firstZiIndex.
  DisplaySearchingZis(int firstZiIndex) {
    var length = getSearchingZiCount(firstZiIndex);
    var searchingZiId = theFirstZiList[firstZiIndex].searchingZiId;

    int columnCount = 8;
    double fontSize = 45.0;
    double rowStartPosition = 85.0;

    if (length > 40 && length <= 80) {
      columnCount = 9;
      fontSize = 40.0;
      rowStartPosition = 80.0;
    }
    else if (length > 80 && length <= 120) {
      columnCount = 10;
      fontSize = 35.0;
      rowStartPosition = 75.0;
    }
    else if (length > 120 && length <= 135) {
      columnCount = 11;
      fontSize = 30.0;
      rowStartPosition = 70.0;
    }
    else if (length > 135) {
      columnCount = 12;
      fontSize = 28.0;
      rowStartPosition = 65.0;
    }

    int baseStrokeCount = theSearchingZiList[searchingZiId].strokeCount;
    int newCharCount = 0;
    int previousNetStrokeCount = 0;
    int currentNetStrokeCount = 0;
    double strokeIndexFontSize = 20.0;
    int minCharsForStrokeIndex = 15;
    String strokeIndexStr;

    var count = 0;
    for (var j = 0; j < 16; j++) {
      for (var i = 0; i < columnCount; i++) {  //12
        //int firstZiId = j * 12 + i;
        var searchingZi = theSearchingZiList[searchingZiId];
        currentNetStrokeCount = searchingZi.strokeCount - baseStrokeCount;

        if ((previousNetStrokeCount == 0 && currentNetStrokeCount != previousNetStrokeCount) || (newCharCount >= minCharsForStrokeIndex && currentNetStrokeCount != previousNetStrokeCount)) {
          strokeIndexStr = "[" + currentNetStrokeCount.toString() + "]";
          displayTextWithValue(strokeIndexStr, 12.0 + i * (fontSize + 5.0), rowStartPosition + j * (fontSize + 5.0) - fontSize * 0.25, strokeIndexFontSize, Colors.brown);
          newCharCount = 0;
          previousNetStrokeCount = currentNetStrokeCount;
        }
        else {
          //displayTextWithValue(searchingZi.char, 20.0 + i * 30.0, 90.0 + j * 30.0 - 25.0 * 0.25, 25.0, Colors.blueAccent);
          displayTextWithValue(searchingZi.char, 12.0 + i * (fontSize + 5.0), rowStartPosition + j * (fontSize + 5.0) - fontSize * 0.25, fontSize, Colors.blueAccent);
          newCharCount++;
          previousNetStrokeCount = currentNetStrokeCount;
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
      searchingZiCount = totalSearchingZiCount + 1 - searchingZiId;
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
