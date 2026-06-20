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

  // not used
  onChangeDropdownItem(Language selectedLanguage) {
    setState(() {
      theDefaultLocale = selectedLanguage.name;
      _selectedLanguage = selectedLanguage;
    });
  }

  Widget getSettingsSelection(BuildContext context) {
    return Center(
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.language,
              size: 56,
              color: Colors.blue,
            ),
            SizedBox(height: 20),

            Text(
              getString(303), // Language in title
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 20),

            SizedBox(
              width: 220,
              child: getLanguageSelection(context),
            ),
          ],
        ),
      ),
    );
  }


  Widget getLanguageSelection(BuildContext context) {
    return DropdownButtonFormField<Language>(
      value: _selectedLanguage,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        contentPadding:
        EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      items: _dropdownMenuItems,
      onChanged: (selectedLanguage) {
        setState(() {
          _selectedLanguage = selectedLanguage!;
          theDefaultLocale = selectedLanguage.name;
        });
      },
    );
  }
}