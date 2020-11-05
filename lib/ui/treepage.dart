import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import 'package:hanzishu/engine/lesson.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/treepainter.dart';
import 'package:hanzishu/utility.dart';

class TreePage extends StatefulWidget {
  final int lessonId;
  TreePage({this.lessonId});

  @override
  _TreePageState createState() => _TreePageState();
}

class _TreePageState extends State<TreePage> {
  int centerZiId;
  double screenWidth;
  //double percentage;
  @override
  void initState() {
    super.initState();
    //theLessonList[theCurrentLessonId].populateTreeMap(1);

    setState(() {
      centerZiId = theCurrentCenterZiId;
      //percentage = 0.0;
    });
  }

  /*
  double screenHeight(BuildContext context, {double dividedBy = 1, double reducedBy = 0.0}) {
    return (screenSize(context).height - reducedBy) / dividedBy;
  }
  double screenHeightExcludingToolbar(BuildContext context, {double dividedBy = 1}) {
    return screenHeight(context, dividedBy: dividedBy, reducedBy: kToolbarHeight);
  }
  */

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidth(context);

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Tree Page"),
      ),
      body: Container(
        //height: 200.0,
        //width: 200.0,
        child: CustomPaint(
          foregroundPainter: TreePainter(
              lineColor: Colors.amber,
              completeColor: Colors.blueAccent,
              centerId: centerZiId,
              //completePercent: percentage,
              width: screenWidth
          ),
          child: Center(
            child: Stack(
                children: createHittestButtons()
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> createHittestButtons() {
    List<Widget> buttons = [];

    thePositionManager.resetPositionIndex();
    var realGroupMembers = theLessonManager.getRealGroupMembers(centerZiId);
    var totalSideNumberOfZis = theZiManager.getNumberOfZis(realGroupMembers);
    for (var i = 0; i < realGroupMembers.length; i++) {
      var memberZiId = realGroupMembers[i];
      var button = FlatButton(
          child: Text('', style: TextStyle(fontSize: 20.0),),
          color: Colors.white,
          textColor: Colors.blueAccent,
          onPressed: () {
            setState(() {
              centerZiId = memberZiId;
            });
          });

      var positionAndSize = theLessonManager.getPositionAndSize(memberZiId, totalSideNumberOfZis);
      var posi = Positioned(
          top: positionAndSize.transY,
          left: positionAndSize.transX,
          height: positionAndSize.height,
          width: positionAndSize.width,
          child: button
      );

      buttons.add(posi);
    }

    if (centerZiId != 1 ) {
      var parentId = theZiManager.getParentZiId(centerZiId);
      var butt = FlatButton(
          child: Text('', style: TextStyle(fontSize: 20.0),),
          color: Colors.white,
          textColor: Colors.blueAccent,
          onPressed: () {
            setState(() {
              centerZiId = parentId;
            });
          });
      var posiAndSize = theLessonManager.getCenterPositionAndSize();
      var posiCenter = Positioned(
          top: posiAndSize.transY,
          left: posiAndSize.transX,
          height: posiAndSize.height,
          width: posiAndSize.width,
          child: butt
      );

      buttons.add(posiCenter);
    }

    return buttons;
  }
}
