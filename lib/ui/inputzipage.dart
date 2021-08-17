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
  //String previousText = "";
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

  String getInputTextByIndex(int index) {
    //var startComposing = _controller.value.composing.start;
    //var endComposing = _controller.value.composing.end;
    var newInputText = _controller.value.text.substring(0, previousStartComposing);
    var ziCandidate = InputZiManager.getZiCandidateByIndex(index);
    if (ziCandidate != null) {
      var ziStr = ziCandidate.zi; //inputKeyLetter;
      newInputText += ziStr;
    }

    if(previousEndComposing + 1 <= _controller.value.text.length) {
      newInputText += _controller.value.text.substring(
          previousEndComposing + 1, _controller.value.text.length);
    }

    return newInputText;
    //return _controller.value.composing.textBefore(_controller.value.text) + str + _controller.value.composing.textAfter(_controller.value.text);
  }

  String getFullComposingText(String inputKeyLetter) {
    var startComposing = _controller.value.composing.start;
    var endComposing = _controller.value.composing.end;

    var str = "";
    if (endComposing > startComposing) {
      str = _controller.value.text.substring(startComposing, endComposing);
    }

    // seems no need for this value, just use composing string directly.
    //str += inputKeyLetter;

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

  void handleKeyInput() {
    //if (previousText.length == _controller.text.length && previousText == _controller.text) {
      // it just tells us the new value with the composing result. nothing to do.
    //  return;
    //}

    if (justCompletedPosting) {
      justCompletedPosting = false;
      return;
    }

    print('Second text field: ${_controller.text}');
    // get text[composing.end] value, which is inputKeyLetter
    String latestInputKeyLetter = "";

    if (_controller.value.composing.end > 0) {
      // composing can be in the middle positiob of the text
      latestInputKeyLetter = _controller.text[_controller.value.composing
        .end - 1];
    }
    else {
      var len = _controller.text.length;
      if (len > 0) {
        latestInputKeyLetter = _controller.text[len - 1];
      }
    }

    var lett = isALetter(latestInputKeyLetter);

    if (latestInputKeyLetter == " " /*32*/) { // space key
      setTextBySelectionIndex(0);
      setState(() {
        updateCounter += 1;
      });
    }
    else if (isALetter(latestInputKeyLetter)) {
      var composingText = getFullComposingText(latestInputKeyLetter);
      theCurrentZiCandidates = InputZiManager.getZiCandidates(composingText);

      previousStartComposing = _controller.value.composing.start;
      previousEndComposing = _controller.value.composing.end;

      setState(() {
        updateCounter += 1;
      });
    }

    //previousText = _controller.text;
  }

  void setTextBySelectionIndex(int selectionIndex) {
    var newText = getInputTextByIndex(selectionIndex);
    _controller.clearComposing();
    previousStartComposing = -1;
    previousEndComposing = -1;
    justCompletedPosting = true;

    //now reset controller which will notify the listeners right away
    _controller.text = newText;
    //_controller.text += st; //'好';
    //Note: set cursor to the end of of the current editing
    _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));

    // reset the candidate. might set to global ini value
    theCurrentZiCandidates = theDefaultZiCandidates;
  }

  @override
  Widget build(BuildContext context) {
    /*
    return TextField(
        controller: _controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Full Name',
        ),
        //focusNode: _textNode,
      );
      */

    screenWidth = Utility.getScreenWidth(context);

    var inputZiPainter = InputZiPainter(
        lineColor: Colors.amber,
        completeColor: Colors.blueAccent,
        lessonId: 1, /*TODO: temp*/
        //completePercent: percentage,
        screenWidth: 350 /*TODO: temp*/
    );

    //List<String> listOfCandidates;

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
              width: double.infinity,
              //height: 50,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Full Name',
                ),
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
        height: 40.0, //posiAndSize.height,
        width: 40.0 * zi.length, //posiAndSize.width,
        child: butt
    );

    xPosi.value += (40.0 * zi.length + 30.0);

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