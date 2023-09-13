import 'package:flutter/material.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/data/zigrouplist.dart';
import 'package:hanzishu/engine/zigroup.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';

class ZiGroupPage extends StatefulWidget {
  final int ziId;
  ZiGroupPage({this.ziId});

  @override
  _ZiGroupPageState createState() => _ZiGroupPageState();
}

class _ZiGroupPageState extends State<ZiGroupPage> {
  @override
  Widget build(BuildContext context) {
    var ziId = widget.ziId;

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(getString(418)/*"Phrase"*/),
      ),
      body: Center
        (
        child: getZiGroupListView(context, ziId),
      ),
    );
  }

  Widget getZiGroupListView(BuildContext context, int ziId) {
    var zi = DictionaryManager.getSearchingZi(ziId);
    var phrases = ZiGroup.getRelatedPhrases(zi.char);

    if (phrases.isEmpty) {
      return  Text(getString(419)/*"No phrases"*/, style: TextStyle(color: Colors.lightBlue));
    }

    return ListView(
      children: <Widget>[
          for (var phrase in phrases)
            ListTile(title: Text(phrase, textDirection: TextDirection.ltr))
      ],
    );
  }
}