import 'package:flutter/material.dart';
import 'package:hanzishu/ui/reviewpage.dart';
import 'package:hanzishu/ui/quizresultpage.dart';
import 'package:hanzishu/engine/statisticsmanager.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/studytimepage.dart';
import 'package:hanzishu/ui/tapcountpage.dart';
import 'package:hanzishu/ui/reviewselectionpage.dart';

class MePage extends StatefulWidget {
  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Me"),
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
            //Text(
            //  "XXXXXXXXXXXXXXX",
            //  textDirection: TextDirection.rtl,
            //  textAlign: TextAlign.center,
            //),
            ListTile(
              leading: Icon(Icons.location_city),
              title: Text("Review of Lessons", textDirection: TextDirection.ltr),
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
            /*
            ListTile(
              leading: Icon(Icons.location_city),
              title: Text("Study Time", textDirection: TextDirection.ltr),
              trailing: Icon(Icons.location_city),
              onTap: () {
                theStatisticsManager.trackTimeAndTap();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudyTimePage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.location_city),
              title: Text("Tap Count", textDirection: TextDirection.ltr),
              trailing: Icon(Icons.location_city),
              onTap: () {
                theStatisticsManager.trackTimeAndTap();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TapCountPage(),
                  ),
                );
              },
            ),
            */
            ListTile(
              leading: Icon(Icons.location_city),
              title: Text("Quiz Results", textDirection: TextDirection.ltr),
              trailing: Icon(Icons.location_city),
              //subtitle: Text(
              //  "XXXXXXXXXX",
              //  textDirection: TextDirection.rtl,
              //),
              onTap: () {
                theStatisticsManager.trackTimeAndTap();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizResultPage(),
                  ),
                );
              },
            ),
          ],
        );
      }
}