import 'package:flutter/material.dart';
import 'package:hanzishu/ui/imagebutton.dart';
import 'package:hanzishu/ui/treepage.dart';
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
  Widget build(BuildContext context) {
    theCurrentLessonId = widget.lessonId;

    String lessonName = "Lesson " + theCurrentLessonId.toString() + ": " + theLessonList[theCurrentLessonId].titleTranslation;

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
    return Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(30),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                OpenHelper.getImageButton(context, lessonId, "assets/charactertree.png", LessonSection.FullCharacterTree, false),
                OpenHelper.getImageButton(context, lessonId, "assets/characterlist.png", LessonSection.Characters, false),
              ],
            ),
            padding: EdgeInsets.all(20),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                OpenHelper.getImageButton(context, lessonId, "assets/breakout.png", LessonSection.Assembling, false),
                OpenHelper.getImageButton(context, lessonId, "assets/conversations.png", LessonSection.Conversation, false),
              ],
            ),
            padding: EdgeInsets.all(20),
          ),
          Container(
            child: OpenHelper.getImageButton(context, lessonId, "assets/quiz.png", LessonSection.Quiz, false),
            padding: EdgeInsets.all(20),
          ),
        ]
    );
  }
}