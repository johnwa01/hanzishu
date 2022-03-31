
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';

class GlossaryPage extends StatefulWidget {
  GlossaryPage();

  @override
  _GlossaryPageState createState() => _GlossaryPageState();
}

class _GlossaryPageState extends State<GlossaryPage> {
  double fontSize1;
  double fontSize2;
  double fontSize3;

  double screenWidth;
  ScrollController _scrollController;
  PrimitiveWrapper contentLength = PrimitiveWrapper(0.0);
  OverlayEntry overlayEntry;
  int previousOverlayGroup = 0;
  int previousOverlayIndex = 0;

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        //print("offset = ${_scrollController.offset}");
      });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // it is a good practice to dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidth(context);

    fontSize1 = 14.0 * getSizeRatioWithLimit();
    fontSize2 = 13.0 * getSizeRatioWithLimit();
    fontSize3 = 12.0 * getSizeRatioWithLimit(); // base size 12

    // init positionmanager frame size
    thePositionManager.setFrameWidth(screenWidth);

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Glossary"),
      ),
      body: Container(
        //height: 800.00,

        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: WillPopScope(
              child: getGlossaryContentView(context),
              onWillPop: _onWillPop
          ),
        ),

      ),
    );
  }

  Future<bool>_onWillPop() {
    return Future.value(true);
  }

  Widget getGlossaryContentView(BuildContext context) {
    return Column(
        //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          Text(
              "Terminology",
              style: TextStyle(color: Colors.blue, fontSize: fontSize1/*, fontWeight: FontWeight.bold*/),
              textAlign: TextAlign.start
            ),
          SizedBox(height: fontSize3),
          Text(
              "Hanzi (汉字)",
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "Chinese character",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
                "Hanzishu (汉字树)",
                style: TextStyle(color: Colors.blue, fontSize: fontSize2),
                textAlign: TextAlign.start
          ),
          Text(
                "Hanzishu literally translates to ‘Chinese character tree’. Hansizhu is a learning method which breaks up Chinese Characters into Components. This system is used to search through the Chinese dictionary as well as to teach reading and typing in Chinese.",
                style: TextStyle(fontSize: fontSize3),
                textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Strokes",
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "The lines used to create a Character (or a Component).",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Components",
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "Elements of a Character. There are two types of Components:",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "  •	Components that are also Characters (Basic Characters)",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          Text(
              "  •	Non-Character Components. They require other Components to create a Character.",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Basic Characters",
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "Standalone Components. Basic Characters are the foundation of the Hanzishu One Tap Dictionary.",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Characters",
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "Characters are created with Components or Strokes.",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Lead Components",
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "The basic Components which are mapped to a key on the English keyboard.",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Select Shift+z to show the Component-key pairings while typing.",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Expanded Components",
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "The Components that stem from a Lead Component. Expanded Components usually have a similar shape to its Lead Component.",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Select Shift+ any key except z to show the Expanded Components while typing.",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Make-up Strokes",
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "The Strokes used to complete typing of Characters which contains only one or two Components.",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Component-key pairing",
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "A Lead Component and its corresponding key on the English keyboard.",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Mapping",
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "The concept of matching Lead Components to the English keyboard.",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Hanzishu Input Typing Method",
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "A methodology of learning and typing Chinese by breaking up Characters into Components and mapping those core Components (Lead Components) to the English keyboard. All other Components (Expanded Components) are sorted under each Lead Component (often with a similar shape). Components are grouped into sequences of English letters. These sequences create Characters. Supports nearly 3,800 Characters.",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "A separate IME app for the input method to be used by other programs is under development and could be released at any time.",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Hanzishu One Tap Dictionary",
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "A Chinese Character dictionary that’s organized based on Basic Characters. Searching a Character by searching the first Basic Character it contains.",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          SizedBox(height: fontSize3),
          Text(
              "Sections",
              style: TextStyle(color: Colors.blue, fontSize: fontSize1),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Lessons",
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "Practice your Chinese with 10 units of lessons (60 lessons total).",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          Text(
              "Return to this section once you have mastered the Hanzishu Typing Method.",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Character drills",
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "Overview of Characters via a navigation tree. Includes definition, pronunciation, writing how-to, and the Basic Characters. It is a recursive tree with Components forming complicated Characters. It is visualized with the Character in the center of the screen and the Components/Characters (situated on all four sides of the screen) building up the central Character one layer at a time. Tapping a Character in the center drills down, and tapping a Component/Character on the sides moves back. Holding a Character/Component displays its detailed information.",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Flashcards",
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "Reviews all the new Basic Characters, non-characters, and phrases from a lesson. Includes pronunciation, definition, strokes, and the Component-key pairing sequence.",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Character breakdown",
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "Separates Characters in a lesson into Characters or Components. Tapping a Character or a Component displays its detailed information.",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Conversation",
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "Demonstrates pronunciation and provides speaking practice. Tapping a Character displays its overlay information.",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Typing exercises",
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "Practice for typing the Character using the Hanzishu Input Typing Method.",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Quiz",
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "Reviews the lesson.",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Dictionary",
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "View all the characters based on the Hanzishu One Tap Dictionary method which groups Characters by their Basic Characters. Contains nearly 3,800 Characters.",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Reference the Dictionary as you learn the Hanzishu Input Typing Method and complete the lessons.",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Typing",
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "Learn the Hanzishu Input Typing Method and memorize the Component-key pairings.",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Start in this section before continuing to the Lessons section.",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Me",
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "Track your progress and review what you’ve already covered.",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Character review",
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "Review the characters according to the lessons and the units that they were first introduced.",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Quiz results",
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "Records of the quizzes that you have taken",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          SizedBox(height: fontSize3),
          Text(
              "Icons",
              style: TextStyle(color: Colors.blue, fontSize: fontSize1),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Triangle",
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "Indicates a new Character or Component in the lesson.",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Pencil",
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "Tap to see the Character drawn",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Speaker",
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "Tap to hear the Character",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "Check mark",
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "Indicates that you have just gone through this Character or Component.",
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          SizedBox(height: fontSize3),
          Text(
              "Overlay",
              style: TextStyle(color: Colors.blue, fontSize: fontSize1),
              textAlign: TextAlign.start
          ),
          Text(
              "Tapping or holding a Character in many features within the app displays the detailed information about that Character.",
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
        ]
    );
  }
}