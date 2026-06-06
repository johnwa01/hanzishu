
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
import 'package:hanzishu/ui/inputgamepage.dart';

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
      //appBar: AppBar
      //  (
      //  title: Text(getString(10)/*"Glossary"*/),
      //),
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
        textStyle: TextStyle(fontSize: 24.0),
      ),
      onPressed: () {
        setState(() {
          currentLocale = changeTheDefaultLocale();
          //_dropdownCourseMenuItems = buildDropdownCourseMenuItems(courseMenuList);
        });
      },
      child: Text(getOppositeDefaultLocale(), /*English/中文*/
          style: TextStyle(color: Colors.blue, fontSize: 24.0)),
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

          SizedBox(height: 8),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20 * getSizeRatioWithLimit(),
            ),
            child: Column(
              children: [

                Row(
                  children: [

                    Image.asset(
                      'assets/core/logo.jpg',
                      width: 58.0 * getSizeRatioWithLimit(),
                      height: 58.0 * getSizeRatioWithLimit(),
                      fit: BoxFit.fitWidth,
                    ),

                    SizedBox(width: 12 * getSizeRatioWithLimit()),

                    Text(
                      "Hanzishu",
                      style: TextStyle(
                        fontSize: 28 * getSizeRatioWithLimit(),
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),

                    Spacer(),

                    getLanguageSwitchButton(),
                  ],
                ),

                SizedBox(height: 6),

                Text(
                  "Learn Chinese Through Character Structure & Typing",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16 * getSizeRatioWithLimit(),
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          //Text(
          //    getString(412)/*"detailed Launch stuff"*/,
          //    style: TextStyle(color: Colors.blue, fontSize: fontSize2),
          //    textAlign: TextAlign.start
          //),
          //SizedBox(height: fontSize1),
          //getRefreshNotice(), // TODO: can remove this after adding real inputgame link
          //SizedBox(height: fontSize1),
          //getRealInputGameLink(),
          //SizedBox(height: fontSize1),
          //getWarmupInputGameLink(),
          //SizedBox(height: fontSize1),
          //getWarmupResults(), //TODO: move it into under the game section
          //SizedBox(height: fontSize1),
          //getInputGameRegistration(),
          //getFinalGameInfo(),
          //SizedBox(height: fontSize1),
          //getFormalGameResults(),
          //SizedBox(height: fontSize1),
          //getHanzishuInputGameLink(),
          SizedBox(height: 10 * getSizeRatioWithLimit()),
          getHomeFeatureGrid(context),
          SizedBox(height: 16 * getSizeRatioWithLimit()),


          Container(
            margin: EdgeInsets.symmetric(horizontal: 20 * getSizeRatioWithLimit()),
            padding: EdgeInsets.all(20 * getSizeRatioWithLimit()),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Discover Hanzishu",
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 24 * getSizeRatioWithLimit(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        launchUrl(Uri.parse("https://hanzishu.com/publish"),
                            webOnlyWindowName: '_self');
                      },
                      child: Text(
                        "View All →",
                        style: TextStyle(
                          fontSize: 14 * getSizeRatioWithLimit(),
                          color: Colors.brown,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  "Articles, videos, classroom stories and research.",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14 * getSizeRatioWithLimit(),
                  ),
                ),
                SizedBox(height: 14 * getSizeRatioWithLimit()),
                SizedBox(
                  height: 205 * getSizeRatioWithLimit(),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      getDiscoverCard(
                        "华州高中课堂",
                        "“汉字树”走进美国高中中文课堂",
                        "https://hanzishu.com/publish/skyline.html",
                        Icons.school,
                      ),

                      SizedBox(width: 14 * getSizeRatioWithLimit()),

                      getDiscoverCard(
                        "塔尔萨大学首秀",
                        "象形电打法在美国大学课堂的体验",
                        "https://hanzishu.com/publish/tul.html",
                        Icons.play_circle_fill,
                      ),

                      SizedBox(width: 14 * getSizeRatioWithLimit()),

                      getDiscoverCard(
                        "在教室里种汉字树",
                        "一线中文课堂中的实践故事",
                        "https://hanzishu.com/publish/westside.html",
                        Icons.menu_book,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          //getSkylineReportLink(),
          //getGaochengsixiaoReportLink(),
          //getTulReportLink(),
          //getWestsideReportLink(),
          //getPublishReportLink(),
          //getHanzishuHistoryLink(),
          //getMakaylaHanzishuDiaryLink(),
          //getPinyinNotGoodForTeachingLink(),
          //getNewStageOfLearningChineseLink(),
          //getInputMethodAndTeachingLink(),
        ]
    );
  }

  Widget getHomeFeatureGrid(BuildContext context) {
    double ratio = getSizeRatioWithLimit();
    double horizontalPadding = 20 * ratio;
    double gap = 14 * ratio;
    double availableWidth = screenWidth - horizontalPadding * 2;
    bool useTwoColumns = availableWidth >= 720;
    double cardWidth = useTwoColumns
        ? (availableWidth - gap) / 2
        : availableWidth;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: gap,
        runSpacing: gap,
        children: [
          getHomeFeatureCard(
            title: getString(91),
            subtitle: "Learn step by step with structured lessons.",
            icon: Icons.menu_book_rounded,
            color: Colors.green,
            width: cardWidth,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LessonsPage()),
              );
            },
          ),
          getHomeFeatureCard(
            title: getString(93),
            subtitle: "Type Chinese easily and intuitively with Hanzishu.",
            icon: Icons.keyboard_rounded,
            color: Colors.blue,
            width: cardWidth,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ToolsPage()),
              );
            },
          ),
          getHomeFeatureCard(
            title: getString(92),
            subtitle: "Search Chinese characters and words easily.",
            icon: Icons.menu_book_outlined,
            color: Colors.deepPurple,
            width: cardWidth,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InputZiPage(
                    typingType: TypingType.DicSearchTyping,
                    lessonId: 0,
                    wordsStudy: '',
                    isSoundPrompt: false,
                    inputMethod: InputMethod.Both,
                    showHint: HintType.Hint1,
                    includeSkipSection: false,
                    showSwitchMethod: false,
                  ),
                ),
              );
            },
          ),
          getHomeFeatureCard(
            title: getString(1),
            subtitle: "Learn and have fun with interactive puzzles.",
            icon: Icons.extension_rounded,
            color: Colors.orange,
            width: cardWidth,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WordPage()),
              );
            },
          ),
          getHomeFeatureCard(
            title: getString(94),
            subtitle: "Explore useful tools, resources, settings, and more.",
            icon: Icons.apps_rounded,
            color: Colors.teal,
            width: cardWidth,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MePage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget getHomeFeatureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required double width,
    required VoidCallback onTap,
  }) {
    double ratio = getSizeRatioWithLimit();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18 * ratio),
        child: Container(
          width: width,
          height: 118 * ratio,
          padding: EdgeInsets.all(18 * ratio),
          decoration: BoxDecoration(
            color: color.withOpacity(0.06),
            borderRadius: BorderRadius.circular(18 * ratio),
            border: Border.all(color: color.withOpacity(0.10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 18 * ratio,
                offset: Offset(0, 8 * ratio),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 66 * ratio,
                height: 66 * ratio,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(14 * ratio),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.30),
                      blurRadius: 12 * ratio,
                      offset: Offset(0, 6 * ratio),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 36 * ratio,
                ),
              ),
              SizedBox(width: 18 * ratio),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: color,
                        fontSize: 21 * ratio,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8 * ratio),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.blueGrey[700],
                        fontSize: 13.5 * ratio,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10 * ratio),
              Container(
                width: 34 * ratio,
                height: 34 * ratio,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 20 * ratio,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getDiscoverCard(
      String title,
      String subtitle,
      String url,
      IconData iconData,
      ) {
    return InkWell(
      onTap: () {
        launchUrl(Uri.parse(url), webOnlyWindowName: '_self');
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 210 * getSizeRatioWithLimit(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 70 * getSizeRatioWithLimit(),
              decoration: BoxDecoration(
                color: Colors.brown.shade100,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      iconData,
                      size: 38 * getSizeRatioWithLimit(),
                      color: Colors.brown,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Article",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10 * getSizeRatioWithLimit(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12 * getSizeRatioWithLimit()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15 * getSizeRatioWithLimit(),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12 * getSizeRatioWithLimit(),
                      color: Colors.grey[700],
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Read More →",
                    style: TextStyle(
                      color: Colors.brown,
                      fontSize: 11 * getSizeRatioWithLimit(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
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

  Widget getFinalGameInfo() {
    if (kIsWeb) {
      return Center(child: TextButton(
        //color: Colors.blueAccent, //white,
        //textColor: Colors.brown, //brown,
        onPressed: () {
          launchUrl(Uri.parse("https://hanzishu.com/typing/2026/finalgameinfo.html"),
              webOnlyWindowName: '_self');
        },
        style: TextButton.styleFrom(
          side: BorderSide(
            color: Colors.blue, // The border color
            width: 2,          // The border width
          ),
          // You can also add rounded corners
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(getString(563), style: TextStyle(
            fontSize: 16 * getSizeRatioWithLimit(), color: Colors.brown)),
      ),
      );
    }
    else {
      return SizedBox(width: 0.0, height: 0.0);
    }

    //return SizedBox(width: 0, height: 0);
  }

  Widget getFormalGameResults() {
    if (kIsWeb) {
      return Center(child: TextButton(
        //color: Colors.blueAccent, //white,
        //textColor: Colors.brown, //brown,
        onPressed: () {
          launchUrl(Uri.parse("https://www.52hrtt.com/mobileview/news/fifm2026042622034213408793.html"),
              webOnlyWindowName: '_self');
        },
        style: TextButton.styleFrom(
          side: BorderSide(
            color: Colors.blue, // The border color
            width: 2,          // The border width
          ),
          // You can also add rounded corners
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(getString(564), style: TextStyle(
            fontSize: 16 * getSizeRatioWithLimit(), color: Colors.brown)),
      ),
      );
    }
    else {
      return SizedBox(width: 0.0, height: 0.0);
    }

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

  Widget getRealInputGameLink() {
    if (kIsWeb) {
      return Center(child: TextButton(
        //color: Colors.blueAccent, //white,
        //textColor: Colors.brown, //brown,

        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InputGamePage(gameid: "5", gameid2: "6"),
            ),
          );
        },
        style: TextButton.styleFrom(
          side: BorderSide(
            color: Colors.blue, // The border color
            width: 2,          // The border width
          ),
          // You can also add rounded corners
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(getString(562), style: TextStyle(
            fontSize: 20 * getSizeRatioWithLimit(), color: Colors.blue)),
      ),
      );
    }
    else {
      return SizedBox(width: 0.0, height: 0.0);
    }
  }

  Widget getWarmupInputGameLink() {
    if (kIsWeb) {
      return Center(child: TextButton(
        //color: Colors.blueAccent, //white,
        //textColor: Colors.brown, //brown,

        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InputGamePage(gameid: "1", gameid2: "2"),
            ),
          );
        },
        style: TextButton.styleFrom(
          side: BorderSide(
            color: Colors.blue, // The border color
            width: 2,          // The border width
          ),
          // You can also add rounded corners
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(getString(536), style: TextStyle(
            fontSize: 16 * getSizeRatioWithLimit(), color: Colors.brown)),
      ),
      );
    }
    else {
      return SizedBox(width: 0.0, height: 0.0);
    }
  }

  Widget getRefreshNotice() {
    if (kIsWeb) {
      return Center(child:  Text(getString(559), style: TextStyle(
            fontSize: 16 * getSizeRatioWithLimit(), color: Colors.brown)),
      );
    }
    else {
      return SizedBox(width: 0.0, height: 0.0);
    }
  }

  Widget getWarmupResults() {
    if (kIsWeb) {
      return Center(child: TextButton(
        //color: Colors.blueAccent, //white,
        //textColor: Colors.brown, //brown,
        onPressed: () {
          launchUrl(Uri.parse("https://hanzishu.com/typing/2026/warmupresults.html"),
              webOnlyWindowName: '_self');
        },
        child: Text(getString(537), style: TextStyle(
            fontSize: 16 * getSizeRatioWithLimit(), color: Colors.brown)),
      ),
      );
    }
    else {
      return SizedBox(width: 0.0, height: 0.0);
    }
  }

  Widget getInputGameRegistration() {
    if (kIsWeb) {
      return Center(child: TextButton(
        //color: Colors.blueAccent, //white,
        //textColor: Colors.brown, //brown,
        onPressed: () {
          launchUrl(Uri.parse("https://forms.microsoft.com/r/03LeSte8HU?origin=lprLink"),
              webOnlyWindowName: '_self');
        },
        style: TextButton.styleFrom(
          side: BorderSide(
            color: Colors.blue, // The border color
            width: 2,          // The border width
          ),
          // You can also add rounded corners
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(getString(538), style: TextStyle(
            fontSize: 16 * getSizeRatioWithLimit(), color: Colors.brown)),
      ),
      );
    }
    else {
      return SizedBox(width: 0.0, height: 0.0);
    }
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
        style: TextButton.styleFrom(
          side: BorderSide(
            color: Colors.blue, // The border color
            width: 2,          // The border width
          ),
          // You can also add rounded corners
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(getString(533), style: TextStyle(
            fontSize: 16 * getSizeRatioWithLimit(), color: Colors.brown)),
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
        child: Text("View All Articles & Videos →", style: TextStyle(fontSize: 16.0/*applyRatio(20.0)*/, color: Colors.brown)),
      );

    //return SizedBox(width: 0, height: 0);
  }
}