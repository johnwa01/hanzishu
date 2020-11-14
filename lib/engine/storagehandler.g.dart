// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storagehandler.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Storage _$StorageFromJson(Map<String, dynamic> json) {
  return Storage(
    storageVersion: json['storageVersion'] as String,
    latestEnabledLesson: json['latestEnabledLesson'] as int,
    lessonQuizResults: (json['lessonQuizResults'] as List)
        .map((e) => LessonQuizResult.fromJson(e as Map<String, dynamic>))
        .toList(),
  )..statisticsArray = (json['statisticsArray'] as List)
      .map((e) => Statistics.fromJson(e as Map<String, dynamic>))
      .toList();
}

Map<String, dynamic> _$StorageToJson(Storage instance) => <String, dynamic>{
      'storageVersion': instance.storageVersion,
      'latestEnabledLesson': instance.latestEnabledLesson,
      'statisticsArray': instance.statisticsArray,
      'lessonQuizResults': instance.lessonQuizResults,
    };
