import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hanzishu/engine/inputzimanager.dart';
import 'package:hanzishu/ui/inputzipainter.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/variables.dart';
import 'dart:core';

class InputZiPage extends StatefulWidget {
  InputZiPage();

  @override
  _InputZiPageState createState() => new _InputZiPageState();
}

class _InputZiPageState extends State<InputZiPage> {
  double screenWidth;
  TextEditingController _controller = new TextEditingController();
  FocusNode _textNode = new FocusNode();
  int previousStartComposing = -1;
  int previousEndComposing = -1;
  String previousText = "";
  bool justCompletedPosting = false;
  List<String> ziCandidates = null;


  int updateCounter = 0;

  @override
  initState() {
    super.initState();
    
    _controller.addListener(handleKeyInput);

    setState(() {
      updateCounter =0;
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
        newInputText = _controller.value.text;
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
      if (!justCompletedPosting) {
        setTextBySelectionIndex(selectionIndex);
      }
    }
    else if (isNumberOneToSeven(latestInputKeyLetter)) {
      if (!justCompletedPosting) {
        setTextBySelectionIndex(getZeroBasedNumber(latestInputKeyLetter));
      }
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
    screenWidth = Utility.getScreenWidth(context);

    var inputZiPainter = InputZiPainter(
        lineColor: Colors.amber,
        completeColor: Colors.blueAccent,
        lessonId: 1, /*TODO: temp*/
        screenWidth: 350 /*TODO: temp*/
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

          SizedBox(
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
          ),

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
                maxLines: 3,
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

  Positioned getZiCandidateButton(PrimitiveWrapper xPosi, int candidateIndex, String zi) {
    var butt = FlatButton(
      color: Colors.white,
      textColor: Colors.blueAccent,
      onPressed: () {
        setTextBySelectionIndex(candidateIndex);
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
}