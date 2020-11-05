import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import 'package:hanzishu/engine/lesson.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/engine/zimanager.dart';

class BasePainter extends CustomPainter{
  Color lineColor;
  Color completeColor;
  double completePercent;
  double width;

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

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}