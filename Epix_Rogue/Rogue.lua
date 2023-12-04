local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1740 - (343 + 1397);
	local v6;
	while true do
		if ((v5 == (1157 - (1074 + 82))) or ((5213 - 2834) >= (6362 - (214 + 1570)))) then
			return v6(...);
		end
		if ((v5 == (1455 - (990 + 465))) or ((200 + 283) > (324 + 419))) then
			v6 = v0[v4];
			if (((2387 + 67) > (2274 - 1696)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1727 - (1668 + 58);
		end
	end
end
v0["Epix_Rogue_Rogue.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v12.Player;
	local v14 = v12.Target;
	local v15 = v12.MouseOver;
	local v16 = v10.Spell;
	local v17 = v10.MultiSpell;
	local v18 = v10.Item;
	local v19 = v10.Utils.MergeTableByKey;
	local v10 = EpicLib;
	local v20 = v10.Commons.Everyone;
	local v21 = v10.Macro;
	local v22 = math.min;
	local v23 = pairs;
	local v24 = C_Timer;
	local v25 = math.max;
	local v26 = math.abs;
	local v23 = v23;
	local v27 = table.insert;
	local v28 = UnitAttackSpeed;
	local v29 = GetTime;
	local v30 = {};
	v10.Commons.Rogue = v30;
	if (((1556 - (512 + 114)) < (11622 - 7164)) and not v16.Rogue) then
		v16.Rogue = {};
	end
	v16.Rogue.Commons = {Sanguine=v16(468273 - 241763, nil, 3 - 2),AncestralCall=v16(127812 + 146926, nil, 1 + 1),ArcanePulse=v16(226344 + 34020, nil, 10 - 7),ArcaneTorrent=v16(27040 - (109 + 1885), nil, 1473 - (1269 + 200)),BagofTricks=v16(598799 - 286388, nil, 820 - (98 + 717)),Berserking=v16(27123 - (802 + 24), nil, 10 - 4),BloodFury=v16(25981 - 5409, nil, 2 + 5),Fireblood=v16(203776 + 61445, nil, 2 + 6),LightsJudgment=v16(55145 + 200502, nil, 24 - 15),Shadowmeld=v16(196697 - 137713, nil, 4 + 6),CloakofShadows=v16(12711 + 18513, nil, 10 + 1),CrimsonVial=v16(134746 + 50565, nil, 6 + 6),Evasion=v16(6710 - (797 + 636), nil, 63 - 50),Feint=v16(3585 - (1427 + 192), nil, 5 + 9),Blind=v16(4861 - 2767, nil, 14 + 1),CheapShot=v16(831 + 1002, nil, 342 - (192 + 134)),Kick=v16(3042 - (316 + 960), nil, 10 + 7),KidneyShot=v16(315 + 93, nil, 17 + 1),Sap=v16(25881 - 19111, nil, 570 - (83 + 468)),Shiv=v16(7744 - (1202 + 604), nil, 93 - 73),SliceandDice=v16(525086 - 209590, nil, 58 - 37),Shadowstep=v16(36879 - (45 + 280), nil, 22 + 0),Sprint=v16(2607 + 376, nil, 9 + 14),TricksoftheTrade=v16(32059 + 25875, nil, 5 + 19),CripplingPoison=v16(6310 - 2902, nil, 1936 - (340 + 1571)),DeadlyPoison=v16(1114 + 1709, nil, 1798 - (1733 + 39)),InstantPoison=v16(867192 - 551608, nil, 1061 - (125 + 909)),AmplifyingPoison=v16(383612 - (1096 + 852), nil, 13 + 15),NumbingPoison=v16(8227 - 2466, nil, 29 + 0),WoundPoison=v16(9191 - (409 + 103), nil, 266 - (46 + 190)),AtrophicPoison=v16(381732 - (51 + 44), nil, 9 + 22),AcrobaticStrikes=v16(198241 - (1114 + 203), nil, 758 - (228 + 498)),Alacrity=v16(41932 + 151607, nil, 19 + 14),ColdBlood=v16(382908 - (174 + 489), nil, 88 - 54),DeeperStratagem=v16(195436 - (830 + 1075)),EchoingReprimand=v16(386140 - (303 + 221), nil, 1305 - (231 + 1038)),EchoingReprimand2=v16(269625 + 53933, nil, 1199 - (171 + 991)),EchoingReprimand3=v16(1333453 - 1009894, nil, 101 - 63),EchoingReprimand4=v16(807429 - 483869, nil, 32 + 7),EchoingReprimand5=v16(1243833 - 888995, nil, 115 - 75),FindWeakness=v16(146725 - 55702, nil, 126 - 85),FindWeaknessDebuff=v16(317468 - (111 + 1137), nil, 200 - (91 + 67)),ImprovedAmbush=v16(1135796 - 754176, nil, 11 + 32),MarkedforDeath=v16(138142 - (423 + 100), nil, 1 + 43),Nightstalker=v16(38935 - 24873, nil, 24 + 21),ResoundingClarity=v16(382393 - (326 + 445), nil, 200 - 154),SealFate=v16(31612 - 17422, nil, 109 - 62),Sepsis=v16(386119 - (530 + 181), nil, 929 - (614 + 267)),SepsisBuff=v16(375971 - (19 + 13), nil, 79 - 30),ShadowDance=v16(431841 - 246528, nil, 142 - 92),ShadowDanceTalent=v16(102567 + 292363, nil, 89 - 38),ShadowDanceBuff=v16(384536 - 199114),Subterfuge=v16(110020 - (1293 + 519), nil, 107 - 54),SubterfugeBuff=v16(300760 - 185568, nil, 102 - 48),ThistleTea=v16(1645599 - 1263976, nil, 753 - 433),Vigor=v16(7936 + 7047),Stealth=v16(364 + 1420, nil, 132 - 75),Stealth2=v16(26619 + 88572, nil, 20 + 38),Vanish=v16(1160 + 696, nil, 1155 - (709 + 387)),VanishBuff=v16(13185 - (673 + 1185), nil, 174 - 114),VanishBuff2=v16(369906 - 254713, nil, 100 - 39),PoolEnergy=v16(715192 + 284718, nil, 47 + 15)};
	v16.Rogue.Assassination = v19(v16.Rogue.Commons, {Ambush=v16(11713 - 3037, nil, 16 + 47),AmplifyingPoisonDebuff=v16(764495 - 381081, nil, 125 - 61),AmplifyingPoisonDebuffDeathmark=v16(396208 - (446 + 1434), nil, 1348 - (1040 + 243)),CripplingPoisonDebuff=v16(10174 - 6765, nil, 1913 - (559 + 1288)),DeadlyPoisonDebuff=v16(4749 - (609 + 1322), nil, 521 - (13 + 441)),DeadlyPoisonDebuffDeathmark=v16(1473523 - 1079199, nil, 177 - 109),Envenom=v16(162586 - 129941, nil, 3 + 66),FanofKnives=v16(187847 - 136124, nil, 25 + 45),Garrote=v16(309 + 394, nil, 210 - 139),GarroteDeathmark=v16(197450 + 163380, nil, 132 - 60),Mutilate=v16(879 + 450, nil, 41 + 32),PoisonedKnife=v16(133330 + 52235, nil, 63 + 11),Rupture=v16(1902 + 41, nil, 508 - (153 + 280)),RuptureDeathmark=v16(1041921 - 681095, nil, 69 + 7),WoundPoisonDebuff=v16(3428 + 5252, nil, 41 + 36),ArterialPrecision=v16(363703 + 37080, nil, 57 + 21),AtrophicPoisonDebuff=v16(597495 - 205107, nil, 49 + 30),BlindsideBuff=v16(121820 - (89 + 578), nil, 58 + 22),CrimsonTempest=v16(252410 - 130999, nil, 1130 - (572 + 477)),CutToTheChase=v16(6969 + 44698, nil, 50 + 32),DashingScoundrel=v16(45573 + 336224, nil, 169 - (84 + 2)),Deathmark=v16(593624 - 233430, nil, 61 + 23),Doomblade=v16(382515 - (497 + 345), nil, 3 + 82),DragonTemperedBlades=v16(64542 + 317259, nil, 1419 - (605 + 728)),Elusiveness=v16(56371 + 22637),Exsanguinate=v16(446448 - 245642, nil, 5 + 83),ImprovedGarrote=v16(1410983 - 1029351, nil, 81 + 8),ImprovedGarroteBuff=v16(1087199 - 694798, nil, 68 + 22),ImprovedGarroteAura=v16(392892 - (457 + 32), nil, 39 + 52),IndiscriminateCarnage=v16(383204 - (832 + 570), nil, 87 + 5),IndiscriminateCarnageBuff=v16(100594 + 285153),InternalBleeding=v16(548349 - 393396, nil, 45 + 48),Kingsbane=v16(386423 - (588 + 208), nil, 253 - 159),LightweightShiv=v16(396783 - (884 + 916)),MasterAssassin=v16(535933 - 279944, nil, 56 + 39),MasterAssassinBuff=v16(257388 - (232 + 421), nil, 1985 - (1569 + 320)),PreyontheWeak=v16(32266 + 99245, nil, 19 + 78),PreyontheWeakDebuff=v16(862365 - 606456, nil, 703 - (316 + 289)),SerratedBoneSpike=v16(1008932 - 623508, nil, 5 + 94),SerratedBoneSpikeDebuff=v16(395489 - (666 + 787), nil, 525 - (360 + 65)),ShivDebuff=v16(298598 + 20906, nil, 355 - (79 + 175)),VenomRush=v16(239918 - 87766, nil, 80 + 22),ScentOfBlood=v16(1170319 - 788520, nil, 762 - 366),ScentOfBloodBuff=v16(394979 - (503 + 396)),ShroudedSuffocation=v16(385659 - (92 + 89))});
	v16.Rogue.Outlaw = v19(v16.Rogue.Commons, {AdrenalineRush=v16(26674 - 12924, nil, 53 + 50),Ambush=v16(5135 + 3541, nil, 407 - 303),AmbushOverride=v16(58807 + 371216),BetweentheEyes=v16(719018 - 403677, nil, 92 + 13),BladeFlurry=v16(6629 + 7248, nil, 322 - 216),Dispatch=v16(262 + 1836, nil, 162 - 55),Elusiveness=v16(80252 - (485 + 759)),Opportunity=v16(452657 - 257030),PistolShot=v16(186952 - (442 + 747), nil, 1245 - (832 + 303)),RolltheBones=v16(316454 - (88 + 858), nil, 34 + 77),SinisterStrike=v16(159988 + 33327, nil, 5 + 107),Audacity=v16(382634 - (766 + 23), nil, 557 - 444),AudacityBuff=v16(528285 - 142015, nil, 300 - 186),BladeRush=v16(922759 - 650882, nil, 1188 - (1036 + 37)),CountTheOdds=v16(270816 + 111166, nil, 225 - 109),Dreadblades=v16(269927 + 73215, nil, 1597 - (641 + 839)),FanTheHammer=v16(382759 - (910 + 3), nil, 300 - 182),GhostlyStrike=v16(198621 - (1466 + 218), nil, 55 + 64),GreenskinsWickers=v16(387971 - (556 + 592), nil, 43 + 77),GreenskinsWickersBuff=v16(394939 - (329 + 479), nil, 975 - (174 + 680)),HiddenOpportunity=v16(1317020 - 933739, nil, 252 - 130),ImprovedAdrenalineRush=v16(282320 + 113102, nil, 862 - (396 + 343)),ImprovedBetweenTheEyes=v16(20836 + 214648, nil, 1601 - (29 + 1448)),KeepItRolling=v16(383378 - (135 + 1254), nil, 470 - 345),KillingSpree=v16(241347 - 189657, nil, 84 + 42),LoadedDice=v16(257697 - (389 + 1138), nil, 701 - (102 + 472)),LoadedDiceBuff=v16(241747 + 14424, nil, 71 + 57),PreyontheWeak=v16(122625 + 8886, nil, 1674 - (320 + 1225)),PreyontheWeakDebuff=v16(455566 - 199657, nil, 80 + 50),QuickDraw=v16(198402 - (157 + 1307), nil, 1990 - (821 + 1038)),SummarilyDispatched=v16(953061 - 571071, nil, 15 + 117),SwiftSlasher=v16(678512 - 296524, nil, 50 + 83),TakeEmBySurpriseBuff=v16(956497 - 570590, nil, 1160 - (834 + 192)),Weaponmaster=v16(12762 + 187971, nil, 35 + 100),UnderhandedUpperhand=v16(9104 + 414940),DeftManeuvers=v16(591606 - 209728),Crackshot=v16(424007 - (300 + 4)),Gouge=v16(475 + 1301, nil, 355 - 219),Broadside=v16(193718 - (112 + 250), nil, 55 + 82),BuriedTreasure=v16(500048 - 300448, nil, 80 + 58),GrandMelee=v16(99998 + 93360, nil, 104 + 35),RuthlessPrecision=v16(95873 + 97484, nil, 105 + 35),SkullandCrossbones=v16(201017 - (1001 + 413), nil, 314 - 173),TrueBearing=v16(194241 - (244 + 638), nil, 835 - (627 + 66)),ViciousFollowup=v16(1176595 - 781716, nil, 745 - (512 + 90))});
	v16.Rogue.Subtlety = v19(v16.Rogue.Commons, {Backstab=v16(1959 - (1665 + 241), nil, 861 - (373 + 344)),BlackPowder=v16(143955 + 175220, nil, 39 + 106),Elusiveness=v16(208401 - 129393),Eviscerate=v16(333069 - 136250, nil, 1246 - (35 + 1064)),Rupture=v16(1414 + 529, nil, 316 - 168),ShadowBlades=v16(485 + 120986, nil, 1385 - (298 + 938)),Shadowstrike=v16(186697 - (233 + 1026), nil, 1816 - (636 + 1030)),ShurikenStorm=v16(101147 + 96688, nil, 148 + 3),ShurikenToss=v16(33870 + 80144, nil, 11 + 141),SymbolsofDeath=v16(212504 - (55 + 166), nil, 30 + 123),DanseMacabre=v16(38468 + 344060, nil, 588 - 434),DanseMacabreBuff=v16(394266 - (36 + 261), nil, 270 - 115),DeeperDaggers=v16(383885 - (34 + 1334), nil, 60 + 96),DeeperDaggersBuff=v16(297900 + 85505, nil, 1440 - (1035 + 248)),DarkBrew=v16(382525 - (20 + 1), nil, 83 + 75),DarkShadow=v16(246006 - (134 + 185), nil, 1292 - (549 + 584)),EnvelopingShadows=v16(238789 - (314 + 371), nil, 549 - 389),Finality=v16(383493 - (478 + 490), nil, 86 + 75),FinalityBlackPowderBuff=v16(387120 - (786 + 386), nil, 524 - 362),FinalityEviscerateBuff=v16(387328 - (1055 + 324), nil, 1503 - (1093 + 247)),FinalityRuptureBuff=v16(342969 + 42982, nil, 18 + 146),Flagellation=v16(1527053 - 1142422, nil, 559 - 394),FlagellationPersistBuff=v16(1123291 - 728533, nil, 417 - 251),Gloomblade=v16(71415 + 129343, nil, 643 - 476),GoremawsBite=v16(1470368 - 1043777),ImprovedShadowDance=v16(297068 + 96904, nil, 429 - 261),ImprovedShurikenStorm=v16(320639 - (364 + 324), nil, 462 - 293),InvigoratingShadowdust=v16(917913 - 535390),LingeringShadow=v16(126781 + 255743, nil, 711 - 541),LingeringShadowBuff=v16(618131 - 232171, nil, 519 - 348),MasterofShadows=v16(198244 - (1249 + 19), nil, 156 + 16),PerforatedVeins=v16(1488955 - 1106437, nil, 1259 - (686 + 400)),PerforatedVeinsBuff=v16(309333 + 84921, nil, 403 - (73 + 156)),PreyontheWeak=v16(623 + 130888, nil, 986 - (721 + 90)),PreyontheWeakDebuff=v16(2878 + 253031, nil, 571 - 395),Premeditation=v16(343630 - (224 + 246), nil, 286 - 109),PremeditationBuff=v16(631863 - 288690, nil, 33 + 145),SecretStratagem=v16(9384 + 384936, nil, 132 + 47),SecretTechnique=v16(558113 - 277394, nil, 599 - 419),Shadowcraft=v16(427107 - (203 + 310)),ShadowFocus=v16(110202 - (1238 + 755), nil, 13 + 168),ShurikenTornado=v16(279459 - (709 + 825), nil, 334 - 152),SilentStorm=v16(561883 - 176161, nil, 1047 - (196 + 668)),SilentStormBuff=v16(1522941 - 1137219, nil, 380 - 196),TheFirstDance=v16(383338 - (171 + 662), nil, 278 - (4 + 89)),TheRotten=v16(1338955 - 956940, nil, 68 + 118),TheRottenBuff=v16(1731430 - 1337227, nil, 74 + 113),Weaponmaster=v16(195023 - (35 + 1451), nil, 1641 - (28 + 1425))});
	if (((2655 - (941 + 1052)) <= (933 + 39)) and not v18.Rogue) then
		v18.Rogue = {};
	end
	v18.Rogue.Commons = {AlgetharPuzzleBox=v18(195215 - (822 + 692), {(7 + 6),(14 + 0)}),ManicGrieftorch=v18(66872 + 127436, {(446 - (114 + 319)),(17 - 3)}),WindscarWhetstone=v18(87646 + 49840, {(26 - 13),(1220 - (741 + 465))}),Healthstone=v18(5977 - (170 + 295)),RefreshingHealingPotion=v18(100837 + 90543)};
	v18.Rogue.Assassination = v19(v18.Rogue.Commons, {AlgetharPuzzleBox=v18(177920 + 15781, {(11 + 2),(8 + 6)}),AshesoftheEmbersoul=v18(208397 - (957 + 273), {(6 + 7),(36 - 22)}),WitherbarksBranch=v18(335992 - 225993, {(1793 - (389 + 1391)),(2 + 12)})});
	v18.Rogue.Outlaw = v19(v18.Rogue.Commons, {ManicGrieftorch=v18(442364 - 248056, {(43 - 30),(325 - (309 + 2))}),WindscarWhetstone=v18(422206 - 284720, {(5 + 8),(10 + 4)}),BeaconToTheBeyond=v18(205081 - (628 + 490), {(32 - 19),(788 - (431 + 343))}),DragonfireBombDispenser=v18(409192 - 206582, {(11 + 2),(1709 - (556 + 1139))})});
	v18.Rogue.Subtlety = v19(v18.Rogue.Commons, {ManicGrieftorch=v18(194323 - (6 + 9), {(7 + 6),(6 + 8)}),StormEatersBoon=v18(239837 - 45535, {(1330 - (486 + 831)),(48 - 34)}),BeaconToTheBeyond=v18(38542 + 165421, {(1276 - (668 + 595)),(3 + 11)}),AshesoftheEmbersoul=v18(564964 - 357797, {(1957 - (1129 + 815)),(1764 - (1326 + 424))}),WitherbarksBranch=v18(208335 - 98336, {(131 - (88 + 30)),(30 - 16)}),BandolierOfTwistedBlades=v18(208941 - (421 + 1355), {(7 + 6),(51 - 37)}),Mirror=v18(343831 - 136250, {(5 + 8),(21 - 7)})});
	v30.StealthSpell = function()
		return (v16.Rogue.Commons.Subterfuge:IsAvailable() and v16.Rogue.Commons.Stealth2) or v16.Rogue.Commons.Stealth;
	end;
	v30.VanishBuffSpell = function()
		return (v16.Rogue.Commons.Subterfuge:IsAvailable() and v16.Rogue.Commons.VanishBuff2) or v16.Rogue.Commons.VanishBuff;
	end;
	v30.Stealth = function(v46, v47)
		local v48 = 785 - (222 + 563);
		while true do
			if (((9628 - 5258) == (3147 + 1223)) and (v48 == (190 - (23 + 167)))) then
				if ((EpicSettings.Settings['StealthOOC'] and (v16.Rogue.Commons.Stealth:IsCastable() or v16.Rogue.Commons.Stealth2:IsCastable()) and v13:StealthDown()) or ((6560 - (690 + 1108)) <= (311 + 550))) then
					if (v10.Press(v46, nil) or ((1165 + 247) == (5112 - (40 + 808)))) then
						return "Cast Stealth (OOC)";
					end
				end
				return false;
			end
		end
	end;
	do
		local v49 = 0 + 0;
		local v50;
		while true do
			if ((v49 == (0 - 0)) or ((3028 + 140) < (1139 + 1014))) then
				v50 = v16(101620 + 83691);
				v30.CrimsonVial = function()
					local v147 = 571 - (47 + 524);
					local v148;
					while true do
						if ((v147 == (1 + 0)) or ((13602 - 8626) < (1990 - 658))) then
							return false;
						end
						if (((10554 - 5926) == (6354 - (1165 + 561))) and (v147 == (0 + 0))) then
							v148 = EpicSettings.Settings['CrimsonVialHP'] or (0 - 0);
							if ((v50:IsCastable() and (v13:HealthPercentage() <= v148)) or ((21 + 33) == (874 - (341 + 138)))) then
								if (((23 + 59) == (168 - 86)) and v10.Cast(v50, nil)) then
									return "Cast Crimson Vial (Defensives)";
								end
							end
							v147 = 327 - (89 + 237);
						end
					end
				end;
				break;
			end
		end
	end
	do
		local v51 = 0 - 0;
		local v52;
		while true do
			if ((v51 == (0 - 0)) or ((1462 - (581 + 300)) < (1502 - (855 + 365)))) then
				v52 = v16(4669 - 2703);
				v30.Feint = function()
					local v149 = 0 + 0;
					local v150;
					while true do
						if ((v149 == (1235 - (1030 + 205))) or ((4327 + 282) < (2322 + 173))) then
							v150 = EpicSettings.Settings['FeintHP'] or (286 - (156 + 130));
							if (((2617 - 1465) == (1940 - 788)) and v52:IsCastable() and v13:BuffDown(v52) and (v13:HealthPercentage() <= v150)) then
								if (((3882 - 1986) <= (902 + 2520)) and v10.Cast(v52, nil)) then
									return "Cast Feint (Defensives)";
								end
							end
							break;
						end
					end
				end;
				break;
			end
		end
	end
	do
		local v53 = 0 + 0;
		local v54 = false;
		local function v55(v108)
			if ((not v13:AffectingCombat() and v13:BuffRefreshable(v108)) or ((1059 - (10 + 59)) > (459 + 1161))) then
				if (v10.Press(v108, nil, true) or ((4319 - 3442) > (5858 - (671 + 492)))) then
					return "poison";
				end
			end
		end
		v30.Poisons = function()
			local v109 = 0 + 0;
			while true do
				if (((3906 - (369 + 846)) >= (491 + 1360)) and (v109 == (1 + 0))) then
					if (v13:BuffDown(v16.Rogue.Commons.CripplingPoison) or ((4930 - (1036 + 909)) >= (3861 + 995))) then
						if (((7178 - 2902) >= (1398 - (11 + 192))) and v16.Rogue.Commons.AtrophicPoison:IsAvailable()) then
							local v230 = v55(v16.Rogue.Commons.AtrophicPoison);
							if (((1634 + 1598) <= (4865 - (135 + 40))) and v230) then
								return v230;
							end
						elseif (v16.Rogue.Commons.NumbingPoison:IsAvailable() or ((2170 - 1274) >= (1897 + 1249))) then
							local v248 = 0 - 0;
							local v249;
							while true do
								if (((4588 - 1527) >= (3134 - (50 + 126))) and ((0 - 0) == v248)) then
									v249 = v55(v16.Rogue.Commons.NumbingPoison);
									if (((706 + 2481) >= (2057 - (1233 + 180))) and v249) then
										return v249;
									end
									break;
								end
							end
						else
							local v250 = 969 - (522 + 447);
							local v251;
							while true do
								if (((2065 - (107 + 1314)) <= (327 + 377)) and (v250 == (0 - 0))) then
									v251 = v55(v16.Rogue.Commons.CripplingPoison);
									if (((407 + 551) > (1880 - 933)) and v251) then
										return v251;
									end
									break;
								end
							end
						end
					else
						local v215 = 0 - 0;
						local v216;
						while true do
							if (((6402 - (716 + 1194)) >= (46 + 2608)) and (v215 == (0 + 0))) then
								v216 = v55(v16.Rogue.Commons.CripplingPoison);
								if (((3945 - (74 + 429)) >= (2898 - 1395)) and v216) then
									return v216;
								end
								break;
							end
						end
					end
					break;
				end
				if ((v109 == (0 + 0)) or ((7256 - 4086) <= (1036 + 428))) then
					v54 = v13:BuffUp(v16.Rogue.Commons.WoundPoison);
					if (v16.Rogue.Assassination.DragonTemperedBlades:IsAvailable() or ((14788 - 9991) == (10849 - 6461))) then
						local v217 = 433 - (279 + 154);
						local v218;
						while true do
							if (((1329 - (454 + 324)) <= (536 + 145)) and (v217 == (17 - (12 + 5)))) then
								v218 = v55((v54 and v16.Rogue.Commons.WoundPoison) or v16.Rogue.Commons.DeadlyPoison);
								if (((1767 + 1510) > (1036 - 629)) and v218) then
									return v218;
								end
								v217 = 1 + 0;
							end
							if (((5788 - (277 + 816)) >= (6046 - 4631)) and (v217 == (1184 - (1058 + 125)))) then
								if (v16.Rogue.Commons.AmplifyingPoison:IsAvailable() or ((603 + 2609) <= (1919 - (815 + 160)))) then
									local v258 = 0 - 0;
									while true do
										if ((v258 == (0 - 0)) or ((739 + 2357) <= (5255 - 3457))) then
											v218 = v55(v16.Rogue.Commons.AmplifyingPoison);
											if (((5435 - (41 + 1857)) == (5430 - (1222 + 671))) and v218) then
												return v218;
											end
											break;
										end
									end
								else
									v218 = v55(v16.Rogue.Commons.InstantPoison);
									if (((9916 - 6079) >= (2256 - 686)) and v218) then
										return v218;
									end
								end
								break;
							end
						end
					elseif (v54 or ((4132 - (229 + 953)) == (5586 - (1111 + 663)))) then
						local v231 = 1579 - (874 + 705);
						local v232;
						while true do
							if (((662 + 4061) >= (1582 + 736)) and (v231 == (0 - 0))) then
								v232 = v55(v16.Rogue.Commons.WoundPoison);
								if (v232 or ((58 + 1969) > (3531 - (642 + 37)))) then
									return v232;
								end
								break;
							end
						end
					elseif ((v16.Rogue.Commons.AmplifyingPoison:IsAvailable() and v13:BuffDown(v16.Rogue.Commons.DeadlyPoison)) or ((260 + 876) > (691 + 3626))) then
						local v252 = 0 - 0;
						local v253;
						while true do
							if (((5202 - (233 + 221)) == (10979 - 6231)) and ((0 + 0) == v252)) then
								v253 = v55(v16.Rogue.Commons.AmplifyingPoison);
								if (((5277 - (718 + 823)) <= (2983 + 1757)) and v253) then
									return v253;
								end
								break;
							end
						end
					elseif (v16.Rogue.Commons.DeadlyPoison:IsAvailable() or ((4195 - (266 + 539)) <= (8663 - 5603))) then
						local v259 = 1225 - (636 + 589);
						local v260;
						while true do
							if (((0 - 0) == v259) or ((2060 - 1061) > (2135 + 558))) then
								v260 = v55(v16.Rogue.Commons.DeadlyPoison);
								if (((169 + 294) < (1616 - (657 + 358))) and v260) then
									return v260;
								end
								break;
							end
						end
					else
						local v261 = 0 - 0;
						local v262;
						while true do
							if ((v261 == (0 - 0)) or ((3370 - (1151 + 36)) < (664 + 23))) then
								v262 = v55(v16.Rogue.Commons.InstantPoison);
								if (((1196 + 3353) == (13585 - 9036)) and v262) then
									return v262;
								end
								break;
							end
						end
					end
					v109 = 1833 - (1552 + 280);
				end
			end
		end;
	end
	v30.MfDSniping = function(v57)
		if (((5506 - (64 + 770)) == (3173 + 1499)) and v57:IsCastable()) then
			local v111, v112 = nil, 136 - 76;
			local v113 = (v15:IsInRange(6 + 24) and v15:TimeToDie()) or (12354 - (157 + 1086));
			for v116, v117 in v23(v13:GetEnemiesInRange(60 - 30)) do
				local v118 = 0 - 0;
				local v119;
				while true do
					if ((v118 == (0 - 0)) or ((5005 - 1337) < (1214 - (599 + 220)))) then
						v119 = v117:TimeToDie();
						if ((not v117:IsMfDBlacklisted() and (v119 < (v13:ComboPointsDeficit() * (1.5 - 0))) and (v119 < v112)) or ((6097 - (1813 + 118)) == (333 + 122))) then
							if (((v113 - v119) > (1218 - (841 + 376))) or ((6233 - 1784) == (619 + 2044))) then
								v111, v112 = v117, v119;
							else
								v111, v112 = v15, v113;
							end
						end
						break;
					end
				end
			end
			if ((v111 and (v111:GUID() ~= v14:GUID())) or ((11674 - 7397) < (3848 - (464 + 395)))) then
				v10.Press(v111, v57);
			end
		end
	end;
	v30.CanDoTUnit = function(v58, v59)
		return v20.CanDoTUnit(v58, v59);
	end;
	do
		local v60 = 0 - 0;
		local v61;
		local v62;
		local v63;
		local v64;
		while true do
			if ((v60 == (2 + 1)) or ((1707 - (467 + 370)) >= (8573 - 4424))) then
				v61.Rupture:RegisterPMultiplier(v63, {v62.FinalityRuptureBuff,(1.3 + 0)});
				v61.Garrote:RegisterPMultiplier(v63, v64);
				v60 = 8 - 4;
			end
			if (((2732 - (150 + 370)) < (4465 - (74 + 1208))) and ((2 - 1) == v60)) then
				v63 = nil;
				function v63()
					if (((22034 - 17388) > (2129 + 863)) and v61.Nightstalker:IsAvailable() and v13:StealthUp(true, false, true)) then
						return (391 - (14 + 376)) + ((0.05 - 0) * v61.Nightstalker:TalentRank());
					end
					return 1 + 0;
				end
				v60 = 2 + 0;
			end
			if (((1368 + 66) < (9100 - 5994)) and (v60 == (4 + 0))) then
				v61.CrimsonTempest:RegisterPMultiplier(v63);
				break;
			end
			if (((864 - (23 + 55)) < (7164 - 4141)) and (v60 == (2 + 0))) then
				v64 = nil;
				function v64()
					local v151 = 0 + 0;
					while true do
						if ((v151 == (0 - 0)) or ((769 + 1673) < (975 - (652 + 249)))) then
							if (((12136 - 7601) == (6403 - (708 + 1160))) and v61.ImprovedGarrote:IsAvailable() and (v13:BuffUp(v61.ImprovedGarroteAura, nil, true) or v13:BuffUp(v61.ImprovedGarroteBuff, nil, true) or v13:BuffUp(v61.SepsisBuff, nil, true))) then
								return 2.5 - 1;
							end
							return 1 - 0;
						end
					end
				end
				v60 = 30 - (10 + 17);
			end
			if ((v60 == (0 + 0)) or ((4741 - (1400 + 332)) <= (4037 - 1932))) then
				v61 = v16.Rogue.Assassination;
				v62 = v16.Rogue.Subtlety;
				v60 = 1909 - (242 + 1666);
			end
		end
	end
	do
		local v65 = 0 + 0;
		local v66;
		local v67;
		local v68;
		while true do
			if (((671 + 1159) < (3127 + 542)) and (v65 == (940 - (850 + 90)))) then
				v66 = v16(338964 - 145433);
				v67 = v16(395711 - (360 + 1030));
				v65 = 1 + 0;
			end
			if ((v65 == (2 - 1)) or ((1967 - 537) >= (5273 - (909 + 752)))) then
				v68 = v16(395543 - (109 + 1114));
				v30.CPMaxSpend = function()
					return (9 - 4) + ((v66:IsAvailable() and (1 + 0)) or (242 - (6 + 236))) + ((v67:IsAvailable() and (1 + 0)) or (0 + 0)) + ((v68:IsAvailable() and (2 - 1)) or (0 - 0));
				end;
				break;
			end
		end
	end
	v30.CPSpend = function()
		return v22(v13:ComboPoints(), v30.CPMaxSpend());
	end;
	do
		local v69 = 1133 - (1076 + 57);
		while true do
			if (((442 + 2241) >= (3149 - (579 + 110))) and (v69 == (0 + 0))) then
				v30.AnimachargedCP = function()
					if (v13:BuffUp(v16.Rogue.Commons.EchoingReprimand2) or ((1595 + 209) >= (1739 + 1536))) then
						return 409 - (174 + 233);
					elseif (v13:BuffUp(v16.Rogue.Commons.EchoingReprimand3) or ((3957 - 2540) > (6368 - 2739))) then
						return 2 + 1;
					elseif (((5969 - (663 + 511)) > (359 + 43)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand4)) then
						return 1 + 3;
					elseif (((14838 - 10025) > (2159 + 1406)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand5)) then
						return 11 - 6;
					end
					return -(2 - 1);
				end;
				v30.EffectiveComboPoints = function(v152)
					local v153 = 0 + 0;
					while true do
						if (((7613 - 3701) == (2788 + 1124)) and ((0 + 0) == v153)) then
							if (((3543 - (478 + 244)) <= (5341 - (440 + 77))) and (((v152 == (1 + 1)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand2)) or ((v152 == (10 - 7)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand3)) or ((v152 == (1560 - (655 + 901))) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand4)) or ((v152 == (1 + 4)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand5)))) then
								return 6 + 1;
							end
							return v152;
						end
					end
				end;
				break;
			end
		end
	end
	do
		local v70 = 0 + 0;
		local v71;
		local v72;
		local v73;
		local v74;
		local v75;
		while true do
			if (((7001 - 5263) <= (3640 - (695 + 750))) and (v70 == (0 - 0))) then
				v71 = v16.Rogue.Assassination.DeadlyPoisonDebuff;
				v72 = v16.Rogue.Assassination.WoundPoisonDebuff;
				v70 = 1 - 0;
			end
			if (((164 - 123) <= (3369 - (285 + 66))) and (v70 == (4 - 2))) then
				v75 = v16.Rogue.Assassination.AtrophicPoisonDebuff;
				v30.Poisoned = function(v154)
					return ((v154:DebuffUp(v71) or v154:DebuffUp(v73) or v154:DebuffUp(v74) or v154:DebuffUp(v72) or v154:DebuffUp(v75)) and true) or false;
				end;
				break;
			end
			if (((3455 - (682 + 628)) <= (662 + 3442)) and (v70 == (300 - (176 + 123)))) then
				v73 = v16.Rogue.Assassination.AmplifyingPoisonDebuff;
				v74 = v16.Rogue.Assassination.CripplingPoisonDebuff;
				v70 = 1 + 1;
			end
		end
	end
	do
		local v76 = 0 + 0;
		local v77;
		local v78;
		local v79;
		local v80;
		local v81;
		local v82;
		while true do
			if (((2958 - (239 + 30)) < (1318 + 3527)) and (v76 == (2 + 0))) then
				v81 = v16.Rogue.Assassination.InternalBleeding;
				v82 = 0 - 0;
				v76 = 8 - 5;
			end
			if ((v76 == (316 - (306 + 9))) or ((8102 - 5780) > (456 + 2166))) then
				v79 = v16.Rogue.Assassination.Rupture;
				v80 = v16.Rogue.Assassination.RuptureDeathmark;
				v76 = 2 + 0;
			end
			if ((v76 == (0 + 0)) or ((12965 - 8431) == (3457 - (1140 + 235)))) then
				v77 = v16.Rogue.Assassination.Garrote;
				v78 = v16.Rogue.Assassination.GarroteDeathmark;
				v76 = 1 + 0;
			end
			if ((v76 == (3 + 0)) or ((404 + 1167) > (1919 - (33 + 19)))) then
				v30.PoisonedBleeds = function()
					local v155 = 0 + 0;
					while true do
						if (((0 - 0) == v155) or ((1170 + 1484) >= (5874 - 2878))) then
							v82 = 0 + 0;
							for v233, v234 in v23(v13:GetEnemiesInRange(739 - (586 + 103))) do
								if (((363 + 3615) > (6477 - 4373)) and v30.Poisoned(v234)) then
									local v254 = 1488 - (1309 + 179);
									while true do
										if (((5406 - 2411) > (671 + 870)) and (v254 == (2 - 1))) then
											if (((2455 + 794) > (2024 - 1071)) and v234:DebuffUp(v81)) then
												v82 = v82 + (1 - 0);
											end
											break;
										end
										if ((v254 == (609 - (295 + 314))) or ((8038 - 4765) > (6535 - (1300 + 662)))) then
											if (v234:DebuffUp(v77) or ((9894 - 6743) < (3039 - (1178 + 577)))) then
												local v264 = 0 + 0;
												while true do
													if ((v264 == (0 - 0)) or ((3255 - (851 + 554)) == (1353 + 176))) then
														v82 = v82 + (2 - 1);
														if (((1782 - 961) < (2425 - (115 + 187))) and v234:DebuffUp(v78)) then
															v82 = v82 + 1 + 0;
														end
														break;
													end
												end
											end
											if (((854 + 48) < (9162 - 6837)) and v234:DebuffUp(v79)) then
												local v265 = 1161 - (160 + 1001);
												while true do
													if (((751 + 107) <= (2044 + 918)) and (v265 == (0 - 0))) then
														v82 = v82 + (359 - (237 + 121));
														if (v234:DebuffUp(v80) or ((4843 - (525 + 372)) < (2441 - 1153))) then
															v82 = v82 + (3 - 2);
														end
														break;
													end
												end
											end
											v254 = 143 - (96 + 46);
										end
									end
								end
							end
							v155 = 778 - (643 + 134);
						end
						if ((v155 == (1 + 0)) or ((7773 - 4531) == (2104 - 1537))) then
							return v82;
						end
					end
				end;
				break;
			end
		end
	end
	do
		local v83 = 0 + 0;
		local v84;
		while true do
			if ((v83 == (3 - 1)) or ((1731 - 884) >= (1982 - (316 + 403)))) then
				v10:RegisterForSelfCombatEvent(function(v156, v156, v156, v156, v156, v156, v156, v156, v156, v156, v156, v157)
					if ((v157 == (209717 + 105791)) or ((6194 - 3941) == (669 + 1182))) then
						v84 = v29();
					end
				end, "SPELL_AURA_REMOVED");
				break;
			end
			if ((v83 == (0 - 0)) or ((1479 + 608) > (765 + 1607))) then
				v84 = v29();
				v30.RtBRemains = function(v158)
					local v159 = 0 - 0;
					local v160;
					while true do
						if ((v159 == (0 - 0)) or ((9234 - 4789) < (238 + 3911))) then
							v160 = (v84 - v29()) - v10.RecoveryOffset(v158);
							return ((v160 >= (0 - 0)) and v160) or (0 + 0);
						end
					end
				end;
				v83 = 2 - 1;
			end
			if ((v83 == (18 - (12 + 5))) or ((7061 - 5243) == (181 - 96))) then
				v10:RegisterForSelfCombatEvent(function(v161, v161, v161, v161, v161, v161, v161, v161, v161, v161, v161, v162)
					if (((1339 - 709) < (5274 - 3147)) and (v162 == (64034 + 251474))) then
						v84 = v29() + (2003 - (1656 + 317));
					end
				end, "SPELL_AURA_APPLIED");
				v10:RegisterForSelfCombatEvent(function(v163, v163, v163, v163, v163, v163, v163, v163, v163, v163, v163, v164)
					if ((v164 == (281148 + 34360)) or ((1553 + 385) == (6684 - 4170))) then
						v84 = v29() + v22(196 - 156, (384 - (5 + 349)) + v30.RtBRemains(true));
					end
				end, "SPELL_AURA_REFRESH");
				v83 = 9 - 7;
			end
		end
	end
	do
		local v85 = 1271 - (266 + 1005);
		local v86;
		while true do
			if (((2804 + 1451) >= (187 - 132)) and (v85 == (0 - 0))) then
				v86 = {CrimsonTempest={},Garrote={},Rupture={}};
				v30.Exsanguinated = function(v165, v166)
					local v167 = 1696 - (561 + 1135);
					local v168;
					local v169;
					while true do
						if (((3907 - 908) > (3799 - 2643)) and (v167 == (1067 - (507 + 559)))) then
							v169 = v166:ID();
							if (((5896 - 3546) > (3572 - 2417)) and (v169 == (121799 - (212 + 176)))) then
								return v86.CrimsonTempest[v168] or false;
							elseif (((4934 - (250 + 655)) <= (13233 - 8380)) and (v169 == (1228 - 525))) then
								return v86.Garrote[v168] or false;
							elseif ((v169 == (3039 - 1096)) or ((2472 - (1869 + 87)) > (11910 - 8476))) then
								return v86.Rupture[v168] or false;
							end
							v167 = 1903 - (484 + 1417);
						end
						if (((8672 - 4626) >= (5082 - 2049)) and (v167 == (775 - (48 + 725)))) then
							return false;
						end
						if ((v167 == (0 - 0)) or ((7294 - 4575) <= (841 + 606))) then
							v168 = v165:GUID();
							if (not v168 or ((11047 - 6913) < (1099 + 2827))) then
								return false;
							end
							v167 = 1 + 0;
						end
					end
				end;
				v85 = 854 - (152 + 701);
			end
			if ((v85 == (1312 - (430 + 881))) or ((63 + 101) >= (3680 - (557 + 338)))) then
				v30.WillLoseExsanguinate = function(v170, v171)
					local v172 = 0 + 0;
					while true do
						if ((v172 == (0 - 0)) or ((1838 - 1313) == (5602 - 3493))) then
							if (((70 - 37) == (834 - (499 + 302))) and v30.Exsanguinated(v170, v171)) then
								return true;
							end
							return false;
						end
					end
				end;
				v30.ExsanguinatedRate = function(v173, v174)
					local v175 = 866 - (39 + 827);
					while true do
						if (((8430 - 5376) <= (8967 - 4952)) and (v175 == (0 - 0))) then
							if (((2872 - 1001) < (290 + 3092)) and v30.Exsanguinated(v173, v174)) then
								return 5 - 3;
							end
							return 1 + 0;
						end
					end
				end;
				v85 = 2 - 0;
			end
			if (((1397 - (103 + 1)) <= (2720 - (475 + 79))) and (v85 == (4 - 2))) then
				v10:RegisterForSelfCombatEvent(function(v176, v176, v176, v176, v176, v176, v176, v177, v176, v176, v176, v178)
					if ((v178 == (642590 - 441784)) or ((334 + 2245) < (109 + 14))) then
						for v224, v225 in v23(v86) do
							for v235, v236 in v23(v225) do
								if ((v235 == v177) or ((2349 - (1395 + 108)) >= (6890 - 4522))) then
									v225[v235] = true;
								end
							end
						end
					end
				end, "SPELL_CAST_SUCCESS");
				v10:RegisterForSelfCombatEvent(function(v179, v179, v179, v179, v179, v179, v179, v180, v179, v179, v179, v181)
					if ((v181 == (122615 - (7 + 1197))) or ((1750 + 2262) <= (1172 + 2186))) then
						v86.CrimsonTempest[v180] = false;
					elseif (((1813 - (27 + 292)) <= (8805 - 5800)) and (v181 == (895 - 192))) then
						v86.Garrote[v180] = false;
					elseif ((v181 == (8148 - 6205)) or ((6134 - 3023) == (4063 - 1929))) then
						v86.Rupture[v180] = false;
					end
				end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
				v85 = 142 - (43 + 96);
			end
			if (((9606 - 7251) == (5324 - 2969)) and (v85 == (3 + 0))) then
				v10:RegisterForSelfCombatEvent(function(v182, v182, v182, v182, v182, v182, v182, v183, v182, v182, v182, v184)
					if ((v184 == (34282 + 87129)) or ((1162 - 574) <= (166 + 266))) then
						if (((8989 - 4192) >= (1227 + 2668)) and (v86.CrimsonTempest[v183] ~= nil)) then
							v86.CrimsonTempest[v183] = nil;
						end
					elseif (((263 + 3314) == (5328 - (1414 + 337))) and (v184 == (2643 - (1642 + 298)))) then
						if (((9890 - 6096) > (10623 - 6930)) and (v86.Garrote[v183] ~= nil)) then
							v86.Garrote[v183] = nil;
						end
					elseif ((v184 == (5765 - 3822)) or ((420 + 855) == (3190 + 910))) then
						if ((v86.Rupture[v183] ~= nil) or ((2563 - (357 + 615)) >= (2513 + 1067))) then
							v86.Rupture[v183] = nil;
						end
					end
				end, "SPELL_AURA_REMOVED");
				v10:RegisterForCombatEvent(function(v185, v185, v185, v185, v185, v185, v185, v186)
					local v187 = 0 - 0;
					while true do
						if (((843 + 140) <= (3874 - 2066)) and (v187 == (0 + 0))) then
							if ((v86.CrimsonTempest[v186] ~= nil) or ((147 + 2003) <= (753 + 444))) then
								v86.CrimsonTempest[v186] = nil;
							end
							if (((5070 - (384 + 917)) >= (1870 - (128 + 569))) and (v86.Garrote[v186] ~= nil)) then
								v86.Garrote[v186] = nil;
							end
							v187 = 1544 - (1407 + 136);
						end
						if (((3372 - (687 + 1200)) == (3195 - (556 + 1154))) and (v187 == (3 - 2))) then
							if ((v86.Rupture[v186] ~= nil) or ((3410 - (9 + 86)) <= (3203 - (275 + 146)))) then
								v86.Rupture[v186] = nil;
							end
							break;
						end
					end
				end, "UNIT_DIED", "UNIT_DESTROYED");
				break;
			end
		end
	end
	do
		local v87 = 0 + 0;
		local v88;
		local v89;
		local v90;
		while true do
			if ((v87 == (66 - (29 + 35))) or ((3882 - 3006) >= (8852 - 5888))) then
				v10:RegisterForSelfCombatEvent(function(v188, v188, v188, v188, v188, v188, v188, v188, v188, v188, v188, v189, v188, v188, v190, v191)
					if ((v189 == (820053 - 634290)) or ((1454 + 778) > (3509 - (53 + 959)))) then
						if (((v29() - v90) > (408.5 - (312 + 96))) or ((3662 - 1552) <= (617 - (147 + 138)))) then
							local v239 = 899 - (813 + 86);
							while true do
								if (((3331 + 355) > (5876 - 2704)) and ((492 - (18 + 474)) == v239)) then
									v89 = v22(v30.CPMaxSpend(), v13:ComboPoints() + v190 + (v25(0 + 0, v190 - (3 - 2)) * v22(1088 - (860 + 226), v13:BuffStack(v88) - (304 - (121 + 182)))));
									v90 = v29();
									break;
								end
							end
						end
					end
				end, "SPELL_ENERGIZE");
				break;
			end
			if ((v87 == (0 + 0)) or ((5714 - (988 + 252)) < (93 + 727))) then
				v88 = v16(61277 + 134350);
				v89 = 1970 - (49 + 1921);
				v87 = 891 - (223 + 667);
			end
			if (((4331 - (51 + 1)) >= (4959 - 2077)) and (v87 == (1 - 0))) then
				v90 = v29();
				v30.FanTheHammerCP = function()
					if ((((v29() - v90) < (1125.5 - (146 + 979))) and (v89 > (0 + 0))) or ((2634 - (311 + 294)) >= (9818 - 6297))) then
						if ((v89 > v13:ComboPoints()) or ((863 + 1174) >= (6085 - (496 + 947)))) then
							return v89;
						else
							v89 = 1358 - (1233 + 125);
						end
					end
					return 0 + 0;
				end;
				v87 = 2 + 0;
			end
		end
	end
	do
		local v91 = 0 + 0;
		local v92;
		local v93;
		local v94;
		while true do
			if (((3365 - (963 + 682)) < (3721 + 737)) and (v91 == (1505 - (504 + 1000)))) then
				v30.TimeToNextTornado = function()
					local v192 = 0 + 0;
					local v193;
					while true do
						if (((0 + 0) == v192) or ((42 + 394) > (4454 - 1433))) then
							if (((610 + 103) <= (493 + 354)) and not v13:BuffUp(v94, nil, true)) then
								return 182 - (156 + 26);
							end
							v193 = v13:BuffRemains(v94, nil, true) % (1 + 0);
							v192 = 1 - 0;
						end
						if (((2318 - (149 + 15)) <= (4991 - (890 + 70))) and ((118 - (39 + 78)) == v192)) then
							if (((5097 - (14 + 468)) == (10148 - 5533)) and (v29() == v92)) then
								return 0 - 0;
							elseif ((((v29() - v92) < (0.1 + 0)) and (v193 < (0.25 + 0))) or ((806 + 2984) == (226 + 274))) then
								return 1 + 0;
							elseif (((169 - 80) < (219 + 2)) and ((v193 > (0.9 - 0)) or (v193 == (0 + 0))) and ((v29() - v92) > (51.75 - (12 + 39)))) then
								return 0.1 + 0;
							end
							return v193;
						end
					end
				end;
				v10:RegisterForSelfCombatEvent(function(v194, v194, v194, v194, v194, v194, v194, v194, v194, v194, v194, v195)
					local v196 = 0 - 0;
					while true do
						if (((7315 - 5261) >= (422 + 999)) and ((0 + 0) == v196)) then
							if (((1754 - 1062) < (2037 + 1021)) and (v195 == (1028139 - 815396))) then
								v92 = v29();
							elseif ((v195 == (199545 - (1596 + 114))) or ((8495 - 5241) == (2368 - (164 + 549)))) then
								v93 = v29();
							end
							if ((v93 == v92) or ((2734 - (1059 + 379)) == (6096 - 1186))) then
								v92 = 0 + 0;
							end
							break;
						end
					end
				end, "SPELL_CAST_SUCCESS");
				break;
			end
			if (((568 + 2800) == (3760 - (145 + 247))) and (v91 == (0 + 0))) then
				v92, v93 = 0 + 0, 0 - 0;
				v94 = v16(53323 + 224602);
				v91 = 1 + 0;
			end
		end
	end
	do
		local v95 = 0 - 0;
		local v96;
		while true do
			if (((3363 - (254 + 466)) < (4375 - (544 + 16))) and ((2 - 1) == v95)) then
				v10:RegisterForSelfCombatEvent(function()
					local v197 = 628 - (294 + 334);
					while true do
						if (((2166 - (236 + 17)) > (213 + 280)) and (v197 == (0 + 0))) then
							v96.Counter = 0 - 0;
							v96.LastMH = v29();
							v197 = 4 - 3;
						end
						if (((2449 + 2306) > (2824 + 604)) and (v197 == (795 - (413 + 381)))) then
							v96.LastOH = v29();
							break;
						end
					end
				end, "PLAYER_ENTERING_WORLD");
				v10:RegisterForSelfCombatEvent(function(v198, v198, v198, v198, v198, v198, v198, v198, v198, v198, v198, v199)
					if (((59 + 1322) <= (5038 - 2669)) and (v199 == (511500 - 314589))) then
						v96.Counter = 1970 - (582 + 1388);
					end
				end, "SPELL_ENERGIZE");
				v95 = 2 - 0;
			end
			if (((0 + 0) == v95) or ((5207 - (326 + 38)) == (12081 - 7997))) then
				v96 = {Counter=(0 - 0),LastMH=(620 - (47 + 573)),LastOH=(0 + 0)};
				v30.TimeToSht = function(v200)
					local v201 = 0 - 0;
					local v202;
					local v203;
					local v204;
					local v205;
					local v206;
					local v207;
					while true do
						if (((7577 - 2908) > (2027 - (1269 + 395))) and (v201 == (496 - (76 + 416)))) then
							return v206[v207] - v29();
						end
						if ((v201 == (443 - (319 + 124))) or ((4290 - 2413) >= (4145 - (564 + 443)))) then
							if (((13127 - 8385) >= (4084 - (337 + 121))) and (v96.Counter >= v200)) then
								return 0 - 0;
							end
							v202, v203 = v28("player");
							v201 = 3 - 2;
						end
						if ((v201 == (1912 - (1261 + 650))) or ((1921 + 2619) == (1459 - 543))) then
							v204 = v25(v96.LastMH + v202, v29());
							v205 = v25(v96.LastOH + v203, v29());
							v201 = 1819 - (772 + 1045);
						end
						if (((1 + 2) == v201) or ((1300 - (102 + 42)) > (6189 - (1524 + 320)))) then
							table.sort(v206);
							v207 = v22(1275 - (1049 + 221), v25(157 - (18 + 138), v200 - v96.Counter));
							v201 = 9 - 5;
						end
						if (((3339 - (67 + 1035)) < (4597 - (136 + 212))) and (v201 == (8 - 6))) then
							v206 = {};
							for v240 = 0 + 0, 2 + 0 do
								local v241 = 1604 - (240 + 1364);
								while true do
									if ((v241 == (1082 - (1050 + 32))) or ((9579 - 6896) < (14 + 9))) then
										v27(v206, v204 + (v240 * v202));
										v27(v206, v205 + (v240 * v203));
										break;
									end
								end
							end
							v201 = 1058 - (331 + 724);
						end
					end
				end;
				v95 = 1 + 0;
			end
			if (((1341 - (269 + 375)) <= (1551 - (267 + 458))) and (v95 == (1 + 1))) then
				v10:RegisterForSelfCombatEvent(function(v208, v208, v208, v208, v208, v208, v208, v208, v208, v208, v208, v208, v208, v208, v208, v208, v208, v208, v208, v208, v208, v208, v208, v209)
					local v210 = 0 - 0;
					while true do
						if (((1923 - (667 + 151)) <= (2673 - (1410 + 87))) and (v210 == (1897 - (1504 + 393)))) then
							v96.Counter = v96.Counter + (2 - 1);
							if (((8766 - 5387) <= (4608 - (461 + 335))) and v209) then
								v96.LastOH = v29();
							else
								v96.LastMH = v29();
							end
							break;
						end
					end
				end, "SWING_DAMAGE");
				v10:RegisterForSelfCombatEvent(function(v211, v211, v211, v211, v211, v211, v211, v211, v211, v211, v211, v211, v211, v211, v211, v212)
					if (v212 or ((101 + 687) >= (3377 - (1730 + 31)))) then
						v96.LastOH = v29();
					else
						v96.LastMH = v29();
					end
				end, "SWING_MISSED");
				break;
			end
		end
	end
	do
		local v97 = 1667 - (728 + 939);
		local v98;
		local v99;
		local v100;
		while true do
			if (((6566 - 4712) <= (6853 - 3474)) and ((0 - 0) == v97)) then
				v98 = v13:CritChancePct();
				v99 = 1068 - (138 + 930);
				v97 = 1 + 0;
			end
			if (((3557 + 992) == (3899 + 650)) and (v97 == (8 - 6))) then
				v10:RegisterForEvent(function()
					if ((v99 == (1766 - (459 + 1307))) or ((4892 - (474 + 1396)) >= (5280 - 2256))) then
						local v223 = 0 + 0;
						while true do
							if (((16 + 4804) > (6295 - 4097)) and (v223 == (0 + 0))) then
								v24.After(9 - 6, v100);
								v99 = 8 - 6;
								break;
							end
						end
					end
				end, "PLAYER_EQUIPMENT_CHANGED");
				v30.BaseAttackCrit = function()
					return v98;
				end;
				break;
			end
			if ((v97 == (592 - (562 + 29))) or ((905 + 156) >= (6310 - (374 + 1045)))) then
				v100 = nil;
				function v100()
					local v213 = 0 + 0;
					while true do
						if (((4235 - 2871) <= (5111 - (448 + 190))) and (v213 == (1 + 0))) then
							if ((v99 > (0 + 0)) or ((2343 + 1252) <= (11 - 8))) then
								v24.After(8 - 5, v100);
							end
							break;
						end
						if ((v213 == (1494 - (1307 + 187))) or ((18526 - 13854) == (9018 - 5166))) then
							if (((4779 - 3220) == (2242 - (232 + 451))) and not v13:AffectingCombat()) then
								local v247 = 0 + 0;
								while true do
									if ((v247 == (0 + 0)) or ((2316 - (510 + 54)) <= (1587 - 799))) then
										v98 = v13:CritChancePct();
										v10.Debug("Base Crit Set to: " .. v98);
										break;
									end
								end
							end
							if ((v99 == nil) or (v99 < (36 - (13 + 23))) or ((7615 - 3708) == (254 - 77))) then
								v99 = 0 - 0;
							else
								v99 = v99 - (1089 - (830 + 258));
							end
							v213 = 3 - 2;
						end
					end
				end
				v97 = 2 + 0;
			end
		end
	end
	do
		local v101 = 0 + 0;
		local v102;
		local v103;
		local v104;
		local v105;
		while true do
			if (((4911 - (860 + 581)) > (2047 - 1492)) and (v101 == (3 + 0))) then
				v102.Rupture:RegisterPMultiplier(v104, {v103.FinalityRuptureBuff,(2.3 - 1)});
				v102.Garrote:RegisterPMultiplier(v104, v105);
				break;
			end
			if ((v101 == (3 - 1)) or ((796 + 176) == (371 + 274))) then
				v105 = nil;
				function v105()
					if (((12013 - 8831) >= (908 + 1207)) and v102.ImprovedGarrote:IsAvailable() and (v13:BuffUp(v102.ImprovedGarroteAura, nil, true) or v13:BuffUp(v102.ImprovedGarroteBuff, nil, true) or v13:BuffUp(v102.SepsisBuff, nil, true))) then
						return 1.5 + 0;
					end
					return 1427 - (85 + 1341);
				end
				v101 = 4 - 1;
			end
			if (((10994 - 7101) < (4801 - (45 + 327))) and (v101 == (0 - 0))) then
				v102 = v16.Rogue.Assassination;
				v103 = v16.Rogue.Subtlety;
				v101 = 503 - (444 + 58);
			end
			if ((v101 == (1 + 0)) or ((494 + 2373) < (932 + 973))) then
				v104 = nil;
				function v104()
					local v214 = 0 - 0;
					while true do
						if ((v214 == (1732 - (64 + 1668))) or ((3769 - (1227 + 746)) >= (12451 - 8400))) then
							if (((3004 - 1385) <= (4250 - (415 + 79))) and v102.Nightstalker:IsAvailable() and v13:StealthUp(true, false, true)) then
								return 1 + 0 + ((491.05 - (142 + 349)) * v102.Nightstalker:TalentRank());
							end
							return 1 + 0;
						end
					end
				end
				v101 = 2 - 0;
			end
		end
	end
end;
return v0["Epix_Rogue_Rogue.lua"]();

