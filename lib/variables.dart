import 'package:hanzishu/utility.dart';
import 'dart:io';

//TODO: create theManagers
var theLessonManager = null;
var theZiManager = null;
var thePhraseManager = null;
var theSentenceManager = null;
var theLevelManager = null;
var thePositionManager = null;
var theStorageHandler = null;
var theQuizManager = null;
var theStatisticsManager = null;
var theInputZiManager = null;
var theComponentManager = null;
var theStrokeManager = null;
var theDictionaryManager = null;

var theCurrentZiComponents = [0, 0, 0, 0, 0, 0, 0, 0];
var theTotalBeginnerLessons = 60; //TODO: to lessonmanager?
var theNumberOfLessonsInLevels = [9, 7, 5, 5, 7, 5, 5, 6, 4, 7];
//var theHittestState = HittestState.hanzishuFullZiMode;

var theRangeUptoLessonNumberForCurrentLevel = 1;
var theRangeFromLessonNumberForCurrentLevel = 1;

//TODO: create theRuntimeStates
var theCurrentLevel = 1;
// NOTE: Use theCurrentLessonId whenever possible
//var theCurrentLesson = "None";  // to be removed
var theCurrentLessonId = 1;
var theCurrentCenterZiId = 1;
var thePreviousCenterZiId = 0;

var theLessonsPage = null;

//TODO: move to theConfig
var theIsPartialZiMode = true;

Directory theStorageFileDirectory = null;

var theFileIOFile;

// for removing of dictionary's overlay
var theDicOverlayEntry;

bool theHavePopulatedLessonsInfo = false;
//double theDrawingSizeRatio;

class theConst {
  static var starCharId = 756;
  static var starChar = '*';
  static var atCharId = 1;
  static var atChar = '@';
}

class theConfig {  // can change by runtime
  static bool withSoundAndExplains = true;
}

List<String> theDefaultZiCandidates = ['的', '人', '大', '一', '十', '力', '他'];
//List<String> theDefaultZiCandidates = ['的', '人', '大', '一', '十', '力'];
//seems hard to pass the value from page to painter
List<String> theCurrentZiCandidates = theDefaultZiCandidates;
String globalTestDoubleByteCode = "";
