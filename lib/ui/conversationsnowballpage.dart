
import 'package:flutter/material.dart';
import 'package:hanzishu/data/sentencelist.dart';
import 'dart:ui';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/engine/sentence.dart';
import 'package:hanzishu/engine/texttospeech.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/data/conversationsnowballlist.dart';

class ConversationSnowballPage extends StatefulWidget {
  final int lessonId;
  ConversationSnowballPage({this.lessonId});

  @override
  _ConversationSnowballPageState createState() => _ConversationSnowballPageState();
}

class _ConversationSnowballPageState extends State<ConversationSnowballPage> {
  int lessonId;
  double fontSize1;
  double fontSize2;
  double fontSize3;

  double screenWidth;
  ScrollController _scrollController;
  PrimitiveWrapper contentLength = PrimitiveWrapper(0.0);
  OverlayEntry overlayEntry;
  int previousOverlayGroup = 0;
  int previousOverlayIndex = 0;

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
  }

  @override
  void dispose() {
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



    for (var i = 0; i < sents.length; i++) {
      widgets.add(getOneRow(sents[i]));
    }

    return widgets;
  }

  Widget getOneRow(Sent oneSent) {
    var sentText = theSentenceList[oneSent.sentenceId].conv;

    var label;
    if (oneSent.player == ' ') {
      label = oneSent.player + ' ';
    }
    else {
      label = oneSent.player + ':';
    }

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 10 * getSizeRatioWithLimit()),
          Text(label, style: TextStyle(fontSize: 25 * getSizeRatioWithLimit()),),
          SizedBox(width: 10 * getSizeRatioWithLimit()),
          Container(
            height: 25.0 * getSizeRatioWithLimit(), //180
            width: 25.0 * getSizeRatioWithLimit(),
            child: IconButton(
              icon: Icon(
                Icons.volume_up,
                size: 25.0 * getSizeRatioWithLimit(),   // 150
              ),
              color: Colors.cyan, //Colors.green,
              onPressed: () {
                TextToSpeech.speak(sentText);
                //setState(() {
                  //setPositionState(AnswerPosition.soundIcon);
                //});
              },
            )
          ),
          SizedBox(width: 15 * getSizeRatioWithLimit()),
          Text(sentText, style: TextStyle(fontSize: 25 * getSizeRatioWithLimit()),),

        ],
      ),
    );
  }

  Widget getContinue(BuildContext context) {
    var buttonText = getString(285); // Continue

    if (theIsFromLessonContinuedSection) {
      return Container(
        child: FlatButton(
          child: Text(buttonText,
            style: TextStyle(fontSize: getSizeRatioWithLimit() * 18.0),),
          color: Colors.blueAccent,
          textColor: Colors.white,
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
}