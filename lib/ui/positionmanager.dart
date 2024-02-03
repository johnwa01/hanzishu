import 'package:flutter/material.dart';
import 'package:hanzishu/data/searchingzilist.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/engine/levelmanager.dart';
import 'package:hanzishu/engine/zimanager.dart';

class PositionAndMeaning {
  double x;
  double y;
  String meaning;

  PositionAndMeaning(
      double x,
      double y,
      String meaning) {
    this.x = x;
    this.y = y;
    this.meaning = meaning;
  }

  set(double x, double y, String meaning) {
    this.x = x;
    this.y = y;
    this.meaning = meaning;
  }
}

class ZiOrCharSize {
  static int defaultSize = 0;
  static int centerSize = 1;
  static int sideLargeSize = 2;
  static int sideMediumSize = 3;
  static int sideSmallSize = 4;
  static int conversationSize = 5;
  static int assembleDissembleSize = 6;
  static int newCharsSize = 7;
  static int strokeSize = 8;
}

//theCharSizes.centerZiSize
//theCharSizes.sideZiLargeSize
//theCharSizes.sideZiSmallSize

class PositionAndSize {
  double transX;
  double transY;
  double width;
  double height;
  double charFontSize;
  double lineWidth;

  PositionAndSize(double transX,
    double transY,
    double width,
    double height,
    double charFontSize,
    double lineWidth) {
      this.transX = transX;
      this.transY = transY;
      this.width = width;
      this.height = height;
      this.charFontSize = charFontSize;
      this.lineWidth = lineWidth;
  }
}

/* in engine zimanager
class NumberOfZis {
  int left;
  int right;
  int upper;
  int bottom;

  NumberOfZis(int left, int right, int upper, int bottom) {
    left = left;
    right = right;
    upper = upper;
    bottom = bottom;
  }
}
*/

class PositionManager
{
  static int theSmallMaximumNumber = 3;
  static int theMediumMaximumNumber = 5;
  static int theBigMaximumNumber = 8;
  //var theTotalSideNumberOfZis = NumberOfZis(0, 0, 0, 0);
  var theCurrentSideIndexOfZis = NumberOfZis(0, 0, 0, 0);
  static double defaultFrameTopEdgeSize = 35.0;
  static double FrameTopEdgeSize = defaultFrameTopEdgeSize; // initial value

  static double FrameLeftEdgeSize = 4.0;
  static double FrameHeightToWidthRatio = 1.2;

  var frameWidth = 0.0;
  var theFrameHeightY = 0.0; // = theFrameWidth * theFrameHeightToWidthRatio

  setFrameTopEdgeSizeWithRatio(double sizeRatio) {
    FrameTopEdgeSize = defaultFrameTopEdgeSize * sizeRatio;
  }

  init() {}

  static PositionAndSize copyPositionAndSize(PositionAndSize posi) {
    return PositionAndSize(posi.transX, posi.transY, posi.width, posi.height, posi.charFontSize, posi.lineWidth);
  }

  double getFrameXPosition(int index) {
    var x1 = FrameLeftEdgeSize;
    double width1 = frameWidth / 3.0;
    if (index == 1) {
      return x1;
    }
    var x2 = x1 + width1 * 0.9;
    if (index == 2) {
      return x2;
    }
    var x3 = x2 + width1 * 1.2;
    if (index == 3) {
      return x3;
    }
    var x4 = x3 + width1 * 0.9;
    if (index == 4) {
      return x4;
    }
  }

  double getFrameYPosition(int index) {
    double height = frameWidth * FrameHeightToWidthRatio;
    var y1 = FrameTopEdgeSize;
    var height1 = height / 3.01;
    if (index == 1) {
      return y1;
    }
    var y2 = y1 + height1 * 0.9;
    if (index == 2) {
      return y2;
    }
    var y3 = y2 + height1 * 1.2;
    if (index == 3) {
      return y3;
    }
    var y4 = y3 + height1 * 0.9;
    if (index == 4) {
      return y4;
    }
  }

  PositionAndSize getCenterZiPosi() {
    // speech icon
    var xPosi2 = getFrameXPosition(2);
    var yPosi2 = getFrameYPosition(2);
    var charFontSize = getCharFontSize(ZiOrCharSize.centerSize);

    return PositionAndSize(xPosi2 + charFontSize * 0.35, yPosi2 + charFontSize * 0.7,
        charFontSize , charFontSize, 0.0, 0.0);
  }

  PositionAndSize getCenterSpeechPosi() {
    // speech icon
    var xPosi2 = getFrameXPosition(2);
    var yPosi2 = getFrameYPosition(2);
    var charFontSize = getCharFontSize(ZiOrCharSize.centerSize);

    return PositionAndSize(xPosi2 + charFontSize * 0.1, yPosi2 + charFontSize * 0.2,
        charFontSize * 0.3, charFontSize * 0.3, 0.0, 0.0);
  }

  PositionAndSize getMeaningPosi() {
    // Bihua icon
    var xPosi2 = getFrameXPosition(2);
    var yPosi3 = getFrameYPosition(3);
    var charFontSize = getCharFontSize(ZiOrCharSize.centerSize);

    return PositionAndSize(xPosi2 + charFontSize * 0.35,  yPosi3 - charFontSize * 0.4, charFontSize * 0.27, charFontSize * 0.27, 0.0, 0.0);
  }

  PositionAndSize getMeaningTextSpeechPosi() {
    // Bihua icon
    var xPosi2 = getFrameXPosition(2);
    var xPosi3 = getFrameXPosition(3);
    var yPosi3 = getFrameYPosition(3);
    var charFontSize = getCharFontSize(ZiOrCharSize.centerSize);

    return PositionAndSize(xPosi2 + charFontSize * 0.35,  yPosi3 - charFontSize * 0.4, xPosi3 - xPosi2 - charFontSize * 0.35 * 2, charFontSize * 0.30, 0.0, 0.0);
  }

  PositionAndSize getCenterBihuaPosi() {
    // Bihua icon
    var xPosi3 = getFrameXPosition(3);
    var yPosi3 = getFrameYPosition(3);
    var charFontSize = getCharFontSize(ZiOrCharSize.centerSize);

    return PositionAndSize(xPosi3 - charFontSize * 0.35,  yPosi3 - charFontSize * 0.35, charFontSize * 0.3, charFontSize * 0.3, 0.0, 0.0);
  }

  PositionAndSize getHintPosi() {
    // speech icon
    var xPosi1 = getFrameXPosition(1);
    var yPosi4 = getFrameYPosition(4);
    var charFontSize = getCharFontSize(ZiOrCharSize.defaultSize);

    return PositionAndSize(xPosi1, yPosi4/* + charFontSize*/,
        charFontSize, charFontSize, 20.0, 0.0);
  }

  PositionAndSize getNewCharIconPosi() {
    // speech icon
    var xPosi3 = getFrameXPosition(3);
    var yPosi2 = getFrameYPosition(2);
    var charFontSize = getCharFontSize(ZiOrCharSize.centerSize);

    return PositionAndSize(xPosi3 - charFontSize * 0.35, yPosi2 + charFontSize * 0.1,
        charFontSize * 0.3, charFontSize * 0.3, 0.0, 0.0);
  }

  /* left bottom corner of the frame
  PositionAndSize getLearnedCharIconPosi() {
    // speech icon
    var xPosi2 = getFrameXPosition(2);
    var yPosi3 = getFrameYPosition(3);
    var charFontSize = getCharFontSize(ZiOrCharSize.centerSize);

    return PositionAndSize(xPosi2 + charFontSize * 0.05, yPosi3 - charFontSize * 0.4,
        charFontSize * 0.3, charFontSize * 0.3, 0.0, 0.0);
  }
  */

  PositionAndSize getTreeNavigationPosi(double sizeRatio) {
    var xPosi1 = getFrameXPosition(1);
    var yPosi1 = getFrameYPosition(1);
    // Not apply sizeRatio for the chars in navigation path, only apply to the space of each char so that it looks bigger
    var charFontSize = getCharFontSize(ZiOrCharSize.conversationSize) /* sizeRatio*/;

    return PositionAndSize(xPosi1, yPosi1 - charFontSize,  // change to shift just half
        charFontSize, charFontSize, charFontSize, 2.0 /* sizeRatio*/);
  }

  PositionAndSize getPositionAndSize(ZiListType listType, int memberZiId, NumberOfZis sideNumberOfZis/*, isCreationList: Bool*/) {
    var currentDisplayOrder = 0;
    var totalNumber = theBigMaximumNumber;
    String displaySideString;
    //var displayZiInCreationList = isCreationList
    if (listType == ZiListType.zi) {
      var memberZi = theZiManager.getZi(memberZiId);
      displaySideString = Utility.checkAndUpdateOneCharSideForLessonTwo(
          memberZiId, memberZi.displaySide);
    }
    else { // searchingZiList
      displaySideString = theSearchingZiList[memberZiId].displaySide;
    }

    switch (displaySideString) {
      case "l":
        currentDisplayOrder = theCurrentSideIndexOfZis.left;
        totalNumber = sideNumberOfZis.left;
        break;
      case "r":
        currentDisplayOrder = theCurrentSideIndexOfZis.right;
        totalNumber = sideNumberOfZis.right;
        break;
      case "u":
        currentDisplayOrder = theCurrentSideIndexOfZis.upper;
        totalNumber = sideNumberOfZis.upper;
        break;
      case "b":
        currentDisplayOrder = theCurrentSideIndexOfZis.bottom;
        totalNumber = sideNumberOfZis.bottom;
        break;
      default:
        currentDisplayOrder = 0;
    }

    return thePositionManager.getPositionAndSizeHelper(displaySideString, currentDisplayOrder, totalNumber/*, isCreationList: displayZiInCreationList*/);
  }

  void setFrameWidth(double width) {
    frameWidth = width;
    theFrameHeightY = frameWidth * FrameHeightToWidthRatio;
  }

  // Stay matching to ZiOrCharSize enum
  // non-characters or strokes
  static List<double> ZiSizes = [
    0.04,
    0.18 * 1.1,    //1.3,
    0.14,
    0.12,
    0.1,
    0.06,
    0.06, // 0.08
    0.08,
    0.08
  ];

  double getZiSize(int ziSizeIndex) {
    return frameWidth * ZiSizes[ziSizeIndex];
  }

  // standard chars
  static List<double> CharFontSizes =  [
    1.1 * 0.04,
    1.1 * 0.18 * 1.1,    //1.3,
    1.1 * 0.14,
    1.1 * 0.12,
    1.1 * 0.1,
    1.1 * 0.06,
    1.1 * 0.08,
    1.1 * 0.08,
    1.1 * 0.05
  ];

  double getCharFontSize(int charFontSizeIndex) {
    return frameWidth * CharFontSizes[charFontSizeIndex];
  }

  static List<double> ZiLineWidth = [
    0.069,
    0.069 * 1.1,    //1.3,  //5.0,
    0.069,  //4.0,
    0.069,  //3.75,
    0.069,  //3.5,
    0.069,  //1.0,
    0.069,  //2.0,
    0.069,  //1.4,
    0.069   //1.0
  ];

  double getZiLineWidth(int ziLineWidthIndex) {
    var ziSize = getZiSize(ziLineWidthIndex);
    return ziSize * ZiLineWidth[ziLineWidthIndex];
  }

  void resetPositionIndex() {
    theCurrentSideIndexOfZis.left = 0;
    theCurrentSideIndexOfZis.right = 0;
    theCurrentSideIndexOfZis.upper = 0;
    theCurrentSideIndexOfZis.bottom = 0;
  }

  void updatePositionIndex(ZiListType listType, int memberZiId) {
    String displaySideString;
    if (listType == ZiListType.zi) {
      var memberZi = theZiManager.getZi(memberZiId);
      displaySideString = Utility.checkAndUpdateOneCharSideForLessonTwo(
          memberZiId, memberZi.displaySide);
    }
    else if (listType == ZiListType.searching) {
      displaySideString = theSearchingZiList[memberZiId].displaySide;
    }

    switch (displaySideString) {
      case "l":
        theCurrentSideIndexOfZis.left = theCurrentSideIndexOfZis.left  + 1;
        break;
      case "r":
        theCurrentSideIndexOfZis.right = theCurrentSideIndexOfZis.right + 1;
        break;
      case "u":
        theCurrentSideIndexOfZis.upper = theCurrentSideIndexOfZis.upper + 1;
        break;
      case "b":
        theCurrentSideIndexOfZis.bottom = theCurrentSideIndexOfZis.bottom + 1;
        break;
      default:
        break;
    }
  }

  static Rect getLessonBoxPosition(int internalLessonId, double transYPosition){
    var levelLessonPair = LevelManager.getLevelLessonPair(internalLessonId);
    var levelId = levelLessonPair.levelId;
    var lessonId = levelLessonPair.lessonId;
    var numberOfLessons =    theNumberOfLessonsInLevels[levelId - 1];

    var firstXWithTwoMembers = 75.0;
    var firstXWithThreeMembers = 5.0;
    var xGapForSevenTotalMax = 30.0;
    var widthForSevenTotalMax = 100.0;
    var heightForSevenTotalMax = 100.0;

    var x = 0.0;
    var y = transYPosition;
    var width = 0.0;
    var height = 0.0;

    if (numberOfLessons <= 15) {
      for (var i = 1; i <= lessonId; i++) {
        if (i == 1) {
          x = firstXWithTwoMembers;
        }
        else if (i == 6 || i == 11) {
          x = firstXWithTwoMembers;
          //y += heightForSevenTotalMax //* 0.5
          //y += yGapForSevenTotalMax //* 0.5
        }
        else if (i == 3 || i == 8 || i == 13) {
          x = firstXWithThreeMembers;
          //y += heightForSevenTotalMax //* 0.5
          //y += yGapForSevenTotalMax //* 0.5
        }
        else {
          x += widthForSevenTotalMax;
          x += xGapForSevenTotalMax;
        }
      }

      width = widthForSevenTotalMax;
      height = heightForSevenTotalMax; //* 0.5
    }

    return Rect.fromLTWH(x, y, width, height);
  }

  static int NotARootZiId = 10000;

  int getRootZiDisplayIndex(int rootZiId) {
    if (rootZiId >= 731 && rootZiId <= 749) {
      return rootZiId - 731;
    }
    else if(rootZiId > 749 && rootZiId <= 755) {
      return rootZiId - 731 + 1;
    }
    else {
      return NotARootZiId;
    }
  }

  bool rootIndexHasZi(int i, List<int>realGroupMembers) {
    var ziId = 0;
    if (i >=0 && i < 19) {
      ziId = 731 + i;
      return realGroupMembers.contains(ziId);
    }
    else if (i == 19) {
      return false;
    }
    else if (i >= 20 && i <= 25) {
      ziId = 731 + i - 1;
      return realGroupMembers.contains(ziId);
    }
  }

  /*
  PositionAndSize getReviewRootPositionAndSize(int index) {
    var posi = PositionAndSize(0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

    posi.width = getZiSize(ZiOrCharSize.sideSmallSize) / 1.3;
    posi.height = getZiSize(ZiOrCharSize.sideSmallSize) / 1.3;
    posi.charFontSize = getCharFontSize(ZiOrCharSize.sideSmallSize) / 1.3;
    posi.lineWidth = getZiLineWidth(ZiOrCharSize.sideSmallSize) / 1.3;

    if (index >=0 && index < 10) {
      posi.transY = 150.0;
      posi.transX = 10.0 + 40.0 * index;
    }
    else if (index >= 10 && index < 19) {
      posi.transY = 215.0;
      posi.transX = 10.0 + 10.0 + (index - 10) * 40.0;
    }
    else if (index >= 19 && index < 26) {
      posi.transY = 280.0;
      posi.transX = 10.0 + 10.0 + 30.0 + (index - 19) * 40.0;
    }

    return posi;
  }
   */

  PositionAndSize getPositionAndSizeHelper(String side, int order, int totalNumber) {
    var posi = PositionAndSize(0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

    var sideZiSize = 0.0;
    var maximumNumber = totalNumber;
    if (totalNumber == 4) {
      maximumNumber = totalNumber;
      sideZiSize = getZiSize(ZiOrCharSize.sideMediumSize);
      posi.charFontSize = getCharFontSize(ZiOrCharSize.sideMediumSize);
      posi.lineWidth = getZiLineWidth(ZiOrCharSize.sideMediumSize);
    }
    else if (totalNumber > theSmallMaximumNumber) {
      maximumNumber = theBigMaximumNumber;
      // TODO: why need theSideZiSize here instead of using posi. directly
      sideZiSize = getZiSize(ZiOrCharSize.sideSmallSize);
      posi.charFontSize = getCharFontSize(ZiOrCharSize.sideSmallSize);
      posi.lineWidth = getZiLineWidth(ZiOrCharSize.sideSmallSize);
    }
    else {
      sideZiSize = getZiSize(ZiOrCharSize.sideLargeSize); //theZiSizes[ZiOrCharSize.sideLargeSize];  //theSideZiLargeSize      // default
      posi.charFontSize = getCharFontSize(ZiOrCharSize.sideLargeSize);
      posi.lineWidth = getZiLineWidth(ZiOrCharSize.sideLargeSize);
    }

    if (side == "m")
    {
      // TODO: calcu sizes
      posi.width = getZiSize(ZiOrCharSize.centerSize);
      posi.height = getZiSize(ZiOrCharSize.centerSize);
      posi.charFontSize = getCharFontSize(ZiOrCharSize.centerSize);
      posi.lineWidth = getZiLineWidth(ZiOrCharSize.sideLargeSize);
    }
    else
    {
      posi.width = sideZiSize;
      posi.height = sideZiSize;
    }

    var xMiddle = frameWidth / 2.0 + FrameLeftEdgeSize;
    var yMiddle = xMiddle * FrameHeightToWidthRatio + FrameTopEdgeSize; /*theTopEdgeSize*/
    var xMiddleToLine = frameWidth / 6.0;
    var yMiddleToLine = xMiddle * FrameHeightToWidthRatio / 6.0;

    if (side == "m")
    {
      posi.transX = xMiddle - (getZiSize(ZiOrCharSize.centerSize) / 2.0);
      // note: 1.4 to make the center char to show a little bit higher than middle
      posi.transY = yMiddle - (getZiSize(ZiOrCharSize.centerSize) / 2.0);
    }
    else if (side == "l")
    {
      if (maximumNumber <= theSmallMaximumNumber) {
        posi.transX = xMiddle - xMiddleToLine - frameWidth / 6.0 - sideZiSize / 2.0;
        var extraYHeight = 0.0;
        var index = 0;
        index = order ~/ 2;
        if (order % 2 == 0) {   // add above
          extraYHeight = (sideZiSize * 1.25) + (sideZiSize * 1.5 * index);  // 1.15=0.15+1.0; 1.3=0.3+1.0
          posi.transY = yMiddle - extraYHeight;
        }
        else {
          extraYHeight = (sideZiSize * 0.25) + (sideZiSize * 1.5 * index);
          posi.transY = yMiddle + extraYHeight;
        }

        if (maximumNumber == 1 || maximumNumber == 3) {
          posi.transY = posi.transY + (sideZiSize * 0.75);
        }
      }
      else if (maximumNumber == 4) {
        var extraXWidth = frameWidth / 10.0 + sideZiSize  / 2.0;
        var xShift = sideZiSize * 1.2; //    / 2.0
        posi.transX = xMiddle - xMiddleToLine - extraXWidth - xShift;

        var extraYHeight = 0.0;

        // max number of first column/row = 4
        var index = 0;
        index = order ~/ 2;
        var yShift = sideZiSize * 0.8;
        if (order % 2 == 0) {   // add above
          extraYHeight = (sideZiSize * (1.25 - 0.75)) + (sideZiSize * 1.85 * index); // 1.15=0.15+1.0; 1.3=0.3+1.0
          posi.transY = yMiddle - extraYHeight - yShift;
        }
        else {
          extraYHeight = (sideZiSize * (0.25 + 1.0)) + (sideZiSize * 1.85 * index);
          posi.transY = yMiddle + extraYHeight - yShift;
        }
      }
      else {
        var extraXWidth = 0.0;
        if (order >= theMediumMaximumNumber) {
          extraXWidth = frameWidth / 10.0 + sideZiSize  / 2.0;
        }
        else {
          extraXWidth = frameWidth / 4.0  + sideZiSize / 2.0; // 1/4 = 1/12 + 1/6
        }
        posi.transX = xMiddle - xMiddleToLine - extraXWidth;

        var extraYHeight = 0.0;

        // max number of first column/row = 4
        var index = 0;
        var newOrder = order;
        if (newOrder >= theMediumMaximumNumber) {
          newOrder = newOrder - theMediumMaximumNumber;
        }
        index = newOrder ~/ 2;
        if (newOrder % 2 == 0) {   // add above
          extraYHeight = (sideZiSize * (1.25 - 0.75)) + (sideZiSize * 1.85 * index) ; // 1.15=0.15+1.0; 1.3=0.3+1.0
          posi.transY = yMiddle - extraYHeight;
        }
        else {
          extraYHeight = (sideZiSize * (0.25 + 1.0)) + (sideZiSize * 1.85 * index);
          posi.transY = yMiddle + extraYHeight;
        }
      }
    }
    else if (side == "r")
    {
      if (maximumNumber <= theSmallMaximumNumber) {
        posi.transX = xMiddle + xMiddleToLine + frameWidth / 6.0 - sideZiSize / 2.0;
        var extraYHeight = 0.0;
        var index = 0;
        index = order ~/ 2;
        if (order % 2 == 0) {   // add above
          extraYHeight = (sideZiSize * 1.25) + (sideZiSize * 1.5 * index);  // 1.15=0.15+1.0; 1.3=0.3+1.0
          posi.transY = yMiddle - extraYHeight;
        }
        else {
          extraYHeight = (sideZiSize * 0.25) + (sideZiSize * 1.5 * index);
          posi.transY = yMiddle + extraYHeight;
        }

        if (maximumNumber == 1 || maximumNumber == 3) {
          posi.transY = posi.transY + (sideZiSize * 0.75);
        }

        return posi;
      }
      else if (maximumNumber == 4) {
        var extraXWidth = frameWidth / 4.0  - sideZiSize / 2.0;
        var xShift = sideZiSize / 8.0;
        posi.transX = xMiddle + xMiddleToLine + extraXWidth - xShift;

        var extraYHeight = 0.0;

        // max number of first column/row = 4
        var index = 0;
        index = order ~/ 2;
        var yShift = sideZiSize * 0.8;
        if (order % 2 == 0) {   // add above
          extraYHeight = (sideZiSize * (1.25-0.75)) + (sideZiSize * 1.85 * index);
          posi.transY = yMiddle - extraYHeight - yShift;
        }
        else {
          extraYHeight = (sideZiSize * (0.25 + 1.0)) + (sideZiSize * 1.85 * index);
          posi.transY = yMiddle + extraYHeight - yShift;
        }
      }
      else {
        var extraXWidth = 0.0;
        if (order >= theMediumMaximumNumber) {
          extraXWidth = frameWidth / 10.0 - sideZiSize / 2.0;
        }
        else {
          extraXWidth = frameWidth / 4.0  - sideZiSize / 2.0; // 1/12 + 1/6
        }
        posi.transX = xMiddle + xMiddleToLine + extraXWidth;

        var extraYHeight = 0.0;

        // max number of first column/row = 4
        var index = 0;
        var newOrder = order;
        if (newOrder >= theMediumMaximumNumber) {
          newOrder = newOrder - theMediumMaximumNumber;
        }
        index = newOrder ~/ 2;
        if (newOrder % 2 == 0) {   // add above
          extraYHeight = (sideZiSize * (1.25-0.75)) + (sideZiSize * 1.85 * index);  // 1.15=0.15+1.0; 1.3=0.3+1.0
          posi.transY = yMiddle - extraYHeight;
        }
        else {
          extraYHeight = (sideZiSize * (0.25 + 1.0)) + (sideZiSize * 1.85 * index);
          posi.transY = yMiddle + extraYHeight;
        }
      }
    }
    else if (side == "u")
    {
      if (maximumNumber <= theSmallMaximumNumber) {
        posi.transY = yMiddle - yMiddleToLine - theFrameHeightY / 6.0 - sideZiSize * 1.5;
        var extraXWidth = 0.0;
        var index = 0;
        index = order ~/ 2;
        if (order % 2 == 0) {   // add above
          extraXWidth = (sideZiSize * 1.25) + (sideZiSize * 1.5 * index);  // 1.15=0.15+1.0; 1.3=0.3+1.0
          posi.transX = xMiddle - extraXWidth;
        }
        else {
          extraXWidth = (sideZiSize * 0.25) + (sideZiSize * 1.5 * index);
          posi.transX = xMiddle + extraXWidth;
        }

        if (maximumNumber == 1 || maximumNumber == 3) {
          posi.transX = posi.transX + (sideZiSize * 0.75);
        }
      }
      else if (maximumNumber == 4) {
        var extraYHeight = theFrameHeightY / 4.4 /*3.5*/  + sideZiSize * 1.5; // 1/12 + 1/6
        var yShift = sideZiSize / 2.0;
        posi.transY = yMiddle - yMiddleToLine - extraYHeight + yShift;

        var extraXWidth = 0.0;

        // max number of first column/row = theSmallMaximumNumber
        var index = order / 2;
        var xShift = sideZiSize * 0.8;
        if (order % 2 == 0) {   // add above
          extraXWidth = (sideZiSize * (1.25-0.75)) + (sideZiSize * 1.25 * index);  // 1.15=0.15+1.0; 1.3=0.3+1.0
          posi.transX = xMiddle - extraXWidth - xShift;
        }
        else {
          extraXWidth = (sideZiSize * (0.25 + 0.5)) + (sideZiSize * 1.25 * index);
          posi.transX = xMiddle + extraXWidth - xShift;
        }
      }
      else {
        var extraYHeight = 0.0;
        if (order >= theMediumMaximumNumber) {
          extraYHeight = theFrameHeightY / 10.0 /*6.8*/ + sideZiSize * 1.5;   //14.0
        }
        else {
          extraYHeight = theFrameHeightY / 4.4 /*3.5*/  + sideZiSize * 1.5; // 1/12 + 1/6
        }
        posi.transY = yMiddle - yMiddleToLine - extraYHeight;

        var extraXWidth = 0.0;

        // max number of first column/row = theSmallMaximumNumber
        var index = 0;
        var newOrder = order;
        if (newOrder >= theMediumMaximumNumber) {
          newOrder = newOrder - theMediumMaximumNumber;
        }
        index = newOrder ~/ 2;
        if (newOrder % 2 == 0) {   // add above
          extraXWidth = (sideZiSize * (1.25-0.75)) + (sideZiSize * 1.25 * index);  // 1.15=0.15+1.0; 1.3=0.3+1.0
          posi.transX = xMiddle - extraXWidth;
        }
        else {
          extraXWidth = (sideZiSize * (0.25 + 0.5)) + (sideZiSize * 1.25 * index);
          posi.transX = xMiddle + extraXWidth;
        }
      }
    }
    else if (side == "b")
    {
      if (maximumNumber <= theSmallMaximumNumber) {
        posi.transY = yMiddle + yMiddleToLine + theFrameHeightY / 5.5 + sideZiSize / 2.0;
        var extraXWidth = 0.0;
        var index = 0;
        index = order ~/ 2;
        if (order % 2 == 0) {   // add above
          extraXWidth = (sideZiSize * 1.25) + (sideZiSize * 1.5 * index);  // 1.15=0.15+1.0; 1.3=0.3+1.0
          posi.transX = xMiddle - extraXWidth;
        }
        else {
          extraXWidth = (sideZiSize * 0.25) + (sideZiSize * 1.5 * index);
          posi.transX = xMiddle + extraXWidth;
        }

        if (maximumNumber == 1 || maximumNumber == 3) {
          posi.transX = posi.transX + (sideZiSize * 0.75);
        }
      }
      else if (maximumNumber == 4) {
        //var extraYHeight = CGFloat(0.0)
        var extraYHeight = theFrameHeightY / 3.8 + sideZiSize / 2.0;
        var yShift = sideZiSize / 2.0;
        posi.transY = yMiddle + yMiddleToLine + extraYHeight - yShift;

        var extraXWidth = 0.0;

        // max number of first column/row = 4
        var index = 0;
        index = order ~/ 2;
        var xShift = sideZiSize * 0.8;
        if (order % 2 == 0) {   // add above
          extraXWidth = (sideZiSize * (1.25 - 0.75)) + (sideZiSize * 1.25 * index);
          posi.transX = xMiddle - extraXWidth - xShift;
        }
        else {
          extraXWidth = (sideZiSize * (0.25 + 0.75)) + (sideZiSize * 1.25 * index);
          posi.transX = xMiddle + extraXWidth - xShift;
        }
      }
      else {
        var extraYHeight = 0.0;
        if (order >= theMediumMaximumNumber) {
          extraYHeight = theFrameHeightY / 10.0 + sideZiSize / 2.0;
        }
        else {
          extraYHeight = theFrameHeightY / 3.8  + sideZiSize / 2.0; // 1/12 + 1/6
        }
        posi.transY = yMiddle + yMiddleToLine + extraYHeight;

        var extraXWidth = 0.0;

        // max number of first column/row = 4
        var index = 0;
        var newOrder = order;
        if (newOrder >= theMediumMaximumNumber) {
          newOrder = newOrder - theMediumMaximumNumber;
        }
        index = newOrder ~/ 2;
        if (newOrder % 2 == 0) {   // add above
          extraXWidth = (sideZiSize * (1.25 - 0.75)) + (sideZiSize * 1.25 * index);  // 1.15=0.15+1.0; 1.3=0.3+1.0
          posi.transX = xMiddle - extraXWidth;
        }
        else {
          extraXWidth = (sideZiSize * (0.25 + 0.75)) + (sideZiSize * 1.25 * index);
          posi.transX = xMiddle + extraXWidth;
        }
      }
    }

    return posi;
  }

  static Map<int, PositionAndSize> getNavigationPathPosi(ZiListType listType, int ziId, bool isFromReviewPage, double sizeRatio) {
    var posi = thePositionManager.getTreeNavigationPosi(sizeRatio);
    Map<int, PositionAndSize> naviMap = Map();
    getOneNaviationPathPosi(0, listType, ziId, posi, isFromReviewPage, naviMap, sizeRatio);

    return naviMap;
  }

  static getOneNaviationPathPosi(int recurLevel, ZiListType listType, int id, PositionAndSize posi, bool isFromReviewPage, Map<int, PositionAndSize> naviMap, double sizeRatio) {
    var zi;
    if (listType == ZiListType.zi) {
      zi = theZiManager.getZi(id);
    }
    else if (listType == ZiListType.searching) {
      zi = theSearchingZiList[id];
    }

    if (zi.id != 1) { // till hit root
      var newRecurLevel = recurLevel + 1;
      var parentId = zi.parentId;

      getOneNaviationPathPosi(newRecurLevel, listType, parentId, posi, isFromReviewPage, naviMap, sizeRatio);
    }

    // for lesson, skip those pseudo ones.
    if (listType == ZiListType.searching || isFromReviewPage /*|| (!Utility.isPseudoNonCharRootZiId(id) &&
          !Utility.isPseudoRootZiId(id))*/) {
      if (zi.id != 1) {
        posi.transX += 18.0 * sizeRatio; // 23.0
        posi.transX += 36.0 * sizeRatio; //15.0
      }

      naviMap[id] = copyPositionAndSize(posi);
    }
  }

  static PositionAndSize getDicAnimatedZiPositionAndSize(double sizeRatio) {
    var size = thePositionManager.getCharFontSize(ZiOrCharSize.centerSize); //1.3
    var yPosi = 20.0;
    if (sizeRatio > 1.6) {
      yPosi = 5.0;
      sizeRatio /= 1.2;
    }
    return PositionAndSize(90.0, yPosi, size*sizeRatio, size*sizeRatio, size*sizeRatio, 3.5*sizeRatio);
  }

  static PositionAndSize getDicAnimationBrushPositionAndSize(PositionAndSize ziPosi, double sizeRatio) {
    return PositionAndSize(ziPosi.transX + ziPosi.width, ziPosi.transY + ziPosi.height, 25.0*sizeRatio, 25.0*sizeRatio, 25.0*sizeRatio, 2.0*sizeRatio);
  }
}
