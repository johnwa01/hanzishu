import 'package:flutter/material.dart';
import 'package:hanzishu/ui/imagebutton.dart';
import 'package:hanzishu/ui/treepage.dart';
import 'package:hanzishu/utility.dart';

class LessonPage extends StatefulWidget {
  final int lessonNumber;
  LessonPage({this.lessonNumber});

  @override
  _LessonPageState createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  _openTreePage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TreePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Lesson Page"),
      ),
      body: Center
        (
        //child: Text("This is Lesson Page."),
        child: getLessonSections(context, widget.lessonNumber),
      ),
    );
  }

  Widget getLessonSections(BuildContext context, int lessonNumber) {
    return Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(30),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                OpenHelper.getImageButton(context, lessonNumber, "assets/charactertree.png", LessonSection.FullCharacterTree),
                OpenHelper.getImageButton(context, lessonNumber, "assets/characterlist.png", LessonSection.Characters),
              ],
            ),
            padding: EdgeInsets.all(30),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                OpenHelper.getImageButton(context, lessonNumber, "assets/breakout.png", LessonSection.Assembling),
                OpenHelper.getImageButton(context, lessonNumber, "assets/conversations.png", LessonSection.Conversation),
              ],
            ),
            padding: EdgeInsets.all(30),
          ),
          Container(
            child: OpenHelper.getImageButton(context, lessonNumber, "assets/quiz.png", LessonSection.Quiz),
            padding: EdgeInsets.all(30),
          ),
        ]
    );
  }
}