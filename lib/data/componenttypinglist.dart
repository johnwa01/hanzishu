import 'package:hanzishu/engine/component.dart';
import 'package:hanzishu/utility.dart';

/*
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
  LeadComponent(9, "Pa", "田", true, true, 2, 5, "C25.png", "nmdc", []),
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
*/

var theLeadComponentList = [
  LeadComponent(1, "Oa", "口", true, true, 2, 4, "C24.png", "nmdc", []),
  LeadComponent(2, "Ta", "丁", true, true, 1, 1, "C11.png", "nmdc", []),
  LeadComponent(3, "Ea", "王", false, true, 1, 3, "C13.png", "nmdc", [4.0,0.45,0.375,8.0,0.9,0.375,4.0,0.45,0.375,8.0,0.45,0.625,8.0,0.45,0.925,8.0,0.9,0.925,4.0,0.3,0.625,8.0,0.45,0.625,8.0,0.975,0.625]),
  LeadComponent(4, "Aa", "人", true, true, 3, 5, "C35.png", "nmdc", []),
  LeadComponent(5, "Qa", "田", true, true, 1, 5, "C15.png", "nmdc", []),
  LeadComponent(6, "Ca", "区字框", false, true, 5, 3, "C53.png", "nmdc", [4.0,0.125,0.1,8.0,0.875,0.1,4.0,0.125,0.1,8.0,0.125,0.9,8.0,0.925,0.9]),
  LeadComponent(7, "Ua", "画字框", true, true, 2, 2, "C22.png", "nmdc", [4.0,0.125,0.25,8.0,0.125,0.85,8.0,0.875,0.85,8.0,0.875,0.25]),
  LeadComponent(8, "Ia", "竖", false, true, 2, 3, "C23.png", "nmdc", [4.0,0.5,0.0,8.0,0.5,1.0]),
  LeadComponent(9, "Ro", "尺", true, true, 1, 2, "C12.png", "nmdc", []),
  LeadComponent(10, "Pa", "单耳", false, true, 2, 5, "C25.png", "nmdc", [4.0,0.475,0.05,8.0,0.475,0.975,4.0,0.475,0.05,8.0,0.8,0.05,8.0,0.8,0.225,8.0,0.7875,0.25,8.0,0.75,0.275,8.0,0.6,0.3]),
  LeadComponent(11, "Ga", "厶", false, true, 3, 1, "C31.png", "nmdc", [4.0,0.7,0.075,8.0,0.65,0.25,8.0,0.625,0.35,8.0,0.575,0.45,8.0,0.5375,0.55,8.0,0.5,0.65,8.0,0.45,0.725,8.0,0.375,0.825,8.0,0.85,0.725,4.0,0.725,0.4125,8.0,0.7625,0.55,8.0,0.8125,0.65,8.0,0.85,0.725,8.0,0.9,0.875]),
  LeadComponent(12, "Fa", "厂", true, true, 3, 2, "C32.png", "nmdc", []),
  LeadComponent(13, "Da", "雪字底", false, true, 3, 3, "C33.png", "nmdc", [4.0,0.1625,0.475,8.0,0.825,0.475,8.0,0.825,0.8,4.0,0.2125,0.65,8.0,0.85,0.65,4.0,0.1625,0.7875,8.0,0.825,0.7875]),
  LeadComponent(14, "Sa", "弓", true, true, 3, 4, "C34.png", "nmdc", []),
  LeadComponent(15, "Wa", "三", true, true, 1, 4, "C14.png", "nmdc", []),
  LeadComponent(16, "Ha", "一", true, true, 4, 1, "C41.png", "nmdc", []),
  LeadComponent(17, "Ja", "撇", false, true, 4, 2, "C42.png", "nmdc", [4.0,0.6875,0.05,8.0,0.675,0.35,8.0,0.65,0.5,8.0,0.6125,0.6,8.0,0.55,0.7,8.0,0.45,0.8,8.0,0.25,0.92]),
  LeadComponent(18, "Ka", "十", true, true, 4, 3, "C43.png", "nmdc", []),
  LeadComponent(19, "La", "竖折", false, true, 4, 4, "C44.png", "nmdc", [4.0,0.175,0.125,8.0,0.175,0.875,8.0,0.775,0.875]),
  LeadComponent(20, "Ba", "日", true, true, 5, 1, "C51.png", "nmdc", []),
  LeadComponent(21, "Va", "八", true, true, 5, 2, "C52.png", "nmdc", []),
  LeadComponent(22, "Ya", "点", false, true, 2, 1, "C21.png", "nmdc", [4.0,0.425,0.2,8.0,0.6,0.35]),
  LeadComponent(23, "Xa", "艾字底", false, true, 5, 4, "C54.png", "nmdc", [4.0,0.75,0.05,8.0,0.6,0.475,8.0,0.5,0.65,8.0,0.325,0.85,8.0,0.025,0.975,4.0,0.2,0.05,8.0,0.325,0.375,8.0,0.5,0.65,8.0,0.725,0.825,8.0,0.925,0.925]),
  LeadComponent(24, "Na", "同字框", false, true, 6, 1, "C61.png", "nmdc", [4.0,0.125,0.075,8.0,0.125,0.95,4.0,0.125,0.075,8.0,0.875,0.075,8.0,0.875,0.85,8.0,0.85,0.8875,8.0,0.8,0.9,8.0,0.7125,0.9125]),
  LeadComponent(25, "Ma", "木", true, true, 6, 2,  "C62.png", "nmdc",[]),
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
  ComponentInGroup(1, 2, 4),
  ComponentInGroup(2, 1, 1),
  ComponentInGroup(3, 2, 5),
  ComponentInGroup(4, 4, 2),
  ComponentInGroup(5, 5, 2),
  ComponentInGroup(6, 6, 1),
  ComponentInGroup(7, 0, 0),  // the whole components photo only
  ComponentInGroup(12, 1, 4),
  ComponentInGroup(11, 5, 4),
  ComponentInGroup(8, 4, 3),
  ComponentInGroup(9, 3, 2),
  ComponentInGroup(13, 4, 4),
  ComponentInGroup(10, 2, 1),
  ComponentInGroup(14, 3, 1),
  ComponentInGroup(15, 1, 5),
  ComponentInGroup(16, 6, 2),
  ComponentInGroup(17, 0, 0),  // the whole components photo only
  ComponentInGroup(20, 1, 3),
  ComponentInGroup(18, 5, 1),
  ComponentInGroup(19, 3, 3),
  ComponentInGroup(21, 2, 2),
  ComponentInGroup(22, 4, 1),
  ComponentInGroup(23, 3, 4),
  ComponentInGroup(24, 2, 3),
  ComponentInGroup(25, 5, 3),
  ComponentInGroup(26, 1, 2),
  ComponentInGroup(27, 3, 5),
];

var theExpandedComponentList = [
  ComponentCollection(0, "E51.png", 0, 0, 0/*"Explaination Text"*/),
  ComponentCollection(1, "E24.png", 2, 4, 315/*"closed shape"*/),
  ComponentCollection(2, "E13.png", 1, 3, 316/*"like E"*/),
  ComponentCollection(3, "E23.png", 2, 3, 342/*"the verticle line"*/),
  ComponentCollection(4, "E53.png", 5, 3, 317/*"open to right"*/),
  ComponentCollection(5, "E42.png", 4, 2, 318/*"curve toward bottom left"*/),
  ComponentCollection(6, "E11.png", 1, 1, 319/*"overall T shape looking"*/),
  ComponentCollection(7, "E25.png", 2, 5, 320/*"hammer looking"*/),
  ComponentCollection(8, "E44.png", 4, 4, 343/*"Overall L shape looking"*/),
  ComponentCollection(9, "E31.png", 3, 1, 321/*"disconnected triangle"*/),
  ComponentCollection(10, "E62.png", 6, 2, 322/*"a shape with three legs"*/),
  ComponentCollection(11, "E34.png", 3, 4, 323/*"half circle shape"*/),
  ComponentCollection(12, "E41.png", 4, 1, 344/*"the horizontal line"*/),
  ComponentCollection(13, "E14.png", 1, 4, 324/*"mountain like shape"*/),
  ComponentCollection(14, "E22.png", 2, 2, 345/*"open to top"*/),
  ComponentCollection(15, "E43.png", 4, 3, 346/*"crossing at middle"*/),
  ComponentCollection(16, "E52.png", 5, 2, 347/*"split shapes"*/),
  ComponentCollection(17, "E61.png", 6, 1, 348/*"open to bottom"*/),
  ComponentCollection(18, "E12.png", 1, 2, 325/*"two legs"*/),
  ComponentCollection(19, "E33.png", 3, 3, 326/*"facing left"*/),
  ComponentCollection(20, "E32.png", 3, 2, 349/*"shelter looking"*/),
  ComponentCollection(21, "E51.png", 5, 1, 327/*"closed shape with horizontal lines"*/),
  ComponentCollection(22, "E54.png", 5, 4, 350/*"diagonal crossing"*/),
  ComponentCollection(23, "E15.png", 1, 5, 351/*"closed shape with crossing"*/),
  ComponentCollection(24, "E21.png", 2, 1, 352/*"the first stroke"*/),
  ComponentCollection(25, "E35.png", 3, 5, 353/*"upward arrow"*/),
];

/*
var theReviewExpandedComponentList = [
  //ComponentCollection(0, "", 0, 0, "component"),
  ComponentCollection(0, "EF24.png", 2, 4, "自"),
  ComponentCollection(1, "EF13.png", 1, 3, "火"),
  ComponentCollection(2, "EF23.png", 2, 3, "中"),
  ComponentCollection(3, "EF53.png", 5, 3, "弗"),
  ComponentCollection(4, "EF42.png", 4, 2, "于"),
  ComponentCollection(5, "EF11.png", 1, 1, "片"),
  ComponentCollection(6, "EF25.png", 2, 5, "甲"),
  ComponentCollection(7, "EF44.png", 4, 4, "本"),
  ComponentCollection(8, "EF31.png", 3, 1, "卅"),
  ComponentCollection(9, "EF62.png", 6, 2, "幺"),
  ComponentCollection(10, "EF34.png", 3, 4, "匕"),
  ComponentCollection(11, "EF41.png", 4, 1, "心"),
  ComponentCollection(12, "EF14.png", 1, 4, "丈"),
  ComponentCollection(13, "EF22.png", 2, 2, "巾"),
  ComponentCollection(14, "EF43.png", 4, 3, "广"),
  ComponentCollection(15, "EF52.png", 5, 2, "刁"),
  ComponentCollection(16, "EF61.png", 6, 1, "皮"),
  ComponentCollection(17, "EF12.png", 1, 2, "川"),
  ComponentCollection(18, "EF33.png", 3, 3, "王"),
  ComponentCollection(19, "EF32.png", 3, 2, "工"),
  ComponentCollection(20, "EF51.png", 5, 1, "飞"),
  ComponentCollection(21, "EF54.png", 5, 4, "聿"),
  ComponentCollection(22, "EF15.png", 1, 5, "月"),
  ComponentCollection(23, "EF21.png", 2, 1, "卜"),
  ComponentCollection(24, "EF35.png", 3, 5, "土"),
];
*/

var theFullExpandedComponentList = [
  ComponentCollection(0, "EF11.png", 1, 1, 0),
  ComponentCollection(1, "EF12.png", 1, 2, 0),
  ComponentCollection(2, "EF13.png", 1, 3, 0),
  ComponentCollection(3, "EF14.png", 1, 4, 0),
  ComponentCollection(4, "EF15.png", 1, 5, 0),
  ComponentCollection(5, "EF21.png", 2, 1, 0),
  ComponentCollection(6, "EF22.png", 2, 2, 0),
  ComponentCollection(7, "EF23.png", 2, 3, 0),
  ComponentCollection(8, "EF24.png", 2, 4, 0),
  ComponentCollection(9, "EF25.png", 2, 5, 0),
  ComponentCollection(10, "EF31.png", 3, 1, 0),
  ComponentCollection(11, "EF32.png", 3, 2, 0),
  ComponentCollection(12, "EF33.png", 3, 3, 0),
  ComponentCollection(13, "EF34.png", 3, 4, 0),
  ComponentCollection(14, "EF35.png", 3, 5, 0),
  ComponentCollection(15, "EF41.png", 4, 1, 0),
  ComponentCollection(16, "EF42.png", 4, 2, 0),
  ComponentCollection(17, "EF43.png", 4, 3, 0),
  ComponentCollection(18, "EF44.png", 4, 4, 0),
  ComponentCollection(19, "EF51.png", 5, 1, 0),
  ComponentCollection(20, "EF52.png", 5, 2, 0),
  ComponentCollection(21, "EF53.png", 5, 3, 0),
  ComponentCollection(22, "EF54.png", 5, 4, 0),
  ComponentCollection(23, "EF61.png", 6, 1, 0),
  ComponentCollection(24, "EF62.png", 6, 2, 0),
];

var theZiForIntroductionList=[
  ZiWithComponentsAndStrokes("键", ["Tl", "Xh", "B2"], "GG6.png", 0), //index only, not used
  ZiWithComponentsAndStrokes("人", ["Ea"], "", 298/*"Tap 人 in the list below."*/),
  //ZiWithComponentsAndStrokes("分", ["Ra", "Va"], "", "八 > r, 刀 > v"),
  ZiWithComponentsAndStrokes("分", ["Ra", "Va"], "", 299/*"Type 'r', spacebar."*/),
  ZiWithComponentsAndStrokes("品", ["Ia", "Ia", "Ia"], "", 0/*"口 : i, 口 : i, tap 品."*/),
  //ZiWithComponentsAndStrokes("晶", ["Oa", "Oa", "Oa"], "501.png", 0/*"日 > o, 日 > o, 日 > o"*/),
  ZiWithComponentsAndStrokes("厅", ["Ka", "Ja"], "", 0/*"厂 : k, 丁 : j, tap 厅."*/),  // move down
  ZiWithComponentsAndStrokes("支", ["Aa", "Na"], "", 0/*"十 : a, 又 : n, " + getString(300)*/),
  ZiWithComponentsAndStrokes("查", ["La", "Oa", "Ga"], "", 0/*"木 : l, 日 : o, 一 : g"*/),
  ZiWithComponentsAndStrokes("昭", ["Oa", "Va", "Ia"], "", 0/*"日 : o, 刀 : v, 口 : i"*/),
  // ZiWithComponentsAndStrokes("哈", ["Ia", "Ea", "Ga", "Ia"], "", "口 > i,人 > e,一 > g,口 > i"), // enough. limit the numbers.
];

var theZiForLeadCompExerciseList=[
  ZiWithComponentsAndStrokes("键", [], "GG6.png", 110), //hintText ID
  ZiWithComponentsAndStrokes("品", [], "", 0),
  ZiWithComponentsAndStrokes("森", [], "", 0),
  ZiWithComponentsAndStrokes("晶", [], "", 0),
  //ZiWithComponentsAndStrokes("合", [], "", 0),
  //ZiWithComponentsAndStrokes("同", [], "", 0),
  //ZiWithComponentsAndStrokes("哈", [], "", 0),
  //ZiWithComponentsAndStrokes("昼", [], "", 0),
  //ZiWithComponentsAndStrokes("查", [], "", 0),
  //ZiWithComponentsAndStrokes("画", [], "", 0),
  ZiWithComponentsAndStrokes("网", [], "", 0),
  //ZiWithComponentsAndStrokes("命", [], "", 0),
  //ZiWithComponentsAndStrokes("晌", [], "", 0),
  ZiWithComponentsAndStrokes("松", [], "", 0),
  ZiWithComponentsAndStrokes("框", [], "", 0),
  ZiWithComponentsAndStrokes("苔", [], "", 0),
  ZiWithComponentsAndStrokes("苦", [], "", 0),
  ZiWithComponentsAndStrokes("架", [], "", 0),
  ZiWithComponentsAndStrokes("岗", [], "", 0),
  ZiWithComponentsAndStrokes("谷", [], "", 0),
  //ZiWithComponentsAndStrokes("向", [], "", 0),
  ZiWithComponentsAndStrokes("枯", [], "", 0),

  /*
  ZiWithComponentsAndStrokes("双", ["Na", "Na"], "500.png", ""),
  ZiWithComponentsAndStrokes("引", ["Ca", "Ya"], "502.png", ""),
  ZiWithComponentsAndStrokes("叶", ["Ia", "Aa"], "504.png", ""),
  ZiWithComponentsAndStrokes("一", ["Ga"], "456.png", ""),
  ZiWithComponentsAndStrokes("二", ["Fa"], "451.png", getString(312)/*"Reminder: For a character containing a single component, after typing the component, if needed, you can continue to type up to three strokes of the character: 1st, 2nd and last stroke."*/),
  ZiWithComponentsAndStrokes("三", ["Da"], "505.png", ""),
  ZiWithComponentsAndStrokes("召", ["Va", "Ia"], "506.png", ""),
  ZiWithComponentsAndStrokes("义", ["Wa", "Ha"], "501.png", ""),
  ZiWithComponentsAndStrokes("晶", ["Oa", "Oa", "Oa"], "", ""),
  //ZiWithComponentsAndStrokes("田", ["Pa"], "509.png", "Reminder: For a character containing a single component, after typing the component, if needed, you can continue to type up to three strokes of the character: 1st, 2nd and last stroke."),   // da shu 'y'
  ZiWithComponentsAndStrokes("公", ["Ra", "Ma"], "510.png", ""),
  ZiWithComponentsAndStrokes("乙", ["Ba"], "511.png", getString(312)/*"Reminder: For a character containing a single component, after typing the component, if needed, you can continue to type up to three strokes of the character: 1st, 2nd and last stroke."*/),  // da 'b'
  ZiWithComponentsAndStrokes("旧", ["Ya", "Oa"], "512.png", ""),
  ZiWithComponentsAndStrokes("乇", ["Ta", "Sa"], "513.png", getString(313)/*"Reminder: For a character containing two components, after typing the two components, if needed, you can continue to type up to two strokes: the last stroke from the 1st component, and the last stroke from the 2nd component."*/),
  ZiWithComponentsAndStrokes("合", ["Ea", "Ga", "Ia"], "514.png", ""),
  ZiWithComponentsAndStrokes("哈", ["Ia", "Ea", "Ga", "Ia"], "", ""),
  */
];
// 月 巾  雪

var theZiForExpandedReviewExerciseList=[
  ZiWithComponentsAndStrokes("键", [], "", 335), //
  ZiWithComponentsAndStrokes("份", [], "E42.png,E43.png", 0), //任
  ZiWithComponentsAndStrokes("哄", [], "E24.png,E61.png", 0), //贵
  ZiWithComponentsAndStrokes("亨", [], "E21.png,E11.png", 0),
  ZiWithComponentsAndStrokes("汰", [], "E21.png,E35.png", 0),
  ZiWithComponentsAndStrokes("渠", [], "E21.png,E53.png", 0),
  ZiWithComponentsAndStrokes("叁", [], "E31.png,E41.png", 0),
  ZiWithComponentsAndStrokes("坞", [], "E43.png,E34.png", 0),
  //ZiWithComponentsAndStrokes("鸭", [], "E15.png,E34.png", 0),
  ZiWithComponentsAndStrokes("描", [], "E41.png,E61.png", 0),//蕾
  ZiWithComponentsAndStrokes("佐", [], "E24.png,E61.png", 0),
  ZiWithComponentsAndStrokes("悟", [], "E23.png,E34.png", 0),
  ZiWithComponentsAndStrokes("诏", [], "E21.png,E25.png", 0),
  ZiWithComponentsAndStrokes("柒", [], "E21.png,E31.png", 0), //畜
  ZiWithComponentsAndStrokes("群", [], "E33.png,E13.png", 0),
  ZiWithComponentsAndStrokes("铭", [], "E42.png,E34.png", 0),
  //ZiWithComponentsAndStrokes("驶", [], "E34.png,E24.png", 0),
  ZiWithComponentsAndStrokes("炊", [], "E35.png,E42.png", 0),
  ZiWithComponentsAndStrokes("妙", [], "E54.png,E52.png", 0),
  //ZiWithComponentsAndStrokes("道", [], "E21.png,E51.png", 0),
  //ZiWithComponentsAndStrokes("俱", [], "E42.png,E51.png", 0),
  ZiWithComponentsAndStrokes("梅", [], "E42.png,E51.png", 0),
  ZiWithComponentsAndStrokes("摩", [], "E32.png,E13.png", 0),
  ZiWithComponentsAndStrokes("昼", [], "E32.png,E13.png", 0),
  //ZiWithComponentsAndStrokes("京", [], "E21.png,E52.png", 0),
  ZiWithComponentsAndStrokes("岸", [], "E21.png,E52.png", 0),
  ZiWithComponentsAndStrokes("匈", [], "E21.png,E52.png", 0),
  ZiWithComponentsAndStrokes("敌", [], "E43.png,E54.png", 0),
  ZiWithComponentsAndStrokes("帘", [], "E21.png,E61.png", 0),
  ZiWithComponentsAndStrokes("梨", [], "E62.png,E23.png", 0),
];

var theZiForExpandedGeneralExerciseList=[
  /*
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
  ZiWithComponentsAndStrokes("会", ["Ea", "Ga", "Ma"], "488.png", getString(314)/*"If there are two options to separate components, choose the option that contains a component with more strokes."*/),
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
  ZiWithComponentsAndStrokes("键", [], "", 356), //
  ZiWithComponentsAndStrokes("狞", [], "", 0), //11
  ZiWithComponentsAndStrokes("坞", [], "", 0), //12
  //ZiWithComponentsAndStrokes("卖", [], "", 0), //13
  ZiWithComponentsAndStrokes("意", [], "", 0), //14 //拙
  ZiWithComponentsAndStrokes("庵", [], "", 0), //15
  ZiWithComponentsAndStrokes("柒", [], "", 0), //21 //讹
  //ZiWithComponentsAndStrokes("谢", [], "", 0), //23
  ZiWithComponentsAndStrokes("忍", [], "", 0), //25 //雇
  ZiWithComponentsAndStrokes("绢", [], "", 0), //31
  ZiWithComponentsAndStrokes("蕊", [], "", 0), //32 //疮
  ZiWithComponentsAndStrokes("侈", [], "", 0), //33 //烈
  ZiWithComponentsAndStrokes("荡", [], "", 0), //34 //透
  //ZiWithComponentsAndStrokes("卖", [], "", ""), //35
  //ZiWithComponentsAndStrokes("涨", [], "", ""), //41
  ZiWithComponentsAndStrokes("箔", [], "", 0), //42 //馅
  ZiWithComponentsAndStrokes("轮", [], "", 0), //43
  ZiWithComponentsAndStrokes("拖", [], "", 0), //44
  ZiWithComponentsAndStrokes("帽", [], "", 0), //51
  ZiWithComponentsAndStrokes("靠", [], "", 0), //52
  ZiWithComponentsAndStrokes("客", [], "", 0), //54
  ZiWithComponentsAndStrokes("宽", [], "", 0), //61
  ZiWithComponentsAndStrokes("况", [], "", 0), //62 //瓢
];

var theShowAttachedComponentList = [
  ComponentCollection(0, "F43.png", 0, 0, 0/*"Explaination Text - string id*/),
  ComponentCollection(1, "F24.png", 2, 4, 315/*"closed shape"*/),
  //ComponentCollection(2, "F13.png", 1, 3, 316/*"like E"*/),
  ComponentCollection(3, "F23.png", 2, 3, 342/*"the verticle line"*/),
  ComponentCollection(5, "F42.png", 4, 2, 318/*"curve toward bottom left"*/),
  ComponentCollection(6, "F11.png", 1, 1, 319/*"overall T shape looking"*/),
  ComponentCollection(7, "F25.png", 2, 5, 320/*"hammer looking"*/),
  ComponentCollection(8, "F44.png", 4, 4, 343/*"Overall L shape looking"*/),
  ComponentCollection(9, "F31.png", 3, 1, 321/*"disconnected triangle"*/),
  ComponentCollection(10, "F62.png", 6, 2, 322/*"a shape with three legs"*/),
  ComponentCollection(11, "F34.png", 3, 4, 323/*"half circle shape"*/),
  ComponentCollection(15, "F43.png", 4, 3, 346/*"crossing at middle"*/),
  ComponentCollection(16, "F52.png", 5, 2, 347/*"split shapes"*/),
  ComponentCollection(17, "F61.png", 6, 1, 348/*"open to bottom"*/),
  //ComponentCollection(18, "F12.png", 1, 2, 325/*"two legs"*/),
  ComponentCollection(19, "F33.png", 3, 3, 326/*"facing left"*/),
  //ComponentCollection(20, "F32.png", 3, 2, 349/*"shelter looking"*/),
  ComponentCollection(21, "F51.png", 5, 1, 327/*"closed shape with horizontal lines"*/),
  ComponentCollection(22, "F54.png", 5, 4, 350/*"diagonal crossing"*/),
  ComponentCollection(23, "F15.png", 1, 5, 351/*"closed shape with crossing"*/),
  //ComponentCollection(25, "F35.png", 3, 5, 353/*"upward arrow"*/),
];

var theZiForAttachedCompExerciseList=[
  ZiWithComponentsAndStrokes("键", [], ""/*N32.png*/, 336),
  ZiWithComponentsAndStrokes("痰", [], "N32.png", 0),
  ZiWithComponentsAndStrokes("到", [], "N31.png", 0),
  ZiWithComponentsAndStrokes("雅", [], "N11.png", 0),
  //ZiWithComponentsAndStrokes("捧", [], "N12.png", 0),
  ZiWithComponentsAndStrokes("晚", [], "N12.png", 0),
  ZiWithComponentsAndStrokes("聪", [], "N13.png", 0),
  ZiWithComponentsAndStrokes("碘", [], "N15.png", 0),
  ZiWithComponentsAndStrokes("茫", [], "N21.png", 0),
  //ZiWithComponentsAndStrokes("兹", [], "N21.png", 0),
  //ZiWithComponentsAndStrokes("齿", [], "N22.png", 0),
  ZiWithComponentsAndStrokes("涉", [], "N23.png", 0),
  ZiWithComponentsAndStrokes("蝗", [], "N24.png", 0),
  ZiWithComponentsAndStrokes("娜", [], "N25.png", 0),
  //ZiWithComponentsAndStrokes("拟", [], "N31.png", 0),
  ZiWithComponentsAndStrokes("歉", [], "N33.png", 0),
  //ZiWithComponentsAndStrokes("侯", [], "N33.png", 0),
  ZiWithComponentsAndStrokes("驱", [], "N34.png", 0),
  //ZiWithComponentsAndStrokes("拷", [], "N34.png", 0),
  ZiWithComponentsAndStrokes("鉴", [], "N35.png", 0),
  //ZiWithComponentsAndStrokes("谍", [], "N41.png", 0), //TODO: hint wrong
  //ZiWithComponentsAndStrokes("硕", [], "N41.png", 0),
  ZiWithComponentsAndStrokes("氨", [], "N42.png", 0),
  ZiWithComponentsAndStrokes("鞭", [], "N43.png", 0),
  ZiWithComponentsAndStrokes("婚", [], "N44.png", 0),
  //ZiWithComponentsAndStrokes("颠", [], "N51.png", 0),
  //ZiWithComponentsAndStrokes("赊", [], "N52.png", 0), //TODO: hint wrong
  //ZiWithComponentsAndStrokes("铠", [], "N53.png", 0),
  ZiWithComponentsAndStrokes("修", [], "N54.png", 0),
  //ZiWithComponentsAndStrokes("溅", [], "N54.png", 0),
  ZiWithComponentsAndStrokes("满", [], "N61.png", 0),
  //ZiWithComponentsAndStrokes("偏", [], "N61.png", 0),
  //ZiWithComponentsAndStrokes("篇", [], "N61.png", 0), //some font might be wrong
  ZiWithComponentsAndStrokes("藐", [], "N62.png", 0),
  //ZiWithComponentsAndStrokes("漾", [], "N62.png", 0),
  //ZiWithComponentsAndStrokes("聚", [], "N62.png", 0),
];

var theZiForTwinCompExerciseList=[
  ZiWithComponentsAndStrokes("键", [], "P54.png", 337),
  ZiWithComponentsAndStrokes("荷", [], "P11.png", 0),
  ZiWithComponentsAndStrokes("疯", [], "P12.png", 0),
  //ZiWithComponentsAndStrokes("拙", [], "P12.png", 0)
  ZiWithComponentsAndStrokes("搓", [], "P13.png", 0), //To verify
  ZiWithComponentsAndStrokes("聘", [], "P15.png", 0),
  //ZiWithComponentsAndStrokes("拙", [], "P22.png", 0),
  ZiWithComponentsAndStrokes("趋", [], "P23.png", 0),
  ZiWithComponentsAndStrokes("酗", [], "P24.png", 0),
  ZiWithComponentsAndStrokes("顾", [], "P25.png", 0),
  ZiWithComponentsAndStrokes("统", [], "P31.png", 0),
  //ZiWithComponentsAndStrokes("衰", [], "P31.png", 0),
  ZiWithComponentsAndStrokes("质", [], "P32.png", 0),
  ZiWithComponentsAndStrokes("净", [], "P33.png", 0),
  ZiWithComponentsAndStrokes("鸣", [], "P34.png", 0),
  //ZiWithComponentsAndStrokes("祠", [], "P34.png", 0),
  ZiWithComponentsAndStrokes("券", [], "P35.png", 0),
  //ZiWithComponentsAndStrokes("坐", [], "P35.png", 0),
  ZiWithComponentsAndStrokes("痹", [], "P41.png", 0),
  ZiWithComponentsAndStrokes("剂", [], "P42.png", 0),
  ZiWithComponentsAndStrokes("酷", [], "P43.png", 0),
  ZiWithComponentsAndStrokes("秕", [], "P44.png", 0),
  ZiWithComponentsAndStrokes("衰", [], "P51.png", 0),
  ZiWithComponentsAndStrokes("弯", [], "P52.png", 0),
  //ZiWithComponentsAndStrokes("袍", [], "P53.png", 0),
  ZiWithComponentsAndStrokes("越", [], "P54.png", 0),
  ZiWithComponentsAndStrokes("靖", [], "P61.png", 0),
  //ZiWithComponentsAndStrokes("暴", [], "P62.png", 0), TODO: hint and last letter
];

var theZiForSubCompExerciseList=[
  ZiWithComponentsAndStrokes("键", [], "Q54.png", 338),
  ZiWithComponentsAndStrokes("舒", [], "Q11.png", 0),
  ZiWithComponentsAndStrokes("筷", [], "Q12.png", 0),
  ZiWithComponentsAndStrokes("逞", [], "Q14.png", 0),
  ZiWithComponentsAndStrokes("碑", [], "Q15.png", 0),
  ZiWithComponentsAndStrokes("寂", [], "Q23.png", 0),
  ZiWithComponentsAndStrokes("腰", [], "Q24.png", 0),
  ZiWithComponentsAndStrokes("购", [], "Q25.png", 0),
  ZiWithComponentsAndStrokes("呦", [], "Q31.png", 0),
  ZiWithComponentsAndStrokes("锨", [], "Q32.png", 0),
  ZiWithComponentsAndStrokes("铭", [], "Q33.png", 0),
  ZiWithComponentsAndStrokes("坞", [], "Q34.png", 0),
  ZiWithComponentsAndStrokes("谨", [], "Q41.png", 0),
  ZiWithComponentsAndStrokes("忿", [], "Q44.png", 0),
  ZiWithComponentsAndStrokes("管", [], "Q51.png", 0),
  ZiWithComponentsAndStrokes("阅", [], "Q52.png", 0),
  ZiWithComponentsAndStrokes("歧", [], "Q54.png", 0),
  ZiWithComponentsAndStrokes("病", [], "Q61.png", 0),
  ZiWithComponentsAndStrokes("粹", [], "Q62.png", 0),
];

var theZiForSingleCompExerciseList=[
  ZiWithComponentsAndStrokes("键", [], "", 339),
  //ZiWithComponentsAndStrokes("歹", [], "", 0),
  //ZiWithComponentsAndStrokes("二", [], "", 0),
  ZiWithComponentsAndStrokes("日", [], "", 0),
  ZiWithComponentsAndStrokes("十", [], "", 0),
  //ZiWithComponentsAndStrokes("大", [], "", 0),
  ZiWithComponentsAndStrokes("父", [], "", 0),
  ZiWithComponentsAndStrokes("口", [], "", 0),
  ZiWithComponentsAndStrokes("下", [], "", 0), //世
  ZiWithComponentsAndStrokes("田", [], "", 0),
  ZiWithComponentsAndStrokes("我", [], "", 0),
  ZiWithComponentsAndStrokes("三", [], "", 0),
  //ZiWithComponentsAndStrokes("了", [], "", 0),
  ZiWithComponentsAndStrokes("弓", [], "", 0),
  ZiWithComponentsAndStrokes("尺", [], "", 0),
  ZiWithComponentsAndStrokes("一", [], "", 0),
  ZiWithComponentsAndStrokes("巾", [], "", 0),
  ZiWithComponentsAndStrokes("内", [], "", 0),
  ZiWithComponentsAndStrokes("乙", [], "", 0),
  ZiWithComponentsAndStrokes("母", [], "", 0),
  ZiWithComponentsAndStrokes("冉", [], "", 0),
];

var theZiForTwoCompExerciseList=[
  ZiWithComponentsAndStrokes("键", [], "SpecialStrokes.png", 340),
  ZiWithComponentsAndStrokes("呆", [], "", 0),
  ZiWithComponentsAndStrokes("岁", [], "", 0),
  ZiWithComponentsAndStrokes("好", [], "", 0),
  ZiWithComponentsAndStrokes("扛", [], "", 0),
  //ZiWithComponentsAndStrokes("多", [], "", 0),
  ZiWithComponentsAndStrokes("六", [], "", 0),
  ZiWithComponentsAndStrokes("汗", [], "", 0), //老
  ZiWithComponentsAndStrokes("再", [], "", 0),
  ZiWithComponentsAndStrokes("收", [], "", 0),
  ZiWithComponentsAndStrokes("芯", [], "", 0), //笼
  ZiWithComponentsAndStrokes("尖", [], "", 0), //陈
  ZiWithComponentsAndStrokes("所", [], "", 0),
  ZiWithComponentsAndStrokes("舌", [], "", 0),
  ZiWithComponentsAndStrokes("爷", [], "", 0),
  ZiWithComponentsAndStrokes("幼", [], "", 0), //系
  ZiWithComponentsAndStrokes("牺", [], "", 0),
  ZiWithComponentsAndStrokes("明", [], "", 0),
  //ZiWithComponentsAndStrokes("对", [], "", 0),
];

var theZiForGeneralExerciseList=[
  ZiWithComponentsAndStrokes("键", [], "", 341),
  ZiWithComponentsAndStrokes("你", [], "", 0),
  ZiWithComponentsAndStrokes("师", [], "", 0),
  ZiWithComponentsAndStrokes("下", [], "", 0),
  ZiWithComponentsAndStrokes("没", [], "", 0),
  ZiWithComponentsAndStrokes("叭", [], "", 0),
  ZiWithComponentsAndStrokes("会", [], "", 0),
  ZiWithComponentsAndStrokes("卖", [], "", 0),
  ZiWithComponentsAndStrokes("目", [], "", 0),
  ZiWithComponentsAndStrokes("调", [], "", 0),
  ZiWithComponentsAndStrokes("旷", [], "", 0),
  ZiWithComponentsAndStrokes("掉", [], "", 0),
  ZiWithComponentsAndStrokes("木", [], "", 0),
  ZiWithComponentsAndStrokes("谢", [], "", 0),
  ZiWithComponentsAndStrokes("公", [], "", 0),
  ZiWithComponentsAndStrokes("学", [], "", 0),
  //ZiWithComponentsAndStrokes("引", [], "", 0),
  ZiWithComponentsAndStrokes("客", [], "", 0),
];

//var theComponentList = [
//  Component("Aa", "", false, "", "", [4.0,0.125,0.7,8.0,0.125,0.4,8.0,0.875,0.4,8.0,0.875,0.7]),
//];