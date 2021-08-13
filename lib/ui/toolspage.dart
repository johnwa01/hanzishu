import 'package:flutter/material.dart';
import 'package:hanzishu/ui/reviewpage.dart';
import 'package:hanzishu/ui/quizresultpage.dart';
import 'package:hanzishu/engine/statisticsmanager.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/studytimepage.dart';
import 'package:hanzishu/ui/inputzipage.dart';
import 'package:hanzishu/ui/reviewselectionpage.dart';

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
        title: Text("Tools"),
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
          title: Text("Review", textDirection: TextDirection.ltr),
          trailing: Icon(Icons.location_city),
          onTap: () {
            theStatisticsManager.trackTimeAndTap();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReviewSelectionPage(),
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