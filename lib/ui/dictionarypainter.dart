import 'package:flutter/material.dart';
import 'package:hanzishu/data/searchingzilist.dart';
import 'dart:ui';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/dictionary.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/data/firstzilist.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/breakoutpainter.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';

class DictionaryPainter extends BreakoutPainter {
  Color lineColor;
  //double screenWidth; == width in basepainter
  DictionaryStage dicStage;
  int firstZiIndex;  // different meaning for different stage
  int searchingZiIndex;
  BuildContext context;
  int compoundZiCurrentComponentId;
  ZiListType ziListType;
  bool showBreakoutDetails;

  static int firstZiCount = theFirstZiList.length; // started with 0
  static int totalSearchingZiCount = theSearchingZiList.length; // started with 0. first one is not real.
  static int minCharsForStrokeIndex = 15;

  Map<int, PositionAndSize> dicBreakoutPositions = Map();

  DictionaryPainter(Color lineColor, double screenWidth, DictionaryStage dicStage, int firstZiIndex, int searchingZiIndex, BuildContext context, int compoundZiCurrentComponentId, ZiListType ziListType, bool shouldDrawCenter, bool showBreakoutDetails) {
    this.lineColor = lineColor;
    this.width = screenWidth;
    this.dicStage = dicStage;

    this.firstZiIndex = firstZiIndex;
    this.searchingZiIndex = searchingZiIndex;
    this.context = context;
    this.compoundZiCurrentComponentId = compoundZiCurrentComponentId;
    this.ziListType = ziListType;
    this.shouldDrawCenter = shouldDrawCenter;
    this.showBreakoutDetails = showBreakoutDetails;
  }

  double getSizeRatio() {
    var defaultSize = width / 16.0; // equivalent to the original hardcoded value of 25.0
    return defaultSize / 25.0;
  }

  double applyRatio(double value) {
    return value * getSizeRatio();
  }

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;

    if (this.dicStage == DictionaryStage.firstzis) {
      // Just keep a height
      displayTextWithValue("", applyRatio(20.0), applyRatio(5.0), applyRatio(20.0), Colors.blueGrey, false); // 20

      // below should match dictionaryPage
      //var helpPosiAndSize = PositionAndSize(width - applyRatio(65.0), applyRatio(5.0), applyRatio(20.0), applyRatio(20.0), 0.0, 0.0); // 5.0
      //displayTextWithValue("", helpPosiAndSize.transX, helpPosiAndSize.transY, helpPosiAndSize.width, Colors.lightBlue);

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
    var defaultFontSize = applyRatio(25.0);
    var fontSize1 = applyRatio (5.0);
//    var fontSize2 = applyRatio(10.0);
    var fontSize3 = applyRatio(35.0);
    var fontSize4 = applyRatio(70.0);
//    var fontSize5 = applyRatio(105.0);
//    var fontSize6 = applyRatio(140.0);

//    displayTextWithValue("@", fontSize2, fontSize1, defaultFontSize, Colors.blueAccent);

    if (/*stage == DictionaryStage.searchingzis ||*/ stage == DictionaryStage.detailedzi) {
      // TODO: this line should be called in page so that it'll persist the firstZiIndex value
      //if (firstZiIndex == -1) {
      //  firstZiIndex = Dictionary.getFirstZiIndexByPickingZiIndex(searchingZiIndex);
      //}

      if (firstZiIndex >= 0) {
        displayTextWithValue("<-", fontSize3, fontSize1, defaultFontSize, Colors.blueAccent, false);
        var searchingZiIndex = theFirstZiList[firstZiIndex].searchingZiId;
        displayTextWithValue(
            theSearchingZiList[searchingZiIndex].char, fontSize4, fontSize1, defaultFontSize,
            Colors.blueAccent, false);
      }
    }
    else if (stage == DictionaryStage.help) {
      //var searchingId = theFirstZiList[firstZiIndex].searchingZiId;
      displayTextWithValue(getString(114)/*"Help"*/, fontSize4, fontSize1, defaultFontSize, Colors.blueAccent, false);
    }
/*
    if (stage == DictionaryStage.detailedzi) {
      displayTextWithValue("->", fontSize5, fontSize1, defaultFontSize, Colors.blueAccent);
      displayTextWithValue(theSearchingZiList[searchingZiIndex].char, fontSize6, fontSize1, defaultFontSize, Colors.blueAccent);
    }
*/
  }

  DisplayHelpPath() {
    displayTextWithValue("@", 10.0, 5.0, 25.0, Colors.blueAccent, false);
    displayTextWithValue("->", 35.0, 5.0, 20.0, Colors.blueAccent, false);
    displayTextWithValue(getString(114)/*"Help"*/, 60.0, 5.0, 20.0, Colors.blueAccent, false);
  }

  DisplayDetailedZi(int ziIndex) {
    thePositionManager.setFrameWidth(getFrameWidth());

    //var defaultFontSize = applyRatio(25.0);
    //NOTE: match the definitions in dictionarysearchingpage.dart
    var fontSize1 = applyRatio(1.0);
    var fontSize2 = applyRatio(2.0);
    var fontSize3 = applyRatio(10.0);
    var fontSize4 = applyRatio(20.0);
    var fontSize5 = applyRatio(25.0);
    var fontSize6 = applyRatio(35.0);
    var fontSize7 = applyRatio(90.0);
    var fontSize8 = applyRatio(115.0);
    var fontSize9 = applyRatio(210.0);
    var fontSize10 = applyRatio(245.0);
    var fontSize11 = applyRatio(295.0);
    var fontSize12 = applyRatio(362.0);

    //drawFrameWithColors(
    //    getFrameWidth(), PositionManager.FrameLeftEdgeSize,
    //    PositionManager.FrameTopEdgeSize, Colors.cyan,
    //    Colors.lime, BasePainter.FrameLineWidth);

    var detailedZi = theSearchingZiList[ziIndex];

    var posi = PositionManager.getDicAnimatedZiPositionAndSize(getSizeRatio());

    var charColor = Colors.blue;
    if (compoundZiCurrentComponentId != ziIndex) {
      // for animation's component chars
      charColor = Colors.brown;
    }

    // compoundZiCurrentComponentId is also used for compound zi animation action
    if (ziListType == ZiListType.searching) {
      // in this case, compoundZiCurrentComponentId is actually the id of a searchingZi itself (not a component), that is, detailedZi.
      if (compoundZiCurrentComponentId > 0 && shouldDrawCenter) {
        var ziChar = DictionaryManager.getChar(compoundZiCurrentComponentId);
        displayTextWithValue(ziChar, posi.transX, posi.transY + fontSize5 * 0.7, posi.charFontSize, charColor, false);
      }
    }
    else {
      if (compoundZiCurrentComponentId >= 0) {
        drawComponentZiById(
            compoundZiCurrentComponentId,
              posi.transX,
              posi.transY + fontSize5,
              posi.charFontSize,
              posi.charFontSize,
              posi.charFontSize,
              charColor,
              false,
              posi.lineWidth);
      }
    }

    // Note: same position as button action in page.
    var animatedZiPosi = PositionManager.getDicAnimatedZiPositionAndSize(getSizeRatio());
    var posiAndSizeBihua = PositionManager.getDicAnimationBrushPositionAndSize(animatedZiPosi, getSizeRatio());
    DisplayIcon(
        iconPenStrokes,
        posiAndSizeBihua.transX,
        posiAndSizeBihua.transY,
        posiAndSizeBihua.width,
        posiAndSizeBihua.height,
        Colors.amber,
        fontSize2);

    // for related ZiGroups
    /*
    DisplayIcon(
        iconPenStrokes,
        posiAndSizeBihua.transX + 100,
        posiAndSizeBihua.transY,
        posiAndSizeBihua.width,
        posiAndSizeBihua.height,
        Colors.amber,
        fontSize2);
    */

    displayTextWithValue("[" + getString(418)/*"Phrase"*/ + "]", posiAndSizeBihua.transX + 100, posiAndSizeBihua.transY, fontSize4, Colors.black, false);

    //Need to match the yPosi in DictionaryPage.
    displayTextWithValue(getString(85)/*"Sound"*/ + ": ", fontSize3, fontSize9, fontSize4, Colors.black, false);
    DisplayIcon(iconSpeechStrokes, fontSize7, fontSize9, fontSize4, fontSize4, Colors.amber/*MaterialColor ofColor*/, fontSize2/*ziLineWidth*/);
    displayTextWithValue(detailedZi.pinyin, fontSize8 * 1.1, fontSize9, fontSize4, Colors.blue, false);

    displayTextWithValue(getString(86)/*"Meaning"*/ + ": ", fontSize3, fontSize10, fontSize4, Colors.black, false);
    displayTextWithValue(detailedZi.meaning, fontSize3 + applyRatio(90.0), fontSize10, fontSize4, Colors.blue, false);

    var posiSize = PositionAndSize(fontSize3, fontSize11, fontSize4, fontSize4, fontSize4, fontSize1);
    displayComponentsOrStrokes(ziIndex, posiSize, true);
    posiSize.transY += fontSize6;

    if (showBreakoutDetails) {
      displayTypingCodePlaceholder(posiSize);  // hide when diamond icon is selected
    }
    else {
      displayTypingCode(ziIndex, posiSize);
    }

    //displayTextWithValue("Hint: ", 10.0, 350.0, 20.0, Colors.blue); // pictograph image will show up here as well

    displayTextWithValue(getString(304)/*"Breakdown"*/ + ": ", fontSize3, fontSize12, fontSize4, Colors.black, false);
    DisplayIcon(iconBreakdownStrokes, fontSize8 * 1.1, fontSize12, fontSize4, fontSize4, Colors.amber, fontSize2);
    bool isGetPositionOnly = false;
    var yPosi = displayCharBreakout(ziIndex, isGetPositionOnly);
  }

  /*
  displayComponentsOrStrokes(int searchingZiId, PositionAndSize posi) {
    var isSingleCompZi = DictionaryManager.isSingleCompZi(searchingZiId);

    if (isSingleCompZi) {
      displayStrokes(searchingZiId, posi, getSizeRatio());
    }
    else {
      displayFullComponents(searchingZiId, posi, getSizeRatio());
    }
  }
  */

  double displayCharBreakout(int ziId, bool isGetPositionOnly, ) {
    //breakoutIndex.value = 0;
    isBreakoutPositionsOnly = isGetPositionOnly;

    var fontSize1 = applyRatio(396.0); //425.0
    //displayTextWithValue("[Break out] ", 10.0, 370.0, 20.0, Colors.blue);
    var yPositionWrapper = YPositionWrapper(fontSize1);  //170.0
    displayOneCharDissembling(yPositionWrapper, ziId, ZiListType.searching, 0, showBreakoutDetails, isBreakoutPositionsOnly, breakoutPositions);

    return yPositionWrapper.yPosi;
  }

  displayWholeStrokes() {

  }

  Map<int, PositionAndSize> getDicBreakoutPositions(int ziId) {
    //breakoutIndex.value = 0;

    // give it a space, which will be filled up by a run of displayCharBreakout later with no show
    breakoutPositions = dicBreakoutPositions; //theLessonManager.getBreakoutPositions(lessonId);
    isBreakoutPositionsOnly = true;

    displayCharBreakout(ziId, true); // get positions only
    return breakoutPositions;
  }

  DisplayFirstZis() {
    double fontSize;
    var textColor;
    String charStr;
    double yPosi;

    var defaultFontSize = applyRatio(25.0);
    var smallFontSize = applyRatio(20.0);
    var fillerSize = applyRatio(4.0); // 5
    var startYSize = applyRatio(40.0); // 60


    for (var j = 0; j < 16; j++) {
      for (var i = 0; i < 12 /*realGroupMembers.length*/; i++) {
        int firstZiId = j * 12 + i;
        if (firstZiId >= firstZiCount) {
          return;
        }

        fontSize = defaultFontSize;  //25.0
        if (theFirstZiList[firstZiId].char[0] == '[') {
          fontSize = smallFontSize;   //20.0
        }

        charStr = theFirstZiList[firstZiId].char;
        if (charStr[0] == "[") {
          textColor = Colors.redAccent;
          yPosi = startYSize + j * (defaultFontSize + fillerSize) /*- 25.0 * 0.25*/;
        }
        else {
          textColor = Colors.blueAccent;
          yPosi =  startYSize + j * (defaultFontSize + fillerSize) - defaultFontSize * 0.25;
        }

        displayTextWithValue(charStr, smallFontSize + i * (defaultFontSize + fillerSize), yPosi, fontSize, textColor, false);
      }
    }
  }

  static void getSearchingParameters(double screenWidth, int numberOfZi, PrimitiveWrapper actualColumnCount, PositionAndSize startPosition) {
    // since this is static function shared by others, just do the ratio here itself
    var defaultFontSize = screenWidth / 16.0;  // was 25.0 as the hardcoded value
    int columnCount = 8;
    double fontSize = defaultFontSize * (41.0 / 25.0); //45.0
    double rowStartPosition = defaultFontSize * (70.0 / 25.0);  //85.0
    double xStartPosition = defaultFontSize * (12.0 / 25.0);

    if (numberOfZi > 40 && numberOfZi <= 80) {
      columnCount = 9;
      fontSize = defaultFontSize * (37.0 / 25.0); //40.0;
      rowStartPosition = defaultFontSize * (62.0 / 25.0);
    }
    else if (numberOfZi > 80 && numberOfZi <= 120) {
      columnCount = 10;
      fontSize = defaultFontSize * (31.0 / 25.0); //35.0;
      rowStartPosition = defaultFontSize * (54.0 / 25.0);
    }
    else if (numberOfZi > 120 && numberOfZi <= 135) {
      columnCount = 11;
      fontSize = defaultFontSize * (27.0 / 25.0); //30.0;
      rowStartPosition = defaultFontSize * (46.0 / 25.0);
    }
    else if (numberOfZi > 135) {
      columnCount = 12;
      fontSize = defaultFontSize * (26.0 / 25.0); //28.0;
      rowStartPosition = defaultFontSize * (32.0 / 25.0);
    }

    actualColumnCount.value = columnCount;
    startPosition.transX = xStartPosition;
    startPosition.transY = rowStartPosition;
    startPosition.width = fontSize + defaultFontSize * (5.0 / 25.0);
    startPosition.height = fontSize + defaultFontSize * (5.0 / 25.0);
    startPosition.charFontSize = fontSize;
    startPosition.lineWidth = defaultFontSize * (1.0 / 25.0);
  }

  // Note: searchingZis display uses firstZiIndex as input to show all the zis belonging to the firstZiIndex.
  DisplaySearchingZis(int firstZiIndex) {
    var length = getSearchingZiCount(firstZiIndex);
    var searchingZiId = theFirstZiList[firstZiIndex].searchingZiId;
    PrimitiveWrapper actualColumnCount = new PrimitiveWrapper(0);
    PositionAndSize startPosition = new PositionAndSize(0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

    getSearchingParameters(width, length, actualColumnCount, startPosition);

    //int baseStrokeCount = theSearchingZiList[searchingZiId].strokeCount;
    int newCharCount = 0;
    int previousStrokeCount = 0;
    int currentStrokeCount = 0;

    double strokeIndexFontSize = applyRatio(15.0);

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
          displayTextWithValue(strokeIndexStr, startPosition.transX + i * startPosition.width, startPosition.transY + j * startPosition.height /*- startPosition.charFontSize * 0.25*/, strokeIndexFontSize, Colors.brown, false);
          newCharCount = 0;
          previousStrokeCount = currentStrokeCount;
        }
        else {
          //displayTextWithValue(searchingZi.char, 20.0 + i * 30.0, 90.0 + j * 30.0 - 25.0 * 0.25, 25.0, Colors.blueAccent);
          displayTextWithValue(searchingZi.char, startPosition.transX + i * startPosition.width, startPosition.transY + j * startPosition.height - startPosition.charFontSize * 0.25, startPosition.charFontSize, Colors.blueAccent, false);
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
