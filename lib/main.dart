import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hanzishu/engine/statisticsmanager.dart';
import 'package:hanzishu/engine/storagehandler.dart';
import 'package:hanzishu/ui/lessonspage.dart';
import 'package:hanzishu/ui/reviewpage.dart';
import 'package:hanzishu/ui/dictionarypage.dart';
import 'package:hanzishu/ui/dictionarypainter.dart';
import 'package:hanzishu/ui/mepage.dart';
import 'package:hanzishu/ui/theme.dart';
import 'package:hanzishu/engine/lessonmanager.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/phrasemanager.dart';
import 'package:hanzishu/engine/sentencemanager.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/engine/levelmanager.dart';
import 'package:hanzishu/ui/positionmanager.dart';

import 'package:hanzishu/engine/fileio.dart';
import 'package:hanzishu/engine/storagehandler.dart';
import 'package:hanzishu/engine/quizmanager.dart';
import 'package:hanzishu/engine/statisticsmanager.dart';
//import 'package:hanzishu/ui/reviewselectionpage.dart';
import 'package:hanzishu/ui/toolspage.dart';

import 'package:hanzishu/ui/animatedpathpainter.dart'; // TODO: temp
import 'package:hanzishu/engine/inputzimanager.dart';


void main() {
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
    return MaterialApp(
      theme: _buildShrineTheme(),
      title: 'Hanzishu',
      home: MyHomePage(fileIO: CounterStorage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final CounterStorage fileIO;
  MyHomePage({Key key, @required this.fileIO}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  String _str;
  //int _counter;

  @override
  void initState() {
    super.initState();
    init();

    theFileIOFile = widget.fileIO;

    theStorageHandler.initStorage();
    //TODO: for write to storage part of code
    //var str = theStorageHandler.putStorageToJson();
    //widget.fileIO.writeString(str);

    //widget.fileIO.writeCounter(1);

    widget.fileIO.readString().then((String value) {
      if(value != null) {
        var storage = theStorageHandler.getStorageFromJson(value);
        if (storage != null) {
          theStorageHandler.setStorage(storage);
        }
        //setState(() {
        //  _str = value;
        //});
      }
    });
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

    theStatisticsManager.init(0,
        0.0,
        0,
        '',
        null);

    LessonManager.populateLessonsInfo();
  }

  final List<Widget> _children =
  [
    LessonsPage(),
    //ReviewSelectionPage(),
    ToolsPage(),
    DictionaryPage(),
    MePage()
  ];

  onTappedBar(int index)
  {
    theStatisticsManager.trackTimeAndTap();
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTappedBar,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.onSurface,
        unselectedItemColor: colorScheme.onSurface.withOpacity(.60),
        selectedLabelStyle: textTheme.caption,
        unselectedLabelStyle: textTheme.caption,
        items: [
          BottomNavigationBarItem(
            title: Text('Lessons'),
            icon: Icon(Icons.favorite),
          ),
          BottomNavigationBarItem(
            title: Text('Typing'),
            icon: Icon(Icons.location_on),
          ),
          BottomNavigationBarItem(
            title: Text('Dictionary'),
            icon: Icon(Icons.location_on),
          ),
          BottomNavigationBarItem(
            title: Text('Me'),
            icon: Icon(Icons.library_books),
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