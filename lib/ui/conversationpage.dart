

import 'package:flutter/material.dart';
import 'package:hanzishu/data/sentencelist.dart';
import 'dart:ui';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/engine/pinyin.dart';
import 'package:hanzishu/engine/texttospeech.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/lessonmanager.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/engine/lesson.dart';

class ConversationPage extends StatefulWidget {
  final int lessonId;
  final PinyinType pinyinType;
  ConversationPage({required this.lessonId, required this.pinyinType});

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
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
  //bool hasPressedContinue = false;

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
    _scrollController!
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
        title: Text(getString(4) /*"Conversation"*/),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: WillPopScope(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18.0, 24.0, 18.0, 28.0),
              child: Column(
                children: <Widget>[
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: getSkipThisSection(),
                      ),
                    ),
                  ),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: getConversationContent(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28.0),
                  getContinue(context),
                ],
              ),
            ),
            onWillPop: _onWillPop,
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    return Future.value(true);
  }

  Widget getConversationContent(BuildContext context) {
    return Column(
      //mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: getRows(lessonId),
    );
  }

  List<Widget> getRows(int lessId) {
    List<Widget> widgets = [];
    var sents = theLessonList[lessId].sentenceList; //  snowballIds[0];

    if (lessId > Lesson.numberOfLessonsInUnit1) // after first unit of 9 lessons
        {
      widgets.add(getPinyinTypeRow());
    }

    for (var i = 0; i < sents.length; i++) {
      widgets.add(getOneRow(sents[i], i));
      if (pinyinType != PinyinType.None) { // after level 1
        widgets.add(getPinyinRow(sents[i], pinyinType!));
      }
      widgets.add(getTranslation(sents[i]));
      widgets.add(SizedBox(height: 16.0 * getSizeRatioWithLimit()));
    }

    return widgets;
  }

  Widget getPinyinTypeRow() {
    return Container(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //SizedBox(width: spaceStart * getSizeRatioWithLimit()),
            getOnePinyinType(PinyinType.Full),
            getOnePinyinType(PinyinType.OnlyNewZi),
            getOnePinyinType(PinyinType.OnlyFirst),
            getOnePinyinType(PinyinType.None),
          ]

      ),
    );
  }

  Widget getOnePinyinType(PinyinType onePinyinType) {
    var color = Colors.black;
    if (pinyinType == onePinyinType)
    {
      color = Colors.green;
    }
    var display = ''; // None pinyin
    if (onePinyinType == PinyinType.OnlyFirst) {
      display = getString(508);
    }
    else if (onePinyinType == PinyinType.OnlyNewZi) {
      display = getString(509);
    }
    else if (onePinyinType == PinyinType.Full) {
      display = getString(510);
    }
    else if (onePinyinType == PinyinType.None) {
      display = getString(507);
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
          style: TextStyle(color: color)),
    );
  }

  Widget getOneRow(int sentId, int rowIndex) {
    return Container(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: getRowButtons(sentId, rowIndex)
      ),
    );
  }

  Widget getPinyinRow(int sentId, PinyinType pinyinType) {
    var spaceStart = 72.0;
    if (lessonId > 60) {
      spaceStart = 44.0;
    }

    return Container(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: spaceStart * getSizeRatioWithLimit()),
            getSentencePinyin(sentId, pinyinType)
          ]

      ),
    );
  }

  Widget getSentencePinyin(int sentenceId, PinyinType pinyinType) {
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
      pinyin = LessonManager.getPinyinFromSentence(theSentenceList[sentenceId].conv, pinyinType, theLessonList[lessonId].convChars);
    }
    return Text(Utility.adjustPinyinSpace(pinyin), style: TextStyle(fontSize: 16 * getSizeRatioWithLimit()));
  }

  Widget getTranslation(int sentId) {
    // text trans
    String trans = theSentenceList[sentId].trans;
    if (trans.length == 0) {
      trans = LessonManager.getTranslationFromSentence(theSentenceList[sentId].conv);
    }

    var spaceStart = 72.0;
    if (lessonId > 60) {
      spaceStart = 44.0;
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

  List<Widget> getRowButtons(int sentId, int rowIndex) {
    var sentText = theSentenceList[sentId].conv;

    List<Widget> buttons = [];
    if (lessonId <= 60) {
      buttons.add(
        SizedBox(
          width: 28.0 * getSizeRatioWithLimit(),
          child: Text(
            "${rowIndex + 1}.",
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 14.0 * getSizeRatioWithLimit(),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    var oneIcon = SizedBox(
      height: 34.0 * getSizeRatioWithLimit(),
      width: 34.0 * getSizeRatioWithLimit(),
      child: IconButton(
        icon: Icon(
          Icons.volume_up,
          size: 26.0 * getSizeRatioWithLimit(),
        ),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        color: Colors.cyan,
        onPressed: () {
          initOverlay();
          TextToSpeech.speak("zh-CN", sentText);
        },
      ),
    );
    buttons.add(oneIcon);
    buttons.add(SizedBox(width: 10.0 * getSizeRatioWithLimit()));
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

  Widget getSkipThisSection() {
    if (theIsFromLessonContinuedSection) {
      return TextButton(
        child: Text(
          getString(401), // Skip this section
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.blueAccent,
          ),
        ),
        onPressed: () {
          theIsBackArrowExit = false;
          Navigator.of(context).pop();
        },
      );
    }
    else {
      return const SizedBox(width: 0, height: 0);
    }
  }

  Widget getContinue(BuildContext context) {
    var buttonText = getString(285) + " ->"; // Continue

    if (theIsFromLessonContinuedSection) {
      return SizedBox(
        width: 220.0,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.0),
            ),
          ),
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: getSizeRatioWithLimit() * 18.0,
              color: Colors.black87,
            ),
          ),
          onPressed: () {
            //if (lessonId > Lesson.numberOfLessonsInLevel1 && pinyinType != PinyinType.None && !hasPressedContinue) {
            //  hasPressedContinue = true;
            //  setState(() {
            //    pinyinType = PinyinType.None;
            //  });
            //}
            //else {
            theIsBackArrowExit = false;
            Navigator.of(context).pop();
            //}
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
      var contentLeftOffset = Utility.getCenteredContentLeftOffset(context, screenWidth);
      var adjustedXValue = Utility.adjustOverlayXPosition(posiX + contentLeftOffset, screenWidth);

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
