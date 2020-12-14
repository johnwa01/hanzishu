import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import 'package:hanzishu/engine/lesson.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/generalmanager.dart';

class BasePainter extends CustomPainter{
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
  double completePercent;
  double width;

  int reviewStartLessonId;
  int reviewEndLessonId;

  var canvas;

  BasePainter({this.lineColor,this.completeColor,this.completePercent,this.width});
  @override
  void paint(Canvas canvas, Size size) {
    /*
    Paint line = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Paint complete = new Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    canvas.drawCircle(
        center,
        radius,
        line
    );

    double arcAngle = 2 * pi * (completePercent / 100);
    canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        arcAngle,
        false,
        complete
    );

    var paint1 = Paint()
      ..color = Color(0xff638965)
      ..style = PaintingStyle.fill;
    //a rectangle
    canvas.drawRect(Offset(100, 100) & Size(200, 200), paint1);

    TextSpan span = TextSpan(
        style: TextStyle(color: Colors.blue[800], fontSize: 24.0,
            fontFamily: 'Roboto'), text: "好");
    TextPainter tp = TextPainter(
        text: span, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(100.0, 100.0));
    */
  }

  void drawTriangle(Canvas canvas, Size size) {
    var paint4 = Paint();
    /*
    paint4.color = Colors.amber;
    paint4.strokeWidth = 5;
    canvas.drawLine(
        Offset(0, size.height / 2),
        Offset(size.width, size.height / 2),
        paint4
    );

    paint4.color = Colors.blue;
    paint4.style = PaintingStyle.stroke;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 4, paint4);

    paint4.color = Colors.green;
    */

    var path5 = Path();
    path5.moveTo(0.0, 0.0); //size.width / 3, size.height * 3 / 4);
    path5.lineTo(size.width / 2, size.height * 5 / 6);
    path5.lineTo(size.width * 3 / 4, size.height * 4 / 6);
    path5.close();
    Matrix4 matrix4 = Matrix4.identity();
    matrix4.scale(0.5, 0.5, 0);
    matrix4.translate(40.0, 20.0, 0.0);

    var path5b = path5.transform(matrix4.storage);
    canvas.drawPath(path5b, paint4);
  }

  void drawLine(double x1, double y1, double x2, double y2, MaterialColor ofColor, double widthOfLine ) {
    var paint = Paint();

    paint.color = ofColor; //Colors.amber;
    paint.strokeWidth = widthOfLine; //5;
    canvas.drawLine(
        Offset(x1, y1),
        Offset(x2, y2),
        paint
    );
  }

  void drawShape(Path path, MaterialColor ofColor, double widthOfLine) {
    var paint = Paint();
    paint.color = ofColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = widthOfLine;

    canvas.drawPath(path, paint);
  }

  Path createZiPathBase(List<double> ziStrokes)
  {
    // width is always 1.0
    var height = 1.0; //* 1.2
    var path = Path();

    var i = 0;
    while (i < ziStrokes.length) {
      if (ziStrokes[i] == 4.0)  // start
      {
        path.moveTo(ziStrokes[i+1], ziStrokes[i+2] * height);
      }
      else if (ziStrokes[i] == 8.0)  // end
      {
        path.lineTo(ziStrokes[i+1], ziStrokes[i+2] * height);
      }

      i = i + 3;
    }
/*
    var path5 = Path();
    path5.moveTo(0.0, 0.0); //size.width / 3, size.height * 3 / 4);
    path5.lineTo(0.4, 0.7);
    path5.lineTo(0.8, 0.9);
    path5.close();
*/
    return path;
  }

  Path transformZiPath(Path ziPath, double transX, double transY) {
    Matrix4 matrix = Matrix4.identity();
    matrix.translate(transX, transY, 0.0);

    return ziPath.transform(matrix.storage);
  }

  Path transformZiPathScale(Path ziPath, double scaleX, double scaleY) {
    Matrix4 matrix = Matrix4.identity();
    matrix.scale(scaleX, scaleY, 0);

    return ziPath.transform(matrix.storage);
  }

  void createSubZi(MaterialColor ofColor, double widthOfLine, /*int hitTestId,*/ Path path)
  {
    var paint = Paint();
    paint.color = ofColor; //Colors.amber;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = widthOfLine;
    canvas.drawPath(path, paint);
  }

  void buildBaseZi(int id, double transX, double transY, double widthX, double heightY, MaterialColor ofColor, /*int hitTestId, int recursiveLevel,*/ bool isSingleColor, double ziLineWidth)
  {
    var zi = theZiManager.getZi(id);
    var ziStrokes = zi.strokes;
    var pathZi = createZiPathBase(ziStrokes);
    var pathZiScaled = transformZiPathScale(pathZi, widthX, heightY);
    var pathZiTransformed = transformZiPath(pathZiScaled, transX, transY);

    createSubZi(ofColor, ziLineWidth, pathZiTransformed);
  }

  void displayText(int id, double transX, double transY, double charFontSize) {
    var zi = theZiManager.getZi(id);
    TextSpan span = TextSpan(style: TextStyle(color: Colors.blue[800], fontSize: charFontSize/*, fontFamily: 'Roboto'*/), text: zi.char);
    //TextPainter tp = TextPainter(span, TextDirection.ltr);
    var tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(transX, transY));
  }

  double textTransYAdjust(double transY, double heightY) {
    return transY - heightY / 2.0;
  }

  void drawRootZi(int id, double transX, double transY, double widthX, double heightY, double charFontSize, MaterialColor ofColor, bool isSingleColor, double ziLineWidth, bool createFrame, bool hasRootZiLearned, bool withPinyin, MaterialColor frameFillColor/*UIColor = UIColor.white*/)
  {
    // has the index global so that each displayed char has a unique index regardless whether it has popup or not; it's init to 1 whenever a center zi in the tree is changed
    //TODO: thePopupTipIndex += 1;
    var zi = theZiManager.getZi(id);
    if (zi.isStrokeOrNonChar()) {
      buildBaseZi(id, transX, transY, widthX, heightY, ofColor, /*int hitTestId,*/ isSingleColor, ziLineWidth);
    }
    else {
      double textTransYAdjusted = textTransYAdjust(transY, heightY);
      displayText(id, transX, textTransYAdjusted, charFontSize);
    }

    // TODO: if createFrame, add to data structure for hittest buttons.
    // TODO: pinyin etc
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

  void drawZiGroup(int id, int internalStartLessonId, int internalEndLessonId) {
    var ziColor = Colors.brown;

    // one center zi first
    var posiSize = theLessonManager.getCenterPositionAndSize(); //thePositionManager.getPositionAndSizeHelper("m", 1, BigMaximumNumber/*, isCreationList: true*/);

    var withPinyin = true;

    theCurrentCenterZiId = id;
    theCreatedNumber = 0;

    thePositionManager.resetPositionIndex();

    // get its real members
    //var groupMembers = theLessonManager.getRealGroupMembers(id);
    var groupMembers;
    //if (id == 1) {
    //  groupMembers = theZiManager.getGroupMembers(id);
    //}
    //else {
      groupMembers = theZiManager.getRealGroupMembers(id, internalStartLessonId, internalEndLessonId);
    //}

    theTotalSideNumberOfZis = theZiManager.getNumberOfZis(groupMembers);

    for (var index = 0; index < groupMembers.length; index++) {
      var memberZiId = groupMembers[index];

      var posiSize2;
      //var posiSize2 = theLessonManager.getPositionAndSize(memberZiId, theTotalSideNumberOfZis/*, isCreationList: false*/);
      if (id == 1) {
        var rootZiDisplayIndex = thePositionManager.getRootZiDisplayIndex(memberZiId);
        posiSize2 = thePositionManager.getReviewRootPositionAndSize(rootZiDisplayIndex);
      }
      else {
        posiSize2 = thePositionManager.getPositionAndSize(
            memberZiId, theTotalSideNumberOfZis /*, isCreationList: false*/);
      }
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