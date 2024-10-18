
import 'package:flutter/material.dart';
import 'package:hanzishu/data/sentencelist.dart';
import 'dart:ui';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/engine/sentence.dart';
import 'package:hanzishu/engine/texttospeech.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/pinyin.dart';
import 'package:hanzishu/engine/lesson.dart';
import 'package:hanzishu/engine/lessonunit.dart';
import 'package:hanzishu/engine/lessonmanager.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/data/conversationsnowballlist.dart';

class ConversationSnowballPage extends StatefulWidget {
  final int lessonId;
  final PinyinType pinyinType;

  ConversationSnowballPage({required this.lessonId, required this.pinyinType});

  @override
  _ConversationSnowballPageState createState() => _ConversationSnowballPageState();
}

class _ConversationSnowballPageState extends State<ConversationSnowballPage> {
  int lessonId = -1;
  double fontSize1 = 0.0;
  double fontSize2 = 0.0;
  double fontSize3 = 0.0;

  double screenWidth = 0.0;
  ScrollController? _scrollController;
  PrimitiveWrapper contentLength = PrimitiveWrapper(0.0);
  OverlayEntry? overlayEntry = null;
  int previousOverlayGroup = 0;
  int previousOverlayIndex = 0;
  PositionAndMeaning previousPositionAndMeaning = PositionAndMeaning(
      0.0, 0.0, "");
  PinyinType? pinyinType;

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        //print("offset = ${_scrollController.offset}");
      });
    pinyinType = widget.pinyinType;
  }

  initOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
  }

  @override
  void dispose() {
    initOverlay();
    _scrollController
        .dispose(); // it is a good practice to dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidth(context);
    lessonId = widget.lessonId;

    fontSize1 = TheConst.fontSizes[1]; //* getSizeRatioWithLimit();
    fontSize2 = TheConst.fontSizes[2]; //* getSizeRatioWithLimit();
    fontSize2 = TheConst.fontSizes[2]; //* getSizeRatioWithLimit();

    // init positionmanager frame size
    thePositionManager.setFrameWidth(screenWidth);

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(getString(373) /*"Snowball Conversation"*/),
      ),
      body: Container(
        //height: 800.00,

        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: WillPopScope(
              child: Column(
                  children: <Widget>[
                    getSnowballContent(context),
                    getContinue(context),
                  ]
              ),
              onWillPop: _onWillPop
          ),
        ),

      ),
    );
  }

  Future<bool> _onWillPop() {
    return Future.value(true);
  }

  Widget getSnowballContent(BuildContext context) {
    return Column(
      //mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: getRows(lessonId),
    );
  }

  List<Widget> getRows(int lessId) {
    List<Widget> widgets = [];
    //assume just one snowball for each lesson now, so the first one in array.
    var snowballId = theLessonList[lessId].snowballIds[0];
    var sents = theConversationSnowballList[snowballId].sents;

    if (lessId > Lesson.numberOfLessonsInUnit1) // after first unit of lessons
        {
      widgets.add(getPinyinTypeRow());
    }

    for (var i = 0; i < sents!.length; i++) {
      widgets.add(getOneRow(sents[i], i));
      if (lessonId > theNumberOfLessonsInLevels[0]) {
        widgets.add(getPinyinRow(sents[i]));
      }
      widgets.add(getTranslation(sents[i].sentenceId));
      widgets.add(SizedBox(height: 10 * getSizeRatioWithLimit()));
    }

    return widgets;
  }

  Widget getPinyinTypeRow() {
    return Container(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //SizedBox(width: spaceStart * getSizeRatioWithLimit()),
            getOnePinyinType(PinyinType.None),
            getOnePinyinType(PinyinType.OnlyFirst),
            getOnePinyinType(PinyinType.OnlyNewZi),
            getOnePinyinType(PinyinType.Full)
          ]

      ),
    );
  }

  Widget getOnePinyinType(PinyinType onePinyinType) {
    var display = getString(507); // None pinyin
    if (onePinyinType == PinyinType.OnlyFirst) {
      display = getString(508);
    }
    else if (onePinyinType == PinyinType.OnlyNewZi) {
      display = getString(509);
    }
    else if (onePinyinType == PinyinType.Full) {
      display = getString(510);
    }

    return TextButton(
      style: TextButton.styleFrom(
        textStyle: TextStyle(fontSize: 14.0 * getSizeRatioWithLimit()),
      ),
      onPressed: () {
        setState(() {
          pinyinType = onePinyinType;
        });
      },
      child: Text(display,
          style: TextStyle(color: Colors.black)),
    );
  }

  Widget getOneRow(Sent oneSent, int rowIndex) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: getRowButtons(oneSent, rowIndex)
      ),
    );
  }

  Widget getPinyinRow(Sent oneSent) {
    var spaceBeforePinyin = 75.0;
    if (lessonId > 60) {
      spaceBeforePinyin = 50.0;
    }
    return Container(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: spaceBeforePinyin * getSizeRatioWithLimit()),
            getSentencePinyin(oneSent.sentenceId)
          ]
      ),
    );
  }

  Widget getSentencePinyin(int sentenceId) {
    if (pinyinType == PinyinType.None) {
      return SizedBox(width: 0.0, height: 0.0);
    }

    String pinyin = theSentenceList[sentenceId].pinyin;

    if (pinyin.length > 1) {
      if (pinyinType == PinyinType.OnlyFirst) {
        var token = pinyin.split(' '); // ' ' is delimeter
        pinyin = token[0];
      }
      else if (pinyinType == PinyinType.OnlyNewZi) {
        pinyin = ""; // recreate the list for new zi only
      }
    }

    if (pinyin.length == 0) {
      var newCharsInUnit = LessonUnit.getNewCharsInUnit(lessonId);
      pinyin = LessonManager.getPinyinFromSentence(theSentenceList[sentenceId].conv, pinyinType, newCharsInUnit);
    }

    return Text(Utility.adjustPinyinSpace(pinyin), style: TextStyle(fontSize: 16 * getSizeRatioWithLimit()));
  }

  Widget getTranslation(int sentId) {
    // text trans
    String trans = theSentenceList[sentId].trans;
    if (trans.length == 0) {
      trans = LessonManager.getTranslationFromSentence(theSentenceList[sentId].conv);
    }

    var spaceStart = 50.0;
    if (lessonId > 60) {
      spaceStart = 30.0;
    }

    return Container(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: spaceStart * getSizeRatioWithLimit()),
            Flexible(
              child: Container(
                child: Text(trans, style: TextStyle(fontSize: 16 * getSizeRatioWithLimit()), softWrap: true),
              ),
            ),
          ]

      ),
    );
  }

  List<Widget> getRowButtons(Sent oneSent, int rowIndex) {
    var label;
    if (oneSent.player == ' ') {
      label = oneSent.player + '  ';
    }
    else {
      label = oneSent.player + ':';
    }

    var sentText = theSentenceList[oneSent.sentenceId].conv;

    List<Widget> buttons = [];
    buttons.add(SizedBox(width: 10 * getSizeRatioWithLimit()));
    if (lessonId <= 60) {
      buttons.add(Text(
        label, style: TextStyle(fontSize: 20 * getSizeRatioWithLimit())));
      buttons.add(SizedBox(width: 10 * getSizeRatioWithLimit()));
    }

    var oneIcon = Container(
          height: 30.0 * getSizeRatioWithLimit(), //180
          width: 30.0 * getSizeRatioWithLimit(),
          child: IconButton(
            icon: Icon(
              Icons.volume_up,
              size: 30.0 * getSizeRatioWithLimit(), // 150
            ),
            color: Colors.cyan, //Colors.green,
            onPressed: () {
              initOverlay();
              TextToSpeech.speak("zh-CN", sentText);
            },
          )
    );
    buttons.add(oneIcon);
    buttons.add(SizedBox(width: 15 * getSizeRatioWithLimit()));
    //Text(sentText,
    //  style: TextStyle(fontSize: 25 * getSizeRatioWithLimit()),),

    for (int i = 0; i < sentText.length; i++) {
      var butt = TextButton(
        style: TextButton.styleFrom(
          textStyle: TextStyle(fontSize: 25.0 * getSizeRatioWithLimit()),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.fromLTRB(2.5, 0.0, 2.5, 0.0)
        ),
        onPressed: () {
            initOverlay();
            TextToSpeech.speak("zh-CN", sentText[i]);
        },
        onLongPress: () {
          initOverlay();
          TextToSpeech.speak("zh-CN", sentText[i]);
          var ziId = ZiManager.findIdFromChar(ZiListType.searching, sentText[i]);
          var meaning = ZiManager.getOnePinyinAndMeaning(ziId, ZiListType.searching);
          var posiAndSize = PositionAndSize((150.0 + rowIndex) * getSizeRatioWithLimit(), (85.0 + (rowIndex * 25)) * getSizeRatioWithLimit(), 20.0 * getSizeRatioWithLimit(), 20.0 * getSizeRatioWithLimit(), 0.0, 0.0);
          showOverlay(context, posiAndSize.transX, posiAndSize.transY, meaning);
        },
        child: Text(sentText[i],
            style: TextStyle(color: Colors.blue)),
      );
      buttons.add(Container(child: butt));
    }

    return buttons;
  }

  Widget getContinue(BuildContext context) {
    var buttonText = getString(285); // Continue

    if (theIsFromLessonContinuedSection) {
      return Container(
        child: TextButton(
          child: Text(buttonText,
            style: TextStyle(fontSize: getSizeRatioWithLimit() * 18.0, color: Colors.white),),
          //color: Colors.blueAccent,
          //textColor: Colors.white,
          onPressed: () {
            theIsBackArrowExit = false;
            Navigator.of(context).pop();
          },
        ),
      );
    }
    else {
      return SizedBox(width: 0, height: 0);
    }
  }

  showOverlay(BuildContext context, double posiX, double posiY, String meaning) {
    initOverlay();

    if (previousPositionAndMeaning.x != posiX || previousPositionAndMeaning.y != posiY || previousPositionAndMeaning.meaning != meaning) {
      var screenWidth = Utility.getScreenWidth(context);
      var adjustedXValue = Utility.adjustOverlayXPosition(posiX, screenWidth);

      OverlayState overlayState = Overlay.of(context);
      overlayEntry = OverlayEntry(
          builder: (context) =>
              Positioned(
                  top: posiY,
                  left: adjustedXValue,
                  /*
                  child: FlatButton(
                    child: Text(meaning, style: TextStyle(fontSize: getSizeRatioWithLimit() * 20.0),),
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    onPressed: () {},
                  )*/

                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blueAccent, //Colors.red.shade50,
                      textStyle: TextStyle(fontSize: 20.0 * getSizeRatioWithLimit()),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.fromLTRB(2.5, 0.0, 2.5, 0.0),
                      ),
                     onPressed: () {
                        initOverlay();
                        },
                      child: Text(meaning,
                          style: TextStyle(color: Colors.white)),
                  )
              ));
      overlayState.insert(overlayEntry!);
      previousPositionAndMeaning.set(posiX, posiY, meaning);
    }
    else {
      previousPositionAndMeaning.set(0.0, 0.0, "");
    }
  }
}