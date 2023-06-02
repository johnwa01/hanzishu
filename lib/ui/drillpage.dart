import 'package:flutter/material.dart';
import 'package:hanzishu/data/searchingzilist.dart';
import 'package:hanzishu/data/componentlist.dart';
import 'package:hanzishu/data/drillmenulist.dart';
import 'dart:ui';
import 'dart:async';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/lessonmanager.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';
import 'package:hanzishu/engine/drill.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/drillpainter.dart';
import 'package:hanzishu/engine/zi.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/engine/texttospeech.dart';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/ui/drillpagecore.dart';
import 'package:hanzishu/ui/animatedpathpainter.dart';
import 'package:hanzishu/localization/string_en_US.dart';
import 'package:hanzishu/localization/string_zh_CN.dart';
//import 'package:flutter_tts/flutter_tts.dart';
//import 'package:url_launcher/url_launcher.dart';

class DrillPage extends StatefulWidget {
  //final int lessonId;
  final DrillCategory drillCategory; //startLessonId;
  final int subItemId; //endLessonId;
  final String customString;
  Map<int, PositionAndSize> sidePositionsCache = Map();
  Map<int, List<int>>realGroupMembersCache = Map();
  PositionAndSize centerPositionAndSizeCache;

  DrillPage({this.drillCategory, this.subItemId, this.customString});

  @override
  _DrillPageState createState() => _DrillPageState();
}

class _DrillPageState extends State<DrillPage> with SingleTickerProviderStateMixin {
  DrillCategory drillCategory; //startLessonId;
  int subItemId; //endLessonId;
  String customString;
  int centerZiId;
  bool shouldDrawCenter;
  double screenWidth;
  int previousZiId = 0;
  bool haveShowedOverlay = true;

  AnimationController _controller;
  Map<int, bool> allLearnedZis = Map();

  int compoundZiComponentNum = 0;
  List<int> compoundZiAllComponents = [];
  var compoundZiAnimationTimer;

  ZiListType currentZiListType;

  //List<ReviewLevel> _reviewLevelsEnding = ReviewLevel.getReviewLevelsEnding(0);
  List<DropdownMenuItem<DrillMenu>> _dropdownDrillMenuItems;
  DrillMenu _selectedDrillMenu;

  List<DropdownMenuItem<DrillMenu>> _dropdownSubMenuItems;
  DrillMenu _selectedSubMenu;

  String currentLocale;

  getSizeRatio() {
    var defaultFontSize = screenWidth / 16;
    return defaultFontSize / 25.0; // ratio over original hard coded value
  }

  void _startAnimation() {
    _controller.stop();
    _controller.reset();
    _controller.forward(from: 0.0).whenComplete(() {
      setState(() {
        _controller.stop();
        _controller.reset();     // when complete, clean the animation drawing.
        shouldDrawCenter = true; // let it redraw the screen with regular center zi.
      });
    });
  }

  void _clearAnimation() {
    _controller.stop();
    _controller.reset();
  }

  @override
  void initState() {
    super.initState();
    //theLessonList[theCurrentLessonId].populateDrillMap(1);

    // should just run once
    // believe initState only runs once, but added a global variable in case LessonPage has run it already.
    if (!theHavePopulatedLessonsInfo) {
      LessonManager.populateLessonsInfo();
      theHavePopulatedLessonsInfo = true;
    }

    drillCategory = widget.drillCategory;
    subItemId = widget.subItemId;
    customString = widget.customString;
    theAllZiLearned = false;

    if (drillCategory == DrillCategory.custom) {
      DictionaryManager.InitRealFilterList(DrillCategory.custom, customString);
    }

    //theSearchingZiRealFilterList[0] = null;
    //theSearchingZiRealFilterList[1] = null;
    //theSearchingZiRealFilterList[2] = null;

    _dropdownDrillMenuItems = buildDropdownDrillMenuItems(theDrillMenuList);
    _selectedDrillMenu = _dropdownDrillMenuItems[0].value;

    _dropdownSubMenuItems = buildDropdownSubMenuItems();
    if (_dropdownSubMenuItems != null && _dropdownSubMenuItems.length > 0) {
      _selectedSubMenu = _dropdownSubMenuItems[0].value;
    }

    _controller = new AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );

    theCurrentCenterZiId = 1;
    setState(() {
      centerZiId = theCurrentCenterZiId;
      shouldDrawCenter = true;
      compoundZiComponentNum = 0;
      this.currentLocale = theDefaultLocale;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int compoundZiCurrentComponentId = 0;
    int compoundZiTotalComponentNum = 0;

    // compound zi is animating.
    if (compoundZiComponentNum > 0) {
      List<String> componentCodes = List<String>();
      if (compoundZiAllComponents == null ||
          compoundZiAllComponents.length == 0) {
        DictionaryManager.getAllComponents(centerZiId, componentCodes);
        DictionaryManager.getComponentIdsFromCodes(
            componentCodes, compoundZiAllComponents);
      }
      //var compList = getAllZiComponents(searchingZiIndex);
      compoundZiTotalComponentNum = compoundZiAllComponents.length;

      if (compoundZiComponentNum == compoundZiTotalComponentNum + 1) {
        // after looping through the compoundZiAllComponents.
        compoundZiCurrentComponentId = centerZiId;
        currentZiListType = ZiListType.searching;
        shouldDrawCenter = true;
      }
      else {
        compoundZiCurrentComponentId =
        compoundZiAllComponents[compoundZiComponentNum - 1];
        currentZiListType = ZiListType.component;
      }
    }

    //screenWidth = Utility.getScreenWidth(context);
    screenWidth = Utility.getScreenWidthForTreeAndDict(context);
    thePositionManager.setFrameTopEdgeSizeWithRatio(getSizeRatio());

    //var subMenuUptoId = 0;
    if (drillCategory != DrillCategory.custom && _selectedSubMenu != null) {
      /*subMenuUptoId*/subItemId = _selectedSubMenu.id;
    }

    if (drillCategory != DrillCategory.custom) {
      drillCategory = getCategoryFromSelectedDrillMenu(_selectedDrillMenu.id);
    }

    var imageName = "assets/core/chardrill_eng.png";
    if (theDefaultLocale == "zh_CN") {
      imageName = "assets/core/chardrill_cn.png";
    }

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(getString(394)/*"Hanzishu drill"*/),
      ),
      body: Container(
        child: WillPopScope(   // just for removing overlay on detecting back arrow
          //height: 200.0,
          //width: 200.0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end/*spaceBetween*/,
                  children: <Widget>[
                    getLanguageSwitchButtonAsNeeded(drillCategory, centerZiId),
                  ]
                ),
                SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center, //spaceBetween,
                    children: <Widget>[
                      SizedBox(width: 10),
                      getCategories(context, centerZiId, drillCategory),
                      //SizedBox(width: 10),
                      //Text("Test"),
                      SizedBox(width: 10),
                      //Text("Results"),
                      getSubMenus(context, centerZiId),
                      SizedBox(width: 10),
                      //SizedBox(width: 10),
                    ],
                  ),
                SizedBox(height: 10),
                /*
                FlatButton(
                    color: Colors.blueAccent, //white,
                    textColor: Colors.white, //brown,
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => DrillPageCore(drillCategory: DrillCategory.all, subItemId: 0, customString: null)));
                    },
                    child: Text(getString(301), style: TextStyle(fontSize: 16.0/*applyRatio(20.0)*/)),
                ),
                */
                InkWell(
                    child: //Column(
                    //children: [
                    Ink.image(
                      image: AssetImage(imageName),
                      width: 170, //130
                      height: 110, //80
                    ),
                    onTap: () => {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => DrillPageCore(drillCategory: drillCategory, subItemId: subItemId, customString: null))),
                    }
                ),
                SizedBox(height: 30),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center/*spaceBetween*/,
                    children: <Widget>[
                      //SizedBox(width: 40),
                      SizedBox(width: 300, child: Text(getString(417)/*"For dictionary, typing method, lessons and more, choose the options in the bottom."*/, /*English/中文*/
                          style: TextStyle(color: Colors.blue))),
                      //SizedBox(width: 40),
                    ]
                ),
              ],
            ),
            onWillPop: _onWillPop
        ),
      ),
    );
  }

  DrillCategory getCategoryFromSelectedDrillMenu(int selectedDrillMenuId) {
    var category;

    switch (selectedDrillMenuId) {
      case 1:
        category = DrillCategory.all;
        break;
      case 2:
        category = DrillCategory.hanzishu;
        break;
      case 3:
        category = DrillCategory.hsk;
        break;
      default:
        category = DrillCategory.all;
        break;
    }

    return category;
  }

  Widget getLanguageSwitchButtonAsNeeded(DrillCategory drillCategory, int centerId) {
    //if (drillCategory != DrillCategory.all || centerId != 1) {
    //  return SizedBox(width: 0, height: 0);
    //}

    return TextButton(
      style: TextButton.styleFrom(
        textStyle: TextStyle(fontSize: 16.0),
      ),
      onPressed: () {
        setState(() {
          currentLocale = changeTheDefaultLocale();
          _dropdownDrillMenuItems = buildDropdownDrillMenuItems(theDrillMenuList);
          _dropdownSubMenuItems = buildDropdownSubMenuItems();
          //currentIndex = 1;
          //currentIndex = theInputZiManager.getNextIndex(typingType, /*currentIndex,*/ lessonId);;
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
    final BottomNavigationBar navigationBar = globalKeyNav.currentWidget;
    navigationBar.onTap(0);

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

  Widget getCategories(BuildContext context, int centerZiId, DrillCategory drillCategory) {
    if (centerZiId == 1 && drillCategory != DrillCategory.custom) {
      return DropdownButton(
        value: _selectedDrillMenu,
        items: _dropdownDrillMenuItems,
        onChanged: onChangeDropdownDrillItem,
      );
    }
    else {
      return SizedBox(width: 0, height: 0);
    }
  }

  Widget getSubMenus(BuildContext context, int centerZiId) {
    if (centerZiId == 1 && _selectedDrillMenu.id != 1) {
      return DropdownButton(
        value: _selectedSubMenu,
        items: _dropdownSubMenuItems,
        onChanged: onChangeDropdownSubItem,
      );
    }
    else {
      return SizedBox(width: 0, height: 0);
    }
  }

  List<DropdownMenuItem<DrillMenu>> buildDropdownDrillMenuItems(List drillMenuList) {
    List<DropdownMenuItem<DrillMenu>> items = List();
    for (DrillMenu drillMenu in drillMenuList) {
      items.add(
        DropdownMenuItem(
          value: drillMenu,
          child: Text(getString(drillMenu.stringId)),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<DrillMenu>> buildDropdownSubMenuItems() {
    var subMenuList;
    var commonString1 = getString(397);
    var commonString2 = "";
    if (_selectedDrillMenu.id == 1) {
      return null;
    }
    else if (_selectedDrillMenu.id == 2) {
      subMenuList = theHanzishuSubList;
      commonString2 = getString(398);
    }
    else if (_selectedDrillMenu.id == 3) {
      subMenuList = theHSKSubList;
      commonString2 = getString(399);
    }

    List<DropdownMenuItem<DrillMenu>> items = List();

    for (var subMenu in subMenuList) {
      var subString;
      if (subMenu.stringId != 0) {
        subString = getString(subMenu.stringId);
      }
      else {
        subString = subMenu.id.toString();
      }

      items.add(
        DropdownMenuItem(
          value: subMenu,
          child: Text(commonString1 + commonString2 + subString),
        ),
      );
    }
    return items;
  }

  onChangeDropdownDrillItem(DrillMenu selectedDrillMenu) {
    setState(() {
      _dropdownDrillMenuItems = buildDropdownDrillMenuItems(theDrillMenuList);
      _selectedDrillMenu = selectedDrillMenu;
      drillCategory = getCategoryFromSelectedDrillMenu(_selectedDrillMenu.id);
      _dropdownSubMenuItems = buildDropdownSubMenuItems();

      if (_selectedDrillMenu.id != 1 && theSearchingZiRealFilterList[_selectedDrillMenu.id-1] == null) {

        DictionaryManager.InitRealFilterList(drillCategory, null);
      }

      if (_dropdownSubMenuItems != null && _dropdownSubMenuItems.length > 0) {
        _selectedSubMenu = _dropdownSubMenuItems[0].value;
        subItemId = _selectedSubMenu.id;
      }
    });
  }

  onChangeDropdownSubItem(DrillMenu selectedSubMenu) {
    setState(() {
      _selectedSubMenu = selectedSubMenu;
      subItemId = _selectedSubMenu.id;
    });
  }

  Future<bool>_onWillPop() {
    return Future.value(true);
  }
}
