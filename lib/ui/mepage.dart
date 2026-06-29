import 'package:flutter/material.dart';
import 'package:hanzishu/ui/glossarypage.dart';
import 'package:hanzishu/ui/quizresultpage.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/privacypolicy.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hanzishu/ui/settingspage.dart';
import 'package:hanzishu/ui/basiccomponentspage.dart';
import 'package:hanzishu/ui/flashcardpage.dart';
import 'package:hanzishu/ui/practicesheetpage.dart';
import 'dart:io';
import 'package:hanzishu/variables.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hanzishu/ui/webviewpage.dart';

class MePage extends StatefulWidget {
  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {
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
      backgroundColor: Color(0xFFF7F4EC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 900),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
                    children: [
                      _buildSectionHeader(
                        icon: Icons.eco_rounded,
                        title: getString(699), //'Learn',
                      ),
                      /*
                      _buildMenuItem(
                        icon: Icons.menu_book_rounded,
                        iconColor: Color(0xFF2E8B57),
                        iconBackground: Color(0xFFE3F5EA),
                        title: 'Hanzishu Introduction',
                        onTap: _openIntroduction,
                      ),
                      */
                      _buildMenuItem(
                        icon: Icons.translate_rounded,
                        iconColor: Color(0xFF2B84D6),
                        iconBackground: Color(0xFFE2F1FC),
                        title: getString(470), //'Chinese Components',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BasicComponentsPage(),
                            ),
                          );
                        },
                      ),
                      if (kIsWeb)
                        _buildMenuItem(
                          icon: Icons.school_rounded,
                          iconColor: Color(0xFF6B4BB5),
                          iconBackground: Color(0xFFF0E8FB),
                          title: getString(420), //'Chinese Enlightening Classes',
                          onTap: () {
                            launchUrl(
                              Uri.parse("https://hanzishu.com/lesson"),
                              webOnlyWindowName: '_self',
                            );
                          },
                        ),

                      SizedBox(height: 22),
                      _buildSectionHeader(
                        icon: Icons.handyman_rounded,
                        title: getString(700), //'Tools',
                      ),
                      _buildMenuItem(
                        icon: Icons.style_rounded,
                        iconColor: Color(0xFFE08A1E),
                        iconBackground: Color(0xFFFFF0CE),
                        title: getString(406), //'Customized Flashcards',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FlashcardPage(),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.edit_note_rounded,
                        iconColor: Color(0xFFE95367),
                        iconBackground: Color(0xFFFFE3E7),
                        title: getString(449), //'Hanzi Practice Sheet Generator',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PracticeSheetPage(
                                initZis: "合体字练习部件非笔画",
                              ),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.auto_stories_rounded,
                        iconColor: Color(0xFF7B5AC8),
                        iconBackground: Color(0xFFF0E8FB),
                        title: getString(440), //'Glossary',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GlossaryPage(),
                            ),
                          );
                        },
                      ),
                      if (!kIsWeb) _buildQuizResultsItem(),

                      SizedBox(height: 22),
                      _buildSectionHeader(
                        icon: Icons.settings_rounded,
                        title: getString(698), //'Settings & Support',
                      ),
                      _buildMenuItem(
                        icon: Icons.language_rounded,
                        iconColor: Color(0xFF2E8B57),
                        iconBackground: Color(0xFFE3F5EA),
                        title: getString(302), //'Language Setting',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingsPage(),
                            ),
                          ).then((val) => {_callbackFromSettingsPage()});
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.privacy_tip_rounded,
                        iconColor: Color(0xFF2B84D6),
                        iconBackground: Color(0xFFE2F1FC),
                        title: getString(141), //'Privacy Policy & Contact Us',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrivacyPolicyPage(),
                            ),
                          );
                        },
                      ),
                      if (kIsWeb)
                        _buildMenuItem(
                          icon: Icons.link_rounded,
                          iconColor: Color(0xFFF19A22),
                          iconBackground: Color(0xFFFFEED8),
                          title: getString(603), //'Resources',
                          onTap: () {
                            launchUrl(
                              Uri.parse("https://hanzishu.com/links"),
                              webOnlyWindowName: '_self',
                            );
                          },
                        ),
                    ],
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
      height: 110,
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
          topLeft: Radius.circular(48),
          topRight: Radius.circular(48),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 28,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 34),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Text(
            getString(94), //'More',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 34,
            color: Color(0xFF5F8E52),
          ),
          SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0E5A35),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 18, 12),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: iconBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 38,
                    color: iconColor,
                  ),
                ),
                SizedBox(width: 28),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 36,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuizResultsItem() {
    return _buildMenuItem(
      icon: Icons.emoji_events_rounded,
      iconColor: Color(0xFF9A6A22),
      iconBackground: Color(0xFFFFF0CE),
      title: getString(267),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizResultPage(),
          ),
        );
      },
    );
  }

  void _openIntroduction() {
    String webUrl;
    if (theDefaultLocale == "en_US") {
      webUrl = "https://hanzishu.com/publish/index-en.htm";
    } else {
      webUrl = "https://hanzishu.com/publish";
    }

    if (kIsWeb) {
      launchUrl(Uri.parse(webUrl), webOnlyWindowName: '_self');
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebViewPage(webUrl, getString(94)),
        ),
      );
    }
  }

  void _callbackFromSettingsPage() {
    if (currentLocale != theDefaultLocale) {
      setState(() {
        currentLocale = theDefaultLocale;
      });
      theStorageHandler.setLanguage(theDefaultLocale);
      theStorageHandler.SaveToFile();

      final BottomNavigationBar navigationBar =
      globalKeyNav.currentWidget as BottomNavigationBar;
      navigationBar.onTap!(3);
    }
  }
}
