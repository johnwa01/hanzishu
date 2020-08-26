import 'package:flutter/material.dart';
import 'package:hanzishu/lessonpage.dart';

class LessonsPage extends StatefulWidget {
  @override
  _LessonsPageState createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  _openLessonPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LessonPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Lessons Page"),
      ),
      body: Center
        (
        //child: Text("This is Lessons Page."),
        child: RaisedButton(
          textColor: Colors.deepPurple, // TODO: use style
          color: Colors.greenAccent,
          child: Text('Lesson 1'),
          onPressed: () => _openLessonPage(context)
        )
      ),
    );
  }
}