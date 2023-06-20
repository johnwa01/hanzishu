import 'package:flutter/material.dart';
import 'package:hanzishu/ui/glossarypage.dart';
import 'package:hanzishu/ui/quizresultpage.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/privacypolicy.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hanzishu/ui/settingspage.dart';
import 'package:hanzishu/ui/basiccomponentspage.dart';
import 'package:hanzishu/ui/flashcardpage.dart';
import 'package:hanzishu/ui/studynewwordspage.dart';
import 'dart:io';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/introductionpage.dart';
import 'package:url_launcher/url_launcher.dart';

class MePage extends StatefulWidget {
  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  double screenWidth;
  String currentLocale;

  @override
  void initState() {
    super.initState();

    setState(() {
      currentLocale = theDefaultLocale;
    });
  }

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }

  Widget getQuizResults() {
    var imageSize = 35.0 * getSizeRatioWithLimit();

    if (kIsWeb) {
      return Container(width: 0.0, height: 0.0);
    }
    else {
      return ListTile(
        leading: Image.asset(
            'assets/core/quizresults.png', width: imageSize, height: imageSize),
        //Icon(Icons.location_city),
        title: Text(getString(267)/*"Quiz results"*/, textDirection: TextDirection.ltr),
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
        title: Text(getString(94)/*"Me"*/),
      ),
      body: Center
        (
        child: getMeListView(context),
      ),
    );
  }

    _callbackFromSettingsPage() {
      if (currentLocale != theDefaultLocale) {
        setState(() {
          // let this page refresh to pick up the locale change.
          currentLocale = theDefaultLocale;
        });
        theStorageHandler.setLanguage(theDefaultLocale);
        theStorageHandler.SaveToFile();

        // let main page refresh to pick up the language change for navigation bar items
        final BottomNavigationBar navigationBar = globalKeyNav.currentWidget;
        navigationBar.onTap(3);
      }

      /*
      var bottomWidgetKey=new GlobalKey<State<BottomNavigationBar>>();
      BottomNavigationBar navigationBar =  bottomWidgetKey.currentWidget as BottomNavigationBar;
      navigationBar.onTap(1);
      */
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
              leading: Image.asset('assets/core/conversations.png', width: imageSize, height: imageSize), //Icon(Icons.location_city),
              title:  Text(getString(411)/*"Hanzishu Introduction"*/, textDirection: TextDirection.ltr),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IntroductionPage(),
                  ),
                );
              },
            ),

            /*
            ListTile(
              leading: Image.asset('assets/core/itemicon.png'),
              title: Text(getString(420)/*"Hanzishu classes"*/, textDirection: TextDirection.ltr),
              onTap: () {
                if (kIsWeb) {
                  launchUrl(Uri.parse("https://hanzishu.com/lesson"), webOnlyWindowName: '_self');
                }
              },
            ),
            */

            ListTile(
              leading: Image.asset('assets/core/breakout.png', width: imageSize, height: imageSize), //Icon(Icons.location_city),
              title: Text(getString(384)/*"Hanzi basic components"*/, textDirection: TextDirection.ltr),
              //trailing: Image.asset('assets/core/itemicon.png'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BasicComponentsPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Image.asset('assets/core/characterlist.png', width: imageSize, height: imageSize), //Icon(Icons.location_city),
              title: Text(getString(406)/*"Customized flashcard"*/, textDirection: TextDirection.ltr),
              //trailing: Image.asset('assets/core/itemicon.png'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlashcardPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Image.asset('assets/core/characterdrill.png', width: imageSize, height: imageSize), //Icon(Icons.location_city),
              title: Text(getString(409)/*"Study new words"*/, textDirection: TextDirection.ltr),
              //trailing: Image.asset('assets/core/itemicon.png'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        StudyCustomizedWordsPage(),
                  ),
                );
              },
            ),
            getQuizResults(),
            ListTile(
              leading: Image.asset('assets/core/glossary.png', width: imageSize, height: imageSize), //Icon(Icons.location_city),
              title:  Text(getString(140)/*"Glossary"*/, textDirection: TextDirection.ltr),
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
              leading: Image.asset('assets/core/settings.png', width: imageSize, height: imageSize), //Icon(Icons.location_city),
              title: Text(getString(302)/*"Language Settings"*/, textDirection: TextDirection.ltr),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage())).then((val)=>{_callbackFromSettingsPage()});
                //      Navigator.of(context).push(
                //          MaterialPageRoute(builder: (context) => LessonPage(lessonId: lessonId))).then((val)=>{_getRequests()});
                //  ),
                //);
              },
            ),
            ListTile(
              leading: Image.asset('assets/lessons/L9.png', width: imageSize, height: imageSize), //Icon(Icons.location_city),
              title: Text(getString(141)/*"Privacy policy"*/, textDirection: TextDirection.ltr),
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