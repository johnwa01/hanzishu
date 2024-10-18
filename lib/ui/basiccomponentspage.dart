
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/basiccomponentsdetailpage.dart';

class BasicComponentsPage extends StatefulWidget {
  BasicComponentsPage();

  @override
  _BasicComponentsPageState createState() => _BasicComponentsPageState();
}

class _BasicComponentsPageState extends State<BasicComponentsPage> {
  double screenWidth = 0.0;
  //ScrollController _scrollController;
  PrimitiveWrapper contentLength = PrimitiveWrapper(0.0);
  OverlayEntry? overlayEntry = null;
  int previousOverlayGroup = 0;
  int previousOverlayIndex = 0;

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }

  @override
  void initState() {
    super.initState();
    //_scrollController = ScrollController()
    //  ..addListener(() {
        //print("offset = ${_scrollController.offset}");
    //  });
  }

  @override
  void dispose() {
    //_scrollController.dispose(); // it is a good practice to dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    screenWidth = Utility.getScreenWidth(context);
    // init positionmanager frame size
//    thePositionManager.setFrameWidth(screenWidth);

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(getString(384)/*"Hanzi basic components"*/),
      ),
      body: Container(
        //height: 800.00,

        //child: SingleChildScrollView(
        //  controller: _scrollController,
        //  scrollDirection: Axis.vertical,
        //  child: WillPopScope(
              child: getHelpContentView(context),
        //      onWillPop: _onWillPop
        //  ),
        //),
      ),
    );
  }

  initOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
      theDicOverlayEntry = null;
    }
  }

  Future<bool>_onWillPop() {
    initOverlay();

    return Future.value(true);
  }


  Widget getOneKeyboardButton(int keyGroup, int keyIndex)
  {
    var image;
    if (keyGroup == 0 && keyIndex == 0) {
      image = "C00.png"; // the empty image without content, actual LC00.png
    }
    else {
      image = theComponentManager.getComponentByGroupAndIndex(
          keyGroup, keyIndex).image;
    }

    return TextButton(
      //color: Colors.white,
      //textColor: Colors.blueAccent,
      //padding: EdgeInsets.zero,
      onPressed: () {
        if (keyGroup != 0 && keyIndex != 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  BasicComponentsDetailPage(
                      keyGroup: keyGroup, keyIndex: keyIndex),
            ),
          );
        }
      },
      child: Image.asset(
        "assets/components/L" + image,
        width: 30.0 * getSizeRatioWithLimit(),
        height: 55.0 * getSizeRatioWithLimit(),
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget getHelpContentView(BuildContext context) {
    var fontSize1 = TheConst.fontSizes[1]; //* getSizeRatioWithLimit();
    var fontSize2 = TheConst.fontSizes[2]; //* getSizeRatioWithLimit();

    screenWidth = Utility.getScreenWidthForTreeAndDict(context);
    var oneWidth = screenWidth / 10.0;

    var fontSize = 18.0 * getSizeRatioWithLimit();
    return Column(
      //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //SizedBox(height: fontSize2 / 2),
          SizedBox(height: fontSize2 * 2),

          Row(
              children: <Widget>[
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(1, 1), width: oneWidth),
                //SizedBox(width: fontSize),
                SizedBox(child: getOneKeyboardButton(2, 1), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(1, 2), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                //SizedBox(width: fontSize),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(2, 2), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(1, 3), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                //SizedBox(width: fontSize),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(2, 3), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(1, 4), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                //SizedBox(width: fontSize),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(2, 4), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(child: getOneKeyboardButton(1, 5), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                //SizedBox(width: fontSize),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(2, 5), width: oneWidth),
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(child: getOneKeyboardButton(3, 5), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(3, 4), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(3, 3), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(3, 2), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(3, 1), width: oneWidth),
                //SizedBox(width: fontSize),
                SizedBox(child: getOneKeyboardButton(4, 1), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(4, 2), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(4, 3), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(4, 4), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(5, 4), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                //SizedBox(width: fontSize),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(6, 2), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(5, 3), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                //SizedBox(width: fontSize),
                SizedBox(child: getOneKeyboardButton(6, 1), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(5, 2), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(5, 1), width: oneWidth),
                //SizedBox(width: fontSize),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
                SizedBox(child: getOneKeyboardButton(0, 0), width: oneWidth),
              ]
          ),
        ]
    );
  }
}
