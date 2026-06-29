import 'package:flutter/material.dart';
import 'package:hanzishu/ui/wordlevelpage.dart';
import 'package:hanzishu/ui/glossarypage.dart';
import 'package:hanzishu/ui/wordlaunchpage.dart';
import 'package:hanzishu/ui/quizresultpage.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/privacypolicy.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hanzishu/ui/settingspage.dart';
import 'package:hanzishu/ui/basiccomponentspage.dart';
import 'package:hanzishu/ui/flashcardpage.dart';
import 'package:hanzishu/ui/practicesheetpage.dart';
import 'package:hanzishu/ui/studynewwordspage.dart';
import 'dart:io';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/introductionpage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hanzishu/engine/drill.dart';
import 'package:hanzishu/engine/thirdpartylesson.dart';
import 'package:hanzishu/ui/thirdpartylessonpage.dart';
import 'package:hanzishu/engine/studywords.dart';

class WordPage extends StatefulWidget {
  @override
  _MeWordState createState() => _MeWordState();
}

class _MeWordState extends State<WordPage> {
  double? screenWidth;
  String? currentLocale;

  @override
  void initState() {
    super.initState();

    setState(() {
      currentLocale = theDefaultLocale;
    });
  }

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth!);
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidthForTreeAndDict(context);
    thePositionManager.setFrameWidth(screenWidth);

    return Scaffold(
      backgroundColor: Color(0xFFF8F3EE),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 720),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                    child: getMeGridView(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 76,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF2E6F50),
            Color(0xFF4F8D6B),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(46),
          topRight: Radius.circular(46),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 18,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Text(
            getString(670), //'Block Hanzi',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget getMeGridView(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 24,
      mainAxisSpacing: 18,
      childAspectRatio: 1.10,
      children: <Widget>[
        _buildMenuCard(
          icon: Icons.view_in_ar,
          iconText: '木\n口 人',
          title: getString(659), //'All 3,800\nCommon Hanzi',
          subtitle: getString(660), //'Explore the complete set\nof common Hanzi',
          titleColor: Color(0xFF18543B),
          circleColor: Color(0xFFE4F3E9),
          blockColors: [Color(0xFF4F8F4E), Color(0xFFFFC840), Color(0xFFF36E45)],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WordLaunchPage(
                  drillCategory: DrillCategory.all,
                  subItemId: 1,
                  customString: '',
                  thirdPartyType: ThirdPartyType.none,
                ),
              ),
            );
          },
        ),
        _buildMenuCard(
          icon: Icons.menu_book_rounded,
          iconText: 'HSK',
          title: getString(661), //'HSK Hanzi',
          subtitle: getString(662), //'Practice by\nHSK level',
          titleColor: Color(0xFF244F84),
          circleColor: Color(0xFFE3F1FA),
          blockColors: [Color(0xFF3E74B8)],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WordLevelPage(
                  drillCategory: DrillCategory.hsk,
                  subItemId: -1,
                  customString: '',
                ),
              ),
            );
          },
        ),
        _buildMenuCard(
          icon: Icons.edit_note_rounded,
          iconText: '',
          title: getString(663), //'Customized Hanzi',
          subtitle: getString(664), //'Learn from\nyour own text',
          titleColor: Color(0xFF6B3D86),
          circleColor: Color(0xFFF0E5F8),
          blockColors: [Color(0xFF6B3D86)],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudyCustomizedWordsPage(
                  titleStringId: 409,
                  customString: '',
                  studyType: StudyType.all,
                ),
              ),
            );
          },
        ),
        _buildMenuCard(
          icon: Icons.auto_stories_rounded,
          iconText: '语文',
          title: getString(665), //'Yuwen Textbook',
          subtitle: getString(666), //'Study Hanzi from\nYuwen textbooks',
          titleColor: Color(0xFFA54E1B),
          circleColor: Color(0xFFFFEFCB),
          blockColors: [Color(0xFFA54E1B)],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ThirdPartyLessonPage(
                  thirdPartyType: ThirdPartyType.yuwen,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String iconText,
    required String title,
    required String subtitle,
    required Color titleColor,
    required Color circleColor,
    required List<Color> blockColors,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.16),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 22, 16, 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: circleColor,
                ),
                child: Center(
                  child: iconText == '木\n口 人'
                      ? _buildBlockIcon()
                      : Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(icon, size: 62, color: blockColors.first),
                      if (iconText.isNotEmpty)
                        Text(
                          iconText,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: iconText == 'HSK' ? 24 : 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 18),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  height: 1.08,
                  fontWeight: FontWeight.w800,
                  color: titleColor,
                ),
              ),
              SizedBox(height: 10),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.18,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 8),
              Icon(
                Icons.chevron_right,
                size: 28,
                color: Color(0xFF2E6F50),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlockIcon() {
    return SizedBox(
      width: 82,
      height: 74,
      child: Stack(
        children: [
          Positioned(
            left: 28,
            top: 0,
            child: _miniBlock('木', Color(0xFF4F8F4E)),
          ),
          Positioned(
            left: 6,
            bottom: 0,
            child: _miniBlock('口', Color(0xFFFFC840)),
          ),
          Positioned(
            right: 6,
            bottom: 0,
            child: _miniBlock('人', Color(0xFFF36E45)),
          ),
        ],
      ),
    );
  }

  Widget _buildInnerIcon({
    required IconData icon,
    required String iconText,
    required Color iconColor,
  }) {
    if (iconText == '木\n口 人') {
      return _buildBlockIcon();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          icon,
          size: 62,
          color: iconColor,
        ),
        if (iconText.isNotEmpty)
          Text(
            iconText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: iconText == 'HSK' ? 24 : 18,
              fontWeight: FontWeight.w800,
            ),
          ),
      ],
    );
  }

  Widget _miniBlock(String text, Color color) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
