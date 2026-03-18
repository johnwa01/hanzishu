import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/ui/inputzipage.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/engine/inputgamemanager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hanzishu/engine/inputgame.dart';
import 'package:hanzishu/data/inputgameanswersheetlist.dart';

class InputGamePage extends StatefulWidget {
  Map<int, PositionAndSize> sidePositionsCache = Map();
  Map<int, List<int>>realGroupMembersCache = Map();
  late PositionAndSize centerPositionAndSizeCache;
  final String? gameid;
  final String? gameid2;

  InputGamePage({required this.gameid, this.gameid2});

  @override
  _InputGamePageState createState() => _InputGamePageState();
}

class _InputGamePageState extends State<InputGamePage> with SingleTickerProviderStateMixin {
  int searchingZiIndex = -1;
  late bool shouldDrawCenter;
  late double screenWidth;
  //late String initZis;
  late int? currentGameId;
  late int? currentGameType; // 1: pictographic, 2: Pinyin input

  FocusNode _textNode = new FocusNode();

  late TextEditingController _controller;

  int compoundZiComponentNum = 0;
  List<int> compoundZiAllComponents = [];
  Timer? compoundZiAnimationTimer;
  int compoundZiCurrentComponentId = -1;
  var currentZiListType = ZiListType.searching;

  String inputText = '';
  int currentIndex = 0;

  bool gridShowZi = true;
  InputGameState inputGameState = InputGameState.login;

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }

  @override
  void initState() {
    super.initState();

    currentGameId = int.parse(widget.gameid!);

    theCurrentCenterZiId = searchingZiIndex;

    setState(() {
      gridShowZi = true;
      inputGameState = InputGameState.login;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidthForTreeAndDict(context);
    thePositionManager.setFrameWidth(screenWidth - 10.0);
    _controller = new TextEditingController(text: ""/*initZis*/);

    /*"Grid shows Hanzi"*/
    var gridShowOrNotShowZiString = gridShowZi ? getString(452) : getString(453);/*"Grid (not) show Hanzi"*/;
    String displ = "请输入参赛码：Please enter participation code:";

    try {
      return Scaffold
        (
        appBar: AppBar
          (
          title: Text("汉字树杯输入大赛 | Hanzishu Cup  Input Competition"),
        ),
        body: Container(
            child: WillPopScope(
                child: new Column( //Stack(
                    children: //<Widget>[
                      getUIByInputGameState(),
                ),
                onWillPop: _onWillPop
            )
        ),
      );
    } catch (e, s) {
      print(s);
    }

    // should not reach here
    return SizedBox(width: 0.0, height: 0.0);
  }

  List<Widget> getUIByInputGameState() {
    switch (inputGameState) {
      case InputGameState.login:
        return getLogins();
      case InputGameState.gameType:
        return getGameTypes();
      case InputGameState.answerSheet:
        return getAnswerSheets();
      case InputGameState.game:
        return getGame();
    }

    return [];
  }

  List<Widget> getLogins() {
    List<Widget> logins = [];
    logins.add(SizedBox(height: 50));
    logins.add(Center(child: Row(
        children: <Widget>[
          SizedBox(width: 50 * getSizeRatioWithLimit()),
          SizedBox(
            width: 200 * getSizeRatioWithLimit(), //double.infinity,
            //height: 120,
            child: TextField(
              autocorrect: false,
              enableSuggestions: false,
              controller: _controller,
              focusNode: _textNode,
              autofocus: false,
              style: TextStyle(
                 fontSize: 18 * getSizeRatioWithLimit(), //editFontSize * editFieldFontRatio, // 35
                  //height: 1.0 // 1.0
                 ),
              maxLines: 1,
              //expands: true,
              keyboardType: TextInputType.text, //multiline,  //TextInputType.visiblePassword
              decoration: InputDecoration(
                //hintText: 'This test',
                filled: true,
                fillColor: Colors.grey, //lightBlueAccent, //black12,
              ),
            ),//focusNode: _textNode,
          ),
          SizedBox(width: 10 * getSizeRatioWithLimit()),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: TextStyle(fontSize: 20.0 * getSizeRatioWithLimit()),
            ),

            onPressed: () {
              processInputs();
            },
            child: Text("开始 Start login",
              style: TextStyle(color: Colors.lightBlue)),
          ),
        ]
    ),
    ));

    return logins;
  }

  List<Widget> getGameTypes() {
    List<Widget> gameTypes = [];

    gameTypes.add(SizedBox(height: 50.0));
    gameTypes.add(TextButton(
      style: TextButton.styleFrom(
        textStyle: TextStyle(fontSize: 20.0 * getSizeRatioWithLimit()),
        side: BorderSide(
          color: Colors.blue, // The border color
          width: 2,          // The border width
        ),
        // You can also add rounded corners
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () {
        setState(() {
          currentGameId = int.parse(widget.gameid!);
          inputGameState = InputGameState.answerSheet;
        });
      },
      child: Text("汉字树象形输入法热身赛\n\nHanzishu Pictographic Input Method Games",
          style: TextStyle(color: Colors.lightBlue)),
    ));

    gameTypes.add(SizedBox(height: 50.0));

    if (widget.gameid2 != null) {
      if (int.parse(widget.gameid2!) > 0) {
        gameTypes.add(Center(child: TextButton(
          style: TextButton.styleFrom(
            textStyle: TextStyle(fontSize: 20.0 * getSizeRatioWithLimit()),
            side: BorderSide(
              color: Colors.blue, // The border color
              width: 2,          // The border width
            ),
            // You can also add rounded corners
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () {
            setState(() {
              currentGameId = int.parse(widget.gameid2!);
              inputGameState = InputGameState.answerSheet;
            });
          },
          child: Text("拼音输入法热身赛\n\nPinyin Input Method Warm Up Games",
              style: TextStyle(color: Colors.lightBlue),
        ))));
      }
    }

    return gameTypes;
  }

  List<Widget> getAnswerSheets() {
    List<Widget> launchAnswerSheets = [];

    launchAnswerSheets.add(SizedBox(height: 50 * getSizeRatioWithLimit()));

    launchAnswerSheets.add(Center(child: TextButton(
      style: TextButton.styleFrom(
        textStyle: TextStyle(fontSize: 20.0 * getSizeRatioWithLimit()),
        side: BorderSide(
          color: Colors.blue, // The border color
          width: 2,          // The border width
        ),
        // You can also add rounded corners
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () {
        launchAnswerSheetWindow(currentGameId!);
        setState(() {
          inputGameState = InputGameState.game;
        });
      },
      child: Text("1. 先读下面内容，然后点击这里。First read content below, then click this button",
          style: TextStyle(color: Colors.lightBlue, fontSize: 20.0 * getSizeRatioWithLimit())),
    )));

    launchAnswerSheets.add(SizedBox(height: 10.0));
    launchAnswerSheets.add(Text("2. 然后，在打开的比赛答卷中填写你个人的信息部分。Then, at the opened answer sheet for the game, fill out the part about yourself.",   style: TextStyle(color: Colors.lightBlue,
      fontSize: 20.0 * getSizeRatioWithLimit(), // Set the font size in logical pixels
      //fontWeight: FontWeight.bold, // Optional: also set font weight
    ),));
    launchAnswerSheets.add(SizedBox(height: 10.0));
    launchAnswerSheets.add(Text("3. 最后，回到这里。",   style: TextStyle(color: Colors.lightBlue,
    fontSize: 20.0 * getSizeRatioWithLimit()), // Set the font size in logical pixels
      //fontWeight: FontWeight.bold, // Optional: also set font weight
    ),);

    return launchAnswerSheets;
  }

  List<Widget> getGame() {
    List<Widget> games = [];
    games.add(SizedBox(height: 50 * getSizeRatioWithLimit()));

    games.add(Center(child: Text("1. Make sure you are at right input mode.", style: TextStyle(color: Colors.lightBlue, fontSize: 20.0 * getSizeRatioWithLimit()))));
    games.add(SizedBox(height: 10));
    games.add(Center(child: TextButton(
      style: TextButton.styleFrom(
        textStyle: TextStyle(fontSize: 20.0 * getSizeRatioWithLimit()),
        side: BorderSide(
          color: Colors.blue, // The border color
          width: 2,          // The border width
        ),
        // You can also add rounded corners
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () {
        launchInputGame(currentGameId!);
      },
      child: Text("2. 开始比赛 Start the Game",
          style: TextStyle(color: Colors.lightBlue, fontSize: 20.0 * getSizeRatioWithLimit(),)),
    )));

    return games;
  }

  showInvalidInputDialog() {
    // set up the button
    Widget okButton = TextButton(
      child: Text(getString(286)/*Ok*/, style: TextStyle(color: Colors.blue)),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(getString(375)/*Result*/),
      content: Text(
          getString(374)/*cannot find: */ + inputText + "."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  launchInputGame(int gameid) {
    InputMethod inputMethod = InputMethod.Pinxin;
    int inputGameType = InputGameManager.getInputGameById(gameid).gameType;
    if (inputGameType == 2) { // 1 == Pinxin
      inputMethod = InputMethod.Others;
    }

    if (inputText != null && inputText.length > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              InputZiPage(typingType: TypingType.InputGame, lessonId: currentGameId!, wordsStudy: '', isSoundPrompt: false, inputMethod: inputMethod, showHint: HintType.Hint1, includeSkipSection: false, showSwitchMethod: false), //InputZiPage(),
        ),
      );
    }
    else {
      showInvalidInputDialog();
    }
  }

  processInputs() {
    var ziId = -1;
    inputText = _controller.value.text;

    if (InputGameManager.isInputGamePasscodeValid(inputText)) {
      setState(() {
        inputGameState = InputGameState.gameType;
      });
    }
    else {
      //if (inputText.length == 0) {
      showInvalidInputDialog();
    }
  }

  launchAnswerSheetWindow(int gameId) {
    int gameType = InputGameManager
        .getInputGameById(gameId)
        .gameType;

    launchUrl(Uri.parse(theInputGameAnswerSheetList[gameType].url), mode: LaunchMode.externalApplication/*, webOnlyWindowName: '_self'*/);
  }

  Future<bool>_onWillPop() {
    return Future.value(true);
  }
}
