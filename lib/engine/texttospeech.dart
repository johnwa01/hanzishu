import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

class TextToSpeech {
  static speak(String lang, String str) async {
    FlutterTts flutterTts = FlutterTts();
    flutterTts.setLanguage(lang); //"zh-CN"
    flutterTts.speak(str/*'你好''Hello World'*/);
  }

  // rate: use 0.5 as normal
  static speakWithRate(String lang, String str, double rate) async {
    double realRate; // iOS: 0.5 is normal, Android: 1.0 is normal
    if (!kIsWeb && Platform.isIOS) { // iOS simulator would crash on backspace with composing. so have to skip the underline feature until it's fixed.
      realRate = rate;
    }
    else if (kIsWeb) {
      realRate = rate;
    }
    else { // Android
      realRate = rate * 2.0;
    }

    FlutterTts flutterTts = FlutterTts();
    flutterTts.setLanguage(lang); //"zh-CN"
    flutterTts.setSpeechRate(realRate);
    flutterTts.speak(str/*'你好''Hello World'*/);
  }
}