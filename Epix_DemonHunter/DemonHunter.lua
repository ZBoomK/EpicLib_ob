local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((2387 - (68 + 997)) > (4818 - (226 + 1044)))) then
			v6 = v0[v4];
			if (not v6 or ((2490 - 1918) >= (4603 - (32 + 85)))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if (((312 + 1092) == (2361 - (892 + 65))) and (v5 == (2 - 1))) then
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
	if (not v16.DemonHunter or ((6927 - 3179) < (4060 - 1848))) then
		v16.DemonHunter = {};
	end
	v16.DemonHunter.Commons = {ArcaneTorrent=v16(203069 - (87 + 263), nil, 181 - (67 + 113)),Glide=v16(96314 + 35033, nil, 4 - 2),ImmolationAura=v16(190424 + 68496, nil, 11 - 8),ChaosNova=v16(180009 - (802 + 150), nil, 10 - 6),CollectiveAnguish=v16(707720 - 317568, nil, 70 + 26),ConcentratedSigils=v16(208663 - (915 + 82), nil, 203 - 131),ConsumeMagic=v16(162138 + 116188, nil, 122 - 28),Darkness=v16(197905 - (1069 + 118), nil, 210 - 117),Demonic=v16(466828 - 253418, nil, 1 + 4),ElysianDecree=v16(693240 - 303077, nil, 6 + 0),Felblade=v16(233684 - (368 + 423), nil, 21 - 14),FodderToTheFlame=v16(391447 - (10 + 8), nil, 30 - 22),Imprison=v16(218274 - (416 + 26), nil, 28 - 19),ImprovedDisrupt=v16(137484 + 182877, nil, 197 - 85),SigilOfFlame=v17(448 - (145 + 293), 205026 - (44 + 386), 205999 - (998 + 488), 123840 + 265970),SigilOfMisery=v17(37 + 8, 390585 - (201 + 571), 203278 - (116 + 1022), 864648 - 656963),SoulSigils=v16(232118 + 163328, nil, 354 - 257),TheHunt=v16(1317329 - 946364, nil, 870 - (814 + 45)),VengefulRetreat=v16(489818 - 291025, nil, 3 + 47),Disrupt=v16(64927 + 118825, nil, 897 - (261 + 624)),ImmolationAuraBuff=v16(460126 - 201206, nil, 1093 - (1020 + 60)),SigilOfFlameDebuff=v16(206021 - (630 + 793), nil, 47 - 33),Pool=v16(4734332 - 3734422, nil, 6 + 9)};
	v16.DemonHunter.Havoc = v19(v16.DemonHunter.Commons, {Annihilation=v16(693521 - 492094, nil, 1763 - (760 + 987)),BladeDance=v16(190412 - (1789 + 124), nil, 783 - (745 + 21)),Blur=v16(68308 + 130281, nil, 49 - 31),ChaosStrike=v16(638561 - 475767, nil, 1 + 18),DeathSweep=v16(164995 + 45157, nil, 1075 - (87 + 968)),DemonsBite=v16(714184 - 551941, nil, 20 + 1),FelRush=v16(440969 - 245897, nil, 1435 - (447 + 966)),Metamorphosis=v16(524060 - 332633, nil, 1840 - (1703 + 114)),ThrowGlaive=v16(185824 - (376 + 325), nil, 38 - 14),AFireInside=v16(1316253 - 888478, nil, 29 + 69),AnyMeansNecessary=v16(854814 - 466700, nil, 114 - (9 + 5)),BlindFury=v16(203926 - (85 + 291), nil, 1290 - (243 + 1022)),BurningWound=v16(1488543 - 1097354, nil, 22 + 4),ChaosTheory=v16(390867 - (1123 + 57), nil, 22 + 5),ChaoticTransformation=v16(388366 - (163 + 91), nil, 1958 - (1869 + 61)),CycleOfHatred=v16(72326 + 186561, nil, 101 - 72),DemonBlades=v16(312650 - 109095, nil, 5 + 25),EssenceBreak=v16(355737 - 96877, nil, 30 + 1),EyeBeam=v16(199487 - (1329 + 145), nil, 1003 - (140 + 831)),FelBarrage=v16(260775 - (1409 + 441), nil, 751 - (15 + 703)),FelEruption=v16(98124 + 113757, nil, 472 - (262 + 176)),FirstBlood=v16(208137 - (345 + 1376), nil, 723 - (198 + 490)),FuriousGaze=v16(1516734 - 1173423, nil, 86 - 50),FuriousThrows=v16(394235 - (696 + 510), nil, 77 - 40),GlaiveTempest=v16(344079 - (1091 + 171), nil, 7 + 31),Inertia=v16(1346356 - 918716, nil, 328 - 229),Initiative=v16(388482 - (123 + 251), nil, 193 - 154),InnerDemon=v16(390391 - (208 + 490), nil, 4 + 36),IsolatedPrey=v16(172884 + 215229, nil, 877 - (660 + 176)),MiseryInDefeat=v16(46630 + 341480, nil, 305 - (14 + 188)),Momentum=v16(207151 - (534 + 141), nil, 17 + 25),Netherwalk=v16(173862 + 22693, nil, 92 + 3),Ragefire=v16(815623 - 427516, nil, 68 - 25),RestlessHunter=v16(1094365 - 704223, nil, 56 + 48),SerratedGlaive=v16(248417 + 141737, nil, 440 - (115 + 281)),ShatteredDestiny=v16(902771 - 514655, nil, 84 + 17),Soulscar=v16(937956 - 549850, nil, 168 - 122),TacticalRetreat=v16(390555 - (550 + 317), nil, 67 - 20),TrailofRuin=v16(363876 - 104995, nil, 134 - 86),UnboundChaos=v16(347746 - (134 + 151), nil, 1714 - (970 + 695)),ChaosTheoryBuff=v16(744584 - 354389, nil, 2041 - (582 + 1408)),FelBarrageBuff=v16(897971 - 639046, nil, 141 - 28),FuriousGazeBuff=v16(1293722 - 950410, nil, 1876 - (1195 + 629)),InertiaBuff=v16(565554 - 137913, nil, 346 - (187 + 54)),InnerDemonBuff=v16(390925 - (162 + 618), nil, 38 + 15),InitiativeBuff=v16(260565 + 130650, nil, 216 - 114),MetamorphosisBuff=v16(272796 - 110532, nil, 5 + 49),MomentumBuff=v16(210264 - (1373 + 263), nil, 1055 - (451 + 549)),TacticalRetreatBuff=v16(123073 + 266817, nil, 86 - 30),UnboundChaosBuff=v16(583965 - 236503, nil, 1441 - (746 + 638)),BurningWoundDebuff=v16(147220 + 243971, nil, 87 - 29),EssenceBreakDebuff=v16(320679 - (218 + 123), nil, 1640 - (1535 + 46)),SerratedGlaiveDebuff=v16(387659 + 2496, nil, 9 + 51)});
	v16.DemonHunter.Vengeance = v19(v16.DemonHunter.Commons, {InfernalStrike=v16(189670 - (306 + 254), nil, 4 + 57),Shear=v16(399930 - 196148, nil, 1529 - (899 + 568)),SoulCleave=v16(150178 + 78299, nil, 152 - 89),SoulFragments=v16(204584 - (268 + 335), nil, 354 - (60 + 230)),ThrowGlaive=v16(204729 - (426 + 146), nil, 8 + 57),DemonSpikes=v16(205176 - (282 + 1174), nil, 877 - (569 + 242)),Torment=v16(533615 - 348370, nil, 4 + 63),AscendingFlame=v16(429627 - (706 + 318), nil, 1365 - (721 + 530)),AgonizingFlames=v16(208819 - (945 + 326), nil, 169 - 101),BulkExtraction=v16(285046 + 35295, nil, 769 - (271 + 429)),BurningAlive=v16(190830 + 16909, nil, 1570 - (1408 + 92)),BurningBlood=v16(391299 - (461 + 625), nil, 1394 - (993 + 295)),CharredFlesh=v16(17481 + 319158, nil, 1242 - (418 + 753)),CycleofBinding=v16(148426 + 241292, nil, 12 + 95),DarkglareBoon=v16(113984 + 275724, nil, 19 + 54),DownInFlames=v16(390261 - (406 + 123), nil, 1843 - (1749 + 20)),Fallout=v16(53960 + 173214, nil, 1397 - (1249 + 73)),FelDevastation=v16(75665 + 136419, nil, 1221 - (466 + 679)),FieryBrand=v16(490766 - 286745, nil, 220 - 143),FieryDemise=v16(391120 - (106 + 1794), nil, 25 + 53),FocusedCleave=v16(86756 + 256451, nil, 318 - 210),Frailty=v16(1055982 - 666024, nil, 193 - (4 + 110)),Fracture=v16(264226 - (57 + 527), nil, 1507 - (41 + 1386)),ShearFury=v16(390100 - (17 + 86), nil, 74 + 35),SigilOfChains=v17(204 - 112, 585380 - 383242, 207831 - (122 + 44), 673325 - 283518),SigilOfSilence=v17(268 - 187, 168947 + 38735, 29234 + 172903, 789696 - 399887),SoulBarrier=v16(263713 - (30 + 35), nil, 57 + 25),SoulCarver=v16(208664 - (1043 + 214), nil, 313 - 230),SoulCrush=v16(391197 - (323 + 889), nil, 225 - 141),SpiritBomb=v16(248034 - (361 + 219), nil, 405 - (53 + 267)),StoketheFlames=v16(88974 + 304853, nil, 523 - (15 + 398)),Vulnerability=v16(390958 - (18 + 964), nil, 323 - 237),Metamorphosis=v16(108745 + 79082, nil, 55 + 32),DemonSpikesBuff=v16(204669 - (20 + 830), nil, 69 + 19),MetamorphosisBuff=v16(187953 - (116 + 10), nil, 7 + 82),RecriminationBuff=v16(410615 - (542 + 196), nil, 237 - 126),FieryBrandDebuff=v16(60673 + 147098, nil, 46 + 44),FrailtyDebuff=v16(89076 + 158380, nil, 239 - 148)});
	if (not v18.DemonHunter or ((3025 - 1845) == (3731 - (1126 + 425)))) then
		v18.DemonHunter = {};
	end
	v18.DemonHunter.Commons = {Healthstone=v18(5917 - (118 + 287)),RefreshingHealingPotion=v18(750074 - 558694),DreamwalkersHealingPotion=v18(208144 - (118 + 1003))};
	v18.DemonHunter.Havoc = v19(v18.DemonHunter.Commons, {});
	v18.DemonHunter.Vengeance = v19(v18.DemonHunter.Commons, {});
	if (((11969 - 7879) < (5030 - (142 + 235))) and not v21.DemonHunter) then
		v21.DemonHunter = {};
	end
	v21.DemonHunter.Commons = {Healthstone=v21(40 - 31),RefreshingHealingPotion=v21(3 + 7),UseWeapon=v21(1078 - (553 + 424)),DisruptMouseover=v21(20 - 9),ImprisonMouseover=v21(11 + 1),SigilOfFlamePlayer=v21(13 + 0),SigilOfFlameCursor=v21(9 + 5),MetamorphosisPlayer=v21(8 + 9),SigilOfMiseryPlayer=v21(11 + 8),SigilOfMiseryCursor=v21(43 - 23),ThrowGlaiveMouseover=v21(60 - 38),ElysianDecreePlayer=v21(60 - 33),ElysianDecreeCursor=v21(9 + 19)};
	v21.DemonHunter.Havoc = v19(v21.DemonHunter.Commons, {});
	v21.DemonHunter.Vengeance = v19(v21.DemonHunter.Commons, {SigilOfSilencePlayer=v21(72 - 57),SigilOfSilenceCursor=v21(769 - (239 + 514)),InfernalStrikePlayer=v21(7 + 11),InfernalStrikeCursor=v21(1350 - (797 + 532)),SigilOfChainsPlayer=v21(17 + 6),SigilOfChainsCursor=v21(9 + 15)});
end;
return v0["Epix_DemonHunter_DemonHunter.lua"]();

