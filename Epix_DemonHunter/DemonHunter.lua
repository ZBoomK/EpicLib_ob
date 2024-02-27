local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((6284 - 2872) >= (6230 - (1523 + 114)))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_DemonHunter_DemonHunter.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v11.Player;
	local v13 = v11.Target;
	local v14 = v11.Pet;
	local v15 = v9.Spell;
	local v16 = v9.MultiSpell;
	local v17 = v9.Item;
	local v18 = v9.Utils.MergeTableByKey;
	local v19 = EpicLib;
	local v20 = v19.Macro;
	if (((3302 + 372) >= (734 - 218)) and not v15.DemonHunter) then
		v15.DemonHunter = {};
	end
	v15.DemonHunter.Commons = {ArcaneTorrent=v15(51678 - (68 + 997), nil, 1271 - (226 + 1044)),Glide=v15(571937 - 440590, nil, 119 - (32 + 85)),ImmolationAura=v15(253744 + 5176, nil, 1 + 2),ChaosNova=v15(180014 - (892 + 65), nil, 9 - 5),CollectiveAnguish=v15(721170 - 331018, nil, 175 - 79),ConcentratedSigils=v15(208016 - (87 + 263), nil, 252 - (67 + 113)),ConsumeMagic=v15(204089 + 74237, nil, 230 - 136),Darkness=v15(144677 + 52041, nil, 369 - 276),Demonic=v15(214362 - (802 + 150), nil, 13 - 8),ElysianDecree=v15(707741 - 317578, nil, 5 + 1),Felblade=v15(233890 - (915 + 82), nil, 19 - 12),FodderToTheFlame=v15(228026 + 163403, nil, 9 - 1),Imprison=v15(219019 - (1069 + 118), nil, 19 - 10),ImprovedDisrupt=v15(700780 - 380419, nil, 20 + 92),SigilOfFlame=v16(17 - 7, 202960 + 1636, 205304 - (368 + 423), 1225048 - 835238),SigilOfMisery=v16(63 - (10 + 8), 1499506 - 1109693, 202582 - (416 + 26), 663121 - 455436),SoulSigils=v15(169707 + 225739, nil, 171 - 74),TheHunt=v15(371403 - (145 + 293), nil, 441 - (44 + 386)),VengefulRetreat=v15(200279 - (998 + 488), nil, 16 + 34),Disrupt=v15(150461 + 33291, nil, 784 - (201 + 571)),ImmolationAuraBuff=v15(260058 - (116 + 1022), nil, 53 - 40),SigilOfFlameDebuff=v15(120095 + 84503, nil, 51 - 37),Pool=v15(3550768 - 2550858, nil, 874 - (814 + 45))};
	v15.DemonHunter.Havoc = v18(v15.DemonHunter.Commons, {Annihilation=v15(496308 - 294881, nil, 1 + 15),BladeDance=v15(66604 + 121895, nil, 902 - (261 + 624)),Blur=v15(352911 - 154322, nil, 1098 - (1020 + 60)),ChaosStrike=v15(164217 - (630 + 793), nil, 64 - 45),DeathSweep=v15(995018 - 784866, nil, 8 + 12),DemonsBite=v15(558609 - 396366, nil, 1768 - (760 + 987)),FelRush=v15(196985 - (1789 + 124), nil, 788 - (745 + 21)),Metamorphosis=v15(65845 + 125582, nil, 62 - 39),ThrowGlaive=v15(726147 - 541024, nil, 1 + 23),AFireInside=v15(335856 + 91919, nil, 1153 - (87 + 968)),AnyMeansNecessary=v15(1708455 - 1320341, nil, 91 + 9),BlindFury=v15(460134 - 256584, nil, 1438 - (447 + 966)),BurningWound=v15(1070939 - 679750, nil, 1843 - (1703 + 114)),ChaosTheory=v15(390388 - (376 + 325), nil, 43 - 16),ChaoticTransformation=v15(1194211 - 806099, nil, 9 + 19),CycleOfHatred=v15(570194 - 311307, nil, 43 - (9 + 5)),DemonBlades=v15(203931 - (85 + 291), nil, 1295 - (243 + 1022)),EssenceBreak=v15(985008 - 726148, nil, 26 + 5),EyeBeam=v15(199193 - (1123 + 57), nil, 27 + 5),FelBarrage=v15(259179 - (163 + 91), nil, 1963 - (1869 + 61)),FelEruption=v15(59194 + 152687, nil, 119 - 85),FirstBlood=v15(317044 - 110628, nil, 5 + 30),FuriousGaze=v15(471794 - 128483, nil, 34 + 2),FuriousThrows=v15(394503 - (1329 + 145), nil, 1008 - (140 + 831)),GlaiveTempest=v15(344667 - (1409 + 441), nil, 756 - (15 + 703)),Inertia=v15(198043 + 229597, nil, 537 - (262 + 176)),Initiative=v15(389829 - (345 + 1376), nil, 727 - (198 + 490)),InnerDemon=v15(1721648 - 1331955, nil, 95 - 55),IsolatedPrey=v15(389319 - (696 + 510), nil, 85 - 44),MiseryInDefeat=v15(389372 - (1091 + 171), nil, 17 + 86),Momentum=v15(650056 - 443580, nil, 138 - 96),Netherwalk=v15(196929 - (123 + 251), nil, 472 - 377),Ragefire=v15(388805 - (208 + 490), nil, 4 + 39),RestlessHunter=v15(173787 + 216355, nil, 940 - (660 + 176)),SerratedGlaive=v15(46875 + 343279, nil, 246 - (14 + 188)),ShatteredDestiny=v15(388791 - (534 + 141), nil, 41 + 60),Soulscar=v15(343297 + 44809, nil, 45 + 1),TacticalRetreat=v15(818946 - 429258, nil, 73 - 26),TrailofRuin=v15(726172 - 467291, nil, 26 + 22),UnboundChaos=v15(221234 + 126227, nil, 445 - (115 + 281)),ChaosTheoryBuff=v15(907607 - 517412, nil, 43 + 8),FelBarrageBuff=v15(625758 - 366833, nil, 414 - 301),FuriousGazeBuff=v15(344179 - (550 + 317), nil, 74 - 22),InertiaBuff=v15(601081 - 173440, nil, 293 - 188),InnerDemonBuff=v15(390430 - (134 + 151), nil, 1718 - (970 + 695)),InitiativeBuff=v15(746530 - 355315, nil, 2092 - (582 + 1408)),MetamorphosisBuff=v15(562743 - 400479, nil, 67 - 13),MomentumBuff=v15(786184 - 577556, nil, 1879 - (1195 + 629)),TacticalRetreatBuff=v15(515628 - 125738, nil, 297 - (187 + 54)),UnboundChaosBuff=v15(348242 - (162 + 618), nil, 40 + 17),BurningWoundDebuff=v15(260549 + 130642, nil, 123 - 65),EssenceBreakDebuff=v15(538549 - 218211, nil, 5 + 54),SerratedGlaiveDebuff=v15(391791 - (1373 + 263), nil, 1060 - (451 + 549))});
	v15.DemonHunter.Vengeance = v18(v15.DemonHunter.Commons, {InfernalStrike=v15(59695 + 129415, nil, 94 - 33),Shear=v15(342487 - 138705, nil, 1446 - (746 + 638)),SoulCleave=v15(85985 + 142492, nil, 95 - 32),SoulFragments=v15(204322 - (218 + 123), nil, 1645 - (1535 + 46)),ThrowGlaive=v15(202851 + 1306, nil, 10 + 55),DemonSpikes=v15(204280 - (306 + 254), nil, 5 + 61),Torment=v15(363550 - 178305, nil, 1534 - (899 + 568)),AgonizingFlames=v15(136422 + 71126, nil, 164 - 96),BulkExtraction=v15(320944 - (268 + 335), nil, 359 - (60 + 230)),BurningAlive=v15(208311 - (426 + 146), nil, 9 + 61),BurningBlood=v15(391669 - (282 + 1174), nil, 917 - (569 + 242)),CharredFlesh=v15(969720 - 633081, nil, 5 + 66),CycleofBinding=v15(390742 - (706 + 318), nil, 1358 - (721 + 530)),DarkglareBoon=v15(390979 - (945 + 326), nil, 182 - 109),DownInFlames=v15(346791 + 42941, nil, 774 - (271 + 429)),Fallout=v15(208683 + 18491, nil, 1575 - (1408 + 92)),FelDevastation=v15(213170 - (461 + 625), nil, 1364 - (993 + 295)),FieryBrand=v15(10594 + 193427, nil, 1248 - (418 + 753)),FieryDemise=v15(148236 + 240984, nil, 9 + 69),FocusedCleave=v15(100383 + 242824, nil, 28 + 80),Frailty=v15(390487 - (406 + 123), nil, 1848 - (1749 + 20)),Fracture=v15(62622 + 201020, nil, 1402 - (1249 + 73)),ShearFury=v15(139139 + 250858, nil, 1254 - (466 + 679)),SigilOfChains=v16(221 - 129, 578152 - 376014, 209565 - (106 + 1794), 123317 + 266490),SigilOfSilence=v16(21 + 60, 613160 - 405478, 547374 - 345237, 389923 - (4 + 110)),SoulBarrier=v15(264232 - (57 + 527), nil, 1509 - (41 + 1386)),SoulCarver=v15(207510 - (17 + 86), nil, 57 + 26),SoulCrush=v15(869711 - 479726, nil, 243 - 159),SpiritBomb=v15(247620 - (122 + 44), nil, 146 - 61),StoketheFlames=v15(1306509 - 912682, nil, 90 + 20),Vulnerability=v15(56400 + 333576, nil, 173 - 87),Metamorphosis=v15(187892 - (30 + 35), nil, 60 + 27),DemonSpikesBuff=v15(205076 - (1043 + 214), nil, 332 - 244),MetamorphosisBuff=v15(189039 - (323 + 889), nil, 239 - 150),RecriminationBuff=v15(410457 - (361 + 219), nil, 431 - (53 + 267)),FieryBrandDebuff=v15(46940 + 160831, nil, 503 - (15 + 398)),FrailtyDebuff=v15(248438 - (18 + 964), nil, 342 - 251)});
	if (((1341 + 974) == (1459 + 856)) and not v17.DemonHunter) then
		v17.DemonHunter = {};
	end
	v17.DemonHunter.Commons = {Healthstone=v17(6362 - (20 + 830)),RefreshingHealingPotion=v17(149390 + 41990),DreamwalkersHealingPotion=v17(207149 - (116 + 10))};
	v17.DemonHunter.Havoc = v18(v17.DemonHunter.Commons, {});
	v17.DemonHunter.Vengeance = v18(v17.DemonHunter.Commons, {});
	if (not v20.DemonHunter or ((233 + 2910) > (4486 - (542 + 196)))) then
		v20.DemonHunter = {};
	end
	v20.DemonHunter.Commons = {Healthstone=v20(18 - 9),RefreshingHealingPotion=v20(3 + 7),UseWeapon=v20(52 + 49),DisruptMouseover=v20(4 + 7),ImprisonMouseover=v20(31 - 19),SigilOfFlamePlayer=v20(33 - 20),SigilOfFlameCursor=v20(1565 - (1126 + 425)),MetamorphosisPlayer=v20(422 - (118 + 287)),SigilOfMiseryPlayer=v20(74 - 55),SigilOfMiseryCursor=v20(1141 - (118 + 1003)),ThrowGlaiveMouseover=v20(64 - 42),ElysianDecreePlayer=v20(404 - (142 + 235)),ElysianDecreeCursor=v20(126 - 98)};
	v20.DemonHunter.Havoc = v18(v20.DemonHunter.Commons, {});
	v20.DemonHunter.Vengeance = v18(v20.DemonHunter.Commons, {SigilOfSilencePlayer=v20(4 + 11),SigilOfSilenceCursor=v20(993 - (553 + 424)),InfernalStrikePlayer=v20(33 - 15),InfernalStrikeCursor=v20(19 + 2),SigilOfChainsPlayer=v20(23 + 0),SigilOfChainsCursor=v20(14 + 10)});
end;
return v0["Epix_DemonHunter_DemonHunter.lua"]();

