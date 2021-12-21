import 'package:flutter/material.dart';
import 'package:hanzishu/ui/inputzihelppage.dart';
import 'package:hanzishu/ui/reviewpage.dart';
import 'package:hanzishu/ui/quizresultpage.dart';
import 'package:hanzishu/engine/statisticsmanager.dart';
import 'package:hanzishu/engine/inputzi.dart';
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
        title: Text("Hanzishu Typing Method"),
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
        /*
        ListTile(
          //leading: Icon(Icons.location_city),
          title: Text("Introduction", textDirection: TextDirection.ltr),
          trailing: Icon(Icons.location_city),
          onTap: () {
            theStatisticsManager.trackTimeAndTap();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InputZiHelpPage(),
              ),
            );
          },
        ),
        */
        ListTile(
          //leading: Icon(Icons.location_city),
          title: Text("Introduction", textDirection: TextDirection.ltr),
          trailing: Icon(Icons.location_city),
          onTap: () {
            theStatisticsManager.trackTimeAndTap();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InputZiPage(typingType: TypingType.ThreeOrMoreComponents), //InputZiPage(),
              ),
            );
          },
        ),
        ListTile(
          title: Text("Memorize components to keyboard mapping", textDirection: TextDirection.ltr),
        ),
        ListTile(
          //leading: Icon(Icons.location_city),
          title: Text("        Memorize component groups", textDirection: TextDirection.ltr),
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
          //leading: Icon(Icons.location_city),
          title: Text("        Memorize components in groups", textDirection: TextDirection.ltr),
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
          //leading: Icon(Icons.location_city),
          title: Text("        Memorize components", textDirection: TextDirection.ltr),
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
          //leading: Icon(Icons.location_city),
          title: Text("Guided typing", textDirection: TextDirection.ltr),
          trailing: Icon(Icons.location_city),
          onTap: () {
            theStatisticsManager.trackTimeAndTap();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InputZiPage(typingType: TypingType.TwoComponents), //InputZiPage(),
              ),
            );
          },
        ),
        ListTile(
          //leading: Icon(Icons.location_city),
          title: Text("Be familiar with expanded components", textDirection: TextDirection.ltr),
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
        //ListTile(
        //  title: Text("Guided typing of characters", textDirection: TextDirection.ltr),
        //),

        ListTile(
          //leading: Icon(Icons.location_city),
          title: Text("Guided typing", textDirection: TextDirection.ltr),
          trailing: Icon(Icons.location_city),
          onTap: () {
            theStatisticsManager.trackTimeAndTap();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InputZiPage(typingType: TypingType.OneComponent), //InputZiPage(),
              ),
            );
          },
        ),
        //ListTile(
        //  title: Text("At your own:", textDirection: TextDirection.ltr),
        //),
        ListTile(
          //leading: Icon(Icons.location_city),
          title: Text("Typing", textDirection: TextDirection.ltr),
          trailing: Icon(Icons.location_city),
          onTap: () {
            theStatisticsManager.trackTimeAndTap();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InputZiPage(typingType: TypingType.FreeTyping), //InputZiPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}