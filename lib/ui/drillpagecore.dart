
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
import 'package:hanzishu/ui/animatedpathpainter.dart';
import 'package:hanzishu/localization/string_en_US.dart';
import 'package:hanzishu/localization/string_zh_CN.dart';
//import 'package:flutter_tts/flutter_tts.dart';
//import 'package:url_launcher/url_launcher.dart';

class DrillPageCore extends StatefulWidget {
  //final int lessonId;
  final DrillCategory drillCategory; //startLessonId;
  final int subItemId; //endLessonId;
  final String customString;
  Map<int, PositionAndSize> sidePositionsCache = Map();
  Map<int, List<int>>realGroupMembersCache = Map();
  PositionAndSize centerPositionAndSizeCache;

  DrillPageCore({this.drillCategory, this.subItemId, this.customString});

  @override
  _DrillPageCoreState createState() => _DrillPageCoreState();
}

class _DrillPageCoreState extends State<DrillPageCore> with SingleTickerProviderStateMixin {
  DrillCategory drillCategory; //startLessonId;
  int subItemId; //endLessonId;
  String customString;
  int centerZiId;
  bool shouldDrawCenter;
  double screenWidth;
  OverlayEntry overlayEntry;
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

    resetCompoundZiAnimation();
  }

  void resetCompoundZiAnimation() {
    // re-init
    compoundZiComponentNum = 0;
    if (compoundZiAllComponents.length > 0) {
      compoundZiAllComponents.clear(); //removeRange(0, compList.length - 1);
    }

    if (compoundZiAnimationTimer != null) {
      compoundZiAnimationTimer.cancel();
      compoundZiAnimationTimer = null;
    }
  }

  List<int> getAllZiComponents(int id) {
    if (compoundZiAllComponents.length == 0) {
      theZiManager.getAllZiComponents(ZiListType.searching, id, compoundZiAllComponents);
    }

    return compoundZiAllComponents;
  }

  @override
  Widget build(BuildContext context) {
    int compoundZiCurrentComponentId = -1;
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
        resetCompoundZiAnimation();
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

    if (compoundZiComponentNum > 0 &&
        compoundZiComponentNum <= compoundZiTotalComponentNum) {
      compoundZiAnimation();
    }

    //var subMenuUptoId = 0;
    //if (drillCategory != DrillCategory.custom && _selectedSubMenu != null) {
    //  /*subMenuUptoId*/subItemId = _selectedSubMenu.id;
    //}

    //if (drillCategory != DrillCategory.custom) {
    //  drillCategory = getCategoryFromSelectedDrillMenu(_selectedDrillMenu.id);
    //}

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
            child: new Stack(
              children: <Widget>[
                new Positioned(
                  child: CustomPaint(
                    foregroundPainter: DrillPainter(
                        Colors.amber,
                        Colors.blueAccent,
                        centerZiId,
                        shouldDrawCenter,
                        screenWidth,
                        0, //widget.startLessonId, //TODO: remove this
                        subItemId, //subMenuUptoId, //widget.endLessonId, TODO: remove endLessonId
                        widget.sidePositionsCache,
                        widget.realGroupMembersCache,
                        widget.centerPositionAndSizeCache,
                        allLearnedZis,
                        compoundZiCurrentComponentId,
                        currentZiListType,
                        drillCategory//  _selectedDrillMenu.id
                    ),
                    child: Center(
                      child: Stack(
                          children: createHittestButtons(context)
                      ),
                    ),
                  ),
                ),
                getAnimatedPathPainter(),
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

  Widget getAnimatedPathPainter() {
    //if (!theZiManager.isHechenZi(centerZiId)) {
    if (theSearchingZiList[centerZiId].composit.length == 1) {
      var posi = thePositionManager.getCenterZiPosi();
      var strokes = DictionaryManager.getSingleComponentSearchingZiStrokes(centerZiId);
      return new Positioned(
        top: posi.transY,
        left: posi.transX,
        height: posi.height,
        width: posi.width,
        child: new CustomPaint(
          foregroundPainter: new AnimatedPathPainter(_controller, strokes),
        ),
      );
    }
    else {
      // no need to create above.
      return Container(width: 0.0, height: 0.0);
    }
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

  //NOTE: setState within the Timer so that it'll trigger this function to be called repeatedly.
  // Not really an animation, just set a timer to display a component in the center, after time, display next component in the center, etc.
  void  compoundZiAnimation() {
    const oneSec = const Duration(seconds: 1);
    compoundZiAnimationTimer = new Timer(oneSec, () {     //timeout(oneSec, (Timer t) {   //periodic
      setState(() {
        compoundZiComponentNum += 1;
      });
    });
  }

  showOverlay(BuildContext context, double posiX, double posiY, String pinyinAndMeaning) {
    initOverlay();
    var adjustedXValue = Utility.adjustOverlayXPosition(posiX, screenWidth);

    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
        builder: (context) =>Positioned(
            top: posiY,
            left: adjustedXValue,
            child: FlatButton(
              child: Text(pinyinAndMeaning, style: TextStyle(fontSize: 20.0),),
              color: Colors.blueAccent,
              textColor: Colors.white,
              onPressed: () {},
            )
        ));
    overlayState.insert(overlayEntry);
  }

  Positioned getPositionedContinueButton() {
    var yPosi = 0.0;

    var buttonColor = Colors.white;
    if (theAllZiLearned) {
      buttonColor = Colors.blue;
    }

    var butt = FlatButton(
      color: buttonColor, //Colors.white,
      textColor: Colors.brown,
      onPressed: () {
        theIsBackArrowExit = false;
        Navigator.of(context).pop();
      },
      child: Text('', style: TextStyle(fontSize: getSizeRatio() * 20.0)),
    );

    // NOTE: match the basepainting's drawZiGroup
    var posiCenter = Positioned(
        top: yPosi, //yPosi.transY +
        //2 * thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize),
        left: screenWidth - 80.0, //getSizeRatio() * 0.0,  // Need to match DrillPainter/BasePainter
        height: /*getSizeRatio() */ 50.0,
        //posiAndSize.height,
        width: /*getSizeRatio() */ 80.0, // 100.0
        //posiAndSize.width,
        child: butt
    );

    return posiCenter;
  }

  Positioned getPositionedButton(PositionAndSize posiAndSize, int currentZiId, int newCenterZiId, bool isFromNavigation) {
    var butt = FlatButton(
      color: Colors.white, // buttonColor,
      textColor: Colors.blueAccent,
      onPressed: () {
        initOverlay();

        _clearAnimation();
        resetCompoundZiAnimation();

        setState(() {
          centerZiId = newCenterZiId;
          shouldDrawCenter = true;
        });

        var char = theSearchingZiList[currentZiId].char;
        TextToSpeech.speak("zh-CN", char);
      },
      onLongPress: () {
        initOverlay();

        var partialZiId = currentZiId;
        ZiListTypeWrapper listTypeWrapper = ZiListTypeWrapper(ZiListType.searching);
        // navigation would always show the real char
        if (theCurrentCenterZiId != currentZiId && !isFromNavigation) {
          partialZiId = theZiManager.getPartialZiId(listTypeWrapper, theCurrentCenterZiId, currentZiId);
        }

        var sideZiOrComp;
        if (listTypeWrapper.value == ZiListType.component) {
          sideZiOrComp = theComponentList[partialZiId].charOrNameOfNonchar;
        }
        else {
          sideZiOrComp = theSearchingZiList[partialZiId].char;
        }

        //var zi = theZiManager.getZi(partialZiId);
        TextToSpeech.speak("zh-CN", sideZiOrComp);

        if (previousZiId != currentZiId || !haveShowedOverlay) {
          //var meaning = ZiManager.getPinyinAndMeaning(partialZiId);
          var pinyinAndMeaning;
          if (listTypeWrapper.value == ZiListType.searching) {
            pinyinAndMeaning = Zi.formatPinyinAndMeaning(theSearchingZiList[partialZiId].pinyin, theSearchingZiList[partialZiId].meaning);
          }
          else {
            pinyinAndMeaning = Zi.formatPinyinAndMeaning(theComponentList[partialZiId].pinyin, theComponentList[partialZiId].meaning);
          }

          showOverlay(context, posiAndSize.transX, posiAndSize.transY, pinyinAndMeaning);
          haveShowedOverlay = true;
        }
        else if (haveShowedOverlay) {
          haveShowedOverlay = false;
        }

        previousZiId = currentZiId;
      },
      child: Text('', style: TextStyle(fontSize: 20.0),),
    );

    var posiCenter = Positioned(
        top: posiAndSize.transY,
        left: posiAndSize.transX,
        height: posiAndSize.height,
        width: posiAndSize.width,
        child: butt
    );

    return posiCenter;
  }

  Positioned getPositionedSpeechButton(PositionAndSize posiAndSize, int ziId) {
    var butt = FlatButton(
      onPressed: () {
        initOverlay();

        //var zi = theZiManager.getZi(ziId);
        TextToSpeech.speak("zh-CN", theSearchingZiList[ziId].char);
      },
      child: Text('', style: TextStyle(fontSize: 20.0),),
    );

    var posiCenter = Positioned(
        top: posiAndSize.transY,
        left: posiAndSize.transX,
        height: posiAndSize.height,
        width: posiAndSize.width,
        child: butt
    );

    return posiCenter;
  }

  Positioned getPositionedMeaningSpeakButton(PositionAndSize posiAndSize, int ziId) {
    var butt = FlatButton(
      onPressed: () {
        initOverlay();

        //var zi = theZiManager.getZi(ziId);
        TextToSpeech.speak("en-US", theSearchingZiList[ziId].meaning);
      },
      child: Text('', style: TextStyle(fontSize: 20.0),),
    );

    var posiCenter = Positioned(
        top: posiAndSize.transY,
        left: posiAndSize.transX,
        height: posiAndSize.height,
        width: posiAndSize.width,
        child: butt
    );

    return posiCenter;
  }

  Positioned getPositionedDrawBihuaButton(PositionAndSize posiAndSize, int ziId) {
    var butt = FlatButton(
      onPressed: () {
        initOverlay();

        resetCompoundZiAnimation();

        setState(() {
          shouldDrawCenter = false;
        });

        if (theSearchingZiList[ziId].composit.length <= 1) {
          _startAnimation();
        }
        else {
          compoundZiAnimation();
        }

        //var zi = theZiManager.getZi(ziId);
        TextToSpeech.speak("zh-CN", theSearchingZiList[ziId].char);
      },
      child: Text('', style: TextStyle(fontSize: 20.0),),
    );

    var posiCenter = Positioned(
        top: posiAndSize.transY,
        left: posiAndSize.transX,
        height: posiAndSize.height,
        width: posiAndSize.width,
        child: butt
    );

    return posiCenter;
  }

  List<Widget> createHittestButtons(BuildContext context) {
    List<Widget> buttons = [];
    //TextToSpeech.speak('你好');

    thePositionManager.resetPositionIndex();

    //var subMenuUptoId = 0;
    if (drillCategory != DrillCategory.custom && _selectedSubMenu != null) {
      /*subMenuUptoId*/subItemId = _selectedSubMenu.id;
    }

    var realGroupMembers = BasePainter.getRealGroupMembers(centerZiId, ZiListType.searching, drillCategory, 0/*widget.startLessonId*/, subItemId/*subMenuUptoId*/, widget.realGroupMembersCache);
    var totalSideNumberOfZis = theZiManager.getNumberOfZis(ZiListType.searching, realGroupMembers);
    for (var i = 0; i < realGroupMembers.length; i++) {
      var memberZiId = realGroupMembers[i];
      //var memberPinyinAndMeaning = ZiManager.getPinyinAndMeaning(memberZiId);
      var positionAndSize;
      //if (centerZiId == 1) {
      //var rootZiDisplayIndex = thePositionManager.getRootZiDisplayIndex(memberZiId);
      //positionAndSize = thePositionManager.getDrillRootPositionAndSize(rootZiDisplayIndex);
      //}
      //else {
      positionAndSize = BasePainter.getPositionAndSize(
          ZiListType.searching, memberZiId, totalSideNumberOfZis, widget.sidePositionsCache);
      //}

      var posi = getPositionedButton(positionAndSize, memberZiId, memberZiId, false);

      thePositionManager.updatePositionIndex(ZiListType.searching, memberZiId);
      buttons.add(posi);
    }

    if (centerZiId != 1 ) {
      //var pinyinAndMeaning = ZiManager.getPinyinAndMeaning(centerZiId);
      var newCenterZiId = theZiManager.getParentZiId(ZiListType.searching, centerZiId);
      //var posiAndSize = theLessonManager.getCenterPositionAndSize();
      var posiAndSize = thePositionManager.getPositionAndSizeHelper("m", 1, PositionManager.theBigMaximumNumber);
      var posiCenter = getPositionedButton(posiAndSize, centerZiId, newCenterZiId, false);

      buttons.add(posiCenter);
    }

    // draw speech icon
    var posiAndSizeSpeech = thePositionManager.getCenterSpeechPosi();
    var speechPosiCenter = getPositionedSpeechButton(posiAndSizeSpeech, centerZiId);
    buttons.add(speechPosiCenter);

    // draw meaning 'button'
    var posiAndSizeMeaningSpeak = thePositionManager.getMeaningTextSpeechPosi();
    var meaningTextSpeechButton = getPositionedMeaningSpeakButton(posiAndSizeMeaningSpeak, centerZiId);
    buttons.add(meaningTextSpeechButton);

    // draw bihua icon
    var posiAndSizeBihua = thePositionManager.getCenterBihuaPosi();
    var drawBihuaPosiCenter = getPositionedDrawBihuaButton(posiAndSizeBihua, centerZiId);
    buttons.add(drawBihuaPosiCenter);

    CreateNavigationHitttestButtons(centerZiId, true, buttons);

    // skip and next section button
    if (drillCategory == DrillCategory.custom) {
      buttons.add(getPositionedContinueButton());
    }

    return buttons;
  }

  //TODO: not sure to use this or not
  showCompletedDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(getString(286)/*"OK"*/),
      onPressed: () {
      },
    );

    String title = getString(115)/*"Good job!"*/;
    String content = getString(407)/*"You have go through all the flashcards!"*/;

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

  CreateNavigationHitttestButtons(int centerZiId, bool isFromDrillPageCore, List<Widget> buttons) {
    if (centerZiId != 1) {
      var naviMap = PositionManager.getNavigationPathPosi(
          ZiListType.searching, centerZiId, isFromDrillPageCore, getSizeRatio());

      for (var id in naviMap.keys) {
        var posi = getPositionedButton(naviMap[id], id, id, true);
        buttons.add(posi);
      }
    }
  }
}
