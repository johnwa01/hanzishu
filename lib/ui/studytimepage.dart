import 'package:flutter/material.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/data/zilist.dart';
import 'package:hanzishu/engine/statisticsmanager.dart';
import 'package:hanzishu/engine/storagehandler.dart';

class StudyTimePage extends StatefulWidget {
  StudyTimePage();

  @override
  _StudyTimePageState createState() => _StudyTimePageState();
}

class _StudyTimePageState extends State<StudyTimePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Study Time"),
      ),
      body: Center
        (
        child: getStudyTimeWizard(), //child: Text("This is Character List Page."),
      ),
    );

  }

  String getStudyTimeString(int index) {
    var statistics = theStorageHandler.getStudyTimeAndTapCount(index);
    var studyTimeString = '';
    if (statistics != null && statistics.dateString != null && statistics.studyTime != null) {
      studyTimeString = StatisticsManager.produceStudyTimeString(statistics.dateString, statistics.studyTime);
    }

    return studyTimeString;
  }

  Widget getStudyTimeWizard() {
    return ListView.separated(
      itemCount: theStorageHandler.getStudyTimeAndTapCountLength(),
      separatorBuilder/*IndexedWidgetBuilder*/: (BuildContext context, int index) {
        return Divider();
      },
      itemBuilder/*IndexedWidgetBuilder*/: (BuildContext context, int index) {
        return ListTile(
          //title: Text('item $index'),
          //title: Text(theLessonList[index].chars),
          title: Text(getStudyTimeString(index)),
        );
      },
    );
  }
}