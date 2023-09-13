import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:hanzishu/data/componentlist.dart';
import 'package:hanzishu/ui/basiccomponentsdetailpainter.dart';
import 'package:hanzishu/variables.dart';
//import 'package:hanzishu/ui/listofzipainter.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/engine/texttospeech.dart';
import 'package:hanzishu/engine/componentmanager.dart';
import 'package:hanzishu/engine/zimanager.dart';

class BasicComponentsDetailPage extends StatefulWidget {
  final int keyGroup;
  final int keyIndex;
  BasicComponentsDetailPage({this.keyGroup, this.keyIndex});

  @override
  _BasicComponentsDetailPageState createState() => _BasicComponentsDetailPageState();
}

class _BasicComponentsDetailPageState extends State<BasicComponentsDetailPage> {
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

    var basicComponentsDetailPainter = BasicComponentsDetailPainter( //BasicComponentsDetailPainter(
        lineColor: Colors.amber,
        completeColor: Colors.blueAccent,
        keyGroup: widget.keyGroup,
        keyIndex: widget.keyIndex,
        //lessonId: widget.lessonId,
        //completePercent: percentage,
        screenWidth: screenWidth
    );

    List<SpeechIconInfo> listOfSpeechIconInfo = List<SpeechIconInfo>();
    // get iconinfo only, isInfoOnly = true
    basicComponentsDetailPainter.displayAllZi(widget.keyGroup, widget.keyIndex, true, listOfSpeechIconInfo, contentLength);

    //contentLength = MediaQuery.of(context).size.height; this is inaccurate

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(getString(384)/*"Hanzi Basic Components"*/),
      ),
      body: Container(
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: CustomPaint(
            foregroundPainter: basicComponentsDetailPainter,
            size: new Size(screenWidth, contentLength.value + 30.0), // 30.0 - extra buffer

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
        var str = ComponentManager.getComponent(speechIconInfo.id).charOrNameOfNonchar;
        TextToSpeech.speak("zh-CN", str);
      },
      child: Text('', style: TextStyle(fontSize: applyRatio(20.0))),
    );

    var posiCenter = Positioned(
        top: speechIconInfo.yPosi - applyRatio(30.0/4.0),
        left: speechIconInfo.xPosi - applyRatio(30.0/4.0),
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