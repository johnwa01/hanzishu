import 'package:hanzishu/engine/pinyin.dart';

var thePinyinList=[
  Pinyin(0, "a", Sample( "a", "阿"), []),
  Pinyin(1, "o", Sample("o", "噢"), []),
  Pinyin(2, "e", Sample("e", "婀"), []),

  Pinyin(3, "i", Sample("", "衣"), []),
  Pinyin(4, "u", Sample("", "屋"), []),
  Pinyin(5, "ü", Sample("", "迂"), []),

  Pinyin(6, "ai", Sample("", "哀"), []),
  Pinyin(7, "ei", Sample("", "诶"), []),
  Pinyin(8, "ui", Sample("", "威"), []),

  Pinyin(9, "ao", Sample("", "熬"), []),
  Pinyin(10, "ou", Sample("", "欧"), []),
  Pinyin(11, "iu", Sample("", "忧"), []),

  Pinyin(12, "ie", Sample("", "耶"), []),
  Pinyin(13, "üe", Sample("", "约"), []),
  Pinyin(14, "er", Sample("", "儿"), []), // 2nd tone

  Pinyin(15, "an", Sample("", "安"), []),
  Pinyin(16, "en", Sample("", "恩"), []),
  Pinyin(17, "in", Sample("", "因"), []),

  Pinyin(18, "un", Sample("", "温"), []),
  Pinyin(19, "ün", Sample("", "晕"), []),
  Pinyin(20, "ang", Sample("", "昂"), []),

  Pinyin(21, "eng", Sample("", "亨(h)"), []), // h
  Pinyin(22, "ing", Sample("", "英"), []),
  Pinyin(23, "ong", Sample("", "轰(h)"), []), // h

  Pinyin(24, "b", Sample("", "玻"), []),
  Pinyin(25, "p", Sample("", "坡"), []),
  Pinyin(26, "m", Sample("", "摸"), []),
  Pinyin(27, "f", Sample("", "佛"), []),

  Pinyin(28, "d", Sample("", "得"), []),
  Pinyin(29, "t", Sample("", "特"), []),
  Pinyin(30, "n", Sample("", "讷"), []),
  Pinyin(31, "l", Sample("", "勒"), []),

  Pinyin(32, "g", Sample("", "哥"), []),
  Pinyin(33, "k", Sample("", "科"), []),
  Pinyin(34, "h", Sample("", "喝"), []),

  Pinyin(35, "j", Sample("", "基"), []),
  Pinyin(36, "q", Sample("", "欺"), []),
  Pinyin(37, "x", Sample("", "希"), []),

  Pinyin(38, "zh", Sample("", "知"), []),
  Pinyin(39, "ch", Sample("", "蚩"), []),
  Pinyin(40, "sh", Sample("", "诗"), []),
  Pinyin(41, "r", Sample("", "日"), []),

  Pinyin(42, "z", Sample("", "资"), []),
  Pinyin(43, "c", Sample("", "雌"), []),
  Pinyin(44, "s", Sample("", "思"), []),

  Pinyin(45, "y", Sample("", "迂"), []),
  Pinyin(46, "w", Sample("", "乌"), []),

  Pinyin(47, "", Sample("", ""), [Sample("mā", "妈"), Sample("má", "麻"), Sample("mǎ", "马"), Sample("mà", "骂")]), // '马' has wrong sound in Chrome
  //Pinyin(48, "", Sample("", ""), [Sample("ō", "噢"), Sample("ó", "哦"), Sample("ǒ", "嚄"), Sample("ò", "哦")]),
  //Pinyin(49, "", Sample("", ""), [Sample("ē", "婀"), Sample("é", "俄"), Sample("shě", "舍"), Sample("è", "饿")]),
  Pinyin(48, "", Sample("", ""), [Sample("yī", "衣"), Sample("yí", "移"), Sample("yǐ", "乙"), Sample("yì", "易")]),
  Pinyin(49, "", Sample("", ""), [Sample("wū", "屋"), Sample("wú", "无"), Sample("wǔ", "五"), Sample("wù", "物")]),
  Pinyin(50, "", Sample("", ""), [Sample("yū", "迂"), Sample("yú", "鱼"), Sample("yǔ", "雨"), Sample("yù", "遇")]),

  Pinyin(51, "", Sample("", ""), [Sample("zhè", "这"), Sample("zuò", "做"), Sample("suì", "岁")]),
  Pinyin(52, "", Sample("", ""), [Sample("lóu", "楼"), Sample("hǎo", "好"), Sample("yuè", "月")]),
  Pinyin(53, "", Sample("", ""), [Sample("děng", "等"), Sample("shān", "山"), Sample("xià", "夏")]),
  Pinyin(54, "", Sample("", ""), [Sample("xià", "下"), Sample("rén", "人"), Sample("jiào", "叫")]),
  Pinyin(55, "", Sample("", ""), [Sample("xiè", "谢"), Sample("tóng", "同"), Sample("bèi", "贝")]),
  Pinyin(56, "", Sample("", ""), [Sample("jiàn", "见"), Sample("nà", "那"), Sample("cài", "菜")]),
  Pinyin(57, "", Sample("", ""), [Sample("kuài", "快"), Sample("míng", "名"), Sample("páng", "旁")]),
  Pinyin(58, "", Sample("", ""), [Sample("guān", "关"), Sample("qì", "气"), Sample("chūn", "春")]),
];

var thePinyinLessonList=[
  [0, 1, 2],
  [3, 4, 5,           0, 1, 2],
  [24, 25, 26, 27,    0, 1, 2, 3, 4, 5],
  [                   0, 1, 2, 3, 4, 5, 24, 25, 26, 27],
  [28, 29, 30, 31,    0, 1, 2, 3, 4, 5],
  [6, 7, 8,           28, 29, 30, 31],
  [32, 33, 34,        6, 7, 8],
  [9, 10, 11,         32, 33, 34, 6, 7, 8],
  [35, 36, 37,        9, 10, 11, 6, 7, 8],
  [12, 13, 14,        35, 36, 37, 9, 10, 11],
  [38, 39, 40, 41,    12, 13, 14, 9, 10, 11],
  [15, 16, 17,        38, 39, 40, 41, 12, 13, 14],
  [42, 43, 44,        15, 16, 17, 12, 13, 14],
  [18, 19, 20,        42, 43, 44, 15, 16, 17],
  [45, 46,            18, 19, 20, 15, 16, 17],
  [21, 22, 23,        45, 46, 18, 19, 20],
  [                   21, 22, 23, 45, 46, 18, 19, 20],
  [47,                21, 22, 23],
  [48, 53,            47],
  [49, 54,            48, 47],
  [50, 55,            49, 54],
  [51, 56,            50, 55],
  [52, 57,            51, 56],
  [58,                57, 56, 55],
];