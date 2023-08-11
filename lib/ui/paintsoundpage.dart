
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/engine/paintsoundmanager.dart';
import 'package:hanzishu/engine/texttospeech.dart';

class PaintSoundPage extends StatefulWidget {
  final SoundCategory currentSoundCategory;
  final int currentSoundViewIndex;

  PaintSoundPage(this.currentSoundCategory, this.currentSoundViewIndex);

  @override
  _PaintSoundPageState createState() => _PaintSoundPageState();
}

class _PaintSoundPageState extends State<PaintSoundPage> {
  double screenWidth;
  ScrollController _scrollController;
  PrimitiveWrapper contentLength = PrimitiveWrapper(0.0);
  OverlayEntry overlayEntry;
  int previousOverlayGroup = 0;
  int previousOverlayIndex = 0;

  SoundCategory currentSoundCategory;
  int currentSoundViewIndex;
  int currentSoundViewSubIndex = 1; // not used yet

  /*
  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }
*/

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }

  @override
  void initState() {
    super.initState();
    currentSoundCategory = widget.currentSoundCategory;
    currentSoundViewIndex = widget.currentSoundViewIndex;

    _scrollController = ScrollController()
      ..addListener(() {
        //print("offset = ${_scrollController.offset}");
      });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // it is a good practice to dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidth(context);
    // init positionmanager frame size
    thePositionManager.setFrameWidth(screenWidth);

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(getString(423)/*"画音入门"*/),
      ),
      body: Container(
        //height: 800.00,

        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: WillPopScope(
              child: getPaintSoundView(context),
              onWillPop: _onWillPop
          ),
        ),

      ),
    );
  }

  initOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
      theDicOverlayEntry = null;
    }
  }

  Future<bool>_onWillPop() {
    initOverlay();

    return Future.value(true);
  }

  showOverlay(BuildContext context, keyGroup, keyIndex) {
    initOverlay();

    if (!(keyGroup == 0 && keyIndex == 0) && !(previousOverlayGroup == keyGroup && previousOverlayIndex == keyIndex)) {
      var fullExpandedComp = theComponentManager
          .getFullExpandedComponentByGroupAndIndex(keyGroup, keyIndex);

      OverlayState overlayState = Overlay.of(context);
      overlayEntry = OverlayEntry(
          builder: (context) =>
              Positioned(
                top: 30 * getSizeRatioWithLimit(), // 30 is the minimum value without being partially covered
                left: 100.0 * getSizeRatioWithLimit(), //posiX,
                child: Image.asset(
                  "assets/typing/" + fullExpandedComp.imageName,
                  width: 100.0 * getSizeRatioWithLimit(),
                  height: 130.0 * getSizeRatioWithLimit(),
                  //fit: BoxFit.fitWidth,
                ),
              ));
      overlayState.insert(overlayEntry);
      previousOverlayGroup = keyGroup;
      previousOverlayIndex = keyIndex;
    }
    else {
      previousOverlayGroup = 0;
      previousOverlayIndex = 0;
    }
  }

  Widget getOneKeyboardButton(int keyGroup, int keyIndex)
  {
    var imageIndex = PaintSoundManager.getXIndex(keyGroup, keyIndex);

    return FlatButton(
      color: Colors.white,
      textColor: Colors.blueAccent,
      padding: EdgeInsets.zero,
      onPressed: () {
        //initOverlay();

        //showOverlay(context, keyGroup, keyIndex);
        TextToSpeech.speak("zh-CN", PaintSoundManager.getXChar(keyGroup, keyIndex));
      },
      child: Image.asset(
        "assets/paintx/x" + imageIndex.toString() + ".png",
        width: 150.0 * getSizeRatioWithLimit(),
        height: 55.0 * getSizeRatioWithLimit(),
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget getPaintSoundView(BuildContext context) {
    if (currentSoundCategory == SoundCategory.intro) {
      return getPaintIntro(context, currentSoundViewIndex);
    }
    else if (currentSoundViewIndex == 0) {
      return getPaintIndex(context);
    }
    else if (currentSoundCategory == SoundCategory.erGe) {
      return getErGe(context);
    }
    else if (currentSoundCategory == SoundCategory.tongYao) {
      return getTongYao(context);
    }
    else if (currentSoundCategory == SoundCategory.tongHua) {
      return getTongHua(context);
    }
  }

  Widget getPaintIntro(BuildContext context, int soundViewIndex) {
    var fontSize1 = TheConst.fontSizes[1]; //* getSizeRatioWithLimit();
    var fontSize2 = TheConst.fontSizes[2]; //* getSizeRatioWithLimit();

    var fontSize = 18.0 * getSizeRatioWithLimit();
    return Column(
      //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: fontSize2 / 2),
          Text(
              getString(427)/*"点击每个"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize1),
              textAlign: TextAlign.start
          ),
          getOneRow(soundViewIndex, 1),
          getOneRow(soundViewIndex, 3),
          getOneRow(soundViewIndex, 5),
          getOneRow(soundViewIndex, 7),
          getOneRow(soundViewIndex, 9),
          getOneRow(soundViewIndex, 11),
          getOneRow(soundViewIndex, 13),
          getOneRow(soundViewIndex, 15),

          getContinueAndBackButtons(),
        ]
    );
  }

  Widget getOneRow(int groupIndex, int indexInGroup) {
    var fontSize = 18.0 * getSizeRatioWithLimit();

    return Row(
        children: <Widget>[
          Flexible(child: getOneKeyboardButton(groupIndex, indexInGroup)),
          SizedBox(width: fontSize),
          Flexible(child: getOneKeyboardButton(groupIndex, indexInGroup + 1)),
        ]
    );
  }

  Widget getNextButton() {
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: TextStyle(fontSize: 20.0 * getSizeRatioWithLimit()),
      ),
      onPressed: () {
        if (currentSoundViewIndex < 2) { // where 2 is the total
          setState(() {
            currentSoundViewIndex += 1;
          });
        }
        else {
          showCompletedDialog(context);
        }
      },
      child: Text(getString(138),
          style: TextStyle(color: Colors.lightBlue)),
    );
  }

  Widget getPreviousButton() {
    if (currentSoundViewIndex == 1) {
      return SizedBox(height: 0.0, width: 0.0);
    }

    return TextButton(
      style: TextButton.styleFrom(
        textStyle: TextStyle(fontSize: 20.0 * getSizeRatioWithLimit()),
      ),
      onPressed: () {
        if (currentSoundViewIndex > 1) {
          setState(() {
            currentSoundViewIndex -= 1;
          });
        }
        else {
          showCompletedDialog(context);
        }
      },
      child: Text(getString(405),
          style: TextStyle(color: Colors.lightBlue)),
    );
  }

  Widget getContinueAndBackButtons() {
    return Row(
        children: <Widget>[
          getPreviousButton(),
          SizedBox(width: 30 * getSizeRatioWithLimit()),
          getNextButton(),
        ]
    );
  }

  showCompletedDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        theIsBackArrowExit = false;
        Navigator.of(context).pop(); // out this dialog
        Navigator.of(context).pop(); // to the lesson page
      },
    );

    String title;
    String content;

    //if (typingType == TypingType.LeadComponents) {
    title = getString(115)/*"Good job!"*/;
    content = getString(354)/*"You have completed this exercise! Please move on to the next one."*/;
    //}

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

  Widget getPaintIndex(context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount/*itemExtent*/: 25,
        itemBuilder/*IndexedWidgetBuilder*/: (BuildContext context, int index) {
          return getButtonRow(context, index);
        }
    );
  }

  Widget getButtonRow(BuildContext context, int index) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: getRowSections(context, index),
      ),
      padding: EdgeInsets.all(20),
    );
  }

  List<Widget> getRowSections(BuildContext context, int index) {
    List<Widget> sections = [];

    var path;

    if (SoundCategory.erGe == currentSoundCategory) {
      path = "assets/lessons/L1.png";
    }
    if (SoundCategory.tongYao == currentSoundCategory) {
      path = "assets/lessons/L8.png";
    }
    if (SoundCategory.tongHua == currentSoundCategory) {
      path = "assets/lessons/L10.png";
    }

    sections.add(Container(child: getImageButton(context, index * 4 + 1, path, 60, 60)));
    sections.add(Container(child: getImageButton(context, index  * 4 + 2, path, 60, 60)));
    sections.add(Container(child: getImageButton(context, index  * 4 + 3, path, 60, 60)));
    sections.add(Container(child: getImageButton(context, index * 4 + 4, path, 60, 60)));

    return sections;
  }

  Widget getImageButton(BuildContext context, int lessonNumber, String imagePath, double xSize, double ySize) {
    return InkWell(
        child: Column(
            children: [
              Ink.image(
                image: AssetImage(imagePath),
                width: xSize,
                height: ySize,
              ),
              Text(
                lessonNumber.toString(),
                style: TextStyle(fontSize: 14.0, fontFamily: "Raleway"),
              ),
            ]
        ),

        onTap: () {
          setState(() {
            currentSoundViewIndex = lessonNumber;
          });
        }

    );
  }

  Widget getErGe(context) {
    return Image.asset(
      "assets/paintge/erge" + currentSoundViewIndex.toString() + ".png",
      width: 300.0 * getSizeRatioWithLimit(),  // 350
      height: 500.0 * getSizeRatioWithLimit(), // 150
      fit: BoxFit.fitWidth,
    );
  }

  Widget getTongYao(context) {
    return Image.asset(
      "assets/paintyao/tongyao" + currentSoundViewIndex.toString() + ".png",
      width: 300.0 * getSizeRatioWithLimit(),  // 350
      height: 500.0 * getSizeRatioWithLimit(), // 150
      fit: BoxFit.fitWidth,
    );
  }

  Widget getTongHua(context) {
    return Image.asset(
      "assets/painthua/tonghua" + currentSoundViewIndex.toString() + "_1.png",
      width: 300.0 * getSizeRatioWithLimit(),  // 350
      height: 500.0 * getSizeRatioWithLimit(), // 150
      fit: BoxFit.fitWidth,
    );
  }
}
