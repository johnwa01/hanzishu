import 'package:flutter/material.dart';
import 'package:hanzishu/ui/reviewpage.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/data/levellist.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/ui/inputzipage.dart';
import 'package:hanzishu/engine/levelmanager.dart';

class ReviewLevel {
  int id;
  String name;
  static int totalExercises = 38; // roughly 98 chars a exercises.

  ReviewLevel(this.id, this.name);

  static List<ReviewLevel> startingLevels = List<ReviewLevel>(totalExercises);

  static populateInitialLevels() {
    if (startingLevels[0] == null) {
      for (var index = 0; index <= totalExercises - 1; index++) {
        var level = ReviewLevel(index + 1, (index + 1).toString());
        startingLevels[index] = level;
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
}

class TpyingSelectionPage extends StatefulWidget {
  @override
  _TypingSelectionPageState createState() => _TypingSelectionPageState();
}

class _TypingSelectionPageState extends State<TpyingSelectionPage> {
  List<ReviewLevel> _reviewLevelsStarting = ReviewLevel.getReviewLevelsStarting(0);
  List<DropdownMenuItem<ReviewLevel>> _dropdownMenuItemsLevelStarting;
  ReviewLevel _selectedReviewLevelStarting;

  @override
  void initState() {
    _dropdownMenuItemsLevelStarting = buildDropdownMenuItemsLevel(_reviewLevelsStarting);
    _selectedReviewLevelStarting = _dropdownMenuItemsLevelStarting[0].value;

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
              ],
            ),
          ),
          SizedBox(height: 40),
          Container(
            child: getStartReview(context),
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

  Widget getStartReview(BuildContext context) {
    return Container(
      child: FlatButton(
        child: Text("Start", style: TextStyle(fontSize: 30.0),),
        color: Colors.blueAccent,
        textColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InputZiPage(typingType: TypingType.CustomizedTyping, lessonId: 1), // TODO: hardcoded
            ),
          );
        },
      ),
    );
  }
}