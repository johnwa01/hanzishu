import 'package:hanzishu/utility.dart';

var theLessonManager = null;
var theZiManager = null;
var thePhraseManager = null;
var theSentenceManager = null;
var theLevelManager = null;

var theCurrentZiComponents = [0, 0, 0, 0, 0, 0, 0, 0];
var theTotalBeginnerLessons = 50; //TODO: to lessonmanager?
var theNumberOfLessonsInLevels = [7, 13, 15, 15];
var theHittestState = HittestState.hanzishuFullZiMode;

var theRangeUptoLessonNumberForCurrentLevel = 1;
var theRangeFromLessonNumberForCurrentLevel = 1;

var theCurrentLevel = 1;
var theCurrentLesson = "none";

var thePreviousCenterZiId = 0;