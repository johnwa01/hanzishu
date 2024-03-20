import 'package:flutter/material.dart';
import 'package:hanzishu/data/pinyinlist.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/engine/texttospeech.dart';
import 'package:hanzishu/engine/pinyin.dart';

class PinyinPage extends StatefulWidget {
  final int currentPinyinLessonId;
  final bool includeSkipSection;
  PinyinPage({this.currentPinyinLessonId, this.includeSkipSection});

  @override
  _PinyinPageState createState() => _PinyinPageState();
}

class _PinyinPageState extends State<PinyinPage> {
  double screenWidth;
  int currentPinyinLessonId;
  int currentPinyinExerciseIndex;
  bool includeSkipSection;
  List<int> currentExerciseCollection;


  @override
  void initState() {
    super.initState();

    currentPinyinLessonId = widget.currentPinyinLessonId;
    includeSkipSection = widget.includeSkipSection;
    currentPinyinExerciseIndex = 0;
  }

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidthForTreeAndDict(context);

    String pinyinExerciseName = getString(505) /*"Pinyin exercise"*/ + " " + currentPinyinLessonId.toString();

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(pinyinExerciseName),
      ),
      body: Center
        (
        child: getPinyinSections(context),
      ),
    );
  }

  Widget getMainPinyin() {
    var exerciseList = thePinyinLessonList[currentPinyinLessonId];
    //only need to worry about one index. When index increases through next button, this will show next index.
    var name = thePinyinList[exerciseList[currentPinyinExerciseIndex]].name;
    var sample = thePinyinList[exerciseList[currentPinyinExerciseIndex]].sample;

    if (name.length != 0) {
      return TextButton(
        style: TextButton.styleFrom(
          textStyle: TextStyle(fontSize: 220.0 * getSizeRatioWithLimit()),
        ),
        onPressed: () {
          TextToSpeech.speak("zh-CN", sample.zi);
        },
        child: Text(name,
            style: TextStyle(color: Colors.redAccent)),

      );
    }
    else {
      return SizedBox(width: 0.0, height: 0.0);
    }
  }

  Widget getMainHanzi() {
    var exerciseList = thePinyinLessonList[currentPinyinLessonId];
    //only need to worry about one index. When index increases through next button, this will show next index.
    var name = thePinyinList[exerciseList[currentPinyinExerciseIndex]].name;
    var sample = thePinyinList[exerciseList[currentPinyinExerciseIndex]].sample;

    if (name.length != 0) {
      return TextButton(
        style: TextButton.styleFrom(
          textStyle: TextStyle(fontSize: 40.0 * getSizeRatioWithLimit()),
        ),
        onPressed: () {
          TextToSpeech.speak("zh-CN", sample.zi);
        },
        child: Text(sample.zi,
            style: TextStyle(color: Colors.lightBlue)),

      );
    }
    else {
      return SizedBox(width: 0.0, height: 0.0);
    }
  }

  Widget getOneSample(Sample sample) {
    return Column(
      children: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
          textStyle: TextStyle(fontSize: 53.0 * getSizeRatioWithLimit()),
        ),
        onPressed: () {
          TextToSpeech.speak("zh-CN", sample.zi);
        },
        child: Text(sample.pinyin,
          style: TextStyle(color: Colors.redAccent)),
        ),

        TextButton(
          style: TextButton.styleFrom(
            textStyle: TextStyle(fontSize: 25.0 * getSizeRatioWithLimit()),
          ),
        onPressed: () {
          TextToSpeech.speak("zh-CN", sample.zi);
        },
        child: Text(sample.zi,
          style: TextStyle(color: Colors.lightBlue)),
        ),
      ]
    );
  }

  List<Widget> getSamples() {
    List<Widget> sampleWidgets = [];
    var exerciseList = thePinyinLessonList[currentPinyinLessonId];
    //only need to worry about one index. When index increases through next button, this will show next index.
    var samples = thePinyinList[exerciseList[currentPinyinExerciseIndex]].samples;
    for (int i = 0; i < samples.length; i++) {
      sampleWidgets.add(getOneSample(samples[i]));
    }

    return sampleWidgets;
  }

  Widget getNextButton() {
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: TextStyle(fontSize: 20.0 * getSizeRatioWithLimit()),
      ),
      onPressed: () {
        List<Widget> sampleWidgets = [];
        var length = thePinyinLessonList[currentPinyinLessonId].length;
        if (currentPinyinExerciseIndex >= (length - 1)) {
          theIsBackArrowExit = false;
          Navigator.of(context).pop(); // exit
        }
        else {
          setState(() {
            currentPinyinExerciseIndex++;
          });
        }
      },
      child: Text(getString(138), // "Next"
          style: TextStyle(color: Colors.lightBlue)),

    );
  }

  Widget SkipSection() {
    if (includeSkipSection) {
      return TextButton(
        style: TextButton.styleFrom(
          textStyle: TextStyle(fontSize: 15.0 * getSizeRatioWithLimit()),
        ),
        onPressed: () {
          theIsBackArrowExit = false;
          Navigator.of(context).pop(); // exit
        },
        child: Text(getString(401),
            style: TextStyle(color: Colors.lightBlue)),

      );
    }
    else {
      return SizedBox(width: 0.0, height: 0.0);
    }
  }

  Widget getPinyinSections(BuildContext context) {
    // put scrollview since I get render overflow issue
    return SingleChildScrollView(
      child: Column(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [SkipSection()],
              ),
              //padding: EdgeInsets.all(20),
            ),
            Container(
              child: Text(getString(506) /*"Click each Pinyin and repeat after speaker for a few times."*/, style: TextStyle(fontSize: 15.0),),
              //padding: EdgeInsets.all(15),
            ),
            SizedBox(height: 30.0 * getSizeRatioWithLimit()),
            //Container(
              //child: Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                //children: <Widget>[
                  getMainPinyin(),
                  getMainHanzi(),
                //],
              //),
              //padding: EdgeInsets.all(20),
            //),
            SizedBox(height: 30.0 * getSizeRatioWithLimit()),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: getSamples(),
              ),
              //padding: EdgeInsets.all(20),
            ),
            SizedBox(height: 30.0 * getSizeRatioWithLimit()),
            getNextButton(),
          ]
      ),
    );
  }
}