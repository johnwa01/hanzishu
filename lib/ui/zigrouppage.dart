import 'package:flutter/material.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/data/zigrouplist.dart';
import 'package:hanzishu/engine/zigroup.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';

class ZiGroupPage extends StatefulWidget {
  final int ziId;
  ZiGroupPage({required this.ziId});

  @override
  _ZiGroupPageState createState() => _ZiGroupPageState();
}

class _ZiGroupPageState extends State<ZiGroupPage> {
  @override
  Widget build(BuildContext context) {
    var ziId = widget.ziId;

    return Scaffold(
      appBar: AppBar(
        title: Text(getString(418) /*"Phrase"*/),
        centerTitle: true,
      ),
      body: getZiGroupListView(context, ziId),
    );
  }

  Widget getZiGroupListView(BuildContext context, int ziId) {
    var zi = DictionaryManager.getSearchingZi(ziId);
    var phrases = ZiGroup.getRelatedPhrases(zi.char);

    if (phrases.isEmpty) {
      return Center(
        child: Text(
          getString(419) /*"No phrases"*/,
          style: TextStyle(
            color: Colors.lightBlue,
            fontSize: 18.0,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxContentWidth = constraints.maxWidth < 900.0
            ? constraints.maxWidth
            : 900.0;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 92.0,
                    height: 92.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.08),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blueAccent.withOpacity(0.16),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      zi.char,
                      style: const TextStyle(
                        fontSize: 48.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  Text(
                    "${phrases.length} " + getString(418), //Phrases,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.blueGrey.shade700,
                    ),
                  ),

                  const SizedBox(height: 26.0),

                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12.0,
                    runSpacing: 12.0,
                    children: <Widget>[
                      for (var phrase in phrases)
                        _buildPhraseChip(phrase),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhraseChip(String phrase) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 11.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(
          color: Colors.blueAccent.withOpacity(0.18),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        phrase,
        textDirection: TextDirection.ltr,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1F2937),
        ),
      ),
    );
  }
}
