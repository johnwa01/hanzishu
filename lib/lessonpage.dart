import 'package:flutter/material.dart';
import 'package:hanzishu/imagebutton.dart';
import 'package:hanzishu/treepage.dart';

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
                OpenHelper.getImageButton(context, lessonNumber, "assets/charactertree.png", true),
                OpenHelper.getImageButton(context, lessonNumber, "assets/conversations.png", true),
              ],
            ),
            padding: EdgeInsets.all(30),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                OpenHelper.getImageButton(context, lessonNumber, "assets/charactertree.png", true),
                OpenHelper.getImageButton(context, lessonNumber, "assets/conversations.png", true),
              ],
            ),
            padding: EdgeInsets.all(30),
          ),
          Container(
            child: OpenHelper.getImageButton(context, lessonNumber, "assets/charactertree.png", true),
            padding: EdgeInsets.all(30),
          ),
        ]
    );
  }
}