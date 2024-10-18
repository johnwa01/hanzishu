import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';

part 'storagehandler.g.dart';

@JsonSerializable(nullable: false)
class Storage {
  String storageVersion = '';
  String language = '';
  String lessonsStatus = ''; // completed = '1', not completed = '0'; starting from 0 position up to 119. Total 120 for now.
  //List<Statistics> statisticsArray;  //Note: The most complicated structure I created for the storage.
  List<LessonQuizResult> lessonQuizResults = <LessonQuizResult>[];

  Storage({required this.storageVersion, required this.language, required this.lessonsStatus, required this.lessonQuizResults});
}

/* Keep for reference
class Statistics {
  String dateString;
  double studyTime;
  int tapCount;

  Statistics({
    this.dateString,
    this.studyTime,
    this.tapCount
  });

  init() {
    dateString = '';
    studyTime = 0.0;
    tapCount = 0;
  }

  factory Statistics.fromJson(Map<String, dynamic> json) => Statistics(
    dateString: json["dateString"],
    studyTime: json["studyTime"],
    tapCount: json["tapCount"],
  );

  Map<String, dynamic> toJson() => {
    "dateString": dateString,
    "studyTime": studyTime,
    "tapCount": tapCount,
  };
}
*/

class LessonQuizResult {
  String dateString = '';
  int lessonId = -1;
  int cor = -1;       // totalCorrect
  int answ = -1;       // answered

  LessonQuizResult({
    required this.dateString,
    required this.lessonId,
    required this.cor,
    required this.answ,
  });

  factory LessonQuizResult.fromJson(Map<String, dynamic> json) => LessonQuizResult(
    dateString: json["dateString"],
    lessonId: json["lessonId"],
    cor: json["cor"],
    answ: json["answ"],
  );

  Map<String, dynamic> toJson() => {
    "dateString": dateString,
    "lessonId": lessonId,
    "cor": cor,
    "answ": answ,
  };
}

class StorageHandler {
  static int MaximumNumberOfQuizResults = 60;
  static int NumberOfQuizResultsToTrim = 10;
  Storage storage = Storage(storageVersion : '', language : '', lessonsStatus : '', lessonQuizResults : <LessonQuizResult>[]);
  bool hasTriedToLoadStorage = false;

  initStorage() {
    storage.storageVersion = '1.0';
    storage.language = 'en_US';
    storage.lessonsStatus = '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
    hasTriedToLoadStorage = false;
  }

  setStorageVersion(String storageVersion) {
    storage.storageVersion = storageVersion;
  }

  setLanguage(String language) {
    storage.language = language;
  }

  setLessonsStatus(String lessonsStatus) {
    storage.lessonsStatus = lessonsStatus;
  }

  setHasTriedToLoadStorage() {
    this.hasTriedToLoadStorage = true;
  }

  updateOneLessonStatus(int lessonId, bool completed) {
    var newValue = completed ? '1' : '0';
    storage.lessonsStatus = Utility.replaceCharAt(storage.lessonsStatus, lessonId - 1, newValue);
  }

  bool hasLessonCompleted(int lessonId) {
    var value = storage.lessonsStatus.codeUnitAt(lessonId - 1);
    return (value == 49) ? true : false;    // 49 -> '1'
  }

  String getStorageVersion() {
    return storage.storageVersion;
  }

  String getLanguage() {
    return storage.language;
  }

  String getLessonsStatus() {
    return storage.lessonsStatus;
  }

  bool getHasTriedToLoadStorage() {
    return hasTriedToLoadStorage;
  }

  List<LessonQuizResult> getLessonQuizResults() {
    return storage.lessonQuizResults;
  }

  LessonQuizResult? getLessonQuizResult(int index) {
    var results = getLessonQuizResults();
    // make newest result the first - reverse the order
    if (results != null) {
      var length = results.length;
      if (length > 0 && index >= 0 && index <= length - 1) {
        return results[length - 1 - index];
      }
    }

    return null;
  }

  int getLessonQuizResultLength () {
    var results = getLessonQuizResults();
    if (results != null) {
      return results.length;
    }

    return 0;
  }

  appendLessonQuizResult(LessonQuizResult lessonQuizResult) {
    var result = LessonQuizResult(dateString : '', lessonId : -1, cor : -1, answ : -1);
    result.dateString = lessonQuizResult.dateString;
    result.lessonId = lessonQuizResult.lessonId;
    result.cor = lessonQuizResult.cor;
    result.answ = lessonQuizResult.answ;

    if (storage.lessonQuizResults == null) {
      storage.lessonQuizResults = [];
    }
    storage.lessonQuizResults.add(result);

    // trim the results if more than the max
    if (storage.lessonQuizResults.length > MaximumNumberOfQuizResults) {
      storage.lessonQuizResults.removeRange(0, NumberOfQuizResultsToTrim);
    }
  }

  Storage getStorage() {
    return storage;
  }

  // setting this way will make it easier for new versions with new entries. It'll pick up whatever new entries you add here in future versions.
  // set value read from storage to run time
  setStorage(Storage storage) {
    // update some values from local storage
    if (storage.storageVersion != null) {
      this.storage.storageVersion = storage.storageVersion;
    }

    if (storage.language != null) {
      this.storage.language = storage.language;
    }

    if (storage.lessonsStatus != null) {
      if(this.storage.lessonsStatus.length == storage.lessonsStatus.length) {
        this.storage.lessonsStatus = storage.lessonsStatus;
      }
      if(this.storage.lessonsStatus.length > storage.lessonsStatus.length) { // new release with more lessons than from storage record
        this.storage.lessonsStatus = Utility.replacePartOfString(this.storage.lessonsStatus, storage.lessonsStatus);
      }
      else {
        // strange case of run time having a shorter string than read from storage.
        // just read first part of the string read from the storage
        this.storage.lessonsStatus = storage.lessonsStatus.substring(0, this.storage.lessonsStatus.length);
      }
    }

    if (storage.lessonQuizResults != null) {
      this.storage.lessonQuizResults = storage.lessonQuizResults;
    }
  }

  Storage? getStorageFromJson(String content) {
    try {
      var stor = _$StorageFromJson(json.decode(content));
      return stor;
    } catch (e) {
      return null;
    }
  }

  String putStorageToJson() {
    return json.encode(_$StorageToJson(storage));
  }

  SaveToFile() {
    // do nothing if web for now
    if (!kIsWeb) {
      var str = theStorageHandler.putStorageToJson();

      if (theFileIOFile != null) {
        theFileIOFile.writeString(str);
      }
    }
  }
}
