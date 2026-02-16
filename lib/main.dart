import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/engine/standardexammanager.dart';
import 'package:hanzishu/engine/statisticsmanager.dart';
import 'package:hanzishu/engine/storagehandler.dart';
import 'package:hanzishu/ui/lessonspage.dart';
import 'package:hanzishu/ui/launchpage.dart';
import 'package:hanzishu/ui/dictionarypage.dart';
import 'package:hanzishu/ui/mepage.dart';
import 'package:hanzishu/ui/theme.dart';
import 'package:hanzishu/engine/lessonmanager.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/phrasemanager.dart';
import 'package:hanzishu/engine/sentencemanager.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/engine/lessonunitmanager.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/ui/inputzipage.dart';
import 'package:hanzishu/engine/quizmanager.dart';
import 'package:hanzishu/ui/toolspage.dart';
import 'package:hanzishu/ui/mepage.dart';
import 'package:hanzishu/ui/wordpage.dart';
import 'package:hanzishu/engine/inputzimanager.dart';
import 'package:hanzishu/engine/componentmanager.dart';
import 'package:hanzishu/engine/strokemanager.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';
import 'package:hanzishu/ui/drillpage.dart';
import 'package:hanzishu/engine/triemanager.dart';
import 'package:hanzishu/engine/inputgamemanager.dart';

import 'dart:io';
import "package:hanzishu/utility.dart";
import 'dart:ui';

import 'package:go_router/go_router.dart';
import 'package:go_router/src/state.dart';

import 'package:hanzishu/ui/inputgamepage.dart';

// Define your routes and associate them with screens.
final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => MyHomePage(),
    ),
    GoRoute(
      //Example: hanzishu.com/#/details?id=55&x=99
      path: '/details',
      builder: (context, state) {
        // Access the query parameter 'id'
        final itemId = state.uri.queryParameters['id'];
        final xValue = state.uri.queryParameters['x'];

        return DetailPage(itemId: itemId, xValue: xValue);
      },
    ),
    GoRoute(
      //Example: hanzishu.com/#/dictionary?id=55&x=99
      path: '/lessons',
      builder: (context, state) {
        return LaunchPage();
      },
    ),
    GoRoute(
      //Example: hanzishu.com/#/dictionary?id=55&x=99
      path: '/dictionary',
      builder: (context, state) {
        return InputZiPage(typingType: TypingType.DicSearchTyping, lessonId: 0, wordsStudy: '', isSoundPrompt: false, inputMethod: InputMethod.Both, showHint: HintType.Hint1, includeSkipSection: false, showSwitchMethod: false);
      },
    ),
    GoRoute(
      //Example: hanzishu.com/#/dictionary?id=55&x=99
      path: '/puzzle',
      builder: (context, state) {
        return WordPage();
      },
    ),
    GoRoute(
      //Example: hanzishu.com/#/dictionary?id=55&x=99
      path: '/input',
      builder: (context, state) {
        return ToolsPage();
      },
    ),
    GoRoute(
      //Example: hanzishu.com/#/dictionary?id=55&x=99
      path: '/more',
      builder: (context, state) {
        return MePage();
      },
    ),
    GoRoute(
      //Example: hanzishu.com/#/inputgame?gameid=1
      path: '/inputgame',
      builder: (context, state) {
        final gameid = state.uri.queryParameters['gameid'];
        return InputGamePage(gameid: gameid);
      },
    ),
    // Example with a path parameter
    //  GoRoute(
    //    path: '/profile/:userId',
    //    builder: (context, state) {
    //      final userId = state.pathParameters['userId']!;
    //      return ProfileScreen(userId: userId);
    //    },
    //  ),
  ],
  // Optional: Add an error screen builder
  // errorBuilder: (context, state) => const NotFoundScreen(),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    // 2. Attach the GoRouter to your app
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
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
    theLessonUnitManager = LessonUnitManager();
    thePositionManager = PositionManager();
    theStorageHandler = StorageHandler();
    theQuizManager = QuizManager();
    theStatisticsManager = StatisticsManager();
    theInputZiManager = InputZiManager();
    theComponentManager = ComponentManager();
    theStrokeManager = StrokeManager();
    theDictionaryManager = DictionaryManager();
    theStandardExamManager = StandardExamManager();

    theStatisticsManager.init(LessonQuizResult(dateString : '', lessonId : -1, cor : -1, answ : -1));
    theTrieManager = TrieManager();
    //move to lesson
    //LessonManager.populateLessonsInfo();

    theInputGameManager = InputGameManager();
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
    //LessonsPage(),
    LaunchPage(),
    //DictionaryPage(),
    InputZiPage(typingType: TypingType.DicSearchTyping, lessonId: 0, wordsStudy: '', isSoundPrompt: false, inputMethod: InputMethod.Both, showHint: HintType.Hint1, includeSkipSection: false, showSwitchMethod: false), //InputZiPage(),
    WordPage(),
    //DrillPage(drillCategory: DrillCategory.all, subItemId: 0, customString: null),
    ToolsPage(), // typing
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
        //selectedLabelStyle: textTheme.caption,
        //unselectedLabelStyle: textTheme.caption,
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
    //caption: base.caption.copyWith(
    //  fontWeight: FontWeight.w400,
    //  fontSize: 14,
    //  letterSpacing: defaultLetterSpacing,
    //),
    //button: base.button.copyWith(
    //  fontWeight: FontWeight.w500,
    //  fontSize: 14,
    //  letterSpacing: defaultLetterSpacing,
    //),
  )
      .apply(
    fontFamily: 'Rubik',
    displayColor: shrineBrown900,
    bodyColor: shrineBrown900,
  );
}

const ColorScheme _shrineColorScheme = ColorScheme(
  primary: shrinePink100,
  //primaryVariant: shrineBrown900,
  secondary: shrinePink50,
  //secondaryVariant: shrineBrown900,
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

class DetailPage extends StatelessWidget {
  final String? itemId;
  final String? xValue;
  const DetailPage({this.itemId, this.xValue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Screen')),
      body: Center(child: Text('Item ID: ${itemId ?? "None"} xValue: ${xValue ?? "None"}')),
    );
  }
}