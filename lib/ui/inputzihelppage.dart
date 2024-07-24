
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
//import 'package:video_player/video_player.dart';

class InputZiHelpPage extends StatefulWidget {
  InputZiHelpPage();

  @override
  _InputZiHelpPageState createState() => _InputZiHelpPageState();
}

class _InputZiHelpPageState extends State<InputZiHelpPage> {
  //VideoPlayerController _videoController;

  double screenWidth;
  ScrollController _scrollController;
  PrimitiveWrapper contentLength = PrimitiveWrapper(0.0);
  OverlayEntry overlayEntry;
  int previousOverlayGroup = 0;
  int previousOverlayIndex = 0;

  /*
  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }
*/

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }

  @override
  void initState() {
    super.initState();

    //_videoController = VideoPlayerController.asset('assets/video/Welcome.MP4');
    // Initialize the VideoPlayerController.
    //_videoController.initialize();
    // Play the video.
    //_videoController.play();

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

  double getSizeRatio() {
    // Note: assume screenWidth has considered the height to screen ratio already, that is, might be narrowed alreadly
    //       from the actual screen size if height to width ratio is lower than the minimum.
    return Utility.getSizeRatio(screenWidth);
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidth(context);
    // init positionmanager frame size
    thePositionManager.setFrameWidth(screenWidth);

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(getString(93)/*"部件输入法"*/),
      ),
      body: Container(
        //height: 800.00,

        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: WillPopScope(
              child: getHelpContentView(context),
              onWillPop: _onWillPop
          ),
        ),

      ),
    );
  }

  initOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
      theDicOverlayEntry = null;
    }
  }

  Future<bool>_onWillPop() {
    initOverlay();

    return Future.value(true);
  }

  showOverlay(BuildContext context, keyGroup, keyIndex) {
    initOverlay();

    if (!(keyGroup == 0 && keyIndex == 0) && !(previousOverlayGroup == keyGroup && previousOverlayIndex == keyIndex)) {
      var fullExpandedComp = theComponentManager
          .getFullExpandedComponentByGroupAndIndex(keyGroup, keyIndex);

      OverlayState overlayState = Overlay.of(context);
      overlayEntry = OverlayEntry(
          builder: (context) =>
              Positioned(
                top: 30 * getSizeRatioWithLimit(), // 30 is the minimum value without being partially covered
                left: 100.0 * getSizeRatioWithLimit(), //posiX,
                child: Image.asset(
                  "assets/typing/" + fullExpandedComp.imageName,
                  width: 100.0 * getSizeRatioWithLimit(),
                  height: 130.0 * getSizeRatioWithLimit(),
                  //fit: BoxFit.fitWidth,
                ),
              ));
      overlayState.insert(overlayEntry);
      previousOverlayGroup = keyGroup;
      previousOverlayIndex = keyIndex;
    }
    else {
      previousOverlayGroup = 0;
      previousOverlayIndex = 0;
    }
  }

  Widget getOneKeyboardButton(int keyGroup, int keyIndex)
  {
    var image;
    if (keyGroup == 0 && keyIndex == 0) {
      image = "C00.png"; // the empty image without content, actual LC00.png
    }
    else {
      image = theComponentManager.getComponentByGroupAndIndex(
          keyGroup, keyIndex).image;
    }

    return FlatButton(
      color: Colors.white,
      textColor: Colors.blueAccent,
      padding: EdgeInsets.zero,
      onPressed: () {
        initOverlay();

        showOverlay(context, keyGroup, keyIndex);
      },
      child: Image.asset(
        "assets/components/L" + image,
        width: 30.0 * getSizeRatioWithLimit(),
        height: 55.0 * getSizeRatioWithLimit(),
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget getHelpContentView(BuildContext context) {
    var fontSize1 = TheConst.fontSizes[1]; //* getSizeRatioWithLimit();
    var fontSize2 = TheConst.fontSizes[2]; //* getSizeRatioWithLimit();

    var fontSize = 18.0 * getSizeRatioWithLimit();
    return Column(
        //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: fontSize2 / 2),
          Text(
              getString(93)/*"部件输入法"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize1),
              textAlign: TextAlign.start
          ),
          //AspectRatio(
          //  aspectRatio: _videoController.value.aspectRatio,
          //    child: VideoPlayer(_videoController),
          //),
          Text(
              getString(366)/*"部件输入法将一个汉字分解成部件，并在英文键盘上输入对应的字母。"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize2 / 2),
          Text(
              getString(156)/*"What are Components?"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize1),
              textAlign: TextAlign.start
          ),
          Text(
              getString(157)/*"Components are elements of a Character. The Hanzishu Component Input Method breaks Components into two types. Lead Components are the base Components. And each Lead Component houses a collection of sub-components called Expanded Components."*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize2),
          Text(
              getString(158)/*"How it works"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize1),
              textAlign: TextAlign.start
          ),
          Text(
              getString(159)/*"The Hanzishu Component Input Method matches each Lead Component with a key on the English keyboard to create a Component-key pairing. Reference this chart to visualize how Lead Components are mapped to English letters."*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize2),

          Row(
              children: <Widget>[
                Flexible(child: getOneKeyboardButton(1, 5)),
                Flexible(child: getOneKeyboardButton(1, 4)),
                Flexible(child: getOneKeyboardButton(1, 3)),
                Flexible(child: getOneKeyboardButton(1, 2)),
                Flexible(child: getOneKeyboardButton(1, 1)),
                SizedBox(width: fontSize),
                Flexible(child: getOneKeyboardButton(2, 1)),
                Flexible(child: getOneKeyboardButton(2, 2)),
                Flexible(child: getOneKeyboardButton(2, 3)),
                Flexible(child: getOneKeyboardButton(2, 4)),
                Flexible(child: getOneKeyboardButton(2, 5)),
              ]
          ),
          Row(
              children: <Widget>[
                Flexible(child: getOneKeyboardButton(3, 5)),
                Flexible(child: getOneKeyboardButton(3, 4)),
                Flexible(child: getOneKeyboardButton(3, 3)),
                Flexible(child: getOneKeyboardButton(3, 2)),
                Flexible(child: getOneKeyboardButton(3, 1)),
                SizedBox(width: fontSize),
                Flexible(child: getOneKeyboardButton(4, 1)),
                Flexible(child: getOneKeyboardButton(4, 2)),
                Flexible(child: getOneKeyboardButton(4, 3)),
                Flexible(child: getOneKeyboardButton(4, 4)),
                Flexible(child: getOneKeyboardButton(0, 0)),
              ]
          ),
          Row(
              children: <Widget>[
                Flexible(child: getOneKeyboardButton(0, 0)),
                Flexible(child: getOneKeyboardButton(5, 4)),
                Flexible(child: getOneKeyboardButton(5, 3)),
                Flexible(child: getOneKeyboardButton(5, 2)),
                Flexible(child: getOneKeyboardButton(5, 1)),
                SizedBox(width: fontSize),
                Flexible(child: getOneKeyboardButton(6, 1)),
                Flexible(child: getOneKeyboardButton(6, 2)),
                Flexible(child: getOneKeyboardButton(0, 0)),
                Flexible(child: getOneKeyboardButton(0, 0)),
                Flexible(child: getOneKeyboardButton(0, 0)),
              ]
          ),
          SizedBox(height: fontSize2),
          Container(
            //color: Colors.grey,
            //padding: EdgeInsets.all(1.0),
            alignment: Alignment.center,
            child: Image.asset(
              "assets/typing/FullComponents.png",
              width: 370.0 * getSizeRatio(),
              height: 250.0 * getSizeRatio(),
            )
          ),
          //SizedBox(height: fontSize2),
          Text(
              getString(160)/*"Expanded Components are grouped under each Lead Component-key pairing. To type in Chinese, Components are grouped into sequences of English letters. Each sequence of Components creates a Character."*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize2),
          Text(
              getString(161)/*"The Typing section of this app will:"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "  • " + getString(162)/*"Introduce you to Lead & various Expanded Components"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "  • " + getString(163)/*"Teach you the Component-key pairings and typing method"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "  • " + getString(164)/*"Help you memorize the Component-key pairings"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "  • " + getString(165)/*"Help you practice with guided and free typing"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              getString(166)/*"By the time you finish, you’ll be ready to type in Chinese on your own!"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize2),
          Text(
              getString(167)/*"Tips"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize1),
              textAlign: TextAlign.start
          ),
          //SizedBox(height: fontSize2),
          Text(
              getString(168)/*"Tip 1: Want to use what you type elsewhere? Double click the content in the editing field to copy."*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize2),
          Text(
              getString(169)/*"Tip 2: The Dos and Don’ts of breaking up a Character into Components."*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "  • " + getString(170)/*"DON’T break up Strokes that cross through each other."*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "    o " + getString(171)/*"ex: Character 井 doesn’t split into separate Components"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          //Text(
          //    "  •	" + getString(172)/*"DO break up two strokes that are next to each other or just touching."*/,
          //    style: TextStyle(fontSize: fontSize2),
          //    textAlign: TextAlign.start
          //),
          Text(
              "    o " + getString(173)/*"ex: 明 -> 日 and 月"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "    o " + getString(174)/*"ex: 古 -> 十 and 口"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "  • " + getString(175)/*"DO break up Characters into as few Components as possible."*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "    o " + getString(176)/*"ex: 房 -> 户 and 方 (instead of four Components)"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "  • " + getString(177)/*"DO break up Characters into the Component with the most  strokes."*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "    o " +  getString(178)/*"ex: 云 -> 一 (plus another Component with three strokes)"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize2),
          Text(
              getString(179)/*"Tip 3: The Lead Components and their keyboard pairings are visualized on the keyboard chart above."*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "  • " + getString(180)/*"Tap each Lead Component in the chart to see the Expanded Components associated to them."*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "  • " + getString(181)/*"During typing, select Shift+z to show the Component-key pairings. Select Shift+ any key (except z) to show the Expanded Components."*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "  • " + getString(182)/*"To type a Lead Component or its Expanded Component, simply type the corresponding keyboard key."*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          /*
          SizedBox(height: fontSize2),
          Text(
              getString(183)/*"提示 4：将部件分解为子部件的规则。"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "  • " + getString(362)/*"除了以下两点，与将字分解为部件的规则相同："*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "    o " + getString(363)/*"如果没有其它选择，可以分解相互交叉的笔画"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "    o " + getString(364)/*"出现的笔画和形体按此表归入相似部件"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Container(
            alignment: Alignment.center,
            child: Image.asset(
                "assets/typing/SpecialStrokes.png",
                width: 200.0 * getSizeRatioWithLimit(), //390
                height: 160.0 * getSizeRatioWithLimit()), //150
          ),
          */
          SizedBox(height: fontSize2),
          Text(
              getString(184)/*"How to type a Chinese Character"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize1),
              textAlign: TextAlign.start
          ),
          /*
          Text(
              "1. " + getString(185)/*"Divide the character into components (Lead Components or Expanded Components)."*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "  a. " + getString(186)/*"If a Character has one Component:"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "    i. " + getString(187)/*"Type the Component"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "    ii. " + getString(188)/*"If the Character doesn’t appear on the list:"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "      1. " + getString(189)/*"Type up to three make-up Strokes (the first, second, and the last stroke of the Component) until the Character appears"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "      2. " + getString(190)/*"Treat all fold Strokes as a Component 乙"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "  b. " + getString(191)/*"If a Character has two Components:"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "    i. " + getString(192)/*"Type the two Components first"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "    ii. " + getString(193)/*"If the Character doesn’t appear on the list:"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "      1. " + getString(194)/*"Type two make-up Strokes (the last Stroke of each Component) until the Character appears"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "      2. " + getString(195)/*"Treat all fold Strokes as a Component 乙"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "  c. " + getString(196)/*"If a Character has three or more Components:"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          */
          Text(
              getString(197)/*"Type as many Components as necessary in sequence until the Character appears"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize2),
          Text(
              getString(198)/*"In action"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize1),
              textAlign: TextAlign.start
          ),
          Text(
              getString(199)/*"Ex: Type the Chinese character 品"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "  • " + getString(200)/*"Find the first Component 口"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "  • " + getString(201)/*"Find the corresponding key i"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "  • " + getString(202)/*"Tap it"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "  • " + getString(203)/*"If 品 appears in the Character list (below the editing field), select it by:"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "    o " + getString(204)/*"Tapping the Character"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "    o " + getString(206)/*"Typing the number associated with the character"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "    o " + getString(205)/*"Tapping the spacebar if it’s first in the list"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "  • " + getString(207)/*"If the Character is not listed, repeat these steps with the second and third Components until you see 品 listed"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "  • " + getString(367)/*"如果'品'字排在后面，也可继续输入部件，使它的排列靠前"*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "  • " + getString(208)/*"The English letters in the editing field automatically convert to 品."*/,
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
        ]
    );
  }
}

