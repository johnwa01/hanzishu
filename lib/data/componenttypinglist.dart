import 'package:hanzishu/engine/component.dart';


var theLeadComponentList = [
  LeadComponent(0, "Ta", "撇", false, true, 1, 1, "C11.png", "nmdc", [4.0,0.6875,0.05,8.0,0.675,0.35,8.0,0.65,0.5,8.0,0.6125,0.6,8.0,0.55,0.7,8.0,0.45,0.8,8.0,0.25,0.92]),
  LeadComponent(1, "Ra", "八", true, true, 1, 2, "C12.png", "nmdc", []),
  LeadComponent(2, "Ea", "人", true, true, 1, 3, "C13.png", "nmdc", []),
  LeadComponent(3, "Wa", "艾字底", false, true, 1, 4, "C14.png", "nmdc", [4.0,0.75,0.05,8.0,0.6,0.475,8.0,0.5,0.65,8.0,0.325,0.85,8.0,0.025,0.975,4.0,0.2,0.05,8.0,0.325,0.375,8.0,0.5,0.65,8.0,0.725,0.825,8.0,0.925,0.925]),
  LeadComponent(4, "Qa", "周字框", false, true, 1, 5, "C15.png", "nmdc", [4.0,0.075,0.9375,8.0,0.1125,0.9,8.0,0.1625,0.8,8.0,0.2,0.65,8.0,0.2125,0.075,8.0,0.9,0.075,8.0,0.9,0.875,8.0,0.875,0.9,8.0,0.85,0.925,8.0,0.75,0.9875]),
  LeadComponent(5, "Ya", "竖", false, true, 2, 1, "C21.png", "nmdc", [4.0,0.5,0.0,8.0,0.5,1.0]),
  LeadComponent(6, "Ua", "上三框", false, true, 2, 2, "C22.png", "nmdc", [4.0,0.125,0.7,8.0,0.125,0.4,8.0,0.875,0.4,8.0,0.875,0.7]),
  LeadComponent(7, "Ia", "口", true, true, 2, 3, "C23.png", "nmdc", []),
  LeadComponent(8, "Oa", "日", true, true, 2, 4, "C24.png", "nmdc", []),
  LeadComponent(90, "Pa", "田", true, true, 2, 5, "C25.png", "nmdc", []),
  LeadComponent(10, "Ga", "一", true, true, 3, 1, "C31.png", "nmdc", []),
  LeadComponent(11, "Fa", "二", true, true, 3, 2, "C32.png", "nmdc", []),
  LeadComponent(12, "Da", "三", true, true, 3, 3, "C33.png", "nmdc", []),
  LeadComponent(13, "Sa", "七", true, true, 3, 4, "C34.png", "nmdc", []),
  LeadComponent(14, "Aa", "十", true, true, 3, 5, "C35.png", "nmdc", []),
  LeadComponent(15, "Ha", "点", false, true, 4, 1, "C41.png", "nmdc", [4.0,0.425,0.2,8.0,0.6,0.35]),
  LeadComponent(16, "Ja", "丁", true, true, 4, 2, "C42.png", "nmdc", []),
  LeadComponent(17, "Ka", "厂", true, true, 4, 3, "C43.png", "nmdc", []),
  LeadComponent(18, "La", "木", true, true, 4, 4,  "C44.png", "nmdc",[]),
  LeadComponent(19, "Ba", "乙", true, true, 5, 1, "C51.png", "nmdc", []),
  LeadComponent(20, "Va", "刀", true, true, 5, 2, "C52.png", "nmdc", []),
  LeadComponent(21, "Ca", "弓", true, true, 5, 3, "C53.png", "nmdc", []),
  LeadComponent(22, "Xa", "雪字底", false, true, 5, 4, "C54.png", "nmdc", [4.0,0.1625,0.475,8.0,0.825,0.475,8.0,0.825,0.8,4.0,0.2125,0.65,8.0,0.85,0.65,4.0,0.1625,0.7875,8.0,0.825,0.7875]),
  LeadComponent(23, "Na", "又", true, true, 6, 1, "C61.png", "nmdc", []),
  LeadComponent(24, "Ma", "厶", false, true, 6, 2, "C62.png", "nmdc", [4.0,0.7,0.075,8.0,0.65,0.25,8.0,0.625,0.35,8.0,0.575,0.45,8.0,0.5375,0.55,8.0,0.5,0.65,8.0,0.45,0.725,8.0,0.375,0.825,8.0,0.85,0.725,4.0,0.725,0.4125,8.0,0.7625,0.55,8.0,0.8125,0.65,8.0,0.85,0.725,8.0,0.9,0.875]),
];

// TODO: To be created in run time.
// We call lead component just component, and other components expanded components.
//var theLeadComponentList  = theComponentList;

var theComponentGroupList = [
  ComponentGroup(0, "GG6.png"),
  ComponentGroup(1, "GG5.png"),
  ComponentGroup(2, "G1.png"),
  ComponentGroup(3, "G2.png"),
  ComponentGroup(4, "G3.png"),
  ComponentGroup(5, "G4.png"),
  ComponentGroup(6, "G5.png"),
  ComponentGroup(7, "G6.png"),
];

var theComponentGroupListInRealExercise = [
  0,
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  1,
  4,
  6,
  2,
  7,
  5,
  3
];

var theComponentGroupWithIdList = [
  ComponentGroup(1, "GN1.png"),
  ComponentGroup(2, "GN2.png"),
  ComponentGroup(3, "GN3.png"),
  ComponentGroup(4, "GN4.png"),
  ComponentGroup(5, "GN5.png"),
  ComponentGroup(6, "GN6.png"),
];


var theComponentInGroupList = [
  ComponentInGroup(0, 3, 0),  // the group photo only
  ComponentInGroup(1, 3, 3),
  ComponentInGroup(2, 3, 1),
  ComponentInGroup(3, 3, 4),
  ComponentInGroup(4, 3, 2),
  ComponentInGroup(5, 3, 5),
  ComponentInGroup(6, 2, 0),  // the group photo only
  ComponentInGroup(7, 2, 3),
  ComponentInGroup(8, 2, 4),
  ComponentInGroup(9, 2, 1),
  ComponentInGroup(10, 2, 5),
  ComponentInGroup(11, 2, 2),
  ComponentInGroup(12, 5, 0),  // the group photo only
  ComponentInGroup(13, 5, 2),
  ComponentInGroup(14, 5, 4),
  ComponentInGroup(15, 5, 1),
  ComponentInGroup(16, 5, 3),
  ComponentInGroup(17, 4, 0),  // the group photo only
  ComponentInGroup(18, 4, 3),
  ComponentInGroup(19, 4, 1),
  ComponentInGroup(20, 4, 4),
  ComponentInGroup(21, 4, 2),
  ComponentInGroup(22, 6, 0),  // the group photo only
  ComponentInGroup(23, 6, 2),
  ComponentInGroup(24, 6, 1),
  ComponentInGroup(25, 1, 0),  // the group photo only
  ComponentInGroup(26, 1, 3),
  ComponentInGroup(27, 1, 5),
  ComponentInGroup(28, 1, 4),
  ComponentInGroup(29, 1, 1),
  ComponentInGroup(30, 1, 2),
];

var theRandomComponentList = [
  ComponentInGroup(0, 0, 0),  // the whole components photo only
  ComponentInGroup(1, 3, 2),
  ComponentInGroup(2, 1, 1),
  ComponentInGroup(3, 2, 5),
  ComponentInGroup(4, 4, 2),
  ComponentInGroup(5, 5, 2),
  ComponentInGroup(6, 6, 1),
  ComponentInGroup(7, 0, 0),  // the whole components photo only
  ComponentInGroup(8, 4, 3),
  ComponentInGroup(9, 2, 4),
  ComponentInGroup(11, 5, 4),
  ComponentInGroup(12, 1, 4),
  ComponentInGroup(13, 4, 4),
  ComponentInGroup(10, 2, 1),
  ComponentInGroup(14, 3, 1),
  ComponentInGroup(15, 1, 5),
  ComponentInGroup(16, 6, 2),
  ComponentInGroup(17, 0, 0),  // the whole components photo only
  ComponentInGroup(18, 5, 1),
  ComponentInGroup(19, 3, 3),
  ComponentInGroup(20, 1, 3),
  ComponentInGroup(21, 2, 2),
  ComponentInGroup(22, 4, 1),
  ComponentInGroup(23, 3, 4),
  ComponentInGroup(24, 2, 3),
  ComponentInGroup(25, 5, 3),
  ComponentInGroup(26, 1, 2),
  ComponentInGroup(27, 3, 5),
];

var theExpandedComponentList = [
  ComponentCollection(0, "EF24Sample.png", 0, 0, "Explaination Text"),
  ComponentCollection(1, "E24.png", 2, 4, "square plus horizontal line"),
  ComponentCollection(2, "E13.png", 1, 3, "which common shape"),
  ComponentCollection(3, "E23.png", 2, 3, "which common shape"),
  ComponentCollection(4, "E53.png", 5, 3, "containing a stroke with a few turns"),
  ComponentCollection(5, "E42.png", 4, 2, "overall looking of the shape"),
  ComponentCollection(6, "E11.png", 1, 1, "1st stroke or not fitting into others"),
  ComponentCollection(7, "E25.png", 2, 5, "square plus a cross"),
  ComponentCollection(8, "E44.png", 4, 4, "which common shape"),
  ComponentCollection(9, "E31.png", 3, 1, "1st stroke or count of horizontal lines"),
  ComponentCollection(10, "E62.png", 6, 2, "twisted triangle shape"),
  ComponentCollection(11, "E34.png", 3, 4, "a curve crosses a horizontal line"),
  ComponentCollection(12, "E41.png", 4, 1, "1st stroke or not fitting into others"),
  ComponentCollection(13, "E14.png", 1, 4, "significant diagonal crosses"),
  ComponentCollection(14, "E22.png", 2, 2, "which common shape"),
  ComponentCollection(15, "E43.png", 4, 3, "overall looking of the shape"),
  ComponentCollection(16, "E52.png", 5, 2, "overall looking of the shape"),
  ComponentCollection(17, "E61.png", 6, 1, "which common shape"),
  ComponentCollection(18, "E12.png", 1, 2, "separate or go left and right"),
  ComponentCollection(19, "E33.png", 3, 3, "number of horizontal lines"),
  ComponentCollection(20, "E32.png", 3, 2, "number of horizontal lines"),
  ComponentCollection(21, "E51.png", 5, 1, "all but two first strokes are fold strokes"),
  ComponentCollection(22, "E54.png", 5, 4, "which common shape"),
  ComponentCollection(23, "E15.png", 1, 5, "which common shape"),
  ComponentCollection(24, "E21.png", 2, 1, "1st stroke or not fitting into others"),
  ComponentCollection(25, "E35.png", 3, 5, "which common shape"),
];

var theFullExpandedComponentList = [
  ComponentCollection(0, "EF11.png", 1, 1, ""),
  ComponentCollection(1, "EF12.png", 1, 2, ""),
  ComponentCollection(2, "EF13.png", 1, 3, ""),
  ComponentCollection(3, "EF14.png", 1, 4, ""),
  ComponentCollection(4, "EF15.png", 1, 5, ""),
  ComponentCollection(5, "EF21.png", 2, 1, ""),
  ComponentCollection(6, "EF22.png", 2, 2, ""),
  ComponentCollection(7, "EF23.png", 2, 3, ""),
  ComponentCollection(8, "EF24.png", 2, 4, ""),
  ComponentCollection(9, "EF25.png", 2, 5, ""),
  ComponentCollection(10, "EF31.png", 3, 1, ""),
  ComponentCollection(11, "EF32.png", 3, 2, ""),
  ComponentCollection(12, "EF33.png", 3, 3, ""),
  ComponentCollection(13, "EF34.png", 3, 4, ""),
  ComponentCollection(14, "EF35.png", 3, 5, ""),
  ComponentCollection(15, "EF41.png", 4, 1, ""),
  ComponentCollection(16, "EF42.png", 4, 2, ""),
  ComponentCollection(17, "EF43.png", 4, 3, ""),
  ComponentCollection(18, "EF44.png", 4, 4, ""),
  ComponentCollection(19, "EF51.png", 5, 1, ""),
  ComponentCollection(20, "EF52.png", 5, 2, ""),
  ComponentCollection(21, "EF53.png", 5, 3, ""),
  ComponentCollection(22, "EF54.png", 5, 4, ""),
  ComponentCollection(23, "EF61.png", 6, 1, ""),
  ComponentCollection(24, "EF62.png", 6, 2, ""),
];

var theZiForIntroductionList=[
  ZiWithComponentsAndStrokes("键", ["Tl", "Xh", "B2"], "GG6.png", ""), //index only, not used
  ZiWithComponentsAndStrokes("人", ["Ea"], "", "Tap 人 in the list below."),
  //ZiWithComponentsAndStrokes("分", ["Ra", "Va"], "", "八 > r, 刀 > v"),
  ZiWithComponentsAndStrokes("分", ["Ra", "Va"], "", "Type 'r', spacebar."),
  ZiWithComponentsAndStrokes("品", ["Ia", "Ia", "Ia"], "", "口 > i, 口 > i, tap 品."),
  //ZiWithComponentsAndStrokes("晶", ["Oa", "Oa", "Oa"], "501.png", "日 > o, 日 > o, 日 > o"),
  ZiWithComponentsAndStrokes("厅", ["Ka", "Ja"], "", "厂 > k, 丁 > j, tap 厅."),  // move down
  ZiWithComponentsAndStrokes("支", ["Aa", "Na"], "", "十 > a, 又 > n, spacebar."),
  ZiWithComponentsAndStrokes("查", ["La", "Oa", "Ga"], "", "木 > l, 日 > o, 一 > g"),
  ZiWithComponentsAndStrokes("昭", ["Oa", "Va", "Ia"], "", "日 > o, 刀 > v, 口 > i"),
  // ZiWithComponentsAndStrokes("哈", ["Ia", "Ea", "Ga", "Ia"], "", "口 > i,人 > e,一 > g,口 > i"), // enough. limit the numbers.
];

var theZiForLeadCompExerciseList=[
  ZiWithComponentsAndStrokes("双", ["Na", "Na"], "500.png", ""),
  ZiWithComponentsAndStrokes("森", ["La", "La", "La"], "503.png", ""),
  ZiWithComponentsAndStrokes("引", ["Ca", "Ya"], "502.png", ""),
  ZiWithComponentsAndStrokes("叶", ["Ia", "Aa"], "504.png", ""),
  ZiWithComponentsAndStrokes("一", ["Ga"], "456.png", ""),
  ZiWithComponentsAndStrokes("二", ["Fa"], "451.png", "Reminder: For a character containing a single component, after typing the component, if needed, you can continue to type up to three strokes of the character: 1st, 2nd and last stroke."),
  ZiWithComponentsAndStrokes("三", ["Da"], "505.png", ""),
  ZiWithComponentsAndStrokes("召", ["Va", "Ia"], "506.png", ""),
  ZiWithComponentsAndStrokes("义", ["Wa", "Ha"], "501.png", ""),
  ZiWithComponentsAndStrokes("晶", ["Oa", "Oa", "Oa"], "", ""),
  //ZiWithComponentsAndStrokes("田", ["Pa"], "509.png", "Reminder: For a character containing a single component, after typing the component, if needed, you can continue to type up to three strokes of the character: 1st, 2nd and last stroke."),   // da shu 'y'
  ZiWithComponentsAndStrokes("公", ["Ra", "Ma"], "510.png", ""),
  ZiWithComponentsAndStrokes("乙", ["Ba"], "511.png", "Reminder: For a character containing a single component, after typing the component, if needed, you can continue to type up to three strokes of the character: 1st, 2nd and last stroke."),  // da 'b'
  ZiWithComponentsAndStrokes("旧", ["Ya", "Oa"], "512.png", ""),
  ZiWithComponentsAndStrokes("乇", ["Ta", "Sa"], "513.png", "Reminder: For a character containing two components, after typing the two components, if needed, you can continue to type up to two strokes: the last stroke from the 1st component, and the last stroke from the 2nd component."),
  ZiWithComponentsAndStrokes("合", ["Ea", "Ga", "Ia"], "514.png", ""),
  ZiWithComponentsAndStrokes("哈", ["Ia", "Ea", "Ga", "Ia"], "", ""),
];
// 月 巾  雪

var theZiForExpandedCompExerciseList=[
  //ZiWithComponentsAndStrokes("呆", ["Ia", "La"], "515.png", ""), //
  //ZiWithComponentsAndStrokes("从", ["Ea", "Ea"], "516.png", ""),   //
  //ZiWithComponentsAndStrokes("旦", ["Oa", "Ga"], "517.png", ""),  //
  //ZiWithComponentsAndStrokes("旷", ["Oa", "Kb"], "519.png", "->"),
  ZiWithComponentsAndStrokes("客", ["Ha", "Na", "Ia"], "497.png", ""),
  //ZiWithComponentsAndStrokes("叮", ["Ia", "Ja"], "518.png", "Use make-up strokes as needed."),
  ZiWithComponentsAndStrokes("你", ["Ta", "Ta", "Ya"], "490.png", ""),
  ZiWithComponentsAndStrokes("谢", ["Ha", "Oa", "Ja"], "491.png", ""),
  ZiWithComponentsAndStrokes("卖", ["Aa", "Ba", "Ha", "Ea"], "492.png", ""),
  ZiWithComponentsAndStrokes("师", ["Ya", "Ga", "Ua"], "493.png", ""),
  ZiWithComponentsAndStrokes("您", ["Ta", "Ta", "Ya", "Ha"], "494.png", ""),
  //ZiWithComponentsAndStrokes("学", ["Ha", "Ha", "Ja"], "496.png", ""),
  ZiWithComponentsAndStrokes("起", ["Aa", "Ya", "Sa"], "498.png", ""),
  ZiWithComponentsAndStrokes("没", ["Ha", "Ba", "Na"], "499.png", ""),
  ZiWithComponentsAndStrokes("会", ["Ea", "Ga", "Ma"], "488.png", "If there are two options to separate components, choose the option that contains a component with more strokes."),
  ZiWithComponentsAndStrokes("同", ["Ua", "Ga", "Oa"], "495.png", ""),
  //ZiWithComponentsAndStrokes("双", ["Na", "Na"], "460.png", ""),
  //ZiWithComponentsAndStrokes("明", ["Oa", "Qa"], "461.png", ""),
  ZiWithComponentsAndStrokes("好", ["Wa", "Ja"], "462.png", ""),
  ZiWithComponentsAndStrokes("多", ["Na", "Na"], "463.png", ""),
  ZiWithComponentsAndStrokes("岁", ["Ya", "Na"], "464.png", ""),
  ZiWithComponentsAndStrokes("六", ["Ha", "Ra"], "465.png", ""),
  ZiWithComponentsAndStrokes("老", ["Aa", "Sa"], "466.png", ""),
  ZiWithComponentsAndStrokes("再", ["Ga", "Aa"], "467.png", ""),
  ZiWithComponentsAndStrokes("们", ["Ta", "Ua"], "468.png", ""),
  ZiWithComponentsAndStrokes("对", ["Na", "Ja"], "469.png", ""),
  //ZiWithComponentsAndStrokes("关", ["Ha", "Ea"], "470.png", ""),
  //ZiWithComponentsAndStrokes("系", ["Ta", "Ma"], "471.png", ""),
  /*
  ZiWithComponentsAndStrokes("人", ["Ea"], "452.png", ""),
  ZiWithComponentsAndStrokes("大", ["Ea"], "453.png", ""),
  ZiWithComponentsAndStrokes("不", ["Ga"], "455.png", ""),
  ZiWithComponentsAndStrokes("了", ["Ja"], "454.png", ""),
  ZiWithComponentsAndStrokes("我", ["Wa"], "457.png", ""),
  ZiWithComponentsAndStrokes("见", ["Ua"], "450.png", ""),
  ZiWithComponentsAndStrokes("气", ["Fa"], "458.png", ""),
  ZiWithComponentsAndStrokes("下", ["Ga"], "459.png", ""),
   */
  //example for fold strokes not in the table.
];

//var theComponentList = [
//  Component("Aa", "", false, "", "", [4.0,0.125,0.7,8.0,0.125,0.4,8.0,0.875,0.4,8.0,0.875,0.7]),
//];