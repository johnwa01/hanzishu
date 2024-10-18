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
    /*
    for (int i = 0; i < thePhraseList.length; i++) {
      if (phrase == thePhraseList[i].chars) {
        return i;
      }
    }
    */
    var onePhrase = getPhraseByName(phrase);
    if (onePhrase != null) {
      return onePhrase.id;
    }

    return -1;
  }

  static Phrase? getPhraseByName(String phrase) {
    for (int i = 0; i < thePhraseList.length; i++) {
      if (phrase == thePhraseList[i].chars) {
        return thePhraseList[i];
      }
    }
  }

  static Phrase? getSpecialPhraseByName(String phrase) {
    for (int j = 0; j < theSpecialPhraseList.length; j++) {
      if (phrase == theSpecialPhraseList[j].chars) {
        return theSpecialPhraseList[j];
      }
    }

    return null;
  }

  // used in sentence with breakers. treat those special phrases as phrases in sentence, but not in the char list.
  static Phrase? getPhraseIncludingSpecial(String phrase) {
    /*
    for (int i = 0; i < thePhraseList.length; i++) {
      if (phrase == thePhraseList[i].chars) {
        return thePhraseList[i];
      }
    }

    for (int j = 0; j < theSpecialPhraseList.length; j++) {
      if (phrase == theSpecialPhraseList[j].chars) {
        return theSpecialPhraseList[j];
      }
    }
    */
    var onePhrase = getPhraseByName(phrase);
    if (onePhrase != null) {
      return onePhrase;
    }

    return getSpecialPhraseByName(phrase);
  }
}