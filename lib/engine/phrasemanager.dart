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

  static int getPhraseId(String phrase) {
    for (int i = 0; i < thePhraseList.length; i++) {
      if (phrase == thePhraseList[i].chars) {
        return i;
      }
    }

    return -1;
  }
}