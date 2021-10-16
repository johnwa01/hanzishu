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
  ComponentInGroup(9, 0, 0),  // the whole components photo only
  ComponentInGroup(10, 1, 4),
  ComponentInGroup(11, 4, 4),
  ComponentInGroup(12, 3, 1),
  ComponentInGroup(13, 4, 2),
  ComponentInGroup(14, 1, 5),
  ComponentInGroup(15, 6, 2),
  ComponentInGroup(16, 5, 1),
  ComponentInGroup(17, 6, 1),
  ComponentInGroup(18, 0, 0),  // the whole components photo only
  ComponentInGroup(19, 1, 3),
  ComponentInGroup(20, 2, 1),
  ComponentInGroup(21, 4, 1),
  ComponentInGroup(22, 3, 2),
  ComponentInGroup(23, 1, 1),
  ComponentInGroup(24, 5, 3),
  ComponentInGroup(25, 1, 2),
  ComponentInGroup(26, 2, 5),
  ComponentInGroup(27, 5, 4),
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
  ComponentCollection(9, "E31.png", 3, 1, "1st stroke or # of horizontal lines"),
  ComponentCollection(10, "E62.png", 6, 2, "with twisted triangle shape"),
  ComponentCollection(11, "E34.png", 3, 4, "a curve crosses a horizontal line"),
  ComponentCollection(12, "E41.png", 4, 1, "1st stroke, not fit into others"),
  ComponentCollection(13, "E14.png", 1, 4, "with significant diagonal crosses"),
  ComponentCollection(14, "E22.png", 2, 2, "which common shape"),
  ComponentCollection(15, "E43.png", 4, 3, "overall looking of the shape"),
  ComponentCollection(16, "E52.png", 5, 2, "overall looking of the shape"),
  ComponentCollection(17, "E61.png", 6, 1, "which common shape"),
  ComponentCollection(18, "E12.png", 1, 2, "separate/go left and right"),
  ComponentCollection(19, "E24.png", 2, 4, "square with horizontal line"),
  ComponentCollection(20, "E32.png", 3, 2, "number of horizontal lines"),
  ComponentCollection(21, "E51.png", 5, 1, "1st stroke or turning strokes"),
  ComponentCollection(22, "E54.png", 5, 4, "which common shape"),
  ComponentCollection(23, "E15.png", 1, 5, "which common shape"),
  ComponentCollection(24, "E21.png", 2, 1, "1st stroke, not fit into others"),
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