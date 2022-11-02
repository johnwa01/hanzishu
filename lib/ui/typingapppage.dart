import 'package:flutter/material.dart';
import 'package:hanzishu/utility.dart';

class TypingAppPage extends StatefulWidget {
  @override
  _TypingAppPageState createState() => _TypingAppPageState();
}

class _TypingAppPageState extends State<TypingAppPage> {
  double screenWidth;

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(getString(379)/*"General purpose typing app"*/),
      ),
      body: Center
        (
        child: getTypingAppText(context),
      ),
    );
  }

  Widget getTypingAppText(BuildContext context) {
    screenWidth = Utility.getScreenWidth(context);

    double fontSize = 14.0 * getSizeRatioWithLimit();

    return Column(
      //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          Text(
              getString(380)/*"available on Windows and Mac computers"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize),
          Text(
              getString(381)/*"Phone version close to complete"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize),
              textAlign: TextAlign.start
          ),
          //SizedBox(height: fontSize),
          Text(
              getString(382)/*"At the same time..."*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize),
              textAlign: TextAlign.start
          ),
        ]
    );
  }
}