import 'package:hanzishu/engine/component.dart';

var theZiIdToCompCodeMapList=[
  ZiIdToCompMap(2, "Ba"),
  ZiIdToCompMap(3, "Bb"),
  ZiIdToCompMap(4, "Ja"),
  ZiIdToCompMap(5, "Ia"),
  ZiIdToCompMap(6, "Ga"),
  ZiIdToCompMap(7, "Ea"),
  ZiIdToCompMap(8, "Fa"),
  ZiIdToCompMap(9, "Ha"),
  ZiIdToCompMap(10, "Ca"),
  ZiIdToCompMap(11, "Da"),
  ZiIdToCompMap(12, "Ka"),
  ZiIdToCompMap(13, "La"),
  ZiIdToCompMap(14, "Nn"),
  ZiIdToCompMap(17, "Qa"),
  ZiIdToCompMap(18, "Qb"),
  ZiIdToCompMap(19, "Ma"),
  ZiIdToCompMap(20, "Mk"),
  ZiIdToCompMap(22, "Mi"),
  ZiIdToCompMap(23, "Mp"),
  ZiIdToCompMap(24, "Kb"),
  ZiIdToCompMap(25, "Kh"),
  ZiIdToCompMap(28, "Xa"),
  ZiIdToCompMap(32, "Ke"),
  ZiIdToCompMap(36, "Pa"),
  ZiIdToCompMap(37, "Ub"),
  ZiIdToCompMap(39, "Oa"),
  ZiIdToCompMap(40, "Se"),
  ZiIdToCompMap(41, "Sn"),
  ZiIdToCompMap(43, "Tb"),
  ZiIdToCompMap(50, "Ra"),
  ZiIdToCompMap(51, "Fd"),
  ZiIdToCompMap(58, "Db"),
  ZiIdToCompMap(59, "Dg"),
  ZiIdToCompMap(61, "Jb"),
  ZiIdToCompMap(63, "Je"),
  ZiIdToCompMap(68, "Cb"),
  ZiIdToCompMap(72, "Fm"),
  ZiIdToCompMap(74, "Im"),
  ZiIdToCompMap(76, "Gg"),
  ZiIdToCompMap(80, "Cc"),
  ZiIdToCompMap(84, "As"),
  ZiIdToCompMap(87, "Sc"),
  ZiIdToCompMap(90, "Sl"),
  ZiIdToCompMap(91, "Qc"),
  ZiIdToCompMap(96, "Kk"),
  ZiIdToCompMap(98, "Vg"),
  ZiIdToCompMap(99, "Vl"),
  ZiIdToCompMap(103, "Sb"),
  ZiIdToCompMap(104, "Sj"),
  ZiIdToCompMap(110, "Mb"),
  ZiIdToCompMap(111, "Rb"),
  ZiIdToCompMap(114, "Od"),
  ZiIdToCompMap(115, "Ob"),
  ZiIdToCompMap(116, "Lb"),
  ZiIdToCompMap(122, "Sg"),
  ZiIdToCompMap(123, "Tc"),
  ZiIdToCompMap(124, "Ua"),
  ZiIdToCompMap(127, "Ih"),
  ZiIdToCompMap(128, "Iq"),
  ZiIdToCompMap(131, "Bf"),
  ZiIdToCompMap(137, "Bc"),
  ZiIdToCompMap(143, "Jq"),
  ZiIdToCompMap(145, "Hj"),
  ZiIdToCompMap(148, "Ic"),
  ZiIdToCompMap(153, "Jn"),
  ZiIdToCompMap(154, "Bi"),
  ZiIdToCompMap(156, "Eb"),
  ZiIdToCompMap(157, "Ef"),
  ZiIdToCompMap(158, "Fc"),
  ZiIdToCompMap(161, "Dc"),
  ZiIdToCompMap(162, "Dh"),
  ZiIdToCompMap(164, "Ed"),
  ZiIdToCompMap(166, "If"),
  ZiIdToCompMap(169, "Hd"),
  ZiIdToCompMap(170, "Aa"),
  ZiIdToCompMap(172, "Re"),
  ZiIdToCompMap(180, "Ne"),
  ZiIdToCompMap(181, "Vd"),
  ZiIdToCompMap(182, "Vj"),
  ZiIdToCompMap(186, "Pg"),
  ZiIdToCompMap(187, "Md"),
  ZiIdToCompMap(189, "Mf"),
  ZiIdToCompMap(190, "Kd"),
  ZiIdToCompMap(191, "Kf"),
  ZiIdToCompMap(192, "Kn"),
  ZiIdToCompMap(193, "Oi"),
  ZiIdToCompMap(195, "Kh"),
  ZiIdToCompMap(196, "Ya"),
  ZiIdToCompMap(201, "Mj"),
  ZiIdToCompMap(204, "Mx"),
  ZiIdToCompMap(205, "Pm"),
  ZiIdToCompMap(213, "Nb"),
  ZiIdToCompMap(223, "Ng"),
  ZiIdToCompMap(226, "Gd"),
  ZiIdToCompMap(228, "Ae"),
  ZiIdToCompMap(230, "Eo"),
  ZiIdToCompMap(231, "Ey"),
  ZiIdToCompMap(234, "Jd"),
  ZiIdToCompMap(235, "Gb"),
  ZiIdToCompMap(236, "Gl"),
  ZiIdToCompMap(239, "Fb"),
  ZiIdToCompMap(252, "Gq"),
  ZiIdToCompMap(259, "Be"),
  ZiIdToCompMap(264, "Bn"),
  ZiIdToCompMap(266, "Iy"),
  ZiIdToCompMap(267, "Df"),
  ZiIdToCompMap(270, "Fe"),
  ZiIdToCompMap(273, "Ep"),
  ZiIdToCompMap(274, "Ci"),
  ZiIdToCompMap(276, "Hk"),
  ZiIdToCompMap(278, "El"),
  ZiIdToCompMap(282, "Sa"),
  ZiIdToCompMap(291, "Mh"),
  ZiIdToCompMap(295, "Ml"),
  ZiIdToCompMap(304, "Wd"),
  ZiIdToCompMap(306, "Wh"),
  ZiIdToCompMap(307, "Ud"),
  ZiIdToCompMap(309, "Sh"),
  ZiIdToCompMap(310, "Ki"),
  ZiIdToCompMap(311, "Va"),
  ZiIdToCompMap(312, "Wf"),
  ZiIdToCompMap(315, "Td"),
  ZiIdToCompMap(320, "Me"),
  ZiIdToCompMap(324, "Pd"),
  ZiIdToCompMap(326, "Xi"),
  ZiIdToCompMap(328, "Kd"),
  ZiIdToCompMap(330, "Rd"),
  ZiIdToCompMap(332, "Kj"),
  ZiIdToCompMap(333, "Pc"),
  ZiIdToCompMap(334, "Pi"),
  ZiIdToCompMap(335, "Pl"),
  ZiIdToCompMap(341, "Rc"),
  ZiIdToCompMap(343, "Qk"),
  ZiIdToCompMap(344, "Kc"),
  ZiIdToCompMap(345, "Mg"),
  ZiIdToCompMap(347, "Kc"),
  ZiIdToCompMap(348, "Mn"),
  ZiIdToCompMap(352, "Ji"),
  ZiIdToCompMap(353, "Jt"),
  ZiIdToCompMap(355, "Cg"),
  ZiIdToCompMap(361, "Jo"),
  ZiIdToCompMap(367, "Cd"),
  ZiIdToCompMap(373, "Fk"),
  ZiIdToCompMap(374, "It"),
  ZiIdToCompMap(376, "Ig"),
  ZiIdToCompMap(379, "Aj"),
  ZiIdToCompMap(389, "Jg"),
  ZiIdToCompMap(391, "Jj"),
  ZiIdToCompMap(397, "Ec"),
  ZiIdToCompMap(402, "Ad"),
  ZiIdToCompMap(406, "Et"),
  ZiIdToCompMap(411, "Ii"),
  ZiIdToCompMap(413, "Iv"),
  ZiIdToCompMap(422, "Dl"),
  ZiIdToCompMap(424, "Gk"),
  ZiIdToCompMap(431, "Er"),
  ZiIdToCompMap(436, "Hm"),
  ZiIdToCompMap(445, "Bp"),
  ZiIdToCompMap(449, "He"),
  ZiIdToCompMap(459, "Bl"),
  ZiIdToCompMap(461, "Br"),
  ZiIdToCompMap(468, "Dr"),
  ZiIdToCompMap(474, "Ta"),
  ZiIdToCompMap(475, "Wa"),
  ZiIdToCompMap(476, "Ck"),
  ZiIdToCompMap(479, "Pe"),
  ZiIdToCompMap(481, "Sk"),
  ZiIdToCompMap(486, "Kn"),
  ZiIdToCompMap(487, "Bx"),
  ZiIdToCompMap(492, "Oe"),
  ZiIdToCompMap(494, "Jk"),
  ZiIdToCompMap(499, "Ie"),
  ZiIdToCompMap(500, "Io"),
  ZiIdToCompMap(504, "Eq"),
  ZiIdToCompMap(506, "Ab"),
  ZiIdToCompMap(512, "Wb"),
  ZiIdToCompMap(513, "Vq"),
  ZiIdToCompMap(516, "Jy"),
  ZiIdToCompMap(519, "Bu"),
  ZiIdToCompMap(520, "Hb"),
  ZiIdToCompMap(524, "Ht"),
  ZiIdToCompMap(525, "Jw"),
  ZiIdToCompMap(526, "Qf"),
  ZiIdToCompMap(527, "Eu"),
  ZiIdToCompMap(528, "Ac"),
  ZiIdToCompMap(532, "Ce"),
  ZiIdToCompMap(536, "Uf"),
  ZiIdToCompMap(539, "Cp"),
  ZiIdToCompMap(545, "Kl"),
  ZiIdToCompMap(546, "Hn"),
  ZiIdToCompMap(549, "Ek"),
  ZiIdToCompMap(552, "Vp"),
  ZiIdToCompMap(558, "Ke"),
  ZiIdToCompMap(561, "Oj"),
  ZiIdToCompMap(565, "Si"),
  ZiIdToCompMap(573, "Vk"),
  ZiIdToCompMap(577, "Kf"),
  ZiIdToCompMap(582, "Sm"),
  ZiIdToCompMap(583, "Hl"),
  ZiIdToCompMap(586, "We"),
  ZiIdToCompMap(593, "Es"),
  ZiIdToCompMap(596, "Hh"),
  ZiIdToCompMap(598, "Hp"),
  ZiIdToCompMap(603, "Ko"),
  ZiIdToCompMap(607, "Js"),
  ZiIdToCompMap(612, "Jr"),
  ZiIdToCompMap(613, "Rh"),
  ZiIdToCompMap(618, "Fr"),
  ZiIdToCompMap(620, "Ki"),
  ZiIdToCompMap(621, "Wg"),
  ZiIdToCompMap(623, "Iw"),
  ZiIdToCompMap(626, "Pj"),
  ZiIdToCompMap(634, "Ar"),
  ZiIdToCompMap(641, "Bo"),
  ZiIdToCompMap(643, "Cf"),
  ZiIdToCompMap(645, "Gr"),
  ZiIdToCompMap(648, "Km"),
  ZiIdToCompMap(652, "Oq"),
  ZiIdToCompMap(654, "Kp"),
  ZiIdToCompMap(657, "Nl"),
  ZiIdToCompMap(661, "Xd"),
  ZiIdToCompMap(662, "Oc"),
  ZiIdToCompMap(663, "Rm"),
  ZiIdToCompMap(666, "Nd"),
  ZiIdToCompMap(668, "Eg"),
  ZiIdToCompMap(675, "Mq"),
  ZiIdToCompMap(677, "Fo"),
  ZiIdToCompMap(686, "Ai"),
  ZiIdToCompMap(687, "Kg"),
  ZiIdToCompMap(691, "Mc"),
  ZiIdToCompMap(700, "Nh"),
  ZiIdToCompMap(702, "Pf"),
  ZiIdToCompMap(708, "Dk"),
  ZiIdToCompMap(711, "Bs"),
  ZiIdToCompMap(715, "Ni"),
  ZiIdToCompMap(718, "Jp"),
  ZiIdToCompMap(721, "Jl"),
  ZiIdToCompMap(725, "Pt"),
  ZiIdToCompMap(727, "Fi"),
  ZiIdToCompMap(766, "Ft"),
  ZiIdToCompMap(772, "Ap"),
  ZiIdToCompMap(773, "Ms"),
  ZiIdToCompMap(778, "Ag"),
  ZiIdToCompMap(789, "Em"),
  ZiIdToCompMap(793, "Op"),
  ZiIdToCompMap(799, "Gj"),
  ZiIdToCompMap(805, "Og"),
  ZiIdToCompMap(806, "Kg"),
];