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
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 700,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: getPrivacyPolicyText(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget getPrivacyPolicyText(BuildContext context) {
    screenWidth = Utility.getScreenWidth(context);

    double fontSize1 = 14.0 * getSizeRatioWithLimit();
    double fontSize2 = 13.0 * getSizeRatioWithLimit();
    double fontSize3 = 12.0 * getSizeRatioWithLimit(); // base size 12

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              getString(703), //"Privacy",
              style: TextStyle(
                color: Colors.blue,
                fontSize: fontSize1 + 4,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              getString(297),
              style: TextStyle(
                fontSize: fontSize2,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 24),

            Divider(),

            const SizedBox(height: 24),

            Text(
              getString(704), //"Contact Us",
              style: TextStyle(
                color: Colors.blue,
                fontSize: fontSize1 + 4,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              "john@hanzishu.com",
              style: TextStyle(fontSize: fontSize2),
            ),

            Text(
              "P. O. Box 6502",
              style: TextStyle(fontSize: fontSize2),
            ),

            Text(
              "Bellevue, WA 98008",
              style: TextStyle(fontSize: fontSize2),
            ),

            Text(
              "U.S.A.",
              style: TextStyle(fontSize: fontSize2),
            ),
          ],
        ),
      ),
    );
  }
}