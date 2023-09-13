import 'package:hanzishu/data/zigrouplist.dart';

class ZiGroup {
  static List<String> getRelatedPhrases(String zi) {
    List<String> phrases = [];
    for (var phrase in theZiGroupList) {
      if (phrase.contains(zi)) {
        phrases.add(phrase);
      }
    }

    return phrases;
  }
}