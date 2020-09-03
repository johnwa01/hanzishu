import 'package:flutter/material.dart';

class CharacterListPage extends StatefulWidget {
  final int lessonNumber;
  CharacterListPage({this.lessonNumber});

  @override
  _CharacterListPageState createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Character List Page"),
      ),
      body: Center
        (
        child: Text("This is Character List Page."),
      ),
    );
  }
}