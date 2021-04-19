import 'package:flutter/material.dart';
import 'package:hanzishu/data/searchingzilist.dart';
import 'dart:math';
import 'dart:ui';
import 'package:hanzishu/engine/lesson.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/generalmanager.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/data/firstzilist.dart';

enum DictionaryStage {
  firstzis,
  searchingzis,
  detailedzi,
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
      displayTextWithValue("首字表", 10.0, 5.0, 20.0, Colors.blueGrey);
      // below should match dictionaryPage
      var helpPosiAndSize = PositionAndSize(width - 70.0, 5.0, 40.0, 40.0, 0.0, 0.0);
      displayTextWithValue("Help", helpPosiAndSize.transX, helpPosiAndSize.transY, helpPosiAndSize.width / 2.0, Colors.lightBlue);

      DisplayFirstZis();
    }
    else if (this.dicStage == DictionaryStage.searchingzis) {
      DisplayNavigationPath(DictionaryStage.searchingzis);
      displayTextWithValue("检字表", 10.0, 40.0, 20.0, Colors.blueGrey); //Character Searching Table
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
    displayTextWithValue("   1a. If the zi's 'first zi' is '' and it contains other 'first zi', choose the other as 'first zi'.", 10.0, 145.0, 20.0, Colors.blueAccent);
    displayTextWithValue("   1b. If you can't find a 'first zi', use the first stroke of the zi to match it to one of the five 'first zi' at the beginning of the table.", 10.0, 195.0, 20.0, Colors.blueAccent);
    displayTextWithValue("2. Click the 'first zi' to go to 'Searching Zi Table'.", 10.0, 265.0, 20.0, Colors.blueAccent);
    displayTextWithValue("3. From the 'Searching Zi Table', find/click the zi you are looking for.", 10.0, 315.0, 20.0, Colors.blueAccent);
  }

  DisplayNavigationPath(DictionaryStage stage) {

    displayTextWithValue("@", 10.0, 5.0, 25.0, Colors.blueAccent);
    displayTextWithValue("->", 35.0, 5.0, 25.0, Colors.blueAccent);

    if (stage == DictionaryStage.searchingzis) {
      var searchingId = theFirstZiList[firstZiIndex].searchingZiId;
      displayTextWithValue(theSearchingZiList[searchingId].char, 70.0, 5.0, 25.0, Colors.blueAccent);
    }
    else if (stage == DictionaryStage.help) {
      var searchingId = theFirstZiList[firstZiIndex].searchingZiId;
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

        displayTextWithValue(theFirstZiList[firstZiId].char, 20.0 + i * 30.0, 60.0 + j * 30.0 - 25.0 * 0.25, fontSize, Colors.blueAccent);
      }
    }
  }

  // Note: searchingZis display uses firstZiIndex as input to show all the zis belonging to the firstZiIndex.
  DisplaySearchingZis(int firstZiIndex) {
    var length = getSearchingZiCount(firstZiIndex);
    var searchingZiId = theFirstZiList[firstZiIndex].searchingZiId;

    var count = 0;
    for (var j = 0; j < 16; j++) {
      for (var i = 0; i < 12; i++) {
        //int firstZiId = j * 12 + i;
        var searchingZi = theSearchingZiList[searchingZiId];
        displayTextWithValue(searchingZi.char, 20.0 + i * 30.0, 90.0 + j * 30.0 - 25.0 * 0.25, 25.0, Colors.blueAccent);
        searchingZiId++;
        count++;
        if (count >= length) {
          return;
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
