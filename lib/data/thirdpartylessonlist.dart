import 'package:hanzishu/engine/thirdpartylesson.dart';


var theThirdPartyList = [
  ThirdParty(ThirdPartyType.yuwen, 490), // Yuwen
  ThirdParty(ThirdPartyType.sunlaoshi, 517), // Yuwen
  ThirdParty(ThirdPartyType.yuwenAll, 526), // YuwenAll
];

var theThirdPartyLevelList = [
  ThirdPartyLevel(ThirdPartyType.yuwen, '', 1, "l1"), // 100: temp
  ThirdPartyLevel(ThirdPartyType.yuwen, '', 2, "l2"), // 100: temp
  ThirdPartyLevel(ThirdPartyType.sunlaoshi, '', 1, "t1"), // 100: temp
  ThirdPartyLevel(ThirdPartyType.sunlaoshi, '', 2, "t2"), // 100: temp
  ThirdPartyLevel(ThirdPartyType.yuwenAll, '2017', 4, "l4"), // 100: temp
  ThirdPartyLevel(ThirdPartyType.yuwenAll, '2019', 8, "l8"), // 100: temp
];

var theThirdPartyLessonList = [
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 1, 1, "s2"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 1, 2, "s3"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 1, 3, "s4"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 1, 4, "s5"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 1, 5, "k1"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 1, 6, "k2"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 1, 7, "k3"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 1, 8, "k4"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 1, 9, "s6"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 1, 10, "s7"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 1, 11, "s8"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 1, 12, "s9"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 1, 13, "s10"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 1, 14, "k5"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 1, 15, "k6"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 1, 16, "k7"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 1, 17, "k8"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 1, 18, "k9"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 1, 19, "k10"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 1, 20, "k11"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 1, 21, "k12"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 1, 22, "k13"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 1, 23, "k14"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 2, 24, "s1"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 2, 25, "s2"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 2, 26, "s3"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 2, 27, "s4"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 2, 28, "k1"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 2, 29, "k2"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 2, 30, "k3"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 2, 31, "k4"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 2, 32, "k5"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 2, 33, "k6"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 2, 34, "k7"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 2, 35, "k8"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 2, 36, "k9"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 2, 37, "k10"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 2, 38, "k11"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 2, 39, "s5"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 2, 40, "s6"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 2, 41, "s7"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 2, 42, "s8"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 2, 43, "k12"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 2, 44, "k13"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 2, 45, "k14"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 2, 46, "k15"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 2, 47, "k16"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 2, 48, "k17"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 2, 49, "k18"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 2, 50, "k19"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 2, 51, "k20"),
  ThirdPartyLesson(ThirdPartyType.yuwen, '', 2, 52, "k21"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 1, 1, "m1"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 1, 2, "m2"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 1, 3, "m3"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 1, 4, "m4"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 1, 5, "m5"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 1, 6, "m6"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 1, 7, "m7"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 1, 8, "m8"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 1, 9, "m9"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 1, 10, "m10"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 1, 11, "m11"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 1, 12, "m12"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 1, 13, "m13"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 1, 14, "m14"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 1, 15, "m15"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 1, 16, "m16"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 2, 17, "m17"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 2, 18, "m18"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 2, 19, "m19"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 2, 20, "m20"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 2, 21, "m21"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 2, 22, "m22"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 2, 23, "m23"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 2, 24, "m24"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 2, 25, "m25"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 2, 26, "m26"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 2, 27, "m27"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 2, 28, "m28"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 2, 29, "m29"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 2, 30, "m30"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 2, 31, "m31"),
  ThirdPartyLesson(ThirdPartyType.sunlaoshi, '', 2, 32, "m32"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 1, "1（A）. 古诗二首：村居"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 2, "1（B）. 古诗二首：咏柳"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 3, "2. 找春天"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 4, "3. 开满鲜花的小路"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 5, "4. 邓小平爷爷植树"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 6, "A. 语文园地1: 识字加油站"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 7, "B. 语文园地1: 赋得古原草送别"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 8, "C. 语文园地1: 笋茅儿"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 9, "5. 雷锋叔叔，你在哪里"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 10, "6. 千人糕"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 11, "7. 一匹出色的马"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 12, "D. 识字加油站"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 13, "E. 日积月累"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 14, "F. 一株紫丁香"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 15, "G. 神州谣"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 16, "H. 传统节日"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 17, "I. 贝的故事"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 18, "J. 中国美食"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 19, "K. 汉字加油站"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 20, "L. 日积月累"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 21, "M. 小柳树和小枣树"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 22, "8. 彩色的梦"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 23, "9. 枫树上的喜鹊"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 24, "10. 沙滩上的童话"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 25, "11. 我是一只小虫子"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 26, "N. 识字加油站"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 27, "O. 日积月累"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 28, "P. 手影戏"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 29, "12 (A). 亡羊补牢"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 30, "12 (B). 揠苗助长"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 31, "13. 画杨桃"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 32, "14. 小马过河"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 33, "Q. 日积月累"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 34, "R. 好天气和坏天气"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 35, "15 (A). 晓出净慈寺送林子方"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 36, "15 (B). 绝句 唐 杜甫"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 37, "16. 雷雨"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 38, "17. 要是你在野外迷了路"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 39, "18. 太空生活趣事多"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 40, "S. 悯农"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 41, "T. 最大的书"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 42, "19. 大象的耳朵"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 43, "20. 蜘蛛开店"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 44, "21. 青蛙卖泥塘"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 45, "22. 小毛虫"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 46, "U. 二十四节气歌"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 47, "V. 月亮姑娘做衣裳"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 48, "23. 祖先的摇篮"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 49, "24. 羿射九日"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 50, "25. 黄帝的传说"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 51, "W. 舟夜书所见"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2017', 4, 52, "X. 李时珍"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 53, "第1单元 1. 古诗词三首 四时田园杂兴"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 54, "1A. 宿新市徐公店"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 55, "1B. 清平乐 村居"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 56, "2. 乡下人家"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 57, "3. 天窗"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 58, "4. 三月桃花水"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 59, "4A. 日积月累"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 60, "第2单元 5. 琥珀"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 61, "6. 飞向蓝天的恐龙"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 62, "7. 纳米技术就在我们身边"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 63, "8. 千年梦圆在今朝"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 64, "8A. 日积月累"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 65, "第3单元 9. 短诗三首 繁星 (七一)"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 66, "9A. 繁星 (一三一)"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 67, "9B. 繁星 (一五九)"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 68, "10. 绿"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 69, "11. 白桦"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 70, "12. 天晴了的时候"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 71, "12A. 日积月累 诗和音乐一样生命"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 72, "13. 猫"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 73, "14. 母鸡"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 74, "15. 白鹅"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 75, "15A. 日积月累 蜂"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 76, "第5单元 16 海上日出"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 77, "17. 记金华的双龙洞"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 78, "17A. 习作例文 颐和园"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 79, "17B. 7月的天山"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 80, "第6单元 18. 小英雄雨来"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 81, "19. 我们家的男子汉"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 82, "20. 芦花鞋"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 83, "20A. 日积月累 独坐敬亭山"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 84, "第7单元 21. 古诗三首 芙蓉镇送辛渐"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 85, "21A. 塞下曲"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 86, "21B. 墨梅"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 87, "22. 文言文二则 囊萤夜读"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 88, "22A. 铁杵成针"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 89, "23. 诺曼底号遇难记"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 90, "24. 黄继光"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 91, "24A. 日积月累"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 92, "第8单元 25. 宝葫芦的秘密"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 93, "26. 巨人的花园"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 94, "27. 海的女儿"),
  ThirdPartyLesson(ThirdPartyType.yuwenAll, '2019', 8, 95, "27A. 日积月累"),
];
