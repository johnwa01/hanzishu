import 'package:hanzishu/data/settinglist.dart';
import 'package:hanzishu/engine/lessonmanager.dart';
import 'package:hanzishu/engine/settings.dart';
import 'package:flutter/material.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/variables.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late List<DropdownMenuItem<Language>> _dropdownMenuItems;
  late Language _selectedLanguage;

  static getSelectedLanguage() {
    for (var language in theLanguageList) {
      if (theDefaultLocale == language.name) {
        return language;
      }
    }

    return theLanguageList[0];
  }

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems();
    _selectedLanguage = getSelectedLanguage();

    super.initState();
  }

  List<DropdownMenuItem<Language>> buildDropdownMenuItems() {
    List<DropdownMenuItem<Language>> items = []; //List();
    for (var language in theLanguageList) {
      items.add(
        DropdownMenuItem(
          value: language,
          child: Text(language.description),
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
        title: Text(getString(302)/*"Language Setting"*/),
      ),
      body: Center
        (
        child: getSettingsSelection(context),
      ),
    );
  }

  onChangeDropdownItem(Language selectedLanguage) {
    setState(() {
      theDefaultLocale = selectedLanguage.name;
      _selectedLanguage = selectedLanguage;
    });
  }

  Widget getSettingsSelection(BuildContext context) {
    return Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(30),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(getString(303)/*'Explanation language:'*/),
                SizedBox(width: 10),
                getLanguageSelection(context),
                SizedBox(width: 10),
              ],
            ),
          ),
        ]
    );
  }

  Widget getLanguageSelection(BuildContext context) {
    return DropdownButton(
      value: _selectedLanguage,
      items: _dropdownMenuItems,
      onChanged: (selectedLanguage) {
        setState(() {
          _selectedLanguage = selectedLanguage as Language;
        });
      },
      //onChangeDropdownItem,
    );
  }
}