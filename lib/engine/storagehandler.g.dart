// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storagehandler.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Storage _$StorageFromJson(Map<String, dynamic> json) {
  return Storage(
    storageVersion: json['storageVersion'] as String,
    language: json['language'] as String,
    lessonsStatus: json['lessonsStatus'] as String,
    lessonQuizResults: (json['lessonQuizResults'] as List)
        .map((e) => LessonQuizResult.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$StorageToJson(Storage instance) => <String, dynamic>{
      'storageVersion': instance.storageVersion,
      'language': instance.language,
      'lessonsStatus': instance.lessonsStatus,
      'lessonQuizResults': instance.lessonQuizResults,
    };
