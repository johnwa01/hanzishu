import 'package:flutter/material.dart';
import 'package:hanzishu/ui/glossarypage.dart';
import 'package:hanzishu/ui/quizresultpage.dart';
import 'package:hanzishu/ui/reviewselectionpage.dart';
import 'package:hanzishu/utility.dart';

class MePage extends StatefulWidget {
  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  double screenWidth;

  double getSizeRatio() {
    return Utility.getSizeRatio(screenWidth);
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidthForTreeAndDict(context);

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
              leading: Image.asset('assets/core/characterdrill.png', width: 35.0, height: 35.0), //Icon(Icons.location_city),
              title: Text("Character review", textDirection: TextDirection.ltr),
              //trailing: Image.asset('assets/core/itemicon.png'),
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
              leading: Image.asset('assets/core/quiz.png', width: 35.0, height: 35.0), //Icon(Icons.location_city),
              title: Text("Quiz results", textDirection: TextDirection.ltr),
              //trailing: Image.asset('assets/core/itemicon.png'),
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
              leading: Image.asset('assets/core/characterlist.png', width: 35.0, height: 35.0), //Icon(Icons.location_city),
              title: Text("Glossary", textDirection: TextDirection.ltr),
              //trailing: Image.asset('assets/core/itemicon.png'),
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