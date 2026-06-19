import 'package:flutter/material.dart';
import 'package:hanzishu/data/searchingzilist.dart';
import 'dart:ui';
import 'dart:async';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/engine/texttospeech.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';
import 'package:hanzishu/engine/dictionary.dart';
import 'package:hanzishu/ui/dictionarypainter.dart';
import 'package:hanzishu/ui/dictionaryhelppage.dart';
import 'package:hanzishu/ui/dictionarysearchingpage.dart';
import 'package:hanzishu/data/firstzilist.dart';
import 'package:hanzishu/engine/zimanager.dart';

class FlashcardPage extends StatefulWidget {
  Map<int, PositionAndSize> sidePositionsCache = Map();
  Map<int, List<int>>realGroupMembersCache = Map();
  PositionAndSize? centerPositionAndSizeCache;

  @override
  _FlashcardPageState createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> with SingleTickerProviderStateMixin {
  int searchingZiIndex = -1;
  bool shouldDrawCenter = false;
  double screenWidth = 0.0;
  //DictionaryStage dicStage;
  //OverlayEntry overlayEntry;
  // PositionAndMeaning previousPositionAndMeaning = PositionAndMeaning(
  //     0.0, 0.0, "");
  FocusNode _textNode = new FocusNode();

  TextEditingController _controller = new TextEditingController(text: "您份成");

  int compoundZiComponentNum = 0;
  List<int> compoundZiAllComponents = [];
  Timer? compoundZiAnimationTimer;
  int compoundZiCurrentComponentId = -1;
  var currentZiListType = ZiListType.searching;

  String inputText = '';
  int currentIndex = 0;

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }

  @override
  void initState() {
    super.initState();

    theCurrentCenterZiId = searchingZiIndex;
    //_controller.addListener(handleKeyInput);
    theAllZiLearned = false;

    setState(() {
      searchingZiIndex = searchingZiIndex;
      shouldDrawCenter = true;
      compoundZiComponentNum = 0;

      searchingZiIndex = 0;
      //dicStage = DictionaryStage.firstzis;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getRequests() async {
    this.currentIndex += 1;

    if (!theIsBackArrowExit && this.currentIndex <= inputText.length) {
      // reinit
      theIsBackArrowExit = true;
      launchZi(this.currentIndex);
    }
    else {
      // init all variables
      // either true back arrow or all done
      theIsBackArrowExit = true;
      //theIsFromTypingContinuedSection = false;
      this.currentIndex = 0;
    }
    //}
  }

  @override
  Widget build(BuildContext context) {
    compoundZiCurrentComponentId = searchingZiIndex;
    int compoundZiTotalComponentNum = 0;

    // TODO: components don't seem relative here
    // compound zi is animating.
    if (compoundZiComponentNum > 0) {
      List<String> componentCodes = <String>[];
      if (compoundZiAllComponents == null || compoundZiAllComponents.length == 0) {
        DictionaryManager.getAllComponents(searchingZiIndex, componentCodes);
        DictionaryManager.getComponentIdsFromCodes(
            componentCodes, compoundZiAllComponents);
      }
      //var compList = getAllZiComponents(searchingZiIndex);
      compoundZiTotalComponentNum = compoundZiAllComponents.length;

      if (compoundZiComponentNum == compoundZiTotalComponentNum + 1) {
        // after looping through the compoundZiAllComponents.
        compoundZiCurrentComponentId = searchingZiIndex;
        currentZiListType = ZiListType.searching;
        shouldDrawCenter = true;
      }
      else {
        compoundZiCurrentComponentId = compoundZiAllComponents[compoundZiComponentNum - 1];
        currentZiListType = ZiListType.component;
      }
    }

    screenWidth = Utility.getScreenWidthForTreeAndDict(context);
    thePositionManager.setFrameWidth(screenWidth - 10.0);

    try {
      return Scaffold(
        appBar: AppBar(
          title: Text(getString(406)/*"Customized flashcards"*/),
        ),
        body: WillPopScope(
          onWillPop: _onWillPop,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720.0),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.0 * getSizeRatioWithLimit(),
                      vertical: 28.0 * getSizeRatioWithLimit(),
                    ),
                    child: Card(
                      elevation: 4.0,
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(24.0 * getSizeRatioWithLimit()),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Center(child: _buildFlashcardIcon()),
                            SizedBox(height: 18.0 * getSizeRatioWithLimit()),
                            Text(
                              getString(406)/*"Customized flashcards"*/,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24.0 * getSizeRatioWithLimit(),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8.0 * getSizeRatioWithLimit()),
                            Text(
                              "Paste Chinese text to instantly create flashcards.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.0 * getSizeRatioWithLimit(),
                                color: Colors.blueGrey,
                                height: 1.35,
                              ),
                            ),
                            SizedBox(height: 28.0 * getSizeRatioWithLimit()),
                            Text(
                              getString(408)/*"Type or copy/paste all your words below"*/,
                              style: TextStyle(
                                fontSize: 16.0 * getSizeRatioWithLimit(),
                                color: Colors.blueGrey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10.0 * getSizeRatioWithLimit()),
                            TextField(
                              autocorrect: false,
                              enableSuggestions: false,
                              controller: _controller,
                              focusNode: _textNode,
                              autofocus: false,
                              style: TextStyle(
                                fontSize: 20.0 * getSizeRatioWithLimit(),
                                height: 1.35,
                              ),
                              minLines: 4,
                              maxLines: 6,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                hintText: "你好，我是学生。",
                                filled: true,
                                fillColor: Colors.blueGrey.withOpacity(0.06),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0 * getSizeRatioWithLimit(),
                                  vertical: 14.0 * getSizeRatioWithLimit(),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  borderSide: BorderSide(
                                    color: Colors.lightBlue,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 12.0 * getSizeRatioWithLimit()),
                            InkWell(
                              borderRadius: BorderRadius.circular(12.0),
                              onTap: () {
                                setState(() {
                                  _controller.text = "你好，我是学生。";
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4.0 * getSizeRatioWithLimit(),
                                  vertical: 8.0 * getSizeRatioWithLimit(),
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 14.0 * getSizeRatioWithLimit(),
                                      color: Colors.blueGrey,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "Example: ",
                                        style: TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                      TextSpan(
                                        text: "你好，我是学生。",
                                        style: TextStyle(color: Colors.lightBlue[700]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 24.0 * getSizeRatioWithLimit()),
                            SizedBox(
                              height: 48.0 * getSizeRatioWithLimit(),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightBlue,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  textStyle: TextStyle(
                                    fontSize: 17.0 * getSizeRatioWithLimit(),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () {
                                  processInputs();
                                },
                                child: Text("Generate Cards ->"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } catch (e, s) {
      print(s);
    }

    //should not reach here
    return SizedBox(width: 0.0, height: 0.0);
  }


  Widget _buildFlashcardIcon() {
    final double ratio = getSizeRatioWithLimit();
    return SizedBox(
      width: 112.0 * ratio,
      height: 86.0 * ratio,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            left: 8.0 * ratio,
            top: 16.0 * ratio,
            child: _buildSmallCard("字", Colors.orangeAccent.withOpacity(0.25)),
          ),
          Positioned(
            right: 8.0 * ratio,
            top: 8.0 * ratio,
            child: _buildSmallCard("词", Colors.lightBlueAccent.withOpacity(0.25)),
          ),
          Positioned(
            top: 22.0 * ratio,
            child: _buildSmallCard("学", Colors.lightGreenAccent.withOpacity(0.28)),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallCard(String text, Color color) {
    final double ratio = getSizeRatioWithLimit();
    return Container(
      width: 58.0 * ratio,
      height: 58.0 * ratio,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: Colors.white, width: 2.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
            offset: Offset(0.0, 3.0),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 26.0 * ratio,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey[800],
          ),
        ),
      ),
    );
  }

  processInputs() {
    //var latestValue;
    var ziId = -1;
    if (_controller.value.text != null && _controller.value.text.length != 0) {
      inputText = _controller.value.text;
      var resultStr = DictionaryManager.validateChars(inputText);
      if (resultStr.length == 0) {
        showInvalidInputDialog();
      }
      else {
        if (resultStr.length != inputText.length) {
          inputText = resultStr;
        }

        launchZi(0);
      }
    }
    else {
      // assert
    }
  }

  launchZi(int index) {
    //var ziId = DictionaryManager.getSearchingZiId("灵"/*inputText[index]*/);
    //inputText = "灵巧的"; //TODO
    if (inputText != null && inputText.length > 0) {
      //_controller.clear();
      //FocusScope.of(context).unfocus();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DictionarySearchingPage(
                  dicStage: DictionaryStage.detailedzi,
                  firstOrSearchingZiIndex: -1,
                  flashcardList: inputText,
                  dicCaller: DicCaller.Flashcard),
        ),
      );
    }
    else {
      //_controller.clear();
      //FocusScope.of(context).unfocus();
      showInvalidInputDialog();
    }
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

  Future<bool>_onWillPop() {
    return Future.value(true);
  }

}
