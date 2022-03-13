import 'package:flutter/material.dart';
import 'package:hanzishu/ui/reviewpage.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/data/levellist.dart';
import 'package:hanzishu/engine/levelmanager.dart';

class ReviewLevel {
  int id;
  String name;

  ReviewLevel(this.id, this.name);

  static List<ReviewLevel> startingLevels = List(theLevelList.length);
  static List<ReviewLevel> endingLevels = List(theLevelList.length);


  static populateInitialLevels() {
    var length = theLevelList.length;
    if (startingLevels[0] == null && endingLevels[0] == null) {
      for (var index = 0; index <= length - 1; index++) {
        var level;
        if (index == 0) {
          startingLevels[index] = ReviewLevel(index, "Starting Unit");
          endingLevels[index] = ReviewLevel(index, "Ending Unit");
        }
        else {
          level = ReviewLevel(index, 'Unit ' + index.toString());
          startingLevels[index] = level;
          endingLevels[index] = level;
        }
      }
    }
  }

  // note: selected ReveiwLevel instance has to be the same one as in the list.
  // therefore can't create a new one everytime. Otherwise it'll fail with assert.
  static List<ReviewLevel> getReviewLevelsStarting(int levelSelectedEndingId) {
    if (levelSelectedEndingId == 0) {
      populateInitialLevels();
      return startingLevels;
    }
    else {
      var newStartingLevels = List<ReviewLevel>(levelSelectedEndingId+1);
      for (var index = 0; index <= levelSelectedEndingId; index++) {
          newStartingLevels[index] = startingLevels[index];
      }

      return newStartingLevels;
    }
  }

  static List<ReviewLevel> getReviewLevelsEnding(int levelSelectedStartingId) {
    if (levelSelectedStartingId == 0) {
      populateInitialLevels();
      return endingLevels;
    }
    else {
      var length = endingLevels.length;

      var newLength = length - levelSelectedStartingId + 1;
      var newEndingLevels = List<ReviewLevel>(newLength);
      newEndingLevels[0] = endingLevels[0];
      for (var index = 1; index <= newLength - 1; index++) {
        newEndingLevels[index] = endingLevels[levelSelectedStartingId + index - 1];
      }

      return newEndingLevels;
    }
  }
}

class ReviewLesson {
  int id;
  String name;

  ReviewLesson(this.id, this.name);

  static int getMaximumLessons() {
    //var theNumberOfLessonsInLevels = [7, 13, 15, 15];

    var maximumLessons = 0;
    for (var index = 0; index < theNumberOfLessonsInLevels.length; index++) {
      if (maximumLessons < theNumberOfLessonsInLevels[index]) {
        maximumLessons = theNumberOfLessonsInLevels[index];
      }
    }

    return maximumLessons;
  }

  static List<ReviewLesson> lessons = List(getMaximumLessons() + 1); /*[
    ReviewLesson(0, 'Starting Lesson'),
    ReviewLesson(1, 'Lesson 1'),
    ReviewLesson(2, 'Lesson 2'),
    ReviewLesson(3, 'Lesson 3'),
    ReviewLesson(4, 'Lesson 4'),
    ReviewLesson(5, 'Lesson 5'),
  ];*/

  static populateMaximumLessons(String str) {
    var length = getMaximumLessons() + 1;
    if (lessons[0] == null) {
      for (var index = 0; index < length; index++) {
        var lesson;
        if (index == 0) {
          lesson = ReviewLesson(index, str);
        }
        else {
          lesson = ReviewLesson(index, 'Lesson ' + index.toString());
        }

        lessons[index] = lesson;
      }
    }
  }

  static List<ReviewLesson> getReviewLessonsStarting(int selectedLevel, int lessonSelectedEndingId) {
    if (lessonSelectedEndingId == 0) {
      populateMaximumLessons("Starting Lesson");
      // get real lessons for the level
      var length = 0;
      if (selectedLevel > 0) {
        length = theNumberOfLessonsInLevels[selectedLevel - 1] + 1;
      }
      var startingLessons = List<ReviewLesson>(length);
      for (var index = 0; index < length; index++) {
        startingLessons[index] = lessons[index];
      }

      return startingLessons;
    }
    else {
      var newStartingLessons = List<ReviewLesson>(lessonSelectedEndingId + 1);
      for (var index = 0; index <= lessonSelectedEndingId; index++) {
        newStartingLessons[index] = lessons[index];
      }

      return newStartingLessons;
    }
  }

  static List<ReviewLesson> getReviewLessonsEnding(int selectedLevel, int lessonSelectedStartingId) {
    var length = 0;
    if (lessonSelectedStartingId == 0) {
      populateMaximumLessons("Ending Lesson");
      // get real lessons for the level
      if (selectedLevel > 0) { // Unit 1 to 10 instead of the title "Starting Unit"
        length = theNumberOfLessonsInLevels[selectedLevel - 1] + 1;
      }
      var endingLessons = List<ReviewLesson>(length);
      for (var index = 0; index < length; index++) {
        endingLessons[index] = lessons[index];
      }

      return endingLessons;
    }
    else {
      var newLength = 0;
      if (selectedLevel > 0) {
        length = theNumberOfLessonsInLevels[selectedLevel - 1] + 1; //lessons.length;
        newLength = length - lessonSelectedStartingId + 1;
      }

      var newEndingLessons = List<ReviewLesson>(newLength);
      newEndingLessons[0] = lessons[0];
      for (var index = 1; index <= newLength - 1; index++) {
        newEndingLessons[index] = lessons[lessonSelectedStartingId + index - 1];
      }

      return newEndingLessons;
    }
  }
}

class ReviewSelectionPage extends StatefulWidget {
  @override
  _ReviewSelectionPageState createState() => _ReviewSelectionPageState();
}

class _ReviewSelectionPageState extends State<ReviewSelectionPage> {
  List<ReviewLevel> _reviewLevelsStarting = ReviewLevel.getReviewLevelsStarting(0);
  List<DropdownMenuItem<ReviewLevel>> _dropdownMenuItemsLevelStarting;
  ReviewLevel _selectedReviewLevelStarting;

  List<ReviewLevel> _reviewLevelsEnding = ReviewLevel.getReviewLevelsEnding(0);
  List<DropdownMenuItem<ReviewLevel>> _dropdownMenuItemsLevelEnding;
  ReviewLevel _selectedReviewLevelEnding;

  List<ReviewLesson> _reviewLessonsStarting; // = ReviewLesson.getReviewLessonsStarting(0);
  List<DropdownMenuItem<ReviewLesson>> _dropdownMenuItemsLessonStarting;
  ReviewLesson _selectedReviewLessonStarting;

  List<ReviewLesson> _reviewLessonsEnding; // = ReviewLesson.getReviewLessonsEnding(0);
  List<DropdownMenuItem<ReviewLesson>> _dropdownMenuItemsLessonEnding;
  ReviewLesson _selectedReviewLessonEnding;

  @override
  void initState() {
    _dropdownMenuItemsLevelStarting = buildDropdownMenuItemsLevel(_reviewLevelsStarting);
    _selectedReviewLevelStarting = _dropdownMenuItemsLevelStarting[0].value;

    _dropdownMenuItemsLevelEnding = buildDropdownMenuItemsLevel(_reviewLevelsEnding);
    _selectedReviewLevelEnding = _dropdownMenuItemsLevelEnding[0].value;

    //_dropdownMenuItemsLessonStarting = buildDropdownMenuItemsLesson(_reviewLessonsStarting);
    //_selectedReviewLessonStarting.id = 0; // = _dropdownMenuItemsLessonStarting[0].value;

    //_dropdownMenuItemsLessonEnding = buildDropdownMenuItemsLesson(_reviewLessonsEnding);
    //_selectedReviewLessonEnding.id = 0; // = _dropdownMenuItemsLessonEnding[0].value;

    super.initState();
  }

  List<DropdownMenuItem<ReviewLevel>> buildDropdownMenuItemsLevel(List reviewLevels) {
    List<DropdownMenuItem<ReviewLevel>> items = List();
    for (ReviewLevel reviewLevel in reviewLevels) {
      items.add(
        DropdownMenuItem(
          value: reviewLevel,
          child: Text(reviewLevel.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<ReviewLesson>> buildDropdownMenuItemsLesson(List reviewLessons) {
    List<DropdownMenuItem<ReviewLesson>> items = List();
    for (ReviewLesson reviewLesson in reviewLessons) {
      items.add(
        DropdownMenuItem(
          value: reviewLesson,
          child: Text(reviewLesson.name),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Review selection"),
      ),
      body: Center
        (
        child: getReviewSelection(context),
      ),
    );
  }

  onChangeDropdownItemLevelStarting(ReviewLevel selectedReviewLevel) {
    setState(() {
      _selectedReviewLevelStarting = selectedReviewLevel;
    });

    _reviewLevelsEnding = ReviewLevel.getReviewLevelsEnding(_selectedReviewLevelStarting.id);
    _dropdownMenuItemsLevelEnding = buildDropdownMenuItemsLevel(_reviewLevelsEnding);

    if (_selectedReviewLevelStarting.id == _selectedReviewLevelEnding.id) {
      setInitLessons();
    }
  }

  onChangeDropdownItemLevelEnding(ReviewLevel selectedReviewLevel) {
    setState(() {
      _selectedReviewLevelEnding = selectedReviewLevel;
    });

    _reviewLevelsStarting = ReviewLevel.getReviewLevelsStarting(_selectedReviewLevelEnding.id);
    _dropdownMenuItemsLevelStarting = buildDropdownMenuItemsLevel(_reviewLevelsStarting);

    if (_selectedReviewLevelStarting.id == _selectedReviewLevelEnding.id) {
      setInitLessons();
    }
  }

  setInitLessons() {
    _reviewLessonsStarting = ReviewLesson.getReviewLessonsStarting(_selectedReviewLevelStarting.id, 0);
    _dropdownMenuItemsLessonStarting = buildDropdownMenuItemsLesson(_reviewLessonsStarting);
    if (_dropdownMenuItemsLessonStarting != null && _dropdownMenuItemsLessonStarting.length > 0) {
      _selectedReviewLessonStarting = _dropdownMenuItemsLessonStarting[0].value;
    }

    _reviewLessonsEnding = ReviewLesson.getReviewLessonsEnding(_selectedReviewLevelStarting.id, 0);
    _dropdownMenuItemsLessonEnding = buildDropdownMenuItemsLesson(_reviewLessonsEnding);
    if (_dropdownMenuItemsLessonEnding != null && _dropdownMenuItemsLessonEnding.length > 0) {
      _selectedReviewLessonEnding = _dropdownMenuItemsLessonEnding[0].value;
    }
  }

  onChangeDropdownItemLessonStarting(ReviewLesson selectedReviewLesson) {
    setState(() {
      _selectedReviewLessonStarting = selectedReviewLesson;
    });

    _reviewLessonsEnding = ReviewLesson.getReviewLessonsEnding(_selectedReviewLevelStarting.id, _selectedReviewLessonStarting.id);
    _dropdownMenuItemsLessonEnding = buildDropdownMenuItemsLesson(_reviewLessonsEnding);
  }

  onChangeDropdownItemLessonEnding(ReviewLesson selectedReviewLesson) {
    setState(() {
      _selectedReviewLessonEnding = selectedReviewLesson;
    });

    // levelStarting and levelEnding are same when lesson dropdown is showing
    _reviewLessonsStarting = ReviewLesson.getReviewLessonsStarting(_selectedReviewLevelStarting.id, _selectedReviewLessonEnding.id);
    _dropdownMenuItemsLessonStarting = buildDropdownMenuItemsLesson(_reviewLessonsStarting);
  }

  Widget getReviewSelection(BuildContext context) {
    return Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(30),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(width: 10),
                getStartingLevel(context),
                SizedBox(width: 10),
                Text('to'),
                SizedBox(width: 10),
                getEndingLevel(context),
                SizedBox(width: 10),
              ],
            ),
          ),
          SizedBox(height: 40),
          getLessonRange(context),
          SizedBox(height: 40),
          Container(
            child: getStartReview(context), //OpenHelper.getImageButton(context, lessonId, "assets/quiz.png", LessonSection.Quiz),
            padding: EdgeInsets.all(20),
          ),
        ]
    );
  }

  Widget getStartingLevel(BuildContext context) {
    return DropdownButton(
      value: _selectedReviewLevelStarting,
      items: _dropdownMenuItemsLevelStarting,
      onChanged: onChangeDropdownItemLevelStarting,
    );
  }

  Widget getEndingLevel(BuildContext context) {
    return DropdownButton(
      value: _selectedReviewLevelEnding,
      items: _dropdownMenuItemsLevelEnding,
      onChanged: onChangeDropdownItemLevelEnding,
    );
  }

  Widget getLessonRange(BuildContext context) {
    if (_selectedReviewLevelStarting.id != 0 && _selectedReviewLevelEnding.id != 0 && _selectedReviewLevelStarting.id == _selectedReviewLevelEnding.id ) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(width: 10),
            getStartingLesson(context),
            SizedBox(width: 10),
            Text('to'),
            SizedBox(width: 10),
            getEndingLesson(context),
            SizedBox(width: 10),
          ],
        ),
      );
    }

    return Text('');
  }

  Widget getStartingLesson(BuildContext context) {
    return DropdownButton(
      value: _selectedReviewLessonStarting,
      items: _dropdownMenuItemsLessonStarting,
      onChanged: onChangeDropdownItemLessonStarting,
    );
  }

  Widget getEndingLesson(BuildContext context) {
    return DropdownButton(
      value: _selectedReviewLessonEnding,
      items: _dropdownMenuItemsLessonEnding,
      onChanged: onChangeDropdownItemLessonEnding,
    );
  }

  Widget getStartReview(BuildContext context) {
    return Container(
      child: FlatButton(
        child: Text("Start", style: TextStyle(fontSize: 30.0),),
        color: Colors.blueAccent,
        textColor: Colors.white,
        onPressed: () {
          var startLessonId = 0;
          var endLessonId = 0;
          if (_selectedReviewLessonStarting != null && _selectedReviewLessonStarting.id != null) {
            startLessonId = _selectedReviewLessonStarting.id;
          }
          if (_selectedReviewLessonEnding != null && _selectedReviewLessonEnding.id != null) {
            endLessonId = _selectedReviewLessonEnding.id;
          }
          var startInternalLessonId = LevelManager.getStartInternalLessonId(_selectedReviewLevelStarting.id, _selectedReviewLevelEnding.id, startLessonId, endLessonId);
          var endInternalLessonId = LevelManager.getEndInternalLessonId(_selectedReviewLevelStarting.id, _selectedReviewLevelEnding.id, startLessonId, endLessonId);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewPage(startLessonId: startInternalLessonId, endLessonId: endInternalLessonId),
            ),
          );
        },
      ),
    );
  }
}