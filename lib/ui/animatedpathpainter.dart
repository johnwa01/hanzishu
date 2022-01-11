import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:hanzishu/variables.dart';  // for PathMetric
import 'package:hanzishu/ui/basepainter.dart';

Path createAnimatedPath(
    Path originalPath,
    double animationPercent,
    ) {
  // ComputeMetrics can only be iterated once!
  final totalLength = originalPath
      .computeMetrics()
      .fold(0.0, (double prev, PathMetric metric) => prev + metric.length);

  final currentLength = totalLength * animationPercent;

  return extractPathUntilLength(originalPath, currentLength);
}

Path extractPathUntilLength(
    Path originalPath,
    double length,
    ) {
  var currentLength = 0.0;

  final path = new Path();

  var metricsIterator = originalPath.computeMetrics().iterator;

  while (metricsIterator.moveNext()) {
    var metric = metricsIterator.current;

    var nextLength = currentLength + metric.length;

    final isLastSegment = nextLength > length;
    if (isLastSegment) {
      final remainingLength = length - currentLength;
      final pathSegment = metric.extractPath(0.0, remainingLength);

      path.addPath(pathSegment, Offset.zero);
      break;
    } else {
      // There might be a more efficient way of extracting an entire path
      final pathSegment = metric.extractPath(0.0, metric.length);
      path.addPath(pathSegment, Offset.zero);
    }

    currentLength = nextLength;
  }

  return path;
}

class AnimatedPathPainter extends CustomPainter {
  final Animation<double> _animation;
  List<double> strokes;

  AnimatedPathPainter(this._animation, this.strokes) : super(repaint: _animation);

  Path _createAnyPath(Size size) {
    //var strokes = theZiManager.getZi(theCurrentCenterZiId).strokes;
    return BasePainter.createZiPathScaled(strokes, size.width, size.height);
    /*
    return Path()
      ..moveTo(size.height / 4, size.height / 4)
      ..lineTo(size.height, size.width / 2)
      ..moveTo(size.height / 3, size.height / 3)
      ..lineTo(size.height / 2, size.width)
      ..quadraticBezierTo(size.height / 2, 100, size.width, size.height);
     */
  }

  @override
  void paint(Canvas canvas, Size size) {
    final animationPercent = this._animation.value;

    print("Painting + ${animationPercent} - ${size}");

    final path = createAnimatedPath(_createAnyPath(size), animationPercent);

    final Paint paint = Paint();
    paint.color = Colors.amberAccent;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 7.0;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
