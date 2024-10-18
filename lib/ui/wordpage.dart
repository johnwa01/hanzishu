import 'package:flutter/material.dart';
import 'package:hanzishu/ui/wordlevelpage.dart';
import 'package:hanzishu/ui/glossarypage.dart';
import 'package:hanzishu/ui/wordlaunchpage.dart';
import 'package:hanzishu/ui/quizresultpage.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/privacypolicy.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hanzishu/ui/settingspage.dart';
import 'package:hanzishu/ui/basiccomponentspage.dart';
import 'package:hanzishu/ui/flashcardpage.dart';
import 'package:hanzishu/ui/practicesheetpage.dart';
import 'package:hanzishu/ui/studynewwordspage.dart';
import 'dart:io';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/introductionpage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hanzishu/engine/drill.dart';
import 'package:hanzishu/engine/thirdpartylesson.dart';
import 'package:hanzishu/ui/thirdpartylessonpage.dart';

class WordPage extends StatefulWidget {
  @override
  _MeWordState createState() => _MeWordState();
}

class _MeWordState extends State<WordPage> {
  double? screenWidth;
  String? currentLocale;

  @override
  void initState() {
    super.initState();

    setState(() {
      currentLocale = theDefaultLocale;
    });
  }

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth!);
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidthForTreeAndDict(context);

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(getString(1)/*Learn/test Hanzi*/),
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
        ListTile(
          leading: Image.asset('assets/lessons/L27.png', width: imageSize, height: imageSize), //Icon(Icons.location_city),
          title: Text(getString(455)/*"HSK Hanzi"*/, textDirection: TextDirection.ltr),
          //trailing: Image.asset('assets/core/itemicon.png'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    WordLevelPage(drillCategory: DrillCategory.hsk, subItemId: -1, customString: ''),
              ),
            );
          },
        ),
        ListTile(
          leading: Image.asset('assets/lessons/L30.png', width: imageSize, height: imageSize), //Icon(Icons.location_city),
          title: Text(getString(490)/*"Yuwen"*/, textDirection: TextDirection.ltr),
          //trailing: Image.asset('assets/core/itemicon.png'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ThirdPartyLessonPage(thirdPartyType: ThirdPartyType.yuwen),
              ),
            );
          },
        ),
        ListTile(
          leading: Image.asset('assets/core/glossary.png', width: imageSize, height: imageSize), //Icon(Icons.location_city),
          title:  Text(getString(395)/*"3,800 common words"*/, textDirection: TextDirection.ltr),
          //trailing: Image.asset('assets/core/itemicon.png'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WordLaunchPage(drillCategory: DrillCategory.all,
                    subItemId: 1,
                    customString: ''),
              ),
            );
          },
        ),
        //ListTile(
        //  leading: Image.asset('assets/core/settings.png', width: imageSize, height: imageSize), //Icon(Icons.location_city),
        //  title: Text(getString(302)/*"Language Settings"*/, textDirection: TextDirection.ltr),
        //  onTap: () {
        //    Navigator.push(
        //        context,
        //        MaterialPageRoute(
        //          builder: (context) => GlossaryPage(),
        //        ),
        //    );
        //  },
        //),
      ],
    );
  }
}