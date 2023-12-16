import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/dictionary.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/foundation.dart';

class PracticeSheetPainter extends BasePainter {
  BuildContext context;
  String ziList;
  bool gridShowZi;
  //final isWebMobile = kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android);

  PracticeSheetPainter(String ziList, double screenWidth, bool gridShowZi) {
    this.ziList = ziList;
    this.width = screenWidth;
    this.gridShowZi = gridShowZi;
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
    DrawSheet(ziList, gridShowZi);
  }

  DrawSheet(String zis, bool gridShowZi) {
    var xStartPosi = 150.0;
    var yStartPosi = 25.0;
    var fontSize = 40.0;
    var pinyinStart = 20.0;
    var pinyinYShift = 5.0;
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
          var gridShowZiSpace = 0.0;
          if (!gridShowZi) {
            displayTextWithValue(
                oneWord, pinyinStart, posi.transY + pinyinYShift,
                posi.charFontSize / 2.0, Colors.black, false);
            gridShowZiSpace += 30.0;
          }
          var pinyin = searchingZi.pinyin;
          var index = pinyin.indexOf('/');
          if (index > 0) {
            pinyin = pinyin.substring(0, index);
          }

          displayTextWithValue(
              pinyin, pinyinStart + gridShowZiSpace, posi.transY + pinyinYShift,
              posi.charFontSize / 2.0, Colors.black, false);
          compPosi = PositionAndSize(
              pinyinStart, posi.transY + compYShift + (fontSize / 2.8),
              fontSize / 2.8, fontSize / 2.8, fontSize / 2.8, 0.0);
          displayComponentsOrStrokes(searchingZi.id, compPosi, false);
        }
      }
      else {
        oneWord = null;
      }

      if (!gridShowZi) {
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

    displayTextWithValue("汉字练习纸生成器：https://hanzishu.com", xStartPosi, posi.transY + yExtraSpace, posi.charFontSize/4.0, Colors.blueGrey, false);
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
