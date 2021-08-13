import 'package:hanzishu/engine/inputzi.dart';

var theInputZiList = [
  InputZi("ac", 11, "丌"),
  InputZi("apa", 2, "开"),
  InputZi("apau", 7, "无"),
  InputZi("apaue", 4, "专"),
  InputZi("apauf", 12, "丐"),
  InputZi("apnp", 6, "互"),
  InputZi("axo", 10, "扎"),
  InputZi("bx",8, "厷"),
  InputZi("ci", 3, "尤"),
  InputZi("dcde", 5, "瓦"),
  InputZi("de", 1, "节"),
  InputZi("dfg", 9, "戉"),
];

/*
 1. find range [double-byte code is in charge of this]
 2. sort according to the frequency value - (create a new sub-list and sort it)
    [find the top n/25 with the largest values]
    [stack of size n. new one push into a position if fit, otherwise ignore.]
    [frequency value is in charge of the order]
 3. take the top zi list in order
 */
