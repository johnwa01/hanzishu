import 'package:flutter/material.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/ui/inputzipage.dart';
import 'package:hanzishu/engine/component.dart';
import 'package:hanzishu/ui/componentpage.dart';
import 'package:hanzishu/ui/typingselectionpage.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';

class ToolsPage extends StatefulWidget {
  @override
  _ToolsPageState createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  var exerciseCompleted = [false, false, false, false, false, false, false, false];

  int numberOfExercises = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(getString(98)/*"Component Input Method"*/),
      ),
      body: Center
        (
        child: getMeListView(context),
      ),
    );
  }

  _getRequests() async {
    if (theNewlyCompletedTypingExercise != -1) {
      exerciseCompleted[theNewlyCompletedTypingExercise] = true;
      theNewlyCompletedTypingExercise = -1;

      setState(() {
        // force refresh every time to make sure to pick up completed icon
        this.numberOfExercises += 1;
      });
    }
  }

  Widget getMeListView(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text(getString(99)/*"Please finish exercise 1 - 7 to learn the input method"*/ + ":", textDirection: TextDirection.ltr),
        ),
        ListTile(
          //leading: Image.asset('assets/core/itemicon.png'),
          title: Text("1. " + getString(100)/*"Give it a try"*/, textDirection: TextDirection.ltr),
          trailing: exerciseCompleted[0] ? Image.asset('assets/core/completedicon.png') : Image.asset('assets/core/itemicon.png'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InputZiPage(typingType: TypingType.GiveItATry), //InputZiPage(),
              ),
            ).then((val)=>{_getRequests()});
          },
        ),
        ListTile(
          //leading: Image.asset('assets/core/itemicon.png'),
          title: Text("2. " + getString(101)/*"Component-key pairing groups"*/, textDirection: TextDirection.ltr),
          trailing: exerciseCompleted[1] ? Image.asset('assets/core/completedicon.png') : Image.asset('assets/core/itemicon.png'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ComponentPage(questionType: QuestionType.ComponentGroup),
              ),
            ).then((val)=>{_getRequests()});
          },
        ),
        ListTile(
          //leading: Image.asset('assets/core/itemicon.png'),
          title: Text("3. " + getString(102)/*"Memorize by groups"*/, textDirection: TextDirection.ltr),
          trailing: exerciseCompleted[2] ? Image.asset('assets/core/completedicon.png') : Image.asset('assets/core/itemicon.png'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ComponentPage(questionType: QuestionType.ComponentInGroup),
              ),
            ).then((val)=>{_getRequests()});
          },
        ),

        ListTile(
          //leading: Image.asset('assets/core/itemicon.png'),
          title: Text("4. " + getString(103)/*"Memorize the pairings"*/, textDirection: TextDirection.ltr),
          trailing: exerciseCompleted[3] ? Image.asset('assets/core/completedicon.png') : Image.asset('assets/core/itemicon.png'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ComponentPage(questionType: QuestionType.Component),
              ),
            ).then((val)=>{_getRequests()});
          },
        ),
        ListTile(
          //leading: Image.asset('assets/core/itemicon.png'),
          title: Text("5. " + getString(104)/*"Guided typing"*/, textDirection: TextDirection.ltr),
          trailing: exerciseCompleted[4] ? Image.asset('assets/core/completedicon.png') : Image.asset('assets/core/itemicon.png'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InputZiPage(typingType: TypingType.LeadComponents, lessonId: 0), //InputZiPage(),
              ),
            ).then((val)=>{_getRequests()});
          },
        ),
        ListTile(
          //leading: Image.asset('assets/core/itemicon.png'),
          title: Text("6. " + getString(105)/*"Expanded Components"*/, textDirection: TextDirection.ltr),
          trailing: exerciseCompleted[5] ? Image.asset('assets/core/completedicon.png') : Image.asset('assets/core/itemicon.png'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ComponentPage(questionType: QuestionType.ExpandedComponent),
              ),
            ).then((val)=>{_getRequests()});
          },
        ),
        //ListTile(
        //  title: Text("Guided typing of characters", textDirection: TextDirection.ltr),
        //),
        ListTile(
          //leading: Image.asset('assets/core/itemicon.png'),
          title: Text("7. " + getString(308)/*"Review Expanded Components"*/, textDirection: TextDirection.ltr),
          trailing: exerciseCompleted[6] ? Image.asset('assets/core/completedicon.png') : Image.asset('assets/core/itemicon.png'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ComponentPage(questionType: QuestionType.ReviewExpandedComponent),
              ),
            ).then((val)=>{_getRequests()});
          },
        ),
        //ListTile(
        //  title: Text("Guided typing of characters", textDirection: TextDirection.ltr),
        //),
        ListTile(
          //leading: Image.asset('assets/core/itemicon.png'),
          title: Text("8. " + getString(106)/*"Typing exercises"*/, textDirection: TextDirection.ltr),
          trailing: exerciseCompleted[7] ? Image.asset('assets/core/completedicon.png') : Image.asset('assets/core/itemicon.png'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InputZiPage(typingType: TypingType.ExpandedComponents, lessonId: 0), //InputZiPage(),
              ),
            ).then((val)=>{_getRequests()});
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
      ],
    );
  }
}