import 'package:hanzishu/engine/component.dart';


var theComponentList = [
  Component(0, "Ta", "撇", false, true, 1, 1, "C11.png", "nmdc", [4.0,0.6875,0.05,8.0,0.675,0.35,8.0,0.65,0.5,8.0,0.6125,0.6,8.0,0.55,0.7,8.0,0.45,0.8,8.0,0.25,0.92]),
  Component(1, "Ra", "八", true, true, 1, 2, "C12.png", "nmdc", []),
  Component(2, "Ea", "人", true, true, 1, 3, "C13.png", "nmdc", []),
  Component(3, "Wa", "艾字底", false, true, 1, 4, "C14.png", "nmdc", [4.0,0.75,0.05,8.0,0.6,0.475,8.0,0.5,0.65,8.0,0.325,0.85,8.0,0.025,0.975,4.0,0.2,0.05,8.0,0.325,0.375,8.0,0.5,0.65,8.0,0.725,0.825,8.0,0.925,0.925]),
  Component(4, "Qa", "周字框", false, true, 1, 5, "C15.png", "nmdc", [4.0,0.075,0.9375,8.0,0.1125,0.9,8.0,0.1625,0.8,8.0,0.2,0.65,8.0,0.2125,0.075,8.0,0.9,0.075,8.0,0.9,0.875,8.0,0.875,0.9,8.0,0.85,0.925,8.0,0.75,0.9875]),
  Component(5, "Ya", "竖", false, true, 2, 1, "C21.png", "nmdc", [4.0,0.5,0.0,8.0,0.5,1.0]),
  Component(6, "Ua", "上三框", false, true, 2, 2, "C22.png", "nmdc", [4.0,0.125,0.7,8.0,0.125,0.4,8.0,0.875,0.4,8.0,0.875,0.7]),
  Component(7, "Ia", "口", true, true, 2, 3, "C23.png", "nmdc", []),
  Component(8, "Oa", "日", true, true, 2, 4, "C24.png", "nmdc", []),
  Component(90, "Pa", "田", true, true, 2, 5, "C25.png", "nmdc", []),
  Component(10, "Ga", "一", true, true, 3, 1, "C31.png", "nmdc", []),
  Component(11, "Fa", "二", true, true, 3, 2, "C32.png", "nmdc", []),
  Component(12, "Da", "三", true, true, 3, 3, "C33.png", "nmdc", []),
  Component(13, "Sa", "七", true, true, 3, 4, "C34.png", "nmdc", []),
  Component(14, "Aa", "十", true, true, 3, 5, "C35.png", "nmdc", []),
  Component(15, "Ha", "点", false, true, 4, 1, "C41.png", "nmdc", [4.0,0.425,0.2,8.0,0.6,0.35]),
  Component(16, "Ja", "丁", true, true, 4, 2, "C42.png", "nmdc", []),
  Component(17, "Ka", "厂", true, true, 4, 3, "C43.png", "nmdc", []),
  Component(18, "La", "木", true, true, 4, 4,  "C44.png", "nmdc",[]),
  Component(19, "Ba", "乙", true, true, 5, 1, "C51.png", "nmdc", []),
  Component(20, "Va", "刀", true, true, 5, 2, "C52.png", "nmdc", []),
  Component(21, "Ca", "弓", true, true, 5, 3, "C53.png", "nmdc", []),
  Component(22, "Xa", "雪字底", false, true, 5, 4, "C54.png", "nmdc", [4.0,0.1625,0.475,8.0,0.825,0.475,8.0,0.825,0.8,4.0,0.2125,0.65,8.0,0.85,0.65,4.0,0.1625,0.7875,8.0,0.825,0.7875]),
  Component(23, "Na", "又", true, true, 6, 1, "C61.png", "nmdc", []),
  Component(24, "Ma", "厶", false, true, 6, 2, "C62.png", "nmdc", [4.0,0.7,0.075,8.0,0.65,0.25,8.0,0.625,0.35,8.0,0.575,0.45,8.0,0.5375,0.55,8.0,0.5,0.65,8.0,0.45,0.725,8.0,0.375,0.825,8.0,0.85,0.725,4.0,0.725,0.4125,8.0,0.7625,0.55,8.0,0.8125,0.65,8.0,0.85,0.725,8.0,0.9,0.875]),
];

// TODO: To be created in run time.
// We call lead component just component, and other components expanded components.
var theLeadComponentList  = theComponentList;

var theComponentGroupList = [
  ComponentGroup(0, "GG5.png"),
  ComponentGroup(1, "G1.png"),
  ComponentGroup(2, "G2.png"),
  ComponentGroup(3, "G3.png"),
  ComponentGroup(4, "G4.png"),
  ComponentGroup(5, "G5.png"),
  ComponentGroup(6, "G6.png"),
];

var theComponentGroupListInRealExercise = [
  0,
  1,
  2,
  3,
  4,
  5,
  6,
  3,
  5,
  1,
  6,
  4,
  2
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
  ComponentInGroup(1, 3, 4),
  ComponentInGroup(2, 2, 3),
  ComponentInGroup(3, 3, 5),
  ComponentInGroup(4, 2, 2),
  ComponentInGroup(5, 5, 2),
  ComponentInGroup(6, 3, 3),
  ComponentInGroup(7, 4, 3),
  ComponentInGroup(8, 2, 4),
  ComponentInGroup(9, 1, 4),
  ComponentInGroup(10, 4, 4),
  ComponentInGroup(11, 3, 1),
  ComponentInGroup(12, 4, 2),
  ComponentInGroup(13, 1, 5),
  ComponentInGroup(14, 6, 2),
  ComponentInGroup(15, 5, 1),
  ComponentInGroup(16, 6, 1),
  ComponentInGroup(17, 1, 3),
  ComponentInGroup(18, 2, 1),
  ComponentInGroup(19, 4, 1),
  ComponentInGroup(20, 3, 2),
  ComponentInGroup(21, 1, 1),
  ComponentInGroup(22, 5, 3),
  ComponentInGroup(23, 1, 2),
  ComponentInGroup(24, 2, 5),
  ComponentInGroup(25, 5, 4),
];

var theExpandedComponentList = [
  ComponentCollection(0, "EF33.png", 0, 0, "Explaination Text"),
  ComponentCollection(1, "E33.png", 3, 3, "number of horizontal lines"),
  ComponentCollection(2, "E13.png", 1, 3, "which common shape"),
  ComponentCollection(3, "E23.png", 2, 3, "vertical line through a square"),
  ComponentCollection(4, "E53.png", 5, 3, "contains a stroke with a few turnings"),
  ComponentCollection(5, "E42.png", 4, 2, "overall looking of the shape"),
  ComponentCollection(6, "E11.png", 1, 1, "1st stroke, not fit into others"),
  ComponentCollection(7, "E25.png", 2, 5, "square with a cross"),
  ComponentCollection(8, "E44.png", 4, 4, "which common shape"),
  ComponentCollection(23, "E31.png", 3, 1, "1st stroke or # of horizontal lines"),
  ComponentCollection(9, "E62.png", 6, 2, "with twisted triangle shape"),
  ComponentCollection(10, "E34.png", 3, 4, "a curve crosses a horizontal line"),
  ComponentCollection(22, "E41.png", 4, 1, "1st stroke, not fit into others"),
  ComponentCollection(11, "E14.png", 1, 4, "with significant diagonal crosses"),
  ComponentCollection(12, "E22.png", 2, 2, "which common shape"),
  ComponentCollection(13, "E43.png", 4, 3, "overall looking of the shape"),
  ComponentCollection(14, "E52.png", 5, 2, "overall looking of the shape"),
  ComponentCollection(15, "E61.png", 6, 1, "which common shape"),
  ComponentCollection(16, "E12.png", 1, 2, "separate/go left and right"),
  ComponentCollection(17, "E24.png", 2, 4, "square with horizontal line"),
  ComponentCollection(18, "E32.png", 3, 2, "number of horizontal lines"),
  ComponentCollection(24, "E51.png", 5, 1, "1st stroke or turning strokes"),
  ComponentCollection(19, "E54.png", 5, 4, "which common shape"),
  ComponentCollection(20, "E15.png", 1, 5, "which common shape"),
  ComponentCollection(21, "E21.png", 2, 1, "1st stroke, not fit into others"),
  ComponentCollection(25, "E35.png", 3, 5, "which common shape"),
];

/*
var theFullExpandedComponentList = [
  FullComponentCollection(0, "z", "EF33.png"),
  FullComponentCollection(1, "t", "E11.png"),
  FullComponentCollection(2, "r", "E12.png"),
  FullComponentCollection(3, "e", "E13.png"),
  FullComponentCollection(4, "w", "E14.png"),
  FullComponentCollection(5, "q", "E15.png"),
  FullComponentCollection(6, "y", "E21.png"),
  FullComponentCollection(7, "u", "E22.png"),
  FullComponentCollection(8, "i", "E23.png"),
  FullComponentCollection(9, "o", "E24.png"),
  FullComponentCollection(10, "p", "E25.png"),
  FullComponentCollection(11, "g", "E31.png"),
  FullComponentCollection(12, "f", "E32.png"),
  FullComponentCollection(13, "d", "E33.png"),
  FullComponentCollection(14, "s", "E34.png"),
  FullComponentCollection(15, "a", "E35.png"),
  FullComponentCollection(16, "h", "E41.png"),
  FullComponentCollection(17, "j", "E42.png"),
  FullComponentCollection(18, "k", "E43.png"),
  FullComponentCollection(19, "l", "E44.png"),
  FullComponentCollection(20, "b", "E51.png"),
  FullComponentCollection(21, "v", "E52.png"),
  FullComponentCollection(22, "c", "E53.png"),
  FullComponentCollection(23, "x", "E54.png"),
  FullComponentCollection(24, "n", "E61.png"),
  FullComponentCollection(25, "m", "E62.png"),
];
*/