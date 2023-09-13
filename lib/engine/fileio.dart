import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/Hanzishu2020.txt');  // the hardcoded default file for Hanzishu storage.
  }

  /*
  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      // Note: For first ever run or has never saved before, the file would not be created yet.
      return 0;
    }
  }
  */

  Future<String> readString() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return null;
    }
  }

  /*
  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
  */

  Future<File> writeString(String content) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(content);
  }
}
