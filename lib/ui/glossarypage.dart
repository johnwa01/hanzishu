
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

    fontSize1 = TheConst.fontSizes[1]; //* getSizeRatioWithLimit();
    fontSize2 = TheConst.fontSizes[2]; //* getSizeRatioWithLimit();
    fontSize2 = TheConst.fontSizes[2]; //* getSizeRatioWithLimit();

    // init positionmanager frame size
    thePositionManager.setFrameWidth(screenWidth);

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(getString(140)/*"Glossary"*/),
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
              getString(209)/*"Terminology"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize1/*, fontWeight: FontWeight.bold*/),
              textAlign: TextAlign.start
            ),
          SizedBox(height: fontSize3),
          Text(
              getString(210)/*"Hanzi"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              getString(211)/*"Chinese character"*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
                getString(212)/*"Hanzishu"*/,
                style: TextStyle(color: Colors.blue, fontSize: fontSize2),
                textAlign: TextAlign.start
          ),
          Text(
                getString(213)/*"Hanzishu literally translates to ‘Chinese character tree’. Hansizhu is a learning method which breaks up Chinese Characters into Components. This system is used to search through the Chinese dictionary as well as to teach reading and typing in Chinese."*/,
                style: TextStyle(fontSize: fontSize3),
                textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(214)/*"Strokes"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              getString(215)/*"The lines used to create a Character (or a Component)."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(216)/*"Components"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              getString(217)/*"Elements of a Character. There are two types of Components:"*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "  •	" + getString(218)/*"Components that are also Characters (Basic Characters)"*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          Text(
              "  •	" + getString(219)/*"Non-Character Components. They require other Components to create a Character."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(220)/*"Basic Characters"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              getString(221)/*"Standalone Components. Basic Characters are the foundation of the First Character Dictionary."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(222)/*"Characters"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              getString(223)/*"Characters are created with Components or Strokes."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(224)/*"Lead Components"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              getString(225)/*"The basic Components which are mapped to a key on the English keyboard."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(226)/*"Select Shift+z to show the Component-key pairings while typing."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          //Text(
          //    getString(227)/*"Expanded Components"*/,
          //    style: TextStyle(color: Colors.blue, fontSize: fontSize2),
          //    textAlign: TextAlign.start
          //),
          //Text(
          //    getString(228)/*"The Components that stem from a Lead Component. Expanded Components usually have a similar shape to its Lead Component."*/,
          //    style: TextStyle(fontSize: fontSize3),
          //    textAlign: TextAlign.start
          //),
          //SizedBox(height: fontSize3),
          Text(
              getString(229)/*"Select Shift+ any key except z to show the Expanded Components while typing."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(230)/*"Make-up Strokes"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              getString(231)/*"The Strokes used to complete typing of Characters which contains only one or two Components."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(232)/*"Component-key pairing"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              getString(233)/*"A Lead Component and its corresponding key on the English keyboard."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(234)/*"Mapping"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              getString(235)/*"The concept of matching Lead Components to the English keyboard."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(236)/*"Component Input Method"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              getString(237)/*"A methodology of learning and typing Chinese by breaking up Characters into Components and mapping those core Components (Lead Components) to the English keyboard. All other Components (Expanded Components) are sorted under each Lead Component (often with a similar shape). Components are grouped into sequences of English letters. These sequences create Characters. Supports nearly 3,800 Characters."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(238)/*"A separate IME app for the input method to be used by other programs is under development and could be released at any time."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(239)/*"First Character Dictionary"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              getString(240)/*"A Chinese Character dictionary that’s organized based on Basic Characters. Searching a Character by searching the first Basic Character it contains."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          SizedBox(height: fontSize3),
          Text(
              getString(241)/*"Sections"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize1),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(242)/*"Lessons"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              getString(243)/*"Practice your Chinese with 10 units of lessons (60 lessons total)."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          Text(
              getString(244)/*"Return to this section once you have mastered the Component Input Method."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(245)/*"Character drills"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              getString(246)/*"Overview of Characters via a navigation tree. Includes definition, pronunciation, writing how-to, and the Basic Characters. It is a recursive tree with Components forming complicated Characters. It is visualized with the Character in the center of the screen and the Components/Characters (situated on all four sides of the screen) building up the central Character one layer at a time. Tapping a Character in the center drills down, and tapping a Component/Character on the sides moves back. Holding a Character/Component displays its detailed information."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(247)/*"Flashcards"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              getString(248)/*"Reviews all the new Basic Characters, non-characters, and phrases from a lesson. Includes pronunciation, definition, strokes, and the Component-key pairing sequence."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(249)/*"Character breakdown"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              getString(250)/*"Separates Characters in a lesson into Characters or Components. Tapping a Character or a Component displays its detailed information."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(251)/*"Conversation"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              getString(252)/*"Demonstrates pronunciation and provides speaking practice. Tapping a Character displays its overlay information."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(253)/*"Typing exercises"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              getString(254)/*"Practice for typing the Character using the Component Input Method."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(255)/*"Quiz"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              getString(256)/*"Reviews the lesson."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(257)/*"Dictionary"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              getString(258)/*"View all the characters based on the First Character Dictionary method which groups Characters by their Basic Characters. Contains nearly 3,800 Characters."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(259)/*"Reference the Dictionary as you learn the Component Input Method and complete the lessons."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(260)/*"Typing"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              getString(261)/*"Learn the Component Input Method and memorize the Component-key pairings."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(262)/*"Start in this section before continuing to the Lessons section."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(263)/*"Me"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              getString(264)/*"Track your progress and review what you’ve already covered."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(265)/*"Character review"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              getString(266)/*"Review the characters according to the lessons and the units that they were first introduced."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          //Text(
          //    getString(267)/*"Quiz results"*/,
          //    style: TextStyle(color: Colors.blue, fontSize: fontSize2),
          //    textAlign: TextAlign.start
          //),
          //Text(
          //    getString(268)/*"Records of the quizzes that you have taken"*/,
          //    style: TextStyle(fontSize: fontSize3),
          //    textAlign: TextAlign.start
          //),
          //SizedBox(height: fontSize3),
          SizedBox(height: fontSize3),
          Text(
              getString(269)/*"Icons"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize1),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(270)/*"Triangle"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              getString(271)/*"Indicates a new Character or Component in the lesson."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(272)/*"Pencil"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              getString(273)/*"Tap to see the Character drawn"*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(274)/*"Speaker"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              getString(275)/*"Tap to hear the Character"*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(276)/*"Check mark"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              getString(277)/*"Indicates that you have just gone through this Character or Component."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(305)/*"Diamond"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              getString(306)/*"To show the detailed breakdown info."*/,
              style: TextStyle(fontSize: fontSize3),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          SizedBox(height: fontSize3),
          Text(
              getString(278)/*"Overlay"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize1),
              textAlign: TextAlign.start
          ),
          Text(
              getString(279)/*"Tapping or holding a Character in many features within the app displays the detailed information about that Character."*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
        ]
    );
  }
}