import 'package:flutter/material.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/ui/inputzipage.dart';
import 'package:hanzishu/engine/component.dart';
import 'package:hanzishu/ui/componentpage.dart';
import 'package:hanzishu/ui/inputzihelppage.dart';
import 'package:hanzishu/ui/typingselectionpage.dart';
import 'package:hanzishu/ui/typingapppage.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

class ToolsPage extends StatefulWidget {
  @override
  _ToolsPageState createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  //var exerciseCompleted = [false, false, false, false, false, false, false, false, false, false, false];

  int numberOfExercises = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(getString(368)/*"Component Input Method"*/),
      ),
      body: Center
        (
        child: getMeListView(context),
      ),
    );
  }

  _getRequests() async {
    //if (theNewlyCompletedTypingExercise != -1) {
      //exerciseCompleted[theNewlyCompletedTypingExercise] = true;
      //theNewlyCompletedTypingExercise = -1;

      //setState(() {
        // force refresh every time to make sure to pick up completed icon
        this.numberOfExercises += 1;
      //});

      if (!theIsBackArrowExit && this.numberOfExercises <= 8) {
        // reinit
        theIsBackArrowExit = true;
        LaunchExercise(this.numberOfExercises);
      }
      else {
        // init all variables
        // either true back arrow or all done
        theIsBackArrowExit = true;
        theIsFromTypingContinuedSection = false;
        this.numberOfExercises = 0;
      }
    //}
  }

  LaunchExercise(int exerciseNumber) {
    switch (exerciseNumber) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ComponentPage(questionType: QuestionType.Component),
          ),
        ).then((val) => {_getRequests()});
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                InputZiPage(typingType: TypingType.LeadComponents,
                    lessonId: 0, wordsStudy: null), //InputZiPage(),
          ),
        ).then((val) => {_getRequests()});
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ComponentPage(questionType: QuestionType.ExpandedComponent),
          ),
        ).then((val) => {_getRequests()});
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                InputZiPage(
                    typingType: TypingType.ExpandedReview), //InputZiPage(),
          ),
        ).then((val) => {_getRequests()});
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                InputZiPage(
                    typingType: TypingType.SingleComponent), //InputZiPage(),
          ),
        ).then((val) => {_getRequests()});
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                InputZiPage(
                    typingType: TypingType.TwoComponents), //InputZiPage(),
          ),
        ).then((val) => {_getRequests()});
        break;
      case 6:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ComponentPage(questionType: QuestionType.ShowAttachedComponent),
          ),
        ).then((val) => {_getRequests()});
        break;
      case 7:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                InputZiPage(
                    typingType: TypingType.AttachedComponents), //InputZiPage(),
          ),
        ).then((val) => {_getRequests()});
        break;
      case 8:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                InputZiPage(
                    typingType: TypingType.GeneralExercise), //InputZiPage(),
          ),
        ).then((val) => {_getRequests()});
        break;
      default:
        break;
    }
  }

  Widget getMeListView(BuildContext context) {
    var str = getString(99);/*"Please finish exercise 1 - 10 to learn the input method"*/
    if (kIsWeb) {
      str = str + " " + getString(372) + "]";
    }
    else {
      str = str + "]";
    }

    var keyboardImageName;
    if (theDefaultLocale == "zh_CN") {
      keyboardImageName = 'assets/core/keyboard_cn.png';
    }
    else { // en_US
      keyboardImageName = 'assets/core/keyboard_eng.png';
    }

    return ListView(
      children: <Widget>[
        ListTile(
          title: Text(str, textDirection: TextDirection.ltr),
        ),
        ListTile(
          //leading: Image.asset('assets/core/itemicon.png'),
          title: Image.asset(keyboardImageName, width: 100, height: 70),
          //trailing: exerciseCompleted[0] ? Image.asset('assets/core/completedicon.png') : Image.asset('assets/core/itemicon.png'),
          onTap: () {
            //TODO: can take this as a parameter to the typing and component pages.
            theIsFromTypingContinuedSection = true;
            LaunchExercise(0);
          },
        ),
        ListTile(
          //leading: Image.asset('assets/core/itemicon.png'),
          title: Text(getString(107)/*"[Optional] Customized exercises"*/, textDirection: TextDirection.ltr),
          //trailing: Image.asset('assets/core/itemicon.png'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TpyingSelectionPage(),
              ),
            );
          },
        ),
        ListTile(
          //leading: Image.asset('assets/core/itemicon.png'),
          title: Text(getString(108)/*"Free typing and help"*/, textDirection: TextDirection.ltr),
          //trailing: Image.asset('assets/core/itemicon.png'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InputZiPage(typingType: TypingType.FreeTyping, lessonId: 0), //InputZiPage(),
              ),
            );
          },
        ),
        ListTile(
          //leading: Image.asset('assets/core/itemicon.png'),
          title: Text(getString(379)/*"Hanzishu pinxing typing app"*/, textDirection: TextDirection.ltr),
          onTap: () {
            launchTypingAppPageOrHtml();
          },
        ),
      ],
    );
  }

  launchTypingAppPageOrHtml() {
    if (kIsWeb) {
      launchUrl(Uri.parse("https://hanzishu.com/zi"), webOnlyWindowName: '_self');
    }
    else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TypingAppPage(),
        ),
      );
    }
  }
}