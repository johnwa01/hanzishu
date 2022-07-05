import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//importpackage:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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
import 'dart:io';

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

  // initial value to work around an Android issue: 'y', pick a zi, 'h' ->yh instead of zi+h.
  TextEditingController _controller = new TextEditingController(text: ">");
  FocusNode _textNode = new FocusNode();
  int previousStartComposing = -1;
  int previousEndComposing = -1;
  int previousEndSelection = -1;
  String initialControllerTextValue; // = "unlikelyIniStr876";
  String previousText = "";
  List<String> ziCandidates;
  bool showHint = false;

  OverlayEntry overlayEntry;
  int dismissCount = 0;

  int updateCounter = 0;
  bool isFromDeletion = false;
  String previousOverlayLetter = "";

  bool hasVerifiedToBeALowerCase = false;

  double getSizeRatio() {
    return Utility.getSizeRatio(screenWidth);
  }

  @override
  initState() {
    super.initState();

    _controller.addListener(handleKeyInput);
    _progressValue = 0.0;
    totalQuestions =
        theInputZiManager.getTotal(widget.typingType, widget.lessonId);
    typingType = widget.typingType;
    theInputZiManager.setCurrentType(typingType);

    setState(() {
      updateCounter = 0;
      showHint = false;
      currentIndex = theInputZiManager.getCurrentIndex(typingType);
    });
  }

  initParameters() {
    previousStartComposing = -1;
    previousEndComposing = -1;
    previousText = "";
    initialControllerTextValue = "";
  }

  // make sure overlay will be removed when moving back to the parent page.
  Future<bool> _onWillPop() {
    initOverlay();

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
    var selectionEnd;

    if (_controller.value.text != null && _controller.value.text.length != 0) {
      selectionEnd = _controller.value.selection.end;
      if (selectionEnd >= 1) {
        return _controller.value.text.substring(selectionEnd - 1, selectionEnd);
      }
    }

    return newInputText;
  }

  String getInputTextBeforeComposingAndSelectionStart(bool isFromNumber) {
    var newInputText = "";

    if (_controller.value.text != null && _controller.value.text.length != 0) {
      if (previousStartComposing == 0) {
        return newInputText;
      }
      else if (previousStartComposing > 0) {
        return _controller.value.text.substring(
            0, previousStartComposing);
      }
      else if (_controller.value.selection.start >= 1) {
        var selectionStart = _controller.value.selection.start;
        if (isFromNumber) {
          // exclude the number letter itself which isn't part of the input
          selectionStart -= 1;
        }
        return _controller.value.text.substring(
            0, selectionStart);
      }
    }

    return newInputText;
  }

  String getInputTextAfterComposingAndSelectionEnd() {
    var newInputText = "";

    if (_controller.value.text != null && _controller.value.text.length > 0) {
      if (previousEndComposing >= 1 &&
          previousEndComposing < _controller.value.text.length) {
        return _controller.value.text.substring(
            previousEndComposing, _controller.value.text.length);
      }
      else {
        if (_controller.value.selection.end > -1) {
          return _controller.value.text.substring(
              _controller.value.selection.end, _controller.value.text.length);
        }
      }
    }

    return newInputText;
  }

  String getInputText(int index, bool isFromNumber) {
    var newInputText = "";

    newInputText = getInputTextBeforeComposingAndSelectionStart(isFromNumber);

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

  showOverlay(BuildContext context, String latestOverleyLetter
      /*InputZiOverlayParameters overlayParameters*/
      /*TypingType type, int index, bool isFullComponents, String fullComponentsLetter*/) {
    initOverlay();

    if (latestOverleyLetter != previousOverlayLetter) {
      var imageName;
      var fullPath;
      double imageLeft;
      double imageWidth;
      double imageHeight;

      if (latestOverleyLetter == "Z") { // the full mapping chart
        imageName = "GG6.png";
        imageLeft = 50.0 * getSizeRatio();
        imageWidth = 300.0 * getSizeRatio();
        imageHeight = 135.0 * getSizeRatio();
      }
      else {
        var pair = ComponentManager.getGroupAndIndexFromLetter(
            latestOverleyLetter);
        var fullExpandedComponent = theComponentManager
            .getFullExpandedComponentByGroupAndIndex(
            pair.groupNumber, pair.indexInGroup);
        imageName = fullExpandedComponent.imageName;
        imageLeft = 150.0 * getSizeRatio();
        imageWidth = 100.0 * getSizeRatio();
        imageHeight = 135.0 * getSizeRatio();
      }
      fullPath = "assets/typing/" + imageName;

      OverlayState overlayState = Overlay.of(context);
      overlayEntry = OverlayEntry(
          builder: (context) =>
              Positioned(
                top: 30 * getSizeRatio(), //65, //65.0, //85.0, //posiY,
                left: imageLeft, //100, //0.0, //posiX,
                child: Image.asset(
                  fullPath,
                  width: imageWidth, //350.0,
                  height: imageHeight,
                  fit: BoxFit.fitWidth,
                ),
              ));
      overlayState.insert(overlayEntry);
      previousOverlayLetter = latestOverleyLetter;
    }
    else {
      previousOverlayLetter =
      ""; // this time no display = dismiss the display; prepare for next time to re-display
    }
  }

  String getFullComposingText(int startComposing, int endComposing) {
    var str = "";
    if (endComposing > startComposing) {
      str = _controller.value.text.substring(startComposing, endComposing);
    }

    return str;
  }

  bool isNumberOneToSeven(String value) {
    if (value.length > 0) {
      var charCodeUnits = value[0].codeUnits;

      if (charCodeUnits.length == 1 && charCodeUnits[0] >= 49 &&
          charCodeUnits[0] <= 55) { // value is between 1 and 7
        return true;
      }
    }

    return false;
  }

  int getZeroBasedNumber(String value) {
    if (value.length > 0) {
      var charCodeUnits = value[0].codeUnits;

      if (charCodeUnits.length == 1 && charCodeUnits[0] >= 49 &&
          charCodeUnits[0] <= 55) { // value is between a and z
        return charCodeUnits[0] - 49;
      }
    }

    return -1;
  }

  // isFromCharChandidateList: true if tap a candidate char; false if type "spacebar" or uppercase letter for overlay.
  // candidateLength includes cases like "ttt" as the first candidate, that is, run out of normal candidates.
  int getCursorPosition(int candidateCharLength, bool isFromCharCandidateList,
      bool isFromOverlay) {
    var selectionPosi;
    if (_controller.value.selection.end >= 0) {
      selectionPosi = _controller.value.selection.end;
      if (isFromCharCandidateList) { // since it's from candidate, not from keyboard.
        selectionPosi += candidateCharLength; // the new Chinese char
        if (previousEndComposing >= 1) {
          selectionPosi -= (previousEndComposing -
              previousStartComposing); // subtract composing if any
        }
      }
      else if (isFromOverlay) {
        selectionPosi--; // subtract the uppercase letter
      }
      else { // currently just spacebar case: previousEndComposing is always >= 1 due to the spacebar ' ' space
        selectionPosi += candidateCharLength; // the new Chinese char
        selectionPosi -=
        (previousEndComposing - previousStartComposing); // subtract composing
      }
    }
    else {
      selectionPosi = _controller.value.text.length;
    }

    if (selectionPosi <
        0 /*|| (_controller.value.text.length > 0 && selectionPosi > _controller.value.text.length)*/) {
      selectionPosi = _controller.value.text.length;
    }

    return selectionPosi;
  }

  checkAndUpdateCurrentIndex() {
    // for guarded typing
    if (typingType != TypingType.FreeTyping) {
      if (theInputZiManager.doesTypingResultContainTheZi(
          typingType, currentIndex, _controller.text, lessonId)) {
        // tell Flutter to refresh with the next index
        setState(() {
          if ((currentIndex + 1) ==
              theInputZiManager.getTotal(typingType, lessonId)) {
            /*
            if (lessonId == 38) {
              theTypingExerciseNumber = 1;
            }
            else {
              theTypingExerciseNumber += 1;
            }
            */
            theInputZiManager.initCurrentIndex();
            showCompletedDialog(currentBuildContext);
          }
          currentIndex =
              theInputZiManager.getNextIndex(
                  typingType, /*currentIndex,*/ lessonId);
        });

        //       return;
      }
    }
  }

  void setTextByChosenZiIndex(int selectionIndex, bool isFromCharCandidateList,
      bool isFromOverlay, bool isFromNumber) {
    hasVerifiedToBeALowerCase = false;

    var newText = getInputText(selectionIndex, isFromNumber);

    previousText = newText;
    if (isFromCharCandidateList) {
      // in this case, it has no chance to go through handleKeyInputHelper to set the init value. Therefore we are setting it specifically.
      initialControllerTextValue = "newText";
    }

    var candidateCharLength = theCurrentZiCandidates[selectionIndex].length;
    // reset the candidate. might set to global ini value
    theCurrentZiCandidates = theDefaultZiCandidates;

    var selectionPosi = getCursorPosition(
        candidateCharLength, isFromCharCandidateList, isFromOverlay);
    previousEndSelection = selectionPosi; //_controller.value.selection.end;

    _controller.value = _controller.value.copyWith(text: newText,
        composing: TextRange.empty,
        selection: TextSelection.collapsed(offset: selectionPosi));

    previousStartComposing = -1;
    previousEndComposing = -1;

    showHint = false;

    checkAndUpdateCurrentIndex();

    //restart a typing cycle
    InputZiManager.previousFirstPositionList.clear();
  }

  void handleKeyInput() {
    handleKeyInputHelper(0);
  }

  workaroundWebCases() {
    if (hasVerifiedToBeALowerCase ||
        (_controller.text.length > 0 && _controller.selection == -1)) {
      // For web case, only the combination of composing empty and setting selection will set cursor in the right position in web.
      // at the same time, it won't reserve the composing value which is fine for now. (like iOS to avoid crash).
      // TODO: will validate in future flutter version.
      int posi = _controller.text.length;
      if (previousEndComposing > 0) {
        posi = previousEndComposing;
      }
      _controller.value = _controller.value.copyWith(
          composing: TextRange.empty,
          selection: TextSelection.collapsed(offset: posi));
      //_controller.value = _controller.value.copyWith(selection: TextSelection.collapsed(offset: _controller.text.length));
      //_controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
    }
  }

  // my method counds on previousStartComposing/previousEndComposing & set value.composing as needed to
  // tell Flutter to under the characters in composing.
  // Feel have a root finally. Otherwise it's always floating somewhere.
  void handleKeyInputHelper(int selectionIndex) {
    // Note: For each event, the system might send message multiple times.
    // This logic filters out the extra top level calls to this function, as well as the
    // calls triggered by code below but before the controller text is changed.
    isFromDeletion = false;
    // Will always blocks if same text as the previous one. Only setting initialControllerTextValue in this if/else block.
    // We don't support clicking of same upper case letter multi-times. We simply ignore the later clicks. Otherwise the logic is too complicated
    // due to repeated Flutter messages and same text value.
    if (_controller.text == initialControllerTextValue) {
      // this is due to repeated Flutter messages.
      if (initialControllerTextValue != previousText) {
        // set this _controller.value to be the same as the one we processed in the following code. This way, it won't show the wrong value to UI.
        _controller.value = _controller.value.copyWith(text: previousText,
            selection: TextSelection.collapsed(offset: previousEndSelection));
      }

      if (kIsWeb) {
        workaroundWebCases();
      }

      return;
    }
    else if (_controller.text == previousText) {
      return;
    }
    else {
      if (_controller.value.text.length < previousText.length) {
        isFromDeletion = true;
      }
      // set it as the comparision standard
      setInitialControllerTextValue();
      hasVerifiedToBeALowerCase = false;
    }

    if (currentIndex < 0) {
      return;
    }

    //TODO: temp testing for comp shapes
    globalTestDoubleByteCode = _controller.text;

    /*
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
    */

    //print('Second text field: ${_controller.text}');
    String latestInputKeyLetter = "";

    latestInputKeyLetter = getLatestInputLetter();

    if (latestInputKeyLetter == " " /*32*/) { // space key
      initOverlay();

      setPreviousComposing();

      setTextByChosenZiIndex(selectionIndex, false, false, false);
    }
    /*
    else if (_controller.text.length == 0) { // due to deletion, otherwise won't be 0
      theCurrentZiCandidates = theDefaultZiCandidates;
      previousStartComposing = -1;
      previousEndComposing = -1;
      previousText = _controller.text;
    }
    */
    else if (isFromDeletion) {
      initOverlay();
      if (_controller.text.length == 0) {
        // don't allow to remove the default character value of '>' at the beginning to work around an Android issue as described earlier
        _controller.value = _controller.value.copyWith(text: '>',
            composing: TextRange.empty,
            selection: TextSelection.collapsed(offset: 1));
      }
      else if ((previousEndComposing - previousStartComposing) > 1) {
        previousEndComposing--;
        var composingText = getFullComposingText(
            previousStartComposing, previousEndComposing);
        theCurrentZiCandidates = InputZiManager.getZiCandidates(composingText);
        InputZiManager.updateFirstCandidate(
            theCurrentZiCandidates, InputZiManager.previousFirstPositionList);
        previousText = _controller.text;
      }
      else {
        previousStartComposing = -1;
        previousEndComposing = -1;
        theCurrentZiCandidates = theDefaultZiCandidates;
        previousText = _controller.text;
      }
    }
    //Note: Temp disable UpperCase and LowerCase if want to test component shapes
    else if (Utility.isAUpperCaseLetter(latestInputKeyLetter)) { // space key
      showOverlay(context, latestInputKeyLetter);
      setPreviousComposing();

      // prepare the previousText ahead of time so that the overlay won't be over written by dup runs
      previousText = getInputTextWithoutUpperCaseLetter(latestInputKeyLetter);
      // we normally only reset this init value at the function entry.
      // But need to do it for overlay case so that the next input can go through the checking at the entry.
      //     initialControllerTextValue = previousText; // prepare for next input, equal to the value.text
      // actually set the current value, although use previousText parameter
      var selectionPosi = getCursorPosition(1, false, true);
      previousEndSelection = selectionPosi;
      previousEndComposing--; // subtract the uppercase letter for overlay
      if (!kIsWeb && Platform
          .isIOS) { // iOS simulator would crash on backspace with composing. so have to skip the underline feature until it's fixed.
        _controller.value = _controller.value.copyWith(text: previousText,
            selection: TextSelection.collapsed(offset: selectionPosi));
      }
      else if (kIsWeb) {
        // make cursor correct, but no underline though.
        _controller.value = _controller.value.copyWith(text: previousText,
            composing: TextRange.empty,
            selection: TextSelection.collapsed(offset: selectionPosi));
      }
      else { // Android
        _controller.value = _controller.value.copyWith(text: previousText,
            composing: TextRange(
                start: previousStartComposing, end: previousEndComposing),
            selection: TextSelection.collapsed(offset: selectionPosi));
      }
    }
    else if (/*kIsWeb &&*/ isNumberOneToSeven(latestInputKeyLetter)) {
      if (_controller.text != previousText) {
        initOverlay();
      }

      previousEndComposing += 1;
      setTextByChosenZiIndex(
          getZeroBasedNumber(latestInputKeyLetter), false, false, true);
    }
    else if (Utility.isALowerCaseLetter(latestInputKeyLetter)) {
      hasVerifiedToBeALowerCase = true;
      initOverlay();
      setPreviousComposing();

      var composingText = getFullComposingText(
          previousStartComposing, previousEndComposing);
      theCurrentZiCandidates = InputZiManager.getZiCandidates(composingText);
      InputZiManager.updateFirstCandidate(
          theCurrentZiCandidates, InputZiManager.previousFirstPositionList);

      if (theCurrentZiCandidates == null) {
        List<String> composingList = [composingText];
        theCurrentZiCandidates = composingList;
      }
      previousText = _controller.text;

      // Android appears updating its value.composing after initial setting of the value.composing from empty by app.
      // or even without initial setting. Maybe a kind of algorithm behind detecting what kind of input. By default, it seems treating
      // English letter input as composing.
      // Check myself and update value.composing value if not matching to tell the phone to show underline the letters
      // under composing.
      // This logic also covers the initial value.composing case which should be empty (-1, -1).
      // But iPhone doesn't seem to update value.composing after initial setting.
      // iOS simulator would crash on backspace with composing, so not supporting underline feature.
      if (kIsWeb || (!kIsWeb && Platform.isAndroid)) {
        if (_controller.value.composing.start != previousStartComposing ||
            _controller.value.composing.end != previousEndComposing) {
          _controller.value = _controller.value.copyWith(
              composing: TextRange(
                  start: previousStartComposing, end: previousEndComposing));
        }
      }
    }
    else {
      initOverlay();
      previousStartComposing = -1;
      previousEndComposing = -1;
      theCurrentZiCandidates = theDefaultZiCandidates;
      previousText = _controller.text;
    }
  }

  setPreviousComposing() {
    if (previousEndComposing >= 0) {
      previousEndComposing++;
    }
    else {
      previousStartComposing = _controller.selection.end -
          1; // since the ' ' takes one space, it'll always >= 1
      previousEndComposing = previousStartComposing + 1; // for the space itself
    }
  }

  setInitialControllerTextValue() {
    initialControllerTextValue =
        _controller.text; // will not change until next letter input.
    previousText = _controller
        .text; // can change with the updated value within the same letter input.
  }

  Widget getExplainationPage() {
    var fontSize1 = TheConst.fontSizes[1] * getSizeRatio();

    //if (typingType == TypingType.LeadComponents || typingType == TypingType.GiveItATry) {
    var str; //getString(110); /*"The Component Input Method breaks up a Chinese Character into Components and types in the mapped letters on the English keyboard."*/
    // + "\n\n" + getString(111)/*"Reference this chart to visualize how Lead Components are mapped to English letters. The five single-stroke Components sit in the two middle columns, so try to read from middle to side."*/;
    //}
    //if (typingType == TypingType.ExpandedInitial) {
    //  str = theZiForExpandedInitialExerciseList[currentIndex].hintText;
    //}
    var title;
    var buttonText = getString(357);
    if (typingType == TypingType.LeadComponents) {
      str = theZiForLeadCompExerciseList[currentIndex].hintText;
      title = getString(100);
      buttonText = getString(109);
    }
    else if (typingType == TypingType.ExpandedReview) {
      str = theZiForExpandedReviewExerciseList[currentIndex].hintText;
      title = getString(308);
    }
    else if (typingType == TypingType.ExpandedGeneral) {
      str = theZiForExpandedGeneralExerciseList[currentIndex].hintText;
      title = getString(334);
    }
    else if (typingType == TypingType.AttachedComponents) {
      str = theZiForAttachedCompExerciseList[currentIndex].hintText;
      title = getString(328);
    }
    else if (typingType == TypingType.TwinComponents) {
      str = theZiForTwinCompExerciseList[currentIndex].hintText;
      title = getString(329);
    }
    else if (typingType == TypingType.SubComponents) {
      str = theZiForSubCompExerciseList[currentIndex].hintText;
      title = getString(330);
    }
    else if (typingType == TypingType.SingleComponent) {
      str = theZiForSingleCompExerciseList[currentIndex].hintText;
      title = getString(331);
    }
    else if (typingType == TypingType.TwoComponents) {
      str = theZiForTwoCompExerciseList[currentIndex].hintText;
      title = getString(332);
    }
    else if (typingType == TypingType.GeneralExercise) {
      str = theZiForGeneralExerciseList[currentIndex].hintText;
      title = getString(333);
    }

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(title),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: fontSize1),
            Text(
                str,
                //getString(110)/*"The Component Input Method breaks up a Chinese Character into Components and types in the mapped letters on the English keyboard."*/,
                style: TextStyle(fontSize: fontSize1),
                textAlign: TextAlign.start
            ),
            /*     SizedBox(height: fontSize1),
            Text(
                getString(111)/*"Reference this chart to visualize how Lead Components are mapped to English letters. The five single-stroke Components sit in the two middle columns, so try to read from middle to side."*/,
                style: TextStyle(fontSize: fontSize1),
                textAlign: TextAlign.start
            ),
        */
            getExplainationImage(),
            SizedBox(height: fontSize1),
            SizedBox(
              child: Align(
                alignment: Alignment.topCenter,
                child: TextButton(
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(fontSize: 18.0 * getSizeRatio()),
                  ),
                  onPressed: () {
                    setState(() {
                      //currentIndex = 1;
                      currentIndex = theInputZiManager.getNextIndex(typingType, /*currentIndex,*/ lessonId);;
                    });
                  },
                  child: Text(buttonText /*'Try a few/Let's start'*/,
                      style: TextStyle(color: Colors.blue)),
                ),
              ),
            ),
          ]
      ),
    );
  }

  Widget getExplainationImage() {
    //var image = theZiForIntroductionList[0].hintImage;
    var image;
    var width = 140.0 * getSizeRatio();
    var height = 140.0 * getSizeRatio();

    if (typingType == TypingType.LeadComponents) {
      image = theZiForLeadCompExerciseList[currentIndex].hintImage;
      width = 350.0 * getSizeRatio();
      height = 150.0 * getSizeRatio();
    }
    else if (typingType == TypingType.ExpandedReview) {
      image = theZiForExpandedReviewExerciseList[currentIndex].hintImage;
    }
    else if (typingType == TypingType.ExpandedGeneral) {
      image = theZiForExpandedGeneralExerciseList[currentIndex].hintImage;
    }
    else if (typingType == TypingType.AttachedComponents) {
      image = theZiForAttachedCompExerciseList[currentIndex].hintImage;
    }
    else if (typingType == TypingType.TwinComponents) {
      image = theZiForTwinCompExerciseList[currentIndex].hintImage;
    }
    else if (typingType == TypingType.SubComponents) {
      image = theZiForSubCompExerciseList[currentIndex].hintImage;
    }
    else if (typingType == TypingType.SingleComponent) {
      image = theZiForSingleCompExerciseList[currentIndex].hintImage;
    }
    else if (typingType == TypingType.TwoComponents) {
      image = theZiForTwoCompExerciseList[currentIndex].hintImage;
    }
    else if (typingType == TypingType.GeneralExercise) {
      image = theZiForGeneralExerciseList[currentIndex].hintImage;
    }

    if (image.isNotEmpty) {
      return Container( //Flexible(
        alignment: Alignment.center,
        child: Image.asset(
          "assets/typing/" + image,
          width: width,
          height: height,
        ),
      );
    }
    else {
      return SizedBox(width: 0, height: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    theCurrentZiCandidates = theDefaultZiCandidates; // set it to default

    typingType = widget.typingType; //theComponentManager.getCurrentType();
    lessonId = widget.lessonId;

    if (currentIndex < 0) {
      return Container(width:0.0, height: 0.0);
    }

    screenWidth = Utility.getScreenWidthForTreeAndDict(context);
    double editFontSize = 30.0 * getSizeRatio();

    //To be sure
    initOverlay();

    //initParameters();

    int maxNumberOfLines;
    if (typingType == TypingType.FreeTyping) {
      maxNumberOfLines = 4;  //
      editFontSize = 26 * getSizeRatio();
    }
    else {
      maxNumberOfLines = 1;
      _progressValue = currentIndex/totalQuestions;
    }

    currentBuildContext = context;

    //   typingType = widget.typingType; //theComponentManager.getCurrentType();
//    theInputZiManager.setCurrentType(typingType); //TODO: should pass as a parameter in painter?

    var inputZiPainter = InputZiPainter(
        lineColor: Colors.amber,
        completeColor: Colors.blueAccent,
        lessonId: lessonId, /*TODO: temp*/
        screenWidth: screenWidth //350 /*TODO: temp*/
    );

    var title; // = getString(98)/*'Component Input Method'*/;
    //if (typingType == TypingType.GiveItATry) {
    //  title = getString(100)/*'Give it a try'*/;
    //}
    if (typingType == TypingType.LeadComponents) {
      title = getString(100)/*'Give it a try'*/;
    }
    //else if (typingType == TypingType.ExpandedInitial) {
    //  title = getString(105)/*'Expanded Components'*/;
    //}
    else if (typingType == TypingType.ExpandedReview) {
      title = getString(308)/*'Review Expanded Components'*/;
    }
    else if (typingType == TypingType.ExpandedGeneral) {
      title = getString(334)/*'Pratice Expanded Components'*/;
    }
    else if (typingType == TypingType.AttachedComponents) {
      title = getString(328)/*'Learn Attached Components'*/;
    }
    else if (typingType == TypingType.TwinComponents) {
      title = getString(329)/*'Learn Twin Components'*/;
    }
    else if (typingType == TypingType.SubComponents) {
      title = getString(330)/*'Learn Sub Components'*/;
    }
    else if (typingType == TypingType.SingleComponent) {
      title = getString(331)/*'Character with single Component'*/;
    }
    else if (typingType == TypingType.TwoComponents) {
      title = getString(332)/*'Character with two Components'*/;
    }
    else if (typingType == TypingType.GeneralExercise) {
      title = getString(333)/*'General Exercises'*/;
    }
    else if (typingType == TypingType.FreeTyping) {
      title = getString(108)/*'Free typing and help'*/;
    }
    else if (typingType == TypingType.CustomizedTyping) {
      title = getString(112)/*'Customized exercises'*/;
    }
    else if (typingType == TypingType.FromLessons) {
      title = getString(253)/*'Typing exercises'*/;
    }
    else if (typingType == TypingType.CustomizedTyping) {
      title = getString(112)/*'Customized exercises'*/;
    }

    // first index is for explaination
    if (typingType != TypingType.FromLessons && typingType != TypingType.CustomizedTyping && typingType != TypingType.FreeTyping && currentIndex == 0) {
      return getExplainationPage();
    }

    var editFieldFontRatio = getSizeRatio();
    if (editFieldFontRatio > 1.7) { // otherwise iPad Pro 12.9" would have a huge char size in EditField
      editFieldFontRatio /= 1.3;
    }

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(title),
        ),
      body: WillPopScope( // for dismissing overlay menu only when hitting back arrow
        child: Column(
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
                autocorrect: false,
                enableSuggestions: false,
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
                  fontSize: editFontSize * editFieldFontRatio, // 35
                  height: 1.3
                ),
                maxLines: maxNumberOfLines,
                //expands: true,
                keyboardType: TextInputType.multiline,  //TextInputType.visiblePassword
              ),//focusNode: _textNode,
            ),
          //),
          SizedBox(
            width: double.infinity,
            height: 40.0 * getSizeRatio(), //40
            child:  CustomPaint(
              foregroundPainter: inputZiPainter,
              //size: new Size(screenWidth, 60 /*TODO: more precise. contentLength.value*/),

              //child: Center(
                child: Stack(
                  children: createHittestButtons(context, theCurrentZiCandidates),
                ),
              //),
            ),
          )
        ]
      ),
          onWillPop: _onWillPop
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
              textStyle: TextStyle(fontSize: 16.0 * getSizeRatio()),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InputZiHelpPage(),
                ),
              );},
            child: Text(getString(114)/*'Help'*/, style: TextStyle(fontWeight: FontWeight. bold)),
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
    var fontSize = 15.0 * getSizeRatio();
    var zi = theInputZiManager.getZiWithComponentsAndStrokes(typingType, currentIndex, lessonId);
/*
    var inputZiHintPainter = InputZiHintPainter(
        lineColor: Colors.amber,
        completeColor: Colors.blueAccent,
        screenWidth: screenWidth //350 /*TODO: temp*/
    );
*/
    var sizeRatio = getSizeRatio();
    if (0.80 < sizeRatio && sizeRatio < 0.83) {
      // dp = 320 or below. special case iPod touch 7 which ratio is 0.816. have to make the image size smaller
      // in order to show the whole huge keyboard in iPod touch 7.
      sizeRatio = 0.54;
    }

    return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox( //Flexible
            child: Image.asset(
              "assets/typing/" + theZiForIntroductionList[0].hintImage,
              width: 300.0 * sizeRatio,  // 350
              height: 100.0 * sizeRatio, // 150
              fit: BoxFit.fitWidth,
            )
          ),
          /*
          FittedBox( //Flexible( //FittedBox
              child: Image.asset(
                "assets/typing/" + theZiForIntroductionList[0].hintImage,
                fit: BoxFit.fill,
              )
          ),
          */
          Row(
              children: <Widget>[
                SizedBox(
                  child: Text(
                      getString(113)/*"Please type"*/ + ": ",
                      style: TextStyle(fontSize: fontSize * 1.2),
                      textAlign: TextAlign.left
                  ),
                ),
                SizedBox(width: fontSize * 0.5), //1.2
                SizedBox(
                  child: Text(
                      zi.zi, // was fontSize*2.0
                      style: TextStyle(fontSize: 30.0 * sizeRatio, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                      textAlign: TextAlign.left
                  ),
                ),
                SizedBox(width: fontSize),
                SizedBox(width: 5.0 * getSizeRatio()), //10.0
                SizedBox(
                  child: Text(
                      getString(90)/*"Hint"*/ + ": " + theZiForIntroductionList[currentIndex].hintText ,
                      style: TextStyle(fontSize: fontSize),  // fontSize * 1.2
                      textAlign: TextAlign.center   //left
                  ),
                ),
              ]
          ),

        ]
    );
  }

  Widget getInstruction(String instruction) {
    if (instruction == null || instruction.length == 0) {
      return Container(width:0.0, height: 0.0);
    }

    var fontSize = 13.0 * getSizeRatio();

    return SizedBox(  //
      child: Text(
          instruction,
          style: TextStyle(fontSize: fontSize),
          textAlign: TextAlign.left
      ),
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

    // treat it specially so that it can have shorter/non-standard hints for sample chars.
    //if (typingType == TypingType.GiveItATry) {
    //  return getComponentAndMapping();
    //}

    String instruction  = InputZiManager.getIntroduction(typingType, currentIndex, lessonId);

    var zi = theInputZiManager.getZiWithComponentsAndStrokes(typingType, currentIndex, lessonId);

    var fontSize = 13.0 * getSizeRatio();     //15.0

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
          //SizedBox(height: fontSize),
          getInstruction(instruction),
          getImageTiedToZi(),
          Row(
              children: <Widget>[
                SizedBox(
                  width: 130 * getSizeRatio(),
                  child: Text(
                      getString(113)/*"Please type"*/ + ": ",
                      style: TextStyle(fontSize: fontSize * 1.2),
                      textAlign: TextAlign.left
                  ),
                ),
                SizedBox(width: fontSize),
                SizedBox(
                  width: 50.0 * getSizeRatio(),
                  child: Text(
                      zi.zi,
                      style: TextStyle(fontSize: fontSize * 2.0, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                      textAlign: TextAlign.left
                  ),
                ),
                SizedBox(width: 140.0 * getSizeRatio()), //200.0
                SizedBox(
                  width: 50.0 * getSizeRatio(),
                  child: FlatButton(
                    color: Colors.white,
                    textColor: Colors.blueAccent,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      initOverlay();

                      setState(() {
                        showHint = true;
                      });
                    },
                    child: Text(
                      getString(90)/*"Hint"*/,
                      style: TextStyle(fontSize: fontSize * 1.6), // 1.2
                      textAlign: TextAlign.left //TextAlign.center
                    ),
                  ),
                ),
              ]
          ),
        Row(
            children: <Widget>[
              SizedBox(
                height: 40.0 * getSizeRatio(),
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

  Widget getImageTiedToZi() {
    var image;
    if (typingType == TypingType.ExpandedReview || typingType == TypingType.AttachedComponents || typingType == TypingType.TwinComponents || typingType == TypingType.SubComponents) {
      //if (typingType == TypingType.LeadComponents) {
      //  image = theZiForLeadCompExerciseList[currentIndex].hintImage;
      //}
      if (typingType == TypingType.ExpandedReview) {
        image = theZiForExpandedReviewExerciseList[currentIndex].hintImage;
      }
      else if (typingType == TypingType.AttachedComponents) {
        image = theZiForAttachedCompExerciseList[currentIndex].hintImage;
      }
      else if (typingType == TypingType.TwinComponents) {
        image = theZiForTwinCompExerciseList[currentIndex].hintImage;
      }
      else if (typingType == TypingType.SubComponents) {
        image = theZiForSubCompExerciseList[currentIndex].hintImage;
      }

      if (image.isNotEmpty) {
        var arr = image.split(',');
        var image1 = arr[0];
        var image2 = '';
        if (arr.length > 1) {
          image2 = arr[1];
        }
        return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              getOneImage(image1),
              getOneImage(image2),
            ]
        );
      }
    }

    return SizedBox(width: 0, height: 0);
  }

  Widget getOneImage(String image) {
    var width = 100.0 * getSizeRatio();
    var height = 100.0 * getSizeRatio();
    if (typingType == TypingType.LeadComponents) {
      var width = 300.0 * getSizeRatio();
    }

    if (image.isNotEmpty) {
      return Container( //Flexible(hh
        alignment: Alignment.center,
        child: Image.asset(
          "assets/typing/" + image,
          width: width,
          height: height,
        ),
      );
    }
    else {
      return SizedBox(width: 0, height: 0);
    }
  }

  Positioned getZiCandidateButton(PrimitiveWrapper xPosi, int candidateIndex, String zi) {
    var butt = FlatButton(
      color: Colors.white,
      textColor: Colors.blueAccent,
      onPressed: () {
        initOverlay();
        setTextByChosenZiIndex(candidateIndex, true, false, false);
      },
      child: Text('', style: TextStyle(fontSize: 30.0 * getSizeRatio()),),
    );

    var posiCenter = Positioned(
        top: 5.0 * getSizeRatio(),
        left: xPosi.value,
        height: 30.0 * getSizeRatio(), //posiAndSize.height,
        width: 30.0 * getSizeRatio() * zi.length, //posiAndSize.width,
        child: butt
    );

    xPosi.value += (30.0 * getSizeRatio() * zi.length + 23.0 * getSizeRatio());

    return posiCenter;
  }

  List<Widget> createHittestButtons(BuildContext context, List<String> ziCandidates) {
    List<Widget> buttons = [];

    buttons.add (Container(height: 60.0 * getSizeRatio() /*contentLength.value*/, width: screenWidth));  // workaround to avoid infinite size error

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

    /*
    if (typingType == TypingType.GiveItATry) {
      title = getString(115)/*"Good job!"*/;
      content = getString(116)/*"You did it! Let's go through the Component-key pairings now."*/;
      theNewlyCompletedTypingExercise = 0;
    }
     */
    if (typingType == TypingType.LeadComponents) {
      title = getString(115)/*"Good job!"*/;
      content = getString(354)/*"You have completed this exercise! Please move on to the next one."*/;
      theNewlyCompletedTypingExercise = 1;
    }
    /*
    else if (typingType == TypingType.ExpandedInitial) {
      title = getString(118)/*"Congratulations!"*/;
      content = "Your training is complete. Practice or use what you learned with some free typing.";
      theNewlyCompletedTypingExercise = 0;
    }
    */
    else if (typingType == TypingType.ExpandedReview) {
      title = getString(118)/*"Congratulations!"*/;
      content = getString(354)/*"You have completed this exercise! Please move on to the next one."*/;
      theNewlyCompletedTypingExercise = 3;
    }
    else if (typingType == TypingType.ExpandedGeneral) {
      title = getString(118)/*"Congratulations!"*/;
      content = getString(354)/*"You have completed this exercise! Please move on to the next one."*/;
      theNewlyCompletedTypingExercise = 4;
    }
    else if (typingType == TypingType.AttachedComponents) {
      title = getString(118)/*"Congratulations!"*/;
      content = getString(354)/*"You have completed this exercise! Please move on to the next one."*/;
      theNewlyCompletedTypingExercise = 5;
    }
    else if (typingType == TypingType.TwinComponents) {
      title = getString(118)/*"Congratulations!"*/;
      content = getString(354)/*"You have completed this exercise! Please move on to the next one."*/;
      theNewlyCompletedTypingExercise = 6;
    }
    else if (typingType == TypingType.SubComponents) {
      title = getString(118)/*"Congratulations!"*/;
      content = getString(354)/*"You have completed this exercise! Please move on to the next one."*/;
      theNewlyCompletedTypingExercise = 7;
    }
    else if (typingType == TypingType.SingleComponent) {
      title = getString(118)/*"Congratulations!"*/;
      content = getString(354)/*"You have completed this exercise! Please move on to the next one."*/;
      theNewlyCompletedTypingExercise = 8;
    }
    else if (typingType == TypingType.TwoComponents) {
      title = getString(118)/*"Congratulations!"*/;
      content = getString(354)/*"You have completed this exercise! Please move on to the next one."*/;
      theNewlyCompletedTypingExercise = 9;
    }
    else if (typingType == TypingType.GeneralExercise) {
      title = getString(118)/*"Congratulations!"*/;
      content = getString(355)/*"You have completed this exercise! Please move on to the next one."*/;
      theNewlyCompletedTypingExercise = 10;
    }
    else if (typingType == TypingType.CustomizedTyping) {
      title = getString(115)/*"Good job!"*/;
      content = getString(119)/*"You are making great progress in typing Chinese characters."*/;
    }
    else if (typingType == TypingType.FromLessons) {
      title = getString(115)/*"Good job!"*/;
      content = getString(120)/*"Your typing exercise is complete for this lesson."*/;
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