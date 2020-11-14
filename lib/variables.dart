import 'package:hanzishu/utility.dart';
import 'dart:io';

var theLessonManager = null;
var theZiManager = null;
var thePhraseManager = null;
var theSentenceManager = null;
var theLevelManager = null;
var thePositionManager = null;
var theStorageHandler = null;

var theCurrentZiComponents = [0, 0, 0, 0, 0, 0, 0, 0];
var theTotalBeginnerLessons = 50; //TODO: to lessonmanager?
var theNumberOfLessonsInLevels = [7, 13, 15, 15];
var theHittestState = HittestState.hanzishuFullZiMode;

var theRangeUptoLessonNumberForCurrentLevel = 1;
var theRangeFromLessonNumberForCurrentLevel = 1;

var theCurrentLevel = 1;
// NOTE: Use theCurrentLessonId whenever possible
var theCurrentLesson = "None"; // to be removed
var theCurrentLessonId = 1;

var theCurrentCenterZiId = 1;
var thePreviousCenterZiId = 0;

Directory theStorageFileDirectory = null;
