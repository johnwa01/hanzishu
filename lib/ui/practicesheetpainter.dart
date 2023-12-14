
import 'package:flutter/material.dart';
import 'package:hanzishu/data/searchingzilist.dart';
import 'dart:ui';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/dictionary.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/data/firstzilist.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';

class PracticeSheetPainter extends BasePainter {
  Color lineColor;
  //double screenWidth; == width in basepainter
  //PracticeSheetStage dicStage;
  int firstZiIndex;  // different meaning for different stage
  int searchingZiIndex;
  BuildContext context;
  int compoundZiCurrentComponentId;
  ZiListType ziListType;
  bool showBreakoutDetails;
  String ziList;

  //static int firstZiCount = theFirstZiList.length; // started with 0
  //static int totalSearchingZiCount = theSearchingZiList.length; // started with 0. first one is not real.
  //static int minCharsForStrokeIndex = 15;

  //Map<int, PositionAndSize> dicBreakoutPositions = Map();

  PracticeSheetPainter(String ziList, /*Color lineColor,*/ double screenWidth/*, int firstZiIndex, int searchingZiIndex, BuildContext context, int compoundZiCurrentComponentId, ZiListType ziListType, bool shouldDrawCenter, bool showBreakoutDetails*/) {
   /*
    this.lineColor = lineColor;
    */
    this.ziList = ziList;
    this.width = screenWidth;
    /*
    //this.dicStage = dicStage;

    this.firstZiIndex = firstZiIndex;
    this.searchingZiIndex = searchingZiIndex;
    this.context = context;
    this.compoundZiCurrentComponentId = compoundZiCurrentComponentId;
    this.ziListType = ziListType;
    this.shouldDrawCenter = shouldDrawCenter;
    this.showBreakoutDetails = showBreakoutDetails;
    */
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

    //else if (this.dicStage == PracticeSheetStage.detailedzi) {
      //DisplayNavigationPath(PracticeSheetStage.detailedzi);
      //displayTextWithValue("Character:", 10.0, 5.0, 25.0, Colors.blueAccent);
      DrawSheet(ziList/*"汉字树练习纸"*/);
    //}
  }

  DrawSheet(String zis) {
//    thePositionManager.setFrameWidth(getFrameWidth());

    //var defaultFontSize = applyRatio(25.0);
    //NOTE: match the definitions in dictionarysearchingpage.dart

    //var detailedZi = theSearchingZiList[ziIndex];

    var xStartPosi = 150.0;
    var yStartPosi = 25.0;
    var fontSize = 40.0;
    var pinyinStart = 20.0;
    var pinyinYShift = 10.0;
    var compYShift = 18.0;
    var oneZiSpace = fontSize + 5.0;
    var httpExtraStart = 110.0;
    var yExtraSpace = 10.0;

    var posi = PositionAndSize(xStartPosi, yStartPosi, fontSize, fontSize, fontSize, 0.0);
    var oneWord;
    var length = zis.length;
    SearchingZi searchingZi;
    var compPosi;

    for (int i = 0; i < 10; i++) {
      posi.transX = xStartPosi;
      if (i < length) {
        oneWord = zis[i];
        searchingZi = ZiManager.findSearchingZiFromChar(oneWord);
        if (searchingZi == null) {
          oneWord = null;
        }
        else {
          displayTextWithValue(
              searchingZi.pinyin, pinyinStart, posi.transY + pinyinYShift,
              posi.charFontSize / 2.0, Colors.black, false);
          compPosi = PositionAndSize(
              pinyinStart, posi.transY + compYShift + (fontSize / 2.5),
              fontSize / 2.5, fontSize / 2.5, fontSize / 2.5, 0.0);
          displayComponentsOrStrokes(searchingZi.id, compPosi, false);
        }
      }
      else {
        oneWord = null;
      }

      DrawOneGridAndZi(oneWord, Colors.black, posi, true);
      posi.transX += oneZiSpace;
      DrawOneGridAndZi(oneWord, Colors.grey, posi, true);
      posi.transX += oneZiSpace;
      DrawOneGridAndZi(oneWord, Colors.grey, posi, true);
      posi.transX += oneZiSpace;
      DrawOneGridAndZi(oneWord, Colors.grey, posi, false);
      posi.transX += oneZiSpace;
      DrawOneGridAndZi(oneWord, Colors.grey, posi, false);

      posi.transY += (fontSize + yExtraSpace);
    }

    displayTextWithValue("https://hanzishu.com", xStartPosi + httpExtraStart, posi.transY + yExtraSpace, posi.charFontSize/4.0, Colors.grey, false);
  }

  DrawOneGridAndZi(String oneZi, Color ziColor,  PositionAndSize posi, bool drawZi) {
    var posiOri = PositionAndSize(posi.transX, posi.transY, posi.width, posi.height, posi.charFontSize, posi.lineWidth);

    posiOri.transY += posiOri.charFontSize * 0.30;
    DrawZiGrid(posiOri);

    if (drawZi && oneZi != null) {
      displayTextWithValue(oneZi, posi.transX, posi.transY, posi.charFontSize, ziColor, false);
    }
  }

  DrawZiGrid(PositionAndSize posi) {
    drawOneFrameLineWithColor([posi.transX, posi.transY, posi.transX + posi.charFontSize, posi.transY], Colors.lightBlue, 1.0);
    drawOneFrameLineWithColor([posi.transX + posi.charFontSize, posi.transY, posi.transX + posi.charFontSize, posi.transY + posi.charFontSize], Colors.lightBlue, 1.0);
    drawOneFrameLineWithColor([posi.transX + posi.charFontSize, posi.transY + posi.charFontSize, posi.transX, posi.transY + posi.charFontSize], Colors.lightBlue, 1.0);
    drawOneFrameLineWithColor([posi.transX, posi.transY + posi.charFontSize, posi.transX, posi.transY], Colors.lightBlue, 1.0);
    drawOneFrameLineWithColor([posi.transX, posi.transY, posi.transX + posi.charFontSize, posi.transY + posi.charFontSize], Colors.lightBlue, 1.0);
    drawOneFrameLineWithColor([posi.transX + posi.charFontSize, posi.transY, posi.transX, posi.transY + posi.charFontSize], Colors.lightBlue, 1.0);
  }

  double getFrameWidth() {
    return width - 10.0;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
