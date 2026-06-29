import 'package:flutter/material.dart';

enum AppSection {
  home,
  lessons,
  inputMethod,
  dictionary,
  blockHanzi,
  more,
}

class SectionStyle {
  final Color accentColor;
  final String mascotName;

  const SectionStyle({
    required this.accentColor,
    required this.mascotName,
  });
}

class SectionTheme {
  static SectionStyle style(AppSection section) {
    switch (section) {
      case AppSection.home:
        return const SectionStyle(
          accentColor: Colors.blueGrey,
          mascotName: 'home_mascot',
        );

      case AppSection.lessons:
        return const SectionStyle(
          accentColor: Colors.green,
          mascotName: 'lessons_mascot',
        );

      case AppSection.inputMethod:
        return const SectionStyle(
          accentColor: Colors.deepPurple,
          mascotName: 'input_method_mascot',
        );

      case AppSection.dictionary:
        return const SectionStyle(
          accentColor: Colors.blue,
          mascotName: 'dictionary_mascot',
        );

      case AppSection.blockHanzi:
        return const SectionStyle(
          accentColor: Colors.amber,
          mascotName: 'block_hanzi_mascot',
        );

      case AppSection.more:
        return const SectionStyle(
          accentColor: Colors.teal,
          mascotName: 'more_mascot',
        );
    }
  }

  static Color accentColor(AppSection section) =>
      style(section).accentColor;

  static String mascotName(AppSection section) =>
      style(section).mascotName;
}

//backgroundColor:
//SectionTheme.accentColor(AppSection.inputMethod),

//final mascot =
//SectionTheme.mascotName(AppSection.inputMethod);

//final theme = SectionTheme.style(AppSection.inputMethod);
//theme.accentColor
//theme.mascotName