import 'package:flutter/material.dart';
import 'package:hanzishu/treepage.dart';

class LessonPage extends StatefulWidget {
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
          child: RaisedButton(
              textColor: Colors.deepPurple, // TODO: use style
              color: Colors.greenAccent,
              child: Text('Tree Page'),
              onPressed: () => _openTreePage(context)
          )
      ),
    );
  }
}