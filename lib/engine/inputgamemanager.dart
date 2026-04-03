import 'package:hanzishu/data/countrylist.dart';
import 'package:hanzishu/engine/country.dart';
import 'package:hanzishu/data/inputgamelist.dart';
import 'package:hanzishu/engine/inputgame.dart';
import 'package:hanzishu/engine/school.dart';
import 'package:hanzishu/data/inputgameanswersheetlist.dart';
import 'package:hanzishu/engine/inputgameanswersheet.dart';
import 'package:hanzishu/data/inputgamequestionlist.dart';
import 'package:hanzishu/engine/inputgamequestion.dart';
import 'package:hanzishu/data/schoollist.dart';

class InputGameManager {
  int currentGameQuestionId = -1;
  bool isCurrentPinyinInput = true; // pictographic input

  init(int gameQuestionId, bool isPinyinInput) {
    currentGameQuestionId = gameQuestionId;
    isCurrentPinyinInput = isPinyinInput;
  }

  static Country getCountryById(int id) {
    for (int i = 0; i < theCountryList.length; i++) {
      if (theCountryList[i].id == id) {
        return theCountryList[i];
      }
    }

    return Country(-1, "", "", -1);
  }

  static Continent getContinentById(int id) {
    for (int i = 0; i < theContinentList.length; i++) {
      if (theContinentList[i].id == id) {
        return theContinentList[i];
      }
    }

    return Continent(-1, "", "");
  }

  static InputGame getInputGameById(int id) {
    for (int i = 0; i < theInputGameList.length; i++) {
      if (theInputGameList[i].id == id) {
        return theInputGameList[i];
      }
    }

    return InputGame(-1, -1, "", "", [], "");
  }

  static InputGameQuestion getInputGameQuestionById(int id) {
    for (int i = 0; i < theInputGameQuestionList.length; i++) {
      if (theInputGameQuestionList[i].id == id) {
        return theInputGameQuestionList[i];
      }
    }

    return InputGameQuestion(-1, "", "");
  }

  static InputGameAnswerSheet getInputGameAnswerSheetById(int id) {
    for (int i = 0; i < theInputGameAnswerSheetList.length; i++) {
      if (theInputGameAnswerSheetList[i].id == id) {
        return theInputGameAnswerSheetList[i];
      }
    }

    return InputGameAnswerSheet(-1, "", "");
  }

  static String getInputGameQuestionString(int inputGameId, int inputGameQuestionId, bool isSimplifiedCharacters) {
    var game = getInputGameById(inputGameId);
    var questionIds = game.inputGameQuestionIdList;

    if (isSimplifiedCharacters == true) {
      return theInputGameQuestionList[questionIds[inputGameQuestionId]].content;
    }
    else {
      return theInputGameQuestionList[questionIds[inputGameQuestionId]].contentTraditional;
    }

    /*
    var question;
    for (int i = 0; i < questionIds.length; i++) {
      question = getInputGameQuestionById(questionIds[i]);
      if (question.id == inputGameQuestionId) {
        return question.content;
      }
    }

    return "";
    */
  }

  static bool isInputGamePasscodeValid(String inputPasscode) {
    for (int i = 0; i < theSchoolList.length; i++) {
      if (theSchoolList[i].code == inputPasscode) {
        return true;
      }
    }
    return false;
  }

  static bool isInputGameQuestionListIndexValid(int gameid, int inputGameQuestionListIndex) {
    // the index is within the length of the question list for the game
    if (inputGameQuestionListIndex < theInputGameList[gameid].inputGameQuestionIdList.length) {
      return true;
    }
    else {
      return false;
    }
  }

  static bool isInputGameQuestionIdValid(int inputGameQuestionId) {
    for (int i = 0; i < theInputGameQuestionList.length; i++) {
      if (theInputGameQuestionList[i].id == inputGameQuestionId) {
        return true;
      }
    }

    return false;
  }

  // Format: "2023-10-25 14:30:00"
  bool isTimeLater(String timeString) {
    // 1. Get current local time
    DateTime now = DateTime.now();

    // 2. Parse the input string
    DateTime givenTime = DateTime.parse(timeString);

    // 3. Compare (returns true if givenTime is in the future)
    return givenTime.isAfter(now);
  }

  bool isValidDateTime(inputText, currentGameId) {
    School school = InputGameManager.getSchoolByCode(inputText);
    bool isLater = isTimeLater(school.datetime);
    bool isValidDateTime = true;
    if ((!isLater && (currentGameId == 1 || currentGameId == 2)) ||
        (isLater && (currentGameId == 3 || currentGameId == 4)))
    {
      isValidDateTime = false;
    }

    return isValidDateTime;
  }

  static School getSchoolByCode(String code) {
    for (int i = 0; i < theSchoolList.length; i++) {
      if (theSchoolList[i].code == code) {
        return theSchoolList[i];
      }
    }

    return School(-1, "", "", "", "2026-01-01 00:00:00", -1);
  }
}