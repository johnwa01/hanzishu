
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

// Note: this file is no longer used
class IntroductionPage extends StatefulWidget {
  IntroductionPage();

  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  double fontSize1 = 0.0;
  double fontSize2 = 0.0;
  double fontSize3 = 0.0;

  late double screenWidth;
  late ScrollController _scrollController;
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

    fontSize1 = TheConst.fontSizes[1] * 1.3; //* getSizeRatioWithLimit();
    fontSize2 = TheConst.fontSizes[2] * 1.3; //* getSizeRatioWithLimit();
    fontSize2 = TheConst.fontSizes[2] * 1.3; //* getSizeRatioWithLimit();

    // init positionmanager frame size
    thePositionManager.setFrameWidth(screenWidth);

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(getString(411)/*"Glossary"*/),
      ),
      body: Container(
        //height: 800.00,

        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: WillPopScope(
              child: getIntroductionContentView(context),
              onWillPop: _onWillPop
          ),
        ),

      ),
    );
  }

  Future<bool>_onWillPop() {
    return Future.value(true);
  }

  Widget getIntroductionContentView(BuildContext context) {
    return Column(
      //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          //Text(
          //    getString(411)/*"Hanzishu Introduction"*/,
          //    style: TextStyle(color: Colors.blue, fontSize: fontSize1/*, fontWeight: FontWeight.bold*/),
          //    textAlign: TextAlign.start
          //),
          SizedBox(height: fontSize1),
          Text(
              getString(412)/*"detailed introduction stuff"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize1),
          getHanzishuHistoryLink(),
          getMakaylaHanzishuDiaryLink(),
          //getPinyinNotGoodForTeachingLink(),
          getNewStageOfLearningChineseLink(),
          getInputMethodAndTeachingLink(),
        ]
    );
  }

  Widget getHanzishuHistoryLink() {
    if (kIsWeb)
      return TextButton(
        //color: Colors.blueAccent, //white,
        //textColor: Colors.brown, //blue,
        onPressed: () {
          launchUrl(Uri.parse("https://mp.weixin.qq.com/s/veT0HxXO3R_YTHvOUAnPLQ"), webOnlyWindowName: '_self');
        },
        child: Text(getString(421)/*"Hanzishu's past and present"*/, style: TextStyle(fontSize: 16.0/*applyRatio(20.0)*/, color: Colors.brown)),
      );

    return SizedBox(width: 0, height: 0);
  }

  Widget getMakaylaHanzishuDiaryLink() {
    if (kIsWeb)
      return TextButton(
        //color: Colors.blueAccent, //white,
        //textColor: Colors.brown, //brown,
        onPressed: () {
          launchUrl(Uri.parse("https://hanzishu.com/lesson/makaylahanzishudiary.htm"), webOnlyWindowName: '_self');
        },
        child: Text(getString(435)/*"Makayla Hanzishu Diary"*/, style: TextStyle(fontSize: 16.0/*applyRatio(20.0)*/, color: Colors.brown)),
      );

    return SizedBox(width: 0, height: 0);
  }

  /*
  Widget getPinyinNotGoodForTeachingLink() {
    if (kIsWeb)
      return FlatButton(
        color: Colors.blueAccent, //white,
        textColor: Colors.brown, //brown,
        onPressed: () {
          launchUrl(Uri.parse("https://mp.weixin.qq.com/s/m7QIBYtX3NC8Bhq4gFemMg"), webOnlyWindowName: '_self');
        },
        child: Text(getString(437)/*"Pinyin does no good to international Chinese teaching"*/, style: TextStyle(fontSize: 16.0/*applyRatio(20.0)*/)),
      );

    return SizedBox(width: 0, height: 0);
  }
  */

  Widget getNewStageOfLearningChineseLink() {
    if (kIsWeb)
      return TextButton(
        //color: Colors.blueAccent, //white,
        //textColor: Colors.brown, //brown,
        onPressed: () {
          launchUrl(Uri.parse("https://mp.weixin.qq.com/s/bAWvFFo0WlAuz62UTjkltQ"), webOnlyWindowName: '_self');
        },
        child: Text(getString(471)/*"New scientific stage of Chinese character education"*/, style: TextStyle(fontSize: 16.0/*applyRatio(20.0)*/, color: Colors.brown)),
      );

    return SizedBox(width: 0, height: 0);
  }

  Widget getInputMethodAndTeachingLink() {
    if (kIsWeb)
      return TextButton(
        //color: Colors.blueAccent, //white,
        //textColor: Colors.brown, //brown,
        onPressed: () {
          launchUrl(Uri.parse("https://hanzishu.com/publish/inputmethodandteaching.htm"), webOnlyWindowName: '_self');
        },
        child: Text(getString(436)/*"Input method and teaching"*/, style: TextStyle(fontSize: 16.0/*applyRatio(20.0)*/, color: Colors.brown)),
      );

    return SizedBox(width: 0, height: 0);
  }
}