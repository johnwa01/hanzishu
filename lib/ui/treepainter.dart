import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import 'package:hanzishu/engine/lesson.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/generalmanager.dart';
import 'package:hanzishu/ui/positionmanager.dart';

class TreePainter extends BasePainter {
  static double FrameHeightToWidthRaitio = 1.2;
  static double FrameLeftEdgeSize = 4.0;
  static double FrameTopEdgePosition = 35.0;
  static double FrameLineWidth = 1.0;
  int theCreatedNumber = 0;
  var theTotalSideNumberOfZis = NumberOfZis(0, 0, 0, 0);
  var theDefaultTransparentFillColor = Colors
      .cyan; //UIColor(red: 0.7294, green: 0.9882, blue: 0.8941, alpha: 0.5);

  Color lineColor;
  Color completeColor;
  int centerId;
  //double completePercent;
  double width;
  //Size canvasSize;
  double screenWidth;
  //double frameWidth;

  TreePainter({
    this.lineColor, this.completeColor, this.centerId, /*this.completePercent,*/ this.width
  });

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;

    thePositionManager.setFrameWidth(getFrameWidth());
    drawFrameWithColors(
        getFrameWidth(), FrameLeftEdgeSize, FrameTopEdgePosition, Colors.cyan,
        Colors.lime, FrameLineWidth);
    drawZiGroup(centerId);
  }

  double getFrameWidth() {
    return width - 10.0;
  }

  void drawOnePartialFrameWithColors(List<double> list) {
    var path = Path();
    path.moveTo(list[0], list[1]);
    path.lineTo(list[2], list[3]);
    path.moveTo(list[4], list[5]);
    path.lineTo(list[6], list[7]);
    path.lineTo(list[8], list[9]);

    drawShape(path, Colors.amber, 2.0);
  }

  void drawFrameWithColors(double width, double leftEdge, double topEdge,
      MaterialColor centerColor, MaterialColor sideColor, double widthOfLine) {
    var x1 = leftEdge;
    double width1 = width / 3.0;
    var x2 = x1 + width1;
    var x3 = x2 + width1;
    var x4 = x3 + width1;

    double height = width * FrameHeightToWidthRaitio;
    var y1 = topEdge;
    var height1 = height / 3.01;
    var y2 = y1 + height1;
    var y3 = y2 + height1;
    var y4 = y3 + height1;

    List<double> list1 = [x1, y1, x4, y1, x3, y2, x2, y2, x1, y1];
    drawOnePartialFrameWithColors(list1);

    List<double> list2 = [x4, y1, x4, y4, x3, y3, x3, y2, x4, y1];
    drawOnePartialFrameWithColors(list2);

    List<double> list3 = [x4, y4, x1, y4, x2, y3, x3, y3, x4, y4];
    drawOnePartialFrameWithColors(list3);

    List<double> list4 = [x1, y4, x1, y1, x2, y2, x2, y3, x1, y4];
    drawOnePartialFrameWithColors(list4);

    List<double> list5 = [x2, y2, x3, y2, x3, y3, x2, y3, x2, y2];
    drawOnePartialFrameWithColors(list5);
  }

  void drawZiGroup(int id) {
    var ziColor = Colors.brown;

    // one center zi first
    var posiSize = theLessonManager.getCenterPositionAndSize(); //thePositionManager.getPositionAndSizeHelper("m", 1, BigMaximumNumber/*, isCreationList: true*/);

    var withPinyin = true;

    theCurrentCenterZiId = id;
    theCreatedNumber = 0;

    thePositionManager.resetPositionIndex();

    // get its real members
    var groupMembers = theLessonManager.getRealGroupMembers(id);

    theTotalSideNumberOfZis = theZiManager.getNumberOfZis(groupMembers);

    for (var memberZiId in groupMembers) {
      var posiSize2 = theLessonManager.getPositionAndSize(memberZiId, theTotalSideNumberOfZis/*, isCreationList: false*/);

      var memberZiLearned = GeneralManager.hasZiCompleted(memberZiId, theHittestState, theCurrentLessonId);

      var isSingleColor = false;
      if (theCurrentCenterZiId == 1) { // the root graph
        isSingleColor = true;
      }
      var frameFillColor = Colors.blue; //Colors.white;  //TODO: white and black are treated differently from other colors.
      if (memberZiId == thePreviousCenterZiId) {
        frameFillColor = theDefaultTransparentFillColor;
      }

      drawRootZi(memberZiId, posiSize2.transX, posiSize2.transY, posiSize2.width, posiSize2.height, posiSize2.charFontSize, ziColor, isSingleColor, posiSize2.lineWidth, /*createFrame*/ true, /*hasRootZiLearned*/ memberZiLearned, withPinyin, frameFillColor);

      thePositionManager.updatePositionIndex(memberZiId);
    }

    GeneralManager.checkAndSetHasAllChildrenCompleted(id, theHittestState, theCurrentLessonId);

    // skip the center zi for id == 1, which is the default empty root zi.
    // the Chinese character zi "-" has an id of 170.
    if (id > 1) {
      var rootZiLearned = GeneralManager.hasZiCompleted(id, theHittestState, theCurrentLessonId);
      drawRootZi(id, posiSize.transX, posiSize.transY, posiSize.width, posiSize.height, posiSize.charFontSize, ziColor, /*isSingleColor:*/ true, posiSize.lineWidth, /*createFrame:*/ true, rootZiLearned, withPinyin, Colors.cyan /*TODO*/);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}