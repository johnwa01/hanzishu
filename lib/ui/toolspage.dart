import 'package:flutter/material.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/ui/inputzipage.dart';
import 'package:hanzishu/engine/component.dart';
import 'package:hanzishu/ui/componentpage.dart';
import 'package:hanzishu/ui/inputzihelppage.dart';
import 'package:hanzishu/ui/typingselectionpage.dart';
import 'package:hanzishu/ui/typingcomponentselectionpage.dart';
import 'package:hanzishu/ui/componentcombinationselectionpage.dart';
import 'package:hanzishu/ui/typingapppage.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'package:hanzishu/ui/webviewpage.dart';
import 'package:hanzishu/ui/studynewwordspage.dart';
import 'package:hanzishu/engine/studywords.dart';
import 'package:hanzishu/engine/thirdpartylesson.dart';
import 'package:hanzishu/ui/thirdpartylessonpage.dart';

class ToolsPage extends StatefulWidget {
  @override
  _ToolsPageState createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  //var exerciseCompleted = [false, false, false, false, false, false, false, false, false, false, false];
  double? screenWidth;

  int numberOfExercises = 0;

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth!);
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidthForTreeAndDict(context);
    thePositionManager.setFrameWidth(screenWidth/* - 10.0*/);

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(""),
      ),
      body: Center
        (
        child: getMeListView(context),
      ),
    );
  }

  _getRequests() async {
    //if (theNewlyCompletedTypingExercise != -1) {
    //exerciseCompleted[theNewlyCompletedTypingExercise] = true;
    //theNewlyCompletedTypingExercise = -1;

    //setState(() {
    // force refresh every time to make sure to pick up completed icon
    this.numberOfExercises += 1;
    //});

    if (!theIsBackArrowExit && this.numberOfExercises <= 4) {
      // reinit
      theIsBackArrowExit = true;
      LaunchExercise(this.numberOfExercises);
    }
    else {
      // init all variables
      // either true back arrow or all done
      theIsBackArrowExit = true;
      theIsFromTypingContinuedSection = false;
      this.numberOfExercises = 0;
    }
    //}
  }

  LaunchExercise(int exerciseNumber) {
    switch (exerciseNumber) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                InputZiPage(
                    typingType: TypingType.FirstTyping, lessonId: 0, wordsStudy: '', isSoundPrompt: false, inputMethod: InputMethod.Pinxin, showHint: HintType.Hint1, includeSkipSection: true, showSwitchMethod: false), //InputZiPage(),
          ),
        ).then((val) => {_getRequests()});
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ComponentPage(questionType: QuestionType.Component),
          ),
        ).then((val) => {_getRequests()});
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                InputZiPage(typingType: TypingType.LeadComponents,
                    lessonId: 0, wordsStudy: '', isSoundPrompt: false, inputMethod: InputMethod.Pinxin, showHint: HintType.Hint1, includeSkipSection: true, showSwitchMethod: false), //InputZiPage(),
          ),
        ).then((val) => {_getRequests()});
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ComponentPage(questionType: QuestionType.ExpandedComponent),
          ),
        ).then((val) => {_getRequests()});
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                InputZiPage(
                    typingType: TypingType.ExpandedReview, lessonId: 0, wordsStudy: '', isSoundPrompt: false, inputMethod: InputMethod.Pinxin, showHint: HintType.Hint1, includeSkipSection: true, showSwitchMethod: false), //InputZiPage(),
          ),
        ).then((val) => {_getRequests()});
        break;
    /*
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                InputZiPage(
                    typingType: TypingType.SingleComponent, lessonId: 0, isSoundPrompt: false, inputMethod: InputMethod.Pinxin, showHint: 3, includeSkipSection: true, showSwitchMethod: false), //InputZiPage(),
          ),
        ).then((val) => {_getRequests()});
        break;
        */
      default:
        break;
    }
  }

  Widget getMeListView(BuildContext context) {
    final ratio = getSizeRatioWithLimit();
    final horizontalPadding = 30.0 * ratio;
    final sectionGap = 24.0 * ratio;

    return ListView(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        10 * ratio,
        horizontalPadding,
        24 * ratio,
      ),
      children: <Widget>[
        Center(
          child: Text(
            "Hanzishu Input Method",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32 * ratio,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
        ),
        SizedBox(height: 8 * ratio),
        Center(
          child: Text(
            "Learn, practice, and use the Hanzishu Input Method.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16 * ratio,
              color: Colors.blueGrey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 22 * ratio),

        _buildEnglishInputNotice(),
        SizedBox(height: sectionGap),

        _buildTutorialHero(context),
        SizedBox(height: sectionGap),

        _buildPracticeSection(context),
        SizedBox(height: sectionGap),

        _buildUseSection(context),
        SizedBox(height: 18 * ratio),

        _buildAdditionalResource(context),
        SizedBox(height: 18 * ratio),

        _buildHelpNote(),
      ],
    );
  }

  Widget _buildEnglishInputNotice() {
    final ratio = getSizeRatioWithLimit();

    return Container(
      padding: EdgeInsets.all(16 * ratio),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12 * ratio),
        border: Border.all(color: Colors.orange.withOpacity(0.22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: Colors.orange[700],
            size: 32 * ratio,
          ),
          SizedBox(width: 16 * ratio),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 15 * ratio,
                  height: 1.45,
                  color: Colors.black87,
                ),
                children: [
                  TextSpan(text: "Please switch your computer or phone to "),
                  TextSpan(
                    text: "English input mode",
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: ".\nHanzishu pictographic input is built into this website."),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialHero(BuildContext context) {
    final ratio = getSizeRatioWithLimit();

    Widget tutorialIcon(double size, double iconSize) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.deepPurple.withOpacity(0.07),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.school_rounded,
          color: Colors.deepPurple,
          size: iconSize,
        ),
      );
    }

    Widget tutorialText({required bool centered}) {
      return Column(
        crossAxisAlignment: centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          _buildPill(
            text: "1. START HERE",
            color: Colors.deepPurple,
          ),
          SizedBox(height: 16 * ratio),
          Text(
            "Hanzishu Input Method Tutorial",
            textAlign: centered ? TextAlign.center : TextAlign.start,
            style: TextStyle(
              fontSize: 24 * ratio,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          SizedBox(height: 10 * ratio),
          Text(
            "Learn the 25 pictographic categories and type any Chinese character.",
            textAlign: centered ? TextAlign.center : TextAlign.start,
            style: TextStyle(
              fontSize: 15.5 * ratio,
              height: 1.4,
              color: Colors.blueGrey[800],
            ),
          ),
          SizedBox(height: 14 * ratio),
          _buildInfoRow(Icons.access_time_rounded, "20-minute guided tutorial", Colors.deepPurple),
          SizedBox(height: 6 * ratio),
          _buildInfoRow(Icons.group_rounded, "Recommended for all new users", Colors.deepPurple),
        ],
      );
    }

    Widget startTutorialButton({required bool fullWidth}) {
      return Container(
        width: fullWidth ? double.infinity : null,
        padding: EdgeInsets.symmetric(
          horizontal: 24 * ratio,
          vertical: 16 * ratio,
        ),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(16 * ratio),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.30),
              blurRadius: 12 * ratio,
              offset: Offset(0, 5 * ratio),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book_rounded, color: Colors.white, size: 28 * ratio),
            SizedBox(width: 12 * ratio),
            Flexible(
              child: Text(
                "Start Tutorial",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17 * ratio,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 8 * ratio),
            Icon(Icons.chevron_right_rounded, color: Colors.white, size: 28 * ratio),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 760;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18 * ratio),
            onTap: () {
              theIsFromTypingContinuedSection = true;
              LaunchExercise(0);
            },
            child: Container(
              padding: EdgeInsets.all(isNarrow ? 20 * ratio : 24 * ratio),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18 * ratio),
                border: Border.all(color: Colors.deepPurple.withOpacity(0.16), width: 1.4 * ratio),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.06),
                    blurRadius: 14 * ratio,
                    offset: Offset(0, 5 * ratio),
                  ),
                ],
              ),
              child: isNarrow
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  tutorialIcon(96 * ratio, 54 * ratio),
                  SizedBox(height: 20 * ratio),
                  tutorialText(centered: true),
                  SizedBox(height: 22 * ratio),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 360 * ratio),
                    child: startTutorialButton(fullWidth: true),
                  ),
                ],
              )
                  : Row(
                children: [
                  tutorialIcon(120 * ratio, 68 * ratio),
                  SizedBox(width: 28 * ratio),
                  Expanded(
                    child: tutorialText(centered: false),
                  ),
                  SizedBox(width: 20 * ratio),
                  startTutorialButton(fullWidth: false),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPracticeLabel(String text) {
    final ratio = getSizeRatioWithLimit();

    return Padding(
      padding: EdgeInsets.only(left: 2 * ratio),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.blueGrey[600],
          fontSize: 11.5 * ratio,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildPracticeSection(BuildContext context) {
    final ratio = getSizeRatioWithLimit();

    return _buildSectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.track_changes_rounded,
            title: "2. PRACTICE TYPING",
            subtitle: "Build speed and confidence through guided practice.",
            color: Colors.deepPurple,
          ),
          SizedBox(height: 20 * ratio),
          _buildMainPracticeCard(context),
          SizedBox(height: 16 * ratio),
          LayoutBuilder(
            builder: (context, constraints) {
              final spacing = 14 * ratio;
              final columns = constraints.maxWidth >= 840
                  ? 3
                  : constraints.maxWidth >= 560
                  ? 2
                  : 1;
              final cardWidth = (constraints.maxWidth - spacing * (columns - 1)) / columns;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPracticeLabel("GENERAL PRACTICE"),
                  SizedBox(height: 10 * ratio),
                  Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: [
                      _buildSmallPracticeCard(
                        width: cardWidth,
                        title: "Basic Exercises",
                        subtitle: "Start from the basics.\nImprove step by step.",
                        icon: Icons.keyboard_rounded,
                        color: Colors.orange,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ComponentCombinationSelectionPage()),
                          );
                        },
                      ),
                      _buildSmallPracticeCard(
                        width: cardWidth,
                        title: "Single Alphabet Words",
                        subtitle: "Practice simple\nalphabet words.",
                        icon: Icons.font_download_rounded,
                        color: Colors.amber[700]!,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TypingComponentSelectionPage()),
                          );
                        },
                      ),
                      _buildSmallPracticeCard(
                        width: cardWidth,
                        title: "Commonly Used Hanzi",
                        subtitle: "Practice the most\ncommonly used characters.",
                        icon: Icons.text_fields_rounded,
                        color: Colors.redAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TypingSelectionPage()),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20 * ratio),
                  _buildPracticeLabel("TEXTBOOK PRACTICE"),
                  SizedBox(height: 10 * ratio),
                  Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: [
                      _buildSmallPracticeCard(
                        width: cardWidth,
                        title: "Ty & Od Textbook",
                        subtitle: "Practice with Ty & Od\ntextbook content.",
                        icon: Icons.menu_book_rounded,
                        color: Colors.blue,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ThirdPartyLessonPage(thirdPartyType: ThirdPartyType.sunlaoshi),
                            ),
                          );
                        },
                      ),
                      _buildSmallPracticeCard(
                        width: cardWidth,
                        title: "Chinese Made Easy",
                        subtitle: "Practice with Chinese\nMade Easy content.",
                        icon: Icons.menu_book_rounded,
                        color: Colors.teal,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ThirdPartyLessonPage(thirdPartyType: ThirdPartyType.cMadeEasy),
                            ),
                          );
                        },
                      ),
                      _buildSmallPracticeCard(
                        width: cardWidth,
                        title: "Yuwen",
                        subtitle: "Practice with Yuwen\ntextbook content.",
                        icon: Icons.menu_book_rounded,
                        color: Colors.deepPurple,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ThirdPartyLessonPage(thirdPartyType: ThirdPartyType.yuwenAll),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMainPracticeCard(BuildContext context) {
    final ratio = getSizeRatioWithLimit();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14 * ratio),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudyCustomizedWordsPage(titleStringId: 516, customString: '', studyType: StudyType.typingOnly),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(18 * ratio),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.04),
            borderRadius: BorderRadius.circular(14 * ratio),
            border: Border.all(color: Colors.green.withOpacity(0.55), width: 1.2 * ratio),
          ),
          child: Row(
            children: [
              _buildRoundIcon(Icons.assignment_rounded, Colors.green, size: 68 * ratio, iconSize: 38 * ratio),
              SizedBox(width: 18 * ratio),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10 * ratio,
                      children: [
                        Text(
                          "Customized Typing Exercises",
                          style: TextStyle(
                            fontSize: 18 * ratio,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        _buildPill(text: "★ MAIN PRACTICE TOOL", color: Colors.green),
                      ],
                    ),
                    SizedBox(height: 8 * ratio),
                    Text(
                      "Paste your own text or content and start practicing right away.",
                      style: TextStyle(
                        fontSize: 14 * ratio,
                        color: Colors.blueGrey[700],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.green[700], size: 34 * ratio),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUseSection(BuildContext context) {
    final ratio = getSizeRatioWithLimit();

    return _buildSectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.edit_rounded,
            title: "3. USE THE INPUT METHOD",
            subtitle: "Apply the Hanzishu Input Method to real-world typing.",
            color: Colors.blue,
          ),
          SizedBox(height: 18 * ratio),
          LayoutBuilder(
            builder: (context, constraints) {
              final spacing = 18 * ratio;
              final columns = constraints.maxWidth >= 680 ? 2 : 1;
              final cardWidth = (constraints.maxWidth - spacing * (columns - 1)) / columns;

              return Wrap(
                spacing: spacing,
                runSpacing: 14 * ratio,
                children: [
                  _buildUseCard(
                    width: cardWidth,
                    title: "Web Editor",
                    subtitle: "Use Hanzishu directly\nin your browser.",
                    badge: "★ MAIN TOOL",
                    icon: Icons.web_asset_rounded,
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InputZiPage(
                            typingType: TypingType.FreeTyping,
                            lessonId: 0,
                            wordsStudy: '',
                            isSoundPrompt: false,
                            inputMethod: InputMethod.Pinxin,
                            showHint: HintType.Hint1,
                            includeSkipSection: false,
                            showSwitchMethod: false,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildUseCard(
                    width: cardWidth,
                    title: "Download Hanzishu App",
                    subtitle: "Use Hanzishu in Word, Excel,\nand other applications.",
                    badge: null,
                    icon: Icons.download_for_offline_rounded,
                    color: Colors.orange,
                    onTap: () {
                      launchTypingAppPageOrHtml();
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalResource(BuildContext context) {
    final ratio = getSizeRatioWithLimit();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.menu_book_outlined, color: Colors.deepPurple, size: 20 * ratio),
            SizedBox(width: 8 * ratio),
            Text(
              "ADDITIONAL RESOURCES",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 13 * ratio,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 10 * ratio),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12 * ratio),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InputZiHelpPage()),
              );
            },
            child: Container(
              padding: EdgeInsets.all(14 * ratio),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.04),
                borderRadius: BorderRadius.circular(12 * ratio),
                border: Border.all(color: Colors.deepPurple.withOpacity(0.12)),
              ),
              child: Row(
                children: [
                  _buildRoundIcon(Icons.info_outline_rounded, Colors.deepPurple, size: 44 * ratio, iconSize: 24 * ratio),
                  SizedBox(width: 14 * ratio),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Introduction to Hanzishu Input Method",
                          style: TextStyle(
                            fontSize: 15 * ratio,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        SizedBox(height: 4 * ratio),
                        Text(
                          "Background, features and benefits of the Hanzishu Input Method.",
                          style: TextStyle(
                            fontSize: 13 * ratio,
                            color: Colors.blueGrey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: Colors.blueGrey[700], size: 28 * ratio),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHelpNote() {
    final ratio = getSizeRatioWithLimit();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16 * ratio,
        vertical: 12 * ratio,
      ),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10 * ratio),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_rounded, color: Colors.deepPurple, size: 18 * ratio),
          SizedBox(width: 10 * ratio),
          Flexible(
            child: Text(
              "Need help? Check the Tutorial first. It will answer 90% of your questions.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 13 * ratio,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContainer({required Widget child}) {
    final ratio = getSizeRatioWithLimit();

    return Container(
      padding: EdgeInsets.all(22 * ratio),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16 * ratio),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14 * ratio,
            offset: Offset(0, 4 * ratio),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    final ratio = getSizeRatioWithLimit();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRoundIcon(icon, color, size: 42 * ratio, iconSize: 26 * ratio),
        SizedBox(width: 12 * ratio),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20 * ratio,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              SizedBox(height: 6 * ratio),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14 * ratio,
                  color: Colors.blueGrey[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSmallPracticeCard({
    required double width,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final ratio = getSizeRatioWithLimit();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12 * ratio),
        onTap: onTap,
        child: Container(
          width: width,
          padding: EdgeInsets.all(14 * ratio),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12 * ratio),
            border: Border.all(color: Colors.black.withOpacity(0.06)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10 * ratio,
                offset: Offset(0, 3 * ratio),
              ),
            ],
          ),
          child: Row(
            children: [
              _buildRoundIcon(icon, color, size: 52 * ratio, iconSize: 28 * ratio),
              SizedBox(width: 12 * ratio),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.5 * ratio,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    SizedBox(height: 6 * ratio),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5 * ratio,
                        height: 1.3,
                        color: Colors.blueGrey[700],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.blueGrey[600], size: 24 * ratio),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUseCard({
    required double width,
    required String title,
    required String subtitle,
    required String? badge,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final ratio = getSizeRatioWithLimit();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12 * ratio),
        onTap: onTap,
        child: Container(
          width: width,
          padding: EdgeInsets.all(18 * ratio),
          decoration: BoxDecoration(
            color: color.withOpacity(0.04),
            borderRadius: BorderRadius.circular(12 * ratio),
            border: Border.all(color: color.withOpacity(0.38)),
          ),
          child: Row(
            children: [
              _buildRoundIcon(icon, color, size: 70 * ratio, iconSize: 38 * ratio),
              SizedBox(width: 18 * ratio),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8 * ratio,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 17 * ratio,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        if (badge != null)
                          _buildPill(text: badge, color: color),
                      ],
                    ),
                    SizedBox(height: 8 * ratio),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13.5 * ratio,
                        height: 1.35,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: color, size: 30 * ratio),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoundIcon(IconData icon, Color color, {required double size, required double iconSize}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.13),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: iconSize),
    );
  }

  Widget _buildPill({required String text, required Color color}) {
    final ratio = getSizeRatioWithLimit();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10 * ratio,
        vertical: 5 * ratio,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16 * ratio),
        border: Border.all(color: color.withOpacity(0.20)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11.5 * ratio,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    final ratio = getSizeRatioWithLimit();

    return Row(
      children: [
        Icon(icon, color: color, size: 20 * ratio),
        SizedBox(width: 10 * ratio),
        Text(
          text,
          style: TextStyle(
            fontSize: 13.5 * ratio,
            color: Colors.blueGrey[800],
          ),
        ),
      ],
    );
  }

  launchTypingAppPageOrHtml() {
    String urlStr;
    if (theDefaultLocale == "zh_CN") {
      urlStr = "https://hanzishu.com/xiangxing/index.htm";
    }
    else { // English
      urlStr = "https://hanzishu.com/xiangxing/index-en.htm";
    }
    if (kIsWeb) {
      launchUrl(Uri.parse(urlStr), webOnlyWindowName: '_self');
    }
    else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebViewPage(urlStr, getString(368)/*"Component Input Method"*/),
        ),
      );
    }
    //else {
    //  Navigator.push(
    //    context,
    //    MaterialPageRoute(
    //      builder: (context) => TypingAppPage(),
    //    ),
    //  );
    //}
  }
}