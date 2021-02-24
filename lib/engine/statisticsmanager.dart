import 'package:hanzishu/engine/storagehandler.dart';
import 'package:hanzishu/engine/levelmanager.dart';
import 'package:hanzishu/variables.dart';
import 'package:intl/intl.dart';
//import 'package:intl/date_symbol_data_local.dart'; // for other locales

var MaximumValidPeriod = 120.0;

class StatisticsManager {
  int tapCount;
  double studyTime;
  //QuizResult quizResult;   //no longer used?
  //var currentQuizResult: QuizResult  // no longer used? use lessonQuizResult
  int previousFinishTime;
  String previousDateString;
  LessonQuizResult lessonQuizResult;

  init(int tapCount,
    double studyTime,
    //quizResult: QuizResult = QuizResult(cor: 0, answ: 0),
    //currentQuizResult: QuizResult = QuizResult(cor: 0, answ: 0),
    int previousFinishTime,
    String previousDateString,
    LessonQuizResult lessonQuizResult) {
      this.tapCount = tapCount;
      this.studyTime = studyTime;
      //self.quizResult = quizResult
      //self.currentQuizResult = currentQuizResult
      this.previousFinishTime = previousFinishTime;
      this.previousDateString = previousDateString;
      this.lessonQuizResult = lessonQuizResult;
    }

    /*
  incrementQuizResult(bool isAnswerCorrect) {
    quizResult.answ += 1
    currentQuizResult.answ += 1
    if (isAnswerCorrect) {
      quizResult.cor += 1
      currentQuizResult.cor += 1
    }
  }
  */

  incrementLessonQuizResult(bool isAnswerCorrect) {
    lessonQuizResult.answ += 1;
    if (isAnswerCorrect) {
      lessonQuizResult.cor += 1;
    }
  }

  LessonQuizResult getLessonQuizResult() {
    return lessonQuizResult;
  }

  incrementTapCount() {
    tapCount += 1;
  }

  initStatisticsValues() {
    studyTime = 0.0;
    tapCount = 0;
    //quizResult.cor = 0
    //quizResult.answ = 0
    // note: currentQuizResult is init through the > and < action
    // separate from the overall init
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

  //func initCurrentQuizResults() {
  //  currentQuizResult.cor = 0
  //  currentQuizResult.answ = 0
  //}

  static int currentTimeInSeconds() {
    var ms = (new DateTime.now()).millisecondsSinceEpoch;
    return (ms / 1000).round();
  }

  trackTimeAndTap() {
    // first increment tap count
    incrementTapCount();

    //var date = DateTime.now();

    var currentDateString = StatisticsManager.getCurrentDateString();
    if (previousDateString != null && previousDateString.length > 0 && currentDateString != previousDateString) {
      //save the previous date's data
      saveStatisticsToStorage(/*dateString: previousDateString*/);
      previousDateString = currentDateString;
    }
    else {
      var currentTime = currentTimeInSeconds(); //date.timeIntervalSinceReferenceDate;

      var diff = currentTime - previousFinishTime;

      if (diff < MaximumValidPeriod) {
        studyTime += diff;
      }

      // reset var
      previousFinishTime = currentTime;

      if (studyTime/*accumlatedStudyTimeBeforeSave*/ >= 60.0 && tapCount >= 10) {
        // Update only the statistics part of data
        saveStatisticsToStorage(/*dateString: currentDateString*/);  // actually same as previousDateString if it has a value
      }
    }
  }

  /*
  String getQuizResultString() {
    var statusString = "[ ";
    statusString += quizResult.cor.toString());
    statusString += " of ";
    statusString.append(String(quizResult.answ));
    statusString.append(" correct ]");

    return statusString;
  }
*/

  static String getCurrentDateString() {
    //return DateFormat.yMd().format(DateTime.now());
    var now = DateTime.now();
    //print(DateFormat().format(now)); // This will return date using the default locale
    return DateFormat('MM-dd-yyyy').format(now);
  }

  // temp statistics data to storage memory, but not write to physical file.
  dumpStatisticsToStorageMemory() {
    // note we never accumulate data over night, we always save to the storage the first time when we hit a new date.
    var dateString = previousDateString;
    if (dateString.length == 0) {
      dateString = StatisticsManager.getCurrentDateString();
    }

    var statistics = Statistics(); //dateString, studyTime, tapCount/*, quizResult: quizResult*/);
    statistics.init();
    statistics.dateString = dateString;
    statistics.studyTime = studyTime;
    statistics.tapCount = tapCount;

    //if (lessonQuizResult != null) {
    //  lessonQuizResult.dateString = dateString;
    //}
    theStorageHandler.addOrUpdateStatistics(statistics);
    //theStorageHandler.appendLessonQuizResult(lessonQuizResult: lessonQuizResult)

    // reset the counters
    initStatisticsValues();
  }

  // temp statistics data to storage memory, but not write to physical file.
  dumpLessonQuizToStorageMemory() {
    // note we never accumulate data over night, we always save to the storage the first time when we hit a new date.
    if (lessonQuizResult.answ > 0) {
      var dateString = previousDateString;
      if (dateString.length == 0) {
        dateString = StatisticsManager.getCurrentDateString();
      }

      lessonQuizResult.dateString = dateString;
      lessonQuizResult.lessonId = theCurrentLessonId; // theLessonManager.getLessonNumber(theCurrentLesson);
      theStorageHandler.appendLessonQuizResult(lessonQuizResult);

      // reset the counters - lessonQuiz will init whenever it's used
      initLessonQuizResults();
    }
  }

  // save statistics to storage. no update to lesson status
  saveStatisticsToStorage(/*dateString: String*/) {
    dumpStatisticsToStorageMemory();

    theStorageHandler.SaveToFile();
  }

  saveLessonQuizAndStatisticsToStorage() {
    dumpLessonQuizToStorageMemory();
    dumpStatisticsToStorageMemory();

    theStorageHandler.SaveToFile();
  }

  static String produceStudyTimeString(String timeString, double studyTime) {
    var resultString = timeString;
    resultString += "     ";

    var minu = studyTime / 60;

    resultString += minu.toStringAsFixed(1); //String(format:"%.1f", minu);
    resultString += " minutes";

    return resultString;
  }

  static String produceTapCountString(String timeString, int tapCount) {
    var resultString = timeString;
    resultString += "     ";

    resultString += tapCount.toString();
    resultString += " times";

    return resultString;
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

/*
  static String produceQuizResultString(String quizDate, QuizResult quizResult) {
    var quizResultString = quizDate;
    quizResultString.append("   ");
    quizResultString.append(String(quizResult.cor));
    quizResultString.append(" of ");
    quizResultString.append(String(quizResult.answ));
    quizResultString.append(" correct. ");
    var percentRate = StatisticsManager.percentRate(number1: quizResult.cor, number2: quizResult.answ);
    quizResultString.append(percentRate);
    quizResultString.append("%");

    return quizResultString;
  }
*/

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
