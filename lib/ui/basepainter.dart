import 'package:flutter/material.dart';
import 'package:hanzishu/data/phraselist.dart';
import 'dart:math';
import 'dart:ui';
import 'package:hanzishu/engine/lesson.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/component.dart';
import 'package:hanzishu/engine/componentmanager.dart';
import 'package:hanzishu/engine/generalmanager.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/utility.dart';


class BasePainter extends CustomPainter{
  static double FrameLineWidth = 1.0;

  int theCreatedNumber = 0;
  var totalSideNumberOfZis = NumberOfZis(0, 0, 0, 0);
  var theDefaultTransparentFillColor = Colors
      .cyan; //UIColor(red: 0.7294, green: 0.9882, blue: 0.8941, alpha: 0.5);

  List<double> iconSpeechStrokes = [4.0, 0.25, 0.5, 8.0, 0.25,0.25, 8.0, 0.5, 0.25, 8.0, 0.75, 0.0, 8.0, 0.75, 1.0, 8.0, 0.5, 0.75, 8.0, 0.25, 0.75, 8.0, 0.25, 0.5];
  List<double> iconPenStrokes = [4.0, 0.375, 0.125, 8.0, 1.0, 0.75, 8.0, 0.75, 1, 8.0, 0.125, 0.375, 8.0, 0.125, 0.125, 8.0, 0.375, 0.125, 8.0, 0.125, 0.375];
  List<double> iconZiLearnedStrokes = [4.0, 0.125, 0.5, 8.0, 0.375, 0.75, 8.0, 0.875, 0.25];
  List<double> iconNewCharStrokes = [4.0, 0.0, 0.5, 8.0, 0.75, 0.25, 8.0, 0.5, 1.0, 8.0, 0.0, 0.5];

  bool isFromReviewPage = false;

  Color lineColor;
  Color completeColor;
  double width;
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

  @override
  void paint(Canvas canvas, Size size) {
    this.  canvas = canvas;
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

  void displayText(int id, double transX, double transY, double charFontSize, Color color) {
    var zi = theZiManager.getZi(id);
    var char = zi.char;

    displayTextWithValue(char, transX, transY, charFontSize, color);
  }

  /*
  void displayComponentText(int id, double transX, double transY, double charFontSize, Color color) {
    var component = theComponentManager.getComponent(id);
    var char = component.charOrNameOfNonchar;

    displayTextWithValue(char, transX, transY, charFontSize, color);
  }
*/

  void displayTextForPinyin(int id, double transX, double transY, double charFontSize, Color color, bool trim) {
    var zi = theZiManager.getZi(id);
    var char = zi.pinyin;
    var displayChar = char;

    if (trim && displayChar.length > 7) {
      displayChar = displayChar.substring(0, 4);
      displayChar += "...";
    }

    displayTextWithValue(displayChar, transX, transY, charFontSize, color);
  }

  void displayTextForMeaning(int id, double transX, double transY, double charFontSize, Color color, bool trim) {
    var zi = theZiManager.getZi(id);
    var char = zi.meaning;

    var firstMeaning = Utility.getFirstMeaning(char);
    var displayMeaning = firstMeaning;

    if (trim && firstMeaning.length > 8) {
      displayMeaning = firstMeaning.substring(0, 5);
      displayMeaning += "...";
    }

    displayTextWithValue(displayMeaning, transX, transY, charFontSize, color);
  }

  void displayTextWithValue(var char, double transX, double transY, double charFontSize, Color color) {
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

    TextSpan span = TextSpan(style: TextStyle(color: color/*Colors.blue[800]*/, fontSize: charFontSize/*, fontFamily: 'Roboto'*/), text: char);
    //TextPainter tp = TextPainter(span, TextDirection.ltr);
    var tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout(
      minWidth: 0,
      maxWidth: this.width - transX,
    );
    tp.paint(canvas, Offset(transX, transY));
  }

  double textTransYAdjust(double transY, double heightY) {
    return transY - heightY / 2.0;
  }

  void drawRootZi(int id, double transX, double transY, double widthX, double heightY, double charFontSize, MaterialColor ofColor, bool isSingleColor, double ziLineWidth, bool createFrame, bool hasRootZiLearned, bool withPinyin, MaterialColor frameFillColor, bool shouldDrawChar)
  {
    // has the index global so that each displayed char has a unique index regardless whether it has popup or not; it's init to 1 whenever a center zi in the tree is changed

    //TODO: thePopupTipIndex += 1;
    if (shouldDrawChar) {
      var zi = theZiManager.getZi(id);
      if (zi.isStrokeOrNonChar() && zi.char != '*' /*&& !isReviewCenterPseudoZi &&
          !isReviewCenterPseudoNonCharZi*/) {
        var strokes = theZiManager.getZi(id).strokes;

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
        double textTransYAdjusted = textTransYAdjust(transY, heightY);
        displayText(
            id, transX, textTransYAdjusted, charFontSize, Colors.blue[800]);
      }
    }

    if (withPinyin && theConfig.withSoundAndExplains && !isReviewCenterPseudoZi && !isReviewCenterPseudoNonCharZi) {
      displayTextForPinyin(id, transX, transY - charFontSize * 0.45, charFontSize * 0.27, Colors.blue[800], true);
    }

    if (theConfig.withSoundAndExplains && hasRootZiLearned) {
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
        //TODO: next line not used
        double textTransYAdjusted = textTransYAdjust(transY, heightY);

        displayTextWithValue(char, transX, transY, charFontSize, Colors.blue[800]);
        //displayComponentText(
        //    id, transX, textTransYAdjusted, charFontSize, Colors.blue[800]);
    }
  }

  void drawComponentZi(String doubleByteCode, double transX, double transY, double widthX, double heightY, double charFontSize, MaterialColor ofColor, bool isSingleColor, double ziLineWidth)
  {
    var  comp = theComponentManager.getComponent(doubleByteCode);

    if (comp != null) {
      var char = comp.charOrNameOfNonchar;
      var strokes = comp.strokes;
//TEMP: all uses strokes for testing purpose
    //  if (!comp.isChar) {
        buildBaseZi(
            strokes,
            transX,
            transY,
            widthX,
            heightY,
            ofColor, /*int hitTestId,*/
            isSingleColor,
            ziLineWidth);
      //}
      //else {
      //  displayTextWithValue(
      //      char, transX, transY, charFontSize, Colors.blue[800]);
      //}
    }
  }

  void drawStrokeZi(String strokeCode, double transX, double transY, double widthX, double heightY, double charFontSize, MaterialColor ofColor, bool isSingleColor, double ziLineWidth)
  {
    var  stroke = theStrokeManager.getStroke(strokeCode);

    if (stroke != null) {
      var strokes = stroke.shape;
      //  if (!comp.isChar) {
      buildBaseZi(
          strokes,
          transX,
          transY,
          widthX,
          heightY,
          ofColor,
          isSingleColor,
          ziLineWidth);
    }
  }

  // currently used for compound zi animation
  void drawCenterZi(int ziId) {
    var posiSize = thePositionManager.getPositionAndSizeHelper("m", 1, PositionManager.theBigMaximumNumber);
    drawRootZi(ziId, posiSize.transX, posiSize.transY, posiSize.width, posiSize.height, posiSize.charFontSize, Colors.brown/*ziColor*/, /*isSingleColor:*/ true, posiSize.lineWidth, /*createFrame:*/ true, false /*rootZiLearned*/, false/*withPinyin*/, Colors.cyan /*TODO*/, true);
  }

  /*
  void drawOnePartialFrameWithColors(List<double> list) {
    var path = Path();
    path.moveTo(list[0], list[1]);
    path.lineTo(list[2], list[3]);
    path.moveTo(list[4], list[5]);
    path.lineTo(list[6], list[7]);
    path.lineTo(list[8], list[9]);

    drawShape(path, Colors.amber, 2.0);
  }
  */

  void drawOneFrameLineWithColor(List<double> list) {
    var path = Path();
    path.moveTo(list[0], list[1]);
    path.lineTo(list[2], list[3]);

    drawShape(path, Colors.amber, 2.0);
  }

  void drawFrameWithColors(double width, double leftEdge, double topEdge,
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
    drawOneFrameLineWithColor([x1, y1, x4, y1]);
    drawOneFrameLineWithColor([x4, y1, x4, y4]);
    drawOneFrameLineWithColor([x4, y4, x1, y4]);
    drawOneFrameLineWithColor([x1, y4, x1, y1]);

    if (centerId != 1) {
      // inside frame
      drawOneFrameLineWithColor([x2, y2, x3, y2]);
      drawOneFrameLineWithColor([x3, y2, x3, y3]);
      drawOneFrameLineWithColor([x3, y3, x2, y3]);
      drawOneFrameLineWithColor([x2, y3, x2, y2]);

      if (!Utility.isPseudoRootZiId(centerId) && !Utility.isPseudoNonCharRootZiId(centerId)) {
        // lines in between
        drawOneFrameLineWithColor([x1, y1, x2, y2]);
        drawOneFrameLineWithColor([x4, y1, x3, y2]);
        drawOneFrameLineWithColor([x4, y4, x3, y3]);
        drawOneFrameLineWithColor([x1, y4, x2, y3]);
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

  void displayCenterZiRelated(int id, double charFontSize) {
    var posiAndSizeMeaning = thePositionManager.getMeaningPosi();
    var posiAndSizeSpeech = thePositionManager.getCenterSpeechPosi();
    var posiAndSizeBihua = thePositionManager.getCenterBihuaPosi();

    displayTextForMeaning(id, posiAndSizeMeaning.transX, posiAndSizeMeaning.transY, posiAndSizeMeaning.width, Colors.blue[800], true);

    DisplayIcon(iconSpeechStrokes, posiAndSizeSpeech.transX, posiAndSizeSpeech.transY, posiAndSizeSpeech.width, posiAndSizeSpeech.height, Colors.amber/*MaterialColor ofColor*/, 2.0/*ziLineWidth*/);

    //if (theZiManager.getZiType(id) == 'b') {   //TODO: 'j' for basic zi char
      DisplayIcon(
          iconPenStrokes,
          posiAndSizeBihua.transX,
          posiAndSizeBihua.transY,
          posiAndSizeBihua.width,
          posiAndSizeBihua.height,
          Colors.amber /*MaterialColor ofColor*/,
          2.0 /*ziLineWidth*/);
    //}

    if (!isFromReviewPage && isCharNewInLesson(id)) {
      var posiNewChar = thePositionManager.getNewCharIconPosi();
      DisplayIcon(
          iconNewCharStrokes,
          posiNewChar.transX,
          posiNewChar.transY,
          posiNewChar.width,
          posiNewChar.height,
          Colors.amber /*MaterialColor ofColor*/,
          2.0 /*ziLineWidth*/);
    }

    var posi = thePositionManager.getHintPosi();
    DisplayHint(id, false, posi);
  }

  void drawZiGroup(int id, int internalStartLessonId, int internalEndLessonId) {
    var ziColor = Colors.brown;

    // one center zi first
    var posiSize = getCenterPositionAndSize(centerPositionAndSizeCache); //thePositionManager.getPositionAndSizeHelper("m", 1, BigMaximumNumber/*, isCreationList: true*/);

    var withPinyin = true;

    theCurrentCenterZiId = id;
    theCreatedNumber = 0;

    bool allMemberZiLearned = true;

    thePositionManager.resetPositionIndex();

    // get its real members
    //var groupMembers = theLessonManager.getRealGroupMembers(id);
    var groupMembers;
    // hardcode lesson 2 so that it'll have a sequential order in top layer display

    groupMembers = getRealGroupMembers(id, internalStartLessonId, internalEndLessonId, realGroupMembersCache);

    //var phraseZis = theLessonManager.getPhraseZis(id, internalStartLessonId, internalEndLessonId);
    //TODO: including phraseZis
    totalSideNumberOfZis = theZiManager.getNumberOfZis(groupMembers);

    for (var index = 0; index < groupMembers.length; index++) {
      var memberZiId = groupMembers[index];

      var posiSize2;
      //var posiSize2 = theLessonManager.getPositionAndSize(memberZiId, theTotalSideNumberOfZis/*, isCreationList: false*/);
      //if (id == 1 && isFromReviewPage) {
      //  var rootZiDisplayIndex = thePositionManager.getRootZiDisplayIndex(memberZiId);
      //  posiSize2 = thePositionManager.getReviewRootPositionAndSize(rootZiDisplayIndex);
      //}
      //else {
        posiSize2 = getPositionAndSize(memberZiId, totalSideNumberOfZis, sidePositionsCache);
        //posiSize2 = theLessonManager.getPositionAndSize(memberZiId, totalSideNumberOfZis);
        //posiSize2 = thePositionManager.getPositionAndSize(
        //    memberZiId, totalSideNumberOfZis /*, isCreationList: false*/);
      //}
      var memberZiLearned = doesZiExistInLearnedMap(memberZiId); //GeneralManager.hasZiCompleted(memberZiId, theHittestState, theCurrentLessonId);
      allMemberZiLearned = allMemberZiLearned && memberZiLearned;

      var isSingleColor = false;
      if (theCurrentCenterZiId == 1) { // the root graph
        isSingleColor = true;
      }
      var frameFillColor = Colors.blue; //Colors.white;  //TODO: white and black are treated differently from other colors.
      if (memberZiId == thePreviousCenterZiId) {
        frameFillColor = theDefaultTransparentFillColor;
      }

      // check if its a composite zi and return partial zi
      var partialZiId = memberZiId;
      //id = 155 ->六  [In the tree, treat it as a basic one. but in word list etc, still keep as multiple component char.
      if (theIsPartialZiMode && memberZiId != 155) {
        partialZiId = theZiManager.getPartialZiId(id, memberZiId);
      }
      drawRootZi(partialZiId, posiSize2.transX, posiSize2.transY, posiSize2.width, posiSize2.height, posiSize2.charFontSize, ziColor, isSingleColor, posiSize2.lineWidth, /*createFrame*/ true, /*hasRootZiLearned*/ memberZiLearned, withPinyin, frameFillColor, true);

      thePositionManager.updatePositionIndex(memberZiId);
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
    if (!centerZiAndChildrenLearned && allMemberZiLearned) {
      centerZiAndChildrenLearned = true;
      setCenterZiLearned(id);
    }

    // skip the center zi for id == 1, which is the default empty root zi.
    // the Chinese character zi "-" has an id of 170.
    //TODO：add checking to not display center pseudo root zi for treepage mode - !isFromReviewPage
    if (id > 1) {
      //var rootZiLearned = GeneralManager.hasZiCompleted(id, theHittestState, theCurrentLessonId);

      if (isFromReviewPage && Utility.isPseudoRootZiIdPlusStar(id)) {
        isReviewCenterPseudoZi = true;
      }
      if (isFromReviewPage && Utility.isPseudoNonCharRootZiId(id)) {
        isReviewCenterPseudoNonCharZi = true;
      }

      drawRootZi(
            id,
            posiSize.transX,
            posiSize.transY,
            posiSize.width,
            posiSize.height,
            posiSize.charFontSize,
            ziColor, /*isSingleColor:*/
            true,
            posiSize.lineWidth, /*createFrame:*/
            true,
            centerZiAndChildrenLearned,
            withPinyin,
            Colors.cyan /*TODO*/,
            shouldDrawCenter);

      if (theConfig.withSoundAndExplains && !isReviewCenterPseudoZi && !isReviewCenterPseudoNonCharZi && (id != theConst.starCharId) ) {
        displayCenterZiRelated(id, posiSize.charFontSize);
      }

      // draw navigation path
      displayNavigationPath(id);

      isReviewCenterPseudoZi = false;
      isReviewCenterPseudoNonCharZi = false;
    }
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

  static PositionAndSize getPositionAndSize(int ziId, NumberOfZis totalSideNumberOfZis, Map<int, PositionAndSize> sidePositions) {
    // NOTE: in review mode, the theCurrentLesson might mean the last lesson in the range
    //var currentLesson = theLessonList[theCurrentLessonId];
    // check cache first
    var positionAndSize = getPositionAndSizeFromCache(ziId, sidePositions);

    if (positionAndSize == null) {
      positionAndSize = thePositionManager.getPositionAndSize(ziId, totalSideNumberOfZis);
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

  static List<int> getRealGroupMembers(int id, int internalStartLessonId, int internalEndLessonId, Map<int, List<int>>realGroupMembersCache) {
    var realGroupMembers = getRealGroupMembersFromCache(id, realGroupMembersCache);

    //TODO: temp remove for debugging
    if (realGroupMembers == null) {
      // hardcode for lesson 2's number to have a sequential display order
      if (id == 1 && internalStartLessonId == 2 && internalEndLessonId == internalStartLessonId) {
        realGroupMembers = [2, 3, 170, 153, 154, 7, 155, 8, 10, 157];
      }
      else {
        realGroupMembers = theZiManager.getRealGroupMembers(id, internalStartLessonId, internalEndLessonId);
      }
      addToRealGroupMembersCache(id, realGroupMembers, realGroupMembersCache);
    }

    return realGroupMembers;
  }

  static PositionAndSize getCenterPositionAndSize(PositionAndSize centerPositionAndSizeCache) {
    if (centerPositionAndSizeCache == null) {
      centerPositionAndSizeCache = thePositionManager.getPositionAndSizeHelper("m", 1, PositionManager.theBigMaximumNumber);
    }

    return centerPositionAndSizeCache;
  }

  DisplayHint(int id, bool isPhrase, PositionAndSize posi) {
    var ziOrPhraseHint;
    if (isPhrase) {
      ziOrPhraseHint = thePhraseList[id].hint;
    }
    else {
      ziOrPhraseHint = theZiManager.getZi(id).origin;
    }

    displayTextWithValue("Hint: ", posi.transX, posi.transY,
        thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize),
        Colors.blue);

    PrimitiveWrapper xPosi = PrimitiveWrapper(posi.transX);
    xPosi.value += xYLength(45.0);

    DisplayHintHelper(ziOrPhraseHint, xPosi, posi);
  }

  DisplayHintHelper(String hint, PrimitiveWrapper xPosi, PositionAndSize posi) {
    if (hint.contains("[")) {
      // find string before it
      // display the string
      var  indexStart = hint.indexOf('[');
      if (indexStart != null) {
        //var stringBeforeIndex = hint[..<indexStart];
        var realStringBeforeIndex = hint.substring(0, indexStart); //String(stringBeforeIndex);

        displayTextWithValue(realStringBeforeIndex, xPosi.value, posi.transY, thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize), Colors.blue);
        HintSubstringContainsZi(realStringBeforeIndex, xPosi);

        // find the next "]"
        // get the string between [ and ]
        // display the char
        var indexPair = hint.indexOf(']');
        if (indexPair != null) {
          //var indexStartPlusOne = hint.index(indexStart, offsetBy: 1);
          //var charIdString = hint[indexStartPlusOne..<indexPair];
          var charIdString = hint.substring(indexStart + 1, indexPair);
          var id = Utility.StringToInt(charIdString);

          if (id != null) {
            displayTextWithValue('(', xPosi.value, posi.transY, thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize), Colors.blue);
            xPosi.value = xPosi.value + xYLength(9.0);

            drawRootZi(id, xPosi.value, posi.transY, xYLength(30.0), xYLength(30.0), thePositionManager.getCharFontSize(ZiOrCharSize.sideSmallSize), Colors.blue, false, xYLength(2.0), false, false, false, Colors.blue, true);
            xPosi.value = xPosi.value + xYLength(25.0);
            displayTextWithValue(')', xPosi.value, posi.transY, thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize), Colors.blue);
            //DisplayText(theLessonsTextTag, xPosi.value, yPosi, ScreenManager.screenWidth - xYLength(10.0), theAnswerTextHeight, ")", theDefaultSize, UIColor.black);
            xPosi.value = xPosi.value + xYLength(9.0);
          }

          // find the substring after ]
          //var indexPairPlusOne = hint.index(indexPair, offsetBy: 1);
          var indexPairPlusOne = indexPair + 1;
          if (hint.length > indexPairPlusOne) {
            var rightString = hint.substring(indexPairPlusOne, hint.length);
            DisplayHintHelper(rightString, xPosi, posi);
         }
       }
     }
    }
    else {
      displayTextWithValue(hint, xPosi.value, posi.transY, thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize), Colors.blue);
      //DisplayText(theLessonsTextTag, xPosi, yPosi, theAnswerStringLength - xYLength(15.0), theAnswerTextHeight * 2, hint, theDefaultSize, UIColor.black);
      HintSubstringContainsZi(hint, xPosi);
    }
  }

  HintSubstringContainsZi(String hint, PrimitiveWrapper xPosi) {
    xPosi.value = xPosi.value + hint.length * 8;
    var  indexStart = hint.indexOf('(');
    if (indexStart != null) {
      xPosi.value = xPosi.value + xYLength(20.0);
    }
  }

  bool isCharNewInLesson(int id) {
    if (newInLesson.containsKey(id)) {
      return newInLesson[id];
    }
    else {
      var lesson = theLessonList[theCurrentLessonId];
      var isNew = lesson.isCharNewInLesson(id);
      newInLesson[id] = isNew;
      return isNew;
    }
  }

  displayNavigationPath(int ziId) {
    var posi = thePositionManager.getNavigationPosi();
    displayOneNaviationPathChar(0, ziId, posi);
  }

  displayOneNaviationPathChar(int recurLevel, int id, PositionAndSize posi) {

      var withPinyin = false;

      var zi = theZiManager.getZi(id);
      if (zi.id != 1) // till hit root
        {
        var newRecurLevel = recurLevel + 1;
        var parentId = zi.parentId;

        displayOneNaviationPathChar(newRecurLevel, parentId, posi);
      }

      // for lesson, skip those pseudo ones.
      if (isFromReviewPage || (!Utility.isPseudoNonCharRootZiId(id) && !Utility.isPseudoRootZiId(id))) {
        if (zi.id != 1) {
          posi.transX += xYLength(18.0); // 23.0
          displayTextWithValue(
              " -> ", posi.transX, posi.transY - posi.charFontSize * 0.3,
              posi.charFontSize, Colors.brown);
          posi.transX += xYLength(36.0); //15.0
        }

        var frameFillColor = Colors.yellow;
        var createFrame = false;
        if (recurLevel != 0) {
          frameFillColor = theDefaultTransparentFillColor;
          createFrame = true;
        }

        drawRootZi(
            id,
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

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}