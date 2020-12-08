import 'dart:async';
import 'dart:io';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:hanzishu/variables.dart';

part 'storagehandler.g.dart';

@JsonSerializable(nullable: false)
class Storage {
  String storageVersion;
  int latestEnabledLesson;
  List<Statistics> statisticsArray;
  List<LessonQuizResult> lessonQuizResults;

  Storage({this.storageVersion, this.latestEnabledLesson, this.statisticsArray, this.lessonQuizResults});
}

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

class LessonQuizResult {
  String dateString;
  int lessonId;
  int cor;       // totalCorrect
  int answ;       // answered

  LessonQuizResult({
    this.dateString,
    this.lessonId,
    this.cor,
    this.answ,
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
  Storage storage = Storage();

  initStorage() {
    storage.storageVersion = '1.0';
    storage.latestEnabledLesson = 1;
    //var sta = Statistics("10:11:2020", 0.0, 0);
    storage.statisticsArray = [Statistics()]; //add({"10:11:2020", 0.0, 0});
    storage.lessonQuizResults = [LessonQuizResult()];
  }

  setStorageVersion(String storageVersion) {
    storage.storageVersion = storageVersion;
  }

  setLatestEnabledLesson(int latestEnabledLesson) {
    storage.latestEnabledLesson = latestEnabledLesson;
  }

  int getLatestEnabledLesson() {
    return storage.latestEnabledLesson;
  }

  List<Statistics> getStatisticsArray() {
    return storage.statisticsArray;
  }

  List<LessonQuizResult> getLessonQuizResults() {
    return storage.lessonQuizResults;
  }

  LessonQuizResult getLessonQuizResult(int index) {
    var results = getLessonQuizResults();
    if (results != null) {
      if (index <= results.length - 1) {
        return results[index];
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

  int getStudyTimeAndTapCountLength () {
    var array = getStatisticsArray();
    if (array != null) {
      return array.length;
    }

    return 0;
  }

  Statistics getStudyTimeAndTapCount(int index) {
    var statistics = getStatisticsArray();
    if (statistics != null) {
      if (index <= statistics.length - 1) {
        return statistics[index];
      }
    }

    return null;
  }

  bool existStatisticsForDateString(String dateString) {
    var arrayCount = storage.statisticsArray.length;
    if (arrayCount > 0) {
      if (storage.statisticsArray[arrayCount-1].dateString == dateString) {
        return true;
      }
    }

    return false;
  }

  updateStatistics(Statistics statistics) {
    var arrayCount = storage.statisticsArray.length;
    if (arrayCount > 0) {
      storage.statisticsArray[arrayCount - 1].studyTime += statistics.studyTime;
      storage.statisticsArray[arrayCount - 1].tapCount += statistics.tapCount;
    }
  }

  appendStatistics(Statistics statistics) {
    storage.statisticsArray.add(statistics);
  }

  appendLessonQuizResult(LessonQuizResult lessonQuizResult) {
    var result = LessonQuizResult();
    result.dateString = lessonQuizResult.dateString;
    result.lessonId = lessonQuizResult.lessonId;
    result.cor = lessonQuizResult.cor;
    result.answ = lessonQuizResult.answ;

    storage.lessonQuizResults.add(result);
  }

  addOrUpdateStatistics(Statistics statistics) {
    var exist = existStatisticsForDateString(statistics.dateString);

    if (exist) {
      updateStatistics(statistics);
    }
    else {
      appendStatistics(statistics);
    }
  }

  Storage getStorage() {
    return storage;
  }

  setStorage(Storage storage) {
    this.storage = storage;
  }

  Storage getStorageFromJson(String content) {
    return _$StorageFromJson(json.decode(content));
  }

  String putStorageToJson() {
    return json.encode(_$StorageToJson(storage));
  }

  SaveToFile() {
    var str = theStorageHandler.putStorageToJson();

    theFileIOFile.writeString(str);
  }
}
