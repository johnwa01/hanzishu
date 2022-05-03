import 'package:flutter/material.dart';
import 'package:hanzishu/ui/imagebutton.dart';
import 'package:hanzishu/engine/lessonmanager.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/data/lessonlist.dart';

class LessonPage extends StatefulWidget {
  final int lessonId;
  LessonPage({this.lessonId});

  @override
  _LessonPageState createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  //_openTreePage(BuildContext context) {
  //_LessonPageState(BuildContext context) {
  //  Navigator.of(context).push(MaterialPageRoute(builder: (context) => TreePage()));
  //}

  @override
  void initState() {
    super.initState();

    // should just run once
    // believe initState only runs once, but added a global variable in case ReviewPage has run it already.
    if (!theHavePopulatedLessonsInfo) {
      LessonManager.populateLessonsInfo();
      theHavePopulatedLessonsInfo = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    theCurrentLessonId = widget.lessonId;

    String lessonName = "Lesson " + theCurrentLessonId.toString() + ": " + theLessonList[theCurrentLessonId].titleTranslation + " " + theLessonList[theCurrentLessonId].title;

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(lessonName),   // "Lesson page"
      ),
      body: Center
        (
        //child: Text("This is Lesson Page."),
        child: getLessonSections(context, widget.lessonId),
      ),
    );
  }

  Widget getLessonSections(BuildContext context, int lessonId) {
    // put scrollview since I get render overflow issue
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          //Container(
          //  padding: EdgeInsets.all(5),
          //),
          Container(
            child: Text("Please complete exercises in order.", style: TextStyle(fontSize: 16.0),),
            padding: EdgeInsets.all(15),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                OpenHelper.getImageButton(context, lessonId, "assets/core/characterdrill.png", LessonSection.FullCharacterTree, false, 131, 81),
                OpenHelper.getImageButton(context, lessonId, "assets/core/characterlist.png", LessonSection.Characters, false, 131, 81),
              ],
            ),
            padding: EdgeInsets.all(20),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                OpenHelper.getImageButton(context, lessonId, "assets/core/breakout.png", LessonSection.Decomposing, false, 131, 81),
                OpenHelper.getImageButton(context, lessonId, "assets/core/conversations.png", LessonSection.Conversation, false, 131, 81),
              ],
            ),
            padding: EdgeInsets.all(20),
          ),
          Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  OpenHelper.getImageButton(context, lessonId, "assets/core/typing.png", LessonSection.Typing, false, 131, 80),
                  OpenHelper.getImageButton(context, lessonId, "assets/core/quiz.png", LessonSection.Quiz, false, 131,80),
                ],
            ),
            padding: EdgeInsets.all(20),
          ),
        ]
      ),
    );
  }
}