import 'package:hanzishu/data/searchingzilist.dart';
import 'package:hanzishu/engine/zimanager.dart';
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

  static int getSearchingZiId(String char) {
    for (int i = 0; i < theSearchingZiList.length; i++) {
      if (theSearchingZiList[i].char == char) {
        return i;
      }
    }

    return -1;
  }

  static bool isSingleCompZi(int searchingZiId) {
    var searchingZi = getSearchingZi(searchingZiId);
    return searchingZi.isSingleComponentZi();
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

  static bool isNonCharacter(int searchingZiId) {
    // in theSearchingZiList
    return searchingZiId == 0 || searchingZiId == 69 || searchingZiId == 77 || searchingZiId == 160;
  }

  static bool isEmpty(int searchingZiId) {
    // in theSearchingZiList
    return theSearchingZiList[searchingZiId].char.isEmpty;
  }

  // iterate function to get all the basic components
  static getAllComponents(int searchingZiId, List<String> components) {
    var zi = theSearchingZiList[searchingZiId];

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

  static List<String> getAllLeadComponents(List<String> components) {
    List<String> leadComponents = List<String>();
    String code;

    for (int i = 0; i < components.length; i++) {
      code = components[i];
      var compIndex = ComponentManager.getComponentIdByCode(code);
      var typingCompCode = theComponentList[compIndex].typingCode;
      if (typingCompCode[1] == 'a') {
        leadComponents.add(code);
      }
      else {
        var leadTypingCode = typingCompCode[0] + 'a';
        var leadComp = ComponentManager.getComponentByTypingCode(leadTypingCode);
        leadComponents.add(leadComp.doubleByteCode);
      }
    }

    return leadComponents;
  }

  static bool isSameComps(List<String> comps, List<String> leadComps) {
    for (int i = 0; i < leadComps.length; i++) {
      if (comps[i] != leadComps[i]) {
        return false;
      }
    }

    return true;
  }

  static bool isSameStrokes(String strokes, String leadStrokes) {
    for (int i = 0; i < leadStrokes.length; i++) {
      if (strokes[i] != leadStrokes[i]) {
        return false;
      }
    }

    return true;
  }

  // the components can be lead comp or regular comp here
  static String getAllComponentCodes(List<String> components) {
    String componentTypingCodes = "";
    Component oneComp;

    for (int i = 0; i < components.length; i++) {
      oneComp = ComponentManager.getComponentByCode(components[i]);
      componentTypingCodes += oneComp.typingCode.substring(0, 1).toLowerCase();
    }

    return componentTypingCodes;
  }

  /*
  static String getAllTypingStrokes(List<String> componentCodes) {
    var count = componentCodes.length;
    Component oneComp;
    String strokes;
    int strokeLength;
    String typingStrokes = "";

    if (count == 1) {
      oneComp = ComponentManager.getComponentByCode(componentCodes[0]);
      strokes = oneComp.strokesString;
      strokeLength = strokes.length;

      if (strokeLength >= 1) {
        typingStrokes += strokes[0];
      }

      if (strokeLength >= 2) {
        typingStrokes += strokes[1];
      }

      if (strokeLength >= 3) {
        typingStrokes += strokes[strokeLength - 1];
      }
    }

    if (count == 2) {
      oneComp = ComponentManager.getComponentByCode(componentCodes[0]);
      strokes = oneComp.strokesString;
      typingStrokes += strokes[strokes.length - 1];

      oneComp = ComponentManager.getComponentByCode(componentCodes[1]);
      strokes = oneComp.strokesString;
      typingStrokes += strokes[strokes.length - 1];
    }

    return typingStrokes;
  }
  */

  static String getSubComponentKeys(List<String> componentCodes) {
    var count = componentCodes.length;
    Component oneComp;
    String subComps;
    String subCompTypingString = "";

    if (count == 1 || count == 2) {
      oneComp = ComponentManager.getComponentByCode(componentCodes[count - 1]);
    }

    if (oneComp != null) {
      subComps = oneComp.subComponents;
    }

    if (subComps != null && subComps.length >= 2) {
      var firstCompStr = subComps.substring(0, 2);
      var firstComp = ComponentManager.getComponentByCode(firstCompStr);
      if (firstComp != null) {
        var typingCode = firstComp.typingCode;
        if (typingCode != null && typingCode.length > 1) {
          subCompTypingString = typingCode.substring(0,1);
        }
      }
    }

    if (subComps != null && subComps.length == 4) {
      var secondCompStr = subComps.substring(2, 4);
      var secondComp = ComponentManager.getComponentByCode(secondCompStr);
      if (secondComp != null) {
        var typingCode = secondComp.typingCode;
        if (typingCode != null && typingCode.length > 1) {
          subCompTypingString = subCompTypingString + typingCode.substring(0,1);
        }
      }
    }

    return subCompTypingString;
  }

  // used for hint only
  static String getLeadTypingStrokes(String typingStrokes) {
    String leadTypingStrokes = "";
    String typingCode;

    for (int j = 0; j < typingStrokes.length; j++) {
      typingCode = StrokeManager.getStrokeByCode(typingStrokes[j]).typingCode;
      if (typingCode == "g") {
        leadTypingStrokes += "a";   // the leadTypingStroke of the typingStrokes[j]
      }
      else if (typingCode == "y") {
        leadTypingStrokes += "c";
      }
      else if (typingCode == "t") {
        leadTypingStrokes += "e";
      }
      else if (typingCode == "h") {
        leadTypingStrokes += "f";
      }
      else if (typingCode == "b") {
        leadTypingStrokes += "V";
      }
    }

    return leadTypingStrokes;
  }

  /*
  // typingStrokes here could be lead strokes or regular strokes
  static String getStrokeTypingCodes(String typingStrokes) {
    String typingCodes = "";
    for (int j = 0; j < typingStrokes.length; j++) {
      typingCodes += StrokeManager.getStrokeByCode(typingStrokes[j]).typingCode;
    }

    return typingCodes;
  }
*/

  // used in typing hint
  static String getOneTypingCode(String componentTypingCodes, String subComponentTypingCode) {
    return (componentTypingCodes + subComponentTypingCode).toUpperCase();
  }

  static String getTypingCode(int searchingZiId) {
    List<String> components = List<String>();
    getAllComponents(searchingZiId, components);
    var compCodes = getAllComponentCodes(components);

    //var typingStrokes = getAllTypingStrokes(components);
    //var typingCode = getStrokeTypingCodes(typingStrokes);

    var typingCode = getSubComponentKeys(components);

    if (typingCode != null) {
      return getOneTypingCode(compCodes, typingCode);
    }
    else {
      return compCodes.toUpperCase();
    }
  }

  /*
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
  */
}