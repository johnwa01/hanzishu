import 'package:hanzishu/engine/lesson.dart';
import 'package:hanzishu/utility.dart';

//int BaseLessonTitleTranslationStringID = 20;
//int BaseUnitTitleTranslationStringID = 472;

// only access this through LessonManager
var theLessonList = [
  // Note: the getString here is a static value. The code in lessonspage will call getString directly.
  Lesson(0, "对话", 0/*"Conversion"*/, [], "", [], "", [], [], "Characters", [], [], [0]),
  Lesson(1, "你好", 21/*"Hello"*/, [1,153,154,155], "", [], "", [], [], "Chinese Characters", [], [], [1]),
  Lesson(2, "一二三", 22/*"Numbers"*/, [2,3,4], "", [], "", [], [], "Strokes", [], [], [2]),
  Lesson(3, "多大", 23/*"Age"*/, [5,6,146],  "", [], "",  [], [], "Basic Characters", [], [3, 115], [3]),
  Lesson(4, "再见", 24/*"Goodbye"*/, [7,8],  "", [], "",  [], [], "Chinese Characters", [], [0,20], [4]),
  Lesson(5, "同学", 25/*"Classmates"*/, [9,10],  "", [], "",  [], [], "", [], [117], [5]),
  Lesson(6, "谢谢", 26/*"Thanks"*/, [11,12],  "", [], "",  [], [], "Chinese Characters", [], [38], [6]),
  Lesson(7, "对不起", 27/*"Apology"*/, [13,14],  "", [], "",  [], [], "", [], [70], [7]),
  Lesson(8, "中国", 28/*"China"*/, [15,16],  "", [], "",  [], [], "Compound Characters", [], [5,7], [8]),
  Lesson(9, "名字", 29/*"Name"*/, [18,19],  "", [], "",  [], [], "Traditional and Simplified Characters", [], [16,17], [9]),
  Lesson(10, "上课", 30/*"Start class"*/, [21,22],  "", [], "",  [], [], "", [], [118, 119, 120], [10]),
  Lesson(11, "明白", 31/*"Understanding"*/, [25,145,158,159],  "", [], "",  [], [], "Pianpang", [], [4,153,154], [11]),
  Lesson(12, "完了", 32/*"Done"*/, [26,27,28,29],  "", [], "",  [], [], "", [], [], [12]),
  Lesson(13, "问题", 33/*"Questions"*/, [30,31,32,33],  "", [], "",  [], [], "", [], [72], [13]),
  Lesson(14, "读", 34/*"Reading"*/, [23,24,37,39],  "", [], "",  [], [], "", [], [32], [14]),
  Lesson(15, "重复", 35/*"Repetition"*/, [38,40,41],  "", [], "",  [], [], "", [], [68,71], [15]),
  Lesson(16, "等一下", 36/*"Wait a minute"*/, [34,35,36],  "", [], "",  [], [], "", [], [69], [16]),
  Lesson(17, "爱", 37/*"Love"*/, [42,43,44],  "", [], "",  [], [], "", [], [82,83], [17]),
  Lesson(18, "哥哥", 38/*"Older brother"*/, [45,46],  "", [], "",  [], [], "", [], [121, 122, 123, 124, 125], [18]),
  Lesson(19, "班", 39/*"Class"*/, [20,47,48,49],  "", [], "",  [], [], "", [], [18,19,73], [19]),
  Lesson(20, "生日", 40/*"Birthdays"*/, [50,51],  "", [], "",  [], [], "", [], [104,105,106], [20]),
  Lesson(21, "生病", 41/*"Feeling sick"*/, [52,53,156],  "", [], "",  [], [], "", [], [79,80,81], [21]),
  Lesson(22, "吃饭", 42/*"Meal"*/, [54,55,56],  "", [], "",  [], [], "Pinyin", [], [], [22]),
  Lesson(23, "喝", 43/*"Drinking"*/, [57,58,59],  "", [], "",  [], [], "", [], [126], [23]),
  Lesson(24, "烤鸭", 44/*"Roast duck"*/, [60,61],  "", [], "",  [], [], "Two Character Phrases", [], [24,25], [24]),
  Lesson(25, "辣菜", 45/*"Spicy food"*/, [62,63],  "", [], "",  [], [], "", [], [], [25]),
  Lesson(26, "点菜", 46/*"Ordering"*/, [64,65],  "", [], "",  [], [], "", [], [], [26]),
  Lesson(27, "汉字树", 47/*"Hanzi Tree"*/, [66,67,163],  "", [], "",  [], [], "", [], [133], [27]),
  Lesson(28, "汉字", 48/*"Chinese characters"*/, [68,69,70,71],  "", [], "",  [], [], "", [], [], [28]),
  Lesson(29, "大学", 49/*"College"*/, [72,73],  "", [],  "",  [], [], "Four Character Idoms", [], [48,49,50,51], [29]),
  Lesson(30, "中文", 50/*"Chinese"*/, [74,75,162],  "", [], "",  [], [], "Pinyin", [], [1,2], [30]),
  Lesson(31, "住在", 51/*"Accommodations"*/, [76,77],  "", [], "",  [], [], "Mandarin and  Cantonese", [], [21,22,23], [31]),
  Lesson(32, "功课", 52/*"Homework"*/, [17,78,79],  "", [], "",  [], [], "Pronounciation of Characters   ", [], [13,14], [32]),
  Lesson(33, "喜欢", 53/*"Likes"*/, [80,81,82],  "", [], "",  [], [], "Grammar Is Simple", [], [15], [33]),
  Lesson(34, "温度", 54/*"Temperature"*/, [83,84],  "", [], "",  [], [], "", [], [127,128,129], [34]),
  Lesson(35, "阳光", 55/*"Sunny"*/, [85,86],  "", [], "",  [], [], "Meaning of Characters", [], [8,9,10,11,12], [35]),
  Lesson(36, "风雨", 56/*"Wind & rain"*/, [87,88,157],  "", [], "",  [], [], "", [], [130,131], [36]),
  Lesson(37, "季节", 57/*"Seasons"*/, [89,90],  "", [], "",  [], [], "", [], [54,55], [37]),
  Lesson(38, "下雪", 58/*"Snowing"*/, [91,92],  "", [], "",  [], [], "", [], [107,108], [38]),
  Lesson(39, "多少钱", 59/*"Cost"*/, [93,94],  "", [], "",  [], [], "Panda", [], [44,45], [39]),
  Lesson(40, "票", 60/*"Tickets"*/, [95,96],  "", [], "",  [], [], "Beijing Opera", [], [46,47], [40]),
  Lesson(41, "衣服", 61/*"Clothes"*/, [97,98],  "", [], "",  [], [], "", [], [109,110,147,148], [41]),
  Lesson(42, "公寓", 62/*"Apartment"*/, [99,100],  "", [], "",  [], [], "", [], [66,67], [42]),
  Lesson(43, "逛街", 63/*"Go shopping"*/, [102,103,160],  "", [], "",  [], [], "", [], [100,101,102,103], [43]),
  Lesson(44, "厕所", 64/*"Restroom"*/, [101,104,105],  "", [], "",  [], [], "", [], [63,64,65], [44]),
  Lesson(45, "去哪", 65/*"Sightseeing"*/, [106,107,164],  "", [], "",  [], [], "Computer Input", [], [26,27,28], [45]),
  Lesson(46, "怎么走", 66/*"Directions"*/, [108,109,165],  "", [], "",  [], [], "Chinese New Year", [], [29,30,31,33,34,35], [46]),
  Lesson(47, "旅游", 67/*"Travel"*/, [110,111],  "", [], "",  [], [], "", [], [111,112,113,114], [47]),
  Lesson(48, "照相", 68/*"Photos"*/, [112,113],  "", [], "",  [], [], "", [], [], [48]),
  Lesson(49, "旅店", 69/*"Hotel"*/, [114,115,116],  "", [], "",  [], [], "", [], [144,145,146,149,150], [49]),
  Lesson(50, "高铁", 70/*"Highspeed train"*/, [117,118],  "", [], "",  [], [], "", [], [89,90,151], [50]),
  Lesson(51, "出租车", 71/*"Taxi"*/, [119,120],  "", [], "",  [], [], "", [], [91,92,93,94], [51]),
  Lesson(52, "飞机", 72/*"Airplane"*/, [121,122],  "", [], "",  [], [], "", [], [134,135,136,137,138], [52]),
  Lesson(53, "列车", 73/*"Subway"*/, [123,124],  "", [], "",  [], [], "", [], [132,139,140,141,142], [53]),
  Lesson(54, "开始", 74/*"Start time"*/, [125,126,127],  "", [], "",  [], [], "The Great Wall", [], [40,41,42,43,62], [54]),
  Lesson(55, "足球", 75/*"Football"*/, [128,129],  "", [], "",  [], [], "Chinese Language", [], [52,53], [55]),
  Lesson(56, "电影", 76/*"Movie"*/, [130,131],  "", [], "",  [], [], "Chinese Zodiac", [], [36,37], [56]),
  Lesson(57, "京剧", 77/*"The Beijing Opera"*/, [132,133],  "", [], "",  [], [], "", [], [56,57,58,59,60], [57]),
  Lesson(58, "歌曲", 78/*"Song"*/, [134,135],  "", [], "",  [], [], "", [], [85,86], [58]),
  Lesson(59, "舞蹈", 79/*"Dancing"*/, [136,137],  "", [], "",  [], [], "", [], [87,88], [59]),
  Lesson(60, "宠物", 80/*"Pets"*/, [138,139,140],  "", [], "",  [], [], "", [], [84], [60]),
  //Lesson(61, "动物园", 0/*"Zoo"*/, [141,142],  "", [], "",  [], [], "", [], [95,96,97,98,99], [61]),
  //Lesson(62, "发明", 0/*"Invention"*/, [143,144/*,147,148,149,150,151,152,161*/],  "", [], "",  [], [], "", [], [74,75,76,77,78], [62]),
  Lesson(61, "Chicken1", 472, [184,185,186],  "", [], "",  [], [], "", [], [], [61]),
  Lesson(62, "Chicken2", 472, [187,188,189,190],  "", [], "",  [], [], "", [], [], [62]),
  Lesson(63, "Chicken3", 472, [191,192,193],  "", [], "",  [], [], "", [], [], [63]),
  Lesson(64, "Camel 1", 473, [166,167,168,169],  "", [], "",  [], [], "", [], [], [64]),
  Lesson(65, "Camel 2", 473, [170,171,172],  "", [], "",  [], [], "", [], [], [65]),
  Lesson(66, "Camel 3", 473, [174,175,176,177,178],  "", [], "",  [], [], "", [], [], [66]),
  Lesson(67, "Camel 4", 473, [179,180,181,182,183],  "", [], "",  [], [], "", [], [], [67]),
  Lesson(68, "Bear 1", 474, [194,195,196,197],  "", [], "",  [], [], "", [], [], [68]),
  Lesson(69, "Bear 2", 474, [198, 199,200,201,202,203],  "", [], "",  [], [], "", [], [], [69]),
  Lesson(70, "Bear 3", 474, [204,205,206,207,208,209],  "", [], "",  [], [], "", [], [], [70]),
  Lesson(71, "Terra-Cotta Warriors 1", 475, [210,211,212,213,214],  "", [], "",  [], [], "", [], [], [71]),
  Lesson(72, "Terra-Cotta Warriors 2", 475, [215,216,217,218,219,220],  "", [], "",  [], [], "", [], [], [72]),
  Lesson(73, "Terra-Cotta Warriors 3", 475, [221,222,223,224,225,226],  "", [], "",  [], [], "", [], [], [73]),
  Lesson(74, "Terra-Cotta Warriors 4", 475, [227,228,229,230,231,232],  "", [], "",  [], [], "", [], [], [74]),
  Lesson(75, "Mulan 1", 476, [233,234,235,236,237,238],  "", [], "",  [], [], "", [], [], [75]),
  Lesson(76, "Mulan 2", 476, [239,240,241,242,243,244],  "", [], "",  [], [], "", [], [], [76]),
  Lesson(77, "Mulan 3", 476, [245,246,247,248,249,250],  "", [], "",  [], [], "", [], [], [77]),
  Lesson(78, "Mulan 4", 476, [251,252,253,254,255,256],  "", [], "",  [], [], "", [], [], [78]),
  Lesson(79, "Shanghai 1", 477, [257,258,259,260,261,262],  "", [], "",  [], [], "", [], [], [79]),
  Lesson(80, "Shanghai 2", 477, [263,264,265,266,267,268],  "", [], "",  [], [], "", [], [], [80]),
];
