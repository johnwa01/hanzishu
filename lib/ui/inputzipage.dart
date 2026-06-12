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
import 'package:hanzishu/engine/inputgamemanager.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/data/componenttypinglist.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/data/sentencelist.dart';
import 'package:hanzishu/engine/triemanager.dart';
import 'package:hanzishu/utility.dart';

import 'dart:core';
import 'dart:io';
import 'package:flutter/services.dart';

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

  int currentInputGameId = -1;
  int currentInputGameQuestionListIndex = -1;
  //bool isInputGameInHashMode = false;
  bool isCurrentlySimplifiedChineseCharacters = true;

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
    if (typingType != TypingType.FreeTyping && typingType != TypingType.InputGame &&
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

    if (typingType == TypingType.InputGame) {
      currentInputGameId = widget.lessonId;
    }

    setState(() {
      updateCounter = 0;
      currentIndex = theInputZiManager.getCurrentIndex(typingType);
      if (typingType == TypingType.InputGame) {
        currentInputGameQuestionListIndex = 0;
        //isInputGameInHashMode = false;
      }
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

  String getLatestComposingLetters(TextEditingController activeController) {
    var selectionEnd = activeController.value.selection.end;
    if (selectionEnd >= 1 && selectionEnd > previousEndSelection) {
      if (activeController.value.text.length != 0) {
        return activeController.value.text.substring(previousEndSelection, selectionEnd);
      }
    }

    return "";
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
    if (typingType != TypingType.FreeTyping && typingType != TypingType.InputGame && typingType != TypingType.DicSearchTyping) {
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
    //   checkAndUpdateCurrentIndex(_controllerStandard, ''); // We don't really need this?
    if (typingType != TypingType.InputGame) {
      return;
    }

    if (_controllerStandard.text == previousText) {
      // set an End reference point for next copy/paste prevention
      // as long as setting this, and realize that new copy/paste's End must be longer than previous End,
      // then if seeing Chinese chars showing up, it must be a copy paste action.
      if (previousEndSelection != _controllerStandard.value.selection.end) {
        previousEndSelection = _controllerStandard.value.selection.end;
      }
      return;
    }

    if (_controllerStandard.value.selection.end > previousEndSelection) {
      PreventCopyAndPasteAction(_controllerStandard);
    }

    if (previousText != _controllerStandard.text) {
      previousText = _controllerStandard.text;
    }

    if (previousEndSelection != _controllerStandard.value.selection.end) {
      previousEndSelection = _controllerStandard.value.selection.end;
    }

    setState(() {
      updateCounter++; // for Hash value refresh
    });
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

  //TODO: this method does not work for iPhone and iPad, as well as seeing problem in
  // computers like Sanxing and Lenovo. Basically in normal cases, the typed Chinese characters
  // are disappearing after choosing them from candidate list.
  void PreventCopyAndPasteAction(TextEditingController activeController) {
    // start with this special InputGame case first.
    if (typingType == TypingType.InputGame) {
      // In order to prevent copy/paste action during competition
      // Actually remove the copy/paste content here
      var composingString = getLatestComposingLetters(activeController);
      if (containChineseChars(composingString)) {
        // remove the copy/paste content.
        String textTrimReturnKey = activeController.text.replaceRange(
            previousEndSelection, activeController.value.selection.end,
            ''); //_controller.text.substring(0, previousEndComposing);
        // replace _controller.value
        activeController.value =
            activeController.value.copyWith(text: textTrimReturnKey,
                composing: TextRange.empty,
                selection: TextSelection.collapsed(
                    offset: previousEndSelection));
        // in case of copy/paste for inputgame mode, just remove it and no need to go further.
        return;
      }
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

      if (typingType == TypingType.InputGame && previousEndSelection != _controller.value.selection.end) {
        previousEndSelection = _controller.value.selection.end;
      }

      return;
    }
    else if (_controller.text == previousText) {
      // set an End reference point for next copy/paste prevention
      // as long as setting this, and realize that new copy/paste's End must be longer than previous End,
      // then if seeing Chinese chars showing up, it must be a copy paste action.
      if (typingType == TypingType.InputGame && previousEndSelection != _controller.value.selection.end) {
        previousEndSelection = _controller.value.selection.end;
      }
      return;
    }
    else {
      if (_controller.value.text.characters.length < previousText.characters.length) {
        isFromDeletion = true;
      }
      // set it as the comparision standard
      setInitialControllerTextValue(_controller);
      hasVerifiedToBeALowerCase = false;
    }

    if (currentIndex < 0) {
      return;
    }

    //TODO: temp testing for comp shapes
    globalTestDoubleByteCode = _controller.text;

    PreventCopyAndPasteAction(_controller);

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
        if (InputZiManager.isPinyinInput(composingText) && typingType == TypingType.InputGame) {
          fullZiCandidates = []; //null;
        }
        else {
          fullZiCandidates = InputZiManager.getZiCandidates(composingText)!;
        }
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

      if (typingType == TypingType.InputGame) {
        previousEndSelection = _controller.value.selection.end;
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
      if (InputZiManager.isPinyinInput(composingText) && typingType == TypingType.InputGame) {
        fullZiCandidates = []; //null;
      }
      else {
        fullZiCandidates = InputZiManager.getZiCandidates(composingText)!;
      }

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

  bool containChineseChars(String selectionString) {
    // \u4e00-\u9fa5bie Unicode编码中中文字符的范围，如果字符串中含有这个范围内的字符，则匹配成功。
    RegExp exp = RegExp(r"[\u4e00-\u9fa5]");
    if (exp.hasMatch(selectionString)) {
      return true;
    }

    return false;
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

  setInitialControllerTextValue(TextEditingController activeController) {
    initialControllerTextValue =
        activeController.text; // will not change until next letter input.
    previousText = activeController
        .text; // can change with the updated value within the same letter input.
  }

  Widget getExplainationPage() {
    if (typingType == TypingType.FirstTyping && currentIndex == 0) {
      return _buildFirstTypingIntroPage();
    }

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

  Widget _buildFirstTypingIntroPage() {
    final ratio = getSizeRatio();
    final primary = Color(0xFF6F35E8);
    final darkText = Color(0xFF071B55);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Hanzishu Typing Tutorial",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: darkText,
            fontSize: 24 * ratio,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: darkText,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(0xFFF8FAFF),
              Color(0xFFF2EDFF),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              final isNarrow = maxWidth < 520;
              final contentWidth = isNarrow ? maxWidth * 0.92 : 760.0 * ratio;

              return SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: contentWidth),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18 * ratio),
                      child: Column(
                        children: [
                          SizedBox(height: 18 * ratio),
                          _buildTutorialStepIndicator(context, 1, 5, ratio, primary),
                          SizedBox(height: 38 * ratio),
                          Text(
                            "Your First\nChinese Characters",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: darkText,
                              fontSize: (isNarrow ? 25 : 30) * ratio,
                              fontWeight: FontWeight.w800,
                              height: 1.12,
                              letterSpacing: -0.4,
                            ),
                          ),
                          //SizedBox(height: 10 * ratio),
                          _buildIntroBlocks(ratio),
                          SizedBox(height: 19 * ratio),
                          _buildStartStepButton(ratio, primary),
                          SizedBox(height: 12 * ratio),
                          getSkipThisSection(),
                          SizedBox(height: 20 * ratio),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTutorialStepIndicator(BuildContext context, int activeStep, int totalSteps, double ratio, Color primary) {
    final isNarrow = MediaQuery.of(context).size.width < 700;
    final connectorWidth = isNarrow ? 28 * ratio : 62 * ratio;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps * 2 - 1, (index) {
        if (index.isOdd) {
          return Container(
            width: connectorWidth,
            height: 2 * ratio,
            decoration: BoxDecoration(
              color: Color(0xFFD7D7E2),
              borderRadius: BorderRadius.circular(99),
            ),
          );
        }

        final step = index ~/ 2 + 1;
        final isActive = step == activeStep;
        final circleSize = isNarrow ? 42 * ratio : 48 * ratio;
        return Container(
          width: circleSize,
          height: circleSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? primary : Colors.white,
            border: Border.all(
              color: isActive ? primary : Color(0xFFC7C8D3),
              width: 2.2 * ratio,
            ),
            boxShadow: isActive
                ? [
              BoxShadow(
                color: primary.withOpacity(0.24),
                blurRadius: 14 * ratio,
                offset: Offset(0, 6 * ratio),
              ),
            ]
                : [],
          ),
          child: Text(
            step.toString(),
            style: TextStyle(
              color: isActive ? Colors.white : Color(0xFF8C8E9B),
              fontSize: 21 * ratio,
              fontWeight: FontWeight.w800,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildIntroBlocks(double ratio) {
    return SizedBox(
      width: 430 * ratio,
      height: 330 * ratio,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Center(
              child: Container(
                width: 330 * ratio,
                height: 240 * ratio,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFFFD76A).withOpacity(0.28),
                      blurRadius: 86 * ratio,
                      spreadRadius: 24 * ratio,
                    ),
                    BoxShadow(
                      color: Color(0xFF7C3AED).withOpacity(0.10),
                      blurRadius: 86 * ratio,
                      spreadRadius: 8 * ratio,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom cubes: draw first so the blue cube can sit on top of them.
          Positioned(
            left: 56 * ratio,
            top: 156 * ratio,
            child: _buildAlphabetCube(
              ratio: ratio,
              letter: "O",
              frontColor: Color(0xFFFF9800),
              sideColor: Color(0xFFE26300),
              topColor: Color(0xFFFFD35A),
              size: 118 * ratio,
              angle: -0.045,
            ),
          ),
          Positioned(
            right: 52 * ratio,
            top: 156 * ratio,
            child: _buildAlphabetCube(
              ratio: ratio,
              letter: "A",
              frontColor: Color(0xFF58D72E),
              sideColor: Color(0xFF239A1D),
              topColor: Color(0xFFA8F23A),
              size: 118 * ratio,
              angle: 0.045,
            ),
          ),

          // Top cube overlaps the two bottom cubes, like a stack of toy blocks.
          Positioned(
            top: 56 * ratio,
            left: 146 * ratio,
            child: _buildAlphabetCube(
              ratio: ratio,
              letter: "M",
              frontColor: Color(0xFF168BFF),
              sideColor: Color(0xFF075AE8),
              topColor: Color(0xFF58D9FF),
              size: 118 * ratio,
              angle: -0.02,
            ),
          ),

          Positioned(top: 104 * ratio, left: 34 * ratio, child: _buildSparkle(ratio, Color(0xFFFFD21C), 25)),
          Positioned(top: 120 * ratio, right: 34 * ratio, child: _buildSparkle(ratio, Color(0xFFA855F7), 22)),
          Positioned(bottom: 42 * ratio, left: 22 * ratio, child: _buildDot(ratio, Color(0xFF17BDF4), 14)),
          Positioned(bottom: 28 * ratio, right: 32 * ratio, child: _buildDot(ratio, Color(0xFFFFB000), 13)),
          Positioned(top: 190 * ratio, right: 20 * ratio, child: _buildDot(ratio, Color(0xFF72D72B), 12)),
        ],
      ),
    );
  }

  Widget _buildAlphabetCube({
    required double ratio,
    required String letter,
    required Color frontColor,
    required Color sideColor,
    required Color topColor,
    required double size,
    required double angle,
  }) {
    final depth = size * 0.24;

    return Transform.rotate(
      angle: angle,
      child: SizedBox(
        width: size + depth,
        height: size + depth,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CustomPaint(
              size: Size(size + depth, size + depth),
              painter: _AlphabetToyCubePainter(
                frontColor: frontColor,
                sideColor: sideColor,
                topColor: topColor,
                depth: depth,
                radius: size * 0.035,
              ),
            ),
            Positioned(
              left: 0,
              top: depth,
              width: size,
              height: size,
              child: Center(
                child: Text(
                  letter,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size * 0.48,
                    fontWeight: FontWeight.w900,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.24),
                        blurRadius: 8 * ratio,
                        offset: Offset(0, 4 * ratio),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSparkle(double ratio, Color color, double size) {
    return Icon(
      Icons.auto_awesome_rounded,
      color: color,
      size: size * ratio,
    );
  }

  Widget _buildDot(double ratio, Color color, double size) {
    return Container(
      width: size * ratio,
      height: size * ratio,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.35),
            blurRadius: 8 * ratio,
            offset: Offset(0, 3 * ratio),
          ),
        ],
      ),
    );
  }

  Widget _buildStartStepButton(double ratio, Color primary) {
    return Container(
      width: 420 * ratio,
      height: 74 * ratio,
      constraints: BoxConstraints(maxWidth: 420 * ratio),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 9,
          shadowColor: primary.withOpacity(0.38),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24 * ratio),
          ),
        ),
        onPressed: () {
          speakFirstZiAfterExplanationPage();
          setState(() {
            currentIndex = theInputZiManager.getNextIndex(typingType, currentIndex, lessonId, 1);
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Start",
              style: TextStyle(
                fontSize: 28 * ratio,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(width: 18 * ratio),
            Icon(Icons.arrow_forward_ios_rounded, size: 26 * ratio),
          ],
        ),
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
    thePositionManager.setFrameWidth(screenWidth - 10.0);
    double editFontSize = 30.0 * getSizeRatio();

    //To be sure
    initOverlay();

    //initParameters();

    int maxNumberOfLines;
    if (typingType == TypingType.FreeTyping) {
      maxNumberOfLines = 10;  // 4
      editFontSize = 24 * getSizeRatio();
    }
    else if (typingType == TypingType.InputGame) {
      maxNumberOfLines = 8;
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
    else if (typingType == TypingType.InputGame) {
      title = getString(534)/*'Chinese Cup Input Competition'*/;
    }
    else if (typingType == TypingType.DicSearchTyping) {
      title = "";
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
    if (typingType != TypingType.FromLessons && typingType != TypingType.ThirdParty && typingType != TypingType.CommonZiTyping && typingType != TypingType.FreeTyping && typingType != TypingType.InputGame && typingType != TypingType.DicSearchTyping && typingType != TypingType.Custom && typingType != TypingType.ComponentTyping && typingType != TypingType.ComponentCombinationTyping && currentIndex == 0) {
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F1B2D),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Color(0xFF1F1B2D),
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

  Column getDicSearchTyping(double fieldWidth, double editFieldFontRatio, double editFontSize, int maxNumberOfLines, InputZiPainter inputZiPainter) {
    final ratio = getSizeRatio();
    final teal = Color(0xFF00897B);
    final darkTeal = Color(0xFF005C55);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 24 * ratio),

        _buildDictionaryHeader(ratio, darkTeal),

        SizedBox(height: 28 * ratio),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24 * ratio),
          child: _buildFirstHanziSearchCard(ratio, teal, darkTeal),
        ),

        SizedBox(height: 28 * ratio),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24 * ratio),
          child: _buildDictionarySearchSection(
            ratio,
            teal,
            darkTeal,
            editFieldFontRatio,
            editFontSize,
            maxNumberOfLines,
            inputZiPainter,
          ),
        ),

        SizedBox(height: 32 * ratio),
      ],
    );
  }

  Widget _buildDictionaryHeader(double ratio, Color darkTeal) {
    return Column(
      children: [
        Icon(
          Icons.menu_book_rounded,
          color: darkTeal,
          size: 42 * ratio,
        ),
        SizedBox(height: 10 * ratio),
        Text(
          "Hanzishu Dictionary",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 32 * ratio,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8 * ratio),
        Text(
          "Find and explore Chinese characters.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.blueGrey[700],
            fontSize: 16 * ratio,
            height: 1.35,
          ),
        ),
      ],
    );
  }

  Widget _buildFirstHanziSearchCard(double ratio, Color teal, Color darkTeal) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20 * ratio),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DictionaryPage(),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(26 * ratio),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF3FBFA),
                Colors.white,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(20 * ratio),
            border: Border.all(
              color: darkTeal.withOpacity(0.18),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 18 * ratio,
                offset: Offset(0, 8 * ratio),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bool isNarrow = constraints.maxWidth < 620;

              final iconWidget = Container(
                width: 90 * ratio,
                height: 90 * ratio,
                decoration: BoxDecoration(
                  color: teal.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.manage_search_rounded,
                  color: darkTeal,
                  size: 52 * ratio,
                ),
              );

              final textColumn = Column(
                crossAxisAlignment:
                isNarrow ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                children: [
                  Text(
                    "First-Hanzi Search",
                    textAlign:
                    isNarrow ? TextAlign.center : TextAlign.start,
                    style: TextStyle(
                      color: darkTeal,
                      fontSize: 25 * ratio,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10 * ratio),
                  Text(
                    "Find a character through its first Hanzi.",
                    textAlign:
                    isNarrow ? TextAlign.center : TextAlign.start,
                    style: TextStyle(
                      color: Colors.blueGrey[700],
                      fontSize: 15.5 * ratio,
                      height: 1.35,
                    ),
                  ),
                  SizedBox(height: 18 * ratio),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 28 * ratio,
                      vertical: 16 * ratio,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16 * ratio),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10 * ratio,
                          offset: Offset(0, 3 * ratio),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.grid_view_rounded,
                          color: darkTeal,
                          size: 24 * ratio,
                        ),
                        SizedBox(width: 12 * ratio),
                        Text(
                          "Open First-Hanzi Table",
                          style: TextStyle(
                            color: darkTeal,
                            fontSize: 17 * ratio,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 12 * ratio),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: darkTeal,
                          size: 24 * ratio,
                        ),
                      ],
                    ),
                  ),
                ],
              );

              if (isNarrow) {
                return Column(
                  children: [
                    iconWidget,
                    SizedBox(height: 18 * ratio),
                    textColumn,
                  ],
                );
              }

              return Row(
                children: [
                  iconWidget,
                  SizedBox(width: 24 * ratio),
                  Expanded(child: textColumn),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFirstHanziButton(double ratio, Color darkTeal) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 18 * ratio,
        vertical: 12 * ratio,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13 * ratio),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10 * ratio,
            offset: Offset(0, 4 * ratio),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.grid_view_rounded, color: darkTeal, size: 22 * ratio),
          SizedBox(width: 10 * ratio),
          Text(
            "Open First-Hanzi Table",
            style: TextStyle(
              color: darkTeal,
              fontSize: 15.5 * ratio,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8 * ratio),
          Icon(Icons.arrow_forward_rounded, color: darkTeal, size: 22 * ratio),
        ],
      ),
    );
  }

  Widget _buildDictionarySearchSection(
      double ratio,
      Color teal,
      Color darkTeal,
      double editFieldFontRatio,
      double editFontSize,
      int maxNumberOfLines,
      InputZiPainter inputZiPainter,
      ) {
    return Container(
      padding: EdgeInsets.all(20 * ratio),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20 * ratio),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18 * ratio,
            offset: Offset(0, 8 * ratio),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52 * ratio,
                height: 52 * ratio,
                decoration: BoxDecoration(
                  color: teal.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.search_rounded, color: darkTeal, size: 32 * ratio),
              ),
              SizedBox(width: 14 * ratio),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Search Characters",
                      style: TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 22 * ratio,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4 * ratio),
                    Text(
                      "Choose a search method.",
                      style: TextStyle(
                        color: Colors.blueGrey[700],
                        fontSize: 14.5 * ratio,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20 * ratio),

          _buildDictionaryInputCard(
            ratio: ratio,
            teal: teal,
            darkTeal: darkTeal,
            icon: Icons.keyboard_rounded,
            title: "Search with Hanzishu Input",
            description: "Use the built-in Shape-Sequence input method.",
            child: _buildDictionaryHanzishuSearchBox(
              ratio,
              teal,
              editFieldFontRatio,
              editFontSize,
              maxNumberOfLines,
            ),
          ),

          getZiCandidates(inputZiPainter),

          SizedBox(height: 16 * ratio),

          _buildDictionaryInputCard(
            ratio: ratio,
            teal: teal,
            darkTeal: darkTeal,
            icon: Icons.translate_rounded,
            title: "Search with Other Input Methods",
            description: "Use Pinyin or other input methods.",
            child: _buildDictionaryOtherSearchBox(ratio, teal),
          ),
        ],
      ),
    );
  }

  Widget _buildDictionaryInputCard({
    required double ratio,
    required Color teal,
    required Color darkTeal,
    required IconData icon,
    required String title,
    required String description,
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.all(18 * ratio),
      decoration: BoxDecoration(
        color: Color(0xFFFCFCFD),
        borderRadius: BorderRadius.circular(16 * ratio),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isNarrow = constraints.maxWidth < 620;

          final leading = Container(
            width: 72 * ratio,
            height: 72 * ratio,
            decoration: BoxDecoration(
              color: teal.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: darkTeal, size: 38 * ratio),
          );

          final descriptionColumn = Column(
            crossAxisAlignment: isNarrow ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              Text(
                title,
                textAlign: isNarrow ? TextAlign.center : TextAlign.start,
                style: TextStyle(
                  color: darkTeal,
                  fontSize: 17.5 * ratio,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8 * ratio),
              Text(
                description,
                textAlign: isNarrow ? TextAlign.center : TextAlign.start,
                style: TextStyle(
                  color: Colors.blueGrey[700],
                  fontSize: 14 * ratio,
                  height: 1.35,
                ),
              ),
            ],
          );

          if (isNarrow) {
            return Column(
              children: [
                leading,
                SizedBox(height: 12 * ratio),
                descriptionColumn,
                SizedBox(height: 16 * ratio),
                child,
              ],
            );
          }

          return Row(
            children: [
              leading,
              SizedBox(width: 18 * ratio),
              Expanded(child: descriptionColumn),
              SizedBox(width: 18 * ratio),
              Expanded(
                flex: 2,
                child: child,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDictionaryHanzishuSearchBox(
      double ratio,
      Color teal,
      double editFieldFontRatio,
      double editFontSize,
      int maxNumberOfLines,
      ) {
    return TextField(
      autocorrect: false,
      enableSuggestions: false,
      controller: _controller,
      focusNode: _focusNode,
      autofocus: false,
      cursorColor: teal,
      decoration: InputDecoration(
        hintText: "Enter Shape-Sequence code...",
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14 * ratio,
          vertical: 12 * ratio,
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.search_rounded, color: teal),
          onPressed: () {
            processZiQuery(_controller);
          },
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12 * ratio),
          borderSide: BorderSide(color: teal.withOpacity(0.75), width: 1.2 * ratio),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12 * ratio),
          borderSide: BorderSide(color: teal, width: 1.6 * ratio),
        ),
      ),
      style: TextStyle(
        fontSize: 18 * ratio,
        height: 1.15,
      ),
      maxLines: 1,
      keyboardType: TextInputType.text,
    );
  }

  Widget _buildDictionaryOtherSearchBox(double ratio, Color teal) {
    return TextField(
      autocorrect: false,
      enableSuggestions: false,
      controller: _controllerStandard,
      focusNode: _focusNodeStandard,
      autofocus: false,
      cursorColor: teal,
      decoration: InputDecoration(
        hintText: "Enter Pinyin or other input...",
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14 * ratio,
          vertical: 12 * ratio,
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.search_rounded, color: teal),
          onPressed: () {
            processZiQuery(_controllerStandard);
          },
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12 * ratio),
          borderSide: BorderSide(color: teal.withOpacity(0.75), width: 1.2 * ratio),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12 * ratio),
          borderSide: BorderSide(color: teal, width: 1.6 * ratio),
        ),
      ),
      style: TextStyle(
        fontSize: 18 * ratio,
        height: 1.15,
      ),
      maxLines: 1,
      keyboardType: TextInputType.text,
      onSubmitted: (_) {
        processZiQuery(_controllerStandard);
      },
    );
  }

  Column getRegularOneTyping(double fieldWidth, double editFieldFontRatio, double editFontSize, int maxNumberOfLines, InputZiPainter inputZiPainter) {
    if (inputMethod == InputMethod.Pinxin) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          getHintLabelRelated(),
          getHelpOrProgressIndicator(),
          getInputPrompt(),
          getHintPainter(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.0 * getSizeRatio()),
            child: getHanzishuTextField(
              fieldWidth,
              editFieldFontRatio,
              editFontSize,
              maxNumberOfLines,
            ),
          ),
          getZiCandidates(inputZiPainter),
          getInputGameCompleteString(),
          inputGameInstruction(),
          SizedBox(height: 10),
          inputGameHashInstruction(),
          SizedBox(height: 10.0),
          getInputGameHashString(),
          SizedBox(height: 10),
          getNextInputGameQuestionButton(),
        ],
      );
    }
    else { // other input methods
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          getHelpOrProgressIndicator(),
          Row(
            children: <Widget>[
              SizedBox(width: 10),
              Container(
                alignment: Alignment.topRight,
                child: getSkipThisSection(),
              ),
            ],
          ),
          getInputPrompt(),
          getOtherInputMethodTextField(_controllerStandard, false),
          getInputGameCompleteString(),
          inputGameInstruction(),
          SizedBox(height: 10.0),
          inputGameHashInstruction(),
          SizedBox(height: 10.0),
          getInputGameHashString(),
          SizedBox(height: 10),
          getNextInputGameQuestionButton(),
        ],
      );
    }
  }

  getNextInputGameQuestionButton() {
    if (typingType != TypingType.InputGame) {
      return SizedBox(width: 0.0, height: 0.0);
    }

    String nextQuestionButtonText;
    if (InputGameManager.isInputGameQuestionListIndexValid(currentInputGameId, currentInputGameQuestionListIndex + 1)) {
      nextQuestionButtonText = getString(550);
    }
    else {
      nextQuestionButtonText = getString(557);
    }

    return Center(child: TextButton(
        style: TextButton.styleFrom(
          textStyle: TextStyle(fontSize: 20.0 * getSizeRatio()),
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
          //if (isInputGameInHashMode) {
          if (inputMethod == InputMethod.Pinxin) {
            _controller.clear();
          }
          else {
            _controllerStandard.clear();
          }

          if (InputGameManager.isInputGameQuestionListIndexValid(currentInputGameId, currentInputGameQuestionListIndex + 1)) {
            setState(() {
              currentInputGameQuestionListIndex += 1;
              //isInputGameInHashMode = false;
            });
          }
          else {
            showInputGameCompletedDialog();
          }
          //}
          //else  {
          //  setState(() {
          //    isInputGameInHashMode = true;
          //  });
          //}
        },
        child: Text(nextQuestionButtonText,
          style: TextStyle(
            fontSize: 20.0 * getSizeRatio(), // Set the desired font size
          ),)),
    );
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

  /*
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
  */

  Widget getHanzishuTextField(double fieldWidth, double editFieldFontRatio, double editFontSize, int maxNumberOfLines) {
    return SizedBox(
      width: fieldWidth,
      child: TextField(
        autocorrect: false,
        enableSuggestions: false,
        controller: _controller,
        focusNode: _focusNode,
        autofocus: true,
        cursorColor: Color(0xFF6A35B8),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.0 * getSizeRatio(),
            vertical: 12.0 * getSizeRatio(),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.0 * getSizeRatio()),
            borderSide: BorderSide(
              color: Color(0xFF6A35B8),
              width: 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.0 * getSizeRatio()),
            borderSide: BorderSide(
              color: Color(0xFF6A35B8),
              width: 1.8,
            ),
          ),
        ),
        style: TextStyle(
          fontSize: editFontSize * editFieldFontRatio,
          height: 1.0,
        ),
        maxLines: maxNumberOfLines,
        keyboardType: maxNumberOfLines == 1
            ? TextInputType.text
            : TextInputType.multiline,
      ),
    );
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

  String getEditFieldStringValue() {
    String existingText;
    if (inputMethod == InputMethod.Pinxin) {
      existingText = _controller.value.text;
    }
    else {
      existingText = _controllerStandard.value.text;
    }

    return existingText;
  }

  String getHashStringValue() {
    var hashExtra = "";
    if (InputGameManager.getInputGameById(currentInputGameId) == "1") {
      hashExtra = "Xiangxing";
    }
    else {
      hashExtra = "Pinyin";
    }

    return Utility.getMD5HashString(getEditFieldStringValue() + hashExtra);
  }

  Widget getInputGameCompleteString() {
    if (typingType == TypingType.InputGame /*&&  isInputGameInHashMode */)
    {
      return Text(getString(547), style: TextStyle(
        fontSize: 17.0 * getSizeRatio(), // Set the font size
        fontWeight: FontWeight.bold, // Optional: customize other properties
        color: Colors.brown, // Optional: change color
      ),);
    }

    return SizedBox(width: 0.0, height: 0.0);
  }

  Widget getInputGameHashString() {
    if (typingType == TypingType.InputGame /*&&  isInputGameInHashMode */)
    {
      return SelectableText(getHashStringValue(), style: TextStyle(
        fontSize: 17.0 * getSizeRatio(), // Set the font size
        fontWeight: FontWeight.bold, // Optional: customize other properties
        color: Colors.brown, // Optional: change color
      ),);
    }

    return SizedBox(width: 0.0, height: 0.0);
  }

  Widget inputGameInstruction() {
    if (typingType == TypingType.InputGame) {
      return Center(child: Text(getString(548),   style: TextStyle(
        fontSize: 17.0 * getSizeRatio(), // Set the font size
        fontWeight: FontWeight.bold, // Optional: customize other properties
        color: Colors.blue, // Optional: change color
      ),));
    }

    return SizedBox(width: 0.0, height: 0.0);
  }

  Widget inputGameHashInstruction() {
    if (typingType == TypingType.InputGame) {
      return Center(child: Text(getString(549),   style: TextStyle(
        fontSize: 17.0 * getSizeRatio(), // Set the font size
        fontWeight: FontWeight.bold, // Optional: customize other properties
        color: Colors.blue, // Optional: change color
      ),));
    }

    return SizedBox(width: 0.0, height: 0.0);
  }

  Widget copyTextToClipboard() {
    if (typingType == TypingType.InputGame)
    {
      return TextButton(
        child: const Text('拷贝 Copy'),
        style: TextButton.styleFrom(
          textStyle: TextStyle(fontSize: 20.0 * getSizeRatio()),
          side: BorderSide(
            color: Colors.blue, // The border color
            width: 2,          // The border width
          ),
          // You can also add rounded corners
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () async {
          await Clipboard.setData(ClipboardData(text: getEditFieldStringValue()));
        },
      );
    };

    return SizedBox(width: 0.0, height: 0.0);
  }

  Widget copyHashToClipboard() {
    if (typingType == TypingType.InputGame)
    {
      return Center(child: TextButton(
        child: const Text('拷贝 Copy'),
        style: TextButton.styleFrom(
          textStyle: TextStyle(fontSize: 20.0 * getSizeRatio()),
          side: BorderSide(
            color: Colors.blue, // The border color
            width: 2,          // The border width
          ),
          // You can also add rounded corners
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () async {
          await Clipboard.setData(ClipboardData(text: getHashStringValue()));
          if (inputMethod == InputMethod.Pinxin) {
            _controller.clear();
          }
          else {
            _controllerStandard.clear();
          }
        },
      ));
    };

    return SizedBox(width: 0.0, height: 0.0);
  }

  // non-Hanzishu input methods
  Widget getOtherInputMethodTextField(TextEditingController oneController, bool withQueryButton) {
    double fieldWidth = 400.0; //double.infinity
    if (withQueryButton) {
      fieldWidth = 120.0;
    }

    int maxLines = 1;
    if (typingType == TypingType.InputGame && inputMethod == InputMethod.Others) {
      maxLines = 8;
    }

    return Row(
      //mainAxisAlignment: MainAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        //SizedBox(width: 20 * getSizeRatio()),
        //Text(getString(96)/*"Basic Table"*/, style: TextStyle(fontSize: 20 * getSizeRatio(), color: Colors.blueGrey), ),

        //SizedBox(width: 10 * getSizeRatio()),

        SizedBox(
          width: fieldWidth * getSizeRatio(),
          //height: 120,
          // Note: this is the standard for Dic Search only, not related to the Hanzishu typing field.
          child: TextField(
            autocorrect: false,
            enableSuggestions: false,
            controller: oneController,
            focusNode: _focusNodeStandard,
            autofocus: false,
            style: TextStyle(
              fontSize: 20 * getSizeRatio(),
              //height: 1.0 // 1.3
            ),
            maxLines: maxLines,
            //expands: true,
            keyboardType: TextInputType.text,
            //multiline,  //TextInputType.visiblePassword
            decoration: InputDecoration(
              //hintText: 'This test',
              filled: true,
              fillColor: Colors.black12, //lightBlueAccent,
            ),
          ), //focusNode: _focusNodeStandard,
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

  showInputGameCompletedDialog() {
    Widget okButton = TextButton(
      child: Text(getString(286), style: TextStyle(color: Colors.blue)),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(getString(375)/*Result*/),
      content: Text(getString(552)),
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



  Widget getSkipThisSection() {
    if (includeSkipSection/*theIsFromLessonContinuedSection || theIsFromTypingContinuedSection || typingType == TypingType.Custom*/) {
      return TextButton(
        child: Text(
          (typingType == TypingType.FirstTyping && currentIndex == 0) ? "Skip Step" : getString(401) /*"Skip this section"*/,
          style: TextStyle(fontSize: 14.0, color: Colors.blueAccent),),
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
    if (typingType == TypingType.FreeTyping || typingType == TypingType.InputGame || typingType == TypingType.DicSearchTyping) {
      return SizedBox(width: 0.0, height: 0.0);
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(14.0 * getSizeRatio(), 10.0, 14.0 * getSizeRatio(), 10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: _progressValue,
                minHeight: 8.0 * getSizeRatio(),
                backgroundColor: Color(0xFFE9E3F4),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6A35B8)),
              ),
            ),
          ),
          SizedBox(width: 12.0 * getSizeRatio()),
          Text(
            getTypingScoreString(),
            style: TextStyle(
              fontSize: 16.0 * getSizeRatio(),
              fontWeight: FontWeight.w700,
              color: Color(0xFF2B2140),
            ),
          ),
        ],
      ),
    );
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
                //if (showHint == HintType.Hint1 ||
                //    showHint == HintType.Hint2 ||
                //    showHint == HintType.Hint3)
                SizedBox(
                  child: Text(
                      getString(90) /*"Hint"*/ + ": " +
                          getString(theZiForIntroductionList[currentIndex].hintText),
                      style: TextStyle(fontSize: fontSize), // fontSize * 1.2
                      textAlign: TextAlign.center //left
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
    if (typingType == TypingType.InputGame) {
      //if(!isInputGameInHashMode) {
      return getInputGameQuestion(currentInputGameId, currentInputGameQuestionListIndex);
      //}
      //else {
      //  return Container(width: 0.0, height: 0.0);
      //}
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

    String sentence = getCurrentSentence(typingType);

    contentList.add(SizedBox(width: 14.0 * getSizeRatio()));
    contentList.add(Text(
      promptStr,
      style: TextStyle(
        fontSize: fontSize * 1.35 * getSizeRatio(),
        fontWeight: FontWeight.w700,
        color: Color(0xFF1F1B2D),
      ),
      textAlign: TextAlign.left,
    ));
    contentList.add(SizedBox(width: 6.0 * getSizeRatio()));
    contentList.add(IconButton(
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(
        minWidth: 32.0 * getSizeRatio(),
        minHeight: 32.0 * getSizeRatio(),
      ),
      icon: Icon(
        Icons.volume_up,
        size: fontSize * 1.65 * getSizeRatio(),
      ),
      color: Color(0xFF6A35B8),
      onPressed: () {
        speakHanziAndPhrase(sentence);
      },
    ));
    contentList.add(SizedBox(width: 8.0 * getSizeRatio()));

    if (showHint == HintType.TingDa) {
      contentList.add(TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0 * getSizeRatio())),
          backgroundColor: Color(0xFFF1EBFF),
        ),
        onPressed: () {
          initOverlay();

          setState(() {
            sentenceFirstCharIndex= theInputZiManager.getNextSentenceFirstIndex(typingType, sentenceFirstCharIndex, lessonId, sentence.length);
            currentIndex = sentenceFirstCharIndex;
            if (currentIndex == -1) {
              int oneSentenceAccurateCount = InputZiManager.calculateAccurateTypedCount(listenModeTypedOneSentence, sentence);
              totalAccurateCount += oneSentenceAccurateCount;
              listenModeTypedOneSentence = "";
              theInputZiManager.initCurrentIndex();
              showCompletedDialog(currentBuildContext!);
            }
            else {
              int oneSentenceAccurateCount = InputZiManager.calculateAccurateTypedCount(listenModeTypedOneSentence, sentence);
              totalAccurateCount += oneSentenceAccurateCount;
              listenModeTypedOneSentence = "";
              speakHanziAndPhrase(getCurrentSentence(typingType));
              _focusNode.requestFocus();
            }
          });
        },
        child: Text(
          getString(532),
          style: TextStyle(fontSize: fontSize, color: Color(0xFF5B2FAA)),
          textAlign: TextAlign.left,
        ),
      ));
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

      if (charIndexInSentence.value == chars.length - 1) {
        strAfterChar = '';
      }
      else {
        strAfterChar = chars.getRange(charIndexInSentence.value + 1, chars.length).toString();
      }

      contentList.add(Flexible(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                strBeforeChar,
                style: TextStyle(
                  fontSize: fontSize * 2.0 * getSizeRatio(),
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F1B2D),
                ),
              ),
              GestureDetector(
                onTap: () {
                  TextToSpeech.speak("zh-CN", strChar);
                },
                child: Text(
                  strChar,
                  style: TextStyle(
                    fontSize: fontSize * 2.05 * getSizeRatio(),
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1F1B2D),
                  ),
                ),
              ),
              Text(
                strAfterChar,
                style: TextStyle(
                  fontSize: fontSize * 2.0 * getSizeRatio(),
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F1B2D),
                ),
              ),
            ],
          ),
        ),
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

  Widget getInputGameQuestion(int inputGameId, inputGameQuestionId) {
    var questionString = InputGameManager.getInputGameQuestionString(inputGameId, inputGameQuestionId, isCurrentlySimplifiedChineseCharacters);

    String instruction;
    if (theDefaultLocale == "en_US") {
      instruction = "[" + getString(545) + ' ' + getString(546) + ' ' +
          (inputGameQuestionId + 1).toString() + "]";
    }
    else {
      instruction = "[" + getString(545) + (inputGameQuestionId + 1).toString() + getString(546) + "]";
    }

    if (questionString.length != 0) {
      return Column(
          children: <Widget>[
            Row(
                children: <Widget>[
                  SizedBox(width: 20.0 * getSizeRatio()),
                  Text(instruction,
                      style: TextStyle(fontSize: 20.0 * getSizeRatio(),
                          fontWeight: FontWeight.bold,
                          color: Colors.brown),
                      textAlign: TextAlign.left
                  ),
                  SizedBox(width: 10.0),
                  getCharacterTypeButton(),
                ]
            ),
            Text(questionString,
                style: TextStyle(fontSize: 20.0 * getSizeRatio(),
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
                textAlign: TextAlign.left
            ),
          ]
      );
    }

    return SizedBox(width: 0.0, height: 0.0);
  }

  Widget getCharacterTypeButton() {
    // for Pinyin inputgame only
    if (typingType == TypingType.InputGame && InputGameManager.getInputGameById(currentInputGameId).gameType == 2) {
      String showCharacterTypeButtonText = "";
      if (theDefaultLocale == "en_US") {
        if (isCurrentlySimplifiedChineseCharacters) {
          showCharacterTypeButtonText = "Traditional Chinese";
        }
        else {
          showCharacterTypeButtonText = "Simplified Chinese";
        }
      }
      else { // Chinese
        if (isCurrentlySimplifiedChineseCharacters) {
          showCharacterTypeButtonText = "繁体中文";
        }
        else {
          showCharacterTypeButtonText = "简体中文";
        }
      }

      return TextButton(
          style: TextButton.styleFrom(
            textStyle: TextStyle(fontSize: 20.0 * getSizeRatio()),
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
              isCurrentlySimplifiedChineseCharacters = !isCurrentlySimplifiedChineseCharacters;
            });
          },
          child: Text(showCharacterTypeButtonText,
            style: TextStyle(
              fontSize: 20.0 * getSizeRatio(), // Set the desired font size
            ),));
    };

    return SizedBox(width: 0.0, height: 0.0);
  }

  Widget getWarningMessage() {
    var fontSize = 15.0 * getSizeRatio();     //15.0
    if (currentTypingCodeIsCorrect || currentCorrectTypingCode == "" || theZiCandidatesFromPinyin || showHint == HintType.Hint0 || showHint == HintType.Game  || showHint == HintType.TingDa || typingType == TypingType.FreeTyping || typingType == TypingType.InputGame) {
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

    if (typingType == TypingType.FreeTyping || typingType == TypingType.InputGame || typingType == TypingType.DicSearchTyping) {
      return Container(width:0.0, height: 0.0);
    }

    var fontSize = 13.0 * getSizeRatio();

    List<Widget> hintButtons = <Widget>[];
    if (firstTypedLetterHintType != HintType.TingDa) {
      hintButtons.add(_buildModernHintButton(getString(523), HintType.Hint3, fontSize));
      hintButtons.add(SizedBox(width: 8.0 * getSizeRatio()));
      hintButtons.add(_buildModernHintButton(getString(438), HintType.Hint2, fontSize));
      hintButtons.add(SizedBox(width: 8.0 * getSizeRatio()));
      hintButtons.add(_buildModernHintButton(getString(90) + "1", HintType.Hint1, fontSize));
      hintButtons.add(SizedBox(width: 8.0 * getSizeRatio()));
      hintButtons.add(_buildModernHintButton(getString(464), HintType.Hint0, fontSize));
      hintButtons.add(SizedBox(width: 8.0 * getSizeRatio()));
      hintButtons.add(_buildModernHintButton(getString(525), HintType.Game, fontSize));
    }

    if ((firstTypedLetterHintType == HintType.TingDa || firstTypedLetterHintType == HintType.None) &&
        (typingType == TypingType.FromLessons || typingType == TypingType.ThirdParty || typingType == TypingType.Custom)) {
      if (hintButtons.length > 0) {
        hintButtons.add(SizedBox(width: 8.0 * getSizeRatio()));
      }
      hintButtons.add(_buildModernHintButton(getString(531), HintType.TingDa, fontSize));
    }

    return Container(
      padding: EdgeInsets.fromLTRB(14.0 * getSizeRatio(), 8.0, 14.0 * getSizeRatio(), 8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE8E1F5), width: 1),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: hintButtons),
      ),
    );
  }

  Widget _buildModernHintButton(String label, HintType hintType, double fontSize) {
    bool isSelected = showHint == hintType;

    return SizedBox(
      height: 42.0 * getSizeRatio(),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: isSelected ? Color(0xFF6A35B8) : Colors.white,
          foregroundColor: isSelected ? Colors.white : Color(0xFF5B2FAA),
          padding: EdgeInsets.symmetric(horizontal: 14.0 * getSizeRatio()),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0 * getSizeRatio()),
            side: BorderSide(color: Color(0xFFE1D7F5), width: 1),
          ),
        ),
        onPressed: () {
          initOverlay();

          setState(() {
            showHint = hintType;
            _focusNode.requestFocus();
          });
        },
        child: Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget getHintPainter() {
    if (currentIndex < 0 || typingType == TypingType.FreeTyping ||
        typingType == TypingType.InputGame ||
        typingType == TypingType.DicSearchTyping) {
      return Container(width: 0.0, height: 0.0);
    }

    var char;
    if (typingType == TypingType.ComponentTyping) {
      char = theComponentCategoryStringIdAndTypingCharsList[lessonId]
          .chars[currentIndex];
    }
    else if (typingType == TypingType.ComponentCombinationTyping) {
      char = theComponentCombinationCharsList[lessonId].chars[currentIndex];
    }
    else {
      var zi = theInputZiManager.getZiWithComponentsAndStrokes(
          typingType, currentIndex, lessonId);
      char = zi.zi;
    }

    if (showHint != HintType.Hint1 &&
        showHint != HintType.Hint2 &&
        showHint != HintType.Hint3)  {
      return SizedBox(width: 0.0, height: 0.0);
    }

    var inputZiHintPainter = InputZiHintPainter(
      lineColor: Color(0xFF6A35B8),
      completeColor: Color(0xFF6A35B8),
      screenWidth: screenWidth,
      showHint: this.showHint,
      selectedCompIndex: selectedCompIndex,
      char: char,
      typingType: typingType!,
      typingScoreString: '',
    );

    return Container(
      padding: EdgeInsets.fromLTRB(14.0 * getSizeRatio(), 8.0, 14.0 * getSizeRatio(), 8.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFE8E1F5), width: 1),
          bottom: BorderSide(color: Color(0xFFE8E1F5), width: 1),
        ),
      ),
      child: Row(
        children: <Widget>[
          Text(
            getString(90) + ':',
            style: TextStyle(
              fontSize: 16.0 * getSizeRatio(),
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F1B2D),
            ),
          ),
          SizedBox(width: 12.0 * getSizeRatio()),
          Expanded(
            child: SizedBox(
              height: 30.0 * getSizeRatio(),
              child: CustomPaint(
                foregroundPainter: inputZiHintPainter,
              ),
            ),
          ),
        ],
      ),
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
    void closeDialogAndReturn() {
      theIsBackArrowExit = false;
      Navigator.of(context).pop(); // out this dialog
      Navigator.of(context).pop(); // to the lesson page
      // these two types support multiple sentences which is actually another layer. so pop one more time.
      if (typingType == TypingType.ThirdParty || typingType == TypingType.Custom) {
        Navigator.of(context).pop();
      }
    }

    if (typingType == TypingType.FirstTyping) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return _buildFirstTypingCompletedDialog(closeDialogAndReturn);
        },
      );
      return;
    }

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK", style: TextStyle(color: Colors.blue)),
      onPressed: closeDialogAndReturn,
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

  Widget _buildFirstTypingCompletedDialog(VoidCallback onContinue) {
    // Use a small, bounded design canvas for this success dialog, instead of
    // scaling everything from the full page width. This keeps the layout close
    // to the approved mockup on desktop and prevents the ratio from making the
    // dialog too wide or too tall.
    final rawRatio = getSizeRatio();
    final ratio = rawRatio < 0.86 ? rawRatio : 0.86;
    final primary = Color(0xFF6F35E8);
    final darkText = Color(0xFF1F1B2D);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: 28 * ratio,
        vertical: 22 * ratio,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 760 * ratio),
        child: Container(
          height: 620 * ratio,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(38 * ratio),
                  border: Border.all(color: Color(0xFFE7D7FF), width: 2 * ratio),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Color(0xFFFFFCFF),
                      Color(0xFFF5ECFF),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.22),
                      blurRadius: 42 * ratio,
                      offset: Offset(0, 20 * ratio),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.14),
                      blurRadius: 42 * ratio,
                      offset: Offset(0, 18 * ratio),
                    ),
                  ],
                ),
              ),

              // Main text block
              Positioned(
                left: 52 * ratio,
                right: 52 * ratio,
                top: 58 * ratio,
                child: Column(
                  children: [
                    Text(
                      "You Did It!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: primary,
                        fontSize: 48 * ratio,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                        letterSpacing: -0.8,
                      ),
                    ),
                    SizedBox(height: 14 * ratio),
                    _buildStepCompletePill(ratio, primary),
                    SizedBox(height: 28 * ratio),
                    Text(
                      "You typed your first\nthree Chinese characters.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: darkText,
                        fontSize: 25 * ratio,
                        fontWeight: FontWeight.w700,
                        height: 1.24,
                      ),
                    ),
                  ],
                ),
              ),

              // Key/character sequence: no big frame and no individual frames.
              Positioned(
                left: 140 * ratio, //92
                top: 330 * ratio,
                child: _buildFirstTypingSequence(ratio, primary),
              ),

              // Green mascot: raised to celebrate beside the characters.
              Positioned(
                right: 96 * ratio,
                top: 286 * ratio,
                child: _buildGreenHanzishuMascot(ratio),
              ),

              // Button
              Positioned(
                left: 200 * ratio,
                bottom: 54 * ratio,
                child: _buildLearnKeysButton(ratio, primary, onContinue),
              ),

              // Colorful celebration details. These avoid emoji rendering problems
              // where a party icon can appear black-and-white on web.
              Positioned(top: 42 * ratio, left: 48 * ratio, child: _buildConfettiIcon(ratio, 1.22)),
              Positioned(top: 38 * ratio, right: 92 * ratio, child: _buildSparkle(ratio, Color(0xFFFFC928), 24)),
              Positioned(top: 120 * ratio, left: 72 * ratio, child: _buildSparkle(ratio, Color(0xFFFFD21C), 20)),
              Positioned(top: 145 * ratio, right: 70 * ratio, child: _buildSparkle(ratio, Color(0xFFA855F7), 22)),
              Positioned(top: 250 * ratio, left: 72 * ratio, child: _buildDot(ratio, Color(0xFF17BDF4), 13)),
              Positioned(top: 254 * ratio, right: 58 * ratio, child: _buildDot(ratio, Color(0xFFFF7A7A), 12)),
              Positioned(bottom: 112 * ratio, left: 72 * ratio, child: _buildSparkle(ratio, Color(0xFF17BDF4), 16)),
              Positioned(bottom: 100 * ratio, right: 80 * ratio, child: _buildDot(ratio, Color(0xFFFFB000), 13)),
              Positioned(bottom: 40 * ratio, left: 92 * ratio, child: _buildDot(ratio, Color(0xFF67D742), 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepCompletePill(double ratio, Color primary) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18 * ratio, vertical: 7 * ratio),
      decoration: BoxDecoration(
        color: Color(0xFFF3EEFF),
        borderRadius: BorderRadius.circular(99 * ratio),
        border: Border.all(color: Color(0xFFD9C7FF), width: 1.4 * ratio),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, color: primary, size: 20 * ratio),
          SizedBox(width: 8 * ratio),
          Text(
            "Step 1 Complete",
            style: TextStyle(
              color: primary,
              fontSize: 16 * ratio,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfettiIcon(double ratio, [double scale = 1.0]) {
    return SizedBox(
      width: 76 * ratio * scale,
      height: 76 * ratio * scale,
      child: CustomPaint(
        painter: _PartyPopperPainter(),
      ),
    );
  }

  Widget _buildFirstTypingSequence(double ratio, Color primary) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSequenceText("O", ratio, primary, true),
        _buildSequenceArrow(ratio, primary),
        _buildSequenceText("口", ratio, primary, false),
        _buildSequenceArrow(ratio, primary),
        _buildSequenceText("吕", ratio, primary, false),
        _buildSequenceArrow(ratio, primary),
        _buildSequenceText("品", ratio, primary, false),
      ],
    );
  }

  Widget _buildSequenceText(String text, double ratio, Color primary, bool isKey) {
    return Text(
      text,
      style: TextStyle(
        color: isKey ? primary : Color(0xFF17122A),
        fontSize: (isKey ? 40 : 38) * ratio,
        fontWeight: FontWeight.w900,
        height: 1.0,
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6 * ratio,
            offset: Offset(0, 3 * ratio),
          ),
        ],
      ),
    );
  }

  Widget _buildSequenceArrow(double ratio, Color primary) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 11 * ratio),
      child: Icon(Icons.arrow_forward_rounded, color: primary, size: 31 * ratio),
    );
  }

  Widget _buildLearnKeysButton(double ratio, Color primary, VoidCallback onContinue) {
    return SizedBox(
      width: 360 * ratio,
      height: 68 * ratio,
      child: ElevatedButton(
        onPressed: onContinue,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 9,
          shadowColor: primary.withOpacity(0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24 * ratio),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Learn the 25 Keys",
              style: TextStyle(
                fontSize: 23 * ratio,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(width: 14 * ratio),
            Icon(Icons.arrow_forward_rounded, size: 28 * ratio),
          ],
        ),
      ),
    );
  }

  Widget _buildGreenHanzishuMascot(double ratio) {
    return SizedBox(
      width: 126 * ratio,
      height: 156 * ratio,
      child: CustomPaint(
        painter: _GreenHanzishuMascotPainter(),
      ),
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
class _PartyPopperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final conePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [Color(0xFF7C3AED), Color(0xFFFFB000)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final cone = Path()
      ..moveTo(w * 0.20, h * 0.78)
      ..lineTo(w * 0.52, h * 0.36)
      ..lineTo(w * 0.62, h * 0.88)
      ..close();
    canvas.drawPath(cone, conePaint);

    final stripePaint = Paint()
      ..color = Colors.white.withOpacity(0.68)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.055
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.30, h * 0.67), Offset(w * 0.56, h * 0.76), stripePaint);
    canvas.drawLine(Offset(w * 0.39, h * 0.54), Offset(w * 0.59, h * 0.61), stripePaint);

    final ribbonPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.055
      ..strokeCap = StrokeCap.round;

    ribbonPaint.color = Color(0xFFFF5E7E);
    final ribbon1 = Path()
      ..moveTo(w * 0.48, h * 0.24)
      ..cubicTo(w * 0.58, h * 0.10, w * 0.75, h * 0.18, w * 0.66, h * 0.32);
    canvas.drawPath(ribbon1, ribbonPaint);

    ribbonPaint.color = Color(0xFF17BDF4);
    final ribbon2 = Path()
      ..moveTo(w * 0.62, h * 0.30)
      ..cubicTo(w * 0.79, h * 0.22, w * 0.90, h * 0.34, w * 0.80, h * 0.44);
    canvas.drawPath(ribbon2, ribbonPaint);

    ribbonPaint.color = Color(0xFF72D72B);
    final ribbon3 = Path()
      ..moveTo(w * 0.43, h * 0.30)
      ..cubicTo(w * 0.30, h * 0.18, w * 0.19, h * 0.34, w * 0.31, h * 0.43);
    canvas.drawPath(ribbon3, ribbonPaint);

    void dot(double x, double y, double r, Color color) {
      canvas.drawCircle(Offset(w * x, h * y), w * r, Paint()..color = color);
    }

    dot(0.52, 0.10, 0.035, Color(0xFFFFC928));
    dot(0.76, 0.12, 0.030, Color(0xFFA855F7));
    dot(0.88, 0.28, 0.032, Color(0xFFFF7A7A));
    dot(0.28, 0.18, 0.028, Color(0xFF17BDF4));

    final sparklePaint = Paint()
      ..color = Color(0xFFFFC928)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.035
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.16, h * 0.28), Offset(w * 0.16, h * 0.43), sparklePaint);
    canvas.drawLine(Offset(w * 0.09, h * 0.36), Offset(w * 0.23, h * 0.36), sparklePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GreenHanzishuMascotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.12)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, w * 0.055);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.50, h * 0.92),
        width: w * 0.74,
        height: h * 0.11,
      ),
      shadowPaint,
    );

    // Bean-like green mascot body, closer to the dictionary-cover mascot than
    // to the Hanzishu logo leaf.
    final body = Path()
      ..moveTo(w * 0.48, h * 0.10)
      ..cubicTo(w * 0.23, h * 0.12, w * 0.10, h * 0.34, w * 0.12, h * 0.58)
      ..cubicTo(w * 0.14, h * 0.82, w * 0.32, h * 0.94, w * 0.52, h * 0.93)
      ..cubicTo(w * 0.76, h * 0.92, w * 0.91, h * 0.75, w * 0.88, h * 0.53)
      ..cubicTo(w * 0.84, h * 0.29, w * 0.68, h * 0.12, w * 0.48, h * 0.10)
      ..close();

    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFC7F86C), Color(0xFF85D83D), Color(0xFF55B62A)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(body, bodyPaint);

    final outlinePaint = Paint()
      ..color = Color(0xFF3EAD22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.034
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(body, outlinePaint);

    final highlightPaint = Paint()..color = Colors.white.withOpacity(0.22);
    canvas.drawOval(
      Rect.fromLTWH(w * 0.22, h * 0.24, w * 0.23, h * 0.16),
      highlightPaint,
    );

    // Short curved top tail like the green mascot, not the Hanzishu logo.
    final tailPaint = Paint()
      ..color = Color(0xFF59BB2D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.060
      ..strokeCap = StrokeCap.round;
    final tail = Path()
      ..moveTo(w * 0.47, h * 0.12)
      ..cubicTo(w * 0.40, h * 0.06, w * 0.45, h * 0.02, w * 0.53, h * 0.04);
    canvas.drawPath(tail, tailPaint);

    // Arms celebrating.
    final armPaint = Paint()
      ..color = Color(0xFF60C82E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.072
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.18, h * 0.58), Offset(w * 0.04, h * 0.48), armPaint);
    canvas.drawLine(Offset(w * 0.82, h * 0.57), Offset(w * 0.98, h * 0.45), armPaint);

    final handPaint = Paint()..color = Color(0xFF60C82E);
    canvas.drawCircle(Offset(w * 0.04, h * 0.48), w * 0.045, handPaint);
    canvas.drawCircle(Offset(w * 0.98, h * 0.45), w * 0.045, handPaint);

    // Small brush in the raised hand, echoing the original mascot image.
    final brushPaint = Paint()
      ..color = Color(0xFF8B5A2B)
      ..strokeWidth = w * 0.030
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.92, h * 0.40), Offset(w * 1.08, h * 0.28), brushPaint);
    final brushTip = Paint()..color = Color(0xFF2B1B12);
    final tip = Path()
      ..moveTo(w * 1.08, h * 0.28)
      ..lineTo(w * 1.15, h * 0.24)
      ..lineTo(w * 1.11, h * 0.33)
      ..close();
    canvas.drawPath(tip, brushTip);

    final eyePaint = Paint()..color = Color(0xFF58331F);
    canvas.drawOval(Rect.fromLTWH(w * 0.32, h * 0.42, w * 0.085, h * 0.11), eyePaint);
    canvas.drawOval(Rect.fromLTWH(w * 0.60, h * 0.42, w * 0.085, h * 0.11), eyePaint);

    final eyeHighlight = Paint()..color = Colors.white.withOpacity(0.90);
    canvas.drawCircle(Offset(w * 0.36, h * 0.45), w * 0.016, eyeHighlight);
    canvas.drawCircle(Offset(w * 0.64, h * 0.45), w * 0.016, eyeHighlight);

    final cheekPaint = Paint()..color = Color(0xFFFF9DB5).withOpacity(0.58);
    canvas.drawOval(Rect.fromLTWH(w * 0.22, h * 0.57, w * 0.13, h * 0.07), cheekPaint);
    canvas.drawOval(Rect.fromLTWH(w * 0.67, h * 0.57, w * 0.13, h * 0.07), cheekPaint);

    final mouthPaint = Paint()
      ..color = Color(0xFF8F2B20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.034
      ..strokeCap = StrokeCap.round;
    final mouth = Path()
      ..moveTo(w * 0.42, h * 0.61)
      ..quadraticBezierTo(w * 0.50, h * 0.69, w * 0.59, h * 0.61);
    canvas.drawPath(mouth, mouthPaint);

    final legPaint = Paint()
      ..color = Color(0xFF4DAF25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.066
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.39, h * 0.90), Offset(w * 0.34, h * 0.98), legPaint);
    canvas.drawLine(Offset(w * 0.62, h * 0.90), Offset(w * 0.68, h * 0.98), legPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AlphabetToyCubePainter extends CustomPainter {
  final Color frontColor;
  final Color sideColor;
  final Color topColor;
  final double depth;
  final double radius;

  _AlphabetToyCubePainter({
    required this.frontColor,
    required this.sideColor,
    required this.topColor,
    required this.depth,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cubeSize = size.width - depth;

    // Use clean aligned planes instead of a rounded-card face. This keeps the
    // object reading as a real cube: top + side + front all meet at the same
    // corners, so the block no longer looks visually broken.
    final topLeft = Offset(depth, 0);
    final topRight = Offset(depth + cubeSize, 0);
    final frontTopLeft = Offset(0, depth);
    final frontTopRight = Offset(cubeSize, depth);
    final frontBottomRight = Offset(cubeSize, depth + cubeSize);
    final frontBottomLeft = Offset(0, depth + cubeSize);
    final sideTopRight = Offset(cubeSize + depth, 0);
    final sideBottomRight = Offset(cubeSize + depth, cubeSize);

    final topPath = Path()
      ..moveTo(frontTopLeft.dx, frontTopLeft.dy)
      ..lineTo(frontTopRight.dx, frontTopRight.dy)
      ..lineTo(sideTopRight.dx, sideTopRight.dy)
      ..lineTo(topLeft.dx, topLeft.dy)
      ..close();

    final sidePath = Path()
      ..moveTo(frontTopRight.dx, frontTopRight.dy)
      ..lineTo(sideTopRight.dx, sideTopRight.dy)
      ..lineTo(sideBottomRight.dx, sideBottomRight.dy)
      ..lineTo(frontBottomRight.dx, frontBottomRight.dy)
      ..close();

    final frontPath = Path()
      ..moveTo(frontTopLeft.dx, frontTopLeft.dy)
      ..lineTo(frontTopRight.dx, frontTopRight.dy)
      ..lineTo(frontBottomRight.dx, frontBottomRight.dy)
      ..lineTo(frontBottomLeft.dx, frontBottomLeft.dy)
      ..close();

    final frontRect = Rect.fromLTWH(0, depth, cubeSize, cubeSize);

    // Soft shadow below and slightly behind the cube.
    final shadowPaint = Paint()
      ..color = sideColor.withOpacity(0.30)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, depth * 0.78);
    canvas.drawPath(frontPath.shift(Offset(depth * 0.24, depth * 0.36)), shadowPaint);

    final topPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          topColor,
          frontColor.withOpacity(0.74),
        ],
      ).createShader(topPath.getBounds());
    canvas.drawPath(topPath, topPaint);

    final sidePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          frontColor.withOpacity(0.86),
          sideColor,
        ],
      ).createShader(sidePath.getBounds());
    canvas.drawPath(sidePath, sidePaint);

    final frontPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          topColor.withOpacity(0.95),
          frontColor,
          sideColor.withOpacity(0.96),
        ],
        stops: [0.0, 0.56, 1.0],
      ).createShader(frontRect);
    canvas.drawPath(frontPath, frontPaint);

    // Broad front glow for the shiny toy-block look.
    final glowPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment(-0.60, -0.72),
        radius: 1.14,
        colors: [
          Colors.white.withOpacity(0.48),
          Colors.white.withOpacity(0.10),
          Colors.transparent,
        ],
        stops: [0.0, 0.42, 1.0],
      ).createShader(frontRect);
    canvas.drawPath(frontPath, glowPaint);

    // Glossy highlight strip on the front face.
    final highlightRect = Rect.fromLTWH(
      cubeSize * 0.13,
      depth + cubeSize * 0.12,
      cubeSize * 0.55,
      cubeSize * 0.15,
    );
    final highlight = RRect.fromRectAndRadius(
      highlightRect,
      Radius.circular(cubeSize * 0.08),
    );
    final highlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.white.withOpacity(0.50),
          Colors.white.withOpacity(0.10),
        ],
      ).createShader(highlightRect);
    canvas.drawRRect(highlight, highlightPaint);

    // Crisp edges make it read as a cube, not a rounded tile.
    final edgePaint = Paint()
      ..color = Colors.white.withOpacity(0.40)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.35;
    canvas.drawPath(topPath, edgePaint);
    canvas.drawPath(sidePath, edgePaint);
    canvas.drawPath(frontPath, edgePaint);

    final creasePaint = Paint()
      ..color = Colors.black.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawLine(frontTopRight, sideTopRight, creasePaint);
    canvas.drawLine(frontBottomRight, sideBottomRight, creasePaint);
  }

  @override
  bool shouldRepaint(covariant _AlphabetToyCubePainter oldDelegate) {
    return oldDelegate.frontColor != frontColor ||
        oldDelegate.sideColor != sideColor ||
        oldDelegate.topColor != topColor ||
        oldDelegate.depth != depth ||
        oldDelegate.radius != radius;
  }
}

