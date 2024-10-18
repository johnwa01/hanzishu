import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/engine/zimanager.dart';

class ComponentPainter extends BasePainter {
  static double FrameHeightToWidthRaitio = 1.2;
  static double FrameLeftEdgeSize = 4.0;
  static double FrameTopEdgePosition = 35.0;
  static double FrameLineWidth = 1.0;
  int theCreatedNumber = 0;
  var theTotalSideNumberOfZis = NumberOfZis(0, 0, 0, 0);
  var theDefaultTransparentFillColor = Colors
      .cyan; //UIColor(red: 0.7294, green: 0.9882, blue: 0.8941, alpha: 0.5);

  Color lineColor = Colors.blue;
  Color completeColor = Colors.blue;
  int centerId = -1;
  //double completePercent;
  //double width;
  //Size canvasSize;
  double screenWidth = 0.0;
  //double frameWidth;

  bool withNonCharFrame = false;

  ComponentPainter({
    required this.lineColor, required this.completeColor, required this.centerId, required this.withNonCharFrame/*this.completePercent, this.width*/
  });

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;

    //TODO: why its members are null?
    //var posiSize = PositionAndSize(100.0, 40.0, 35.0, 35.0, 15.0, 2.0);

    if (withNonCharFrame) {
      var paint1 = Paint()
        ..color = this.completeColor   //Color(0xff638965)
        ..style = PaintingStyle.fill;
      //a rectangle
      canvas.drawRect(Offset(0, 0) & Size(size.width, size.height), paint1);
    }

    drawLeadComponentZi(centerId, 0.0, 0.0, size.width, size.height, size.width, /*posiSize.transX, posiSize.transY, posiSize.width, posiSize.height, posiSize.charFontSize,*/ this.lineColor as MaterialColor /*ziColor*/, /*isSingleColor:*/ true, size.width * 0.05);
    // drawZiGroup(centerId);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}