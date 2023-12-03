local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 209 - (133 + 76);
	local v6;
	while true do
		if ((v5 == (1655 - (1594 + 61))) or ((2233 - (108 + 1553)) >= (4999 - (232 + 281)))) then
			v6 = v0[v4];
			if (((2657 - (976 + 277)) == (2361 - (892 + 65))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
		end
		if ((v5 == (1 - 0)) or ((6880 - 3132) < (2562 - (87 + 263)))) then
			return v6(...);
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
	if (not v16.DemonHunter or ((1360 - (67 + 113)) == (1599 + 581))) then
		v16.DemonHunter = {};
	end
	v16.DemonHunter.Commons = {ArcaneTorrent=v16(124263 - 73650, nil, 1 + 0),Glide=v16(522036 - 390689, nil, 954 - (802 + 150)),ImmolationAura=v16(697100 - 438180, nil, 5 - 2),ChaosNova=v16(130334 + 48723, nil, 1001 - (915 + 82)),CollectiveAnguish=v16(1104744 - 714592, nil, 56 + 40),ConcentratedSigils=v16(273110 - 65444, nil, 1259 - (1069 + 118)),ConsumeMagic=v16(631440 - 353114, nil, 205 - 111),Darkness=v16(34199 + 162519, nil, 164 - 71),Demonic=v16(211703 + 1707, nil, 796 - (368 + 423)),ElysianDecree=v16(1226157 - 835994, nil, 24 - (10 + 8)),Felblade=v16(895877 - 662984, nil, 449 - (416 + 26)),FodderToTheFlame=v16(1249800 - 858371, nil, 4 + 4),Imprison=v16(385438 - 167606, nil, 447 - (145 + 293)),ImprovedDisrupt=v16(320791 - (44 + 386), nil, 1598 - (998 + 488)),SigilOfFlame=v17(4 + 6, 167528 + 37068, 205285 - (201 + 571), 390948 - (116 + 1022)),SigilOfMisery=v17(187 - 142, 228811 + 161002, 737950 - 535810, 737507 - 529822),SoulSigils=v16(396305 - (814 + 45), nil, 238 - 141),TheHunt=v16(19990 + 350975, nil, 4 + 7),VengefulRetreat=v16(199678 - (261 + 624), nil, 88 - 38),Disrupt=v16(184832 - (1020 + 60), nil, 1435 - (630 + 793)),ImmolationAuraBuff=v16(877393 - 618473, nil, 61 - 48),SigilOfFlameDebuff=v16(80578 + 124020, nil, 48 - 34),Pool=v16(1001657 - (760 + 987), nil, 1928 - (1789 + 124))};
	v16.DemonHunter.Havoc = v19(v16.DemonHunter.Commons, {Annihilation=v16(202193 - (745 + 21), nil, 6 + 10),BladeDance=v16(518682 - 330183, nil, 66 - 49),Blur=v16(1624 + 196965, nil, 15 + 3),ChaosStrike=v16(163849 - (87 + 968), nil, 83 - 64),DeathSweep=v16(190664 + 19488, nil, 45 - 25),DemonsBite=v16(163656 - (447 + 966), nil, 57 - 36),FelRush=v16(196889 - (1703 + 114), nil, 723 - (376 + 325)),Metamorphosis=v16(313708 - 122281, nil, 70 - 47),ThrowGlaive=v16(52904 + 132219, nil, 52 - 28),AFireInside=v16(427789 - (9 + 5), nil, 474 - (85 + 291)),AnyMeansNecessary=v16(389379 - (243 + 1022), nil, 380 - 280),BlindFury=v16(167922 + 35628, nil, 1205 - (1123 + 57)),BurningWound=v16(318289 + 72900, nil, 280 - (163 + 91)),ChaosTheory=v16(391617 - (1869 + 61), nil, 8 + 19),ChaoticTransformation=v16(1366935 - 978823, nil, 42 - 14),CycleOfHatred=v16(35426 + 223461, nil, 39 - 10),DemonBlades=v16(191194 + 12361, nil, 1504 - (1329 + 145)),EssenceBreak=v16(259831 - (140 + 831), nil, 1881 - (1409 + 441)),EyeBeam=v16(198731 - (15 + 703), nil, 15 + 17),FelBarrage=v16(259363 - (262 + 176), nil, 1754 - (345 + 1376)),FelEruption=v16(212569 - (198 + 490), nil, 150 - 116),FirstBlood=v16(495128 - 288712, nil, 1241 - (696 + 510)),FuriousGaze=v16(720021 - 376710, nil, 1298 - (1091 + 171)),FuriousThrows=v16(63247 + 329782, nil, 116 - 79),GlaiveTempest=v16(1136895 - 794078, nil, 412 - (123 + 251)),Inertia=v16(2124922 - 1697282, nil, 797 - (208 + 490)),Initiative=v16(32751 + 355357, nil, 18 + 21),InnerDemon=v16(390529 - (660 + 176), nil, 5 + 35),IsolatedPrey=v16(388315 - (14 + 188), nil, 716 - (534 + 141)),MiseryInDefeat=v16(156027 + 232083, nil, 92 + 11),Momentum=v16(198516 + 7960, nil, 87 - 45),Netherwalk=v16(312054 - 115499, nil, 266 - 171),Ragefire=v16(208404 + 179703, nil, 28 + 15),RestlessHunter=v16(390538 - (115 + 281), nil, 241 - 137),SerratedGlaive=v16(323025 + 67129, nil, 105 - 61),ShatteredDestiny=v16(1423144 - 1035028, nil, 968 - (550 + 317)),Soulscar=v16(560728 - 172622, nil, 64 - 18),TacticalRetreat=v16(1088975 - 699287, nil, 332 - (134 + 151)),TrailofRuin=v16(260546 - (970 + 695), nil, 91 - 43),UnboundChaos=v16(349451 - (582 + 1408), nil, 169 - 120),ChaosTheoryBuff=v16(490951 - 100756, nil, 192 - 141),FuriousGazeBuff=v16(345136 - (1195 + 629), nil, 68 - 16),InertiaBuff=v16(427882 - (187 + 54), nil, 885 - (162 + 618)),InnerDemonBuff=v16(273374 + 116771, nil, 36 + 17),InitiativeBuff=v16(834345 - 443130, nil, 170 - 68),MetamorphosisBuff=v16(12688 + 149576, nil, 1690 - (1373 + 263)),MomentumBuff=v16(209628 - (451 + 549), nil, 18 + 37),TacticalRetreatBuff=v16(606766 - 216876, nil, 93 - 37),UnboundChaosBuff=v16(348846 - (746 + 638), nil, 22 + 35),BurningWoundDebuff=v16(593938 - 202747, nil, 399 - (218 + 123)),EssenceBreakDebuff=v16(321919 - (1535 + 46), nil, 59 + 0),SerratedGlaiveDebuff=v16(56457 + 333698, nil, 620 - (306 + 254))});
	v16.DemonHunter.Vengeance = v19(v16.DemonHunter.Commons, {InfernalStrike=v16(11708 + 177402, nil, 119 - 58),Shear=v16(205249 - (899 + 568), nil, 41 + 21),SoulCleave=v16(552892 - 324415, nil, 666 - (268 + 335)),SoulFragments=v16(204271 - (60 + 230), nil, 636 - (426 + 146)),ThrowGlaive=v16(24457 + 179700, nil, 1521 - (282 + 1174)),DemonSpikes=v16(204531 - (569 + 242), nil, 190 - 124),Torment=v16(10594 + 174651, nil, 1091 - (706 + 318)),AgonizingFlames=v16(208799 - (721 + 530), nil, 1339 - (945 + 326)),BulkExtraction=v16(800313 - 479972, nil, 62 + 7),BurningAlive=v16(208439 - (271 + 429), nil, 65 + 5),BurningBlood=v16(391713 - (1408 + 92), nil, 1192 - (461 + 625)),CharredFlesh=v16(337927 - (993 + 295), nil, 4 + 67),CycleofBinding=v16(390889 - (418 + 753), nil, 41 + 66),DarkglareBoon=v16(40164 + 349544, nil, 22 + 51),DownInFlames=v16(98496 + 291236, nil, 603 - (406 + 123)),Fallout=v16(228943 - (1749 + 20), nil, 18 + 57),FelDevastation=v16(213406 - (1249 + 73), nil, 28 + 48),FieryBrand=v16(205166 - (466 + 679), nil, 185 - 108),FieryDemise=v16(1113241 - 724021, nil, 1978 - (106 + 1794)),FocusedCleave=v16(108575 + 234632, nil, 28 + 80),Frailty=v16(1151312 - 761354, nil, 213 - 134),Fracture=v16(263756 - (4 + 110), nil, 664 - (57 + 527)),ShearFury=v16(391424 - (41 + 1386), nil, 212 - (17 + 86)),SigilOfChains=v17(63 + 29, 450790 - 248652, 601386 - 393721, 389973 - (122 + 44)),SigilOfSilence=v17(139 - 58, 688978 - 481296, 164436 + 37701, 56376 + 333433),SoulBarrier=v16(534113 - 270465, nil, 147 - (30 + 35)),SoulCarver=v16(142554 + 64853, nil, 1340 - (1043 + 214)),SoulCrush=v16(1474399 - 1084414, nil, 1296 - (323 + 889)),SpiritBomb=v16(666057 - 418603, nil, 665 - (361 + 219)),StoketheFlames=v16(394147 - (53 + 267), nil, 25 + 85),Vulnerability=v16(390389 - (15 + 398), nil, 1068 - (18 + 964)),Metamorphosis=v16(707002 - 519175, nil, 51 + 36),DemonSpikesBuff=v16(128414 + 75405, nil, 938 - (20 + 830)),MetamorphosisBuff=v16(146616 + 41211, nil, 215 - (116 + 10)),RecriminationBuff=v16(30277 + 379600, nil, 849 - (542 + 196)),FieryBrandDebuff=v16(445400 - 237629, nil, 27 + 63),FrailtyDebuff=v16(125725 + 121731, nil, 33 + 58)});
	if (((10777 - 6687) < (11929 - 7276)) and not v18.DemonHunter) then
		v18.DemonHunter = {};
	end
	v18.DemonHunter.Commons = {Healthstone=v18(7063 - (1126 + 425)),RefreshingHealingPotion=v18(191785 - (118 + 287)),DreamwalkersHealingPotion=v18(811383 - 604360)};
	v18.DemonHunter.Havoc = v19(v18.DemonHunter.Commons, {});
	v18.DemonHunter.Vengeance = v19(v18.DemonHunter.Commons, {});
	if (not v21.DemonHunter or ((3773 - (118 + 1003)) < (573 - 377))) then
		v21.DemonHunter = {};
	end
	v21.DemonHunter.Commons = {Healthstone=v21(386 - (142 + 235)),RefreshingHealingPotion=v21(45 - 35),DisruptMouseover=v21(3 + 8),ImprisonMouseover=v21(989 - (553 + 424)),SigilOfFlamePlayer=v21(23 - 10),SigilOfFlameCursor=v21(13 + 1),MetamorphosisPlayer=v21(17 + 0),SigilOfMiseryPlayer=v21(12 + 7),SigilOfMiseryCursor=v21(9 + 11),ThrowGlaiveMouseover=v21(13 + 9),ElysianDecreePlayer=v21(58 - 31),ElysianDecreeCursor=v21(77 - 49)};
	v21.DemonHunter.Havoc = v19(v21.DemonHunter.Commons, {});
	v21.DemonHunter.Vengeance = v19(v21.DemonHunter.Commons, {SigilOfSilencePlayer=v21(33 - 18),SigilOfSilenceCursor=v21(5 + 11),InfernalStrikePlayer=v21(86 - 68),InfernalStrikeCursor=v21(774 - (239 + 514)),SigilOfChainsPlayer=v21(9 + 14),SigilOfChainsCursor=v21(1353 - (797 + 532))});
end;
return v0["Epix_DemonHunter_DemonHunter.lua"]();

