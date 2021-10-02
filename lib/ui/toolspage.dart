import 'package:flutter/material.dart';
import 'package:hanzishu/ui/reviewpage.dart';
import 'package:hanzishu/ui/quizresultpage.dart';
import 'package:hanzishu/engine/statisticsmanager.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/studytimepage.dart';
import 'package:hanzishu/ui/inputzipage.dart';
import 'package:hanzishu/engine/component.dart';
import 'package:hanzishu/ui/componentpage.dart';

class ToolsPage extends StatefulWidget {
  @override
  _ToolsPageState createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  @override
  Widget build(BuildContext context) {
    Utility.removeDicOverlayEntry();

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Typing"),
      ),
      body: Center
        (
        child: getMeListView(context),
      ),
    );
  }

  Widget getMeListView(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.location_city),
          title: Text("Memorize Lead Component Groups", textDirection: TextDirection.ltr),
          trailing: Icon(Icons.location_city),
          onTap: () {
            theStatisticsManager.trackTimeAndTap();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ComponentPage(questionType: QuestionType.ComponentGroup),
              ),
            );
          },
        ),

        ListTile(
          leading: Icon(Icons.location_city),
          title: Text("Memorize Leading Components in Groups", textDirection: TextDirection.ltr),
          trailing: Icon(Icons.location_city),
          onTap: () {
            theStatisticsManager.trackTimeAndTap();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ComponentPage(questionType: QuestionType.ComponentInGroup),
              ),
            );
          },
        ),

        ListTile(
          leading: Icon(Icons.location_city),
          title: Text("Memorize Leading Components", textDirection: TextDirection.ltr),
          trailing: Icon(Icons.location_city),
          onTap: () {
            theStatisticsManager.trackTimeAndTap();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ComponentPage(questionType: QuestionType.Component),
              ),
            );
          },
        ),

        ListTile(
          leading: Icon(Icons.location_city),
          title: Text("Get familiar with expanded Components", textDirection: TextDirection.ltr),
          trailing: Icon(Icons.location_city),
          onTap: () {
            theStatisticsManager.trackTimeAndTap();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ComponentPage(questionType: QuestionType.ExpandedComponent),
              ),
            );
          },
        ),


        ListTile(
          leading: Icon(Icons.location_city),
          title: Text("Input Zi", textDirection: TextDirection.ltr),
          trailing: Icon(Icons.location_city),
          onTap: () {
            theStatisticsManager.trackTimeAndTap();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InputZiPage(), //InputZiPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}