import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/rendering.dart';
//importpackage:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hanzishu/data/sentencelist.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/engine/inputzimanager.dart';
import 'package:hanzishu/engine/componentmanager.dart';
import 'package:hanzishu/engine/texttospeech.dart';
import 'package:hanzishu/engine/dictionary.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';
import 'package:hanzishu/ui/inputzipainter.dart';
import 'package:hanzishu/ui/inputzihintpainter.dart';
import 'package:hanzishu/ui/dictionarypage.dart';
import 'package:hanzishu/ui/inputgamepainter.dart';
import 'package:hanzishu/ui/dictionarysearchingpage.dart';
import 'package:hanzishu/engine/thirdpartylesson.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/data/componenttypinglist.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/data/sentencelist.dart';
import 'package:hanzishu/engine/triemanager.dart';

import 'dart:core';
import 'dart:io';

class InputZiPage extends StatefulWidget {
  final TypingType typingType;
  final int lessonId;
  final String wordsStudy;
  final bool isSoundPrompt;
  final InputMethod inputMethod;
  final HintType showHint;
  final bool includeSkipSection;
  final bool showSwitchMethod;
  InputZiPage({required this.typingType, required this.lessonId, required this.wordsStudy, required this.isSoundPrompt, required this.inputMethod, required this.showHint, required this.includeSkipSection, required this.showSwitchMethod});
  @override
  _InputZiPageState createState() => new _InputZiPageState();
}

class _InputZiPageState extends State<InputZiPage> {
  ScrollController? _scrollController;
  TypingType? typingType;
  int lessonId = -1;
  String wordsStudy = '';
  bool isSoundPrompt = false;
  InputMethod? inputMethod;
  HintType showHint = HintType.None;
  bool includeSkipSection = true;
  bool showSwitchMethod = false;
  int currentIndex = -1;
  var charIndexInSentence = PrimitiveWrapper(0);
  BuildContext? currentBuildContext;
  double _progressValue = 0.0;
  int totalQuestions = -1;
  double screenWidth = 0.0;

  String currentTypingChar = '';

  // initial value to work around an Android issue: 'y', pick a zi, 'h' ->yh instead of zi+h.
  TextEditingController _controller = new TextEditingController(text: "");

  //For standard typing methods only, not related to Hanzishu specific typing
  TextEditingController _controllerStandard = new TextEditingController(
      text: "");

  FocusNode _focusNode = new FocusNode();
  FocusNode _focusNodeStandard = new FocusNode();
  int previousStartComposing = -1;
  int previousEndComposing = -1;
  int previousEndSelection = -1;
  String initialControllerTextValue = ''; // = "unlikelyIniStr876";
  String previousText = "";

  //List<String> ziCandidates;
  int selectedCompIndex = -1;
  int selectedCategoryIndex = -1;
  int selectedSubcategoryIndex = -1;
  int currentCorrectCategoryIndex = -1;
  int currentCorrectSubcategoryIndex = -1;
  bool currentTypingCodeIsCorrect = false;

  //String currentComposingText;
  List<String> currentTypingComponentsAndSub = [];
  String currentCorrectTypingCode = '';
  List<int> currentLeadCompList = [];

  OverlayEntry? overlayEntry = null;
  int dismissCount = 0;

  int updateCounter = 0;
  bool isFromDeletion = false;
  String previousOverlayLetter = "";

  bool hasVerifiedToBeALowerCase = false;

  //int candidateGroupIndex = 0;
  int fullCandidateStartingIndex = 0;

  //For one specific typing string like "ooo", to be used by < or > action
  List<String>? fullZiCandidates;

  bool isFromArrowCandidate = false;

  String listenModeTypedOneSentence = "";
  int totalAccurateCount = 0;
  int sentenceFirstCharIndex = 0;

  //bool showZiCandidates = false;
  HintType firstTypedLetterHintType = HintType.None;

  final stopwatch = Stopwatch()
    ..start();

  double getSizeRatio() {
    return Utility.getSizeRatio(screenWidth);
  }

  initHintSelected() {
    selectedCompIndex = 1;
    selectedCategoryIndex = 0;
    selectedSubcategoryIndex = 0;
    currentCorrectCategoryIndex = 0;
    currentCorrectSubcategoryIndex = 0;
    currentCorrectTypingCode = '';
    currentTypingCodeIsCorrect = true;

    if (currentTypingComponentsAndSub.length > 0) {
      currentTypingComponentsAndSub.clear();
    }

    if (currentLeadCompList.length > 0) {
      currentLeadCompList.clear();
    }
  }

  speakHanziAndPhrase(String typingChar) {
    TextToSpeech.speak("zh-CN", typingChar);
    var phrase = ZiManager.getPhrase(typingChar);
    if (phrase != null) {
      //sleep(const Duration(milliseconds: 1000));
      if (kIsWeb) {
        TextToSpeech.speak("zh-CN", phrase);
      }
      else {
        Timer(Duration(seconds: 1), () {
          TextToSpeech.speak("zh-CN", phrase);
        });
      }
    }
  }

  // For the first one (without a chance for check, other cases are handled in init, but the ones with explanation have to wait until explanation completes.
  speakFirstZiAfterExplanationPage() {
    if ((typingType == TypingType.FirstTyping || typingType == TypingType.LeadComponents || typingType == TypingType.ExpandedReview) && currentIndex == 0) {
      String typeChar = InputZiManager.getEitherCharFromCurrentId(
        typingType!, 1 /*currentIndex*/, widget.lessonId); // skip the '0' position placeholder one
      TextToSpeech.speak("zh-CN", typeChar);
    }
  }

  @override
  initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {});

    //_focusNode.addListener(_onFocusChange);

    _controller.addListener(handleKeyInput);
    _controllerStandard.addListener(handleKeyInputStandard);
    _progressValue = 0.0;
    typingType = widget.typingType;
    wordsStudy = widget.wordsStudy;
    isSoundPrompt = widget.isSoundPrompt;
    inputMethod = widget.inputMethod;
    includeSkipSection = widget.includeSkipSection;
    showSwitchMethod = widget.showSwitchMethod;
    theInputZiManager.setCurrentType(typingType, wordsStudy);
    totalQuestions =
        theInputZiManager.getTotal(widget.typingType, widget.lessonId);

    //if (typingType == TypingType.Custom) {
    //  wordsStudy = ThirdPartyLesson.divideLongSentences(wordsStudy);
    //}

    // start over every time. not worth the confusion otherwise.
    theInputZiManager.initCurrentIndex();

    // first char, put here instead of Build so that it does only once.
    if (typingType != TypingType.FreeTyping &&
        typingType != TypingType.DicSearchTyping) {
      String typeChar;
      if (isSoundPrompt) {
        typeChar = InputZiManager.getEitherCharFromCurrentId(
            typingType!, 0 /*currentIndex*/,
            widget.lessonId); // custom, and sound prompt
        speakHanziAndPhrase(typeChar);
      }
      else if (typingType == TypingType.FromLessons) {
        var sentenceList = theLessonList[widget.lessonId].sentenceList;
        TextToSpeech.speak(
            "zh-CN", theSentenceList[sentenceList[0]].conv);
      }
      else if (typingType == TypingType.ThirdParty) {
        PrimitiveWrapper charIndex = PrimitiveWrapper(-1);
        String sentence = ThirdPartyLesson.getCurrentSentenceAndCharIndex(
            0, charIndex);
        TextToSpeech.speak(
            "zh-CN", sentence);
      }
      else if (typingType == TypingType.Custom) {
        PrimitiveWrapper charIndex = PrimitiveWrapper(-1);
        String sentence = ThirdPartyLesson.getSentenceAndCharIndex(wordsStudy, 0, charIndex);

        TextToSpeech.speak(
            "zh-CN", sentence);
      }
      else {
        if (!((typingType == TypingType.FirstTyping || typingType == TypingType.LeadComponents || typingType == TypingType.ExpandedReview) && (currentIndex == -1))) {
          typeChar = InputZiManager.getEitherCharFromCurrentId(
            typingType!, 0 /*currentIndex*/, widget.lessonId);
          TextToSpeech.speak("zh-CN", typeChar);
        }
      }
    }

    showHint = widget.showHint; // this is the default
    initHintSelected();

    setState(() {
      updateCounter = 0;
      currentIndex = theInputZiManager.getCurrentIndex(typingType);
    });
  }

  @override
  void dispose() {
    _scrollController!
        .dispose(); // it is a good practice to dispose the controller
    //_focusNode.removeListener(_onFocusChange);
    //showZiCandidates = false;
    _focusNode.dispose();
    super.dispose();
  }

  // Need more work if want this feature, not turn on yet
  /*
  void _onFocusChange() {
    if(_focusNode.hasFocus && !showZiCandidates) {
      setState(() {
        showZiCandidates = true;
      });
    }
    else if (!_focusNode.hasFocus && showZiCandidates) {
      setState(() {
        showZiCandidates = false;
      });
    }

    debugPrint("Focus: ${_focusNode.hasFocus.toString()}");
  }
  */

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
      overlayEntry!.remove();
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

  String getNextToLatestInputLetter() {
    var newInputText = "";
    var selectionEnd;

    if (_controller.value.text != null && _controller.value.text.length != 0) {
      selectionEnd = _controller.value.selection.end;
      if (selectionEnd >= 2) {
        return _controller.value.text.substring(selectionEnd - 2, selectionEnd -1);
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
      newInputText += InputZiManager.removePinyin(candidateZiString);
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

  /*
  showOverlay(BuildContext context, String latestOverleyLetter
      //InputZiOverlayParameters overlayParameters
      //TypingType type, int index, bool isFullComponents, String fullComponentsLetter) {
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
        imageHeight = 150.0 * getSizeRatio(); //135
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
      overlayState.insert(overlayEntry!);
      previousOverlayLetter = latestOverleyLetter;
    }
    else {
      previousOverlayLetter =
      ""; // this time no display = dismiss the display; prepare for next time to re-display
    }
  }
  */

  String getFullComposingText(int startComposing, int endComposing) {
    var str = "";
    if (endComposing > startComposing) {
      // adding an error fixing mechanism
      if (endComposing > _controller.value.text.length) {
        endComposing = _controller.value.text.length;
      }
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

  checkAndUpdateCurrentIndex(TextEditingController editController, String newChar) {
    //theTrieManager.find('test');

    // for guarded typing
    if (typingType != TypingType.FreeTyping && typingType != TypingType.DicSearchTyping) {
      var checkedText = newChar;
      if (checkedText.length == 0) {
        checkedText = editController.text;
      }

      if (showHint == HintType.TingDa) {
        listenModeTypedOneSentence += newChar;
      }

      if (showHint != HintType.TingDa && theInputZiManager.doesTypingResultContainTheZi(
          typingType, currentIndex, checkedText/*edidController.text*/, lessonId)) {
        if (editController == _controller) {
          initHintSelected(); // reset the hint selection parameters
        }

        int numberOfCharsTyped = 1; // default is typing 1 char
        if (typingType == TypingType.Custom || typingType == TypingType.ThirdParty) {
          var remainingSubstring = InputZiManager.getRemainingChars(
              typingType!, currentIndex, wordsStudy);
              numberOfCharsTyped = InputZiManager.calculateHowManyTyped(
              checkedText, remainingSubstring);
          if (numberOfCharsTyped < 1) {
            numberOfCharsTyped = 1; // loose count for 1 which is already verified earlier
          }
        }

        totalAccurateCount += numberOfCharsTyped;

        // tell Flutter to refresh with the next index
        setState(() {
          if ((currentIndex + numberOfCharsTyped) ==
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
            showCompletedDialog(currentBuildContext!);
          }
          else {
            currentIndex =
                theInputZiManager.getNextIndex(
                    typingType, currentIndex, lessonId, numberOfCharsTyped);
            String typeChar = InputZiManager.getEitherCharFromCurrentId(
                typingType!, currentIndex, lessonId);

            if (isSoundPrompt) { // custom, and sound prompt
              speakHanziAndPhrase(typeChar);
            }
            else if(typingType == TypingType.FromLessons) {
              var sentenceIndex = PrimitiveWrapper(0);
              var charIndex = PrimitiveWrapper(0);
              var oneLesson = theLessonList[lessonId];
              oneLesson.getSentenceAndCharIndex(
                  currentIndex, sentenceIndex, charIndex);
              if (charIndex.value == 0) {
                TextToSpeech.speak(
                    "zh-CN", theSentenceList[sentenceIndex.value].conv);
              }
              else {
                TextToSpeech.speak("zh-CN", typeChar);
              }
            }
            else if(typingType == TypingType.ThirdParty) {
              var charIndex = PrimitiveWrapper(0);
              String sentence = ThirdPartyLesson.getCurrentSentenceAndCharIndex(
                  currentIndex, charIndex);
              if (charIndex.value == 0) {
                TextToSpeech.speak(
                    "zh-CN", sentence);
              }
              else {
                TextToSpeech.speak("zh-CN", sentence[charIndex.value]);
              }
            }
            else if (typingType == TypingType.Custom) {
              PrimitiveWrapper charIndex = PrimitiveWrapper(-1);
              String sentence = ThirdPartyLesson.getSentenceAndCharIndex(wordsStudy, currentIndex, charIndex);
              if (charIndex.value == 0) {
                TextToSpeech.speak("zh-CN", sentence);
              }
              else {
                TextToSpeech.speak("zh-CN", sentence[charIndex.value]);
              }
            }
            else {
                TextToSpeech.speak("zh-CN", typeChar);
            }
          }
        });
        //       return;
      }
    }
  }

  String getCurrentSentence(TypingType typingType) {
    String sentence = '';

    if(typingType == TypingType.FromLessons) {
      var sentenceIndex = PrimitiveWrapper(0);
      var charIndex = PrimitiveWrapper(0);
      var oneLesson = theLessonList[lessonId];
      oneLesson.getSentenceAndCharIndex(
        currentIndex, sentenceIndex, charIndex);
      sentence = theSentenceList[sentenceIndex.value].conv;
    }
    else if(typingType == TypingType.ThirdParty) {
      var charIndex = PrimitiveWrapper(0);
      sentence = ThirdPartyLesson.getCurrentSentenceAndCharIndex(
      currentIndex, charIndex);
    }
    else if (typingType == TypingType.Custom) {
      PrimitiveWrapper charIndex = PrimitiveWrapper(-1);
      sentence = ThirdPartyLesson.getSentenceAndCharIndex(wordsStudy, currentIndex, charIndex);
    }

    return sentence;
  }

  void handleArrowCandidate(int selectionIndex) {
    if (selectionIndex == (InputZiManager.maxTypingCandidates+1)) { // '>'
      // if empty text, therefore no non-default candidates yet, then skip
      if (_controller.text.length > 0) {
        //if ((candidateGroupIndex + 1) * InputZiManager.maxTypingCandidates < fullZiCandidates!.length) {
        int tempNextStartingIndex = InputZiManager.getFullCandidateNextStartingIndex(fullZiCandidates!, fullCandidateStartingIndex, true/*forwardArrlow*/);
        if(tempNextStartingIndex > 0) {
            //candidateGroupIndex++;
            fullCandidateStartingIndex = tempNextStartingIndex;
            setState(() {
              theCurrentZiCandidates = InputZiManager.getCurrentFromFullZiCandidates(fullZiCandidates!, fullCandidateStartingIndex);
              theCurrentZiCandidates = InputZiManager.removeDupCandidates(theCurrentZiCandidates);
              isFromArrowCandidate = true;
              updateCounter++;
            });
        }
      }
    }
    else if (selectionIndex == InputZiManager.maxTypingCandidates) { // '<'
      //if (candidateGroupIndex > 0) {
      if (fullCandidateStartingIndex > 0) {
        //candidateGroupIndex--;
        fullCandidateStartingIndex = InputZiManager.getFullCandidateNextStartingIndex(fullZiCandidates!, fullCandidateStartingIndex, false/*backward Arrlow*/);
        setState(() {
          theCurrentZiCandidates = InputZiManager.getCurrentFromFullZiCandidates(fullZiCandidates!, fullCandidateStartingIndex);
          theCurrentZiCandidates = InputZiManager.removeDupCandidates(theCurrentZiCandidates);
          isFromArrowCandidate = true;
          updateCounter++;
        });
      }
    }
  }

  void setTextByChosenZiIndex(int selectionIndex, bool isFromCharCandidateList,
      bool isFromOverlay, bool isFromNumber) {
    if (isFromCharCandidateList && selectionIndex >= InputZiManager.maxTypingCandidates) {
      return handleArrowCandidate(selectionIndex);
    }
    fullCandidateStartingIndex = 0;
    initOverlay();

    hasVerifiedToBeALowerCase = false;

    // pronounce the typed char
    var typedZiString = '';
    //if (typingType != TypingType.FreeTyping && typingType != TypingType.DicSearchTyping) {
      //typedZiString = InputZiManager.getCandidateZiString(selectionIndex)!;
      //TextToSpeech.speak("zh-CN", typedZiString);
      var candidateZiString = InputZiManager.getCandidateZiString(selectionIndex);
      if (candidateZiString != null) {
        typedZiString = InputZiManager.removePinyin(candidateZiString);
      }
    var candidateCharLength = typedZiString.characters.length; //theCurrentZiCandidates[selectionIndex].characters.length;
    //}

    var newText = getInputText(selectionIndex, isFromNumber);

    //String newChar = getNewChar(previousText, newText);
    previousText = newText;
    if (isFromCharCandidateList) {
      // in this case, it has no chance to go through handleKeyInputHelper to set the init value. Therefore we are setting it specifically.
      initialControllerTextValue = "newText";
    }

    // reset the candidate. might set to global ini value
    fullZiCandidates = []; //theDefaultZiCandidates;
    theCurrentZiCandidates = []; //theDefaultZiCandidates;

    var selectionPosi = getCursorPosition(
        candidateCharLength, isFromCharCandidateList, isFromOverlay);
    previousEndSelection = selectionPosi; //_controller.value.selection.end;

    _controller.value = _controller.value.copyWith(text: newText,
          composing: TextRange.empty,
          selection: TextSelection.collapsed(offset: selectionPosi));

    if (kIsWeb) {
      _focusNode.requestFocus(); // without this line, phone would still focus on TextField, but web cursor would disappear.
      Future.delayed(Duration(milliseconds: 100), ()
      {
        // make sure to select nothing
        _controller.selection = TextSelection(baseOffset: selectionPosi,
          extentOffset: selectionPosi, );
      });
    }

    previousStartComposing = -1;
    previousEndComposing = -1;

    //showHint = 0;

    checkAndUpdateCurrentIndex(_controller, typedZiString);

    //restart a typing cycle
    InputZiManager.previousFirstPositionList.clear();

    // reset hint status and index
    updateTypingStatusAndHintCompIndex('');
  }

  // delete process doesn't call this
  String getNewChar(String previousText, String newText) {
    String previousOneChar;
    String newOneChar = '';
    int previousLength = previousText.characters.length;

    for (int i = 0; i < newText.characters.length; i++) {
      newOneChar = newText.characters.elementAt(i); //newText.substring(i, i + 1);
      if ((previousLength - 1) < i) {
        return newOneChar;
      }
      previousOneChar = previousText.characters.elementAt(i); //previousText.substring(i, i + 1);

      if (previousOneChar != newOneChar) {
        return newOneChar;
      }
    }

    return '';
  }

  void handleKeyInput() {
    handleKeyInputHelper(0);
  }

  void handleKeyInputStandard() {
         checkAndUpdateCurrentIndex(_controllerStandard, '');
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
    if (_controller.text == initialControllerTextValue && !InputZiManager.isLastLetterArrow(_controller.text)) {
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
      if (_controller.value.text.characters.length < previousText.characters.length) {
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
      fullCandidateStartingIndex = 0;

      initOverlay();

      setPreviousComposing();

      setTextByChosenZiIndex(selectionIndex, false, false, false);
      updateTypingStatusAndHintCompIndex('');
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
      fullCandidateStartingIndex = 0;
      initOverlay();
      /*
      if (_controller.text.length == 0) {
        // don't allow to remove the default character value of '>' at the beginning to work around an Android issue as described earlier
        _controller.value = _controller.value.copyWith(text: '>',
            composing: TextRange.empty,
            selection: TextSelection.collapsed(offset: 1));
      }
      */
      /*else */if ((previousEndComposing - previousStartComposing) > 1) {
        previousEndComposing--;
        var composingText = getFullComposingText(
            previousStartComposing, previousEndComposing);
        fullZiCandidates = InputZiManager.getZiCandidates(composingText)!;
        theCurrentZiCandidates = InputZiManager.getCurrentFromFullZiCandidates(fullZiCandidates!, fullCandidateStartingIndex);
        theCurrentZiCandidates = InputZiManager.removeDupCandidates(theCurrentZiCandidates);
        InputZiManager.updateFirstCandidate(
            theCurrentZiCandidates, InputZiManager.previousFirstPositionList);
        previousText = _controller.text;
        //currentComposingText = previousText;
        var lastComposingText = InputZiManager.getLastComposingTextAfterDelete(previousText);
        updateTypingStatusAndHintCompIndex(lastComposingText);
      }
      else {
        previousStartComposing = -1;
        previousEndComposing = -1;
        theCurrentZiCandidates = []; // theDefaultZiCandidates;
        previousText = _controller.text;
        //currentComposingText = previousText;
        var lastComposingText = InputZiManager.getLastComposingTextAfterDelete(previousText);
        updateTypingStatusAndHintCompIndex(lastComposingText);
      }
    }
    //Note: Temp disable UpperCase and LowerCase if want to test component shapes
    else if (/*Utility.isAUpperCaseLetter(latestInputKeyLetter) ||*/ Utility.isArrow(latestInputKeyLetter)) { // space key
      //if (Utility.isAUpperCaseLetter(latestInputKeyLetter)) {
      //  showOverlay(context, latestInputKeyLetter);
      //}
      /*else */if (Utility.isForwardArrow(latestInputKeyLetter)) {
        // if just '>' char with text length of 1, no non-default candidates yet, there skip
        if (_controller.text.length != 1) {
          int tempNextStartingIndex = InputZiManager.getFullCandidateNextStartingIndex(fullZiCandidates!, fullCandidateStartingIndex, true/*forwardArrlow*/);
          if(tempNextStartingIndex > 0) {
            fullCandidateStartingIndex = tempNextStartingIndex;
          }
          //if ((candidateGroupIndex + 1) * InputZiManager.maxTypingCandidates < fullZiCandidates!.length) {
            //candidateGroupIndex++;
          //}
        }
      }
      else if (Utility.isBackArrow(latestInputKeyLetter)) {
        if (fullCandidateStartingIndex > 0) {
          fullCandidateStartingIndex = InputZiManager.getFullCandidateNextStartingIndex(fullZiCandidates!, fullCandidateStartingIndex, false/*forwardArrlow*/);;
        }
        //if (candidateGroupIndex > 0) {
        //  candidateGroupIndex--;
        //}
      }

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

      if (Utility.isArrow(latestInputKeyLetter)) {
        theCurrentZiCandidates = InputZiManager.getCurrentFromFullZiCandidates(fullZiCandidates!, fullCandidateStartingIndex);
        theCurrentZiCandidates = InputZiManager.removeDupCandidates(theCurrentZiCandidates);
      }
    }
    else if (isNumberOneToSeven(latestInputKeyLetter)) {
      if (theCurrentZiCandidates != null && theCurrentZiCandidates.length != 0) {
        //TODO: make default mode not selectable for a candidate
        //  Candidate list have to be brought up by lower case letter only!
        //String nextToLast = getNextToLatestInputLetter();
        //if (nextToLast is a2 lower case letter) {
        //if (_controller.text != previousText) {
        fullCandidateStartingIndex = 0;
        initOverlay();
        //}

        previousEndComposing += 1;
        setTextByChosenZiIndex(
            getZeroBasedNumber(latestInputKeyLetter), false, false, true);
        //}
      }
    }
    else if (Utility.isALowerCaseLetter(latestInputKeyLetter)) {
      if (firstTypedLetterHintType == HintType.None) {
        firstTypedLetterHintType = showHint;
      }

      fullCandidateStartingIndex = 0;
      hasVerifiedToBeALowerCase = true;
      initOverlay();
      setPreviousComposing();

      var composingText = getFullComposingText(
          previousStartComposing, previousEndComposing);

      //currentComposingText = composingText;
      fullZiCandidates = InputZiManager.getZiCandidates(composingText)!;

      InputZiManager.updateFirstCandidate(
          fullZiCandidates!, InputZiManager.previousFirstPositionList);
      theCurrentZiCandidates = InputZiManager.getCurrentFromFullZiCandidates(fullZiCandidates!, fullCandidateStartingIndex);
      theCurrentZiCandidates = InputZiManager.removeDupCandidates(theCurrentZiCandidates);
      if (theCurrentZiCandidates == null) {
        List<String> composingList = [composingText];
        theCurrentZiCandidates = composingList;
      }
      previousText = _controller.text;
      updateHintAfterANewLetter(composingText);
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
    else if (Utility.specialChar(latestInputKeyLetter)) {
      String convertedSpecialChar = Utility.convertSpecialCharToChineseForm(latestInputKeyLetter);
      String updatedText = Utility.updateSpecialCharValue(latestInputKeyLetter, _controller.value.text);
      _controller.value = _controller.value.copyWith(text: updatedText,
          composing: TextRange.empty/*,
          selection: TextSelection.collapsed(offset: selectionPosi)*/);
      checkAndUpdateCurrentIndex(_controller, convertedSpecialChar);
    }
    else {
      // Note: in case of a single line editor, it doesn't seem to take this value which makes sense.
      //TODO: for single line typing exercise, I won't be able to support real English letters.
      //    I should eliminate such chars and I should eliminate chars beyond my 8,105 chars.
      if (latestInputKeyLetter == "\n") {  // "enter" key
        if (theCurrentZiCandidates != null && theCurrentZiCandidates.length != 0) {
          // Hit 'Enter/new line' key in the middle of composing a character indicated by candidates length,
          // just remove the return key and stay there without moving to next line
          String textTrimReturnKey = _controller.text.replaceRange(previousEndComposing, previousEndComposing+1, ''); //_controller.text.substring(0, previousEndComposing);
          _controller.value = _controller.value.copyWith(text: textTrimReturnKey,
              composing: TextRange.empty, selection: TextSelection.collapsed(offset: previousEndComposing));
        }
      }
      initOverlay();
      fullCandidateStartingIndex = 0;
      previousStartComposing = -1;
      previousEndComposing = -1;
      theCurrentZiCandidates = []; //theDefaultZiCandidates;
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
      str = getString(theZiForLeadCompExerciseList[currentIndex].hintText);
      title = getString(100);
      buttonText = getString(109);
    }
    else if (typingType == TypingType.ExpandedReview) {
      str = getString(theZiForExpandedReviewExerciseList[currentIndex].hintText);
      title = getString(308);
    }
    else if (typingType == TypingType.ExpandedGeneral) {
      str = getString(theZiForExpandedGeneralExerciseList[currentIndex].hintText);
      title = getString(334);
    }
    else if (typingType == TypingType.AttachedComponents) {
      str = getString(theZiForAttachedCompExerciseList[currentIndex].hintText);
      title = getString(393);
    }
    else if (typingType == TypingType.TwinComponents) {
      str = getString(theZiForTwinCompExerciseList[currentIndex].hintText);
      title = getString(329);
    }
    else if (typingType == TypingType.SubComponents) {
      str = getString(theZiForSubCompExerciseList[currentIndex].hintText);
      title = getString(330);
    }
    //else if (typingType == TypingType.SingleComponent) {
    //  str = getString(theZiForSingleCompExerciseList[currentIndex].hintText);
    //  title = getString(331);
    //}
    else if (typingType == TypingType.FirstTyping) {
      str = getString(theZiForFirstTypingExerciseList[currentIndex].hintText);
      title = getString(511);
    }
    else if (typingType == TypingType.TwoComponents) {
      str = getString(theZiForTwoCompExerciseList[currentIndex].hintText);
      title = getString(332);
    }
    else if (typingType == TypingType.GeneralExercise) {
      str = getString(theZiForGeneralExerciseList[currentIndex].hintText);
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
            Container(
              alignment: Alignment.topRight,
              child: getSkipThisSection(),
            ),
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
                    //TextToSpeech.speak("zh-CN", "好"/*typingChar*/);
                    speakFirstZiAfterExplanationPage();
                    setState(() {
                      //currentIndex = 1;
                      currentIndex = theInputZiManager.getNextIndex(typingType, currentIndex, lessonId, 1); //skip first non-real entry
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
      // Not show since the keyboard is confusion to users
      //image = theZiForLeadCompExerciseList[currentIndex].hintImage;
      //width = 350.0 * getSizeRatio();
      //height = 150.0 * getSizeRatio();
    }
    else if (typingType == TypingType.ExpandedReview) {
      image = theZiForExpandedReviewExerciseList[currentIndex].hintImage;
    }
    else if (typingType == TypingType.ExpandedGeneral) {
      image = theZiForExpandedGeneralExerciseList[currentIndex].hintImage;
    }
    else if (typingType == TypingType.AttachedComponents) {
      width = 300.0 * getSizeRatio();
      height = 120.0 * getSizeRatio();
      image = theZiForAttachedCompExerciseList[currentIndex].hintImage;
    }
    else if (typingType == TypingType.TwinComponents) {
      width = 300.0 * getSizeRatio();
      height = 120.0 * getSizeRatio();
      image = theZiForTwinCompExerciseList[currentIndex].hintImage;
    }
    else if (typingType == TypingType.SubComponents) {
      image = theZiForSubCompExerciseList[currentIndex].hintImage;
    }
    //else if (typingType == TypingType.SingleComponent) {
    //  image = theZiForSingleCompExerciseList[currentIndex].hintImage;
    //}
    else if (typingType == TypingType.FirstTyping) {
      image = theZiForFirstTypingExerciseList[currentIndex].hintImage;
    }
    else if (typingType == TypingType.TwoComponents) {
      image = theZiForTwoCompExerciseList[currentIndex].hintImage;
    }
    else if (typingType == TypingType.GeneralExercise) {
      image = theZiForGeneralExerciseList[currentIndex].hintImage;
    }

    if (image != null && image.isNotEmpty) {
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
    //if (/*showHint == 0 &&*/ !isFromArrowCandidate) {
    //   theCurrentZiCandidates = theDefaultZiCandidates;
    //} // set it to default

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
      maxNumberOfLines = 10;  // 4
      editFontSize = 24 * getSizeRatio();
    }
    else {
      maxNumberOfLines = 1;
      _progressValue = currentIndex/totalQuestions;
    }

    currentBuildContext = context;

    //   typingType = widget.typingType; //theComponentManager.getCurrentType();
//    theInputZiManager.setCurrentType(typingType); //TODO: should pass as a parameter in painter?

    var leftArrowColor; // black is default
    // if the first one, no way to go left
    if (fullCandidateStartingIndex == 0) {
      leftArrowColor = Colors.grey;
    }
    else {
      leftArrowColor = Colors.black;
    }

    var rightArrowColor; // black is default
    if (fullZiCandidates == null) {
      rightArrowColor = Colors.grey;
    }
    else {
      //int candidateGroupCount = (fullZiCandidates!.length / InputZiManager.maxTypingCandidates).ceil();  //toInt();
      // if it's the last one, no way to go right.
      //if (candidateGroupIndex == (candidateGroupCount - 1)) {
      //if((fullCandidateStartingIndex + InputZiManager.maxTypingCandidates) >= fullZiCandidates!.length) {
      if (InputZiManager.isLastGroupOfCandidates(fullZiCandidates!, fullCandidateStartingIndex))  {
        rightArrowColor = Colors.grey;
      }
      else {
        rightArrowColor = Colors.black;
      }
    }

    var inputZiPainter = InputZiPainter(
        lineColor: leftArrowColor,
        completeColor: rightArrowColor,
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
    else if (typingType == TypingType.FirstTyping) {
      title = getString(511)/*'Character with First Hanzi'*/;
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
    else if (typingType == TypingType.DicSearchTyping) {
      title = getString(95)/*'Dictionary'*/;
    }
    else if (typingType == TypingType.CommonZiTyping) {
      title = getString(112)/*'Customized exercises'*/;
    }
    else if (typingType == TypingType.FromLessons) {
      title = getString(253)/*'Typing exercises'*/;
    }
    else if (typingType == TypingType.CommonZiTyping) {
      title = getString(112)/*'Customized exercises'*/;
    }
    else if (typingType == TypingType.Custom) {
      title = getString(409)/*'Study customized words'*/;
    }
    else if (typingType == TypingType.ComponentTyping) {
      title = getString(413)/*'Practice typing by component characteristics'*/;
    }
    else if (typingType == TypingType.ComponentCombinationTyping) {
      title = getString(529) + " (" + wordsStudy + ")"; /*'Basic Hanzishu Typing Exercises'*/
    }
    else if (typingType == TypingType.ThirdParty) {
      title = getString(518)/*'Typing exercises'*/;
    }

    // first index is for explaination
    if (typingType != TypingType.FromLessons && typingType != TypingType.ThirdParty && typingType != TypingType.CommonZiTyping && typingType != TypingType.FreeTyping && typingType != TypingType.DicSearchTyping && typingType != TypingType.Custom && typingType != TypingType.ComponentTyping && typingType != TypingType.ComponentCombinationTyping && currentIndex == 0) {
      return getExplainationPage();
    }

    var editFieldFontRatio = getSizeRatio();
    if (editFieldFontRatio > 1.7) { // otherwise iPad Pro 12.9" would have a huge char size in EditField
      editFieldFontRatio /= 1.3;
    }

    var fieldWidth = double.infinity;
    if (typingType == TypingType.DicSearchTyping) {
      fieldWidth = 80.0 * getSizeRatio();
    }

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(title),
        ),
      body: Container(
        child: SingleChildScrollView( // was trying to use this trying to avoid the issue of pushing content up in Android browser
                                        // didn't help but didn't hurt, so leave it here for future flexibility.
          controller: _scrollController,
          //physics: NeverScrollableScrollPhysics(), // Didn't work: not allow to scroll to avoid the issue of pushing content up in Andorid browser
          scrollDirection: Axis.vertical,
          child: WillPopScope( // for dismissing overlay menu only when hitting back arrow
            child:
                  getTypingContent(fieldWidth, editFieldFontRatio, editFontSize, maxNumberOfLines, inputZiPainter),
              onWillPop: _onWillPop
          ),
        ),
      ),
    );
  }

  Column getTypingContent(double fieldWidth, double editFieldFontRatio, double editFontSize, int maxNumberOfLines, InputZiPainter inputZiPainter) {
    if (typingType == TypingType.DicSearchTyping)
    {
      return getDicSearchTyping(fieldWidth, editFieldFontRatio, editFontSize, maxNumberOfLines, inputZiPainter);
    }
    else
    {
      return getRegularOneTyping(fieldWidth, editFieldFontRatio, editFontSize, maxNumberOfLines, inputZiPainter);
    }
  }

  Column  getDicSearchTyping(double fieldWidth, double editFieldFontRatio, double editFontSize, int maxNumberOfLines, InputZiPainter inputZiPainter) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,   //spaceAround,
      //mainAxisSize:  MainAxisSize.max,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: 30 * getSizeRatio()),
                Text(getString(486), textAlign:TextAlign.left),
              ]
          ),
          SizedBox(height: 15.0),
          getDicSearchFirstZi(),
          SizedBox(height: 15.0),
          Row(mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 30 * getSizeRatio()),
              Text("2. " + getString(484), textAlign:TextAlign.left),
            ]
          ),
          getOtherInputMethodTextField(_controllerStandard, true),
          SizedBox(height: 15.0),
          Row(mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: 30 * getSizeRatio()),
                Text("3. " + getString(485), textAlign:TextAlign.left, maxLines: 2, softWrap: true),
              ]
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: 30 * getSizeRatio()),
                Text(getString(487), textAlign:TextAlign.left, maxLines: 2, softWrap: true),
              ]
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 30.0),
              getHanzishuTextField(fieldWidth, editFieldFontRatio, editFontSize, maxNumberOfLines),
              getQueryButton(_controller, true),
            ]
          ),
          getZiCandidates(inputZiPainter),
        ]
    );
  }

  Column getRegularOneTyping(double fieldWidth, double editFieldFontRatio, double editFontSize, int maxNumberOfLines, InputZiPainter inputZiPainter) {
    if (inputMethod == InputMethod.Pinxin) {
      return Column(
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        //mainAxisSize:  MainAxisSize.max,
          children: <Widget>[
            //Spacer(),
            getHintLabelRelated(),
            getHelpOrProgressIndicator(),
            Row(
              children: <Widget>[
                SizedBox(width: 10),
                //Container(
                //  alignment: Alignment.topLeft,
                //  child: getShortTypingTitle(),
                //),
                //SizedBox(width: 10),
                Container(
                  //alignment: Alignment.topRight,
                  child: getSwitchInputMethodOrInputModeMessage(),
                ),
                SizedBox(width: 100.0 * getSizeRatio()), //push skip section into right
                Container(
                  alignment: Alignment.topRight,
                  child: getSkipThisSection(),
                ),
              ]
            ),
            getInputPrompt(),
            // Divider(color: Colors.brown,),
            getHintPainter(),
            SizedBox(height: 10),
            getHanzishuTextField(
                fieldWidth, editFieldFontRatio, editFontSize, maxNumberOfLines),
            getZiCandidates(inputZiPainter),
            //SizedBox(
            //  height: 40.0, //40
            //),
            //SizedBox(
            //    child: getContinue(),
            //),
            // getImageTiedToZi() TODO: not showing image anymore, one can't do two things at the same time.
          ]
      );
    }
    else { // other input methods
      return Column(
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        //mainAxisSize:  MainAxisSize.max,
          children: <Widget>[
            //Spacer(),
            getHelpOrProgressIndicator(),
            Row(
                children: <Widget>[
                  SizedBox(width: 10),
                  Container(
                    alignment: Alignment.topLeft,
                    child: getShortTypingTitle(),
                  ),
                  //SizedBox(width: 10),
                  Container(
                    //alignment: Alignment.topRight,
                    child: getSwitchInputMethod(),
                  ),
                  //SizedBox(width: 10),
                  Container(
                    alignment: Alignment.topRight,
                    child: getSkipThisSection(),
                  ),
                ]
            ),
            getInputPrompt(),
            SizedBox(height: 30.0),
            getOtherInputMethodTextField(_controllerStandard, false),
            SizedBox(height: 40.0),
          ]
      );
    }
  }

  Widget getSwitchInputMethodOrInputModeMessage() {
    if (showSwitchMethod) {
      return getSwitchInputMethod();
    }
    else {
      return getWarningMessage(); //Text(getString(503), style: TextStyle(color: Colors.lightBlue));
    }
  }

  Widget getSwitchInputMethod() {
    return TextButton(
      onPressed: () {
        if (inputMethod == InputMethod.Others) {
          setState(() {
            inputMethod = InputMethod.Pinxin;
          });
        }
        else if (inputMethod == InputMethod.Pinxin) {
          setState(() {
            inputMethod = InputMethod.Others;
          });
        }
      },
      child: Text(getString(493),
          style: TextStyle(color: Colors.brown)),
    );
  }

  Widget getShortTypingTitle() {
    String switchLabel;
    if (inputMethod == InputMethod.Pinxin) {
      switchLabel = getString(494); // puzzle typing. oopposite from the current value
    }
    else { // others
      switchLabel = getString(495); // other input methods
    }

    return Text(switchLabel, style: TextStyle(color: Colors.lightBlue/*, fontSize: 15 * getSizeRatio()*/));
  }

  Widget getHanzishuTextField(double fieldWidth, double editFieldFontRatio, double editFontSize, int maxNumberOfLines) {
    return SizedBox(
      width: fieldWidth, //double.infinity,
      //height: 120,
      child: TextField(
        autocorrect: false,
        enableSuggestions: false,
        controller: _controller,
        focusNode: _focusNode,
        autofocus: true,
        cursorColor: Colors.black,
        //autocorrect: false,
        //enableSuggestions: false,
        //enableInteractiveSelection: false,
        //toolbarOptions: ToolbarOptions(
        //  copy: false,
        //  cut: false,
        //  paste: false, // Disables the paste button
        //  selectAll: false,
        //),

        //contextMenuBuilder: (BuildContext context, EditableTextState editableTextState) {
        //  return AdaptiveTextSelectionToolbar.editable(
        //    anchors: editableTextState.contextMenuAnchors,
        //    clipboardStatus: ClipboardStatus.notPasteable,
            // to apply the normal behavior when click on copy (copy in clipboard close toolbar)
            // use an empty function `() {}` to hide this option from the toolbar
        //    onCopy: () => editableTextState
        //        .copySelection(SelectionChangedCause.toolbar),
            // to apply the normal behavior when click on cut
        //    onCut: () => editableTextState
        //        .cutSelection(SelectionChangedCause.toolbar),
        //    onPaste: () {
              // HERE will be called when the paste button is clicked in the toolbar
              // apply your own logic here

              // to apply the normal behavior when click on paste (add in input and close toolbar)
              // editableTextState.pasteText(SelectionChangedCause.tap);
        //    },
            // to apply the normal behavior when click on select all
        //    onSelectAll: () =>
        //        editableTextState.selectAll(SelectionChangedCause.toolbar),
        //    onLookUp: () {},
        //      onSearchWeb: () {},
        //    onShare: () {},
        //    onLiveTextInput: () {},
        //  );
        //},

        // 1. disable the "Paste" button in popup menu
        //contextMenuBuilder:(context, state) {
        //  return AdaptiveTextSelectionToolbar.buttonItems(anchors: state.contextMenuAnchors,
        //      buttonItems: state.contextMenuButtonItems..removeWhere((item) =>
        //      item.type == ContextMenuButtonType.paste),);
        //},
        // 2. disable physical keyboard shorts (Ctrl+V / Cmd+V)
        //onAppPrivateCommand: (command, args) {
        //  return;
        //},

        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: '', //'Full Name',
        ),
        style: TextStyle(
            fontSize: editFontSize * editFieldFontRatio, // 35
            height: 1.0 // 1.3
        ),
        maxLines: maxNumberOfLines,
        //expands: true,
        keyboardType: TextInputType.multiline,  //TextInputType.visiblePassword
      ),//focusNode: _focusNode,
    );
    //),
  }

  Widget getZiCandidates(InputZiPainter inputZiPainter) {
    //if (!showZiCandidates) {
    //  return SizedBox(width: 0.0, height: 0.0);
    //}

    return SizedBox(
      width: double.infinity,
      height: 40.0 * getSizeRatio(), //40
      child: CustomPaint(
        foregroundPainter: inputZiPainter,
        //size: new Size(screenWidth, 60 /*TODO: more precise. contentLength.value*/),

        //child: Center(
        child: Stack(
          children: createHittestButtons(context, theCurrentZiCandidates),
        ),
        //),
      ),
    );
  }

  Widget getDicSearchFirstZi() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 30 * getSizeRatio()),
          Text("1. ", textAlign:TextAlign.left),
          TextButton(
            style: TextButton.styleFrom(
            textStyle: TextStyle(fontSize: 15.0 * getSizeRatio()),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DictionaryPage(),
              ),
            );
          },
          child: Text(getString(96)/*"First-Hanzi Radical Table"*/,
            style: TextStyle(color: Colors.black)),
          ),
        ]
    );
  }

  // non-Hanzishu input methods?
  Widget getOtherInputMethodTextField(TextEditingController oneController, bool withQueryButton) {
    double fieldWidth = 300.0; //double.infinity;
    if (withQueryButton) {
      fieldWidth = 120.0;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        //SizedBox(width: 20 * getSizeRatio()),
        //Text(getString(96)/*"Basic Table"*/, style: TextStyle(fontSize: 20 * getSizeRatio(), color: Colors.blueGrey), ),
        SizedBox(width: 30 * getSizeRatio()),

        SizedBox(
          width: fieldWidth, // * getSizeRatio(),
          //height: 120,
          // Note: this is the standard for Dic Search only, not related to the Hanzishu typing field.
          child: TextField(
            autocorrect: false,
            enableSuggestions: false,
            controller: oneController,
            focusNode:   _focusNodeStandard,
            autofocus: false,
            style: TextStyle(
              fontSize: 20 * getSizeRatio(),
              //height: 1.0 // 1.3
            ),
            maxLines: 1,
            //expands: true,
            keyboardType: TextInputType.text, //multiline,  //TextInputType.visiblePassword
            decoration: InputDecoration(
              //hintText: 'This test',
              filled: true,
              fillColor: Colors.black12, //lightBlueAccent,
            ),
          ),//focusNode: _focusNodeStandard,
        ),
          getQueryButton(oneController, withQueryButton),
      ],
    );
  }

  Widget getQueryButton(TextEditingController oneController, bool withQueryButton) {
    if (!withQueryButton) {
      return SizedBox(width: 0.0, height: 0.0);
    }

    return Container(
      //height: 25.0 * getSizeRatioWithLimit(), //180
      // width: 25.0 * getSizeRatioWithLimit(),
        child: IconButton(
          icon: Icon(
            Icons.search,   //volume_up,
            size: 50.0 * getSizeRatio(),   // 150
          ),
          color: Colors.lightBlueAccent, //cyan, //Colors.green,
          onPressed: () {
            processZiQuery(oneController);
          },
        )
    );
  }

  processZiQuery(TextEditingController oneController) {
    var latestValue;
    var ziId = -1;
    var text = oneController.value.text;
    if ( text != null && text.length != 0) {
      latestValue = text;
      ziId = DictionaryManager.getSearchingZiId(text);
    }

    if (ziId > 0) {
      oneController.clear();
      FocusScope.of(context).unfocus();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DictionarySearchingPage(
                  dicStage: DictionaryStage.detailedzi,
                  firstOrSearchingZiIndex: ziId,
                  flashcardList: '',
                  dicCaller: DicCaller.Dictionary),
        ),
      );
    }
    else {
      oneController.clear();
      FocusScope.of(context).unfocus();
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
            getString(374)/*cannot find: */ + latestValue + "."),
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

  Widget getSkipThisSection() {
    if (includeSkipSection/*theIsFromLessonContinuedSection || theIsFromTypingContinuedSection || typingType == TypingType.Custom*/) {
      return TextButton(
        child: Text(
          getString(401) /*"Skip this section"*/, style: TextStyle(fontSize: 14.0, color: Colors.blueAccent),),
        //color: Colors.white,
        //textColor: Colors.blueAccent,
        onPressed: () {
          theIsBackArrowExit = false;
          Navigator.of(context).pop();
        },
      );
    }
    else {
      return SizedBox(width: 0, height: 0);
    }
  }
  /*
  Widget getContinue() {
    if (theIsFromLessonContinuedSection || theIsFromTypingContinuedSection) {
      return FlatButton(
        child: Text(
          getString(401) /*"Skip this section"*/, style: TextStyle(fontSize: 14.0),),
        color: Colors.white,
        textColor: Colors.blueAccent,
        onPressed: () {
          theIsBackArrowExit = false;
          Navigator.of(context).pop();
        },
      );
    }
    else {
      return SizedBox(width: 0, height: 0);
    }
  }
*/

  Widget getHelpOrProgressIndicator() {
    if (typingType == TypingType.FreeTyping || typingType == TypingType.DicSearchTyping) {
      return SizedBox(width: 0.0, height: 0.0);

      /*
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
       */
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
                      getString(90)/*"Hint"*/ + ": " + getString(theZiForIntroductionList[currentIndex].hintText) ,
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

  Widget getInputPrompt() {
    // an empty box
    if (typingType == TypingType.FreeTyping || typingType == TypingType.DicSearchTyping) {
      return Container(width: 0.0, height: 0.0);
    }

    var promptStr = getString(113) + "： "; //"Type"
    var fontSize = 13.0 * getSizeRatio();     //15.0

    currentTypingChar = InputZiManager.getEitherCharFromCurrentId(typingType!, currentIndex, lessonId);

      // prepare hint stuff, running once per zi, therefore to put here.
      currentTypingComponentsAndSub =
            ComponentManager.getTypingComponentsAndSubComp(currentTypingChar);
      currentCorrectTypingCode = theComponentManager.getCurrentCorrectTypingCode(currentTypingComponentsAndSub);

    //TextToSpeech.speak("zh-CN", currentTypingChar);

    if (isSoundPrompt) {
      return Row(
          children: <Widget>[
            SizedBox(width: fontSize),
            Text(
                promptStr,
                style: TextStyle(fontSize: fontSize * 1.2),
                textAlign: TextAlign.left
            ),
            SizedBox(
              width: 35.0 * getSizeRatio(), //50
              child: IconButton(
                icon: Icon(
                  Icons.volume_up,
                  size: fontSize * 2 * getSizeRatio(),   // 150
                ),
                color: Colors.cyan, //Colors.green,
                onPressed: () {
                  speakHanziAndPhrase(currentTypingChar);
                }),
            ),
          ]
      );
    }
    else if (typingType == TypingType.FirstTyping || typingType == TypingType.LeadComponents || typingType == TypingType.ExpandedReview || typingType == TypingType.CommonZiTyping || typingType == TypingType.ComponentTyping || typingType == TypingType.ComponentCombinationTyping) {
      if (showHint == HintType.Game) {
        return showGameInput(currentTypingChar);
      }

      return Row(
          children: <Widget>[
            SizedBox(width: fontSize),
            Text(
                promptStr,
                style: TextStyle(fontSize: fontSize * 1.2),
                textAlign: TextAlign.left
              ),

              GestureDetector(
                onTap: () {
                  TextToSpeech.speak("zh-CN", currentTypingChar);
                },
                child: Text(
                  currentTypingChar,
                  style: TextStyle(fontSize: fontSize * 3.0, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                  textAlign: TextAlign.left
                ),
              ),
          ]
      );
    }
    else if (typingType == TypingType.FromLessons || typingType == TypingType.ThirdParty || typingType == TypingType.Custom) {
      if (showHint == HintType.Game) {
        return showGameInput(currentTypingChar);
      }
      else {
        return getInputSentence(typingType!, currentIndex, promptStr, fontSize);
      }
    }
    else {
      return SizedBox(width: 0.0, height: 0.0);
    }
  }

  // Note: TODO this function doesn't handle the case with non-common chinese characters
  // in the sentence which is fine in our current usage. need to use string.characters
  // like in other places in this file if there is a need for it.
  Widget getInputSentence(TypingType typingType, int currentTypingCharsIndex, String promptStr, double fontSize) {
      var sentenceIndex = PrimitiveWrapper(0);
      //var charIndexInSentence = PrimitiveWrapper(0);
      String conv = '';
      if (typingType == TypingType.FromLessons) {
        var oneLesson = theLessonList[lessonId];
        oneLesson.getSentenceAndCharIndex(
            currentTypingCharsIndex, sentenceIndex, charIndexInSentence);
        conv = theSentenceList[sentenceIndex.value].conv;
      }
      else if (typingType == TypingType.ThirdParty) {
        conv = ThirdPartyLesson.getCurrentSentenceAndCharIndex(currentIndex, charIndexInSentence);
      }
      else if (typingType == TypingType.Custom) {
        conv = ThirdPartyLesson.getSentenceAndCharIndex(wordsStudy, currentIndex, charIndexInSentence);
      }

      return Row(
          children:
            getSentenceRowContent(typingType, conv, promptStr, fontSize),
      );
  }

  List<Widget> getSentenceRowContent(TypingType typingType, String conv, String promptStr, double fontSize) {
    List<Widget> contentList = [];

    PrimitiveWrapper charIndex = PrimitiveWrapper(-1);
    String sentence = getCurrentSentence(typingType); //ThirdPartyLesson.getSentenceAndCharIndex(wordsStudy, 0, charIndex);

    contentList.add(SizedBox(width: fontSize));
    contentList.add(Text(
      promptStr,
      style: TextStyle(fontSize: fontSize * 1.1 * getSizeRatio()), //1.2
      textAlign: TextAlign.left
    ));
    contentList.add(IconButton(
      icon: Icon(
        Icons.volume_up,
        size: fontSize * 1.5 * getSizeRatio(),   //
      ),
      color: Colors.cyan, //Colors.green,
      onPressed: () {
        speakHanziAndPhrase(sentence);
      }));
    if (showHint == HintType.TingDa) {
      contentList.add( TextButton(
            //style: ButtonStyle(
            //    backgroundColor: MaterialStateProperty.all(Colors.grey[350])
            //),
            style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero,),backgroundColor: Colors.grey[350]),
            onPressed: () {
              initOverlay();

              setState(() {
                // new sentence: update sentenceFirstCharIndex now
                sentenceFirstCharIndex= theInputZiManager.getNextSentenceFirstIndex(typingType, sentenceFirstCharIndex, lessonId, sentence.length);
                currentIndex = sentenceFirstCharIndex;
                if (currentIndex == -1) {
                  int oneSentenceAccurateCount = InputZiManager.calculateAccurateTypedCount(listenModeTypedOneSentence, sentence);
                  totalAccurateCount += oneSentenceAccurateCount;
                  listenModeTypedOneSentence = ""; // reinit
                  theInputZiManager.initCurrentIndex();
                  showCompletedDialog(currentBuildContext!);
                }
                else {
                  // check how many chars typed for the current sentence before moving to next
                  // compare listenModeTypedOneSentence and sentence
                  int oneSentenceAccurateCount = InputZiManager.calculateAccurateTypedCount(listenModeTypedOneSentence, sentence);
                  totalAccurateCount += oneSentenceAccurateCount;
                  listenModeTypedOneSentence = ""; // reinit
                  speakHanziAndPhrase(getCurrentSentence(typingType));
                  _focusNode
                      .requestFocus(); // Maybe: without this line, phone would still focus on TextField, but web cursor would disapper.
                }
              });
            },
            child: Text(
                getString(532), // Next Sentence
                style: TextStyle(fontSize: fontSize, color: Colors.blueAccent), // 1.6
                textAlign: TextAlign.left //TextAlign.center
            ),
          ));
      //));
    }
    else {
      String strBeforeChar;
      String strChar;
      String strAfterChar;

      var chars = conv.characters;

      if (charIndexInSentence.value == 0) {
        strBeforeChar = '';
      }
      else {
        strBeforeChar = chars.getRange(0, charIndexInSentence.value).toString();
      }
      strChar = chars.getRange(charIndexInSentence.value, charIndexInSentence.value + 1).toString();

      if (charIndexInSentence == chars.length - 1) { // the char is the last one
        strAfterChar = '';
      }
      else {
        strAfterChar = chars.getRange(charIndexInSentence.value + 1, chars.length).toString();
      }

      contentList.add(Text(
          strBeforeChar,
          style: TextStyle(fontSize: fontSize * 1.8 * getSizeRatio(),
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent), //2.0
          textAlign: TextAlign.left
      ));
      contentList.add(GestureDetector(
        onTap: () {
          TextToSpeech.speak("zh-CN", strChar);
        },
        child: Text(
            strChar,
            style: TextStyle(fontSize: fontSize * 2.7 * getSizeRatio(),
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent), // 3.0
            textAlign: TextAlign.left
        ),
      ));
      contentList.add(Text(
          strAfterChar,
          style: TextStyle(fontSize: fontSize * 1.8 * getSizeRatio(),
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent), // 2.0
          textAlign: TextAlign.left
      ));
    }

    return contentList;
  }

  Widget showGameInput(String currentTypingChar) {
    double hei = 160.0; // * getSizeRatio()
    var inputGamePainter = InputGamePainter(
      currentChar: currentTypingChar,
      height: hei,
      screenWidth: screenWidth,
    );

    return SizedBox(
      height: hei,
      width: screenWidth,
      child:  Container(color: Colors.blue,
                      child: CustomPaint(
                        foregroundPainter: inputGamePainter,)),
    );
    /*
    return Text(
        currentTypingChar,
        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
        textAlign: TextAlign.left
    );
    */
  }

  Widget getWarningMessage() {
    var fontSize = 15.0 * getSizeRatio();     //15.0
    if (currentTypingCodeIsCorrect || currentCorrectTypingCode == "" || theZiCandidatesFromPinyin || showHint == HintType.Hint0 || showHint == HintType.Game  || showHint == HintType.TingDa|| typingType == TypingType.FreeTyping) {
      return SizedBox(width: 0.0, height: 0.0);
    }
    else {
      return Text(
          "   " + getString(463), //"Warning: Wrong typing code.",
          style: TextStyle(fontSize: fontSize),
          textAlign: TextAlign.left
      );
    }
  }

  Widget getHintLabelRelated() {
    if (currentIndex < 0) {
      return Container(width:0.0, height: 0.0);
    }

    // an empty box
    if (typingType == TypingType.FreeTyping || typingType == TypingType.DicSearchTyping) {
      return Container(width:0.0, height: 0.0);
        /*SizedBox(
        width: double.infinity,
        height: 0,
      );*/
    }

    var fontSize = 13.0 * getSizeRatio();     //15.0

    var hint1Color = Colors.blue;
    var hint2Color = Colors.blue;
    var hint3Color = Colors.blue;
    var hint0Color = Colors.blue;
    var gameColor = Colors.blue;
    var listenColor = Colors.blue;

    if(showHint == HintType.Hint1) {
      hint1Color = Colors.orange;
    }
    else if(showHint == HintType.Hint2) {
      hint2Color = Colors.orange;
    }
    else if(showHint == HintType.Hint3) {
      hint3Color = Colors.orange;
    }
    else if(showHint == HintType.Hint0) {
      hint0Color = Colors.orange;
    }
    else if(showHint == HintType.Game) {
      gameColor = Colors.orange;
    }
    else if(showHint == HintType.TingDa) {
      listenColor = Colors.orange;
    }

    return Row(
        children: <Widget>[
                getHint3(fontSize, hint3Color),
                SizedBox(width: 1.0),
                getHint2(fontSize, hint2Color),
                SizedBox(width: 1.0),
                getHint1(fontSize, hint1Color),
                SizedBox(width: 1.0),
                getHint0(fontSize, hint0Color),
                SizedBox(width: 1.0),
                getGame(fontSize, gameColor),
                SizedBox(width: 1.0),
                getHintTingDa(fontSize, listenColor),
        ]
    );
  }

  Widget getHint3(double fontSize, Color hint3Color) {
    if (firstTypedLetterHintType == HintType.TingDa) {
      return SizedBox(width: 0.0, height: 0.0);
    }

    return                 SizedBox(
      //width: 50.0 * getSizeRatio(),
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.grey[350])
        ),
        onPressed: () {
          initOverlay();

          setState(() {
            showHint = HintType.Hint3; // show Hint3
            _focusNode.requestFocus(); // without this line, phone would still focus on TextField, but web cursor would disapper.
          });
        },
        child: Text(
            getString(523) /*"Hint3"*/,
            style: TextStyle(fontSize: fontSize /* 1.2*/, color: hint3Color), // 1.6
            textAlign: TextAlign.left //TextAlign.center
        ),
      ),
    );
  }

  Widget getHint2(double fontSize, Color hint2Color) {
    if (firstTypedLetterHintType == HintType.TingDa) {
      return SizedBox(width: 0.0, height: 0.0);
    }

    return                 SizedBox(
      //width: 50.0 * getSizeRatio(),
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.grey[350])
        ),
        onPressed: () {
          initOverlay();

          setState(() {
            showHint = HintType.Hint2; // show Hint2
            _focusNode.requestFocus(); // without this line, phone would still focus on TextField, but web cursor would disapper.
          });
        },
        child: Text(
            getString(438) /*"Hint2"*/,
            style: TextStyle(fontSize: fontSize /* 1.2*/, color: hint2Color), // 1.6
            textAlign: TextAlign.left //TextAlign.center
        ),
      ),
    );
  }

  Widget getHint1(double fontSize, Color hint1Color) {
    if (firstTypedLetterHintType == HintType.TingDa) {
      return SizedBox(width: 0.0, height: 0.0);
    }

    return SizedBox(
        //width: 50.0 * getSizeRatio(),
        child: TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.grey[350])
          ),
          onPressed: () {
            initOverlay();

            setState(() {
              showHint = HintType.Hint1; // show Hint1
              _focusNode.requestFocus(); // without this line, phone would still focus on TextField, but web cursor would disapper.
            });
          },
          child: Text(
              getString(90) + "1" /*"Hint1"*/,
              style: TextStyle(fontSize: fontSize /* 1.2*/, color: hint1Color), // 1.6
              textAlign: TextAlign.left //TextAlign.center
          ),
        ),
      );
  }

  Widget getHint0(double fontSize, Color hint0Color) {
    if (firstTypedLetterHintType == HintType.TingDa) {
      return SizedBox(width: 0.0, height: 0.0);
    }

    return                 SizedBox(
      //width: 30.0 * getSizeRatio(),
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.grey[350])
        ),
        onPressed: () {
          initOverlay();

          setState(() {
            showHint = HintType.Hint0; // show Hint0 - no hint
            _focusNode.requestFocus(); // without this line, phone would still focus on TextField, but web cursor would disapper.
          });
        },
        child: Text(
            getString(464) /*"Hint0"*/,
            style: TextStyle(fontSize: fontSize /* 1.2*/, color:  hint0Color), // 1.6
            textAlign: TextAlign.left //TextAlign.center
        ),
      ),
    );
  }

  Widget getGame(double fontSize, Color gameColor) {
    if (firstTypedLetterHintType == HintType.TingDa) {
      return SizedBox(width: 0.0, height: 0.0);
    }

    return                 SizedBox(
      //width: 30.0 * getSizeRatio(),
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.grey[350])
        ),
        onPressed: () {
          initOverlay();

          setState(() {
            showHint = HintType.Game; // show Hint4 - Game
            _focusNode.requestFocus(); // without this line, phone would still focus on TextField, but web cursor would disapper.
          });
        },
        child: Text(
            getString(525) /*"Game"*/,
            style: TextStyle(fontSize: fontSize /* 1.2*/, color:  gameColor), // 1.6
            textAlign: TextAlign.left //TextAlign.center
        ),
      ),
    );
  }

  Widget getHintTingDa(double fontSize, Color listenColor) {
    if ((firstTypedLetterHintType != HintType.TingDa && firstTypedLetterHintType != HintType.None) || !(typingType == TypingType.FromLessons || typingType == TypingType.ThirdParty || typingType == TypingType.Custom)) {
      return SizedBox(width: 0.0, height: 0.0);
    }

    return                SizedBox(
      //width: 30.0 * getSizeRatio(),
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                Colors.grey[350])
        ),
        onPressed: () {
          initOverlay();

          setState(() {
            showHint = HintType.TingDa;
            _focusNode
                .requestFocus(); // without this line, phone would still focus on TextField, but web cursor would disapper.
          });
        },
        child: Text(
            getString(531) /*"Listen"*/,
            style: TextStyle(
                fontSize: fontSize /* 1.2*/, color: listenColor),
            // 1.6
            textAlign: TextAlign.left //TextAlign.center
        ),
      ),
    );
  }

  Widget getHintPainter() {
    if (currentIndex < 0 || typingType == TypingType.FreeTyping || typingType == TypingType.DicSearchTyping) {
      return Container(width: 0.0, height: 0.0);
    }

    var char;
    if (typingType == TypingType.ComponentTyping) {
      char = theComponentCategoryStringIdAndTypingCharsList[lessonId].chars[currentIndex];
    }
    else if (typingType == TypingType.ComponentCombinationTyping) {
      char = theComponentCombinationCharsList[lessonId].chars[currentIndex];
    }
    else {
      var zi = theInputZiManager.getZiWithComponentsAndStrokes(
          typingType, currentIndex, lessonId);
      char = zi.zi;
    }

    var inputZiHintPainter = InputZiHintPainter(
      lineColor: Colors.amber,
      completeColor: Colors.blueAccent,
      screenWidth: screenWidth, //350 /*TODO: temp*/
      showHint: this.showHint,
      selectedCompIndex: selectedCompIndex,
      //selectedCategoryIndex: selectedCategoryIndex,
      //selectedSubcategoryIndex: selectedSubcategoryIndex,
      char: char, //zi.zi,
      typingType: typingType!,
      typingScoreString: getTypingScoreString(),
    );

    return Row(
        children: <Widget>[
          //getAlphabetsText(fontSize),
          SizedBox(width: 30.0),
          SizedBox(
            height: 20.0 * getSizeRatio(),
            //width: 150.0,
            child:  CustomPaint(
              foregroundPainter: inputZiHintPainter,
            ),
          ),
        ]
    );
  }

  Widget getAlphabetsText(double fontSize) {
    if (showHint == HintType.Hint0 || showHint == HintType.Game) {
      return SizedBox(width: 0.0, height: 0.0);
    }

    return Text(getString(521) + ': ', //"Alphabets"
          style: TextStyle(fontSize: fontSize * 1.2, color: Colors.black));
  }

  Widget getCategoryAndSubCat1Row() {
    // if length is 0, it means the char isn't in the searching zi list (although exists in typinglist
    if (showHint == HintType.Hint0 || showHint == HintType.Game || currentTypingComponentsAndSub.length == 0) {
      return SizedBox(width: 0.0, height: 0.0);
    }

    currentCorrectCategoryIndex = theComponentManager.getCurrentCorrectCategoryIndex(currentTypingComponentsAndSub, selectedCompIndex);

    return Row(
        children: getCategoriesAndSubCat1(),
    );
  }

  List<Widget> getCategoriesAndSubCat1() {
    List<Widget> categories = [];

    if (selectedCategoryIndex < 2) { // before selection of a category
      categories.add(Text(getString(519) + '： [',
        style: TextStyle(color: Colors.black))); // Guess
    }
    //categories.add(getCategoryOneItem(1));
    categories.add(getCategoryOneItem(2));
    categories.add(getCategoryOneItem(3));
    categories.add(getCategoryOneItem(4));
    categories.add(getCategoryOneItem(5));
    if (selectedCategoryIndex < 2) {
      categories.add(Text(']', style: TextStyle(color: Colors.black)));
    }
    else {
      categories.add(Text(': ', style: TextStyle(color: Colors.black)));
    }

    addSubCategory1(categories);

    return categories;
  }

  getCategoryOneItem(int categoryIndex) {
    if (selectedCategoryIndex != 0) {
      if (/*categoryIndex != selectedCategoryIndex &&*/ categoryIndex != currentCorrectCategoryIndex) {
        return SizedBox(width: 0.0, height: 0.0);
      }
    }

    //currentCorrectCategoryIndex = theComponentManager.getCurrentCorrectCategoryIndex(typingComponentsAndSub, selectedCompIndex);
    String categoryString = getString(theComponentCategoryList[categoryIndex-1].categoryNameLocaleStringId);
    var color = Colors.blue;
    if (selectedCategoryIndex > 0) {
      if (categoryIndex == currentCorrectCategoryIndex) {
        color = Colors.green;
      }
      else if (categoryIndex == selectedCategoryIndex) {
        color = Colors.red;
        categoryString = categoryString;
      }
    }

    return TextButton(
      style: TextButton.styleFrom(
        textStyle: TextStyle(fontSize: 16.0 * getSizeRatio()),
      ),
      onPressed: () {
        setState(() {
          selectedCategoryIndex = categoryIndex;
        });
      },
      child: Text(categoryString /*"Start"*/,
          style: TextStyle(color: color)),
    );
  }

  getSubCategoryOneItem(int leadCompIndex, List<int> leadComponentList) {
    bool isSubCategoryEmpty = leadCompIndex > leadComponentList.length;

    if (isSubCategoryEmpty || showHint == HintType.Hint0 || showHint == HintType.Game || selectedCategoryIndex == 0 /*|| selectedSubCategoryIndex == 0*/) {
      return SizedBox(width: 0.0, height: 0.0);
    }

    int componentIndex = leadComponentList[leadCompIndex-1];

    var color = Colors.blue;
    if (selectedSubcategoryIndex > 0) {
      if (leadCompIndex == currentCorrectSubcategoryIndex) {
        color = Colors.green;
      }
      else if (leadCompIndex == selectedSubcategoryIndex) {
        color = Colors.red;
      }
    }

    return TextButton(
      style: ButtonStyle(
         padding: MaterialStateProperty.all(EdgeInsets.zero),
       ),
      onPressed: () {
        setState(() {
          selectedSubcategoryIndex = leadCompIndex;
        });
      },
      child: Text('[' + getString(theLeadComponentList[componentIndex].hint) + ']' ,/*"Start"*/ // lightBlue
          style: TextStyle(color: color, fontSize: 16.0 * getSizeRatio())), // lightBlue
    );
  }

  addSubCategory1(List<Widget> widgetList) {
    if (showHint != HintType.Hint0 && showHint != HintType.Game && selectedCategoryIndex != 0) {
      String category = theComponentCategoryList[currentCorrectCategoryIndex - 1].categoryType;
      currentLeadCompList = ComponentManager.getLeadComponentsForCategory(category);
      currentCorrectSubcategoryIndex = theComponentManager.getCurrentCorrectSubcategoryIndex(currentTypingComponentsAndSub, selectedCompIndex, currentLeadCompList);
      widgetList.add(getSubCategoryOneItem(1, currentLeadCompList));
      widgetList.add(getSubCategoryOneItem(2, currentLeadCompList));
      widgetList.add(getSubCategoryOneItem(3, currentLeadCompList));
    }
  }

  String getTypingScoreString() {
    int totalLen = theInputZiManager.getTotal(typingType, lessonId);
    if (typingType == TypingType.FirstTyping || typingType == TypingType.LeadComponents || typingType == TypingType.ExpandedReview) {
      totalLen--;
    }

    if (totalAccurateCount > totalLen) {
      totalAccurateCount = totalLen; // error control
    }

    return totalAccurateCount.toString() + "/" + totalLen.toString(); // Score string
  }

  //Widget getTypingScore() {
  //  var fontSize = 13.0 * getSizeRatio() * 1.2;
  //  return Text(getTypingScoreString(), style: TextStyle(fontSize: fontSize, color: Colors.deepPurple)); // Score
  //}

  getSubCategoryRow2() {
    if (showHint == HintType.Hint0 || showHint == HintType.Game || selectedCategoryIndex == 0 || currentLeadCompList.length <= 2) {
      return SizedBox(width: 0.0, height: 0.0);
    }

    List<Widget> widgetList  = [];
    for (int i = 3; i < currentLeadCompList.length; i++) {
      widgetList.add(getSubCategoryOneItem(i + 1, currentLeadCompList));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: widgetList,
    );
  }

  // not used anymore
  Widget getImageTiedToZi() {
    var image;
    if (typingType == TypingType.LeadComponents || typingType == TypingType.ExpandedReview || typingType == TypingType.AttachedComponents || typingType == TypingType.TwinComponents || typingType == TypingType.SubComponents) {
      //if (typingType == TypingType.LeadComponents) {
      //  image = theZiForLeadCompExerciseList[currentIndex].hintImage;
      //}
      if (typingType == TypingType.LeadComponents) {
      //  image = "GG6.png"; // not show to avoid confusion on which keyboard
      }
      else if (typingType == TypingType.ExpandedReview) {
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

      if (image != null && image.isNotEmpty) {
        var arr = image.split(',');
        var image1 = arr[0];
        var image2 = '';
        if (arr.length > 1) {
          image2 = arr[1];
        }
        return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /*
              Text(
                  getString(369)/*"Components:"*/,
                  style: TextStyle(fontSize: 15.0 * getSizeRatio()),
                  textAlign: TextAlign.center
              ),
               */
              getOneImage(image1),
              SizedBox(
                width: 35.0 * getSizeRatio(), //50
              ),
              getOneImage(image2),
            ]
        );
      }
    }

    return SizedBox(width: 0, height: 0);
  }

  Widget getOneImage(String image) {
    var width = 80.0 * getSizeRatio();
    var height = 80.0 * getSizeRatio();
    //var fit = BoxFit.fitHeight;
    if (typingType == TypingType.LeadComponents) {
      width = 300.0 * getSizeRatio();
    }
    if (typingType == TypingType.AttachedComponents || typingType == TypingType.TwinComponents) {
      width = 300.0 * getSizeRatio();
    //  fit = BoxFit.fitWidth;
    }

    if (image.isNotEmpty) {
      return Container( //Flexible(hh
        alignment: Alignment.center,
        child: Image.asset(
          "assets/typing/" + image,
          width: width,
          height: height,
      //    fit: fit,
        ),
      );
    }
    else {
      return SizedBox(width: 0, height: 0);
    }
  }

  Positioned getZiCandidateButton(PrimitiveWrapper xPosi, int candidateIndex, String zi) {
    // note: the 20.0 arrow position calculation is fixed by max, not changing with the candidates' size
    // -4.0 to make the highlight on center
    if (candidateIndex == InputZiManager.maxTypingCandidates) { // left arrow
      xPosi.value = (InputZiManager.getCandidateLeftArrowXPosition() - 4.0 ) * getSizeRatio();
    }
    else if (candidateIndex == (InputZiManager.maxTypingCandidates + 1)) { // right arrow
      xPosi.value = (InputZiManager.getCandidateRightArrowXPosition() - 4.0) * getSizeRatio();
    }
    var oneCandidateLength = InputZiManager.getOneCandidateLength(zi) * getSizeRatio();
    var butt = TextButton(
      //color: Colors.white,
      //textColor: Colors.blueAccent,
      onPressed: () {
        initOverlay();
        setTextByChosenZiIndex(candidateIndex, true, false, false);
      },
      child: Text('', style: TextStyle(fontSize: 20.0 * getSizeRatio(), color: Colors.blueAccent),),
    );

    var posiCenter = Positioned(
        top: 5.0 * getSizeRatio(),
        left: xPosi.value,
        height: InputZiManager.getCandidateHanziLength() * getSizeRatio(), //posiAndSize.height,
        width: oneCandidateLength, //posiAndSize.width,
        child: butt
    );

    xPosi.value += oneCandidateLength; //(20.0 * getSizeRatio() * zi.length + 13.0 * getSizeRatio()); // 13.0 was 18.0

    return posiCenter;
  }

  List<Widget> createHittestButtons(BuildContext context, List<String> ziCandidates) {
    List<Widget> buttons = [];

    buttons.add(Container(height: 60.0 * getSizeRatio() /*contentLength.value*/,
        width: screenWidth)); // workaround to avoid infinite size error

    PrimitiveWrapper xPosi = PrimitiveWrapper(
        InputZiManager.getBeginningLength()); // 0.0

    if (ziCandidates != null && ziCandidates.length != 0) {
      for (var i = 0; i < ziCandidates.length; i++) {
        buttons.add(getZiCandidateButton(xPosi, i, ziCandidates[i]));
        xPosi.value +=
            InputZiManager.getCandidateIndexLength() * getSizeRatio();
      }

      buttons.add(
        getZiCandidateButton(xPosi, InputZiManager.maxTypingCandidates, '<'));
      buttons.add(getZiCandidateButton(
        xPosi, InputZiManager.maxTypingCandidates + 1, '>'));
    }
    return buttons;
  }

  showCompletedDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK", style: TextStyle(color: Colors.blue)),
      onPressed: () {
        theIsBackArrowExit = false;
        Navigator.of(context).pop(); // out this dialog
        Navigator.of(context).pop(); // to the lesson page
        // these two types support multiple sentences which is actually another layer. so pop one more time.
        if (typingType == TypingType.ThirdParty || typingType == TypingType.Custom) {
          Navigator.of(context).pop();
        }
      },
    );

    String title = '';
    String content = '';

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
      //theNewlyCompletedTypingExercise = 1;
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
      content = getString(355)/*"Completed course!."*/;
      //theNewlyCompletedTypingExercise = 3;
    }
    else if (typingType == TypingType.ExpandedGeneral) {
      title = getString(118)/*"Congratulations!"*/;
      content = getString(354)/*"You have completed this exercise! Please move on to the next one."*/;
      //theNewlyCompletedTypingExercise = 4;
    }
    else if (typingType == TypingType.AttachedComponents) {
      title = getString(118)/*"Congratulations!"*/;
      content = getString(354)/*"You have completed this exercise! Please move on to the next one."*/;
      //theNewlyCompletedTypingExercise = 5;
    }
    else if (typingType == TypingType.TwinComponents) {
      title = getString(118)/*"Congratulations!"*/;
      content = getString(354)/*"You have completed this exercise! Please move on to the next one."*/;
      //theNewlyCompletedTypingExercise = 6;
    }
    else if (typingType == TypingType.SubComponents) {
      title = getString(118)/*"Congratulations!"*/;
      content = getString(354)/*"You have completed this exercise! Please move on to the next one."*/;
      //theNewlyCompletedTypingExercise = 7;
    }
    else if (typingType == TypingType.SingleComponent) {
      title = getString(118)/*"Congratulations!"*/;
      content = getString(355)/*"You have completed this typing course! ..."*/;
      //theNewlyCompletedTypingExercise = 8;
    }
    else if (typingType == TypingType.FirstTyping) {
      title = getString(118)/*"Congratulations!"*/;
      content = getString(512)/*"You have typed your first Hanzi into computer!"*/;
      //theNewlyCompletedTypingExercise = 8;
    }
    else if (typingType == TypingType.TwoComponents) {
      title = getString(118)/*"Congratulations!"*/;
      content = getString(354)/*"You have completed this exercise! Please move on to the next one."*/;
      //theNewlyCompletedTypingExercise = 9;
    }
    //else if (typingType == TypingType.GeneralExercise) {
    //  title = getString(118)/*"Congratulations!"*/;
    //  content = getString(355)/*"You have completed this exercise! Please move on to the next one."*/;
      //theNewlyCompletedTypingExercise = 10;
    //}
    else if (typingType == TypingType.CommonZiTyping) {
      title = getString(115)/*"Good job!"*/;

      var elapsed = stopwatch.elapsed;
      var inMin = elapsed.inMinutes;
      var extraSec = elapsed.inSeconds % 60;
      var elapsedStr = inMin.toString() + " " + getString(376).toString() + " " + extraSec.toString() + " " + getString(377) + "! ";

      //if (inMin >= 10) {
        content = elapsedStr + getString(383); /* repeat */
      //}
      //else {
      //  content = elapsedStr + getString(119) /*"Wow, you are making great progress in typing Chinese characters. You can now move on to the next exercise!"*/;
      //}
    }
    else if (typingType == TypingType.FromLessons) {
      title = getString(115)/*"Good job!"*/;
      int totalLen = theInputZiManager.getTotal(typingType, lessonId);
      int completedCharCountLessons = currentIndex+1;
      if (showHint == HintType.TingDa) {
        completedCharCountLessons = totalAccurateCount;
      }
      content = getString(120) + getString(524) + ": " + completedCharCountLessons.toString() + "/" + totalLen.toString()/*"Your typing exercise is complete for this lesson."*/;
    }
    else if (typingType == TypingType.ComponentTyping || typingType == TypingType.ComponentCombinationTyping) {
      title = getString(115)/*"Good job!"*/;
      content = getString(410)/*"You have completed typing exercises."*/;
    }
    else if (typingType == TypingType.Custom || typingType == TypingType.ThirdParty) {
      title = getString(115)/*"Good job!"*/;
      int totalLen = theInputZiManager.getTotal(typingType, lessonId);
      int completedCharCount = currentIndex+1;
      if (showHint == HintType.TingDa) {
        completedCharCount = totalAccurateCount;
      }
      content = getString(502) + getString(524) + ": " + completedCharCount.toString() + "/" + totalLen.toString()/*"You have completed this typing exercises."*/;
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

  updateTypingStatusAndHintCompIndex(String composingText) {
    int sameStartSubstring = Utility.sameStartSubstring(
        composingText, currentCorrectTypingCode);

    setState(() {
      if (sameStartSubstring < currentCorrectTypingCode.length) {
        selectedCompIndex = sameStartSubstring + 1;
      }

      if (sameStartSubstring < composingText.characters.length) {
        currentTypingCodeIsCorrect = false;
      }
      else {
        currentTypingCodeIsCorrect = true;
      }
    });
  }

  updateHintAfterANewLetter(String composingText) {
    selectedCategoryIndex = 0;
    selectedSubcategoryIndex = 0;

    updateTypingStatusAndHintCompIndex(composingText);
  }
}