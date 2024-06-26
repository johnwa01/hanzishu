import 'package:hanzishu/engine/stroke.dart';

var theStrokeList=[
  Stroke("a", "横", "g", [4.0,0.1,0.5,8.0,0.9,0.5]),
  Stroke("b", "提", "g", [4.0,0.1,0.6,8.0,0.9,0.4]),
  Stroke("c", "竖", "y", [4.0,0.5,0.1,8.0,0.5,0.8]),
  Stroke("d", "竖钩", "y", [4.0,0.5,0.025,8.0,0.5,0.9,8.0,0.45,0.925,8.0,0.3,0.8]),
  Stroke("e", "撇", "t", [4.0,0.6875,0.05,8.0,0.675,0.35,8.0,0.65,0.5,8.0,0.6125,0.6,8.0,0.55,0.7,8.0,0.45,0.8,8.0,0.25,0.92]),
  Stroke("f", "点", "h", [4.0,0.425,0.2,8.0,0.6,0.35]),
  Stroke("g", "捺", "h", [4.0,0.375,0.25,8.0,0.4125,0.35,8.0,0.5,0.5,8.0,0.5625,0.6,8.0,0.65,0.675,8.0,0.7375,0.75,8.0,0.8125,0.8]),
  Stroke("A", "横折", "b", [4.0,0.15,0.15,8.0,0.85,0.15,8.0,0.85,0.85]),
  Stroke("B", "横撇", "b", [4.0,0.2,0.45,8.0,0.7375,0.45,8.0,0.7,0.55,8.0,0.6,0.7,8.0,0.55,0.76,8.0,0.45,0.85]),
  Stroke("C", "横钩", "b", [4.0,0.175,0.35,8.0,0.8,0.35,8.0,0.725,0.5375]),
  Stroke("D", "竖折", "b", [4.0,0.175,0.125,8.0,0.175,0.875,8.0,0.775,0.875]),
  Stroke("E", "竖弯", "b", [4.0,0.2,0.3,8.0,0.8,0.3,8.0,0.7125,0.4375]),
  Stroke("F", "竖提", "b", [4.0,0.3,0.0125,8.0,0.3,0.925,8.0,0.5375,0.7875]),
  Stroke("G", "撇折", "b", [4.0,0.4625,0.25,8.0,0.225,0.525,8.0,0.75,0.5]),
  Stroke("H", "撇点", "b", [4.0,0.8,0.2,8.0,0.2,0.5,8.0,0.8,0.8]),
  Stroke("I", "撇钩", "b", [4.0,0.75,0.275,8.0,0.675,0.4,8.0,0.55,0.575,8.0,0.45,0.6625,8.0,0.4,0.6]),
  Stroke("J", "弯钩", "b", [4.0,0.25,0.0375,8.0,0.35,0.1375,8.0,0.4,0.2,8.0,0.4375,0.3,8.0,0.4625,0.425,8.0,0.475,0.55,8.0,0.475,0.65,8.0,0.4625,0.75,8.0,0.45,0.8,8.0,0.4375,0.85,8.0,0.4,0.875,8.0,0.35,0.9125,8.0,0.25,0.9375]),
  Stroke("K", "斜钩", "b", [4.0,0.4875,0.1125,8.0,0.5,0.4,8.0,0.525,0.55,8.0,0.55,0.65,8.0,0.6,0.725,8.0,0.7,0.8,8.0,0.725,0.8,8.0,0.775,0.725]),
  Stroke("L", "横折折", "b", [4.0,0.25,0.275,8.0,0.45,0.275,8.0,0.45,0.55,8.0,0.625,0.55]),
  Stroke("M", "横折弯", "b", [4.0,0.325,0.35,8.0,0.6,0.35,8.0,0.6,0.575,8.0,0.625,0.6,8.0,0.725,0.6]),
  Stroke("N", "横折提", "b", [4.0,0.3,0.35,8.0,0.45,0.35,8.0,0.45,0.725,8.0,0.6,0.625]),
  Stroke("O", "横折钩", "b", [4.0,0.375,0.35,8.0,0.675,0.35,8.0,0.65,0.75,8.0,0.575,0.7]),
  Stroke("P", "横斜钩", "b", [4.0,0.215,0.275,8.0,0.5625,0.275,8.0,0.57,0.4625,8.0,0.5875,0.6,8.0,0.625,0.7,8.0,0.7,0.75,8.0,0.75,0.75,8.0,0.7875,0.6875]),
  Stroke("Q", "竖折折", "b", [4.0,0.3875,0.2,8.0,0.3875,0.4,8.0,0.6,0.4,8.0,0.6,0.725]),
  Stroke("R", "竖折撇", "b", [4.0,0.5,0.1,8.0,0.4,0.525,8.0,0.7,0.525,8.0,0.55,0.75]),
  Stroke("S", "竖弯钩", "b", [4.0,0.35,0.25,8.0,0.35,0.725,8.0,0.65,0.725,8.0,0.65,0.6]),
  Stroke("T", "横折折折", "b", [4.0,0.3,0.175,8.0,0.5375,0.175,8.0,0.5375,0.4125,8.0,0.7,0.4125,8.0,0.7,0.75]),
  Stroke("U", "横折折撇", "b", [4.0,0.1,0.1,8.0,0.375,0.1,8.0,0.125,0.4,8.0,0.3875,0.4,8.0,0.35,0.6,8.0,0.3,0.7,8.0,0.225,0.8,8.0,0.1,0.9,8.0,0.05,0.925]),
  Stroke("V", "横折弯钩", "b", [4.0,0.2,0.175,8.0,0.75,0.175,8.0,0.2,0.65,8.0,0.175,0.7,8.0,0.19,0.75,8.0,0.2,0.79,8.0,0.25,0.8,8.0,0.75,0.8,8.0,0.8,0.775,8.0,0.85,0.675]), //[4.0,0.35,0.25,8.0,0.55,0.25,8.0,0.55,0.725,8.0,0.725,0.725,8.0,0.725,0.65]),
  Stroke("W", "横撇弯钩", "b", [4.0,0.45,0.225,8.0,0.625,0.225,8.0,0.5375,0.425,8.0,0.6,0.5,8.0,0.625,0.575,8.0,0.6135,0.65,8.0,0.55,0.675,8.0,0.5,0.6875]),
  Stroke("X", "竖折折钩", "b", [4.0,0.4,0.2,8.0,0.4,0.45,8.0,0.725,0.45,8.0,0.6875,0.7375,8.0,0.6375,0.7]),
  Stroke("Y", "横折折折钩", "b", [4.0,0.3,0.075,8.0,0.7,0.075,8.0,0.6,0.2,8.0,0.515,0.3,8.0,0.375,0.4125,8.0,0.8,0.4125,8.0,0.775,0.825,8.0,0.65,0.625]),
];

