
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';


class DictionaryHelpPage extends StatefulWidget {
  DictionaryHelpPage();

  @override
  _DictionaryHelpPageState createState() => _DictionaryHelpPageState();
}

class _DictionaryHelpPageState extends State<DictionaryHelpPage> {
  double screenWidth = 0.0;
  late ScrollController _scrollController;
  late PrimitiveWrapper contentLength = PrimitiveWrapper(0.0);
  OverlayEntry? overlayEntry = null;
  int previousOverlayGroup = 0;
  int previousOverlayIndex = 0;

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }

  @override
  void initState() {
    super.initState();
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
        title: Text(getString(114)/*"Help"*/),
      ),
      body: Container(
        //height: 800.00,

        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: WillPopScope(
              child: getHelpContentView(context),
              onWillPop: _onWillPop
          ),
        ),

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

  showOverlay(BuildContext context, keyGroup, keyIndex) {
    initOverlay();

    if (!(keyGroup == 0 && keyIndex == 0) && !(previousOverlayGroup == keyGroup && previousOverlayIndex == keyIndex)) {
      var fullExpandedComp = theComponentManager
          .getFullExpandedComponentByGroupAndIndex(keyGroup, keyIndex);

      OverlayState overlayState = Overlay.of(context);
      overlayEntry = OverlayEntry(
          builder: (context) =>
              Positioned(
                top: 160.0, //posiY,
                left: 80.0, //posiX,
                child: Image.asset(
                  "assets/typing/" + fullExpandedComp.imageName,
                  width: 250.0,
                  height: 300.0,
                  //fit: BoxFit.fitWidth,
                ),
              ));
      overlayState.insert(overlayEntry!);
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
    var image;
    if (keyGroup == 0 && keyIndex == 0) {
      image = "C00.png"; // the empty image without content
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
        initOverlay();

        showOverlay(context, keyGroup, keyIndex);
      },
      child: Image.asset(
        "assets/typing/" + image,
        width: 30.0,
        height: 30.0,
        fit: BoxFit.fitWidth,
      ),
    );
  }


  Widget getHelpContentView(BuildContext context) {
    final ratio = getSizeRatioWithLimit();
    final maxContentWidth = screenWidth < 960 ? screenWidth * 0.94 : 900.0;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.0 * ratio,
            vertical: 20.0 * ratio,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildHelpSection(
                title: getString(142)/*"About the First Character Dictionary"*/,
                children: [
                  _buildBodyText(getString(143)),
                ],
              ),
              SizedBox(height: 18.0 * ratio),
              _buildHelpSection(
                title: getString(144),
                children: [
                  _buildBodyText(getString(145)),
                  SizedBox(height: 8.0 * ratio),
                  _buildBodyText(getString(146)),
                  _buildIndentedText(getString(149), level: 1, isEmphasis: true),
                  _buildIndentedText(getString(150), level: 2),
                  _buildIndentedText(getString(151), level: 1),
                  _buildIndentedText(getString(152), level: 2),
                  _buildIndentedText(getString(153), level: 2),
                  _buildBodyText(getString(154)),
                  _buildIndentedText(getString(155), level: 1),
                ],
              ),
              SizedBox(height: 18.0 * ratio),
              _buildHelpSection(
                title: getString(360)/*"Stroke categories"*/,
                children: [
                  _buildBodyText("• " + getString(361)),
                  SizedBox(height: 14.0 * ratio),
                  Container(
                    padding: EdgeInsets.all(12.0 * ratio),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.0 * ratio),
                      border: Border.all(
                        color: Colors.blueAccent.withOpacity(0.10),
                        width: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 18.0 * ratio,
                          offset: Offset(0, 8.0 * ratio),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        "assets/typing/Strokes.png",
                        width: 390.0 * ratio,
                        height: 150.0 * ratio,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 26.0 * ratio),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpSection({
    required String title,
    required List<Widget> children,
  }) {
    final ratio = getSizeRatioWithLimit();

    return Container(
      padding: EdgeInsets.all(20.0 * ratio),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.78),
        borderRadius: BorderRadius.circular(22.0 * ratio),
        border: Border.all(
          color: Colors.blueAccent.withOpacity(0.08),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20.0 * ratio,
            offset: Offset(0, 8.0 * ratio),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 20.0 * ratio,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 10.0 * ratio),
          ...children,
        ],
      ),
    );
  }

  Widget _buildBodyText(String text) {
    final ratio = getSizeRatioWithLimit();

    return Text(
      text,
      style: TextStyle(
        fontSize: 16.0 * ratio,
        height: 1.45,
        color: Colors.black87,
      ),
      textAlign: TextAlign.start,
    );
  }

  Widget _buildIndentedText(String text, {int level = 1, bool isEmphasis = false}) {
    final ratio = getSizeRatioWithLimit();

    return Padding(
      padding: EdgeInsets.only(
        left: 20.0 * ratio * level,
        top: 5.0 * ratio,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: (isEmphasis ? 17.0 : 16.0) * ratio,
          height: 1.45,
          fontWeight: isEmphasis ? FontWeight.w600 : FontWeight.normal,
          color: Colors.black87,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

}