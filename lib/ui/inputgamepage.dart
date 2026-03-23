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
  //late int? currentGameType; // 1: pictographic, 2: Pinyin input
  late ScrollController _scrollController;
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

    _scrollController = ScrollController()
      ..addListener(() {
        //print("offset = ${_scrollController.offset}");
      });

    currentGameId = int.parse(widget.gameid!);

    theCurrentCenterZiId = searchingZiIndex;

    setState(() {
      gridShowZi = true;
      inputGameState = InputGameState.login;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // it is a good practice to dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidthForTreeAndDict(context);
    thePositionManager.setFrameWidth(screenWidth - 10.0);
    _controller = new TextEditingController(text: ""/*initZis*/);

    /*"Grid shows Hanzi"*/
    var gridShowOrNotShowZiString = gridShowZi ? getString(452) : getString(453);/*"Grid (not) show Hanzi"*/;
    //String displ = "请输入参赛码：Please enter participation code:";

    try {
      return Scaffold
        (
        appBar: AppBar
          (
          title: Text(getString(551)),
        ),
        body: Container(
          child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.vertical,
            child: WillPopScope(
                child: new Column( //Stack(
                    children: //<Widget>[
                      getUIByInputGameState(),
                ),
                onWillPop: _onWillPop
            )
          ),
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
      //case InputGameState.inputGameHelper:
        //return getInputGameHelper();
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

    logins.add(Text(getString(558),
        style: TextStyle(color: Colors.lightBlue, fontSize: 20 * getSizeRatioWithLimit())),);
    logins.add(SizedBox(height: 30 * getSizeRatioWithLimit()));
    logins.add(Row(
        children: <Widget>[
          SizedBox(width: 50 * getSizeRatioWithLimit()),
          Text(getString(539),
            style: TextStyle(color: Colors.lightBlue, fontSize: 20.0* getSizeRatioWithLimit())),
        ]
    ));

    logins.add(SizedBox(width: 10 * getSizeRatioWithLimit()));
    logins.add(/*Center(child: */Row(
        children: <Widget>[
          SizedBox(width: 50 * getSizeRatioWithLimit()),
          SizedBox(
            width: 200 * getSizeRatioWithLimit(), //double.infinity,
            //height: 120,
            child: TextField(
              autocorrect: false,
              enableSuggestions: false,
              //controller: _controller,
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
              onSubmitted: (text) {
                processInputs(text);
              },
            ),//focusNode: _textNode,
          ),
          SizedBox(width: 10 * getSizeRatioWithLimit()),
          //TextButton(
          //  style: TextButton.styleFrom(
          //    textStyle: TextStyle(fontSize: 20.0 * getSizeRatioWithLimit()),
          //  ),

            //onPressed: () {
            //  processInputs();
            //},
          //  child: Text("进入 Start login",
          //    style: TextStyle(color: Colors.lightBlue)),
          //),
        ]
    //),
    ));

    return logins;
  }

  List<Widget> getGameTypes() {
    List<Widget> gameTypes = [];

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
          child: Text(getString(555),
              style: TextStyle(color: Colors.lightBlue),
        ))));
      }
    }

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
      child: Text(getString(556),
          style: TextStyle(color: Colors.lightBlue)),
    ));

    return gameTypes;
  }

  List<Widget> getInputGameHelper() {
    List<Widget> inputGameHelper = [];
    inputGameHelper.add(SizedBox(height: 50 * getSizeRatioWithLimit()));

    inputGameHelper.add(Image.asset('assets/core/inputgamehelper.jpg',
      width: 300.0 * getSizeRatioWithLimit(),
      height: 250.0 * getSizeRatioWithLimit(),
      fit: BoxFit.fitWidth,));

    inputGameHelper.add(Text("注意： 你可以点击图示区域在‘打字’网页和‘答卷’网页之间变换。Note：You can hit marked areas to switch between 'Typing web page' and 'Answer sheet web page'.",
        style: TextStyle(color: Colors.lightBlue, fontSize: 20.0 * getSizeRatioWithLimit())));

    inputGameHelper.add(SizedBox(height: 10.0));
    inputGameHelper.add(Center(child: TextButton(
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
          inputGameState = InputGameState.answerSheet;
        });
      },
      child: Text("好的，我明白。 Ok, I understand.",
          style: TextStyle(color: Colors.lightBlue, fontSize: 20.0 * getSizeRatioWithLimit())),
    )));

    return inputGameHelper;
  }

  List<Widget> getAnswerSheets() {
    List<Widget> launchAnswerSheets = [];

    launchAnswerSheets.add(SizedBox(height: 30 * getSizeRatioWithLimit()));
    launchAnswerSheets.add(Text(getString(540),   style: TextStyle(color: Colors.lightBlue,
      fontSize: 17.0 * getSizeRatioWithLimit(), // Set the font size in logical pixels
    ),));
    launchAnswerSheets.add(SizedBox(height: 20 * getSizeRatioWithLimit()));
    launchAnswerSheets.add(Image.asset('assets/core/inputgamehelper.jpg',
      width: 300.0 * getSizeRatioWithLimit(),
      height: 250.0 * getSizeRatioWithLimit(),
      fit: BoxFit.fitHeight,));
    launchAnswerSheets.add(SizedBox(height: 10.0));

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
      child: Text(getString(542),
          style: TextStyle(color: Colors.lightBlue, fontSize: 20.0 * getSizeRatioWithLimit())),
    )));

    return launchAnswerSheets;
  }

  List<Widget> getGame() {
    List<Widget> games = [];

    //var inputTypeEng;
    //var inputTypeChi;
    var inputTypeStr;
    if (InputGameManager.getInputGameById(currentGameId!).gameType == 1) {
      //inputTypeEng = "English";
      //inputTypeChi = "英文";
      inputTypeStr = getString(553);
    }
    else { // 2
      //inputTypeEng = "Pinyin";
      //inputTypeChi = "拼音";
      inputTypeStr = getString(554);
    }

    games.add(SizedBox(height: 50 * getSizeRatioWithLimit()));
    games.add(Center(child: Text(getString(543) + inputTypeStr + ".", style: TextStyle(color: Colors.lightBlue, fontSize: 20.0 * getSizeRatioWithLimit()))));
    games.add(SizedBox(height: 10));
    var answerSheetUrl = InputGameManager.getInputGameById(currentGameId!).answerSheetUrl;
    games.add(Text(getString(541), style: TextStyle(fontSize: 17)));
    games.add(SelectableText(answerSheetUrl, style: TextStyle(fontSize: 17)));
    games.add(SizedBox(height: 10.0));
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
      child: Text(getString(544),
          style: TextStyle(color: Colors.lightBlue, fontSize: 20.0 * getSizeRatioWithLimit(),)),
    )));

    return games;
  }

  showInvalidInputDialog(String text) {
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
          getString(374)/*cannot find: */ + text + "."),
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
      showInvalidInputDialog(gameid.toString());
    }
  }

  processInputs(String text) {
    var ziId = -1;
    //inputText = _controller.value.text;
    inputText = text;

    if (InputGameManager.isInputGamePasscodeValid(inputText)) {
      setState(() {
        inputGameState = InputGameState.gameType;
      });
    }
    else {
      //if (inputText.length == 0) {
      showInvalidInputDialog(inputText);
    }
  }

  launchAnswerSheetWindow(int gameId) {
    var answerSheetUrl = InputGameManager
        .getInputGameById(gameId)
        .answerSheetUrl;

    launchUrl(Uri.parse(answerSheetUrl), mode: LaunchMode.externalApplication/*, webOnlyWindowName: '_self'*/);
  }

  Future<bool>_onWillPop() {
    return Future.value(true);
  }
}
