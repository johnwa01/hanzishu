import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import 'package:hanzishu/engine/lesson.dart';
import 'package:hanzishu/data/lessonlist.dart';
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

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidth(context);
    // init positionmanager frame size
    thePositionManager.setFrameWidth(screenWidth);

    var painterHeight = MediaQuery.of(context).size.height + 150.0;  // add some buffer at the end

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("List of Zi"),
      ),
      body: Container(
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
            child: CustomPaint(
                foregroundPainter: ListOfZiPainter(
                    lineColor: Colors.amber,
                    completeColor: Colors.blueAccent,
                    lessonId: widget.lessonId,
                    //completePercent: percentage,
                    screenWidth: screenWidth
                ),
                size: new Size(screenWidth, painterHeight),

                //child: Center(
                //  child: Stack(
                //      children: createHittestButtons(context)
                //  ),
                //),
            ),
        ),

      ),
    );
  }

  Positioned getPositionedButton(int uniqueNumber, PositionAndSize posiAndSize) {
    var id = Utility.getIdFromUniqueNumber(uniqueNumber);
//TODO: no need for unique number in this case

    var butt = FlatButton(
      color: Colors.white,
      textColor: Colors.blueAccent,
      onPressed: () {
        var zi = theZiManager.getZi(id);
        TextToSpeech.speak(zi.char);
      },
      child: Text('', style: TextStyle(fontSize: 20.0),),
    );

    var posiCenter = Positioned(
        top: posiAndSize.transY,
        left: posiAndSize.transX,
        height: posiAndSize.height,
        width: posiAndSize.width,
        child: butt
    );

    return posiCenter;
  }

  List<Widget> createHittestButtons(BuildContext context) {
    List<Widget> buttons = [];

//    var listOfZiPositions = theLessonManager.getListOfZiPositions(widget.lessonId);
//    if (listOfZiPositions.length == 0) {
//      var painter = ListOfZiPainter();
//      listOfZiPositions = painter.getListOfZiPositions(widget.lessonId);
//    }

    var painterHeight = MediaQuery.of(context).size.height; // + 150.0;  // add some buffer at the end
    buttons.add (Container(height: painterHeight, width: screenWidth));  // workaround to avoid infinite size error

//    listOfZiPositions.forEach((uniqueNumber, position) =>
//        buttons.add(getPositionedButton(uniqueNumber, position)));

    return buttons;
  }

}