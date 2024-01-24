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
	v16.DemonHunter.Vengeance = v19(v16.DemonHunter.Commons, {InfernalStrike=v16(371136 - 182026, nil, 1528 - (899 + 568)),Shear=v16(133946 + 69836, nil, 149 - 87),SoulCleave=v16(229080 - (268 + 335), nil, 353 - (60 + 230)),SoulFragments=v16(204553 - (426 + 146), nil, 8 + 56),ThrowGlaive=v16(205613 - (282 + 1174), nil, 876 - (569 + 242)),DemonSpikes=v16(586834 - 383114, nil, 4 + 62),Torment=v16(186269 - (706 + 318), nil, 1318 - (721 + 530)),AgonizingFlames=v16(208819 - (945 + 326), nil, 169 - 101),BulkExtraction=v16(285046 + 35295, nil, 769 - (271 + 429)),BurningAlive=v16(190830 + 16909, nil, 1570 - (1408 + 92)),BurningBlood=v16(391299 - (461 + 625), nil, 1394 - (993 + 295)),CharredFlesh=v16(17481 + 319158, nil, 1242 - (418 + 753)),CycleofBinding=v16(148426 + 241292, nil, 12 + 95),DarkglareBoon=v16(113984 + 275724, nil, 19 + 54),DownInFlames=v16(390261 - (406 + 123), nil, 1843 - (1749 + 20)),Fallout=v16(53960 + 173214, nil, 1397 - (1249 + 73)),FelDevastation=v16(75665 + 136419, nil, 1221 - (466 + 679)),FieryBrand=v16(490766 - 286745, nil, 220 - 143),FieryDemise=v16(391120 - (106 + 1794), nil, 25 + 53),FocusedCleave=v16(86756 + 256451, nil, 318 - 210),Frailty=v16(1055982 - 666024, nil, 193 - (4 + 110)),Fracture=v16(264226 - (57 + 527), nil, 1507 - (41 + 1386)),ShearFury=v16(390100 - (17 + 86), nil, 74 + 35),SigilOfChains=v17(204 - 112, 585380 - 383242, 207831 - (122 + 44), 673325 - 283518),SigilOfSilence=v17(268 - 187, 168947 + 38735, 29234 + 172903, 789696 - 399887),SoulBarrier=v16(263713 - (30 + 35), nil, 57 + 25),SoulCarver=v16(208664 - (1043 + 214), nil, 313 - 230),SoulCrush=v16(391197 - (323 + 889), nil, 225 - 141),SpiritBomb=v16(248034 - (361 + 219), nil, 405 - (53 + 267)),StoketheFlames=v16(88974 + 304853, nil, 523 - (15 + 398)),Vulnerability=v16(390958 - (18 + 964), nil, 323 - 237),Metamorphosis=v16(108745 + 79082, nil, 55 + 32),DemonSpikesBuff=v16(204669 - (20 + 830), nil, 69 + 19),MetamorphosisBuff=v16(187953 - (116 + 10), nil, 7 + 82),RecriminationBuff=v16(410615 - (542 + 196), nil, 237 - 126),FieryBrandDebuff=v16(60673 + 147098, nil, 46 + 44),FrailtyDebuff=v16(89076 + 158380, nil, 239 - 148)});
	if (((7880 - 4806) == (4625 - (1126 + 425))) and not v18.DemonHunter) then
		v18.DemonHunter = {};
	end
	v18.DemonHunter.Commons = {Healthstone=v18(5917 - (118 + 287)),RefreshingHealingPotion=v18(750074 - 558694),DreamwalkersHealingPotion=v18(208144 - (118 + 1003))};
	v18.DemonHunter.Havoc = v19(v18.DemonHunter.Commons, {});
	v18.DemonHunter.Vengeance = v19(v18.DemonHunter.Commons, {});
	if (((1082 - 712) >= (573 - (142 + 235))) and not v21.DemonHunter) then
		v21.DemonHunter = {};
	end
	v21.DemonHunter.Commons = {Healthstone=v21(40 - 31),RefreshingHealingPotion=v21(3 + 7),DisruptMouseover=v21(988 - (553 + 424)),ImprisonMouseover=v21(22 - 10),SigilOfFlamePlayer=v21(12 + 1),SigilOfFlameCursor=v21(14 + 0),MetamorphosisPlayer=v21(10 + 7),SigilOfMiseryPlayer=v21(9 + 10),SigilOfMiseryCursor=v21(12 + 8),ThrowGlaiveMouseover=v21(47 - 25),ElysianDecreePlayer=v21(75 - 48),ElysianDecreeCursor=v21(62 - 34)};
	v21.DemonHunter.Havoc = v19(v21.DemonHunter.Commons, {});
	v21.DemonHunter.Vengeance = v19(v21.DemonHunter.Commons, {SigilOfSilencePlayer=v21(5 + 10),SigilOfSilenceCursor=v21(77 - 61),InfernalStrikePlayer=v21(771 - (239 + 514)),InfernalStrikeCursor=v21(8 + 13),SigilOfChainsPlayer=v21(1352 - (797 + 532)),SigilOfChainsCursor=v21(18 + 6)});
end;
return v0["Epix_DemonHunter_DemonHunter.lua"]();

