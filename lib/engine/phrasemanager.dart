import 'package:hanzishu/engine/phrase.dart';
import 'package:hanzishu/data/phraselist.dart';

class PhraseManager {
  static final PhraseManager _phraseManager = PhraseManager._internal();
  factory PhraseManager() {
    return _phraseManager;
  }

  PhraseManager._internal();

  Phrase getPhrase(int id) {
    return thePhraseList[id];
  }

  int getPhraseCount() {
    return thePhraseList.length;
  }
}