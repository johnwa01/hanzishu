import 'package:hanzishu/data/searchingzilist.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/engine/dictionary.dart';
import 'package:hanzishu/engine/zi.dart';
//import 'package:hanzishu/engine/componentmanager.dart';

class DictionaryManager {
  static String getChar(int id) {
    return theSearchingZiList[id].char;
  }

  static SearchingZi getSearchingZi(int id) {
    return theSearchingZiList[id];
  }

  static String getPinyinAndMeaning(int id) {
    var searchingZi = getSearchingZi(id);
    return Zi.formatPinyinAndMeaning(searchingZi.pinyin, searchingZi.meaning);
  }

  List<IdAndListTypePair> getComposits(int id) {
    var zi = theSearchingZiList[id];

    // Check whether it's single or combined word
    if (zi.composit.length == 1)
    {
      return null;
    }

    var composits = new List<IdAndListTypePair>();
    var oneItem;
    for (int i = 0; i < zi.composit.length; i++) {
      oneItem = zi.composit[i];
      if (oneItem.codeUnitAt(0) >= '0'.codeUnitAt(0) && oneItem.codeUnitAt(0) <= '9'.codeUnitAt(0))
      {
        var val = Utility.StringToInt(oneItem);
        var pair = IdAndListTypePair(val, ZiListType.searching);
        composits.add(pair);
      }
      else {
        var compId = theComponentManager.getComponentIdByCode(oneItem);
        var pair = IdAndListTypePair(compId, ZiListType.component);
        composits.add(pair);
      }
    }

    return composits;
  }
}