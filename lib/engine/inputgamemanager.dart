import 'package:hanzishu/data/countrylist.dart';
import 'package:hanzishu/engine/country.dart';
import 'package:hanzishu/data/inputgamelist.dart';
import 'package:hanzishu/engine/inputgame.dart';
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

  Country getCountryById(int id) {
    for (int i = 0; i < theCountryList.length; i++) {
      if (theCountryList[i].id == id) {
        return theCountryList[i];
      }
    }

    return Country(-1, "", "", -1);
  }

  Continent getContinentById(int id) {
    for (int i = 0; i < theContinentList.length; i++) {
      if (theContinentList[i].id == id) {
        return theContinentList[i];
      }
    }

    return Continent(-1, "", "");
  }

  InputGame getInputGameById(int id) {
    for (int i = 0; i < theInputGameList.length; i++) {
      if (theInputGameList[i].id == id) {
        return theInputGameList[i];
      }
    }

    return InputGame(-1, "", "", []);
  }

  InputGameQuestion getInputGameQuestionById(int id) {
    for (int i = 0; i < theInputGameQuestionList.length; i++) {
      if (theInputGameQuestionList[i].id == id) {
        return theInputGameQuestionList[i];
      }
    }

    return InputGameQuestion(-1, "");
  }

  InputGameAnswerSheet getInputGameAnswerSheetById(int id) {
    for (int i = 0; i < theInputGameAnswerSheetList.length; i++) {
      if (theInputGameAnswerSheetList[i].id == id) {
        return theInputGameAnswerSheetList[i];
      }
    }

    return InputGameAnswerSheet(-1, "", "");
  }

  String getInputGameQuestionString(int inputGameId, inputGameQuestionId) {
    var game = getInputGameById(inputGameId);
    var questionIds = game.inputGameQuestionIdList;
    var question;
    for (int i = 0; i < questionIds.length; i++) {
      question = getInputGameQuestionById(questionIds[i]);
      if (question.id == inputGameQuestionId) {
        return question.content;
      }
    }

    return "";
  }

  static bool isInputGamePasscodeValid(String inputPasscode) {
    for (int i = 0; i < theSchoolList.length; i++) {
      if (theSchoolList[i].code == inputPasscode) {
        return true;
      }
    }
    return false;
  }

  static bool isInputGameQuestionIdValid(int inputGameQuestionId) {
    for (int i = 0; i < theInputGameQuestionList.length; i++) {
      if (theInputGameQuestionList[i].id == inputGameQuestionId) {
        return true;
      }
    }

    return false;
  }
}