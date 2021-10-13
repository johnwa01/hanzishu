import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/engine/inputzimanager.dart';
import 'package:hanzishu/ui/inputzipainter.dart';
import 'package:hanzishu/ui/inputzicomponentpainter.dart';
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

  String getFullComposingText(String inputKeyLetter) {
    var startComposing = _controller.value.composing.start;
    var endComposing = _controller.value.composing.end;

    var str = "";
    if (endComposing > startComposing) {
      str = _controller.value.text.substring(startComposing, endComposing);
    }

    return str;
  }

  bool isALetter(String value) {
    if(value.length > 0) {
      var charCodeUnits = value[0].codeUnits;

      if (charCodeUnits.length == 1 && charCodeUnits[0] >= 97 && charCodeUnits[0] <= 122 ) {  // value is between a and z
        return true;
      }
    }

    return false;
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
    // for guarded typing
    if (typingType != TypingType.FreeTyping) {
      //var comp = theInputZiManager.getZiWithComponentsAndStrokes(currentIndex) ;
      if (theInputZiManager.doesTypingResultContainTheZi(typingType, currentIndex, _controller.text)) {
        setState(() {
          if ((currentIndex + 1) == theInputZiManager.getTotal(typingType)) {
              showCompletedDialog(currentBuildContext);
          }
          currentIndex++;
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
    else if (isNumberOneToSeven(latestInputKeyLetter)) {
      //if (!justCompletedPosting) {
        setTextBySelectionIndex(getZeroBasedNumber(latestInputKeyLetter));
      //}
    }
    else if (isALetter(latestInputKeyLetter)) {
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

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Input Zi"),
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
            onPressed: () {},
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
    // an empty box
    if (typingType == TypingType.FreeTyping) {
      return SizedBox(
        width: double.infinity,
        height: 0,
      );
    }

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