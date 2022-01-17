import 'package:hanzishu/data/searchingzilist.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/engine/dictionary.dart';
import 'package:hanzishu/engine/component.dart';
import 'package:hanzishu/engine/componentmanager.dart';
import 'package:hanzishu/engine/zi.dart';
import 'package:hanzishu/engine/strokemanager.dart';
import 'package:hanzishu/data/componentlist.dart';

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

  static List<double> getSingleComponentSearchingZiStrokes(int id) {
    // for zi with single component only
    var zi = theSearchingZiList[id];

    // Check whether it's single component char or multiple component char
    if (zi.composit.length == 1) {
      var code = zi.composit[0];
      var compId = ComponentManager.getComponentIdByCode(code);
      return theComponentList[compId].strokes;
    }

    return null;
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
        var compId = ComponentManager.getComponentIdByCode(oneItem);
        var pair = IdAndListTypePair(compId, ZiListType.component);
        composits.add(pair);
      }
    }

    return composits;
  }

  static bool isCompoundZi(int id) {
    var zi = theSearchingZiList[id];

    // Check whether it's single or combined word
    if (zi.composit.length >= 2)
    {
      return true;
    }

    return false;
  }

  static getComponentIdsFromCodes(List<String>codes, List<int>ids) {
    var code;
    var id;
    for (int i = 0; i < codes.length; i++) {
      code = codes[i];
      id = ComponentManager.getComponentIdByCode(code);
      ids.add(id);
    }
  }

  // iterate function to get all the basic components
  static getAllComponents(int ziId, List<String> components) {
    var zi = theSearchingZiList[ziId];

    // Check whether it's single component char or multiple component char
    if (zi.composit.length == 1)
    {
      components.add(zi.composit[0]);
      return;
    }

    var oneItem;
    var subId;
    for (int i = 0; i < zi.composit.length; i++) {
      oneItem = zi.composit[i];
      if (oneItem.codeUnitAt(0) >= '0'.codeUnitAt(0) && oneItem.codeUnitAt(0) <= '9'.codeUnitAt(0))
      {
        subId = Utility.StringToInt(oneItem);
        getAllComponents(subId, components);
      }
      else {
        components.add(oneItem);
      }
    }
  }

  static String getTypingCode(int searchingZiId) {
    List<String> componentCodes = List<String>();
    getAllComponents(searchingZiId, componentCodes);
    var count = componentCodes.length;
    String typingCode = "";
    Component oneComp;
    String strokes;
    int strokeLength;

    for (int i = 0; i < count; i++) {
      oneComp = ComponentManager.getComponentByCode(componentCodes[i]);
      typingCode += oneComp.typingCode.substring(0, 1).toLowerCase();
    }

    if (count == 1) {
      oneComp = ComponentManager.getComponentByCode(componentCodes[0]);
      strokes = oneComp.strokesString;
      strokeLength = strokes.length;

      if (strokeLength >= 1) {
        typingCode += StrokeManager.getStrokeByCode(strokes[0]).typingCode;
      }

      if (strokeLength >= 2) {
          typingCode += StrokeManager.getStrokeByCode(strokes[1]).typingCode;
      }

      if (strokeLength >= 3) {
        typingCode += StrokeManager.getStrokeByCode(strokes[strokeLength - 1]).typingCode;
      }
    }

    if (count == 2) {
      oneComp = ComponentManager.getComponentByCode(componentCodes[0]);
      strokes = oneComp.strokesString;
      typingCode += StrokeManager.getStrokeByCode(strokes[strokes.length - 1]).typingCode;

      oneComp = ComponentManager.getComponentByCode(componentCodes[1]);
      strokes = oneComp.strokesString;
      typingCode += StrokeManager.getStrokeByCode(strokes[strokes.length - 1]).typingCode;
    }

    return typingCode;
  }
}