local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((4944 - (226 + 1044)) >= (2246 - 1730)) and (v5 == (118 - (32 + 85)))) then
			return v6(...);
		end
		if (((2269 + 46) == (514 + 1801)) and (v5 == (957 - (892 + 65)))) then
			v6 = v0[v4];
			if (not v6 or ((7497 - 4354) > (6927 - 3179))) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
	end
end
v0["Epix_DemonHunter_DemonHunter.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v12.Player;
	local v14 = v12.Target;
	local v15 = v12.Pet;
	local v16 = v10.Spell;
	local v17 = v10.MultiSpell;
	local v18 = v10.Item;
	local v19 = v10.Utils.MergeTableByKey;
	local v20 = EpicLib;
	local v21 = v20.Macro;
	if (not v16.DemonHunter or ((1944 - (87 + 263)) > (2360 - (67 + 113)))) then
		v16.DemonHunter = {};
	end
	v16.DemonHunter.Commons = {ArcaneTorrent=v16(37114 + 13499, nil, 2 - 1),Glide=v16(96600 + 34747, nil, 7 - 5),ImmolationAura=v16(259872 - (802 + 150), nil, 7 - 4),ChaosNova=v16(324802 - 145745, nil, 3 + 1),CollectiveAnguish=v16(391149 - (915 + 82), nil, 271 - 175),ConcentratedSigils=v16(120976 + 86690, nil, 94 - 22),ConsumeMagic=v16(279513 - (1069 + 118), nil, 213 - 119),Darkness=v16(430315 - 233597, nil, 17 + 76),Demonic=v16(379186 - 165776, nil, 5 + 0),ElysianDecree=v16(390954 - (368 + 423), nil, 18 - 12),Felblade=v16(232911 - (10 + 8), nil, 26 - 19),FodderToTheFlame=v16(391871 - (416 + 26), nil, 25 - 17),Imprison=v16(93483 + 124349, nil, 15 - 6),ImprovedDisrupt=v16(320799 - (145 + 293), nil, 542 - (44 + 386)),SigilOfFlame=v17(1496 - (998 + 488), 64999 + 139597, 167460 + 37053, 390582 - (201 + 571)),SigilOfMisery=v17(1183 - (116 + 1022), 1622895 - 1233082, 118652 + 83488, 758193 - 550508),SoulSigils=v16(1404263 - 1008817, nil, 956 - (814 + 45)),TheHunt=v16(914044 - 543079, nil, 1 + 10),VengefulRetreat=v16(70241 + 128552, nil, 935 - (261 + 624)),Disrupt=v16(326544 - 142792, nil, 1092 - (1020 + 60)),ImmolationAuraBuff=v16(260343 - (630 + 793), nil, 43 - 30),SigilOfFlameDebuff=v16(968722 - 764124, nil, 6 + 8),Pool=v16(3442734 - 2442824, nil, 1762 - (760 + 987))};
	v16.DemonHunter.Havoc = v19(v16.DemonHunter.Commons, {Annihilation=v16(203340 - (1789 + 124), nil, 782 - (745 + 21)),BladeDance=v16(64838 + 123661, nil, 46 - 29),Blur=v16(778968 - 580379, nil, 1 + 17),ChaosStrike=v16(127814 + 34980, nil, 1074 - (87 + 968)),DeathSweep=v16(925077 - 714925, nil, 19 + 1),DemonsBite=v16(366757 - 204514, nil, 1434 - (447 + 966)),FelRush=v16(534039 - 338967, nil, 1839 - (1703 + 114)),Metamorphosis=v16(192128 - (376 + 325), nil, 37 - 14),ThrowGlaive=v16(569618 - 384495, nil, 7 + 17),AFireInside=v16(942167 - 514392, nil, 112 - (9 + 5)),AnyMeansNecessary=v16(388490 - (85 + 291), nil, 1365 - (243 + 1022)),BlindFury=v16(774544 - 570994, nil, 21 + 4),BurningWound=v16(392369 - (1123 + 57), nil, 22 + 4),ChaosTheory=v16(389941 - (163 + 91), nil, 1957 - (1869 + 61)),ChaoticTransformation=v16(108428 + 279684, nil, 98 - 70),CycleOfHatred=v16(397637 - 138750, nil, 4 + 25),DemonBlades=v16(279734 - 76179, nil, 29 + 1),EssenceBreak=v16(260334 - (1329 + 145), nil, 1002 - (140 + 831)),EyeBeam=v16(199863 - (1409 + 441), nil, 750 - (15 + 703)),FelBarrage=v16(119910 + 139015, nil, 471 - (262 + 176)),FelEruption=v16(213602 - (345 + 1376), nil, 722 - (198 + 490)),FirstBlood=v16(911937 - 705521, nil, 83 - 48),FuriousGaze=v16(344517 - (696 + 510), nil, 75 - 39),FuriousThrows=v16(394291 - (1091 + 171), nil, 6 + 31),GlaiveTempest=v16(1079304 - 736487, nil, 125 - 87),Inertia=v16(428014 - (123 + 251), nil, 491 - 392),Initiative=v16(388806 - (208 + 490), nil, 4 + 35),InnerDemon=v16(173587 + 216106, nil, 876 - (660 + 176)),IsolatedPrey=v16(46630 + 341483, nil, 243 - (14 + 188)),MiseryInDefeat=v16(388785 - (534 + 141), nil, 42 + 61),Momentum=v16(182637 + 23839, nil, 41 + 1),Netherwalk=v16(413069 - 216514, nil, 150 - 55),Ragefire=v16(1088657 - 700550, nil, 24 + 19),RestlessHunter=v16(248409 + 141733, nil, 500 - (115 + 281)),SerratedGlaive=v16(907512 - 517358, nil, 37 + 7),ShatteredDestiny=v16(937980 - 549864, nil, 370 - 269),Soulscar=v16(388973 - (550 + 317), nil, 66 - 20),TacticalRetreat=v16(547734 - 158046, nil, 131 - 84),TrailofRuin=v16(259166 - (134 + 151), nil, 1713 - (970 + 695)),UnboundChaos=v16(663037 - 315576, nil, 2039 - (582 + 1408)),ChaosTheoryBuff=v16(1353226 - 963031, nil, 63 - 12),FelBarrageBuff=v16(975721 - 716796, nil, 1937 - (1195 + 629)),FuriousGazeBuff=v16(454028 - 110716, nil, 293 - (187 + 54)),InertiaBuff=v16(428421 - (162 + 618), nil, 74 + 31),InnerDemonBuff=v16(259853 + 130292, nil, 112 - 59),InitiativeBuff=v16(657707 - 266492, nil, 8 + 94),MetamorphosisBuff=v16(163900 - (1373 + 263), nil, 1054 - (451 + 549)),MomentumBuff=v16(65856 + 142772, nil, 85 - 30),TacticalRetreatBuff=v16(655273 - 265383, nil, 1440 - (746 + 638)),UnboundChaosBuff=v16(130763 + 216699, nil, 85 - 28),BurningWoundDebuff=v16(391532 - (218 + 123), nil, 1639 - (1535 + 46)),EssenceBreakDebuff=v16(318288 + 2050, nil, 9 + 50),SerratedGlaiveDebuff=v16(390715 - (306 + 254), nil, 4 + 56)});
	v16.DemonHunter.Vengeance = v19(v16.DemonHunter.Commons, {InfernalStrike=v16(371136 - 182026, nil, 1528 - (899 + 568)),Shear=v16(133946 + 69836, nil, 149 - 87),SoulCleave=v16(229080 - (268 + 335), nil, 353 - (60 + 230)),SoulFragments=v16(204553 - (426 + 146), nil, 8 + 56),ThrowGlaive=v16(205613 - (282 + 1174), nil, 876 - (569 + 242)),DemonSpikes=v16(586834 - 383114, nil, 4 + 62),Torment=v16(186269 - (706 + 318), nil, 1318 - (721 + 530)),AscendingFlame=v16(429874 - (945 + 326), nil, 284 - 170),AgonizingFlames=v16(184681 + 22867, nil, 768 - (271 + 429)),BulkExtraction=v16(294266 + 26075, nil, 1569 - (1408 + 92)),BurningAlive=v16(208825 - (461 + 625), nil, 1358 - (993 + 295)),BurningBlood=v16(20262 + 369951, nil, 1277 - (418 + 753)),CharredFlesh=v16(128210 + 208429, nil, 8 + 63),CycleofBinding=v16(113986 + 275732, nil, 28 + 79),DarkglareBoon=v16(390237 - (406 + 123), nil, 1842 - (1749 + 20)),DownInFlames=v16(92572 + 297160, nil, 1396 - (1249 + 73)),Fallout=v16(81049 + 146125, nil, 1220 - (466 + 679)),FelDevastation=v16(510161 - 298077, nil, 217 - 141),FieryBrand=v16(205921 - (106 + 1794), nil, 25 + 52),FieryDemise=v16(98387 + 290833, nil, 230 - 152),FocusedCleave=v16(929384 - 586177, nil, 222 - (4 + 110)),Frailty=v16(390542 - (57 + 527), nil, 1506 - (41 + 1386)),Fracture=v16(263745 - (17 + 86), nil, 55 + 25),ShearFury=v16(869737 - 479740, nil, 315 - 206),SigilOfChains=v17(258 - (122 + 44), 349159 - 147021, 688922 - 481257, 317102 + 72705),SigilOfSilence=v17(12 + 69, 420733 - 213051, 202202 - (30 + 35), 267920 + 121889),SoulBarrier=v16(264905 - (1043 + 214), nil, 309 - 227),SoulCarver=v16(208619 - (323 + 889), nil, 222 - 139),SoulCrush=v16(390565 - (361 + 219), nil, 404 - (53 + 267)),SpiritBomb=v16(55905 + 191549, nil, 498 - (15 + 398)),StoketheFlames=v16(394809 - (18 + 964), nil, 414 - 304),Vulnerability=v16(225782 + 164194, nil, 55 + 31),Metamorphosis=v16(188677 - (20 + 830), nil, 68 + 19),DemonSpikesBuff=v16(203945 - (116 + 10), nil, 7 + 81),MetamorphosisBuff=v16(188565 - (542 + 196), nil, 190 - 101),RecriminationBuff=v16(119691 + 290186, nil, 57 + 54),FieryBrandDebuff=v16(74791 + 132980, nil, 237 - 147),FrailtyDebuff=v16(634425 - 386969, nil, 1642 - (1126 + 425))});
	if (((3479 - (118 + 287)) == (12047 - 8973)) and not v18.DemonHunter) then
		v18.DemonHunter = {};
	end
	v18.DemonHunter.Commons = {Healthstone=v18(6633 - (118 + 1003)),RefreshingHealingPotion=v18(560060 - 368680),DreamwalkersHealingPotion=v18(207400 - (142 + 235))};
	v18.DemonHunter.Havoc = v19(v18.DemonHunter.Commons, {});
	v18.DemonHunter.Vengeance = v19(v18.DemonHunter.Commons, {});
	if (((1678 - 1308) >= (43 + 153)) and not v21.DemonHunter) then
		v21.DemonHunter = {};
	end
	v21.DemonHunter.Commons = {Healthstone=v21(986 - (553 + 424)),RefreshingHealingPotion=v21(18 - 8),UseWeapon=v21(89 + 12),DisruptMouseover=v21(11 + 0),ImprisonMouseover=v21(7 + 5),SigilOfFlamePlayer=v21(6 + 7),SigilOfFlameCursor=v21(8 + 6),MetamorphosisPlayer=v21(36 - 19),SigilOfMiseryPlayer=v21(52 - 33),SigilOfMiseryCursor=v21(44 - 24),ThrowGlaiveMouseover=v21(7 + 15),ElysianDecreePlayer=v21(130 - 103),ElysianDecreeCursor=v21(781 - (239 + 514))};
	v21.DemonHunter.Havoc = v19(v21.DemonHunter.Commons, {});
	v21.DemonHunter.Vengeance = v19(v21.DemonHunter.Commons, {SigilOfSilencePlayer=v21(6 + 9),SigilOfSilenceCursor=v21(1345 - (797 + 532)),InfernalStrikePlayer=v21(14 + 4),InfernalStrikeCursor=v21(8 + 13),SigilOfChainsPlayer=v21(53 - 30),SigilOfChainsCursor=v21(1226 - (373 + 829))});
end;
return v0["Epix_DemonHunter_DemonHunter.lua"]();

