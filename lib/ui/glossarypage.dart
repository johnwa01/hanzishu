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
  double fontSize1 = 0.0;
  double fontSize2 = 0.0;
  double fontSize3 = 0.0;

  double screenWidth = 0.0;
  late ScrollController _scrollController;
  PrimitiveWrapper contentLength = PrimitiveWrapper(0.0);
  OverlayEntry? overlayEntry = null;
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
    fontSize3 = TheConst.fontSizes[2]; //* getSizeRatioWithLimit();

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
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth < 940 ? 16.0 : 24.0,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: getGlossaryContentView(context),
                  ),
                ),
              ),
              onWillPop: _onWillPop
          ),
        ),

      ),
    );
  }

  Future<bool>_onWillPop() {
    return Future.value(true);
  }


  Widget buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(
        top: fontSize3,
        bottom: fontSize3 * 0.2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.blue,
              fontSize: fontSize1 + 2,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 4),
          Divider(
            thickness: 1.2,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }


  Widget buildGlossaryItem(
      String title,
      List<String> descriptions,
      ) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: fontSize3 * 0.75),
      padding: EdgeInsets.all(fontSize3 * 0.8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.blue,
              fontSize: fontSize2,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: fontSize3 * 0.4),
          ...descriptions.map(
                (text) => Padding(
              padding: EdgeInsets.only(
                bottom: fontSize3 * 0.2,
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: fontSize3,
                  height: 1.4,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getGlossaryContentView(BuildContext context) {
    return Column(
      //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          buildSectionHeader(getString(209)/*"Terminology"*/),
          buildGlossaryItem(
            getString(210)/*"Hanzi"*/,
            [
              getString(211)/*"Chinese character"*/,
            ],
          ),
          buildGlossaryItem(
            getString(212)/*"Hanzishu"*/,
            [
              getString(213)/*"Hanzishu literally translates to ‘Chinese character tree’. Hansizhu is a learning method which breaks up Chinese Characters into Components. This system is used to search through the Chinese dictionary as well as to teach reading and typing in Chinese."*/,
            ],
          ),
          buildGlossaryItem(
            getString(214)/*"Strokes"*/,
            [
              getString(215)/*"The lines used to create a Character (or a Component)."*/,
            ],
          ),
          buildGlossaryItem(
            getString(216)/*"Components"*/,
            [
              getString(217)/*"Elements of a Character. There are two types of Components:"*/,
              "• " + getString(218)/*"Components that are also Characters (Basic Characters)"*/,
              "• " + getString(219)/*"Non-Character Components. They require other Components to create a Character."*/,
            ],
          ),
          buildGlossaryItem(
            getString(220)/*"Basic Characters"*/,
            [
              getString(221)/*"Standalone Components. Basic Characters are the foundation of the First Character Dictionary."*/,
            ],
          ),
          buildGlossaryItem(
            getString(222)/*"Characters"*/,
            [
              getString(223)/*"Characters are created with Components or Strokes."*/,
            ],
          ),
          buildGlossaryItem(
            getString(224)/*"Lead Components"*/,
            [
              getString(225)/*"The basic Components which are mapped to a key on the English keyboard."*/,
              getString(226)/*"Select Shift+z to show the Component-key pairings while typing."*/,
              getString(229)/*"Select Shift+ any key except z to show the Expanded Components while typing."*/,
            ],
          ),
          buildGlossaryItem(
            getString(230)/*"Make-up Strokes"*/,
            [
              getString(231)/*"The Strokes used to complete typing of Characters which contains only one or two Components."*/,
            ],
          ),
          buildGlossaryItem(
            getString(232)/*"Component-key pairing"*/,
            [
              getString(233)/*"A Lead Component and its corresponding key on the English keyboard."*/,
            ],
          ),
          buildGlossaryItem(
            getString(234)/*"Mapping"*/,
            [
              getString(235)/*"The concept of matching Lead Components to the English keyboard."*/,
            ],
          ),
          buildGlossaryItem(
            getString(236)/*"Component Input Method"*/,
            [
              getString(237)/*"A methodology of learning and typing Chinese by breaking up Characters into Components and mapping those core Components (Lead Components) to the English keyboard. All other Components (Expanded Components) are sorted under each Lead Component (often with a similar shape). Components are grouped into sequences of English letters. These sequences create Characters. Supports nearly 3,800 Characters."*/,
              getString(238)/*"A separate IME app for the input method to be used by other programs is under development and could be released at any time."*/,
            ],
          ),
          buildGlossaryItem(
            getString(239)/*"First Character Dictionary"*/,
            [
              getString(240)/*"A Chinese Character dictionary that’s organized based on Basic Characters. Searching a Character by searching the first Basic Character it contains."*/,
            ],
          ),
          SizedBox(height: fontSize3 * 0.5),
          buildSectionHeader(getString(241)/*"Sections"*/),
          buildGlossaryItem(
            getString(242)/*"Lessons"*/,
            [
              getString(243)/*"Practice your Chinese with 10 units of lessons (60 lessons total)."*/,
              getString(244)/*"Return to this section once you have mastered the Component Input Method."*/,
            ],
          ),
          buildGlossaryItem(
            getString(245)/*"Character drills"*/,
            [
              getString(246)/*"Overview of Characters via a navigation tree. Includes definition, pronunciation, writing how-to, and the Basic Characters. It is a recursive tree with Components forming complicated Characters. It is visualized with the Character in the center of the screen and the Components/Characters (situated on all four sides of the screen) building up the central Character one layer at a time. Tapping a Character in the center drills down, and tapping a Component/Character on the sides moves back. Holding a Character/Component displays its detailed information."*/,
            ],
          ),
          buildGlossaryItem(
            getString(247)/*"Flashcards"*/,
            [
              getString(248)/*"Reviews all the new Basic Characters, non-characters, and phrases from a lesson. Includes pronunciation, definition, strokes, and the Component-key pairing sequence."*/,
            ],
          ),
          buildGlossaryItem(
            getString(249)/*"Character breakdown"*/,
            [
              getString(250)/*"Separates Characters in a lesson into Characters or Components. Tapping a Character or a Component displays its detailed information."*/,
            ],
          ),
          buildGlossaryItem(
            getString(251)/*"Conversation"*/,
            [
              getString(252)/*"Demonstrates pronunciation and provides speaking practice. Tapping a Character displays its overlay information."*/,
            ],
          ),
          buildGlossaryItem(
            getString(253)/*"Typing exercises"*/,
            [
              getString(254)/*"Practice for typing the Character using the Component Input Method."*/,
            ],
          ),
          buildGlossaryItem(
            getString(255)/*"Quiz"*/,
            [
              getString(256)/*"Reviews the lesson."*/,
            ],
          ),
          buildGlossaryItem(
            getString(257)/*"Dictionary"*/,
            [
              getString(258)/*"View all the characters based on the First Character Dictionary method which groups Characters by their Basic Characters. Contains nearly 3,800 Characters."*/,
              getString(259)/*"Reference the Dictionary as you learn the Component Input Method and complete the lessons."*/,
            ],
          ),
          buildGlossaryItem(
            getString(260)/*"Typing"*/,
            [
              getString(261)/*"Learn the Component Input Method and memorize the Component-key pairings."*/,
              getString(262)/*"Start in this section before continuing to the Lessons section."*/,
            ],
          ),
          buildGlossaryItem(
            getString(263)/*"Me"*/,
            [
              getString(264)/*"Track your progress and review what you’ve already covered."*/,
            ],
          ),
          buildGlossaryItem(
            getString(265)/*"Character review"*/,
            [
              getString(266)/*"Review the characters according to the lessons and the units that they were first introduced."*/,
            ],
          ),
          SizedBox(height: fontSize3 * 0.5),
          buildSectionHeader(getString(269)/*"Icons"*/),
          buildGlossaryItem(
            getString(270)/*"Triangle"*/,
            [
              getString(271)/*"Indicates a new Character or Component in the lesson."*/,
            ],
          ),
          buildGlossaryItem(
            getString(272)/*"Pencil"*/,
            [
              getString(273)/*"Tap to see the Character drawn"*/,
            ],
          ),
          buildGlossaryItem(
            getString(274)/*"Speaker"*/,
            [
              getString(275)/*"Tap to hear the Character"*/,
            ],
          ),
          buildGlossaryItem(
            getString(276)/*"Check mark"*/,
            [
              getString(277)/*"Indicates that you have just gone through this Character or Component."*/,
            ],
          ),
          buildGlossaryItem(
            getString(305)/*"Diamond"*/,
            [
              getString(306)/*"To show the detailed breakdown info."*/,
            ],
          ),
          SizedBox(height: fontSize3 * 0.5),
          buildSectionHeader(getString(278)/*"Overlay"*/),
          buildGlossaryItem(
            getString(278)/*"Overlay"*/,
            [
              getString(279)/*"Tapping or holding a Character in many features within the app displays the detailed information about that Character."*/,
            ],
          ),
          SizedBox(height: fontSize3 * 2),
        ]
    );
  }
}
