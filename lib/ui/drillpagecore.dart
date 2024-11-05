
import 'package:flutter/cupertino.dart';
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
import 'package:hanzishu/engine/questionmanager.dart';
import 'package:hanzishu/ui/onerootzipainter.dart';
//import 'package:flutter_tts/flutter_tts.dart';
//import 'package:url_launcher/url_launcher.dart';

class DrillPageCore extends StatefulWidget {
  //final int lessonId;
  final DrillCategory drillCategory; //startLessonId;
  final int startingCenterZiId;
  final int subItemId; //endLessonId;
  final bool isFromReviewPage;
  final String customString;
  Map<int, PositionAndSize> sidePositionsCache = Map();
  Map<int, List<int>>realGroupMembersCache = Map();
  PositionAndSize? centerPositionAndSizeCache;

  DrillPageCore({required this.drillCategory, required this.startingCenterZiId, required this.subItemId, required this.isFromReviewPage, required this.customString});

  @override
  _DrillPageCoreState createState() => _DrillPageCoreState();
}

class _DrillPageCoreState extends State<DrillPageCore> with SingleTickerProviderStateMixin {
  DrillCategory? drillCategory; //startLessonId;
  DrillPainter? drillPainter;
  int startingCenterZiId = -1;
  int subItemId = -1; //endLessonId;
  int internalStartItemId = -1;
  int internalEndItemId = -1;
  String customString = '';
  int centerZiId = -1;
  bool shouldDrawCenter = false;
  double screenWidth = 0.0;
  OverlayEntry? overlayEntry = null;
  int previousZiId = 0;
  bool haveShowedOverlay = true;

  AnimationController? _controller;
  Map<int, bool> allLearnedZis = Map();

  int compoundZiComponentNum = 0;
  List<int> compoundZiAllComponents = [];
  Timer? compoundZiAnimationTimer;

  ZiListType? currentZiListType;

  //List<ReviewLevel> _reviewLevelsEnding = ReviewLevel.getReviewLevelsEnding(0);
  List<DropdownMenuItem<DrillMenu>>? _dropdownDrillMenuItems;
  DrillMenu? _selectedDrillMenu;

  List<DropdownMenuItem<DrillMenu>>? _dropdownSubMenuItems;
  DrillMenu? _selectedSubMenu;

  String currentLocale = '';

  CenterZiRelatedBottum? centerZiRelatedBottum;

  int centerRelatedButtonUpdates = 0;

  QuestionManager questionManager = QuestionManager();

  CenterZiRelatedBottum currentCenterZiRelatedBottum = CenterZiRelatedBottum(
      -1, 'l', 0, 0, -1, 1, 1, 0, -1, false, null);

  getSizeRatio() {
    var defaultFontSize = screenWidth / 16; // note screenWidth is the tree frame width here
    return defaultFontSize / 25.0; // ratio over original hard coded value
  }

  void _startAnimation() {
    _controller!.stop();
    _controller!.reset();
    _controller!.forward(from: 0.0).whenComplete(() {
      setState(() {
        _controller!.stop();
        _controller!.reset();     // when complete, clean the animation drawing.
        shouldDrawCenter = true; // let it redraw the screen with regular center zi.
      });
    });
  }

  void _clearAnimation() {
    _controller!.stop();
    _controller!.reset();
  }

  @override
  void initState() {
    super.initState();
    //theLessonList[theCurrentLessonId].populateDrillMap(1);

    //questionManager.index = 0;

    // should just run once
    // believe initState only runs once, but added a global variable in case LessonPage has run it already.
    if (!theHavePopulatedLessonsInfo) {
      LessonManager.populateLessonsInfo();
      theHavePopulatedLessonsInfo = true;
    }

    drillCategory = widget.drillCategory;
    startingCenterZiId = widget.startingCenterZiId;
    subItemId = widget.subItemId;
    customString = widget.customString;
    theAllZiLearned = false;

    internalStartItemId = subItemId;
    internalEndItemId = subItemId;
    if (drillCategory == DrillCategory.hsk && subItemId == 0) {
      internalStartItemId = 1;
      internalEndItemId = 7; // total 7 levels
    }
    else if(drillCategory == DrillCategory.custom && subItemId == 0) { // real custom
      internalStartItemId = 1; // it use customString in initReadFilterList
      internalEndItemId = 1;
    }
    else if(drillCategory == DrillCategory.custom && subItemId != 0 && customString == null) { // coming from lessons, not regular custom
      // need to set this to lesson specific string
      customString = theLessonManager.getConvChars(subItemId);
    }

    //if (drillCategory == DrillCategory.custom) {
      theDictionaryManager.InitRealFilterList(drillCategory, internalStartItemId, internalEndItemId, customString);
    //}

    //theSearchingZiRealFilterList[0] = null;
    //theSearchingZiRealFilterList[1] = null;
    //theSearchingZiRealFilterList[2] = null;

    _dropdownDrillMenuItems = buildDropdownDrillMenuItems(theDrillMenuList);
    _selectedDrillMenu = _dropdownDrillMenuItems![0].value!;

    _dropdownSubMenuItems = buildDropdownSubMenuItems();
    if (_dropdownSubMenuItems != null && _dropdownSubMenuItems!.length > 0) {
      _selectedSubMenu = _dropdownSubMenuItems![0].value!;
    }

    _controller = new AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );

    theCurrentCenterZiId = startingCenterZiId;
    setState(() {
      centerZiId = theCurrentCenterZiId;
      shouldDrawCenter = true;
      compoundZiComponentNum = 0;
      this.currentLocale = theDefaultLocale;
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
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
      compoundZiAnimationTimer!.cancel();
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
      List<String> componentCodes = <String>[];
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

    var titleText = getString(394)/*"Hanzishu drill"*/;
    if (drillCategory == DrillCategory.hsk) {

    }

    var title;
    if (drillCategory == DrillCategory.hsk) {
      if (subItemId == 0) {
        title = getString(455) + " - " /*+ getString(459) + " - "*/ + getString(456);
      }
      else {
        title = getString(455) + " " + getString(399) + subItemId.toString() + " - " + getString(456);
      }
    }
    else if (drillCategory == DrillCategory.all) {
      title = getString(456); // "Learn Hanzi"
    }
    else {
      title = getString(394)/*"Hanzishu drill"*/;
    }

    //if (questionManager.selectedPosi != -1) {
    //  showOverlayQuestion(context, 30.0, 100.0,
    //      "", 345 /*currentZiId*/);
    //}

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(title),
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
                        internalStartItemId, //widget.startLessonId
                        internalEndItemId, //widget.endLessonId
                        widget.sidePositionsCache,
                        widget.realGroupMembersCache,
                        widget.centerPositionAndSizeCache,
                        allLearnedZis,
                        compoundZiCurrentComponentId,
                        currentZiListType,
                        drillCategory,
                        startingCenterZiId,
                        currentCenterZiRelatedBottum,
                        widget.isFromReviewPage,
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
    List<DropdownMenuItem<DrillMenu>> items = []; //List();
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
    if (_selectedDrillMenu!.id == 1) {
      return <DropdownMenuItem<DrillMenu>>[]; //null;
    }
    else if (_selectedDrillMenu!.id == 2) {
      subMenuList = theHanzishuSubList;
      commonString2 = getString(398);
    }
    else if (_selectedDrillMenu!.id == 3) {
      subMenuList = theHSKSubList;
      commonString2 = getString(399);
    }

    List<DropdownMenuItem<DrillMenu>> items = []; //List();

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
          foregroundPainter: new AnimatedPathPainter(_controller!, strokes!),
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
      overlayEntry!.remove();
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

  showOverlay(BuildContext context, double posiX, double posiY, String pinyinAndMeaning, int searchingZiId) {
    initOverlay();
    var adjustedXValue = Utility.adjustOverlayXPosition(posiX, screenWidth);

    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
        builder: (context) =>Positioned(
            top: posiY,
            left: adjustedXValue,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              child: Text(pinyinAndMeaning, style: TextStyle(fontSize: 20.0 * getSizeRatio(), color: Colors.white),),
              //color: Colors.blueAccent,
              //textColor: Colors.white,
              onPressed: () {
                initOverlay();
                if (searchingZiId != -1) {
                  setState(() {
                    centerZiId = searchingZiId;
                  });
                }
              },
            )
        ));
    overlayState.insert(overlayEntry!);
  }

  Widget getQuestionWizard(BuildContext context) {
    return Container(child: Column(
        children: <Widget>[
          displayOldCenterZi(),
          displaySideZiOrComp(),
          displayZi(),
          getAnswerButton(1),
          SizedBox(height: getSizeRatio() * 5.0),
          getAnswerButton(2),
          SizedBox(height: getSizeRatio() * 5.0),
          getAnswerButton(3),
          SizedBox(height: getSizeRatio() * 15.0),
          getContinueButton(context),
        ]
      ),
      color: Colors.limeAccent, //lime,
      height: getSizeRatio() * 420.0,
      width: getSizeRatio() * 330.0,
    );
  }

  Widget displayOldCenterZi() {
    return Row(
        children: <Widget>[
          Text(
            ' ' + questionManager.getPreviousZi() + ' : ' + questionManager.getPreviousZiMeaning(),
            style: TextStyle(fontSize: getSizeRatio() * 24.0, color: Colors.brown/*, fontFamily: "Raleway"*/),
          ),
        ]
    );
  }

  Widget displaySideZiOrComp() {
    if(questionManager.getCurrentZiId() == questionManager.getSideZiId()) {
      return SizedBox(width: 0.0, height: 0.0);
    }

    return Row(
        children: <Widget>[
          Text(
            ' ',
            style: TextStyle(fontSize: getSizeRatio() * 24.0, color: Colors.brown/*, fontFamily: "Raleway"*/),
          ),
          Container(
            height: getSizeRatio() * 24.0,
            width: getSizeRatio() * 24.0,
            // child: FlatButton(
            child: CustomPaint(
              foregroundPainter: OneRootZiPainter(
                ziId: questionManager.getSideZiId(),
                ziListType: questionManager.getSideZiListType(),
                screenWidth: screenWidth,
                fontSize: getSizeRatio() * 24.0,
                ziColor: Colors.brown,
              ),
            ),
          ),
          Text(
            " : " + questionManager.getSideZiMeaning(),
            style: TextStyle(fontSize: getSizeRatio() * 24.0, color: Colors.brown/*, fontFamily: "Raleway"*/),
          ),
        ]
    );
  }

  Widget displayZi() {
    var char = questionManager.getCurrentZi();
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: TextStyle(fontSize: 24.0 * getSizeRatio()),
      ),
      onPressed: () {
        TextToSpeech.speak("zh-CN", char);
      },
      child: Text(char,
          style: TextStyle(fontSize: 48.0 * getSizeRatio(), color: Colors.greenAccent)),
    );

    //return Text(
    //  questionManager.getCurrentZi(), //lesson.titleTranslation, //"Hello",
    //  style: TextStyle(fontSize: 48.0, color: Colors.greenAccent/*, fontFamily: "Raleway"*/),
    //);
  }

  Widget getAnswerButton(int index) {
    Color color = Colors.blue;

    if (questionManager.selectedPosi > 0 && index == questionManager.getCorrectPosi()) {
      color = Colors.green;
    }
    else if (questionManager.selectedPosi > 0 && index == questionManager.selectedPosi) {
      color = Colors.red;
    }

    //var currentZiId = questionManager.getCurrentZiId();

    return Container(height:45.0 * getSizeRatio(), width: 300.0 * getSizeRatio(),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.black,

          ),
        ),
        child: TextButton(
      style: TextButton.styleFrom(
        textStyle: TextStyle(fontSize: 24.0 * getSizeRatio()),
      ),
      onPressed: () {
        initOverlay();
        setState(() {
          questionManager.selectedPosi = index;
          showOverlayQuestion(context, 30.0 * getSizeRatio(), 80.0 * getSizeRatio(),
              -1, -1, ZiListType.zi, -1);
        });
      },
      child: Text(questionManager.getAnswer(index),
          style: TextStyle(color: color)),
    ));
  }

  Widget getContinueButton(context) {
    if (questionManager.selectedPosi < 1) {
      return SizedBox(width: 0.0, height: 0.0);
    }

    String text = "";
    if (questionManager.selectedPosi > 0 && questionManager.selectedPosi != questionManager.getCorrectPosi() ) {
      text = "Incorrect, continue";
    }
    else if (questionManager.selectedPosi > 0 && questionManager.selectedPosi == questionManager.getCorrectPosi() ) {
      text = "Correct, continue";
    }

    return TextButton(
      //style: TextButton.styleFrom(
      //    textStyle: TextStyle(fontSize: 24.0 * getSizeRatio()),
      //),
      style: TextButton.styleFrom(
        textStyle: TextStyle(fontSize: 24.0 * getSizeRatio()),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.greenAccent,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20.0 * getSizeRatio()),
        ),
      ),
      onPressed: () {
        initOverlay();
        questionManager.selectedPosi = -1; // reinit
        var currentZiId = questionManager.getCurrentZiId();
        if (currentZiId != -1) {
          setState(() {
            centerZiId = currentZiId; //actually the next zi to be at center
          });
        }
      },
      child: Text(text,
        style: TextStyle(color: Colors.greenAccent)),
    );
  }

  showOverlayQuestion(BuildContext context, double posiX, double posiY, int centerZiId, int sideZiId, ZiListType sideZiListType, int searchingZiId) {
    initOverlay();
    var posi = questionManager.getSelectedPosi();
    if (posi < 0) {
      questionManager.setValues(centerZiId, sideZiId, sideZiListType, searchingZiId);
      questionManager.PopulateQuestionInfo();
    }
    var adjustedXValue = 30.0 * getSizeRatio(); //Utility.adjustOverlayXPosition(posiX, screenWidth);

    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
        builder: (context) =>Positioned(
            top: posiY,
            left: adjustedXValue,
            child: getQuestionWizard(context)
        ));
    overlayState.insert(overlayEntry!);
  }

  Positioned getPositionedSkipButton() {
    var yPosi = 0.0;

    var buttonColor = Colors.cyan;
    if (theAllZiLearned) {
      buttonColor = Colors.blue;
    }

    var butt = TextButton(
      //color: buttonColor, //Colors.white,
      //textColor: Colors.brown,
      onPressed: () {
        theIsBackArrowExit = false;
        Navigator.of(context).pop();
      },
      child: Text('', style: TextStyle(fontSize: getSizeRatio() * 20.0, color: Colors.brown)),
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
    //TODO: for new, temp set isQuestion to false, that is, turn off the question feature
    var butt = TextButton(
      //color: Colors.white, // buttonColor,
      //textColor: Colors.blueAccent,
      onPressed: () {
        initOverlay();
        // note: Lessons use Custom as well, so I have to use 1 to skip other non-lesson custom usage.
        // no big difference for lesson 1 itself with this condition, impact only 1 char.
        bool isMiddleZiInLesson = (internalStartItemId == internalEndItemId) && internalStartItemId > 1 && (drillCategory == DrillCategory.custom) && !BasePainter.isCharNewInLesson(newCenterZiId, internalStartItemId);
        var parentZiId = theZiManager.getParentZiId(ZiListType.searching, newCenterZiId);
 //       if (questionManager.isQuestionOn == false || currentZiId == theCurrentCenterZiId || centerZiId == 1 || newCenterZiId < Utility.searchingZiListRealZiStart || parentZiId < Utility.searchingZiListRealZiStart || isMiddleZiInLesson) {
          _clearAnimation();
          resetCompoundZiAnimation();

          bool setParentTo1 = false;
          if (drillCategory == DrillCategory.custom) {
            // during going back toward root. skip the pseudo zi
            if (currentZiId != 1 && (ZiManager.parentIdEqual1(
                DrillCategory.custom, newCenterZiId) ||
                Utility.isSearchingNonZiPseudoZiId(newCenterZiId))) {
              setParentTo1 = true;
            }
          }

          // make sure it doesn't go beyond the startingCenterZiId. do nothing in that case.
          if (!theZiManager.isADistantParentOf(
              ZiListType.searching, startingCenterZiId, newCenterZiId)) {
            setState(() {
              if (setParentTo1) {
                centerZiId = 1;
              }
              else {
                centerZiId = newCenterZiId;
              }
              shouldDrawCenter = true;

              if (centerZiId != 1) {
                var searchingZiId = centerZiId; // drill is for searching zi already
                currentCenterZiRelatedBottum.searchingZiId = searchingZiId;
                CenterZiRelatedBottum.initCenterZiRelatedBottum(
                    searchingZiId, currentCenterZiRelatedBottum);
              }
            });

            var char = theSearchingZiList[currentZiId].char;
            TextToSpeech.speak("zh-CN", char);
          }
 //       }
        /*
        else { //isQuestionOn == true
          //if (currentZiId != theCurrentCenterZiId) {
            var partialZiId = currentZiId;
            ZiListTypeWrapper listTypeWrapper = ZiListTypeWrapper(
                ZiListType.searching);
            // navigation would always show the real char
            if (theCurrentCenterZiId != currentZiId && !isFromNavigation) {
              partialZiId = theZiManager.getPartialZiId(
                  listTypeWrapper, theCurrentCenterZiId, currentZiId);
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
              showOverlayQuestion(context, 30.0, 80.0,
                  centerZiId, partialZiId, listTypeWrapper.value, currentZiId);
              haveShowedOverlay = true;
            }
            else if (haveShowedOverlay) {
              haveShowedOverlay = false;
            }

            previousZiId = currentZiId;
          //}
        }
        */
      },
      onLongPress: () {
        initOverlay();

        if (currentZiId != theCurrentCenterZiId) {
          var partialZiId = currentZiId;
          ZiListTypeWrapper listTypeWrapper = ZiListTypeWrapper(
              ZiListType.searching);
          // navigation would always show the real char
          if (theCurrentCenterZiId != currentZiId && !isFromNavigation) {
            partialZiId = theZiManager.getPartialZiId(
                listTypeWrapper, theCurrentCenterZiId, currentZiId);
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
              pinyinAndMeaning = Zi.formatPinyinAndMeaning(
                  theSearchingZiList[partialZiId].pinyin,
                  theSearchingZiList[partialZiId].meaning);
            }
            else {
              pinyinAndMeaning = Zi.formatPinyinAndMeaning(
                  theComponentList[partialZiId].pinyin,
                  theComponentList[partialZiId].meaning);
            }

            showOverlay(context, posiAndSize.transX, posiAndSize.transY,
                pinyinAndMeaning/* + "\n\n    <Go>"*/, currentZiId);
            haveShowedOverlay = true;
          }
          else if (haveShowedOverlay) {
            haveShowedOverlay = false;
          }

          previousZiId = currentZiId;
        }
      },
      child: Text('', style: TextStyle(fontSize: 20.0, color: Colors.blueAccent),),
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
    var butt = TextButton(
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
        width: posiAndSize.width + 80.0 * getSizeRatio(), //
        child: butt
    );

    return posiCenter;
  }

  Positioned getPositionedMeaningSpeakButton(PositionAndSize posiAndSize, int ziId) {
    var butt = TextButton(
      onPressed: () {
        initOverlay();

        //var zi = theZiManager.getZi(ziId);
        TextToSpeech.speak("en-US", theSearchingZiList[ziId].meaning);
      },
        onLongPress: () {
          initOverlay();
          TextToSpeech.speak("en-US", theSearchingZiList[ziId].meaning);
          showOverlay(context, posiAndSize.transX, posiAndSize.transY /*- scrollOffset*/, theSearchingZiList[ziId].meaning, -1);
        },
      child: Text('', style: TextStyle(fontSize: 20.0),),
    );

    var posiCenter = Positioned(
        top: posiAndSize.transY,
        left: posiAndSize.transX - 10.0,
        height: posiAndSize.height + 10.0,
        width: posiAndSize.width + 10.0,
        child: butt
    );

    return posiCenter;
  }

  Positioned getPositionedDrawBihuaButton(PositionAndSize posiAndSize, int ziId) {
    var butt = TextButton(
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
      /*subMenuUptoId*/subItemId = _selectedSubMenu!.id;
    }

    var realGroupMembers = BasePainter.getRealGroupMembers(centerZiId, ZiListType.searching, drillCategory!, internalStartItemId, internalEndItemId, widget.realGroupMembersCache);
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

      // centerZiRelatedBottom 'buttons'
      createdCenterZiRelatedBottumButtons(buttons);

      if (currentCenterZiRelatedBottum.drawBreakdown) {
        createDrillBreakoutHittestButtons(context, buttons);
      }
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
    if (drillCategory == DrillCategory.custom && (theIsFromLessonContinuedSection || widget.isFromReviewPage)) {
      buttons.add(getPositionedSkipButton());
    }

    return buttons;
  }

  //TODO: not sure to use this or not
  showCompletedDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text(getString(286)/*"OK"*/, style: TextStyle(color: Colors.blue)),
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
        var posi = getPositionedButton(naviMap[id]!, id, id, true);
        buttons.add(posi);
      }
    }
  }

  createdCenterZiRelatedBottumButtons(List<Widget> buttons) {
    var drawCenterZiStructure0 = getCenterZiStructure0Button();
    buttons.add(drawCenterZiStructure0);

    var drawCenterZiStructure1 = getCenterZiStructure1Button();
    buttons.add(drawCenterZiStructure1);

    buttons.add(getCenterZiCompCount0Button());

    buttons.add(getCenterZiCompCount1Button());

    // TODO: turn on after fixing hit button position bug for web version
    //buttons.add(getCenterZiWordBreakdownButton());
  }

  Widget getCenterZiStructure0Button() {
    var butt = TextButton(
      onPressed: () {
        initOverlay();
        currentCenterZiRelatedBottum.structureSelectPosition = 0;

        setState(() {
          centerRelatedButtonUpdates++;
        });
      },
      child: Text('', style: TextStyle(fontSize: 20.0),),
    );

    var posi = thePositionManager.getHintPosi();
    var fontSize = thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize);
    posi.transY += 2.5 * fontSize;

    var posiCenter = Positioned(
        top: posi.transY,
        left: (posi.transX + CenterZiRelatedBottum.position[0] - 10.0) * getSizeRatio(),
        height: fontSize * 1.3,
        width: (CenterZiRelatedBottum.position[1] - CenterZiRelatedBottum.position[0] - 20) * getSizeRatio(),
        child: butt
    );

    return posiCenter;
  }

  Widget getCenterZiStructure1Button() {
    var butt = TextButton(
      onPressed: () {
        initOverlay();
        currentCenterZiRelatedBottum.structureSelectPosition = 1;

        setState(() {
          centerRelatedButtonUpdates++;
        });

      },
      child: Text('', style: TextStyle(fontSize: 20.0),),
    );

    var posi = thePositionManager.getHintPosi();
    var fontSize = thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize);
    posi.transY += 2.5 * fontSize;

    var posiCenter = Positioned(
        top: posi.transY,
        left: (posi.transX + CenterZiRelatedBottum.position[1] - 10.0) * getSizeRatio(),
        height: fontSize * 1.3,
        width: (CenterZiRelatedBottum.position[1] - CenterZiRelatedBottum.position[0] - 20) * getSizeRatio(), // assume similar width
        child: butt
    );

    return posiCenter;
  }

  Widget getCenterZiCompCount0Button() {
    var butt = TextButton(
      onPressed: () {
        initOverlay();
        currentCenterZiRelatedBottum.compCountSelectPosition = 0;

        setState(() {

          centerRelatedButtonUpdates++;
        });
      },
      child: Text('', style: TextStyle(fontSize: 20.0),),
    );

    var posi = thePositionManager.getHintPosi();
    var fontSize = thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize);
    posi.transY += (3.5 * fontSize);

    var posiCenter = Positioned(
        top: posi.transY,
        left: (posi.transX + CenterZiRelatedBottum.position[2] - 10.0) * getSizeRatio(),
        height: fontSize * 1.3,
        width: 40.0 * getSizeRatio(),
        child: butt
    );

    return posiCenter;
  }

  Widget getCenterZiCompCount1Button() {
    var butt = TextButton(
      onPressed: () {
        initOverlay();
        currentCenterZiRelatedBottum.compCountSelectPosition = 1;

        setState(() {
          centerRelatedButtonUpdates++;
        });

      },
      child: Text('', style: TextStyle(fontSize: 20.0),),
    );

    var posi = thePositionManager.getHintPosi();
    var fontSize = thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize);
    posi.transY += (3.5 * fontSize);

    var posiCenter = Positioned(
        top: posi.transY,
        left: (posi.transX + CenterZiRelatedBottum.position[3] - 10.0) * getSizeRatio(),
        height: fontSize * 1.1,
        width: 40.0 * getSizeRatio(),
        child: butt
    );

    return posiCenter;
  }

  Widget getCenterZiWordBreakdownButton() {
    var butt = TextButton(
      onPressed: () {
        initOverlay();

        currentCenterZiRelatedBottum.drawBreakdown = currentCenterZiRelatedBottum.drawBreakdown ? false : true;
        setState(() {
          centerRelatedButtonUpdates++;
        });

      },
      child: Text('', style: TextStyle(fontSize: 20.0),),
    );

    var posi = thePositionManager.getHintPosi();
    var fontSize = thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize);
    posi.transY += (4 * fontSize);

    var posiCenter = Positioned(
        top: posi.transY,
        left: (posi.transX + CenterZiRelatedBottum.position[4]) * getSizeRatio(),
        height: fontSize * 1.3,
        width: 100.0 * getSizeRatio(),
        child: butt
    );

    return posiCenter;
  }

  Positioned getDrillBreakoutPositionedButton(int uniqueNumber, PositionAndSize posiAndSize) {
    var id = Utility.getIdFromUniqueNumber(uniqueNumber);
    var listType = Utility.getListType(uniqueNumber, id);

    var butt = TextButton(
      //color: Colors.white,
      //textColor: Colors.blueAccent,

      onPressed: () {
        initOverlay();
        //var scrollOffset = _scrollController.offset;
        //var zi = theZiManager.getZi(id);
        //var searchingZi = DictionaryManager.getSearchingZi(id);
        var char = ZiManager.getOneChar(id, listType);
        TextToSpeech.speak("zh-CN", char!);
        if (previousZiId != id || !haveShowedOverlay) {
          var pinyinAndMeaning = ZiManager.getOnePinyinAndMeaning(id, listType);
          //var meaning = ZiManager.getPinyinAndMeaning(id);
          showOverlay(context, posiAndSize.transX, posiAndSize.transY /*- scrollOffset*/, pinyinAndMeaning, id);
          haveShowedOverlay = true;
        }
        else if (haveShowedOverlay) {
          haveShowedOverlay = false;
        }

        previousZiId = id;
      },
      child: Text('', style: TextStyle(fontSize: 20.0 *getSizeRatio(), color: Colors.blueAccent),),
    );

    var posiCenter = Positioned(
        top: posiAndSize.transY,
        left: posiAndSize.transX,
        height: posiAndSize.height * 1.3, // not sure why the hittest area is smaller than the char. so use 1.3
        width: posiAndSize.width * 1.3,
        child: butt
    );

    return posiCenter;
  }

  List<Widget> createDrillBreakoutHittestButtons(BuildContext context, List<Widget> buttons) {
    int compoundZiCurrentComponentId = 0;
    int compoundZiTotalComponentNum = 0;
    // compound zi is animating.
    if (compoundZiComponentNum > 0) {
      var compList = getAllZiComponents(centerZiId);
      compoundZiTotalComponentNum = compList.length;

      if (compoundZiComponentNum == compoundZiTotalComponentNum + 1) {
        compoundZiCurrentComponentId = centerZiId;
        resetCompoundZiAnimation();
      }
      else {
        compoundZiCurrentComponentId = compList[compoundZiComponentNum - 1];
      }
    }

    drillPainter = new DrillPainter(
    Colors.amber,
    Colors.blueAccent,
    centerZiId,
    shouldDrawCenter,
    screenWidth,
    subItemId, //widget.startLessonId
    subItemId, //widget.endLessonId
    widget.sidePositionsCache,
    widget.realGroupMembersCache,
    widget.centerPositionAndSizeCache!,
    allLearnedZis,
    compoundZiCurrentComponentId,
    currentZiListType!,
    drillCategory!,
    startingCenterZiId,
        currentCenterZiRelatedBottum,
      widget.isFromReviewPage,
    );

    var breakoutPositions = drillPainter!.getDrillBreakoutPositions();

    var painterHeight = MediaQuery.of(context).size.height + 150.0 * getSizeRatio();  // add some buffer at the end
    buttons.add (Container(height: painterHeight, width: screenWidth));  // workaround to avoid infinite space error

    breakoutPositions.forEach((uniqueNumber, position) =>
        buttons.add(getDrillBreakoutPositionedButton(uniqueNumber, position)));

    return buttons;
  }

  double getDrillHighestBreakoutYPosi( Map<int, PositionAndSize> breakoutPositions) {
    double highestValue = 0;;
    for (var values in breakoutPositions.values) {
      if (values.transY > highestValue) {
        highestValue = values.transY;
      }
    }

    return highestValue;
  }
}
