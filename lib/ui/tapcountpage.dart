import 'package:flutter/material.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/data/zilist.dart';
import 'package:hanzishu/engine/statisticsmanager.dart';
import 'package:hanzishu/engine/storagehandler.dart';

class TapCountPage extends StatefulWidget {
  TapCountPage();

  @override
  _TapCountPageState createState() => _TapCountPageState();
}

class _TapCountPageState extends State<TapCountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Tap Count"),
      ),
      body: Center
        (
        child: getTapCountWizard(), //child: Text("This is Character List Page."),
      ),
    );

  }

  String getTapCountString(int index) {
    var statistics = theStorageHandler.getStudyTimeAndTapCount(index);
    var tapCountString = '';
    if (statistics != null && statistics.dateString != null && statistics.tapCount != null) {
      tapCountString = StatisticsManager.produceTapCountString(statistics.dateString, statistics.tapCount);
    }

    return tapCountString;
  }

  Widget getTapCountWizard() {
    return ListView.separated(
      itemCount: theStorageHandler.getStudyTimeAndTapCountLength(),
      separatorBuilder/*IndexedWidgetBuilder*/: (BuildContext context, int index) {
        return Divider();
      },
      itemBuilder/*IndexedWidgetBuilder*/: (BuildContext context, int index) {
        return ListTile(
          //title: Text('item $index'),
          //title: Text(theLessonList[index].chars),
          title: Text(getTapCountString(index)),
        );
      },
    );
  }
}