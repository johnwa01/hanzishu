import 'package:flutter/material.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/engine/levelmanager.dart';
import 'package:hanzishu/engine/zimanager.dart';

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
      transX = transX;
      transY = transY;
      width = width;
      height = height;
      charFontSize = charFontSize;
      lineWidth = lineWidth;
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
  static var topEdgeSize = XYLength(35.0);
  static var theLeftEdgeSize = XYLength(4.0);
  static var theFrameHeightToWidthRatio = 1.2;

  var frameWidth = 0.0;
  var theFrameHeightY = 0.0; // = theFrameWidth * theFrameHeightToWidthRatio

  init() {}

  PositionAndSize getPositionAndSize(int memberZiId, NumberOfZis sideNumberOfZis/*, isCreationList: Bool*/) {
    var currentDisplayOrder = 0;
    var totalNumber = theBigMaximumNumber;

    //var displayZiInCreationList = isCreationList

    var memberZi = theZiManager.getZi(memberZiId);
    String displaySideString = memberZi.displaySide;
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
    theFrameHeightY = frameWidth * theFrameHeightToWidthRatio;
  }

  // Stay matching to ZiOrCharSize enum
  // non-characters or strokes
  static List<double> ZiSizes = [
    0.04,
    0.18,
    0.14,
    0.12,
    0.1,
    0.06,
    0.08,
    0.08,
    0.08
  ];

  double getZiSize(int ziSizeIndex) {
    return frameWidth * ZiSizes[ziSizeIndex];
  }

  // standard chars
  static List<double> CharFontSizes =  [
    1.1 * 0.04,
    1.1 * 0.18,
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

  static List<double> theZiLineWidth = [
    0.069,
    0.069,  //5.0,
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
    return ziSize * theZiLineWidth[ziLineWidthIndex];
  }

  void resetPositionIndex() {
    theCurrentSideIndexOfZis.left = 0;
    theCurrentSideIndexOfZis.right = 0;
    theCurrentSideIndexOfZis.upper = 0;
    theCurrentSideIndexOfZis.bottom = 0;
  }

  void updatePositionIndex(int memberZiId) {
    var memberZi = theZiManager.getZi(memberZiId);
    String displaySideString = memberZi.displaySide;
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

    var firstXWithTwoMembers = xYLength(75.0);
    var firstXWithThreeMembers = xYLength(5.0);
    var xGapForSevenTotalMax = xYLength(30.0);
    var yGapForSevenTotalMax = xYLength(70.0);
    var widthForSevenTotalMax = xYLength(100.0);
    var heightForSevenTotalMax = xYLength(100.0);

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

    var xMiddle = frameWidth / 2.0 + theLeftEdgeSize;
    var yMiddle = xMiddle * theFrameHeightToWidthRatio + topEdgeSize; /*theTopEdgeSize*/
    var xMiddleToLine = frameWidth / 6.0;
    var yMiddleToLine = xMiddle * theFrameHeightToWidthRatio / 6.0;

    if (side == "m")
    {
      posi.transX = xMiddle - (getZiSize(ZiOrCharSize.centerSize) / 2.0);
      // note: 1.4 to make the center char to show a little bit higher than middle
      posi.transY = yMiddle - (getZiSize(ZiOrCharSize.centerSize) / 1.4);
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
          extraYHeight = theFrameHeightY / 14.0 /*6.8*/ + sideZiSize * 1.5;
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
}