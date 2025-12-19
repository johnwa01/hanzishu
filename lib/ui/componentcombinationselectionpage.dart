import 'package:flutter/material.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/ui/inputzipage.dart';
import 'package:hanzishu/data/componenttypinglist.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/variables.dart';

class ComponentCombinationSelectionPage extends StatefulWidget {
  @override
  _ComponentCombinationSelectionPageState createState() => _ComponentCombinationSelectionPageState();
}

class _ComponentCombinationSelectionPageState extends State<ComponentCombinationSelectionPage> {
  double? screenWidth;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
      });
  }

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth!);
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidth(context);
/*
    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(getString(288)/*"Exercise selection"*/),
      ),
      body: Center
        (
        child: getExerciseSelection(context),
      ),
    );
*/


    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(getString(288)/*"Exercise selection"*/),
      ),
      body: Container(
        //height: 800.00,

        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: WillPopScope(
              child: getExerciseSelection(context),
              onWillPop: _onWillPop
          ),
        ),

      ),
    );
  }

  Future<bool>_onWillPop() {
    return Future.value(true);
  }

  Widget getExerciseSelection(BuildContext context) {
    return Column(
        children: <Widget>[
          Text(getString(530), style: TextStyle(fontSize: 16.0 * getSizeRatioWithLimit(), color: Colors.brown)),
          SizedBox(height: 10.0),
          getStartExercise(context, 0),
          getStartExercise(context, 1),
          getStartExercise(context, 2),
          getStartExercise(context, 3),
          getStartExercise(context, 4),
          getStartExercise(context, 5),
          getStartExercise(context, 6),
          getStartExercise(context, 7),
          getStartExercise(context, 8),
          getStartExercise(context, 9),
        ]
    );
  }

  Widget getStartExercise(BuildContext context, int id) {
    String label;
    String nextLabel;
    var item = theComponentCombinationCharsList[id];
    nextLabel =  item.letter1 + ", " + item.letter2;
    if (item.letter3.length != 0) {
      nextLabel += ", ";
      nextLabel += item.letter3;
    }
    label = (id + 1).toString() + ") " + nextLabel;

    return Container(
      child: TextButton(
        child: Text(label, style: TextStyle(fontSize: 20.0 * getSizeRatioWithLimit(), color: Colors.blue),),
        //color: Colors.blueAccent,
        //textColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InputZiPage(typingType: TypingType.ComponentCombinationTyping, lessonId: id, wordsStudy: nextLabel/*borrow this field*/, isSoundPrompt: false, inputMethod: InputMethod.Pinxin, showHint: HintType.Hint1, includeSkipSection: false, showSwitchMethod: false),
            ),
          );
        },
      ),
    );
  }
}