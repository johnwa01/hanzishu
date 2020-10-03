import 'package:hanzishu/engine/sentence.dart';
import 'package:hanzishu/data/sentencelist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/engine/zi.dart';
import 'package:hanzishu/engine/lessonmanager.dart';

class SentenceManager {
  static final SentenceManager _sentenceManager = SentenceManager._internal();
  factory SentenceManager() {
    return _sentenceManager;
  }

  SentenceManager._internal();

  Sentence getSentence(int id) {
    return theSentenceList[id];
  }

  int getSentenceCount() {
    return theSentenceList.length;
  }

  void addToCollection(Zi zi, String subchars, List<int>comps) {
    if (zi.type == "h" || zi.type == "j") {
      addToSubchars(zi.char, subchars);
    }
    else if (zi.type == "b") {
      addToComponents(zi.id, comps);
    }
    else if (zi.type == "f")
    {
      if (zi.parentId != 0) {
        var parentZi = theZiManager.getZi(zi.parentId);

        if (parentZi.type == "h" || parentZi.type == "j")
        {
          addToSubchars(parentZi.char, subchars);
        }
        else if (parentZi.type == "b")
        {
          addToComponents(parentZi.id, comps);
        }
      }
    }
  }

  void addToSubchars(String char, String subchars)
  {
    if (!subchars.contains(char)) {
      subchars += char;
    }
  }

  void addToComponents(int compId, List<int>comps)
  {
    if (!comps.contains(compId)) {
      comps.add(compId);
    }
  }

  void populateSubcharsAndComponents() {
    var count = theSentenceList.length;
    if (count > 0) {
      for (var i= 1; i <= (count-1); i++) {
        pupluateSubcharsAndComponentsA(i);
      }
    }
  }

  void pupluateSubcharsAndComponentsA(int sentenceId) {
    var senten = theSentenceList[sentenceId];
    populateSubcharsAndComponentsB(senten.conv, senten.chars, senten.comps);
  }

  // use rune in this kind of situations
  void populateSubcharsAndComponentsB(String chars, String subchars, List<int> comps) {
    chars.runes.forEach((int char) {
      //for (var char in chars) {
      populateSubcharsAndComponentsC(char, subchars, comps);
    });
  }

  void populateSubcharsAndComponentsC(int /*was Character*/ char, String subchars, List<int> comps) {
    if (!LessonManager.specialChar(char))
    {
      var zi = theZiManager.getZiByChar(char);
      if (zi != null)
      {
        populateSubcharsAndComponentsD(0, 0, zi, subchars, comps);
      }
    }
  }

  void populateSubcharsAndComponentsD(int recurLevel, int indexInLevel, Zi zi, String subchars, List<int> comps) {
    theCurrentZiComponents[recurLevel] = theCurrentZiComponents[recurLevel] + 1;

    if (zi.type == "h")
    {
      var newRecurLevel = recurLevel + 1;
      var components = theZiManager.getZiComponents(zi.id);
      var count = components.length;
      // TODO: Only if it's two, right? If three, we won't treat them as sub-chars or sub-comps.
      if (count > 0) {
        for (var i = 0; i <= (count-1); i++) {
          var ziSub = theZiManager.getZi(components[i]);
          populateSubcharsAndComponentsD(newRecurLevel, i, ziSub, subchars, comps);
        }
      }
    }

    // in this case, the parent might not be a component of the zi, and we want to include it (and its parents)
    if (zi.type == "j" || zi.type == "b") {
      if (zi.parentId != 0 && zi.parentId != 1) {
        var parentRecurLevel = recurLevel + 1;
        var ziParent = theZiManager.getZi(zi.parentId);
        populateSubcharsAndComponentsD(parentRecurLevel, 0, ziParent, subchars, comps);
      }
    }

    //TODO: include root parents! They are not components, but will be required in the tree.
    // most of the root parents are included in the components, but not all

    if (recurLevel != 0) {
      // we only want subchars, not the top level char
      addToCollection(zi, subchars, comps);
    }
  }
}