import 'package:hanzishu/engine/storagehandler.dart';
import 'package:hanzishu/engine/levelmanager.dart';
import 'package:hanzishu/variables.dart';
import 'package:intl/intl.dart';

var MaximumValidPeriod = 120.0;

class StatisticsManager {
  LessonQuizResult lessonQuizResult;

  init(LessonQuizResult lessonQuizResult) {
      this.lessonQuizResult = lessonQuizResult;
    }

  incrementLessonQuizResult(bool isAnswerCorrect) {
    lessonQuizResult.answ += 1;
    if (isAnswerCorrect) {
      lessonQuizResult.cor += 1;
    }
  }

  LessonQuizResult getLessonQuizResult() {
    return lessonQuizResult;
  }

  initLessonQuizResults() {
    if (lessonQuizResult == null) {
      lessonQuizResult = LessonQuizResult();
    }

    lessonQuizResult.cor = 0;
    lessonQuizResult.answ = 0;
    lessonQuizResult.lessonId = theCurrentLessonId;
    lessonQuizResult.dateString = getCurrentDateString();
  }

  static int currentTimeInSeconds() {
    var ms = (new DateTime.now()).millisecondsSinceEpoch;
    return (ms / 1000).round();
  }

  static String getCurrentDateString() {
    //return DateFormat.yMd().format(DateTime.now());
    var now = DateTime.now();
    //print(DateFormat().format(now)); // This will return date using the default locale
    return DateFormat('MM-dd-yyyy').format(now);
  }

  // temp statistics data to storage memory, but not write to physical file.
  //dumpStatisticsToStorageMemory() {
    // note we never accumulate data over night, we always save to the storage the first time when we hit a new date.

  //  var statistics = Statistics(); //dateString, studyTime, tapCount/*, quizResult: quizResult*/);
  //  statistics.init();

  //  theStorageHandler.addOrUpdateStatistics(statistics);
  //}

  // temp statistics data to storage memory, but not write to physical file.
  dumpLessonQuizToStorageMemory() {
    // note we never accumulate data over night, we always save to the storage the first time when we hit a new date.
    if (lessonQuizResult.answ > 0) {
      var dateString = StatisticsManager.getCurrentDateString();
      lessonQuizResult.dateString = dateString;
      lessonQuizResult.lessonId = theCurrentLessonId; // theLessonManager.getLessonNumber(theCurrentLesson);
      theStorageHandler.appendLessonQuizResult(lessonQuizResult);

      // reset the counters - lessonQuiz will init whenever it's used
      initLessonQuizResults();
    }
  }

  // save statistics to storage. no update to lesson status
  saveStatisticsToStorage(/*dateString: String*/) {
  //  dumpStatisticsToStorageMemory();

    theStorageHandler.SaveToFile();
  }

  saveLessonQuizAndStatisticsToStorage() {
    dumpLessonQuizToStorageMemory();
   // dumpStatisticsToStorageMemory();

    theStorageHandler.SaveToFile();
  }

  static double percentRateFloat(int number1, int number2) {
    var rate = 0.0;
    if (number2 != 0) {
      rate = number1 * 100.0 / number2;
    }

    return rate;
  }

  static String percentRateFixed(double rate) {
    //return String(format:"%.1f", rate);
    return rate.toStringAsFixed(1);
  }

  static String percentRate(int number1, int number2) {
    var rate = 0.0;
    if (number2 != 0) {
      rate = number1 * 100 / number2;
    }
    //return String(format:"%.1f", rate);
    return rate.toStringAsFixed(1);
  }

  static String produceQuizResultString(LessonQuizResult lessonQuizResult) {
    if (lessonQuizResult == null || lessonQuizResult.dateString == null || lessonQuizResult.lessonId == null || lessonQuizResult.cor == null || lessonQuizResult.answ == null) {
      return '';
    }

    var quizResultString = lessonQuizResult.dateString;
    quizResultString += "   ";

    var levelLessonPair = LevelManager.getLevelLessonPair(lessonQuizResult.lessonId);
    quizResultString += "L";
    quizResultString += levelLessonPair.levelId.toString();
    quizResultString += "/L";
    quizResultString += levelLessonPair.lessonId.toString();
    quizResultString +=  ". ";

    quizResultString += lessonQuizResult.cor.toString();
    quizResultString += " of ";
    quizResultString += lessonQuizResult.answ.toString();
    quizResultString += " correct. ";
    quizResultString += StatisticsManager.percentRate(lessonQuizResult.cor, lessonQuizResult.answ);
    quizResultString += "%";

    return quizResultString;
  }
}
