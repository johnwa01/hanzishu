import 'package:flutter/material.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/ui/inputzipage.dart';
import 'package:hanzishu/variables.dart';


class ExerciseNumber {
  int id;
  String name;
  static int totalExercises = 38; // roughly 98 chars a exercises.

  ExerciseNumber(this.id, this.name);

  static List<ExerciseNumber> exerciseNumbers = List<ExerciseNumber>(totalExercises);

  static populateInitialNumbers() {
    if (exerciseNumbers[0] == null) {
      for (var index = 0; index <= totalExercises - 1; index++) {
        var level = ExerciseNumber(index + 1, (index + 1).toString());
        exerciseNumbers[index] = level;
      }
    }
  }

  // note: selected ReveiwNumber instance has to be the same one as in the list.
  // therefore can't create a new one everytime. Otherwise it'll fail with assert.
  static List<ExerciseNumber> getExerciseNumbers() {
      populateInitialNumbers();
      return exerciseNumbers;
  }
}

class TpyingSelectionPage extends StatefulWidget {
  @override
  _TypingSelectionPageState createState() => _TypingSelectionPageState();
}

class _TypingSelectionPageState extends State<TpyingSelectionPage> {
  List<ExerciseNumber> _exerciseNumbers = ExerciseNumber.getExerciseNumbers();
  List<DropdownMenuItem<ExerciseNumber>> _dropdownMenuItemsNumber;
  ExerciseNumber _selectedExerciseNumber;

  @override
  void initState() {
    _dropdownMenuItemsNumber = buildDropdownMenuItemsNumber(_exerciseNumbers);
    _selectedExerciseNumber = _dropdownMenuItemsNumber[0].value;

    super.initState();
  }

  List<DropdownMenuItem<ExerciseNumber>> buildDropdownMenuItemsNumber(List exerciseNumbers) {
    List<DropdownMenuItem<ExerciseNumber>> items = List();
    for (ExerciseNumber exerciseNumber in exerciseNumbers) {
      items.add(
        DropdownMenuItem(
          value: exerciseNumber,
          child: Text(exerciseNumber.name),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    //_selectedExerciseNumber = _dropdownMenuItemsNumber[0].value;

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Exercise selection"),
      ),
      body: Center
        (
        child: getExerciseSelection(context),
      ),
    );
  }

  onChangeDropdownItemNumber(ExerciseNumber selectedExerciseNumber) {
    setState(() {
      _selectedExerciseNumber = selectedExerciseNumber;
    });
  }

  Widget getExerciseSelection(BuildContext context) {
    return Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(30),
          ),
          Text(
              "Practice typing 3,800 Characters in 38 exercises",
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.start
          ),
          Container(
            padding: EdgeInsets.all(30),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(width: 10),
                getNumber(context),
                SizedBox(width: 10),
              ],
            ),
          ),
          SizedBox(height: 40),
          Container(
            child: getStartExercise(context),
            padding: EdgeInsets.all(20),
          ),
        ]
    );
  }

  Widget getNumber(BuildContext context) {
    return DropdownButton(
      value: _selectedExerciseNumber,
      items: _dropdownMenuItemsNumber,
      onChanged: onChangeDropdownItemNumber,
    );
  }

  Widget getStartExercise(BuildContext context) {
    return Container(
      child: FlatButton(
        child: Text("Start", style: TextStyle(fontSize: 28.0),),
        color: Colors.blueAccent,
        textColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InputZiPage(typingType: TypingType.CustomizedTyping, lessonId: _selectedExerciseNumber.id), // TODO: hardcoded
            ),
          );
        },
      ),
    );
  }
}