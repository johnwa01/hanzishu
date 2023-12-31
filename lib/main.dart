import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hanzishu/engine/drill.dart';
import 'package:hanzishu/engine/standardexammanager.dart';
import 'package:hanzishu/engine/statisticsmanager.dart';
import 'package:hanzishu/engine/storagehandler.dart';
import 'package:hanzishu/ui/lessonspage.dart';
import 'package:hanzishu/ui/dictionarypage.dart';
import 'package:hanzishu/ui/mepage.dart';
import 'package:hanzishu/ui/theme.dart';
import 'package:hanzishu/engine/lessonmanager.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/phrasemanager.dart';
import 'package:hanzishu/engine/sentencemanager.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/engine/levelmanager.dart';
import 'package:hanzishu/ui/positionmanager.dart';

import 'package:hanzishu/engine/quizmanager.dart';
import 'package:hanzishu/ui/toolspage.dart';
import 'package:hanzishu/ui/mepage.dart';
import 'package:hanzishu/ui/wordpage.dart';
import 'package:hanzishu/engine/inputzimanager.dart';
import 'package:hanzishu/engine/componentmanager.dart';
import 'package:hanzishu/engine/strokemanager.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';
import 'package:hanzishu/ui/drillpage.dart';

import 'dart:io';
import "package:hanzishu/utility.dart";
import 'dart:ui';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}


//void main() => runApp(
//  new MaterialApp(
//    home: new AnimatedPathDemo(),
//  ),
//);

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: _buildShrineTheme(),
      title: 'Hanzishu',
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        // Obtain the current media query information.
        final mediaQueryData = MediaQuery.of(context);
        return MediaQuery(
          // Set the default textScaleFactor to 1.0 for
          // the whole subtree.
          data: mediaQueryData.copyWith(textScaleFactor: 1.0),
          child: child,
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
    theStorageHandler.initStorage();
    initDefaultLocale();
  }

  init() {
    theLessonManager = LessonManager();
    theZiManager = ZiManager();
    thePhraseManager = PhraseManager();
    theSentenceManager = SentenceManager();
    theLevelManager = LevelManager();
    thePositionManager = PositionManager();
    theStorageHandler = StorageHandler();
    theQuizManager = QuizManager();
    theStatisticsManager = StatisticsManager();
    theInputZiManager = InputZiManager();
    theComponentManager = ComponentManager();
    theStrokeManager = StrokeManager();
    theDictionaryManager = DictionaryManager();
    theStandardExamManager = StandardExamManager();

    theStatisticsManager.init(null);

    //move to lesson
    //LessonManager.populateLessonsInfo();
  }

  void initDefaultLocale() {
    String tempLocale;

    if (kIsWeb) {
      var defaultSystemOrWindowLocale = window.locale;
      tempLocale = defaultSystemOrWindowLocale.toString();
    }
    else {
      String defaultSystemOrWindowLocale = Platform.localeName;
      tempLocale = defaultSystemOrWindowLocale;
    }

    if (tempLocale == "en_US" || tempLocale == "zh_CN") {
      theDefaultLocale = tempLocale;
    }
    else {
      theDefaultLocale = "en_US";
    }
  }

  final List<Widget> _children =
  [
    LessonsPage(),
    DictionaryPage(),
    WordPage(),
    //DrillPage(drillCategory: DrillCategory.all, subItemId: 0, customString: null),
    ToolsPage(),
    MePage()
  ];

  onTappedBar(int index)
  {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    //theDrawingSizeRatio = Utility.getDrawingSizeRatio(context);

    //theLessonsPage = _children[0]; // for refresh the Lessons completed page after a quiz

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        key: globalKeyNav,
        onTap: onTappedBar,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: colorScheme.surface,
        selectedItemColor: Colors.green, //colorScheme.onSurface,
        unselectedItemColor: Colors.black, //colorScheme.onSurface.withOpacity(.60),
        selectedLabelStyle: textTheme.caption,
        unselectedLabelStyle: textTheme.caption,
        items: [
          BottomNavigationBarItem(
            label: getString(91)/*'Lessons'*/,
            icon: Image.asset('assets/core/lessonsicon1.png'),
            activeIcon: Image.asset('assets/core/lessonsicon0.png'),
          ),
          BottomNavigationBarItem(
            label: getString(92)/*'Dictionary'*/,
            icon: Image.asset('assets/core/dictionaryicon1.png'),
            activeIcon: Image.asset('assets/core/dictionaryicon0.png'),
          ),
          BottomNavigationBarItem(
            label: getString(1)/*'Drills'*/,
            icon: Image.asset('assets/core/meicon1.png'),
            activeIcon: Image.asset('assets/core/meicon0.png'),
          ),
          BottomNavigationBarItem(
            label: getString(93)/*'Typing'*/,
            icon: Image.asset('assets/core/typingicon1.png'),
            activeIcon: Image.asset('assets/core/typingicon0.png'),
          ),
          BottomNavigationBarItem(
            label: getString(94)/*'Me'*/,
            icon: Image.asset('assets/core/moreicon1.png'),
            activeIcon: Image.asset('assets/core/moreicon0.png'),
          ),
        ],
      ),
    );
  }
}

ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: _shrineColorScheme,
    textTheme: _buildShrineTextTheme(base.textTheme),
  );
}

TextTheme _buildShrineTextTheme(TextTheme base) {
  return base
      .copyWith(
    caption: base.caption.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      letterSpacing: defaultLetterSpacing,
    ),
    button: base.button.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      letterSpacing: defaultLetterSpacing,
    ),
  )
      .apply(
    fontFamily: 'Rubik',
    displayColor: shrineBrown900,
    bodyColor: shrineBrown900,
  );
}

const ColorScheme _shrineColorScheme = ColorScheme(
  primary: shrinePink100,
  primaryVariant: shrineBrown900,
  secondary: shrinePink50,
  secondaryVariant: shrineBrown900,
  surface: shrineSurfaceWhite,
  background: shrineBackgroundWhite,
  error: shrineErrorRed,
  onPrimary: shrineBrown900,
  onSecondary: shrineBrown900,
  onSurface: shrineBrown900,
  onBackground: shrineBrown900,
  onError: shrineSurfaceWhite,
  brightness: Brightness.light,
);