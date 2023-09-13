import 'package:flutter/material.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/ui/inputzipage.dart';
import 'package:hanzishu/data/componenttypinglist.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/variables.dart';


class ComponentExerciseNumber {
  int id;
  String name;
  static int totalExercises = 25; // roughly 4 to 30 chars a exercises.

  ComponentExerciseNumber(this.id, this.name);

  static List<ComponentExerciseNumber> exerciseNumbers = List<ComponentExerciseNumber>(totalExercises);

  static populateInitialNumbers() {
    //if (exerciseNumbers[0] == null) {
      var onePair;
      var descriptionString;
      var stringAndCharsPair;
      for (var index = 0; index <= totalExercises - 1; index++) {
        onePair = theComponentCategoryStringIdAndTypingCharsList[index];
        descriptionString = getString(onePair.stringId) + " （" + onePair.letter + ")";
        // Following is the index, not stringId -- different from ComponentCategoryStringIdAndTypingChars
        stringAndCharsPair = ComponentExerciseNumber(index, descriptionString);
        exerciseNumbers[index] = stringAndCharsPair;
      }
    //}
  }

  // note: selected ReveiwNumber instance has to be the same one as in the list.
  // therefore can't create a new one everytime. Otherwise it'll fail with assert.
  static List<ComponentExerciseNumber> getComponentExerciseNumbers() {
    populateInitialNumbers();
    return exerciseNumbers;
  }
}

class TypingComponentSelectionPage extends StatefulWidget {
  @override
  _TypingSelectionPageState createState() => _TypingSelectionPageState();
}

class _TypingSelectionPageState extends State<TypingComponentSelectionPage> {
  double screenWidth;
  //List<ComponentExerciseNumber> _exerciseNumbers; // = ComponentExerciseNumber.getComponentExerciseNumbers();
  List<DropdownMenuItem<ComponentExerciseNumber>> _dropdownMenuItemsNumber;
  ComponentExerciseNumber _selectedComponentExerciseNumber;

  @override
  void initState() {
    //_dropdownMenuItemsNumber = buildDropdownMenuItemsNumber(_exerciseNumbers);
    //_selectedComponentExerciseNumber = _dropdownMenuItemsNumber[0].value;

    super.initState();
  }

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }

  List<DropdownMenuItem<ComponentExerciseNumber>> buildDropdownMenuItemsNumber(/*List exerciseNumbers*/) {
    List exerciseNumbers = ComponentExerciseNumber.getComponentExerciseNumbers();

    List<DropdownMenuItem<ComponentExerciseNumber>> items = List();
    for (ComponentExerciseNumber exerciseNumber in exerciseNumbers) {
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
    //_selectedComponentExerciseNumber = _dropdownMenuItemsNumber[0].value;
    //_selectedComponentExerciseNumber.id = theSelectedComponentExerciseNumber;
    //_selectedComponentExerciseNumber.name = '1';
    screenWidth = Utility.getScreenWidth(context);

    // due to localization, has to do it every build instead of init
    _dropdownMenuItemsNumber = buildDropdownMenuItemsNumber(/*_exerciseNumbers*/);
    if (_selectedComponentExerciseNumber == null) {
      _selectedComponentExerciseNumber = _dropdownMenuItemsNumber[0].value;
    }
    else {
      // _select* has to map to one in the current _dropdown*
      _selectedComponentExerciseNumber = _dropdownMenuItemsNumber[_selectedComponentExerciseNumber.id].value;
    }

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(getString(288)/*"Exercise selection"*/),
      ),
      body: Center
        (
        child: getExerciseSelection(context),
      ),
    );
  }

  onChangeDropdownItemNumber(ComponentExerciseNumber selectedComponentExerciseNumber) {
    setState(() {
      _selectedComponentExerciseNumber = selectedComponentExerciseNumber;
    });
  }

  Widget getExerciseSelection(BuildContext context) {
    return Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(30 * getSizeRatioWithLimit()),
          ),
          Text(
              getString(414)/*"Practice typing of a few hundred Characters ..."*/,
              style: TextStyle(fontSize: 15 * getSizeRatioWithLimit()),
              textAlign: TextAlign.start
          ),
          Container(
            padding: EdgeInsets.all(30 * getSizeRatioWithLimit()),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(width: 10 * getSizeRatioWithLimit()),
                getNumber(context),
                SizedBox(width: 10 * getSizeRatioWithLimit()),
              ],
            ),
          ),
          SizedBox(height: 40 * getSizeRatioWithLimit()),
          Container(
            child: getStartExercise(context),
            padding: EdgeInsets.all(20 * getSizeRatioWithLimit()),
          ),
        ]
    );
  }

  Widget getNumber(BuildContext context) {
    return DropdownButton(
      value: _selectedComponentExerciseNumber,
      items: _dropdownMenuItemsNumber,
      onChanged: onChangeDropdownItemNumber,
    );
  }

  Widget getStartExercise(BuildContext context) {
    return Container(
      child: FlatButton(
        child: Text(getString(301)/*"Start"*/, style: TextStyle(fontSize: 28.0 * getSizeRatioWithLimit()),),
        color: Colors.blueAccent,
        textColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InputZiPage(typingType: TypingType.ComponentTyping, lessonId: _selectedComponentExerciseNumber.id),
            ),
          );
        },
      ),
    );
  }
}