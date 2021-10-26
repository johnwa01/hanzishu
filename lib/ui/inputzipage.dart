import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/engine/inputzimanager.dart';
import 'package:hanzishu/engine/componentmanager.dart';
import 'package:hanzishu/ui/inputzipainter.dart';
import 'package:hanzishu/ui/inputzicomponentpainter.dart';
import 'package:hanzishu/ui/inputzihelppage.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/variables.dart';

import 'dart:core';

class InputZiPage extends StatefulWidget {
  final TypingType typingType;
  InputZiPage({this.typingType});
  @override
  _InputZiPageState createState() => new _InputZiPageState();
}

class _InputZiPageState extends State<InputZiPage> {
  TypingType typingType;
  int currentIndex;
  BuildContext currentBuildContext;
  double _progressValue;
  int totalQuestions;
  double screenWidth;
  TextEditingController _controller = new TextEditingController();
  FocusNode _textNode = new FocusNode();
  int previousStartComposing = -1;
  int previousEndComposing = -1;
  String previousText = "";
  bool justCompletedPosting = false;
  List<String> ziCandidates = null;
  bool isCurrentlyUnderChoiceSelection = false;
  OverlayEntry overlayEntry;
  //TypingType previousOverlayType = TypingType.FreeTyping;
  //int previousOverlayIndex = 0;
  var previousOverlayParameters = InputZiOverlayParameters(TypingType.FreeTyping, 0, false, '');

  int updateCounter = 0;

  @override
  initState() {
    super.initState();

    _controller.addListener(handleKeyInput);
    _progressValue = 0.0;
    totalQuestions = theInputZiManager.getTotal(widget.typingType);

    setState(() {
      updateCounter =0;
      currentIndex = 0;
    });
  }

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

  String getInputText(int index) {
    var newInputText = "";
    var composingString = "";

    if (_controller.value.text != null && _controller.value.text.length != 0) {
      if (previousStartComposing != -1) {
        newInputText = _controller.value.text.substring(0, previousStartComposing);
      }
      else {
        var str = _controller.value.text;
        // check if last letter is a choice number, in this case, not a real input and need to be removed
        if (isNumberOneToSeven(str[_controller.value.text.length - 1]) || str[_controller.value.text.length - 1] == " ") {
          newInputText = _controller.value.text.substring(0, _controller.value.text.length - 1);
        }
        else {
          newInputText = _controller.value.text;
        }
      }
    }

    var candidateZiString = InputZiManager.getCandidateZiString(index);
    if (candidateZiString != null) {
      newInputText += candidateZiString;
    }

    if(previousEndComposing != -1 && (previousEndComposing + 1) <= _controller.value.text.length) {
      newInputText += _controller.value.text.substring(
          previousEndComposing + 1, _controller.value.text.length);
    }

    return newInputText;
  }

  showOverlay(BuildContext context, InputZiOverlayParameters overlayParameters/*TypingType type, int index, bool isFullComponents, String fullComponentsLetter*/) {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }

    //if (!(previousOverlayType == type && previousOverlayIndex == index)) {
    if (!overlayParameters.isEqual(previousOverlayParameters)) {
        var imageName;
        var fullPath;
        if (overlayParameters.isFullComponents) {
            if (overlayParameters.fullComponentsLetter == 'Z') {
              imageName = "GG4.png";
            }
            else {
              var pair = ComponentManager.getGroupAndIndexFromLetter(
                  overlayParameters.fullComponentsLetter);
              var fullExpandedComponent = theComponentManager.getFullExpandedComponentByGroupAndIndex(pair.groupNumber, pair.indexInGroup);
              imageName = fullExpandedComponent.imageName;
            }
            fullPath = "assets/typing/" + imageName;
        }
        else {
          imageName = theInputZiManager
              .getZiWithComponentsAndStrokes(typingType, currentIndex)
              .hintImage;
          fullPath = "assets/typingexercise/" + imageName;
        }

        OverlayState overlayState = Overlay.of(context);
        overlayEntry = OverlayEntry(
            builder: (context) =>
                Positioned(
                  top: 85.0, //posiY,
                  left: 0.0, //posiX,
                  child: Image.asset(
                    fullPath,
                    width: 410.0,
                    height: 140.0,
                    //fit: BoxFit.fitWidth,
                  ),
                ));
        overlayState.insert(overlayEntry);
        //previousOverlayType = type;
        //previousOverlayIndex = index;
        previousOverlayParameters.assign(overlayParameters);
      }
      else {
        previousOverlayParameters.init();
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

      if (charCodeUnits.length == 1 && charCodeUnits[0] >= 49 && charCodeUnits[0] <= 55 ) {  // value is between a and z
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

  void setTextBySelectionIndex(int selectionIndex) {
    var newText = getInputText(selectionIndex);

    previousStartComposing = -1;
    previousEndComposing = -1;
    previousText = newText;
    justCompletedPosting = true;

    // reset the candidate. might set to global ini value
    theCurrentZiCandidates = theDefaultZiCandidates;

    _controller.clearComposing();

    //now reset controller which will notify the listeners right away
    _controller.text = newText;

    //_controller.text += st; //'好';
    //Note: set cursor to the end of of the current editing
    _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
  }

  void handleKeyInput() {
    handleKeyInputHelper(0);
  }

  void handleKeyInputHelper(int selectionIndex) {
    if (currentIndex < 0) {
      return;
    }

    // for guarded typing
    if (typingType != TypingType.FreeTyping) {
      //var comp = theInputZiManager.getZiWithComponentsAndStrokes(currentIndex) ;
      if (theInputZiManager.doesTypingResultContainTheZi(typingType, currentIndex, _controller.text)) {
        setState(() {
          if ((currentIndex + 1) == theInputZiManager.getTotal(typingType)) {
              showCompletedDialog(currentBuildContext);
          }
          currentIndex = theInputZiManager.getNextIndex(typingType, currentIndex);
        });

        return;
      }
    }

    if (isCurrentlyUnderChoiceSelection) {
      return;
    }

    print('Second text field: ${_controller.text}');
    String latestInputKeyLetter = "";

    /*
    if (_controller.value.composing.end > 0) {
      // composing can be in the middle position of the text
      latestInputKeyLetter = _controller.text[_controller.value.composing
        .end - 1];
    }
    else {
      // this is as early as the place to check this. ex: notified with controller text update but without real change.
      if (justCompletedPosting) {
        if (_controller.text == previousText) {
          return;
        }
      }

      var len = _controller.text.length;
      if (len > 0) {
        latestInputKeyLetter = _controller.text[len - 1];
      }
    }
    */

    // this is as early as the place to check this. ex: notified with controller text update but without real change.
    if (justCompletedPosting && _controller.text == previousText) {
        if (_controller.value.composing.end > 0) {
          // TODO: work around for now. for some reason, the controller puts back the previous value to the composing.
          _controller.clearComposing();
        }
        return;
    }

    if (_controller.value.composing.end > 0) {
      // composing can be in the middle position of the text
      latestInputKeyLetter = _controller.text[_controller.value.composing
        .end - 1];
    }
    else {
      var len = _controller.text.length;
      if (len > 0) {
        latestInputKeyLetter = _controller.text[len - 1];
      }
    }

    if (latestInputKeyLetter == " " /*32*/) { // space key
      //if (!justCompletedPosting) {
        setTextBySelectionIndex(selectionIndex);
      //4}
    }
    else if (Utility.isAUpperCaseLetter(latestInputKeyLetter)) { // space key
      var overlayParameters = InputZiOverlayParameters(typingType, currentIndex, true, latestInputKeyLetter);
      showOverlay(context, overlayParameters);
    }
    else if (isNumberOneToSeven(latestInputKeyLetter)) {
      //if (!justCompletedPosting) {
        setTextBySelectionIndex(getZeroBasedNumber(latestInputKeyLetter));
      //}
    }
    else if (Utility.isALowerCaseLetter(latestInputKeyLetter)) {
      // reset the completed flag. reset only at this time.
      justCompletedPosting = false;

      var composingText = getFullComposingText(latestInputKeyLetter);
      theCurrentZiCandidates = InputZiManager.getZiCandidates(composingText);
      if (theCurrentZiCandidates == null) {
        List<String> composingList =  [composingText];
        theCurrentZiCandidates = composingList;
      }

      previousStartComposing = _controller.value.composing.start;
      previousEndComposing = _controller.value.composing.end;
    }
  }

  @override
  Widget build(BuildContext context) {
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

    typingType = widget.typingType; //theComponentManager.getCurrentType();
    theInputZiManager.setCurrentType(typingType);

    screenWidth = Utility.getScreenWidth(context);

    var inputZiPainter = InputZiPainter(
        lineColor: Colors.amber,
        completeColor: Colors.blueAccent,
        lessonId: 1, /*TODO: temp*/
        screenWidth: screenWidth //350 /*TODO: temp*/
    );

    var title = 'Hanzishu Component Input Method';
    if (typingType == TypingType.ThreeOrMoreComponents) {
      title = 'Characters with 3 or more components';
    }
    else if (typingType == TypingType.TwoComponents) {
      title = 'Characters with 2 components';
    }
    else if (typingType == TypingType.OneComponent) {
      title = 'Characters with 1 component';
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
                keyboardType: TextInputType.multiline,
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
              //theStatisticsManager.trackTimeAndTap();
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
        padding: EdgeInsets.all(10),
      );
    }
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

    String instruction;
    if (typingType == TypingType.ThreeOrMoreComponents) {
      instruction = "Type the given character. Break the character into components and input them in sequence through keyboard until you make a selection.";
    }
    else if (typingType == TypingType.TwoComponents) {
      instruction = "Type the given character. Break the character into 2 components. Input them in sequence first, then the last stroke of the 1st & 2nd component.";
    }
    else if (typingType == TypingType.OneComponent) {
      instruction = "Type the given character. Input its only component first, then up to 3 strokes (1st, 2nd, and last stroke) until you make a selection.";
    }

    var zi = theInputZiManager.getZiWithComponentsAndStrokes(typingType, currentIndex);

    var fontSize = 18.0;


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
          SizedBox(height: fontSize),

          Row(
              children: <Widget>[
                Flexible(
                  child: Text(
                      "Please type: ",
                      style: TextStyle(fontSize: fontSize),
                      textAlign: TextAlign.left
                  ),
                ),
                SizedBox(width: fontSize),
                Flexible(
                  child: Text(
                      zi.zi,
                      style: TextStyle(fontSize: fontSize * 2.0, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                      textAlign: TextAlign.left
                  ),
                ),
                SizedBox(width: fontSize * 3.0),
                FlatButton(
                  color: Colors.white,
                  textColor: Colors.blueAccent,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    if (overlayEntry != null) {
                        overlayEntry.remove();
                        overlayEntry = null;
                    }

                    var overlayParameters = InputZiOverlayParameters(typingType, currentIndex, false, '');
                    showOverlay(context, overlayParameters);
                  },
                  child: Text(
                    "Hint",
                    style: TextStyle(fontSize: fontSize),
                    textAlign: TextAlign.left
                  ),
                ),
              ]
          ),

        ]
      ),
      onWillPop: _onWillPop
    );

    /*
    var inputZiComponentPainter = InputZiComponentPainter(
        lineColor: Colors.amber,
        completeColor: Colors.blueAccent,
        currentIndex: currentIndex, /*TODO: temp*/
        screenWidth: screenWidth, //350, /*TODO: temp*/
        typingType: typingType
    );

    return SizedBox(
      width: double.infinity,
      height: 155,
      child:  CustomPaint(
        foregroundPainter: inputZiComponentPainter,
        //size: new Size(screenWidth, 60 /*TODO: more precise. contentLength.value*/),
      ),
    );
    */
  }

  Positioned getZiCandidateButton(PrimitiveWrapper xPosi, int candidateIndex, String zi) {
    var butt = FlatButton(
      color: Colors.white,
      textColor: Colors.blueAccent,
      onPressed: () {
        // this lock mechanism seems working fine, but not sure ...
        isCurrentlyUnderChoiceSelection = true;
        setTextBySelectionIndex(candidateIndex);
        isCurrentlyUnderChoiceSelection = false;
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

    if (typingType == TypingType.OneComponent) {
      title = "Congratulation!";
      content = "You have completed all the training sessions! You can now start your own typing.";
    }
    else {
      title = "Good job!";
      content = "You have completed this session and can move on to the next one now.";
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