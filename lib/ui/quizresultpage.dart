import 'package:flutter/material.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/engine/statisticsmanager.dart';

class QuizResultPage extends StatefulWidget {
  QuizResultPage();

  @override
  _QuizResultPageState createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Quiz results"),
      ),
      body: Center
        (
        child: getQuizResultWizard(), //child: Text("This is Character List Page."),
      ),
    );

  }

  String getLessongQuizResultString(int index) {
    var result = theStorageHandler.getLessonQuizResult(index);
    var resultStr = StatisticsManager.produceQuizResultString(result);
    return resultStr;
  }

  Widget getQuizResultWizard() {
    var length = theStorageHandler.getLessonQuizResultLength();

    if (length == 0) {
      return ListView(
        children: <Widget>[
          //Text(
          //  "XXXXXXXXXXXXXXX",
          //  textDirection: TextDirection.rtl,
          //  textAlign: TextAlign.center,
          //),
          ListTile(
            title: Text("No quiz record yet.", textDirection: TextDirection.ltr),
          ),
        ],
      );
    }

    return ListView.separated(
      itemCount: length,
      separatorBuilder/*IndexedWidgetBuilder*/: (BuildContext context, int index) {
        return Divider();
      },
      itemBuilder/*IndexedWidgetBuilder*/: (BuildContext context, int index) {
        return ListTile(
          //title: Text('item $index'),
          //title: Text(theLessonList[index].chars),
          title: Text(getLessongQuizResultString(index)),
        );
      },
    );
  }
}