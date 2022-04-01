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
          //leading: Icon(Icons.location_city),
          title: Text("Give it a try", textDirection: TextDirection.ltr),
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
          title: Text("Memorize the Component-key pairings", textDirection: TextDirection.ltr),
        ),
        ListTile(
          //leading: Icon(Icons.location_city),
          title: Text("        Memorize groups", textDirection: TextDirection.ltr),
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
          //leading: Icon(Icons.location_city),
          title: Text("        Memorize by groups", textDirection: TextDirection.ltr),
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
          //leading: Icon(Icons.location_city),
          title: Text("        Memorize the pairings", textDirection: TextDirection.ltr),
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
          //leading: Icon(Icons.location_city),
          title: Text("Guided typing", textDirection: TextDirection.ltr),
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
          //leading: Icon(Icons.location_city),
          title: Text("Expanded Components", textDirection: TextDirection.ltr),
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
          //leading: Icon(Icons.location_city),
          title: Text(""
              "Typing exercises", textDirection: TextDirection.ltr),
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
          //leading: Icon(Icons.location_city),
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
          //leading: Icon(Icons.location_city),
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