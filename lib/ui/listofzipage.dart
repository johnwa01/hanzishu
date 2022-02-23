import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import 'package:hanzishu/engine/lesson.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/data/phraselist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/listofzipainter.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/engine/texttospeech.dart';


class ListOfZiPage extends StatefulWidget {
  final int lessonId;
  ListOfZiPage({this.lessonId});

  @override
  _ListOfZiPageState createState() => _ListOfZiPageState();
}

class _ListOfZiPageState extends State<ListOfZiPage> {
  double screenWidth;
  ScrollController _scrollController;
  PrimitiveWrapper contentLength = PrimitiveWrapper(0.0);

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
    _scrollController.dispose(); // it is a good practice to dispose the controller
    super.dispose();
  }

  double getSizeRatio() {
    var defaultSize = screenWidth / 16.0; // equivalent to the original hardcoded value of 25.0
    return defaultSize / 25.0;
  }

  double applyRatio(double value) {
    return value * getSizeRatio();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidth(context);
    // init positionmanager frame size
    thePositionManager.setFrameWidth(screenWidth);

    var listOfZiPainter = ListOfZiPainter(
        lineColor: Colors.amber,
        completeColor: Colors.blueAccent,
        lessonId: widget.lessonId,
        //completePercent: percentage,
        screenWidth: screenWidth
    );

    List<SpeechIconInfo> listOfSpeechIconInfo = List<SpeechIconInfo>();
    // get iconinfo only, isInfoOnly = true
    listOfZiPainter.displayAllZi(widget.lessonId, true, listOfSpeechIconInfo, contentLength);

    //contentLength = MediaQuery.of(context).size.height; this is inaccurate

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Character list"),
      ),
      body: Container(
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
            child: CustomPaint(
                foregroundPainter: listOfZiPainter,
                size: new Size(screenWidth, contentLength.value),

                child: Center(
                  child: Stack(
                      children: createHittestButtons(context, listOfSpeechIconInfo),
                  ),
                ),
            ),
        ),

      ),
    );
  }

  Positioned getPositionedSpeechButton(SpeechIconInfo speechIconInfo) {
    var butt = FlatButton(
      color: Colors.white,
      textColor: Colors.blueAccent,
      onPressed: () {
        var str;
        if (speechIconInfo.isPhrase) {
          str = thePhraseList[speechIconInfo.id].chars;
        }
        else {
          str = theZiManager.getZi(speechIconInfo.id).char;
        }

        TextToSpeech.speak(str);
      },
      child: Text('', style: TextStyle(fontSize: applyRatio(20.0))),
    );

    var posiCenter = Positioned(
        top: speechIconInfo.yPosi,
        left: speechIconInfo.xPosi,
        height: applyRatio(30.0), //posiAndSize.height,
        width: applyRatio(30.0), //posiAndSize.width,
        child: butt
    );

    return posiCenter;
  }

  List<Widget> createHittestButtons(BuildContext context, List<SpeechIconInfo> listOfSpeechIconInfo) {
    List<Widget> buttons = [];

    buttons.add (Container(height: contentLength.value, width: screenWidth));  // workaround to avoid infinite size error

    for (var i = 0; i < listOfSpeechIconInfo.length; i++) {
        buttons.add(getPositionedSpeechButton(listOfSpeechIconInfo[i]));
    }

    return buttons;
  }

}