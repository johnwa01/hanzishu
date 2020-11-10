import 'package:flutter/material.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/data/zilist.dart';

class CharacterListPage extends StatefulWidget {
  final int lessonId;
  CharacterListPage({this.lessonId});

  @override
  _CharacterListPageState createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Character List Page"),
      ),
      body: Center
        (
        child: callFunc(), //child: Text("This is Character List Page."),
      ),
    );

  }

  Widget callFunc() {
    var lesson = theLessonList[theCurrentLessonId];
    lesson.populateNewItemList();

    return ListView.separated(
      itemCount: lesson.newItemList.length,
      separatorBuilder/*IndexedWidgetBuilder*/: (BuildContext context, int index) {
        if (index == lesson.newItemTypeStartPosition[0]) {
          return Text("Basic Characters");
        }
        else if (index == lesson.newItemTypeStartPosition[1]) {
          return Text("Basic non-characters");
        }
        else if (index == lesson.newItemTypeStartPosition[2]) {
          return Text("Characters");
        }
        else if (index == lesson.newItemTypeStartPosition[3]) {
          return Text("Phrases");
        }
        return Divider();
      },
      itemBuilder/*IndexedWidgetBuilder*/: (BuildContext context, int index) {
        return ListTile(
                 //title: Text('item $index'),
                 //title: Text(theLessonList[index].chars),
          title: Text(lesson.getItemString(index)),
        );
      },
    );
  }
}