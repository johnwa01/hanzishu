import 'package:flutter/material.dart';

/// Shared text styles for Hanzishu.
///
/// Keep typography decisions here so pages do not define
/// font sizes and weights repeatedly.
class HzTextStyles {
  HzTextStyles._();

  static const TextStyle appBarTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle pageSubtitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: Colors.black54,
  );

  static const TextStyle sectionHeader = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle button = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black54,
  );
}

//Text(
//getString(611),
//textAlign: TextAlign.center,
//style: HzTextStyles.pageSubtitle,
//)

//style: HzTextStyles.button.copyWith(
//color: Colors.white,
//)
