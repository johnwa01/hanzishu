import 'package:flutter/material.dart';

class TreePage extends StatefulWidget {
  @override
  _TreePageState createState() => _TreePageState();
}

class _TreePageState extends State<TreePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Tree Page"),
      ),
      body: Center
        (
        child: Text("This is Tree Page."),
      ),
    );
  }
}