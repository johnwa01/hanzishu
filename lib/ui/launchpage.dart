
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:hanzishu/engine/fileio.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/localization/string_en_US.dart';
import 'package:hanzishu/localization/string_zh_CN.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/ui/lessonspage.dart';
import 'package:hanzishu/ui/inputzipage.dart';
import 'package:hanzishu/ui/wordpage.dart';
import 'package:hanzishu/ui/toolspage.dart';
import 'package:hanzishu/ui/mepage.dart';
import 'package:hanzishu/utility.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

// Note: this file is no longer used
class LaunchPage extends StatefulWidget {
  LaunchPage();

  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  double fontSize1 = 0.0;
  double fontSize2 = 0.0;
  double fontSize3 = 0.0;

  late bool hasLoadedStorage;
  late String currentLocale;

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

    setState(() {
      this.hasLoadedStorage = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // it is a good practice to dispose the controller
    super.dispose();
  }

  Future<bool>_onWillPop() {
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    handleStorage();

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
        title: Text(getString(10)/*"Glossary"*/),
      ),
      body: Container(
        //height: 800.00,

        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: WillPopScope(
              child: getLaunchContentView(context),
              onWillPop: _onWillPop
          ),
        ),

      ),
    );
  }

  handleStorage() {
    // doing nothing for web for now
    if (!kIsWeb) {
      if (!theStorageHandler.getHasTriedToLoadStorage()) {
        var fileIO = CounterStorage();
        theFileIOFile = fileIO;
        theStorageHandler.setHasTriedToLoadStorage();
        fileIO.readString().then((String value) {
          // just once, doesn't matter whether it loads any data or not
          if (value != null) {
            var storage = theStorageHandler.getStorageFromJson(value);
            if (storage != null) {
              updateDefaultLocale(storage.language);
              theStorageHandler.setStorage(storage);
              setState(() {
                this.hasLoadedStorage = true;
              });
            }
          }
        });
      }
    }
  }

  void updateDefaultLocale(String localeFromPhysicalStorage) {
    if (localeFromPhysicalStorage != null && (localeFromPhysicalStorage == 'en_US' || localeFromPhysicalStorage == 'zh_CN')) {
      if (theDefaultLocale != localeFromPhysicalStorage) {
        theDefaultLocale = localeFromPhysicalStorage;

        // let main page refresh to pick up the language change for navigation bar items
        final BottomNavigationBar navigationBar = globalKeyNav.currentWidget as BottomNavigationBar;
        navigationBar.onTap!(0);
      }
    }
  }

  Widget getLanguageSwitchButton() {
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: TextStyle(fontSize: 16.0),
      ),
      onPressed: () {
        setState(() {
          currentLocale = changeTheDefaultLocale();
          //_dropdownCourseMenuItems = buildDropdownCourseMenuItems(courseMenuList);
        });
      },
      child: Text(getOppositeDefaultLocale(), /*English/中文*/
          style: TextStyle(color: Colors.blue)),
    );
  }

  String changeTheDefaultLocale() {
    if (theDefaultLocale == "en_US") {
      theDefaultLocale = "zh_CN";
    }
    else if (theDefaultLocale == "zh_CN") {
      theDefaultLocale = "en_US";
    }

    theStorageHandler.setLanguage(theDefaultLocale);
    theStorageHandler.SaveToFile();

    // let main page refresh to pick up the language change for navigation bar items
    final BottomNavigationBar navigationBar = globalKeyNav.currentWidget as BottomNavigationBar;
    navigationBar.onTap!(0);

    return theDefaultLocale;
  }

  String getOppositeDefaultLocale() {
    int idForLanguageTypeString = 378; /*English/中文*/
    // according to theDefaultLocale
    String localString = "";

    switch (theDefaultLocale) {
      case "en_US":
        {
          localString = theString_zh_CN[idForLanguageTypeString].str; // theString_en_US[id].str;
        }
        break;
      case "zh_CN":
        {
          localString = theString_en_US[idForLanguageTypeString].str; // theString_zh_CN[id].str;
        }
        break;
      default:
        {
        }
        break;
    }

    return localString;
  }

  Widget getLaunchContentView(BuildContext context) {
    return Column(
      //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          //Text(
          //    getString(411)/*"Hanzishu Launch"*/,
          //    style: TextStyle(color: Colors.blue, fontSize: fontSize1/*, fontWeight: FontWeight.bold*/),
          //    textAlign: TextAlign.start
          //),
          SizedBox(height: fontSize1),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Image.asset('assets/core/logo.jpg',
              width: 40.0 * getSizeRatioWithLimit(),
              height: 40.0 * getSizeRatioWithLimit(),
              fit: BoxFit.fitWidth,),
              getLanguageSwitchButton(),
            ]
          ),
          //Text(
          //    getString(412)/*"detailed Launch stuff"*/,
          //    style: TextStyle(color: Colors.blue, fontSize: fontSize2),
          //    textAlign: TextAlign.start
          //),
          SizedBox(height: fontSize1),
          getHanzishuInputGameLink(),
          SizedBox(height: fontSize1 * 2),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 30 * getSizeRatioWithLimit()),
                getInputMethodButton(),
                SizedBox(width: 30 * getSizeRatioWithLimit()),
                getLessonsButton(),
                SizedBox(width: 30 * getSizeRatioWithLimit()),
              ]
          ),
          SizedBox(height: 15 * getSizeRatioWithLimit()),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 30 * getSizeRatioWithLimit()),
                getDictionaryButton(),
                SizedBox(width: 30 * getSizeRatioWithLimit()),
                getPuzzleButton(),
                SizedBox(width: 30 * getSizeRatioWithLimit()),
              ]
          ),
          SizedBox(height: 15 * getSizeRatioWithLimit()),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 30 * getSizeRatioWithLimit()),
                getMoreButton(),
              ]
          ),
          SizedBox(height: 15 * getSizeRatioWithLimit()),
          Text(
            "热点: (Hot topics, Chinese only)",
            style: TextStyle(
              color: Colors.brown,
              //fontSize: 24 * getSizeRatioWithLimit(),
              fontWeight: FontWeight.bold,
            ),
          ),

          getSkylineReportLink(),
          getGaochengsixiaoReportLink(),
          getTulReportLink(),
          getWestsideReportLink(),
          getPublishReportLink(),
          //getHanzishuHistoryLink(),
          //getMakaylaHanzishuDiaryLink(),
          //getPinyinNotGoodForTeachingLink(),
          //getNewStageOfLearningChineseLink(),
          //getInputMethodAndTeachingLink(),
        ]
    );
  }

  Widget getLessonsButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LessonsPage()
          ),
        );
      },
      child: Container(
        width: 150 * getSizeRatioWithLimit(), // Example width
        height: 80 * getSizeRatioWithLimit(), // Example height
        decoration: BoxDecoration(
          color: Colors.blue, // Example background color
          borderRadius: BorderRadius.circular(10), // Example rounded corners
        ),
        child: Center(
          child: Text(
            getString(91), //'Lessons'
            style: TextStyle(
              color: Colors.white,
              fontSize: 24 * getSizeRatioWithLimit(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget getDictionaryButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => InputZiPage(typingType: TypingType.DicSearchTyping, lessonId: 0, wordsStudy: '', isSoundPrompt: false, inputMethod: InputMethod.Both, showHint: HintType.Hint1, includeSkipSection: false, showSwitchMethod: false)
          ),
        );
      },
      child: Container(
        width: 150 * getSizeRatioWithLimit(), // Example width
        height: 80 * getSizeRatioWithLimit(), // Example height
        decoration: BoxDecoration(
          color: Colors.blue, // Example background color
          borderRadius: BorderRadius.circular(10), // Example rounded corners
        ),
        child: Center(
          child: Text(
            getString(92), //'Dictionary'
            style: TextStyle(
              color: Colors.white,
              fontSize: 24 * getSizeRatioWithLimit(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget getPuzzleButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WordPage()
          ),
        );
      },
      child: Container(
        width: 150 * getSizeRatioWithLimit(), // Example width
        height: 80 * getSizeRatioWithLimit(), // Example height
        decoration: BoxDecoration(
          color: Colors.blue, // Example background color
          borderRadius: BorderRadius.circular(10), // Example rounded corners
        ),
        child: Center(
          child: Text(
            getString(1), ///'Drills'
            style: TextStyle(
              color: Colors.white,
              fontSize: 24 * getSizeRatioWithLimit(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget getInputMethodButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ToolsPage()
          ),
        );
      },
      child: Container(
        width: 150 * getSizeRatioWithLimit(), // Example width
        height: 80 * getSizeRatioWithLimit(), // Example height
        decoration: BoxDecoration(
          color: Colors.blue, // Example background color
          borderRadius: BorderRadius.circular(10), // Example rounded corners
        ),
        child: Center(
          child: Text(
            getString(93), // 'Typing'
            style: TextStyle(
              color: Colors.white,
              fontSize: 24 * getSizeRatioWithLimit(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget getMoreButton() {
    return InkWell(
      onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MePage()
            ),
          );
      },
      child: Container(
        width: 150 * getSizeRatioWithLimit(), // Example width
        height: 80 * getSizeRatioWithLimit(), // Example height
        decoration: BoxDecoration(
          color: Colors.blue, // Example background color
          borderRadius: BorderRadius.circular(10), // Example rounded corners
        ),
        child: Center(
          child: Text(
            getString(94), //'Me'
            style: TextStyle(
              color: Colors.white,
              fontSize: 24 * getSizeRatioWithLimit(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget getHanzishuHistoryLink() {
    //if (kIsWeb)
      return TextButton(
        //color: Colors.blueAccent, //white,
        //textColor: Colors.brown, //blue,
        onPressed: () {
          launchUrl(Uri.parse("https://mp.weixin.qq.com/s/veT0HxXO3R_YTHvOUAnPLQ"), webOnlyWindowName: '_self');
        },
        child: Text(getString(421)/*"Hanzishu's past and present"*/, style: TextStyle(fontSize: 16.0/*applyRatio(20.0)*/, color: Colors.brown)),
      );

    //return SizedBox(width: 0, height: 0);
  }

  Widget getNewStageOfLearningChineseLink() {
    //if (kIsWeb)
      return TextButton(
        //color: Colors.blueAccent, //white,
        //textColor: Colors.brown, //brown,
        onPressed: () {
          launchUrl(Uri.parse("https://mp.weixin.qq.com/s/bAWvFFo0WlAuz62UTjkltQ"), webOnlyWindowName: '_self');
        },
        child: Text(getString(471)/*"New scientific stage of Chinese character education"*/, style: TextStyle(fontSize: 16.0/*applyRatio(20.0)*/, color: Colors.brown)),
      );

    //return SizedBox(width: 0, height: 0);
  }

  Widget getInputMethodAndTeachingLink() {
    //if (kIsWeb)
      return TextButton(
        //color: Colors.blueAccent, //white,
        //textColor: Colors.brown, //brown,
        onPressed: () {
          launchUrl(Uri.parse("https://hanzishu.com/publish/inputmethodandteaching.htm"), webOnlyWindowName: '_self');
        },
        child: Text(getString(436)/*"Input method and teaching"*/, style: TextStyle(fontSize: 16.0/*applyRatio(20.0)*/, color: Colors.brown)),
      );

    //return SizedBox(width: 0, height: 0);
  }

  Widget getSkylineReportLink() {
    //if (kIsWeb)
    return TextButton(
      //color: Colors.blueAccent, //white,
      //textColor: Colors.brown, //brown,
      onPressed: () {
        launchUrl(Uri.parse("https://hanzishu.com/publish/skyline.html"), webOnlyWindowName: '_self');
      },
      child: Text("用科技重构识字之路——“汉字树”走进华州高中课堂(作者：江凌欧)", style: TextStyle(fontSize: 16.0/*applyRatio(20.0)*/, color: Colors.brown)),
    );

    //return SizedBox(width: 0, height: 0);
  }

  Widget getGaochengsixiaoReportLink() {
    //if (kIsWeb)
    return TextButton(
      onPressed: () {
        launchUrl(Uri.parse("https://hanzishu.com/publish/gaochengsixiao.html"), webOnlyWindowName: '_self');
      },
      child: Text("山东省成武县郜城四小第一次象形电打课程总结(作者：朱君)", style: TextStyle(fontSize: 16.0/*applyRatio(20.0)*/, color: Colors.brown)),
    );

    //return SizedBox(width: 0, height: 0);
  }

  Widget getHanzishuInputGameLink() {
    if (kIsWeb) {
      return Center(child: TextButton(
        //color: Colors.blueAccent, //white,
        //textColor: Colors.brown, //brown,
        onPressed: () {
          launchUrl(Uri.parse("https://hanzishu.com/typing/2026"),
              webOnlyWindowName: '_self');
        },
        child: Text(getString(533), style: TextStyle(
            fontSize: 16 * getSizeRatioWithLimit(), color: Colors.redAccent)),
      ),
      );
    }
    else {
      return SizedBox(width: 0.0, height: 0.0);
    }

    //return SizedBox(width: 0, height: 0);
  }

  Widget getTulReportLink() {
    //if (kIsWeb)
      return TextButton(
        //color: Colors.blueAccent, //white,
        //textColor: Colors.brown, //brown,
        onPressed: () {
          launchUrl(Uri.parse("https://hanzishu.com/publish/tul.html"), webOnlyWindowName: '_self');
        },
        child: Text("汉字树象形电打法美国塔尔萨大学首秀告捷（作者：张新颖）", style: TextStyle(fontSize: 16.0/*applyRatio(20.0)*/, color: Colors.brown)),
      );

    //return SizedBox(width: 0, height: 0);
  }

  Widget getWestsideReportLink() {
    //if (kIsWeb)
      return TextButton(
        //color: Colors.blueAccent, //white,
        //textColor: Colors.brown, //brown,
        onPressed: () {
          launchUrl(Uri.parse("https://hanzishu.com/publish/westside.html"), webOnlyWindowName: '_self');
        },
        child: Text("在教室里种汉字树（作者：洪璐斯）", style: TextStyle(fontSize: 16.0/*applyRatio(20.0)*/, color: Colors.brown)),
      );

    //return SizedBox(width: 0, height: 0);
  }

  Widget getPublishReportLink() {
    //if (kIsWeb)
      return TextButton(
        //color: Colors.blueAccent, //white,
        //textColor: Colors.brown, //brown,
        onPressed: () {
          launchUrl(Uri.parse("https://hanzishu.com/publish"), webOnlyWindowName: '_self');
        },
        child: Text("更多汉字树相关文章和视频", style: TextStyle(fontSize: 16.0/*applyRatio(20.0)*/, color: Colors.brown)),
      );

    //return SizedBox(width: 0, height: 0);
  }
}