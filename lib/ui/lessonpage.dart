import 'package:flutter/material.dart';
import 'package:hanzishu/ui/imagebutton.dart';
import 'package:hanzishu/ui/treepage.dart';
import 'package:hanzishu/utility.dart';

class LessonPage extends StatefulWidget {
  final int lessonId;
  LessonPage({this.lessonId});

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
                OpenHelper.getImageButton(context, lessonId, "assets/charactertree.png", LessonSection.FullCharacterTree),
                OpenHelper.getImageButton(context, lessonId, "assets/characterlist.png", LessonSection.Characters),
              ],
            ),
            padding: EdgeInsets.all(20),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                OpenHelper.getImageButton(context, lessonId, "assets/breakout.png", LessonSection.Assembling),
                OpenHelper.getImageButton(context, lessonId, "assets/conversations.png", LessonSection.Conversation),
              ],
            ),
            padding: EdgeInsets.all(20),
          ),
          Container(
            child: OpenHelper.getImageButton(context, lessonId, "assets/quiz.png", LessonSection.Quiz),
            padding: EdgeInsets.all(20),
          ),
        ]
    );
  }
}