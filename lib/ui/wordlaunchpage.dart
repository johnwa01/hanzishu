
import 'package:flutter/material.dart';
import 'package:hanzishu/data/searchingzilist.dart';
import 'package:hanzishu/data/componentlist.dart';
import 'package:hanzishu/data/drillmenulist.dart';
import 'dart:ui';
import 'dart:async';
import 'package:hanzishu/engine/quizmanager.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/lessonmanager.dart';
import 'package:hanzishu/engine/dictionary.dart';
import 'package:hanzishu/engine/drill.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/dictionarysearchingpage.dart';
import 'package:hanzishu/engine/zi.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/ui/standardexampage.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/ui/studynewwordspage.dart';
import 'package:hanzishu/ui/quizpage.dart';
import 'package:hanzishu/ui/drillpagecore.dart';
import 'package:hanzishu/ui/inputzipage.dart';
import 'package:hanzishu/localization/string_en_US.dart';
import 'package:hanzishu/localization/string_zh_CN.dart';
//import 'package:flutter_tts/flutter_tts.dart';
import 'package:hanzishu/ui/privacypolicy.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'package:hanzishu/engine/drill.dart';
import 'package:hanzishu/engine/studywords.dart';
import 'package:hanzishu/engine/thirdpartylesson.dart';

class WordLaunchPage extends StatefulWidget {
  //final int lessonId;
  final DrillCategory drillCategory; //startLessonId;
  final int subItemId; //endLessonId;
  final String customString;
  final ThirdPartyType thirdPartyType;
  Map<int, PositionAndSize> sidePositionsCache = Map();
  Map<int, List<int>>realGroupMembersCache = Map();
  PositionAndSize? centerPositionAndSizeCache;

  WordLaunchPage({required this.drillCategory, required this.subItemId, required this.customString, required this.thirdPartyType});

  @override
  _WordLaunchPageState createState() => _WordLaunchPageState();
}

class _WordLaunchPageState extends State<WordLaunchPage> with SingleTickerProviderStateMixin {
  late DrillCategory drillCategory; //startLessonId;
  int subItemId = -1; //endLessonId;
  String customString = '';
  int centerZiId = -1;
  bool? shouldDrawCenter;
  double? screenWidth;
  int previousZiId = 0;
  bool haveShowedOverlay = true;

  Map<int, bool> allLearnedZis = Map();

  int compoundZiComponentNum = 0;
  List<int> compoundZiAllComponents = [];
  Timer? compoundZiAnimationTimer;

  ZiListType? currentZiListType;

  getSizeRatio() {
    var defaultFontSize = screenWidth! / 16;
    return defaultFontSize / 25.0; // ratio over original hard coded value
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

    //if (drillCategory == DrillCategory.custom) {
    //  theDictionaryManager.InitRealFilterList(DrillCategory.custom, subItemId, subItemId, customString);
    //}

    theCurrentCenterZiId = 1;
    setState(() {
      centerZiId = theCurrentCenterZiId;
      shouldDrawCenter = true;
      compoundZiComponentNum = 0;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidth(context);
    thePositionManager.setFrameTopEdgeSizeWithRatio(getSizeRatio());

    var title;
    if (drillCategory == DrillCategory.hsk) {
      if (subItemId == 0) {
        title = getString(455) + " - " + getString(459);
      }
      else {
        if (subItemId == 7) {
          title = getString(455) + " " + getString(399) + " 7/8/9";
        }
        else {
          title = getString(455) + " " + getString(399) + subItemId.toString();
        }
      }
    }
    else if (drillCategory == DrillCategory.all) {
      title = getString(395); // 'all 3,800'
    }
    else if (drillCategory == DrillCategory.custom) {
      title = getString(500);
    }

    return Scaffold(
      backgroundColor: Color(0xFFFDF7FF),
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFFDF7FF),
        elevation: 0,
        foregroundColor: Color(0xFF111827),
      ),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 640;

              return SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 900),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 18, 20, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildPrimaryActionCard(),
                          SizedBox(height: 18),
                          _buildPracticeGrid(isNarrow),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  bool _isThirdPartyTextbook() {
    return widget.thirdPartyType == ThirdPartyType.sunlaoshi ||
        widget.thirdPartyType == ThirdPartyType.yuwenAll ||
        widget.thirdPartyType == ThirdPartyType.cMadeEasy;
  }

  Widget _buildPrimaryActionCard() {
    if (_isThirdPartyTextbook()) {
      return _buildActionCard(
        icon: Icons.keyboard_rounded,
        title: 'Typing Practice',
        subtitle: 'Read and type Hanzi from this lesson.',
        isPrimary: true,
        onTap: () {
          _prepareThirdPartyLessonIfNeeded();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InputZiPage(
                typingType: TypingType.ThirdParty,
                lessonId: 0,
                wordsStudy: customString,
                isSoundPrompt: false,
                inputMethod: InputMethod.Pinxin,
                showHint: HintType.Hint1,
                includeSkipSection: false,
                showSwitchMethod: false,
              ),
            ),
          );
        },
      );
    }

    bool isFromReviewPage = true;
    if (drillCategory == DrillCategory.custom) {
      isFromReviewPage = false;
    }

    return _buildActionCard(
      icon: Icons.extension_rounded,
      title: getString(670), //'Block Hanzi',
      subtitle: getString(671), //'Build and explore characters from components',
      isPrimary: true,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DrillPageCore(
              drillCategory: drillCategory,
              startingCenterZiId: 1,
              subItemId: subItemId,
              isFromReviewPage: isFromReviewPage,
              customString: customString,
            ),
          ),
        );
      },
    );
  }

  Widget _buildPracticeGrid(bool isNarrow) {
    final cards = <Widget>[];

    if (!_isThirdPartyTextbook()) {
      if (drillCategory == DrillCategory.custom) {
        cards.add(_buildActionCard(
          icon: Icons.style_rounded,
          title: getString(2),
          subtitle: getString(694), //'Review each Hanzi with details',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DictionarySearchingPage(
                  dicStage: DictionaryStage.detailedzi,
                  firstOrSearchingZiIndex: -1,
                  flashcardList: customString,
                  dicCaller: DicCaller.Flashcard,
                ),
              ),
            );
          },
        ));
      }

      cards.add(_buildActionCard(
        icon: Icons.translate_rounded,
        title: getString(448),
        subtitle: getString(667), //'Choose the correct meaning',
        onTap: () {
          if (drillCategory == DrillCategory.custom) { // old Yumen is here
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => QuizPage(
                  quizTextbook: QuizTextbook.custom,
                  quizCategory: QuizCategory.meaning,
                  lessonId: 0,
                  wordsStudy: customString,
                  includeSkipSection: false,
                ),
              ),
            );
          }
          else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => StandardExamPage(
                  drillCategory: drillCategory,
                  subItemId: subItemId,
                  quizCategory: QuizCategory.meaning,
                  customString: '',
                ),
              ),
            );
          }
        },
      ));

      cards.add(_buildActionCard(
        icon: Icons.volume_up_rounded,
        title: getString(488),
        subtitle: getString(668), //'Listen and choose the Hanzi',
        onTap: () {
          if (drillCategory == DrillCategory.custom) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => QuizPage(
                  quizTextbook: QuizTextbook.custom,
                  quizCategory: QuizCategory.soundToZi,
                  lessonId: 0,
                  wordsStudy: customString,
                  includeSkipSection: false,
                ),
              ),
            );
          }
          else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => StandardExamPage(
                  drillCategory: drillCategory,
                  subItemId: subItemId,
                  quizCategory: QuizCategory.soundToZi,
                  customString: customString,
                ),
              ),
            );
          }
        },
      ));

      cards.add(_buildActionCard(
        icon: Icons.record_voice_over_rounded,
        title: getString(447),
        subtitle: getString(669), //'See Hanzi and choose its sound',
        onTap: () {
          if (drillCategory == DrillCategory.custom) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => QuizPage(
                  quizTextbook: QuizTextbook.custom,
                  quizCategory: QuizCategory.ziToSound,
                  lessonId: 0,
                  wordsStudy: customString,
                  includeSkipSection: false,
                ),
              ),
            );
          }
          else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => StandardExamPage(
                  drillCategory: drillCategory,
                  subItemId: subItemId,
                  quizCategory: QuizCategory.ziToSound,
                  customString: customString,
                ),
              ),
            );
          }
        },
      ));

      if (drillCategory == DrillCategory.custom) {
        cards.add(_buildActionCard(
          icon: Icons.keyboard_alt_rounded,
          title: getString(489),
          subtitle: getString(695), //'Practice typing the Hanzi',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InputZiPage(
                  typingType: TypingType.Custom,
                  lessonId: 0,
                  wordsStudy: customString,
                  isSoundPrompt: false,
                  inputMethod: InputMethod.Pinxin,
                  showHint: HintType.Hint1,
                  includeSkipSection: false,
                  showSwitchMethod: false,
                ),
              ),
            );
          },
        ));

        cards.add(_buildActionCard(
          icon: Icons.hearing_rounded,
          title: getString(491),
          subtitle: getString(696), //'Listen first, then type Hanzi',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InputZiPage(
                  typingType: TypingType.Custom,
                  lessonId: 0,
                  wordsStudy: customString,
                  isSoundPrompt: true,
                  inputMethod: InputMethod.Pinxin,
                  showHint: HintType.Hint1,
                  includeSkipSection: false,
                  showSwitchMethod: false,
                ),
              ),
            );
          },
        ));

        cards.add(_buildActionCard(
          icon: Icons.menu_book_rounded,
          title: getString(492),
          subtitle: getString(697), //'Study customized Hanzi together',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudyCustomizedWordsPage(
                  titleStringId: 409,
                  customString: customString,
                  studyType: StudyType.all,
                ),
              ),
            );
          },
        ));
      }
    }

    if (cards.isEmpty) {
      return SizedBox(width: 0, height: 0);
    }

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: cards.map((card) {
        return SizedBox(
          width: isNarrow ? double.infinity : 280,
          child: card,
        );
      }).toList(),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    final iconColor = isPrimary ? Color(0xFF0F766E) : Color(0xFF2563EB);
    final iconBg = isPrimary ? Color(0xFFE6F7F2) : Color(0xFFEFF6FF);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(isPrimary ? 26 : 22),
      elevation: isPrimary ? 5 : 2,
      shadowColor: Colors.black.withOpacity(isPrimary ? 0.12 : 0.08),
      child: InkWell(
        borderRadius: BorderRadius.circular(isPrimary ? 26 : 22),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(isPrimary ? 24 : 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isPrimary ? 26 : 22),
            border: Border.all(
              color: isPrimary ? Color(0xFFC7EDE2) : Color(0xFFE5E7EB),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: isPrimary ? 64 : 48,
                height: isPrimary ? 64 : 48,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(isPrimary ? 20 : 16),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: isPrimary ? 34 : 26,
                ),
              ),
              SizedBox(width: isPrimary ? 18 : 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: isPrimary ? 22 : 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: isPrimary ? 14 : 13,
                        height: 1.3,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Icon(
                Icons.arrow_forward_rounded,
                color: iconColor,
                size: isPrimary ? 30 : 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _prepareThirdPartyLessonIfNeeded() {
    if (widget.thirdPartyType == ThirdPartyType.sunlaoshi) {
      ThirdPartyLesson.setThirdPartyTypeAndLessonId(
          ThirdPartyType.sunlaoshi, subItemId);
    }
    else if (widget.thirdPartyType == ThirdPartyType.yuwenAll) {
      ThirdPartyLesson.setThirdPartyTypeAndLessonId(
          ThirdPartyType.yuwenAll, subItemId);
    }
    else if (widget.thirdPartyType == ThirdPartyType.cMadeEasy) {
      ThirdPartyLesson.setThirdPartyTypeAndLessonId(
          ThirdPartyType.cMadeEasy, subItemId);
    }
  }

  Widget getDrillPageCore(drillCategory) {
    if (widget.thirdPartyType == ThirdPartyType.sunlaoshi || widget.thirdPartyType == ThirdPartyType.yuwenAll || widget.thirdPartyType == ThirdPartyType.cMadeEasy) {
      return SizedBox(width: 0.0, height: 0.0);
    }

    bool isFromReviewPage = true;
    if(drillCategory == DrillCategory.custom) {
      isFromReviewPage = false;
    }

    return RawMaterialButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(33),
          ),
          side: BorderSide(color: Colors.blue, width: 0.5)
      ),
      fillColor: Colors.blue.shade100,
      onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) =>
                DrillPageCore(drillCategory: drillCategory,
                    startingCenterZiId: 1,
                    subItemId: subItemId,
                    isFromReviewPage: isFromReviewPage,
                    customString: customString)));
      },
      child: Text(getString(456), //"Learn Hanzi"
          style: TextStyle(color: Colors.brown)), // lightBlue
    );
  }

  Widget getExamSoundToHanzi(DrillCategory drillCategory) {
    if (widget.thirdPartyType == ThirdPartyType.sunlaoshi || widget.thirdPartyType == ThirdPartyType.yuwenAll || widget.thirdPartyType == ThirdPartyType.cMadeEasy) {
      return SizedBox(width: 0.0, height: 0.0);
    }

    if(drillCategory == DrillCategory.custom) {
      return RawMaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(33),
            ),
            side: BorderSide(color: Colors.lightBlueAccent, width: 0.5)
        ),
        fillColor: Colors.blue.shade100,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) =>
                QuizPage(quizTextbook: QuizTextbook.custom, quizCategory: QuizCategory.soundToZi, lessonId: 0, wordsStudy: customString, includeSkipSection: false,),
            ),
          );
        },
        child: Text(getString(488), //"Test Hanzi meaning"
            style: TextStyle(color: Colors.brown)), // lightBlue
      );
    }
    else { //HSK
      return RawMaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(33),
            ),
            side: BorderSide(color: Colors.blue, width: 0.5)
        ),
        fillColor: Colors.blue.shade100,
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) =>
                  StandardExamPage(drillCategory: drillCategory,
                      subItemId: subItemId,
                      quizCategory: QuizCategory.soundToZi,
                      customString: customString)));
        },
        child: Text(getString(488), //"Test sound to Hanzi"
            style: TextStyle(color: Colors.brown)), // lightBlue
      );
    }
  }

  Widget getExamHanziToSound(DrillCategory drillCategory) {
    if (widget.thirdPartyType == ThirdPartyType.sunlaoshi || widget.thirdPartyType == ThirdPartyType.yuwenAll || widget.thirdPartyType == ThirdPartyType.cMadeEasy) {
      return SizedBox(width: 0.0, height: 0.0);
    }

    if(drillCategory == DrillCategory.custom) {
      return RawMaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(33),
            ),
            side: BorderSide(color: Colors.lightBlueAccent, width: 0.5)
        ),
        fillColor: Colors.blue.shade100,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) =>
                QuizPage(quizTextbook: QuizTextbook.custom, quizCategory: QuizCategory.ziToSound, lessonId: 0, wordsStudy: customString, includeSkipSection: false),
            ),
          );
        },
        child: Text(getString(447), //"Test Hanzi to sound"
            style: TextStyle(color: Colors.brown)), // lightBlue
      );
    }
    else {
      return RawMaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(33),
            ),
            side: BorderSide(color: Colors.blue, width: 0.5)
        ),
        fillColor: Colors.blue.shade100,
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) =>
                  StandardExamPage(drillCategory: drillCategory,
                      subItemId: subItemId,
                      quizCategory: QuizCategory.ziToSound,
                      customString: customString)));
        },
        child: Text(getString(447), //"Test Hanzi to sound"
            style: TextStyle(color: Colors.brown)), // lightBlue
      );
    }
  }

  Widget getExamMeaning(drillCategory) {
    if (widget.thirdPartyType == ThirdPartyType.sunlaoshi || widget.thirdPartyType == ThirdPartyType.yuwenAll || widget.thirdPartyType == ThirdPartyType.cMadeEasy) {
      return SizedBox(width: 0.0, height: 0.0);
    }

    if(drillCategory == DrillCategory.custom) {
      return RawMaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(33),
            ),
            side: BorderSide(color: Colors.lightBlueAccent, width: 0.5)
        ),
        fillColor: Colors.blue.shade100,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) =>
                QuizPage(quizTextbook: QuizTextbook.custom, quizCategory: QuizCategory.meaning, lessonId: 0, wordsStudy: customString, includeSkipSection: false),
            ),
          );
        },
        child: Text(getString(448), //"Test Hanzi meaning"
            style: TextStyle(color: Colors.brown)), // lightBlue
      );
    }
    else { // HSK
      return RawMaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(33),
            ),
            side: BorderSide(color: Colors.lightBlueAccent, width: 0.5)
        ),
        fillColor: Colors.blue.shade100,
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) =>
                  StandardExamPage(drillCategory: drillCategory,
                      subItemId: subItemId,
                      quizCategory: QuizCategory.meaning,
                      customString: '')));
        },
        child: Text(getString(448), //"Test Hanzi meaning"
            style: TextStyle(color: Colors.brown)), // lightBlue
      );
    }
  }

  Widget getReadAndTypeHanzi(DrillCategory drillCategory) {
    if(drillCategory != DrillCategory.custom) {
      return SizedBox(width: 0.0, height: 0.0);
    }

    if (widget.thirdPartyType == ThirdPartyType.sunlaoshi || widget.thirdPartyType == ThirdPartyType.yuwenAll || widget.thirdPartyType == ThirdPartyType.cMadeEasy) {
      if (widget.thirdPartyType == ThirdPartyType.sunlaoshi) {
        ThirdPartyLesson.setThirdPartyTypeAndLessonId(
            ThirdPartyType.sunlaoshi, subItemId);
      }
      else if (widget.thirdPartyType == ThirdPartyType.yuwenAll) {
        ThirdPartyLesson.setThirdPartyTypeAndLessonId(
            ThirdPartyType.yuwenAll, subItemId);
      }
      else if (widget.thirdPartyType == ThirdPartyType.cMadeEasy) {
        ThirdPartyLesson.setThirdPartyTypeAndLessonId(
            ThirdPartyType.cMadeEasy, subItemId);
      }

      return TextButton(
          style: ButtonStyle(
            //backgroundColor: WidgetStateProperty.all(backgroundColor),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0)),  // 0.0 is rectangle
            ),
            minimumSize: WidgetStateProperty.all(Size(0.0, 0.0)),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: WidgetStateProperty.all(EdgeInsets.all(0.0)), // 2.0 for showing color for correct or wrong ones
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    InputZiPage(typingType: TypingType.ThirdParty,
                        lessonId: 0,
                        wordsStudy: customString,
                        isSoundPrompt: false,
                        inputMethod: InputMethod.Pinxin,
                        showHint: HintType.Hint1,
                        includeSkipSection: false,
                        showSwitchMethod: false), //InputZiPage(),
              ),
            );
          },
          child: Image.asset("assets/core/typing.png",
            width: 180.0,
            height: 90.0,
            //    fit: fit,
          )
      );
    }
    else {
      return RawMaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(33.0),
            ),
            side: BorderSide(color: Colors.blue, width: 0.5)
        ),
        fillColor: Colors.blue.shade100,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  InputZiPage(typingType: TypingType.Custom,
                      lessonId: 0,
                      wordsStudy: customString,
                      isSoundPrompt: false,
                      inputMethod: InputMethod.Pinxin,
                      showHint: HintType.Hint1,
                      includeSkipSection: false,
                      showSwitchMethod: false), //InputZiPage(),
            ),
          );
        },
        child: Text(getString(489), //"Read and type Hanzi"
            style: TextStyle(color: Colors.brown)),
      );
    }
  }

  Widget getListenAndTypeHanzi(DrillCategory drillCategory) {
    if (widget.thirdPartyType == ThirdPartyType.sunlaoshi || widget.thirdPartyType == ThirdPartyType.yuwenAll || widget.thirdPartyType == ThirdPartyType.cMadeEasy) {
      return SizedBox(width: 0.0, height: 0.0);
    }

    if(drillCategory != DrillCategory.custom) {
      return SizedBox(width: 0.0, height: 0.0);
    }
    else {
      return RawMaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(33),
            ),
            side: BorderSide(color: Colors.blue, width: 0.5)
        ),
        fillColor: Colors.blue.shade100,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    InputZiPage(typingType: TypingType.Custom,
                        lessonId: 0, wordsStudy: customString, isSoundPrompt: true, inputMethod: InputMethod.Pinxin, showHint: HintType.Hint1, includeSkipSection: false, showSwitchMethod: false) //InputZiPage(),
            ),
          );
        },
        child: Text(getString(491), //"Listen and type Hanzi"
            style: TextStyle(color: Colors.brown)), // lightBlue
      );
    }
  }

  Widget getFlashcard(DrillCategory drillCategory) {
    if (widget.thirdPartyType == ThirdPartyType.sunlaoshi || widget.thirdPartyType == ThirdPartyType.yuwenAll || widget.thirdPartyType == ThirdPartyType.cMadeEasy) {
      return SizedBox(width: 0.0, height: 0.0);
    }

    if(drillCategory != DrillCategory.custom) {
      return SizedBox(width: 0.0, height: 0.0);
    }

    bool isFromReviewPage = true;
    if(drillCategory == DrillCategory.custom) {
      isFromReviewPage = false;
    }

    return RawMaterialButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(33),
          ),
          side: BorderSide(color: Colors.blue, width: 0.5)
      ),
      fillColor: Colors.blue.shade100,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DictionarySearchingPage(
                    dicStage: DictionaryStage.detailedzi,
                    firstOrSearchingZiIndex: -1,
                    flashcardList: customString,
                    dicCaller: DicCaller.Flashcard),
          ),
        );
      },
      child: Text(getString(2), //"Flashcards"
          style: TextStyle(color: Colors.brown)), // lightBlue
    );
  }

  Widget getStudyCustomizedWordsPage(DrillCategory drillCategory) {
    if (widget.thirdPartyType == ThirdPartyType.sunlaoshi || widget.thirdPartyType == ThirdPartyType.yuwenAll || widget.thirdPartyType == ThirdPartyType.cMadeEasy) {
      return SizedBox(width: 0.0, height: 0.0);
    }

    if(drillCategory != DrillCategory.custom) {
      return SizedBox(width: 0.0, height: 0.0);
    }

    bool isFromReviewPage = true;
    if(drillCategory == DrillCategory.custom) {
      isFromReviewPage = false;
    }

    return RawMaterialButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(33),
          ),
          side: BorderSide(color: Colors.blue, width: 0.5)
      ),
      fillColor: Colors.blue.shade100,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                StudyCustomizedWordsPage(titleStringId: 409, customString: customString, studyType: StudyType.all),
          ),
        );
      },
      child: Text(getString(492), //"Hanzi: learn, ..."
          style: TextStyle(color: Colors.brown)), // lightBlue
    );
  }

  Future<bool>_onWillPop() {
    return Future.value(true);
  }
}
