import 'package:flutter/material.dart';
//import 'package:hanzishu/lessonpage.dart';
import 'package:hanzishu/imagebutton.dart';

class LessonsPage extends StatefulWidget {
  @override
  _LessonsPageState createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  //_openLessonPage(BuildContext context) {
  //  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LessonPage()));
  //}

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
          child: OpenHelper.getImageButton(context, 1),
      ),
    );
  }
}