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
  var lesson;

  @override
  void initState() {
    super.initState();

    lesson = theLessonList[theCurrentLessonId];
    lesson.populateNewItemList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("List of Zi"),
      ),
      body: Center
        (
        child: getCharacterListWizard(), //child: Text("This is Character List Page."),
      ),
    );

  }

  Widget getCharacterListWizard() {
    var lesson = theLessonList[theCurrentLessonId];
    lesson.populateNewItemList();

    return ListView.separated(
      itemCount: lesson.newItemList.length,
      separatorBuilder: (BuildContext context, int index) {
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
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          //leading: FlutterLogo(size: 72.0),
                 //title: Text('item $index'),
                 //title: Text(theLessonList[index].chars),
          title: Text(lesson.getItemString(index)),
        );
      },
    );
  }
}