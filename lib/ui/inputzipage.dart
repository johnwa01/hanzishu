import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/engine/inputzimanager.dart';
import 'package:hanzishu/engine/componentmanager.dart';
import 'package:hanzishu/ui/inputzipainter.dart';
import 'package:hanzishu/ui/inputzihintpainter.dart';
import 'package:hanzishu/ui/inputzihelppage.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/data/componenttypinglist.dart';

import 'dart:core';

class InputZiPage extends StatefulWidget {
  final TypingType typingType;
  final int lessonId;
  InputZiPage({this.typingType, this.lessonId});
  @override
  _InputZiPageState createState() => new _InputZiPageState();
}

class _InputZiPageState extends State<InputZiPage> {
  TypingType typingType;
  int lessonId;
  int currentIndex;
  BuildContext currentBuildContext;
  double _progressValue;
  int totalQuestions;
  double screenWidth;
  TextEditingController _controller = new TextEditingController();
  FocusNode _textNode = new FocusNode();
  int previousStartComposing = -1;
  int previousEndComposing = -1;
  int previousEndSelection = -1;
  String initialControllerTextValue = "unlikelyIniStr876";
  bool itsTheFirstTime = true;
  String previousText = "";
  bool justCompletedPosting = false;
  bool justCompletedFullCompDisplay = false;
  //bool hasRunLowercase = false;
  String previousValueWithLowercase = "";
  List<String> ziCandidates = null;
  bool showHint = false;
  //String previousOverlayImagePath = "";

  OverlayEntry overlayEntry;
  //TypingType previousOverlayType = TypingType.FreeTyping;
  //int previousOverlayIndex = 0;
  var previousOverlayParameters = InputZiOverlayParameters(TypingType.FreeTyping, 0, false, '', false);
  int dismissCount = 0;

  int updateCounter = 0;


  @override
  initState() {
    super.initState();

    _controller.addListener(handleKeyInput);
    _progressValue = 0.0;
    totalQuestions = theInputZiManager.getTotal(widget.typingType, widget.lessonId);

    setState(() {
      updateCounter =0;
      currentIndex = 0;
      showHint = false;
    });
  }

  // make sure overlay will be removed when moving back to the parent page.
  Future<bool>_onWillPop() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }

    return Future.value(true);
  }

  initOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  // consider the case that the input letter might be in the middle of the input
  String getLatestInputLetter() {
    var newInputText = "";

    if (_controller.value.text != null && _controller.value.text.length != 0) {
      if (_controller.value.selection.start != -1) {
        newInputText += _controller.value.text.substring(0, _controller.value.selection.start);
      }
      else if (_controller.value.composing.end != -1) {
        //Note: composing start/end includes the one letter just typed if no composing letters shown in the screen,
        // but includes it if no letters shown in screen, this inconsistency is hard to manage in code.
        // Found the selection.start is more reliable for this purpose. should check other usage as well.
        newInputText += _controller.value.text.substring(0, _controller.value.composing.end);
      }
      else if (previousEndComposing != -1) {  // in case the current _controller doesn't contain composing info
        //TODO: verify adding 1 here. Since it was an old value not updated in current input?
        newInputText += _controller.value.text.substring(0, previousEndComposing + 1);
      }

      else {
        newInputText = _controller.value.text;
      }
    }

    if (newInputText.length > 0) {
      return newInputText[newInputText.length - 1];
    }
    else {
      return '';
    }
  }

  String getInputTextBeforeComposingAndSelectionStart() {
    var newInputText = "";

    if (_controller.value.text != null && _controller.value.text.length != 0) {
      if (_controller.value.composing.start != -1) {
        newInputText += _controller.value.text.substring(0, _controller.value.composing.start);
      }
      else if (previousStartComposing != -1) {  // in case the current _controller doesn't contain composing info
        newInputText += _controller.value.text.substring(0, previousStartComposing);
      }
      // for this purpose, should use composing since selection.start might be same value as selection.end.
      // There are cases that both composing are unavailable
      else if (_controller.value.selection.start != -1) {
        newInputText += _controller.value.text.substring(0, _controller.value.selection.start);
      }
      else {
        newInputText = _controller.value.text;
      }
    }

    return newInputText;
  }

  String getInputTextAfterComposingAndSelectionEnd() {
    var newInputText = "";

    if (_controller.value.selection.end != -1 &&
    (_controller.value.selection.end + 1) <= _controller.value.text.length) {
      newInputText = _controller.value.text.substring(
      _controller.value.selection.end, _controller.value.text.length);
    }
    else if (_controller.value.composing.end != -1 &&
        _controller.value.composing.end + 1 < _controller.value.text.length) {
      // Note: The composing.end varies when there are composing letters shown in screen or not.
      // Use selection.end to be reliable. use composing as fallback just in case.
      newInputText = _controller.value.text.substring(
          _controller.value.composing.end + 1, _controller.value.text.length);
    }
    else if (previousEndComposing != -1 &&
        (previousEndComposing + 1) <= _controller.value.text.length) {
      newInputText = _controller.value.text.substring(
          previousEndComposing + 1, _controller.value.text.length);
    }



    return newInputText;
  }

  String getInputText(int index) {
    var newInputText = "";

    newInputText = getInputTextBeforeComposingAndSelectionStart();

    var length = newInputText.length;
    // check if last letter is a choice number, in this case, not a real input and need to be removed
    if (length > 0 && (isNumberOneToSeven(newInputText[length - 1]) || newInputText[length - 1] == " " || Utility.isAUpperCaseLetter(newInputText[length - 1]))) {
      newInputText = newInputText.substring(0, length - 1);
    }

    var candidateZiString = InputZiManager.getCandidateZiString(index);
    if (candidateZiString != null) {
      newInputText += candidateZiString;
    }

    newInputText += getInputTextAfterComposingAndSelectionEnd();

    return newInputText;
  }


  String getInputTextWithoutUpperCaseLetter(String upperCaseLetter) {
    var inputTextWithoutUpperCaseLetter = "";

    var str = _controller.value.text;
    var index = str.indexOf(upperCaseLetter);

    if (index == -1) {
      inputTextWithoutUpperCaseLetter = str;
    }
    else {
      inputTextWithoutUpperCaseLetter = str.substring(0, index);

      if (index < str.length) {
        inputTextWithoutUpperCaseLetter += str.substring(index + 1, str.length);
      }
    }

    return inputTextWithoutUpperCaseLetter;
  }

  showOverlay(BuildContext context, InputZiOverlayParameters overlayParameters/*TypingType type, int index, bool isFullComponents, String fullComponentsLetter*/) {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }

    if (!overlayParameters.isEqual(previousOverlayParameters)) {
        var imageName;
        var fullPath;
        double imageLeft = 150.0;
        double imageWidth = 100.0;
        double imageHeight = 135.0;

        if (overlayParameters.isFullComponents) {
            if (overlayParameters.fullComponentsLetter == 'Z') {
              imageName = theZiForIntroductionList[0].hintImage;
              imageLeft = 20.0;
              imageWidth = 350.0;
              imageHeight = 150.0;
            }
            else {
              var pair = ComponentManager.getGroupAndIndexFromLetter(
                  overlayParameters.fullComponentsLetter);
              var fullExpandedComponent = theComponentManager.getFullExpandedComponentByGroupAndIndex(pair.groupNumber, pair.indexInGroup);
              imageName = fullExpandedComponent.imageName;
            }
            fullPath = "assets/typing/" + imageName;
        }

        OverlayState overlayState = Overlay.of(context);
        overlayEntry = OverlayEntry(
            builder: (context) =>
                Positioned(
                  top: 50,//65, //65.0, //85.0, //posiY,
                  left: imageLeft, //100, //0.0, //posiX,
                  child: Image.asset(
                    fullPath,
                    width: imageWidth, //350.0,
                    height: imageHeight,
                    fit: BoxFit.fitWidth,
                  ),
                ));
        overlayState.insert(overlayEntry);
        previousOverlayParameters.assign(overlayParameters);
        dismissCount = 0;
      }
      else {
        dismissCount += 1;
        if (dismissCount >= 2) { // work around to the two messages for one key input issue
          previousOverlayParameters.justDismissed = true;
        }
      }
  }

  String getFullComposingText(String inputKeyLetter) {
    var startComposing = _controller.value.composing.start;
    var endComposing = _controller.value.composing.end;

    var str = "";
    if (endComposing > startComposing) {
      str = _controller.value.text.substring(startComposing, endComposing);
    }

    return str;
  }

  bool isNumberOneToSeven(String value) {
    if(value.length > 0) {
      var charCodeUnits = value[0].codeUnits;

      if (charCodeUnits.length == 1 && charCodeUnits[0] >= 49 && charCodeUnits[0] <= 55 ) {  // value is between 1 and 7
        return true;
      }
    }

    return false;
  }

  int getZeroBasedNumber(String value) {
    if(value.length > 0) {
      var charCodeUnits = value[0].codeUnits;

      if (charCodeUnits.length == 1 && charCodeUnits[0] >= 49 && charCodeUnits[0] <= 55 ) {  // value is between a and z
        return charCodeUnits[0] - 49;
      }
    }

    return -1;
  }

  int getCursorPosition(bool isFromCharList) {
    var selectionPosi;
    if (_controller.value.selection.end != -1) {
      selectionPosi = _controller.value.selection.end;
      if (_controller.value.composing.end != -1) {
        selectionPosi -= (_controller.value.composing.end - _controller.value.composing.start);
      }
      if (isFromCharList) {
        selectionPosi++;
      }
    }
    else if (previousEndSelection != -1) {
      selectionPosi = previousEndSelection;
      if (previousEndComposing != -1) {
        selectionPosi -= (previousEndComposing - previousStartComposing);
      }
      if (isFromCharList) {
        selectionPosi++;
      }
    }
    else {
      selectionPosi = _controller.value.text.length;
    }

    if (selectionPosi < 0 || selectionPosi > _controller.value.text.length) {
      selectionPosi = _controller.value.text.length;
    }

    return selectionPosi;
  }

  void setTextByChosenZiIndex(int selectionIndex, bool isFromCharList) {
    var newText = getInputText(selectionIndex);

    previousText = newText;
        justCompletedPosting = true;
        //hasRunLowercase = false; // init lowercase as well

    // reset the candidate. might set to global ini value
    theCurrentZiCandidates = theDefaultZiCandidates;

    previousEndSelection = _controller.value.selection.end;

    _controller.clearComposing();

    //now reset controller which will notify the listeners right away
    _controller.text = newText;

    //_controller.text += st; //'好';
    //Note: set cursor to the right position of the current editing specifically
    // otherwise it'll set at the beginning

    var selectionPosi = getCursorPosition(isFromCharList);
    var textPosition = TextPosition(offset: selectionPosi);
    _controller.selection = TextSelection.fromPosition(textPosition);

    previousStartComposing = -1;
    previousEndComposing = -1;

    showHint = false;

    //restart a typing cycle
    InputZiManager.previousFirstPositionList.clear();
  }

  void handleKeyInput() {
    handleKeyInputHelper(0);
  }

  void handleKeyInputHelper(int selectionIndex) {
    // Note: For each event, the system might send message multiple times.
    // This logic filters out the extra top level calls to this function, as well as the
    // calls triggered by code below but before the controller text is changed.
    // After controller text is changed, the dup-avoid logic is managed by separate code later.
    if (_controller.text == initialControllerTextValue) {
      return;
    }
    else if (itsTheFirstTime) {
      initialControllerTextValue = _controller.text;
      itsTheFirstTime = false;
    }

    if (currentIndex < 0) {
      return;
    }

    //TODO: temp testing for comp shapes
    globalTestDoubleByteCode = _controller.text;

    // for guarded typing
    if (typingType != TypingType.FreeTyping) {
      //var comp = theInputZiManager.getZiWithComponentsAndStrokes(currentIndex) ;
      if (theInputZiManager.doesTypingResultContainTheZi(typingType, currentIndex, _controller.text, lessonId)) {
        setState(() {
          if ((currentIndex + 1) == theInputZiManager.getTotal(typingType, lessonId)) {
              showCompletedDialog(currentBuildContext);
          }
          currentIndex = theInputZiManager.getNextIndex(typingType, currentIndex, lessonId);
        });

        return;
      }
    }

    print('Second text field: ${_controller.text}');
    String latestInputKeyLetter = "";

    // this is as early as the place to check this. ex: notified with controller text update but without real change.
    // use two conditions so that new typing can continue. if only use justCompletedPosting, all code would be blocked.
    if ((justCompletedPosting || justCompletedFullCompDisplay) && _controller.text == previousText) {
        return;
    }

    latestInputKeyLetter = getLatestInputLetter();

    if (latestInputKeyLetter == " " /*32*/) { // space key
      if (_controller.text != previousText) {
        initOverlay();
      }
      //hasRunLowercase = false;
      setTextByChosenZiIndex(selectionIndex, false);
    }
    //Note: Temp disable UpperCase and LowerCase if want to test component shapes
    else if (Utility.isAUpperCaseLetter(latestInputKeyLetter)) { // space key
      var overlayParameters = InputZiOverlayParameters(typingType, currentIndex, true, latestInputKeyLetter, false);
      showOverlay(context, overlayParameters);

      justCompletedFullCompDisplay = true;
      //hasRunLowercase = false; // init lowercase
      previousEndSelection = _controller.selection.end;
      // prepare the previousText ahead of time so that the overlay won't be over written by dup runs
      previousText = getInputTextWithoutUpperCaseLetter(latestInputKeyLetter);
      // actually set the current value, although use previousText parameter
      _controller.text = previousText; //_controller.text.substring(0, _controller.text.length - 1);
      var selectionPosi = getCursorPosition(false);
      _controller.selection = TextSelection.fromPosition(TextPosition(offset: selectionPosi));
    }
    else if (isNumberOneToSeven(latestInputKeyLetter)) {
      if (_controller.text != previousText) {
        initOverlay();
      }
      //hasRunLowercase = false;
      setTextByChosenZiIndex(getZeroBasedNumber(latestInputKeyLetter), false);
    }
    else if (Utility.isALowerCaseLetter(latestInputKeyLetter)) {
      // reset the completed flag. reset only at this time.
      justCompletedPosting = false;
      justCompletedFullCompDisplay = false;

      if (_controller.text != previousText) {
        initOverlay();

        //if (hasRunLowercase) {
        //  return;
        //}

        if (_controller.text == previousValueWithLowercase) {
          return;
        }
        else {
          // prepare to skip callback. set before _controller change.
          //hasRunLowercase = true;
          previousValueWithLowercase = _controller.text;

          // manipulate composing since iPhone doesn't seem to set the composing value for some reason
          if (_controller.value.composing.start == -1) {
            int startPosi = 0;
            if (_controller.value.selection.start >= 1) {
              // selection seems starting with 1, while composing starts with 0.
              startPosi = _controller.value.selection.start - 1;
            }

            _controller.value = _controller.value.copyWith(
                composing: TextRange(
                    start: startPosi, end: startPosi + 1)); //TextRange.collapsed(1));
          }

          // note: with new lower case letter, the start position has to be different from the previous start.
          // Likely it just doesn't set. We are setting the end manually here.
          if (previousStartComposing == _controller.value.composing.start) {
            if (previousEndComposing == _controller.value.composing.end) {
              _controller.value = _controller.value.copyWith(
                  composing: TextRange(start: previousStartComposing,
                      end: previousEndComposing + 1));
            }
          }
        }
      }

      var composingText = getFullComposingText(latestInputKeyLetter);
      theCurrentZiCandidates = InputZiManager.getZiCandidates(composingText);
      InputZiManager.updateFirstCandidate(theCurrentZiCandidates, InputZiManager.previousFirstPositionList);

      if (theCurrentZiCandidates == null) {
        List<String> composingList =  [composingText];
        theCurrentZiCandidates = composingList;
      }

      previousStartComposing = _controller.value.composing.start;
      previousEndComposing = _controller.value.composing.end;

      // TODO: should I set here as well?
      //previousText = _controller.text;
      // prepare for next lowercase input
      //hasRunLowercase = false;

      // prepare for next input
      // only init when a lower case letter is set to make sure the value lasts long enough.
      initInitialControllerTextValue();
    }
  }

  initInitialControllerTextValue() {
    itsTheFirstTime = true;
    initialControllerTextValue = "";
  }

  setInitialControllerTextValue() {
    itsTheFirstTime = false;
    initialControllerTextValue = _controller.text;
  }

  Widget getIntroductionPage() {
    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Give it a try"),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: theConst.fontSizes[1]),
            Text(
                "The Hanzishu Component Input Method is fast and easy!",
                style: TextStyle(fontSize: theConst.fontSizes[1]),
                textAlign: TextAlign.start
            ),
            SizedBox(height: theConst.fontSizes[1]),
            Text(
                "Chinese Characters are broken up into Components and matched with a key on the English keyboard to create a Component-key pairing.",
                style: TextStyle(fontSize: theConst.fontSizes[1]),
                textAlign: TextAlign.start
            ),
            SizedBox(height: theConst.fontSizes[1]),
            Text(
                "Reference this chart to visualize how Lead Components are mapped to English letters.",
                style: TextStyle(fontSize: theConst.fontSizes[1]),
                textAlign: TextAlign.start
            ),
            Flexible(
              child: Image.asset(
                "assets/typing/" + theZiForIntroductionList[0].hintImage,
                width: 350.0,
                height: 150.0,
                fit: BoxFit.fitWidth
              ),
            ),
            SizedBox(height: theConst.fontSizes[1]),
            Text(
                "Example: Type the Chinese character 品",
                style: TextStyle(fontSize: theConst.fontSizes[1]),
                textAlign: TextAlign.start
            ),
            Text(
                "  •	Find the first Component 口",
                style: TextStyle(fontSize: theConst.fontSizes[1]),
                textAlign: TextAlign.start
            ),
            Text(
                "  •	Find the corresponding key i",
                style: TextStyle(fontSize: theConst.fontSizes[1]),
                textAlign: TextAlign.start
            ),
            Text(
                "  •	Tap it",
                style: TextStyle(fontSize: theConst.fontSizes[1]),
                textAlign: TextAlign.start
            ),
            Text(
                "  •	If 品 appears in the Character list (below the editing field), select it by:",
                style: TextStyle(fontSize: theConst.fontSizes[1]),
                textAlign: TextAlign.start
            ),
            Text(
                "    o	Tapping the Character",
                style: TextStyle(fontSize: theConst.fontSizes[1]),
                textAlign: TextAlign.start
            ),
            Text(
                "    o	 Tapping the spacebar if it’s first in the list",
                style: TextStyle(fontSize: theConst.fontSizes[1]),
                textAlign: TextAlign.start
            ),
            Text(
                "  •	If the Character is not listed, repeat the these steps with the second and third Components until you see 品 listed",
                style: TextStyle(fontSize: theConst.fontSizes[1]),
                textAlign: TextAlign.start
            ),
            Text(
                "  •	The English letters in the editing field automatically convert to 品.",
                style: TextStyle(fontSize: theConst.fontSizes[1]),
                textAlign: TextAlign.start
            ),
            SizedBox(
              child: Align(
                alignment: Alignment.topCenter,
                child: TextButton(
                         style: TextButton.styleFrom(textStyle: const TextStyle(fontSize: 15.0),
                          ),
                  onPressed: () {
                           setState(() {
                            currentIndex = 1;
                        });
                           },
                      child: const Text('Try a few',
                      style: TextStyle(color: Colors.blue)),
                    ),
                  ),
            ),
    ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    typingType = widget.typingType; //theComponentManager.getCurrentType();
    lessonId = widget.lessonId;
    if (currentIndex < 0) {
      return Container(width:0.0, height: 0.0);
    }

    //To be sure
    initOverlay();

    int maxNumberOfLines;
    if (typingType == TypingType.FreeTyping) {
      maxNumberOfLines = 3;
    }
    else {
      maxNumberOfLines = 1;
      _progressValue = currentIndex/totalQuestions;
    }

    currentBuildContext = context;

    //   typingType = widget.typingType; //theComponentManager.getCurrentType();
//    theInputZiManager.setCurrentType(typingType); //TODO: should pass as a parameter in painter?

    screenWidth = Utility.getScreenWidth(context);

    var inputZiPainter = InputZiPainter(
        lineColor: Colors.amber,
        completeColor: Colors.blueAccent,
        lessonId: lessonId, /*TODO: temp*/
        screenWidth: screenWidth //350 /*TODO: temp*/
    );

    var title = 'Hanzishu Component Input Method';
    if (typingType == TypingType.ForIntroduction) {
      title = 'Give it a try';
    }
    else if (typingType == TypingType.LeadComponents) {
      title = 'Guided typing';
    }
    else if (typingType == TypingType.ExpandedComponents) {
      title = 'Typing exercises';
    }

    if (typingType == TypingType.ForIntroduction && currentIndex == 0) {
      return getIntroductionPage();
    }

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(title),
        ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        //mainAxisSize:  MainAxisSize.max,
        children: <Widget>[
          //Spacer(),
          getHelpOrProgressIndicator(),
          getComponentRelated(),
          SizedBox(
              width: double.infinity,
              //height: 120,
              child: TextField(
                controller: _controller,
                focusNode: _textNode,
                autofocus: true,
                //autocorrect: false,
                //enableSuggestions: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '', //'Full Name',
                ),
                style: TextStyle(
                  fontSize: 35,
                  height: 1.5
                ),
                maxLines: maxNumberOfLines,
                //expands: true,
                keyboardType: TextInputType.multiline,  //TextInputType.visiblePassword
              ),//focusNode: _textNode,
            ),
          //),
          SizedBox(
            width: double.infinity,
            height: 40,
            child:  CustomPaint(
              foregroundPainter: inputZiPainter,
              //size: new Size(screenWidth, 60 /*TODO: more precise. contentLength.value*/),

              child: Center(
                child: Stack(
                  children: createHittestButtons(context, theCurrentZiCandidates),
                ),
              ),
            ),
          )
        ]
      ),
    );
  }

  Widget getHelpOrProgressIndicator() {
    if (typingType == TypingType.FreeTyping) {
      return SizedBox(
        //width: double.infinity,
        //height: 30,
        child: Align(
          alignment: Alignment.topRight,
          child: TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InputZiHelpPage(),
                ),
              );},
            child: const Text('Help'),
          ),
        ),
        //TODO: put a help button at the right end
      );
    }
    else {
      return Container( // x and progress bard
        child: LinearProgressIndicator(value: _progressValue),
        //getProgressBar(context),
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 2.0), //EdgeInsets.all(10),
      );
    }
  }

  //Note: Make this case special so that 1: I don't need to put stroke kind of info to the "Give it a try" samples.
  //      2: More space for the keyboard which is special for "Give it a try" case.
  Widget getComponentAndMapping() {
    var fontSize = 15.0;
    var zi = theInputZiManager.getZiWithComponentsAndStrokes(typingType, currentIndex, lessonId);
/*
    var inputZiHintPainter = InputZiHintPainter(
        lineColor: Colors.amber,
        completeColor: Colors.blueAccent,
        screenWidth: screenWidth //350 /*TODO: temp*/
    );
*/
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox( //Flexible(
            child: Image.asset(
              "assets/typing/" + theZiForIntroductionList[0].hintImage,
              width: 350.0, //300.0,
              height: 150.0, //100.0,
              fit: BoxFit.fitWidth,
            )
          ),

          Row(
              children: <Widget>[
                SizedBox(
                  child: Text(
                      "Type: ",
                      style: TextStyle(fontSize: fontSize * 1.2),
                      textAlign: TextAlign.left
                  ),
                ),
                SizedBox(width: fontSize * 1.2),
                SizedBox(
                  child: Text(
                      zi.zi,
                      style: TextStyle(fontSize: fontSize * 2.0, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                      textAlign: TextAlign.left
                  ),
                ),
                SizedBox(width: fontSize),
                SizedBox(width: 30.0),
                SizedBox(
                  child: Text(
                      "Hint: " + theZiForIntroductionList[currentIndex].hintText ,
                      style: TextStyle(fontSize: fontSize * 1.2),
                      textAlign: TextAlign.center   //left
                  ),
                ),
              ]
          ),

        ]
    );
  }

  Widget getComponentRelated() {
    if (currentIndex < 0) {
      return Container(width:0.0, height: 0.0);
    }

    // an empty box
    if (typingType == TypingType.FreeTyping) {
      return Container(width:0.0, height: 0.0);
        /*SizedBox(
        width: double.infinity,
        height: 0,
      );*/
    }

    if (typingType == TypingType.ForIntroduction) {
      return getComponentAndMapping();
    }

    String instruction  = InputZiManager.getIntroduction(typingType, currentIndex, lessonId);

    var zi = theInputZiManager.getZiWithComponentsAndStrokes(typingType, currentIndex, lessonId);

    var fontSize = 15.0;

    var inputZiHintPainter = InputZiHintPainter(
        lineColor: Colors.amber,
        completeColor: Colors.blueAccent,
        screenWidth: screenWidth, //350 /*TODO: temp*/
        showHint: this.showHint,
        char: zi.zi,
        typingType: typingType
    );

    return WillPopScope(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: fontSize),
          Flexible(
            child: Text(
                instruction,
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.left
            ),
          ),
          //SizedBox(height: fontSize),

          Row(
              children: <Widget>[
                SizedBox(
                  width: 50,
                  child: Text(
                      "Type: ",
                      style: TextStyle(fontSize: fontSize * 1.2),
                      textAlign: TextAlign.left
                  ),
                ),
                SizedBox(width: fontSize),
                SizedBox(
                  width: 50.0,
                  child: Text(
                      zi.zi,
                      style: TextStyle(fontSize: fontSize * 2.0, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                      textAlign: TextAlign.left
                  ),
                ),
                SizedBox(width: 220.0), //200.0
                SizedBox(
                  width: 50.0,
                child: FlatButton(
                  color: Colors.white,
                  textColor: Colors.blueAccent,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    if (overlayEntry != null) {
                        overlayEntry.remove();
                        overlayEntry = null;
                    }

                    setState(() {
                      showHint = true;
                    });

                    //var overlayParameters = InputZiOverlayParameters(typingType, currentIndex, false, '');
                    //showOverlay(context, overlayParameters);
                  },
                  child: Text(
                    "Hint",
                    style: TextStyle(fontSize: fontSize * 1.2),
                    textAlign: TextAlign.center
                  ),
                ),
                ),
              ]
          ),
        Row(
            children: <Widget>[
              SizedBox(
                height: 40.0,
                //width: 150.0,
                child:  CustomPaint(
                  foregroundPainter: inputZiHintPainter,
                ),
              ),
              ]
         ),
       ]
      ),
      onWillPop: _onWillPop
    );
  }

  Positioned getZiCandidateButton(PrimitiveWrapper xPosi, int candidateIndex, String zi) {
    var butt = FlatButton(
      color: Colors.white,
      textColor: Colors.blueAccent,
      onPressed: () {
        // this lock mechanism seems working fine, but not sure ...
        //isCurrentlyUnderChoiceSelection = true;
        setInitialControllerTextValue();
        setTextByChosenZiIndex(candidateIndex, true);
        //isCurrentlyUnderChoiceSelection = false;
      },
      child: Text('', style: TextStyle(fontSize: 20.0),),
    );

    var posiCenter = Positioned(
        top: 0.0,
        left: xPosi.value,
        height: 30.0, //posiAndSize.height,
        width: 30.0 * zi.length, //posiAndSize.width,
        child: butt
    );

    xPosi.value += (30.0 * zi.length + 25.0);

    return posiCenter;
  }

  List<Widget> createHittestButtons(BuildContext context, List<String> ziCandidates) {
    List<Widget> buttons = [];

    buttons.add (Container(height: 80.0 /*contentLength.value*/, width: screenWidth));  // workaround to avoid infinite size error

    PrimitiveWrapper xPosi = PrimitiveWrapper(0.0);

    if (ziCandidates != null) {
      for (var i = 0; i < ziCandidates.length; i++) {
        buttons.add(getZiCandidateButton(xPosi, i, ziCandidates[i]));
      }
    }

    return buttons;
  }

  showCompletedDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop(); // out this dialog
        Navigator.of(context).pop(); // to the lesson page
      },
    );

    String title;
    String content;

    if (typingType == TypingType.ForIntroduction) {
      title = "Good job!";
      content = "You did it! Let's go through the typing exercises now.";
    }
    else if (typingType == TypingType.LeadComponents) {
      title = "Good job!";
      content = "You did it again! Let’s get to know the Expanded Components. ";
    }
    else if (typingType == TypingType.ExpandedComponents) {
      title = "Congratulations!";
      content = "Your training is complete. Practice or use what you learned with some free typing.";
    }
    else if (typingType == TypingType.FromLessons) {
      title = "Good job!";
      content = "Your typing exercise is complete for this lesson.";
    }

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
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
}