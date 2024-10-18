import 'package:flutter/material.dart';
import 'package:hanzishu/utility.dart';

class PrivacyPolicyPage extends StatefulWidget {
  @override
  _PrivacyPolicyPageState createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  late double screenWidth;

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(getString(141)/*"Privacy policy"*/),
      ),
      body: Center
        (
        child: getPrivacyPolicyText(context),
      ),
    );
  }

  Widget getPrivacyPolicyText(BuildContext context) {
    screenWidth = Utility.getScreenWidth(context);

    double fontSize1 = 14.0 * getSizeRatioWithLimit();
    double fontSize2 = 13.0 * getSizeRatioWithLimit();
    double fontSize3 = 12.0 * getSizeRatioWithLimit(); // base size 12

    return Column(
      //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          Text(
           getString(141)/*"Privacy policy"*/,
            style: TextStyle(color: Colors.blue, fontSize: fontSize1/*, fontWeight: FontWeight.bold*/),
            textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              getString(297)/*"Hanzishu App doesn't collect sensitive user specific data."*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          SizedBox(height: fontSize3),
          Text(
              "john@hanzishu.com",
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "P. O. Box 6502",
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "Bellevue, WA 98008",
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
          Text(
              "U.S.A.",
              style: TextStyle(fontSize: fontSize2),
              textAlign: TextAlign.start
          ),
        ]
    );
  }
}