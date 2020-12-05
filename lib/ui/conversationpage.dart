import 'package:flutter/material.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/data/zilist.dart';

class ConversationPage extends StatefulWidget {
  final int lessonId;
  ConversationPage({this.lessonId});

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Conversation Page"),
      ),
      body: Center
        (
        child: getConversationWizard(), //child: Text("This is Character List Page."),
      ),
    );

  }

  Widget getConversationWizard() {
    var lesson = theLessonList[theCurrentLessonId];
    lesson.populateNewItemList();

    return ListView.separated(
      itemCount: lesson.sentenceList.length,
      separatorBuilder/*IndexedWidgetBuilder*/: (BuildContext context, int index) {
        return Divider();
      },
      itemBuilder/*IndexedWidgetBuilder*/: (BuildContext context, int index) {
        return ListTile(
          //title: Text('item $index'),
          //title: Text(theLessonList[index].chars),
          title: Text(lesson.getSentence(index)),
        );
      },
    );
  }
}