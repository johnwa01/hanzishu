import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/ui/practicesheetpainter.dart';

class PracticeSheetCorePage extends StatefulWidget {
  late String flashcardList;
  late bool gridShowZi;
  PracticeSheetCorePage({required this.flashcardList, required this.gridShowZi});

  @override
  _PracticeSheetCorePageState createState() => _PracticeSheetCorePageState();
}

class _PracticeSheetCorePageState extends State<PracticeSheetCorePage> with SingleTickerProviderStateMixin {
  late double screenWidth;
  late String flashcardList;
  late bool gridShowZi;

  double getSizeRatio() {
    var defaultFontSize = screenWidth / 16;
    return defaultFontSize / 25.0; // ratio over original hard coded value
  }

  double applyRatio(double value) {
    return value * getSizeRatio();
  }

  @override
  void initState() {
    super.initState();

    flashcardList = widget.flashcardList;
    gridShowZi = widget.gridShowZi;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidthForTreeAndDict(context);
    //var realBrowserSize = Utility.getScreenWidth(context);
    //bool isPhoneBrowser = (realBrowserSize < 850.0) ? true : false;

    var title = getString(449); /*Hanzi practice sheet*/

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(title),  //Hanzi practice sheet
      ),
      body: Container(
          child: WillPopScope(
              child: new Stack(
                  children: <Widget>[
                    new Positioned(
                      child: CustomPaint(
                        foregroundPainter: PracticeSheetPainter(flashcardList, screenWidth, gridShowZi
                        ),
                      ),
                    ),
                  ]
              ),
              onWillPop: _onWillPop
          )
      ),
    );
  }

  Future<bool>_onWillPop() {
    return Future.value(true);
  }
}