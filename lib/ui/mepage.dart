import 'package:flutter/material.dart';
import 'package:hanzishu/ui/glossarypage.dart';
import 'package:hanzishu/ui/quizresultpage.dart';
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
              title: Text("Character review", textDirection: TextDirection.ltr),
              trailing: Icon(Icons.location_city),
              onTap: () {
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
              title: Text("Quiz results", textDirection: TextDirection.ltr),
              trailing: Icon(Icons.location_city),
              //subtitle: Text(
              //  "XXXXXXXXXX",
              //  textDirection: TextDirection.rtl,
              //),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizResultPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.location_city),
              title: Text("Glossary", textDirection: TextDirection.ltr),
              trailing: Icon(Icons.location_city),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GlossaryPage(),
                  ),
                );
              },
            ),
          ],
        );
      }
}