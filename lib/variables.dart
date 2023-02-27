import 'dart:io';
//import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
//TODO: create theManagers
var theLessonManager;
var theZiManager;
var thePhraseManager;
var theSentenceManager;
var theLevelManager;
var thePositionManager;
var theStorageHandler;
var theQuizManager;
var theStatisticsManager;
var theInputZiManager;
var theComponentManager;
var theStrokeManager;
var theDictionaryManager;

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

//var theLessonsPage;
bool theHasNewlyCompletedLesson = false;
int theNewlyCompletedTypingExercise = -1;

var theDefaultLocale = "en_US";

//TODO: move to theConfig
var theIsPartialZiMode = true;

Directory theStorageFileDirectory;

var theFileIOFile;

// for removing of dictionary's overlay
var theDicOverlayEntry;

bool theHavePopulatedLessonsInfo = false;
//double theDrawingSizeRatio;

//int theTypingExerciseNumber = 1;

class TheConst {
  static var starCharId = 756;
  static var starChar = '*';
  static var atCharId = 1;
  static var atChar = '@';
  static List<double> fontSizes = [15.0, 14.0, 13.0]; //[13.0, 12.0, 11.0];
}

class TheConfig {  // can change by runtime
  static bool withSoundAndExplains = true;
}

List<String> theDefaultZiCandidates = ['的', '人', '大', '一', '十', '力', '他'];
//List<String> theDefaultZiCandidates = ['的', '人', '大', '一', '十', '力'];
//seems hard to pass the value from page to painter
List<String> theCurrentZiCandidates = theDefaultZiCandidates;
String globalTestDoubleByteCode = "";

GlobalKey globalKeyNav = new GlobalKey(debugLabel: 'btm_app_bar');

bool theIsBackArrowLessonExit = true;

bool theIsFromLessonContinuedSection = false;

bool theAllZiLearned = false;

//int theSelectedExerciseNumber = 1;
