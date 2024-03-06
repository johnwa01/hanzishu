import 'package:flutter/material.dart';
import 'package:hanzishu/data/phraselist.dart';
import 'dart:ui';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/data/searchingzilist.dart';
import 'package:hanzishu/data/componentlist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/component.dart';
import 'package:hanzishu/engine/strokemanager.dart';
import 'package:hanzishu/engine/componentmanager.dart';
import 'package:hanzishu/engine/drill.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';
import 'package:hanzishu/engine/lessonmanager.dart';
import 'package:hanzishu/engine/zi.dart';

class BasePainter extends CustomPainter{
  static double FrameLineWidth = 1.0;

  int theCreatedNumber = 0;
  var totalSideNumberOfZis = NumberOfZis(0, 0, 0, 0);
  var theDefaultTransparentFillColor = Colors
      .cyan; //UIColor(red: 0.7294, green: 0.9882, blue: 0.8941, alpha: 0.5);

  List<double> iconSpeechStrokes = [4.0, 0.25, 0.5, 8.0, 0.25,0.25, 8.0, 0.5, 0.25, 8.0, 0.75, 0.0, 8.0, 0.75, 1.0, 8.0, 0.5, 0.75, 8.0, 0.25, 0.75, 8.0, 0.25, 0.5];
  List<double> iconSpeechStrokesWithNumber = [4.0, 0.25, 0.5, 8.0, 0.25,0.25, 8.0, 0.5, 0.25, 8.0, 0.75, 0.0, 8.0, 0.75, 1.0, 8.0, 0.5, 0.75, 8.0, 0.25, 0.75, 8.0, 0.25, 0.5, 4.0, 0.0, 0.65, 8.0, 0.1, 0.55, 8.0, 0.1, 1.0, 4.0, 0.0, 1.0, 8.0, 0.25, 1.0];
  List<double> iconPenStrokes = [4.0, 0.375, 0.125, 8.0, 1.0, 0.75, 8.0, 0.75, 1, 8.0, 0.125, 0.375, 8.0, 0.125, 0.125, 8.0, 0.375, 0.125, 8.0, 0.125, 0.375];
  List<double> iconPenStrokesWithNumber = [4.0, 0.375, 0.125, 8.0, 1.0, 0.75, 8.0, 0.75, 1, 8.0, 0.125, 0.375, 8.0, 0.125, 0.125, 8.0, 0.375, 0.125, 8.0, 0.125, 0.375,4.0,0.0,0.7,8.0,0.15,0.6,8.0,0.3,0.75,8.0,0.0,1.0,8.0,0.4,1.0];
  List<double> iconZiLearnedStrokes = [4.0, 0.125, 0.5, 8.0, 0.375, 0.75, 8.0, 0.875, 0.25];
  List<double> iconTriangleStrokes = [4.0, 0.0, 0.5, 8.0, 0.75, 0.25, 8.0, 0.5, 1.0, 8.0, 0.0, 0.5]; // not used currently
  List<double> iconNewCharStrokes = [4.0, 0.35, 0.9, 8.0, 0.1,0.6, 8.0, 0.45, 0.775, 8.0, 0.25, 0.475, 4.0, 0.425, 0.3, 8.0, 0.325, 0.4, 8.0, 0.55, 0.675, 8.0, 0.65, 0.575, 4.0, 0.425, 0.525, 8.0, 0.525, 0.425, 4.0, 0.5, 0.25, 8.0, 0.75, 0.5, 8.0, 0.65, 0.2, 8.0, 0.9, 0.35, 8.0, 0.75, 0.025];
  List<double> iconBreakdownStrokes = [4.0, 0.5, 0.0, 8.0, 1.0, 0.5, 8.0, 0.5, 1.0, 8.0, 0.0, 0.5, 8.0, 0.5, 0.0];
  List<double> iconQuizStrokes = [4.0,0.025,0.65,8.0,0.1,0.75,8.0,0.2,0.85,8.0,0.35,0.95,8.0,0.43,0.9,8.0,0.425,0.8,8.0,0.3,0.65,8.0,0.2,0.575,8.0,0.15,0.55,8.0,0.05,0.56,8.0,0.025,0.65,4.0,0.25,0.76,8.0,0.525,0.81,4.0,0.252,0.46,8.0,0.4,0.625,8.0,0.55,0.725,8.0,0.6,0.75,8.0,0.65,0.725,8.0,0.65,0.625,8.0,0.6,0.58,8.0,0.375,0.375,4.0,0.4,0.3,8.0,0.5,0.2,4.0,0.45,0.25,8.0,0.79,0.58,4.0,0.75,0.65,8.0,0.85,0.5,4.0,0.525,0.15,8.0,0.65,0.0,8.0,0.9,0.45,8.0,1.0,0.3];

  bool isFromReviewPage = false; // this is the opposite of isFromLessonPage, mainly used for Quiz icon in tree.

  Color lineColor;
  Color completeColor;
  double width;  //screenWidth or frame width from inherited classes
  int centerId;
  bool shouldDrawCenter;

  int reviewStartLessonId;
  int reviewEndLessonId;

  Canvas canvas;

  Map<int, PositionAndSize> sidePositionsCache; // = Map();
  Map<int, List<int>> realGroupMembersCache; // = Map();
  PositionAndSize centerPositionAndSizeCache;
  Map<int, bool> allLearnedZis;
  Map<int, bool> newInLesson;
  int compoundZiCurrentComponentId;

  bool isReviewCenterPseudoZi = false;
  bool isReviewCenterPseudoNonCharZi = false;

  //BasePainter({this.lineColor, this.completeColor, this.centerId, this.shouldDrawCenter, this.width, this.sidePositionsCache, this.realGroupMembersCache, this.centerPositionAndSizeCache});

  double getSizeRatio() {
    // Note: assume screenWidth has considered the height to screen ratio already, that is, might be narrowed alreadly
    //       from the actual screen size if height to width ratio is lower than the minimum.
    return Utility.getSizeRatio(width);
  }

  double applyRatio(double value) {
    return value * getSizeRatio();
  }

  // These two are used by inherited classes only.
  // The functions here should never use these since width is passed from inherited classes only
  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(width);
  }

  double applyRatioWithLimit(double value) {
    return value * getSizeRatioWithLimit();
  }

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;
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

  static Path createZiPathBase(List<double> ziStrokes)
  {
    // width is always 1.0
    var height = 1.0; //* 1.2
    var path = Path();

    var i = 0;
    if (ziStrokes != null && ziStrokes.length > 0) {
      while (i < ziStrokes.length) {
        if (ziStrokes[i] == 4.0) // start
            {
          path.moveTo(ziStrokes[i + 1], ziStrokes[i + 2] * height);
        }
        else if (ziStrokes[i] == 8.0) // end
            {
          path.lineTo(ziStrokes[i + 1], ziStrokes[i + 2] * height);
        }

        i = i + 3;
      }
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

  static Path transformZiPath(Path ziPath, double transX, double transY) {
    Matrix4 matrix = Matrix4.identity();
    matrix.translate(transX, transY, 0.0);

    return ziPath.transform(matrix.storage);
  }

  static Path transformZiPathScale(Path ziPath, double scaleX, double scaleY) {
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

  static Path createZiPathScaled(List<double>strokes, double widthX, double heightY) {
    var pathZi = createZiPathBase(strokes);
    return transformZiPathScale(pathZi, widthX, heightY);
  }

  void buildBaseZi(List<double> strokes, double transX, double transY, double widthX, double heightY, MaterialColor ofColor, /*int hitTestId, int recursiveLevel,*/ bool isSingleColor, double ziLineWidth)
  {
    var pathZiScaled = createZiPathScaled(strokes, widthX, heightY);

    var pathZiTransformed = transformZiPath(pathZiScaled, transX, transY);

    createSubZi(ofColor, ziLineWidth, pathZiTransformed);
  }

  void  DisplayIcon(List<double> ziStrokes, double transX, double transY, double widthX, double heightY, MaterialColor ofColor, double ziLineWidth) {
    var pathZi = createZiPathBase(ziStrokes);
    var pathZiScaled = transformZiPathScale(pathZi, widthX, heightY);
    var pathZiTransformed = transformZiPath(pathZiScaled, transX, transY);

    createSubZi(ofColor, ziLineWidth, pathZiTransformed);
  }

  void displayText(int id, ZiListType listType, double transX, double transY, double charFontSize, Color color) {
    var char;
    if (listType == ZiListType.zi) {
      var zi = theZiManager.getZi(id);
      char = zi.char;
    }
    else if (listType == ZiListType.searching) {
      char = DictionaryManager.getChar(id);
    }
    else if (listType == ZiListType.component) {
      char = ComponentManager.getComponent(id).charOrNameOfNonchar;
    }
    //else if (listType == ZiListType.custom) {
    //  char = wordsStudy[id];
    //}
    else {
      return;
    }

    displayTextWithValue(char, transX, transY, charFontSize, color, false);
  }

  void displayTextForPinyin(ZiListType listType, int id, double transX, double transY, double charFontSize, Color color, bool trim) {
    var char;
    var isZiListRealChar = true;
    if (listType == ZiListType.zi) {
      var zi = theZiManager.getZi(id);
      char = zi.pinyin;
      if (zi.char != null && zi.char.length > 1) {
        isZiListRealChar = false;  // for non-char, don't produce sound or display pinyin
      }
    }
    else if (listType == ZiListType.searching) {
      char = theSearchingZiList[id].pinyin;
    }
    else if (listType == ZiListType.component) {
      char = theComponentList[id].pinyin;
    }

    var displayChar = char;

    if (trim && displayChar.length > 7) {
      displayChar = displayChar.substring(0, 4);
      displayChar += "...";
    }

    if (isZiListRealChar) { // Only display pinyin for real char, not non-char
      displayTextWithValue(displayChar, transX, transY, charFontSize, color, false);
    }
  }

  void displayTextForMeaning(ZiListType listType, int id, double transX, double transY, double charFontSize, Color color, bool trim) {
    var zi;
    if (listType == ZiListType.zi) {
      zi = theZiManager.getZi(id);
    }
    else if (listType == ZiListType.searching) {
      zi = theSearchingZiList[id];
    }
    var char = zi.meaning;

    var firstMeaning = Utility.getFirstMeaning(char);
    var displayMeaning = firstMeaning;

    if (trim && firstMeaning.length > 8) {
      displayMeaning = firstMeaning.substring(0, 5);
      displayMeaning += "...";
    }

    displayTextWithValue(displayMeaning, transX, transY, charFontSize, color, false);
  }

  void displayTextWithValue(var char, double transX, double transY, double charFontSize, Color color, bool underline) {
    // shouldn't put such thing under a very basic function
    /*
    if (isReviewCenterPseudoZi) {
        //char = theConst.atChar;
        charFontSize /= 2;
        transX += (charFontSize * 0.5);
        transY += charFontSize;
    }

    if (isReviewCenterPseudoNonCharZi) {
        //char = theConst.starChar;
        transX += (charFontSize * 0.25);
        transY += charFontSize / 2 ;
    }

    if (/*theCurrentCenterZiId == 1 ||*/ char == theConst.starChar) {
      transX += (charFontSize * 0.25);
      transY += charFontSize / 2 ;
    }
    */

    TextSpan span;
    if (underline) {
      span = TextSpan(style: TextStyle(color: color /*Colors.blue[800]*/,
          fontSize: charFontSize /*, fontFamily: 'Roboto'*/,
          decoration: TextDecoration.underline), text: char);
    }
    else {
      span = TextSpan(style: TextStyle(color: color /*Colors.blue[800]*/,
          fontSize: charFontSize /*, fontFamily: 'Roboto'*/), text: char);
    }
    //TextPainter tp = TextPainter(span, TextDirection.ltr);
    var tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout(
      minWidth: 0,
      maxWidth: this.width - transX,
    );
    tp.paint(canvas, Offset(transX, transY));
  }

  double textTransYAdjust(double transY, double heightY) {
    return transY - heightY / 3.4;  //2.0;   //Note: no ratio change here
  }

  List<double> getStrokes(int id, ZiListType listType) {
    List<double> strokes;

    if (listType == ZiListType.component) {
      var comp = ComponentManager.getComponent(id);
      if (comp != null && !comp.isChar) {
        strokes = comp.strokes;
      }
    }
    else if (listType == ZiListType.zi) {
      var zi = theZiManager.getZi(id);
      if (zi.isStrokeOrNonChar() && zi.char != '*') {
        strokes = theZiManager
            .getZi(id)
            .strokes;
      }
    }
    else if (listType == ZiListType.custom) {
      //null
    }
    else if (listType == ZiListType.stroke) {

    }

    return strokes;
  }

  void drawRootZi(int id, ZiListType listType, double transX, double transY, double widthX, double heightY, double charFontSize, MaterialColor ofColor, bool isSingleColor, double ziLineWidth, bool createFrame, bool hasRootZiLearned, bool withPinyin, MaterialColor frameFillColor, bool shouldDrawChar)
  {
    // has the index global so that each displayed char has a unique index regardless whether it has popup or not; it's init to 1 whenever a center zi in the tree is changed

    //TODO: thePopupTipIndex += 1;
    if (shouldDrawChar) {
      var strokes = getStrokes(id, listType);
      //var zi = theZiManager.getZi(id);
      //if (zi.isStrokeOrNonChar() && zi.char != '*' /*&& !isReviewCenterPseudoZi &&
      //    !isReviewCenterPseudoNonCharZi*/) {
      //  var strokes = theZiManager.getZi(id).strokes;
      if (strokes != null) {
        buildBaseZi(
            strokes,
            transX + widthX * 0.05, // adjust a little bit
            transY,
            widthX,
            heightY,
            ofColor, /*int hitTestId,*/
            isSingleColor,
            ziLineWidth);
      }
      else {
        double textTransYAdjusted = textTransYAdjust(transY, heightY);
        displayText(
            id, listType, transX, textTransYAdjusted, charFontSize, ofColor/*Colors.blue[800]*/);
      }
    }

    if (withPinyin && TheConfig.withSoundAndExplains && !isReviewCenterPseudoZi && !isReviewCenterPseudoNonCharZi) {
      displayTextForPinyin(listType, id, transX, transY - charFontSize * 0.45, charFontSize * 0.27, Colors.blue[800], true);
    }

    if (TheConfig.withSoundAndExplains && hasRootZiLearned) {
      DisplayIcon(
          iconZiLearnedStrokes,
          transX + charFontSize * 0.9,
          transY - charFontSize * 0.45,
          widthX * 0.27,
          heightY * 0.27,
          Colors.amber,
          3.0);
    }

    // TODO: if createFrame, add to data structure for hittest buttons.
  }

  void drawLeadComponentZi(int id, double transX, double transY, double widthX, double heightY, double charFontSize, MaterialColor ofColor, bool isSingleColor, double ziLineWidth)
  {
    var  comp = theComponentManager.getLeadComponent(id);
    var  char = comp.charOrNameOfNonchar;
    var  strokes = comp.strokes;

    if (!comp.isChar) {
      buildBaseZi(
            strokes,
            transX,
            transY,
            widthX,
            heightY,
            ofColor, /*int hitTestId,*/
            isSingleColor,
            ziLineWidth);
    }
    else {
        displayTextWithValue(char, transX, transY, charFontSize, Colors.blue[800], false);
    }
  }

  void drawComponentZiById(int id, double transX, double transY, double widthX, double heightY, double charFontSize, MaterialColor ofColor, bool isSingleColor, double ziLineWidth)
  {
    var comp = ComponentManager.getComponent(id);
    drawComponentZiBase(comp, transX, transY, widthX, heightY, charFontSize, ofColor, isSingleColor, ziLineWidth);
  }

  void drawComponentZi(String doubleByteCode, double transX, double transY, double widthX, double heightY, double charFontSize, MaterialColor ofColor, bool isSingleColor, double ziLineWidth)
  {
    var  comp = ComponentManager.getComponentByCode(doubleByteCode);
    drawComponentZiBase(comp, transX, transY, widthX, heightY, charFontSize, ofColor, isSingleColor, ziLineWidth);
  }

  void drawComponentZiBase(Component comp, double transX, double transY, double widthX, double heightY, double charFontSize, MaterialColor ofColor, bool isSingleColor, double ziLineWidth)
  {
    if (comp != null) {
      var char = comp.charOrNameOfNonchar;
      var strokes = comp.strokes;
      //TEMP: all uses strokes for testing purpose - just comment out the if/else part.
      if (!comp.isChar) {
        buildBaseZi(
            strokes,
            transX,
            transY,
            widthX,
            heightY,
            ofColor, /*int hitTestId,*/
            isSingleColor,
            ziLineWidth * 1.2); // adjust a bit against text
      }
      else {
        displayTextWithValue(
            char, transX, transY - 3.0, charFontSize, ofColor, false); // adjust a bit against baseZi
      }
    }
  }

  void drawComponentZiList(List<String> components, double transX, double transY, double widthX, double heightY, double charFontSize, MaterialColor ofColor, bool isSingleColor, double ziLineWidth, bool withHeader) {
    // handle this special case. want to treat left side of 踢 as 足 as whole, but display comp correctly.
    if (components.length > 2 && components[0] == "Ja" && components[1] == "Ng") {
      components[1] = "Ai"; // replace the bottom component for 足 in display
    }

    var length = components.length;
    if (!withHeader) {
      if (length > 4) {
        length = 4; // maximum components for hanzi practice sheet
      }
    }

    for (int i = 0; i < length; i++) {
      drawComponentZi(
            components[i],
            transX + widthX * i,
            transY,
            widthX,
            heightY,
            charFontSize,
            ofColor,
            isSingleColor,
            ziLineWidth);
    }
  }

  void drawStrokeZi(String strokeCode, double transX, double transY, double widthX, double heightY, double charFontSize, MaterialColor ofColor, bool isSingleColor, double ziLineWidth)
  {
    var  stroke = StrokeManager.getStrokeByCode(strokeCode);

    if (stroke != null) {
      var routes = stroke.routes;
      buildBaseZi(
          routes,
          transX,
          transY,
          widthX,
          heightY,
          ofColor,
          isSingleColor,
          ziLineWidth);
    }
  }

  // strokeString is a series of strokeCodes.
  void drawStrokeZiList(String strokeString, double transX, double transY, double widthX, double heightY, double charFontSize, MaterialColor ofColor, bool isSingleColor, double ziLineWidth, bool withHeader)
  {
    var xPosi = PrimitiveWrapper(transX);
    var yPosi = PrimitiveWrapper(transY);

    var length = strokeString.length;
    var maxStrokeLength = 4;
    if (!withHeader) {
      if (length > maxStrokeLength) {
        length = maxStrokeLength;
      }
    }

    if (length > 0) {
      for (int i = 0; i < length; i++) {
        // Pass charFontSize instead of fontWidth. normally double the fontWidth, therefore leave plenty of space between strokes
        checkAndUpdateSubstrStartPositionSimple(' ', xPosi, yPosi, charFontSize);
        drawStrokeZi(
            strokeString[i],
            xPosi.value,
            yPosi.value,
            widthX,
            heightY,
            charFontSize,
            ofColor,
            isSingleColor,
            ziLineWidth);

        xPosi.value += widthX;
      }
    }
  }

  // currently used for compound zi animation
  void drawCenterZi(int ziId, ZiListType listType) {
    var posiSize = thePositionManager.getPositionAndSizeHelper("m", 1, PositionManager.theBigMaximumNumber);
    var charColor = Colors.blue;  //[800];
    if (ziId != theCurrentCenterZiId) {
      charColor = Colors.brown;
    }
    drawRootZi(ziId, listType, posiSize.transX, posiSize.transY, posiSize.width, posiSize.height, posiSize.charFontSize, charColor/*ziColor*/, /*isSingleColor:*/ true, posiSize.lineWidth, /*createFrame:*/ true, false /*rootZiLearned*/, false/*withPinyin*/, Colors.cyan /*TODO*/, true);
  }

  /*
  void drawOnePartialFrameWithColors(List<double> list) {
    var path = Path();
    path.moveTo(list[0], list[1]);
    path.lineTo(list[2], list[3]);
    path.moveTo(list[4], list[5]);
    path.lineTo(list[6], list[7]);
    path.lineTo(list[6], list[7]);
    path.lineTo(list[8], list[9]);

    drawShape(path, Colors.amber, 2.0);
  }
  */

  void drawOneFrameLineWithColor(List<double> list, MaterialColor lineColor, double lineSize) {
    var path = Path();
    path.moveTo(list[0], list[1]);
    path.lineTo(list[2], list[3]);

    drawShape(path, lineColor /*Colors.amber*/, lineSize);
  }

  void drawFrameWithColors(ZiListType listType, double width, double leftEdge, double topEdge,
      MaterialColor centerColor, MaterialColor sideColor, double widthOfLine) {
    var x1 = leftEdge;
    double width1 = width / 3.0;
    var x2 = x1 + width1 * 0.9;
    var x3 = x2 + width1 * 1.2;
    var x4 = x3 + width1 * 0.9;

    double height = width * PositionManager.FrameHeightToWidthRatio;
    var y1 = topEdge;
    var height1 = height / 3.01;
    var y2 = y1 + height1 * 0.9;
    var y3 = y2 + height1 * 1.2;
    var y4 = y3 + height1 * 0.9;

    // outer frame
    drawOneFrameLineWithColor([x1, y1, x4, y1], Colors.amber, 2.0);
    drawOneFrameLineWithColor([x4, y1, x4, y4], Colors.amber, 2.0);
    drawOneFrameLineWithColor([x4, y4, x1, y4], Colors.amber, 2.0);
    drawOneFrameLineWithColor([x1, y4, x1, y1], Colors.amber, 2.0);

    if (centerId != 1 || (centerId == 1 && listType == ZiListType.searching)) {
      // inside frame
      drawOneFrameLineWithColor([x2, y2, x3, y2], Colors.amber, 2.0);
      drawOneFrameLineWithColor([x3, y2, x3, y3], Colors.amber, 2.0);
      drawOneFrameLineWithColor([x3, y3, x2, y3], Colors.amber, 2.0);
      drawOneFrameLineWithColor([x2, y3, x2, y2], Colors.amber, 2.0);

      var showLinesInBetween = true;
      if (listType == ZiListType.zi) {
        if (/*Utility.isPseudoRootZiId(centerId) ||
            Utility.isPseudoNonCharRootZiId(centerId) ||*/
            Utility.isStarChar(centerId)) {
          showLinesInBetween = false;
        }
      }
      else if (listType == ZiListType.searching) {
        //if (ZiManager.isSearchingListIDIndexOnly(centerId)) {
          showLinesInBetween = false;
        //}
      }


      if (showLinesInBetween) {
        // lines in between
        drawOneFrameLineWithColor([x1, y1, x2, y2], Colors.amber, 2.0);
        drawOneFrameLineWithColor([x4, y1, x3, y2], Colors.amber, 2.0);
        drawOneFrameLineWithColor([x4, y4, x3, y3], Colors.amber, 2.0);
        drawOneFrameLineWithColor([x1, y4, x2, y3], Colors.amber, 2.0);
      }
    }
    /*
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
     */
  }

  void displayCenterZiRelated(ZiListType listType, int id, double charFontSize, CenterZiRelatedBottum centerZiRelatedBottom, int internalStartLessonId) {
    var posiAndSizeMeaning = thePositionManager.getMeaningPosi();
    var posiAndSizeSpeech = thePositionManager.getCenterSpeechPosi();
    var posiAndSizeBihua = thePositionManager.getCenterBihuaPosi();

    displayTextWithValue("3", posiAndSizeMeaning.transX - 15.0, posiAndSizeMeaning.transY + 15.0, posiAndSizeMeaning.width / 1.3, Colors.amber, false);
    displayTextForMeaning(listType, id, posiAndSizeMeaning.transX, posiAndSizeMeaning.transY, posiAndSizeMeaning.width, Colors.blue[800], true);

    var displaySpeechIcon = true;
    if (listType == ZiListType.zi) {
      var zi = theZiManager.getZi(id);
      if (zi != null && zi.char != null && zi.char.length > 1) {
        displaySpeechIcon = false;
      }
    }

    if (displaySpeechIcon) {
      DisplayIcon(
          iconSpeechStrokesWithNumber,
          posiAndSizeSpeech.transX,
          posiAndSizeSpeech.transY,
          posiAndSizeSpeech.width,
          posiAndSizeSpeech.height,
          Colors.amber /*MaterialColor ofColor*/,
          2.0 /*ziLineWidth*/);
    }

    //if (theZiManager.getZiType(id) == 'b') {   //TODO: 'j' for basic zi char
      DisplayIcon(
          iconPenStrokesWithNumber,
          posiAndSizeBihua.transX,
          posiAndSizeBihua.transY,
          posiAndSizeBihua.width,
          posiAndSizeBihua.height,
          Colors.amber /*MaterialColor ofColor*/,
          2.0 /*ziLineWidth*/);
    //}

    if (!isFromReviewPage && isCharNewInLesson(id, internalStartLessonId)) {
      var posiNewChar = thePositionManager.getNewCharIconPosi();
      DisplayIcon(
          iconQuizStrokes, //iconNewCharStrokes,
          posiNewChar.transX,
          posiNewChar.transY,
          posiNewChar.width,
          posiNewChar.height,
          Colors.red, //amber /*MaterialColor ofColor*/,
          2.0 /*ziLineWidth*/);
    }

    displayCenterZiRelatedBottum(listType, id, centerZiRelatedBottom);
  }

  void displayCenterZiRelatedBottum(ZiListType listType, int id, CenterZiRelatedBottum centerZiRelatedBottum) {
    var posi = thePositionManager.getHintPosi();
    var fontSize = thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize);
    if (centerZiRelatedBottum.drawBreakdown) {
      // drawBreakdown
      posi.transY += (3 * fontSize);
    }
    else {
      DisplayHint(listType, id, false, posi, true);

      posi.transY += (2.5 * fontSize);  // Need to match treepage
      displayZiStructure(posi, centerZiRelatedBottum);

      posi.transY += fontSize;
      displayComponentCount(posi, centerZiRelatedBottum);
    }

    posi.transY += fontSize;
    // TODO: turn on after fixing hit button position bug in web version
    //displayWordBreakdown(/*listType, id,*/ posi, centerZiRelatedBottum);
  }

  void displayZiStructure(PositionAndSize posi, CenterZiRelatedBottum centerZiRelatedBottum) {
    displayTextWithValue("5. " + getString(440) /*Word structure*/ + "?", posi.transX, posi.transY, thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize), Colors.brown, false);
    // 'l' converts to index, no real change.
    var structureIndex = CenterZiRelatedBottum.getIndexByStructureValue(centerZiRelatedBottum.structureReal);
    var col0 = Colors.blue;
    var col1 = Colors.blue;
    if (centerZiRelatedBottum.structureAccuratePosition == 0) {
      if (centerZiRelatedBottum.structureSelectPosition == 0) {
        col0 = Colors.green;
      }
      else if (centerZiRelatedBottum.structureSelectPosition == 1) {
        col1 = Colors.red;
      }

      displayTextWithValue(
          getString(CenterZiRelatedBottum.structure[structureIndex]) /*"Single part"*/,
          (posi.transX + CenterZiRelatedBottum.position[0]) * getSizeRatio(), posi.transY,
          thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize),
          col0, true);
      displayTextWithValue(
          getString(CenterZiRelatedBottum.structure[centerZiRelatedBottum.structureWrongIndex]) /*"Left & right"*/,
          (posi.transX + CenterZiRelatedBottum.position[1]) * getSizeRatio(), posi.transY,
          thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize),
          col1, true);
    }
    else { // accuratePosition == 1 (the second one)
      if (centerZiRelatedBottum.structureSelectPosition == 0) {
        col0 = Colors.red;
      }
      else if (centerZiRelatedBottum.structureSelectPosition == 1) {
        col1 = Colors.green;
      }

      displayTextWithValue(
          getString(CenterZiRelatedBottum.structure[centerZiRelatedBottum.structureWrongIndex]) /*"Left & right"*/,
          (posi.transX + CenterZiRelatedBottum.position[0]) * getSizeRatio(), posi.transY,
          thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize),
          col0, true);
      displayTextWithValue(
          getString(CenterZiRelatedBottum.structure[structureIndex]) /*"Single part"*/,
          (posi.transX + CenterZiRelatedBottum.position[1]) * getSizeRatio(), posi.transY,
          thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize),
          col1, true);
    }
  }

  void displayComponentCount(PositionAndSize posi, CenterZiRelatedBottum centerZiRelatedBottum) {
    displayTextWithValue("6. " + getString(445) /*Chinese alphabet count*/ + "?", posi.transX, posi.transY, thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize), Colors.brown, false);
    var col0 = Colors.blue;
    var col1 = Colors.blue;
    if (centerZiRelatedBottum.compCountAccuratePosition == 0) {
      if (centerZiRelatedBottum.compCountSelectPosition == 0) {
        col0 = Colors.green;
      }
      else if (centerZiRelatedBottum.compCountSelectPosition == 1) {
        col1 = Colors.red;
      }

      displayTextWithValue(
          centerZiRelatedBottum.compCountReal.toString()/*"2"*/, (posi.transX + CenterZiRelatedBottum.position[2]) * getSizeRatio(), posi.transY,
          thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize),
          col0, true);
      displayTextWithValue(
          centerZiRelatedBottum.compCountWrongValue.toString()/*"3"*/, (posi.transX + CenterZiRelatedBottum.position[3]) * getSizeRatio(), posi.transY,
          thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize),
          col1, true);
    }
    else {
      if (centerZiRelatedBottum.compCountSelectPosition == 0) {
        col0 = Colors.red;
      }
      else if (centerZiRelatedBottum.compCountSelectPosition == 1) {
        col1 = Colors.green;
      }

      displayTextWithValue(
          centerZiRelatedBottum.compCountWrongValue.toString()/*"3"*/, (posi.transX + CenterZiRelatedBottum.position[2]) * getSizeRatio(), posi.transY,
          thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize),
          col0, true);
      displayTextWithValue(
          centerZiRelatedBottum.compCountReal.toString()/*"2"*/, (posi.transX + CenterZiRelatedBottum.position[3]) * getSizeRatio(), posi.transY,
          thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize),
          col1, true);
    }
  }

  void displayWordBreakdown(/*ZiListType listType, int id,*/ PositionAndSize posi, CenterZiRelatedBottum centerZiRelated) {
    if ((centerZiRelated.drawBreakdown)) {
      var posi = thePositionManager.getHintPosi();
      var yPositionWrapper = YPositionWrapper(posi.transY);

      if (centerZiRelated.compCountReal == 1) {

        displayStrokes(centerZiRelated.searchingZiId, posi, getSizeRatio(), true);
      }
      else {
        bool isBreakoutPositionsOnly = false;
        displayOneCharDissembling(
            yPositionWrapper,
            centerZiRelated.searchingZiId,
            ZiListType.searching,
            0,
            false,
            isBreakoutPositionsOnly,
            centerZiRelated.breakoutPositions);
      }
    }

    displayTextWithValue("7. ", posi.transX * getSizeRatio(), posi.transY, thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize), Colors.brown, false);
    displayTextWithValue(getString(446)/*"Breakdown"*/, (posi.transX + CenterZiRelatedBottum.position[4]) * getSizeRatio(), posi.transY, thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize), Colors.brown, true);
  }

  void drawZiGroup(int id, ZiListType listType, int startingCenterZiId, DrillCategory drillCategory, int internalStartLessonId, int internalEndLessonId, CenterZiRelatedBottum centerZiRelatedBottum) {
    var ziColor = Colors.brown;

    // one center zi first
    var posiSize = getCenterPositionAndSize(centerPositionAndSizeCache); //thePositionManager.getPositionAndSizeHelper("m", 1, BigMaximumNumber/*, isCreationList: true*/);

    var withPinyin = false;

    theCurrentCenterZiId = id;

    theCreatedNumber = 0;

    bool allCurrentMemberZiLearned = true;

    thePositionManager.resetPositionIndex();

    // get its real members
    //var groupMembers = theLessonManager.getRealGroupMembers(id);
    var groupMembers;
    // hardcode lesson 2 so that it'll have a sequential number order in top layer display
    groupMembers = getRealGroupMembers(id, listType, drillCategory, internalStartLessonId, internalEndLessonId, realGroupMembersCache);

    //var phraseZis = theLessonManager.getPhraseZis(id, internalStartLessonId, internalEndLessonId);
    //TODO: including phraseZis
    totalSideNumberOfZis = theZiManager.getNumberOfZis(listType, groupMembers);

    for (var index = 0; index < groupMembers.length; index++) {
      //for lesson's tree, we no longer display * and any char under it
      if (listType == ZiListType.zi && groupMembers[index] == TheConst.starCharId) {
        continue;
      }

      var memberZiId = groupMembers[index];

      var posiSize2 = getPositionAndSize(listType, memberZiId, totalSideNumberOfZis, sidePositionsCache);

      var memberZiLearned = doesZiExistInLearnedMap(memberZiId); //GeneralManager.hasZiCompleted(memberZiId, theHittestState, theCurrentLessonId);
      allCurrentMemberZiLearned = allCurrentMemberZiLearned && memberZiLearned;

      var isSingleColor = false;
      if ((listType == ZiListType.zi && theCurrentCenterZiId == 1) || (listType == ZiListType.searching && theCurrentCenterZiId == 1)) { // the root graph
        isSingleColor = true;
      }

      var frameFillColor = Colors.blue; //Colors.white;  //TODO: white and black are treated differently from other colors.
      if (memberZiId == thePreviousCenterZiId) {
        frameFillColor = theDefaultTransparentFillColor;
      }

      // check if its a composite zi and return partial zi
      var partialZiId = memberZiId;
      // exclude the case for lesson 2, id 155.
      //lesson==2, id = 155 ->六  [In the tree, treat it as a basic one. but in word list etc, still keep as multiple component char.
      ZiListTypeWrapper searchingOrCompZiListTypeWrapper = ZiListTypeWrapper(listType); // for searching, the type might change to CompList.
      if ((listType == ZiListType.searching) ||
          (listType == ZiListType.zi && theIsPartialZiMode && !(theCurrentLessonId == 2 && memberZiId == 155))) {
        partialZiId = theZiManager.getPartialZiId(searchingOrCompZiListTypeWrapper, id, memberZiId);
      }
      var oneZiColor = ziColor;
      if (listType == ZiListType.searching) {
        if (theSearchingZiList[memberZiId].composit.length > 2 || ZiManager.isParentOfASearchingListIDIndexOnly(memberZiId)) {
          oneZiColor = Colors.blue;
        }
      }
      else {
        if ((ZiManager.getZiComponentCount(memberZiId) > 2 && !theZiManager.isBasicZi(memberZiId)) || theZiManager.isBasicZi(memberZiId)) {
          oneZiColor = Colors.blue;
        }
      }
      drawRootZi(partialZiId, searchingOrCompZiListTypeWrapper.value, posiSize2.transX, posiSize2.transY, posiSize2.width, posiSize2.height, posiSize2.charFontSize, oneZiColor, isSingleColor, posiSize2.lineWidth, /*createFrame*/ true, /*hasRootZiLearned*/ memberZiLearned, withPinyin, frameFillColor, true);

      thePositionManager.updatePositionIndex(listType, memberZiId);
    }

    /*
    for (var pIndex = 0; pIndex < phraseZis.length; pIndex++) {
      var ziId = phraseZis[pIndex];
      var posiSize2 = theLessonManager.getPositionAndSize(ziId, totalSideNumberOfZis);
      drawRootZi(ziId, posiSize2.transX, posiSize2.transY, posiSize2.width, posiSize2.height, posiSize2.charFontSize, ziColor, isSingleColor, posiSize2.lineWidth, /*createFrame*/ true, /*hasRootZiLearned*/ memberZiLearned, withPinyin, frameFillColor);

      thePositionManager.updatePositionIndex(ziId);
    }
    */

    var centerZiAndChildrenLearned = doesZiExistInLearnedMap(id); //GeneralManager.hasZiCompleted(id, theHittestState, theCurrentLessonId);
    //GeneralManager.checkAndSetHasAllChildrenCompleted(id, theHittestState, theCurrentLessonId);
    if (!centerZiAndChildrenLearned && allCurrentMemberZiLearned) {
      centerZiAndChildrenLearned = true;
      setCenterZiLearned(id);
    }

    if (allCurrentMemberZiLearned && id == 1) {
      theAllZiLearned = true;
    }

    // skip the center zi for id == 1, which is the default empty root zi.
    // the Chinese character zi "-" has an id of 170.
    //TODO：add checking to not display center pseudo root zi for treepage mode - !isFromReviewPage
    if (id > 1) {
      //var rootZiLearned = GeneralManager.hasZiCompleted(id, theHittestState, theCurrentLessonId);
/*
      if (listType == ZiListType.zi && isFromReviewPage && Utility.isPseudoRootZiIdPlusStar(id)) {
        isReviewCenterPseudoZi = true;
      }
      if (listType == ZiListType.zi && isFromReviewPage && Utility.isPseudoNonCharRootZiId(id)) {
        isReviewCenterPseudoNonCharZi = true;
      }

      // make '*' near the center, otherwise, it'll be in the uppper left corner of the center
      if (listType == ZiListType.zi && id == TheConst.starCharId) { // the * char
        posiSize.transX += posiSize.charFontSize * 0.25;
        posiSize.transY += posiSize.charFontSize / 4 ;
      }
*/
      var display = false;
 //     if (listType == ZiListType.zi) {
 //       if (TheConfig.withSoundAndExplains && !isReviewCenterPseudoZi && !isReviewCenterPseudoNonCharZi && id != TheConst.starCharId ) {
 //         display = true;
 //       }
 //     }
      if (listType == ZiListType.searching) {
        if (id >= 52) { // TODO: exclude more structural items
          display = true;
        }
      }

      drawRootZi(
            id,
            listType,
            posiSize.transX,
            posiSize.transY,
            posiSize.width,
            posiSize.height,
            posiSize.charFontSize,
            Colors.blue, //ziColor, /*isSingleColor:*/  //Center zi set to color blue, diff from others.
            true,
            posiSize.lineWidth, /*createFrame:*/
            true,
            centerZiAndChildrenLearned,
            display, //withPinyin
            Colors.cyan /*TODO*/,
            shouldDrawCenter);

      if (display) {
        displayCenterZiRelated(listType, id, posiSize.charFontSize, centerZiRelatedBottum, internalStartLessonId);
      }

      // draw navigation path
      // skip a zi if it's in the parent path of startingCenterZiId
      displayNavigationPath(listType, id, startingCenterZiId, drillCategory);

      isReviewCenterPseudoZi = false;
      isReviewCenterPseudoNonCharZi = false;
    }

    if (id == 1 && (drillCategory == DrillCategory.custom || listType == ZiListType.zi)) {
      displayIntroMessage();
    }

    if ((drillCategory == DrillCategory.custom) && (theIsFromLessonContinuedSection || isFromReviewPage)) {
        //var posi = thePositionManager.getHintPosi();
        // Need to match the DrillPage & TreePage sizes
        double xPosi = width - 80.0;
        double yPosi = 0.0;
        //double yPosi = posi.transY +
            //2 * thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize);
        DisplayContinueOrSkip(listType, xPosi, yPosi);
    }
  }

  displayIntroMessage() {
    displayTextWithValue(getString(404)/*"Study till"*/, 0, 0, thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize), Colors.black, false);
  }

  //void drawCenterZiRelated(int id, double transX, double transY, double charFontSize) {
  //  displayTextForMeaning(id, transX, transY, charFontSize);
  //}

  bool doesZiExistInLearnedMap(int id) {
    return allLearnedZis.containsKey(id);
  }

  setCenterZiLearned(int id) {
    allLearnedZis[id] = true;
  }

  static addToSidePositionsCache(int ziId, PositionAndSize positionAndSize, Map<int, PositionAndSize> sidePositions) {
    sidePositions[ziId] = positionAndSize;
  }

  static PositionAndSize getPositionAndSizeFromCache(int ziId, Map<int, PositionAndSize> sidePositions) {
    return sidePositions[ziId];
  }

  static PositionAndSize getPositionAndSize(ZiListType listType, int ziId, NumberOfZis totalSideNumberOfZis, Map<int, PositionAndSize> sidePositions) {
    // NOTE: in review mode, the theCurrentLesson might mean the last lesson in the range
    //var currentLesson = theLessonList[theCurrentLessonId];
    // check cache first
    var positionAndSize = getPositionAndSizeFromCache(ziId, sidePositions);

    if (positionAndSize == null) {
      positionAndSize = thePositionManager.getPositionAndSize(listType, ziId, totalSideNumberOfZis);
      addToSidePositionsCache(ziId, positionAndSize, sidePositions);
    }

    return positionAndSize;
  }


  static List<int> getRealGroupMembersFromCache(int id, Map<int, List<int>>realGroupMembersCache) {
    return realGroupMembersCache[id];
  }

  static addToRealGroupMembersCache(int id, List<int> realGroupMembers, Map<int, List<int>>realGroupMembersCache) {
    realGroupMembersCache[id] = realGroupMembers;
  }

  static List<int> getRealGroupMembers(int id, ZiListType listType, DrillCategory drillCategory, int internalStartLessonId, int internalEndLessonId, Map<int, List<int>>realGroupMembersCache) {
    var realGroupMembers = null;
    if (listType == ZiListType.zi) {
      realGroupMembers = getRealGroupMembersFromCache(id, realGroupMembersCache);
    }

    //TODO: remove the cache implementation
    //Note: You can temp comment out if/cache for debugging
    if (realGroupMembers == null) {
      // hardcode for lesson 2's number to have a sequential display order
      if (listType == ZiListType.zi && id == 1 && internalStartLessonId == 2 && internalEndLessonId == internalStartLessonId) {
        realGroupMembers = [2, 3, 170, 153, 154, 7, 155, 8, 10, 157]; //'6'(155) is manually added here.
      }
      else {
        realGroupMembers = theZiManager.getRealGroupMembers(id, listType, drillCategory, internalStartLessonId, internalEndLessonId);
      }

      if (listType == ZiListType.zi) {
        addToRealGroupMembersCache(id, realGroupMembers, realGroupMembersCache);
      }
    }

    return realGroupMembers;
  }

  static PositionAndSize getCenterPositionAndSize(PositionAndSize centerPositionAndSizeCache) {
    if (centerPositionAndSizeCache == null) {
      centerPositionAndSizeCache = thePositionManager.getPositionAndSizeHelper("m", 1, PositionManager.theBigMaximumNumber);
    }

    return centerPositionAndSizeCache;
  }

  DisplayHint(ZiListType listType, int id, bool isPhrase, PositionAndSize posi, bool withIndex) {
    var ziOrPhraseHint;
    if (listType == ZiListType.searching) {
      ziOrPhraseHint = theSearchingZiList[id].hint;
      if (ziOrPhraseHint.length == 0) {
        return;
      }
    }
    else if (isPhrase) {
      ziOrPhraseHint = thePhraseList[id].hint;
    }
    else {
      ziOrPhraseHint = theZiManager.getZi(id).origin;
    }
    var hintHeader = withIndex ? ('4. ' + getString(90)/*"Hint"*/ + ': ') : (getString(90)/*"Hint"*/ + ': ');

    displayTextWithValue(hintHeader, posi.transX, posi.transY,
        thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize),
        Colors.brown, false);

    PrimitiveWrapper xPosi = PrimitiveWrapper(posi.transX);
    PrimitiveWrapper yPosi = PrimitiveWrapper(posi.transY);
    xPosi.value += applyRatio(55.0); // hardcoded. ignore screenWidth

    DisplayHintHelper(ziOrPhraseHint, xPosi, yPosi);
  }

  // Will have the same result of going to next section, although the display prompt message is different.
  DisplayContinueOrSkip(ZiListType listType, double xPosi, double yPosi) {
    var skipOrContinue;
    var fontSize = thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize);
    var messageColor = Colors.black;
    if (theAllZiLearned) {
      skipOrContinue = getString(402);
      fontSize /= 1.1;
      //messageColor = Colors.white;
    }
    else {
      fontSize /= 1.3;
      skipOrContinue = getString(401);
    }

    displayTextWithValue(skipOrContinue /*"Skip or continue"*/, xPosi, yPosi,
        fontSize,
        messageColor, false);
  }

  checkAndUpdateSubstrStartPosition(String str, PrimitiveWrapper xPosi, PrimitiveWrapper yPosi, double fontWidth, double fontSize) {
    //Note: Don't double applyRatio for fontWidth here
    var strSize = str.length * fontWidth;
    //var  indexStart = str.indexOf('(');
    var count = Utility.substringCountMaxThree(str, '(');
    if (count > 0) {
      xPosi.value += applyRatio(fontWidth) * count; // give one extra space for Chinese character
    }

    // if str too long, just let it do it. This is mainly to avoid issue for Char drawing.
    if ((xPosi.value > (width / 2)) && ((xPosi.value + strSize) > width)) {
      xPosi.value = /*20.0 + */ applyRatio(55.0);
      yPosi.value += fontSize * 1.0; //1.3; // move to next line with gap
    }
  }

  // suitable for displaying strokes with many small entries
  checkAndUpdateSubstrStartPositionSimple(String str, PrimitiveWrapper xPosi, PrimitiveWrapper yPosi, double fontWidth) {
    //Note: Don't double applyRatio for fontWidth here
    var strSize = str.length * fontWidth;

    // if str too long, just let it do it. This is mainly to avoid issue for Char drawing.
    if (/*(strSize < fontWidth * 4) && */(xPosi.value + strSize + applyRatio(10.0)) >= width) {
      xPosi.value = /*20.0 + */ applyRatio(55.0);
      yPosi.value += fontWidth; // move to next line without gap
    }
  }

  DisplayHintHelper(String hint, PrimitiveWrapper xPosi, PrimitiveWrapper yPosi) {
    double defaultFontSize = applyRatio(16.84);
    if (hint.contains("[")) {
      // Measured with Android 3.30 for following value which matches other values here.
      // the average English letter width is about 8.0, that is, about half the font size.
      //thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize)

      // find string before it
      // display the string
      var  indexStart = hint.indexOf('[');
      if (indexStart != null) {
        //var stringBeforeIndex = hint[..<indexStart];
        var realStringBeforeIndex = hint.substring(0, indexStart); //String(stringBeforeIndex);
        checkAndUpdateSubstrStartPosition(realStringBeforeIndex, xPosi, yPosi, applyRatio(8.0), defaultFontSize);
        displayTextWithValue(realStringBeforeIndex, xPosi.value, yPosi.value, defaultFontSize/*thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize)*/, Colors.blue, false);
        HintSubstringContainsZi(realStringBeforeIndex, xPosi, yPosi, defaultFontSize);

        // find the next "]"
        // get the string between [ and ]
        // display the char
        var indexPair = hint.indexOf(']');
        if (indexPair != null) {
          //var indexStartPlusOne = hint.index(indexStart, offsetBy: 1);
          //var charIdString = hint[indexStartPlusOne..<indexPair];
          var componentCodeString = hint.substring(indexStart + 1, indexPair);
          //var id = Utility.StringToInt(charIdString);

          if (componentCodeString != null) {
            checkAndUpdateSubstrStartPosition('    ', xPosi, yPosi, applyRatio(8.0), defaultFontSize);
            //displayTextWithValue('(', xPosi.value, yPosi.value, defaultFontSize, Colors.blue, false);
            //xPosi.value += applyRatio(7.0);

            var componentId = ComponentManager.getComponentIdByCode(componentCodeString);
            drawRootZi(componentId, ZiListType.component, xPosi.value, yPosi.value, applyRatio(13.0), applyRatio(13.0), applyRatio(11.0)/*thePositionManager.getCharFontSize(ZiOrCharSize.sideSmallSize)*/, Colors.blue, false, 1.5, false, false, false, Colors.blue, true);
            xPosi.value += applyRatio(13.0);
            //displayTextWithValue(')', xPosi.value, yPosi.value, defaultFontSize, Colors.blue, false);

            xPosi.value += applyRatio(8.0);
          }

          // find the substring after ]
          //var indexPairPlusOne = hint.index(indexPair, offsetBy: 1);
          var indexPairPlusOne = indexPair + 1;
          if (hint.length > indexPairPlusOne) {
            var rightString = hint.substring(indexPairPlusOne, hint.length);
            DisplayHintHelper(rightString, xPosi, yPosi);
         }
       }
     }
    }
    else {
      //checkAndUpdateSubstrStartPosition(hint, xPosi, yPosi, 8.0);
      checkAndUpdateSubstrStartPosition(hint, xPosi, yPosi, applyRatio(8.0), defaultFontSize);
      displayTextWithValue(hint, xPosi.value, yPosi.value, defaultFontSize/*thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize)*/, Colors.blue, false);
      HintSubstringContainsZi(hint, xPosi, yPosi, defaultFontSize);
    }
  }

  HintSubstringContainsZi(String hint, PrimitiveWrapper xPosi, PrimitiveWrapper yPosi, double fontSize) {
    xPosi.value += hint.length * applyRatio(8.0);
    var count = Utility.substringCountMaxThree(hint, '(');
    //var  indexStart = hint.indexOf('(');
    if (count > 0) {
      xPosi.value += applyRatio(8.0) * count; //20.0
    }

    if (xPosi.value >= width) {
      xPosi.value = (xPosi.value - width) + applyRatio(55.0 + 18.0);
      if (count >= 2) {
        xPosi.value += applyRatio(25.0); // some buffer at the end of screen. appears not enough space for this case
      }
      // 1.0 or 1.3 doesn't seem matter here, strange.
      yPosi.value += fontSize * 1.0; //1.3; // fontSize has ratio already
    }
  }

  bool isCharNewInLesson(int id, int internalStartLessonId) {
    var convChars = theLessonManager.getConvCharsIds(internalStartLessonId);
    for (int i = 0; i < convChars.length; i++) {
      if (id == convChars[i]) {
        return true;
      }
    }

    return false;
    /*
    if (newInLesson.containsKey(id)) {
      return newInLesson[id];
    }
    else {
      var lesson = theLessonList[theCurrentLessonId];
      var isNew = lesson.isCharNewInLesson(id);
      newInLesson[id] = isNew;
      return isNew;
    }
    */
  }

  // Note: this path will not change its size regardless of the screen size
  displayNavigationPath(ZiListType listType, int ziId, int startingCenterZiId, DrillCategory drillCategory) {
    var posi = thePositionManager.getTreeNavigationPosi(getSizeRatio());
    displayOneNaviationPathChar(0, listType, ziId, startingCenterZiId, posi, drillCategory);
  }

  displayOneNaviationPathChar(int recurLevel, ZiListType listType, int id, startingCenterZiId, PositionAndSize posi, DrillCategory drillCategory) {

      var withPinyin = false;

      var zi;
      if (listType == ZiListType.zi) {
        zi = theZiManager.getZi(id);
      }
      else if (listType == ZiListType.searching) {
        zi = theSearchingZiList[id];
      }

      if (zi.id != 1) // till hit root
        {
        var newRecurLevel = recurLevel + 1;
        var parentId = zi.parentId;

        displayOneNaviationPathChar(newRecurLevel, listType, parentId, startingCenterZiId, posi, drillCategory);
      }

      // for lesson, skip those pseudo ones.
      //if (listType == ZiListType.searching || isFromReviewPage /*|| (!Utility.isPseudoNonCharRootZiId(id) && !Utility.isPseudoRootZiId(id))*/) {
        if (!(drillCategory == DrillCategory.custom && Utility.isSearchingPseudoZiId(id))) {
          if (zi.id != 1) {
            posi.transX += applyRatio(18.0); // 23.0
            displayTextWithValue(
                " -> ", posi.transX, posi.transY - posi.charFontSize * 0.3,
                posi.charFontSize, Colors.brown, false);
            posi.transX += applyRatio(36.0); //15.0
          }

          var frameFillColor = Colors.yellow;
          var createFrame = false;
          if (recurLevel != 0) {
            frameFillColor = theDefaultTransparentFillColor;
            createFrame = true;
          }

          if (!theZiManager.isADistantParentOf(
              listType, startingCenterZiId, id)) {
            drawRootZi(
                id,
                listType,
                posi.transX,
                posi.transY,
                posi.width,
                posi.height,
                posi.charFontSize,
                Colors.brown,
                false,
                posi.lineWidth,
                createFrame,
                false,
                withPinyin,
                frameFillColor,
                true);
          }
        }
      //}
  }

  displayFullComponents(int searchingZiId, PositionAndSize posi, double ratio, bool withHeader) {
    var comps = List<String>();
    DictionaryManager.getAllComponents(searchingZiId, comps);
    if (withHeader) {
      displayTextWithValue(
          getString(97) /*"Components"*/ + ": ", posi.transX, posi.transY, posi
          .charFontSize /*thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize)*/,
          Colors.black, false);
    }

    var xStartPosi = 185.0;
    if (!withHeader) {
      xStartPosi = 20.0;
    }

    drawComponentZiList(
        comps,
        xStartPosi * ratio,  //135
        posi.transY,
        posi.charFontSize * 1.3,
        posi.charFontSize * 1.3,
        posi.charFontSize * 1.3,
        Colors.blue, // cyan, //this.lineColor,
        true,
        posi.charFontSize * 0.07,
        withHeader);
  }

  displayComponentsOrStrokes(int searchingZiId, PositionAndSize posi, bool withHeader) {
    var isSingleCompZi = DictionaryManager.isSingleCompZi(searchingZiId);

    if (isSingleCompZi) {
      displayStrokes(searchingZiId, posi, getSizeRatio(), withHeader);
    }
    else {
      displayFullComponents(searchingZiId, posi, getSizeRatio(), withHeader);
    }
  }

  // assume a single comp zi. used in dictionary.
  displayStrokes(int searchingZiIndex, PositionAndSize posi, double ratio, bool withHeader) {
    var comps = DictionaryManager.getSearchingZi(searchingZiIndex).composit; //theSearchingZiList[searchingZiIndex].composit;
    if (withHeader) {
      displayTextWithValue(
          getString(88) /*"Strokes"*/ + ": ", posi.transX, posi.transY, posi
          .charFontSize /*thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize)*/,
          Colors.black, false);
    }

    var comp = ComponentManager.getComponentByCode(comps[0]);

    var xStartPosi = 110.0;
    if (!withHeader) {
      xStartPosi = 20.0;
    }

    if (comp.strokesString.length > 0) {
      drawStrokeZiList(
          comp.strokesString,
          xStartPosi * ratio,
          posi.transY,
          posi.charFontSize * 1.3,
          posi.charFontSize * 1.3,
          posi.charFontSize * 1.3, //thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize), //20.0,
          Colors.blue,  //cyan, //this.lineColor,
          true,
          posi.charFontSize * 0.07,
          withHeader);
    }
  }

  // assume a single comp zi or component. used in zi list in lessons and comopnent list.
  displayCompStrokes(int ziId, ZiListType type, PositionAndSize posi, double ratio) {
    var comp;
    displayTextWithValue(
        getString(87) /*"Strokes"*/ + ": ", posi.transX, posi.transY, posi
        .charFontSize /*thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize)*/,
        Colors.black, false);
    if (type == ZiListType.zi) {
      var compCode = ComponentManager.getCompCodeFromZiId(ziId);
      comp = ComponentManager.getComponentByCode(compCode);
    }
    else if (type == ZiListType.component) {
      comp = ComponentManager.getComponent(ziId);
    }

    if (comp != null) {
      drawStrokeZiList(
          comp.strokesString,
          160.0 * ratio, // 110
          posi.transY,
          posi.charFontSize * 1.3,
          posi.charFontSize * 1.3,
          posi.charFontSize * 1.3, //thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize), //20.0,
          Colors.blue,   //cyan, //this.lineColor,
          true,
          posi.charFontSize * 0.07,
          true);
    }
  }

  displayTypingCode(int searchingZiIndex, PositionAndSize posi) {
    var typingCode = DictionaryManager.getTypingCode(searchingZiIndex);
    displayTextWithValue(
        getString(89)/*"Typing code"*/ + ": ", posi.transX, posi.transY, posi.charFontSize/*thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize)*/, Colors.black, false);
    displayTextWithValue(typingCode, posi.transX + applyRatio(230.0), posi.transY, posi.charFontSize/*thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize)*/, Colors.blue, false); //170
  }

  displayTypingCodePlaceholder(PositionAndSize posi) {
    displayTextWithValue(
        "", posi.transX, posi.transY, posi.charFontSize/*thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize)*/, Colors.black, false);
    displayTextWithValue("", posi.transX + applyRatio(170.0), posi.transY, posi.charFontSize/*thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize)*/, Colors.blue, false);
  }

  displayOneCharDissembling(YPositionWrapper yPositionWrapper, int ziId, ZiListType listType, int maxRecurLevel, bool showBreakoutDetails, bool isBreakoutPositionsOnly, Map<int, PositionAndSize> breakoutPositions) {
    LessonManager.clearComponentsStructure();
    //if (lessonLeftEdge == null) {
      var lessonLeftEdge = applyRatio(10.0);
    //}

    var breakoutIndex = PrimitiveWrapper(0);

    drawZiAndComponentsDissembling(0, 0, ziId, listType, lessonLeftEdge, yPositionWrapper.yPosi, showBreakoutDetails, isBreakoutPositionsOnly, breakoutIndex, breakoutPositions);

    yPositionWrapper.yPosi += applyRatio(20.0);
    yPositionWrapper.yPosi = LessonManager.getNextYPosition(yPositionWrapper.yPosi);
  }

  // for dissembly only
  drawZiAndComponentsDissembling(int recurLevel, int indexInLevel, int id, ZiListType listType, double transX, double transY, bool showBreakoutDetails, bool isBreakoutPositionsOnly, PrimitiveWrapper breakoutIndex, Map<int, PositionAndSize> breakoutPositions) {
    // note: didn't apply sizeRatio to height/width. a bit better without applying it.
    var posiSize2 = PositionAndSize(transX, transY, thePositionManager.getZiSize(ZiOrCharSize.assembleDissembleSize), thePositionManager.getZiSize(ZiOrCharSize.assembleDissembleSize), thePositionManager.getCharFontSize(ZiOrCharSize.assembleDissembleSize), thePositionManager.getZiLineWidth(ZiOrCharSize.assembleDissembleSize));

    var analyzeZiYSize = thePositionManager.getZiSize(ZiOrCharSize.assembleDissembleSize);  //CGFloat(30.0)
    var analyzeZiYGap = 0.5 * analyzeZiYSize;    //CGFloat(15.0)

    if (recurLevel > 0) {
      if (theCurrentZiComponents[recurLevel] < theCurrentZiComponents[recurLevel-1]-1) {
        theCurrentZiComponents[recurLevel] = theCurrentZiComponents[recurLevel-1]-1;
      }

      if (!isBreakoutPositionsOnly) {
        drawLine(transX - applyRatio(89.0-40.0), transY + analyzeZiYGap + (analyzeZiYSize + analyzeZiYGap) * (theCurrentZiComponents[recurLevel-1]-1), transX - applyRatio(10.0), transY + analyzeZiYGap + (analyzeZiYSize + analyzeZiYGap) * (theCurrentZiComponents[recurLevel]), Colors.amber, applyRatio(2));
      }
    }

    posiSize2.transY += (analyzeZiYSize + analyzeZiYGap) *
        (theCurrentZiComponents[recurLevel]);

    if (isBreakoutPositionsOnly) {
      breakoutIndex.value += 1;
      //posiSize2.width *= getSizeRatio();
      //posiSize2.height *= getSizeRatio();
      breakoutPositions[Utility.getUniqueNumberFromId(breakoutIndex.value, id, listType)] = posiSize2;
    }
    else {
      var withPinyin = false;

      drawRootZi(
          id,
          listType, //ZiListType.zi,
          posiSize2.transX,
          posiSize2.transY,
          posiSize2.width,
          posiSize2.height,
          posiSize2.charFontSize,
          Colors.brown, /*isSingleColor:*/
          false,
          posiSize2.lineWidth, /*createFrame:*/
          true,
          /*hasRootZiLearned:*/
          false,
          withPinyin,
          Colors.blue,
          true);

      if (showBreakoutDetails && recurLevel == 1) {
        var ziOrComp;
        if (listType == ZiListType.searching) {
          ziOrComp = theSearchingZiList[id];
        }
        else if (listType == ZiListType.component) {
          ziOrComp = theComponentList[id];
        }
        //else if (listType == ZiListType.custom) {
        // show detail is not used currently for custom
        //  var searchingZiId = ZiManager.findIdFromChar(listType, wordsStudy[id]);
        //  ziOrComp = theSearchingZiList[searchingZiId];
        //}

        if (ziOrComp != null) {
          String pinyinAndMeaning = Zi.formatPinyinAndMeaning(
              ziOrComp.pinyin, ziOrComp.meaning);
          displayTextWithValue(
              pinyinAndMeaning, posiSize2.transX + posiSize2.charFontSize * 1.1,
              posiSize2.transY, posiSize2.charFontSize / 1.7, Colors.blue, false);
        }
      }
    }

    theCurrentZiComponents[recurLevel] = theCurrentZiComponents[recurLevel] + 1;

    var composits = ZiManager.getComposits(id, listType/*, wordsStudy*/);

    if (composits != null && composits.length > 0)
    {
      var newRecurLevel = recurLevel + 1;

      // if showBreakoutDetails, stop at recurLevel 1
      if (!showBreakoutDetails || (showBreakoutDetails && newRecurLevel <= 1)) {
        var size = 89.0 * getSizeRatio(); //100 // length of each layer
        for (var i = 0; i < composits.length; i++) {
          drawZiAndComponentsDissembling(newRecurLevel, i, composits[i].id, composits[i].listType, posiSize2.transX + size, transY, showBreakoutDetails, isBreakoutPositionsOnly, breakoutIndex, breakoutPositions); // transY is the original value
        }
      }

    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}