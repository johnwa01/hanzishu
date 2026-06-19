import 'package:flutter/material.dart';
import 'package:hanzishu/data/searchingzilist.dart';
import 'package:hanzishu/ui/practicesheetcorepage.dart';
import 'dart:ui';
import 'dart:async';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';
import 'package:hanzishu/engine/zimanager.dart';

class PracticeSheetPage extends StatefulWidget {
  Map<int, PositionAndSize> sidePositionsCache = Map();
  Map<int, List<int>>realGroupMembersCache = Map();
  late PositionAndSize centerPositionAndSizeCache;
  String initZis = '';

  PracticeSheetPage({required this.initZis});

  @override
  _PracticeSheetPageState createState() => _PracticeSheetPageState();
}

class _PracticeSheetPageState extends State<PracticeSheetPage> with SingleTickerProviderStateMixin {
  int searchingZiIndex = -1;
  late bool shouldDrawCenter;
  late double screenWidth;
  late String initZis;


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

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }

  @override
  void initState() {
    super.initState();

    theCurrentCenterZiId = searchingZiIndex;

    setState(() {
      gridShowZi = true;
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
    screenWidth = Utility.getScreenWidthForTreeAndDict(context);
    thePositionManager.setFrameWidth(screenWidth - 10.0);
    initZis = widget.initZis;
    //if (initZis == null) {
    //  initZis = "合体字练习部件非笔画";
    //}
    _controller = new TextEditingController(text: initZis);

    /*"Grid shows Hanzi"*/
    var gridShowOrNotShowZiString = gridShowZi ? getString(452) : getString(453);/*"Grid (not) show Hanzi"*/;
    String displ = "";
    if (theDefaultLocale == "en_US") {
      displ = getString(408); // copy/paste ...
    }
    try {
      return Scaffold
        (
        appBar: AppBar
          (
          title: Text(getString(449)/*"Hanzi practice sheet"*/),
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: WillPopScope(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  18.0 * getSizeRatioWithLimit(),
                  34.0 * getSizeRatioWithLimit(),
                  18.0 * getSizeRatioWithLimit(),
                  28.0 * getSizeRatioWithLimit(),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680.0),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(28.0, 28.0, 28.0, 30.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 18.0,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 52.0,
                              height: 52.0,
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              child: Icon(
                                Icons.edit_note,
                                color: Colors.orange.shade600,
                                size: 34.0,
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Text(
                                displ,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.blueGrey.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 16.0),
                              ),
                              onPressed: () {
                                setState(() {
                                  gridShowZi = gridShowZi ? false : true;
                                });
                              },
                              child: Text(
                                gridShowOrNotShowZiString,
                                style: const TextStyle(color: Colors.blueAccent),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                autocorrect: false,
                                enableSuggestions: false,
                                controller: _controller,
                                focusNode: _textNode,
                                autofocus: false,
                                style: const TextStyle(
                                  fontSize: 22.0,
                                  height: 1.2,
                                ),
                                maxLines: 3,
                                minLines: 1,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: getString(408),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 18.0,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    borderSide: BorderSide(
                                      color: Colors.blueAccent.withOpacity(0.16),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    borderSide: const BorderSide(
                                      color: Colors.blueAccent,
                                      width: 1.4,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 18.0),
                            SizedBox(
                              width: 140.0,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28.0),
                                  ),
                                ),
                                onPressed: () {
                                  processInputs();
                                },
                                child: Text(
                                  getString(301) + " ->",
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              onWillPop: _onWillPop,
            ),
          ),
        ),      );
    } catch (e, s) {
      print(s);
    }

    // should not reach here
    return SizedBox(width: 0.0, height: 0.0);
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
              PracticeSheetCorePage(flashcardList: inputText, gridShowZi: gridShowZi),
        ),
      );
    }
    else {
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
