import 'package:flutter/material.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/ui/inputzipage.dart';
import 'package:hanzishu/engine/component.dart';
import 'package:hanzishu/ui/componentpage.dart';
import 'package:hanzishu/ui/typingselectionpage.dart';

class ToolsPage extends StatefulWidget {
  @override
  _ToolsPageState createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Component Input Method 部件输入法"),
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
          title: Text("Please finish exercise 1 - 7 to learn the input method:", textDirection: TextDirection.ltr),
        ),
        ListTile(
          //leading: Image.asset('assets/core/itemicon.png'),
          title: Text("1. Give it a try", textDirection: TextDirection.ltr),
          trailing: Image.asset('assets/core/itemicon.png'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InputZiPage(typingType: TypingType.GiveItATry), //InputZiPage(),
              ),
            );
          },
        ),
        ListTile(
          //leading: Image.asset('assets/core/itemicon.png'),
          title: Text("2. Component-key pairing groups", textDirection: TextDirection.ltr),
          trailing: Image.asset('assets/core/itemicon.png'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ComponentPage(questionType: QuestionType.ComponentGroup),
              ),
            );
          },
        ),
        ListTile(
          //leading: Image.asset('assets/core/itemicon.png'),
          title: Text("3. Memorize by groups", textDirection: TextDirection.ltr),
          trailing: Image.asset('assets/core/itemicon.png'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ComponentPage(questionType: QuestionType.ComponentInGroup),
              ),
            );
          },
        ),

        ListTile(
          //leading: Image.asset('assets/core/itemicon.png'),
          title: Text("4. Memorize the pairings", textDirection: TextDirection.ltr),
          trailing: Image.asset('assets/core/itemicon.png'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ComponentPage(questionType: QuestionType.Component),
              ),
            );
          },
        ),
        ListTile(
          //leading: Image.asset('assets/core/itemicon.png'),
          title: Text("5. Guided typing", textDirection: TextDirection.ltr),
          trailing: Image.asset('assets/core/itemicon.png'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InputZiPage(typingType: TypingType.LeadComponents, lessonId: 0), //InputZiPage(),
              ),
            );
          },
        ),
        ListTile(
          //leading: Image.asset('assets/core/itemicon.png'),
          title: Text("6. Expanded Components", textDirection: TextDirection.ltr),
          trailing: Image.asset('assets/core/itemicon.png'),
          onTap: () {
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
          //leading: Image.asset('assets/core/itemicon.png'),
          title: Text(""
              "7. Typing exercises", textDirection: TextDirection.ltr),
          trailing: Image.asset('assets/core/itemicon.png'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InputZiPage(typingType: TypingType.ExpandedComponents, lessonId: 0), //InputZiPage(),
              ),
            );
          },
        ),
        ListTile(
          //leading: Image.asset('assets/core/itemicon.png'),
          title: Text(""
              "[Optional] Customized exercises", textDirection: TextDirection.ltr),
          trailing: Image.asset('assets/core/itemicon.png'),
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
          title: Text("Free typing and help", textDirection: TextDirection.ltr),
          trailing: Image.asset('assets/core/itemicon.png'),
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