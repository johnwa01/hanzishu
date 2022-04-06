import 'package:flutter/material.dart';
import 'package:hanzishu/ui/glossarypage.dart';
import 'package:hanzishu/ui/quizresultpage.dart';
import 'package:hanzishu/ui/reviewselectionpage.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/privacypolicy.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

class MePage extends StatefulWidget {
  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  double screenWidth;

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }

  Widget getQuizResults() {
    var imageSize = 35.0 * getSizeRatioWithLimit();

    if (kIsWeb || Platform.isAndroid) {
      return Container(width: 0.0, height: 0.0);
    }
    else {
      return ListTile(
        leading: Image.asset(
            'assets/core/quizresults.png', width: imageSize, height: imageSize),
        //Icon(Icons.location_city),
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
      );
    }
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
        var imageSize = 35.0 * getSizeRatioWithLimit();

        return ListView(
          children: <Widget>[
            //Text(
            //  "XXXXXXXXXXXXXXX",
            //  textDirection: TextDirection.rtl,
            //  textAlign: TextAlign.center,
            //),
            ListTile(
              leading: Image.asset('assets/core/characterreview.png', width: imageSize, height: imageSize), //Icon(Icons.location_city),
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
            getQuizResults(),
            ListTile(
              leading: Image.asset('assets/core/glossary.png', width: imageSize, height: imageSize), //Icon(Icons.location_city),
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
            ListTile(
              leading: Image.asset('assets/lessons/L9.png', width: imageSize, height: imageSize), //Icon(Icons.location_city),
              title: Text("Privacy policy", textDirection: TextDirection.ltr),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrivacyPolicyPage(),
                  ),
                );
              },
            ),
          ],
        );
      }
}