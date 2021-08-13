import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hanzishu/engine/inputzimanager.dart';
import 'dart:core';

class InputZiPage extends StatefulWidget {
  InputZiPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _InputZiPageState createState() => _InputZiPageState();
}

class _InputZiPageState extends State<InputZiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Input zi',
            ),
            SizedBox(
              width: double.infinity,
              height: 300,
              child: KeyboardListener(),
            )
          ],
        ),
      ),
    );
  }
}

class KeyboardListener extends StatefulWidget {
  KeyboardListener();

  @override
  _KeyboardListenerState createState() => new _KeyboardListenerState();
}

class _KeyboardListenerState extends State<KeyboardListener> {
  TextEditingController _controller = new TextEditingController();
  FocusNode _textNode = new FocusNode();
  int previousStartComposing = -1;
  int previousEndComposing = -1;
  //String previousText = "";
  bool justCompletedPosting = false;

  @override
  initState() {
    super.initState();
    
    _controller.addListener(handleKeyInput);
  }

  String getInputText() {
    //var startComposing = _controller.value.composing.start;
    //var endComposing = _controller.value.composing.end;
    var newInputText = _controller.value.text.substring(0, previousStartComposing);
    var firstZiCandidate = InputZiManager.getFirstZiCandidate();
    if (firstZiCandidate != null) {
      var firstZiStr = firstZiCandidate.zi; //inputKeyLetter;
      newInputText += firstZiStr;
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

    if (latestInputKeyLetter == " " /*32*/) { // space key
      //var newText = getInputText('好');
      var newText = getInputText();
      _controller.clearComposing();
      previousStartComposing = -1;
      previousEndComposing = -1;
      justCompletedPosting = true;

      //now reset controller which will notify the listeners right away
      _controller.text = newText;
      //_controller.text += st; //'好';

      // set cursor at the end of the text.
      var tst = _controller.selection;
      var tstStart = tst.start;

      //TextSelection txtSel = new TextSelection(2, 2,  );

      // why have to focus the cursor every time?
      // why start from beginning every time?
      //_controller.selection.start = 2;
      //_controller.selection.end = 2;

    }
    else if (latestInputKeyLetter != "") {
      var composingText = getFullComposingText(latestInputKeyLetter);
      var ziCandidates = InputZiManager.getZiCandidates(composingText);

      previousStartComposing = _controller.value.composing.start;
      previousEndComposing = _controller.value.composing.end;
    }

    //previousText = _controller.text;
  }

  @override
  Widget build(BuildContext context) {
    return /*RawKeyboardListener(
      focusNode: _textNode,
      onKey: (key) => handleKey(key.data),
      child:*/ TextField(
        controller: _controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Full Name',
        ),
        //focusNode: _textNode,
      );
    //);
  }
}