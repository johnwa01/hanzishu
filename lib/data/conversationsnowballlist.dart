import 'package:hanzishu/engine/sentence.dart';

// only access this through SentenceManager
var theConversationSnowballList =
[
  Snowball(0, [Sent('A',1)]), // non-lesson
  Snowball(1, [Sent('A',1), Sent('B', 1)]),
  Snowball(2, [Sent('A',1), Sent('B', 1), Sent('A', 2), Sent('B', 3), Sent('A', 4)]),
  Snowball(3, [Sent('A',1), Sent('B', 1), Sent('A', 5), Sent(' ', 6), Sent('B', 5), Sent('A', 146)]),
  Snowball(4, [Sent('A',1), Sent('B', 7), Sent(' ', 5), Sent('A', 6), Sent('B', 8), Sent('A', 8)]),
  Snowball(5, [Sent('A',9), Sent('B', 1), Sent('A', 7), Sent('B', 10), Sent(' ', 5), Sent('A', 6), Sent('B', 8), Sent('A', 8)]),
  Snowball(6, [Sent('A',1), Sent('B', 7), Sent('A', 11), Sent('B', 12), Sent('A', 5), Sent('B', 6), Sent('A', 8), Sent('B', 8)]),
  Snowball(7, [Sent('A',1), Sent('B', 9), Sent('A', 11), Sent('B', 12), Sent('A', 5), Sent('B', 6), Sent('A', 13), Sent('B', 14), Sent('A', 8), Sent('B', 8)]),
  Snowball(8, [Sent('A',1), Sent('B', 9), Sent('A', 11), Sent('B', 12), Sent('A', 5), Sent('B', 6), Sent('A', 15), Sent('B', 16), Sent('A', 13), Sent('B', 14), Sent('A', 8), Sent('B', 8)]),
  Snowball(9, [Sent('A',1), Sent('B', 1), Sent('A', 18), Sent('B', 19), Sent(' ', 18), Sent('A', 147), Sent('B', 11), Sent('A', 12), Sent('B', 15), Sent('A', 16), Sent('B', 5), Sent('A', 6), Sent(' ', 5), Sent('B', 146), Sent('A', 13), Sent('A', 14), Sent('B', 8), Sent('A', 8)]),
  Snowball(10, [Sent('A',1)]),
  Snowball(11, [Sent('A',1)]),
  Snowball(12, [Sent('A',1)]),
  Snowball(13, [Sent('A',1)]),
  Snowball(14, [Sent('A',1)]),
  Snowball(15, [Sent('A',10), Sent('B', 7), Sent('A', 21), Sent(' ', 30), Sent('B', 31), Sent('A', 33), Sent('B', 37), Sent('A', 34), Sent(' ', 39), Sent('B', 38), Sent('A', 40), Sent(' ', 25), Sent('B', 145), Sent('A', 41), Sent(' ', 23), Sent('B', 24), Sent('A', 26), Sent('B', 28), Sent('A', 35), Sent('B', 29), Sent(' ', 27), Sent('A', 36), Sent(' ', 22)]),
  Snowball(16, [Sent('A',10), Sent('B', 7), Sent('A', 21), Sent(' ', 30), Sent('B', 31), Sent('A', 33), Sent('B', 37), Sent('A', 34), Sent(' ', 39), Sent('B', 38), Sent('A', 40), Sent(' ', 25), Sent('B', 145), Sent('A', 41), Sent(' ', 23), Sent('B', 24), Sent('A', 26), Sent('B', 28), Sent('A', 35), Sent('B', 29), Sent(' ', 27), Sent('A', 36), Sent(' ', 22)]),
];