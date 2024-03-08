local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((4982 - (810 + 251)) >= (1565 + 689)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (not v6 or ((1328 + 145) > (2262 - (43 + 490)))) then
				return v1(v4, ...);
			end
			v5 = 734 - (711 + 22);
		end
		if (((10726 - 7953) == (3632 - (240 + 619))) and (v5 == (1 + 0))) then
			return v6(...);
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
	if (((1837 - 682) <= (111 + 1562)) and not v16.Rogue) then
		v16.Rogue = {};
	end
	v16.Rogue.Commons = {Sanguine=v16(228254 - (1344 + 400), nil, 406 - (255 + 150)),AncestralCall=v16(216405 + 58333, nil, 2 + 0),ArcanePulse=v16(1112425 - 852061, nil, 9 - 6),ArcaneTorrent=v16(26785 - (404 + 1335), nil, 410 - (183 + 223)),BagofTricks=v16(380161 - 67750, nil, 4 + 1),Berserking=v16(9464 + 16833, nil, 343 - (10 + 327)),BloodFury=v16(14327 + 6245, nil, 345 - (118 + 220)),Fireblood=v16(88386 + 176835, nil, 457 - (108 + 341)),LightsJudgment=v16(114820 + 140827, nil, 37 - 28),Shadowmeld=v16(60477 - (711 + 782), nil, 19 - 9),CloakofShadows=v16(31693 - (270 + 199), nil, 4 + 7),CrimsonVial=v16(187130 - (580 + 1239), nil, 35 - 23),Evasion=v16(5046 + 231, nil, 1 + 12),Feint=v16(857 + 1109, nil, 36 - 22),Blind=v16(1301 + 793, nil, 1182 - (645 + 522)),CheapShot=v16(3623 - (1010 + 780), nil, 16 + 0),Kick=v16(8413 - 6647, nil, 49 - 32),KidneyShot=v16(2244 - (1045 + 791), nil, 45 - 27),Sap=v16(10337 - 3567, nil, 524 - (351 + 154)),Shiv=v16(7512 - (1281 + 293), nil, 286 - (28 + 238)),SliceandDice=v16(704966 - 389470, nil, 1580 - (1381 + 178)),Shadowstep=v16(34286 + 2268, nil, 18 + 4),Sprint=v16(1273 + 1710, nil, 79 - 56),TricksoftheTrade=v16(30014 + 27920, nil, 494 - (381 + 89)),CripplingPoison=v16(3023 + 385, nil, 17 + 8),DeadlyPoison=v16(4835 - 2012, nil, 1182 - (1074 + 82)),InstantPoison=v16(691594 - 376010, nil, 1811 - (214 + 1570)),AmplifyingPoison=v16(383119 - (990 + 465), nil, 12 + 16),NumbingPoison=v16(2507 + 3254, nil, 29 + 0),WoundPoison=v16(34156 - 25477, nil, 1756 - (1668 + 58)),AtrophicPoison=v16(382263 - (512 + 114), nil, 80 - 49),AcrobaticStrikes=v16(407109 - 210185, nil, 111 - 79),Alacrity=v16(90037 + 103502, nil, 7 + 26),ColdBlood=v16(332300 + 49945, nil, 114 - 80),DeeperStratagem=v16(195525 - (109 + 1885)),EchoingReprimand=v16(387085 - (1269 + 200), nil, 68 - 32),EchoingReprimand2=v16(324373 - (98 + 717), nil, 863 - (802 + 24)),EchoingReprimand3=v16(557987 - 234428, nil, 47 - 9),EchoingReprimand4=v16(47784 + 275776, nil, 30 + 9),EchoingReprimand5=v16(58284 + 296554, nil, 9 + 31),FindWeakness=v16(253220 - 162197, nil, 136 - 95),FindWeaknessDebuff=v16(113102 + 203118, nil, 18 + 24),ImprovedAmbush=v16(314783 + 66837, nil, 32 + 11),MarkedforDeath=v16(64253 + 73366, nil, 1477 - (797 + 636)),Nightstalker=v16(68276 - 54214, nil, 1664 - (1427 + 192)),ResoundingClarity=v16(132229 + 249393, nil, 106 - 60),SealFate=v16(12755 + 1435, nil, 22 + 25),Sepsis=v16(385734 - (192 + 134), nil, 1324 - (316 + 960)),SepsisBuff=v16(209209 + 166730, nil, 38 + 11),ShadowDance=v16(171287 + 14026, nil, 191 - 141),ShadowDanceTalent=v16(395481 - (83 + 468), nil, 1857 - (1202 + 604)),ShadowDanceBuff=v16(865585 - 680163),Subterfuge=v16(180092 - 71884, nil, 146 - 93),SubterfugeBuff=v16(115517 - (45 + 280), nil, 53 + 1),ThistleTea=v16(333412 + 48211, nil, 117 + 203),Vigor=v16(8292 + 6691),Stealth=v16(314 + 1470, nil, 105 - 48),Stealth2=v16(117102 - (340 + 1571), nil, 23 + 35),Vanish=v16(3628 - (1733 + 39), nil, 162 - 103),VanishBuff=v16(12361 - (125 + 909), nil, 2008 - (1096 + 852)),VanishBuff2=v16(51673 + 63520, nil, 86 - 25),PoolEnergy=v16(969845 + 30065, nil, 574 - (409 + 103)),Gouge=v16(2012 - (46 + 190), nil, 231 - (51 + 44))};
	v16.Rogue.Assassination = v19(v16.Rogue.Commons, {Ambush=v16(2447 + 6229, nil, 1380 - (1114 + 203)),AmbushOverride=v16(430749 - (228 + 498)),AmplifyingPoisonDebuff=v16(83069 + 300345, nil, 36 + 28),AmplifyingPoisonDebuffDeathmark=v16(394991 - (174 + 489), nil, 169 - 104),CripplingPoisonDebuff=v16(5314 - (830 + 1075), nil, 590 - (303 + 221)),DeadlyPoisonDebuff=v16(4087 - (231 + 1038), nil, 56 + 11),DeadlyPoisonDebuffDeathmark=v16(395486 - (171 + 991), nil, 280 - 212),Envenom=v16(87658 - 55013, nil, 171 - 102),FanofKnives=v16(41397 + 10326, nil, 245 - 175),Garrote=v16(2027 - 1324, nil, 114 - 43),GarroteDeathmark=v16(1115428 - 754598, nil, 1320 - (111 + 1137)),Mutilate=v16(1487 - (91 + 67), nil, 217 - 144),PoisonedKnife=v16(46300 + 139265, nil, 597 - (423 + 100)),Rupture=v16(14 + 1929, nil, 207 - 132),RuptureDeathmark=v16(188071 + 172755, nil, 847 - (326 + 445)),WoundPoisonDebuff=v16(37879 - 29199, nil, 171 - 94),ArterialPrecision=v16(935517 - 534734, nil, 789 - (530 + 181)),AtrophicPoisonDebuff=v16(393269 - (614 + 267), nil, 111 - (19 + 13)),BlindsideBuff=v16(197189 - 76036, nil, 186 - 106),CausticSpatter=v16(1205416 - 783441),CausticSpatterDebuff=v16(109591 + 312385),CrimsonTempest=v16(213522 - 92111, nil, 167 - 86),CutToTheChase=v16(53479 - (1293 + 519), nil, 166 - 84),DashingScoundrel=v16(996853 - 615056, nil, 158 - 75),Deathmark=v16(1553195 - 1193001, nil, 197 - 113),Doomblade=v16(202150 + 179523, nil, 18 + 67),DragonTemperedBlades=v16(887120 - 505319, nil, 20 + 66),Elusiveness=v16(26248 + 52760),Exsanguinate=v16(125487 + 75319, nil, 1184 - (709 + 387)),ImprovedGarrote=v16(383490 - (673 + 1185), nil, 257 - 168),ImprovedGarroteBuff=v16(1260074 - 867673, nil, 148 - 58),ImprovedGarroteAura=v16(280669 + 111734, nil, 68 + 23),IndiscriminateCarnage=v16(515493 - 133691, nil, 23 + 69),IndiscriminateCarnageAura=v16(769160 - 383406),IndiscriminateCarnageBuff=v16(757232 - 371485),InternalBleeding=v16(156833 - (446 + 1434), nil, 1376 - (1040 + 243)),Kingsbane=v16(1150949 - 765322, nil, 1941 - (559 + 1288)),LightweightShiv=v16(396914 - (609 + 1322)),MasterAssassin=v16(256443 - (13 + 441), nil, 354 - 259),MasterAssassinBuff=v16(672482 - 415747, nil, 478 - 382),PreyontheWeak=v16(4897 + 126614, nil, 352 - 255),PreyontheWeakDebuff=v16(90893 + 165016, nil, 43 + 55),SerratedBoneSpike=v16(1143756 - 758332, nil, 55 + 44),SerratedBoneSpikeDebuff=v16(724713 - 330677, nil, 67 + 33),ShivDebuff=v16(177702 + 141802, nil, 73 + 28),VenomRush=v16(127755 + 24397, nil, 100 + 2),ScentOfBlood=v16(382232 - (153 + 280), nil, 1143 - 747),ScentOfBloodBuff=v16(353805 + 40275),ShroudedSuffocation=v16(152203 + 233275)});
	v16.Rogue.Outlaw = v19(v16.Rogue.Commons, {AdrenalineRush=v16(7196 + 6554, nil, 94 + 9),Ambush=v16(6287 + 2389, nil, 157 - 53),AmbushOverride=v16(265780 + 164243),BetweentheEyes=v16(316008 - (89 + 578), nil, 76 + 29),BladeFlurry=v16(28849 - 14972, nil, 1155 - (572 + 477)),Dispatch=v16(283 + 1815, nil, 65 + 42),Elusiveness=v16(9431 + 69577),Opportunity=v16(195713 - (84 + 2)),PistolShot=v16(306150 - 120387, nil, 80 + 30),RolltheBones=v16(316350 - (497 + 345), nil, 3 + 108),SinisterStrike=v16(32679 + 160636, nil, 1445 - (605 + 728)),Audacity=v16(272439 + 109406, nil, 251 - 138),AudacityBuff=v16(17703 + 368567, nil, 421 - 307),BladeRush=v16(245096 + 26781, nil, 318 - 203),CountTheOdds=v16(288417 + 93565, nil, 605 - (457 + 32)),Dreadblades=v16(145587 + 197555, nil, 1519 - (832 + 570)),FanTheHammer=v16(359733 + 22113, nil, 31 + 87),GhostlyStrike=v16(696923 - 499986, nil, 58 + 61),GreenskinsWickers=v16(387619 - (588 + 208), nil, 323 - 203),GreenskinsWickersBuff=v16(395931 - (884 + 916), nil, 253 - 132),HiddenOpportunity=v16(222233 + 161048, nil, 775 - (232 + 421)),ImprovedAdrenalineRush=v16(397311 - (1569 + 320), nil, 31 + 92),ImprovedBetweenTheEyes=v16(44739 + 190745, nil, 417 - 293),KeepItRolling=v16(382594 - (316 + 289), nil, 327 - 202),KillingSpree=v16(2388 + 49302, nil, 1579 - (666 + 787)),LoadedDice=v16(256595 - (360 + 65), nil, 119 + 8),LoadedDiceBuff=v16(256425 - (79 + 175), nil, 201 - 73),PreyontheWeak=v16(102624 + 28887, nil, 395 - 266),PreyontheWeakDebuff=v16(492844 - 236935, nil, 1029 - (503 + 396)),QuickDraw=v16(197119 - (92 + 89), nil, 253 - 122),SummarilyDispatched=v16(195900 + 186090, nil, 79 + 53),SwiftSlasher=v16(1495919 - 1113931, nil, 19 + 114),TakeEmBySurpriseBuff=v16(879917 - 494010, nil, 117 + 17),Weaponmaster=v16(95877 + 104856, nil, 410 - 275),UnderhandedUpperhand=v16(52925 + 371119),DeftManeuvers=v16(582369 - 200491),Crackshot=v16(424947 - (485 + 759)),Broadside=v16(447403 - 254047, nil, 1326 - (442 + 747)),BuriedTreasure=v16(200735 - (832 + 303), nil, 1084 - (88 + 858)),GrandMelee=v16(58932 + 134426, nil, 116 + 23),RuthlessPrecision=v16(7964 + 185393, nil, 929 - (766 + 23)),SkullandCrossbones=v16(985387 - 785784, nil, 192 - 51),TrueBearing=v16(509444 - 316085, nil, 481 - 339),ViciousFollowup=v16(395952 - (1036 + 37), nil, 102 + 41)});
	v16.Rogue.Subtlety = v19(v16.Rogue.Commons, {Backstab=v16(102 - 49, nil, 114 + 30),BlackPowder=v16(320655 - (641 + 839), nil, 1058 - (910 + 3)),Elusiveness=v16(201414 - 122406),Eviscerate=v16(198503 - (1466 + 218), nil, 68 + 79),Rupture=v16(3091 - (556 + 592), nil, 53 + 95),ShadowBlades=v16(122279 - (329 + 479), nil, 1003 - (174 + 680)),Shadowstrike=v16(637197 - 451759, nil, 310 - 160),ShurikenStorm=v16(141249 + 56586, nil, 890 - (396 + 343)),ShurikenToss=v16(10088 + 103926, nil, 1629 - (29 + 1448)),SymbolsofDeath=v16(213672 - (135 + 1254), nil, 576 - 423),DanseMacabre=v16(1786071 - 1403543, nil, 103 + 51),DanseMacabreBuff=v16(395496 - (389 + 1138), nil, 729 - (102 + 472)),DeeperDaggers=v16(360978 + 21539, nil, 87 + 69),DeeperDaggersBuff=v16(357498 + 25907, nil, 1702 - (320 + 1225)),DarkBrew=v16(680930 - 298426, nil, 97 + 61),DarkShadow=v16(247151 - (157 + 1307), nil, 2018 - (821 + 1038)),EnvelopingShadows=v16(594066 - 355962, nil, 18 + 142),Finality=v16(679466 - 296941, nil, 60 + 101),FinalityBlackPowderBuff=v16(956599 - 570651, nil, 1188 - (834 + 192)),FinalityEviscerateBuff=v16(24538 + 361411, nil, 42 + 121),FinalityRuptureBuff=v16(8286 + 377665, nil, 253 - 89),Flagellation=v16(384935 - (300 + 4), nil, 45 + 120),FlagellationPersistBuff=v16(1033380 - 638622, nil, 528 - (112 + 250)),Gloomblade=v16(80031 + 120727, nil, 418 - 251),GoremawsBite=v16(244386 + 182205, nil, 98 + 91),ImprovedShadowDance=v16(294647 + 99325, nil, 84 + 84),ImprovedShurikenStorm=v16(237685 + 82266, nil, 1583 - (1001 + 413)),InvigoratingShadowdust=v16(853019 - 470496),LingeringShadow=v16(383406 - (244 + 638), nil, 863 - (627 + 66)),LingeringShadowBuff=v16(1150020 - 764060, nil, 773 - (512 + 90)),MasterofShadows=v16(198882 - (1665 + 241), nil, 889 - (373 + 344)),PerforatedVeins=v16(172524 + 209994, nil, 46 + 127),PerforatedVeinsBuff=v16(1039933 - 645679, nil, 294 - 120),PreyontheWeak=v16(132610 - (35 + 1064), nil, 128 + 47),PreyontheWeakDebuff=v16(547524 - 291615, nil, 1 + 175),Premeditation=v16(344396 - (298 + 938), nil, 1436 - (233 + 1026)),PremeditationBuff=v16(344839 - (636 + 1030), nil, 92 + 86),SecretStratagem=v16(385159 + 9161, nil, 54 + 125),SecretTechnique=v16(18967 + 261752, nil, 401 - (55 + 166)),Shadowcraft=v16(82672 + 343922),ShadowFocus=v16(10882 + 97327, nil, 691 - 510),ShurikenTornado=v16(278222 - (36 + 261), nil, 317 - 135),SilentStorm=v16(387090 - (34 + 1334), nil, 71 + 112),SilentStormBuff=v16(299701 + 86021, nil, 1467 - (1035 + 248)),TheFirstDance=v16(382526 - (20 + 1), nil, 97 + 88),TheRotten=v16(382334 - (134 + 185), nil, 1319 - (549 + 584)),TheRottenBuff=v16(394888 - (314 + 371), nil, 641 - 454),Weaponmaster=v16(194505 - (478 + 490), nil, 100 + 88)});
	if (not v18.Rogue or ((3496 - (786 + 386)) <= (1872 - 1294))) then
		v18.Rogue = {};
	end
	v18.Rogue.Commons = {AlgetharPuzzleBox=v18(195080 - (1055 + 324), {(12 + 1),(55 - 41)}),ManicGrieftorch=v18(659441 - 465133, {(32 - 19),(53 - 39)}),WindscarWhetstone=v18(473884 - 336398, {(32 - 19),(38 - 24)}),Healthstone=v18(13226 - 7714),RefreshingHealingPotion=v18(63430 + 127950),DreamwalkersHealingPotion=v18(866252 - 659229)};
	v18.Rogue.Assassination = v19(v18.Rogue.Commons, {AlgetharPuzzleBox=v18(310219 - 116518, {(1281 - (1249 + 19)),(54 - 40)}),AshesoftheEmbersoul=v18(208253 - (686 + 400), {(242 - (73 + 156)),(825 - (721 + 90))}),WitherbarksBranch=v18(1237 + 108762, {(483 - (224 + 246)),(25 - 11)})});
	v18.Rogue.Outlaw = v19(v18.Rogue.Commons, {ManicGrieftorch=v18(35246 + 159062, {(10 + 3),(46 - 32)}),WindscarWhetstone=v18(137999 - (203 + 310), {(1 + 12),(25 - 11)}),BeaconToTheBeyond=v18(297113 - 93150, {(51 - 38),(847 - (171 + 662))}),DragonfireBombDispenser=v18(202703 - (4 + 89), {(5 + 8),(6 + 8)})});
	v18.Rogue.Subtlety = v19(v18.Rogue.Commons, {ManicGrieftorch=v18(195794 - (35 + 1451), {(2006 - (941 + 1052)),(1528 - (822 + 692))}),StormEatersBoon=v18(277398 - 83096, {(310 - (45 + 252)),(5 + 9)}),BeaconToTheBeyond=v18(496396 - 292433, {(17 - 4),(9 + 5)}),AshesoftheEmbersoul=v18(308648 - 101481, {(1976 - (556 + 1407)),(479 - (170 + 295))}),WitherbarksBranch=v18(57958 + 52041, {(31 - 18),(9 + 5)}),BandolierOfTwistedBlades=v18(117312 + 89853, {(4 + 9),(53 - 39)}),Mirror=v18(547023 - 339442, {(64 - 51),(9 + 5)})});
	if (((393 + 3374) == (8575 - 4808)) and not v21.Rogue) then
		v21.Rogue = {};
	end
	v21.Rogue.Commons = {Healthstone=v21(972 - (783 + 168)),BlindMouseover=v21(30 - 21),CheapShotMouseover=v21(10 + 0),KickMouseover=v21(322 - (309 + 2)),KidneyShotMouseover=v21(36 - 24),TricksoftheTradeFocus=v21(1225 - (1090 + 122)),WindscarWhetstone=v21(9 + 17),RefreshingHealingPotion=v21(97 - 68)};
	v21.Rogue.Outlaw = v19(v21.Rogue.Commons, {Dispatch=v21(10 + 4),PistolShotMouseover=v21(1133 - (628 + 490)),SinisterStrikeMouseover=v21(5 + 22)});
	v21.Rogue.Assassination = v19(v21.Rogue.Commons, {GarroteMouseOver=v21(69 - 41)});
	v21.Rogue.Subtlety = v19(v21.Rogue.Commons, {SecretTechnique=v21(73 - 57),ShadowDance=v21(791 - (431 + 343)),ShadowDanceSymbol=v21(52 - 26),VanishShadowstrike=v21(51 - 33),ShurikenStormSD=v21(16 + 3),ShurikenStormVanish=v21(3 + 17),GloombladeSD=v21(1717 - (556 + 1139)),GloombladeVanish=v21(38 - (6 + 9)),BackstabMouseover=v21(5 + 19),RuptureMouseover=v21(13 + 12),ColdBloodTechnique=v21(199 - (28 + 141))});
	v30.StealthSpell = function()
		return (v16.Rogue.Commons.Subterfuge:IsAvailable() and v16.Rogue.Commons.Stealth2) or v16.Rogue.Commons.Stealth;
	end;
	v30.VanishBuffSpell = function()
		return (v16.Rogue.Commons.Subterfuge:IsAvailable() and v16.Rogue.Commons.VanishBuff2) or v16.Rogue.Commons.VanishBuff;
	end;
	v30.Stealth = function(v50, v51)
		local v52 = 0 + 0;
		while true do
			if (((5046 - 957) == (2897 + 1192)) and (v52 == (1317 - (486 + 831)))) then
				if (((11600 - 7142) >= (5893 - 4219)) and EpicSettings.Settings['StealthOOC'] and (v16.Rogue.Commons.Stealth:IsCastable() or v16.Rogue.Commons.Stealth2:IsCastable()) and v13:StealthDown()) then
					if (((184 + 788) <= (4483 - 3065)) and v10.Press(v50, nil)) then
						return "Cast Stealth (OOC)";
					end
				end
				return false;
			end
		end
	end;
	do
		local v53 = v16.Rogue.Commons;
		local v54 = v53.CrimsonVial;
		v30.CrimsonVial = function()
			local v114 = 1263 - (668 + 595);
			local v115;
			while true do
				if ((v114 == (0 + 0)) or ((996 + 3942) < (12986 - 8224))) then
					v115 = EpicSettings.Settings['CrimsonVialHP'] or (290 - (23 + 267));
					if ((v54:IsCastable() and v54:IsReady() and (v13:HealthPercentage() <= v115)) or ((4448 - (1129 + 815)) > (4651 - (371 + 16)))) then
						if (((3903 - (1326 + 424)) == (4077 - 1924)) and v10.Cast(v54, nil)) then
							return "Cast Crimson Vial (Defensives)";
						end
					end
					v114 = 3 - 2;
				end
				if ((v114 == (119 - (88 + 30))) or ((1278 - (720 + 51)) >= (5763 - 3172))) then
					return false;
				end
			end
		end;
	end
	do
		local v56 = v16.Rogue.Commons;
		local v57 = v56.Feint;
		v30.Feint = function()
			local v116 = 1776 - (421 + 1355);
			local v117;
			while true do
				if (((7392 - 2911) == (2202 + 2279)) and (v116 == (1083 - (286 + 797)))) then
					v117 = EpicSettings.Settings['FeintHP'] or (0 - 0);
					if ((v57:IsCastable() and v13:BuffDown(v57) and (v13:HealthPercentage() <= v117)) or ((3855 - 1527) < (1132 - (397 + 42)))) then
						if (((1352 + 2976) == (5128 - (24 + 776))) and v10.Cast(v57, nil)) then
							return "Cast Feint (Defensives)";
						end
					end
					break;
				end
			end
		end;
	end
	do
		local v59 = 0 - 0;
		local v60;
		local v61;
		local v62;
		while true do
			if (((2373 - (222 + 563)) >= (2934 - 1602)) and (v59 == (2 + 0))) then
				v30.Poisons = function()
					local v154 = 190 - (23 + 167);
					while true do
						if (((1799 - (690 + 1108)) == v154) or ((1506 + 2668) > (3504 + 744))) then
							if (v13:BuffDown(v16.Rogue.Commons.CripplingPoison) or ((5434 - (40 + 808)) <= (14 + 68))) then
								if (((14771 - 10908) == (3693 + 170)) and v16.Rogue.Commons.AtrophicPoison:IsAvailable()) then
									local v240 = v62(v16.Rogue.Commons.AtrophicPoison);
									if (v240 or ((150 + 132) <= (24 + 18))) then
										return v240;
									end
								elseif (((5180 - (47 + 524)) >= (498 + 268)) and v16.Rogue.Commons.NumbingPoison:IsAvailable()) then
									local v246 = v62(v16.Rogue.Commons.NumbingPoison);
									if (v246 or ((3148 - 1996) == (3720 - 1232))) then
										return v246;
									end
								else
									local v247 = v62(v16.Rogue.Commons.CripplingPoison);
									if (((7804 - 4382) > (5076 - (1165 + 561))) and v247) then
										return v247;
									end
								end
							else
								local v230 = 0 + 0;
								local v231;
								while true do
									if (((2716 - 1839) > (144 + 232)) and ((479 - (341 + 138)) == v230)) then
										v231 = v62(v16.Rogue.Commons.CripplingPoison);
										if (v231 or ((842 + 2276) <= (3819 - 1968))) then
											return v231;
										end
										break;
									end
								end
							end
							break;
						end
						if ((v154 == (326 - (89 + 237))) or ((530 - 365) >= (7351 - 3859))) then
							v61 = v13:BuffUp(v16.Rogue.Commons.WoundPoison);
							if (((4830 - (581 + 300)) < (6076 - (855 + 365))) and v16.Rogue.Assassination.DragonTemperedBlades:IsAvailable()) then
								local v232 = 0 - 0;
								local v233;
								while true do
									if ((v232 == (0 + 0)) or ((5511 - (1030 + 205)) < (2832 + 184))) then
										v233 = v62((v61 and v16.Rogue.Commons.WoundPoison) or v16.Rogue.Commons.DeadlyPoison);
										if (((4363 + 327) > (4411 - (156 + 130))) and v233) then
											return v233;
										end
										v232 = 2 - 1;
									end
									if ((v232 == (1 - 0)) or ((102 - 52) >= (237 + 659))) then
										if (v16.Rogue.Commons.AmplifyingPoison:IsAvailable() or ((1000 + 714) >= (3027 - (10 + 59)))) then
											v233 = v62(v16.Rogue.Commons.AmplifyingPoison);
											if (v233 or ((422 + 1069) < (3171 - 2527))) then
												return v233;
											end
										else
											local v250 = 1163 - (671 + 492);
											while true do
												if (((561 + 143) < (2202 - (369 + 846))) and (v250 == (0 + 0))) then
													v233 = v62(v16.Rogue.Commons.InstantPoison);
													if (((3173 + 545) > (3851 - (1036 + 909))) and v233) then
														return v233;
													end
													break;
												end
											end
										end
										break;
									end
								end
							elseif (v61 or ((762 + 196) > (6102 - 2467))) then
								local v241 = 203 - (11 + 192);
								local v242;
								while true do
									if (((1770 + 1731) <= (4667 - (135 + 40))) and (v241 == (0 - 0))) then
										v242 = v62(v16.Rogue.Commons.WoundPoison);
										if (v242 or ((2075 + 1367) < (5613 - 3065))) then
											return v242;
										end
										break;
									end
								end
							elseif (((4309 - 1434) >= (1640 - (50 + 126))) and v16.Rogue.Commons.AmplifyingPoison:IsAvailable() and v13:BuffDown(v16.Rogue.Commons.DeadlyPoison)) then
								local v248 = 0 - 0;
								local v249;
								while true do
									if ((v248 == (0 + 0)) or ((6210 - (1233 + 180)) >= (5862 - (522 + 447)))) then
										v249 = v62(v16.Rogue.Commons.AmplifyingPoison);
										if (v249 or ((1972 - (107 + 1314)) > (960 + 1108))) then
											return v249;
										end
										break;
									end
								end
							elseif (((6441 - 4327) > (401 + 543)) and v16.Rogue.Commons.DeadlyPoison:IsAvailable()) then
								local v251 = v62(v16.Rogue.Commons.DeadlyPoison);
								if (v251 or ((4491 - 2229) >= (12249 - 9153))) then
									return v251;
								end
							else
								local v252 = v62(v16.Rogue.Commons.InstantPoison);
								if (v252 or ((4165 - (716 + 1194)) >= (61 + 3476))) then
									return v252;
								end
							end
							v154 = 1 + 0;
						end
					end
				end;
				break;
			end
			if ((v59 == (503 - (74 + 429))) or ((7401 - 3564) < (648 + 658))) then
				v60 = 0 - 0;
				v61 = false;
				v59 = 1 + 0;
			end
			if (((9094 - 6144) == (7294 - 4344)) and (v59 == (434 - (279 + 154)))) then
				v62 = nil;
				function v62(v155)
					if ((not v13:AffectingCombat() and v13:BuffRefreshable(v155)) or ((5501 - (454 + 324)) < (2595 + 703))) then
						if (((1153 - (12 + 5)) >= (84 + 70)) and v10.Press(v155, nil, true)) then
							return "poison";
						end
					end
				end
				v59 = 4 - 2;
			end
		end
	end
	v30.MfDSniping = function(v63)
		if (v63:IsCastable() or ((101 + 170) > (5841 - (277 + 816)))) then
			local v130, v131 = nil, 256 - 196;
			local v132 = (v15:IsInRange(1213 - (1058 + 125)) and v15:TimeToDie()) or (2084 + 9027);
			for v134, v135 in v23(v13:GetEnemiesInRange(1005 - (815 + 160))) do
				local v136 = 0 - 0;
				local v137;
				while true do
					if (((11252 - 6512) >= (752 + 2400)) and ((0 - 0) == v136)) then
						v137 = v135:TimeToDie();
						if ((not v135:IsMfDBlacklisted() and (v137 < (v13:ComboPointsDeficit() * (1899.5 - (41 + 1857)))) and (v137 < v131)) or ((4471 - (1222 + 671)) >= (8761 - 5371))) then
							if (((58 - 17) <= (2843 - (229 + 953))) and ((v132 - v137) > (1775 - (1111 + 663)))) then
								v130, v131 = v135, v137;
							else
								v130, v131 = v15, v132;
							end
						end
						break;
					end
				end
			end
			if (((2180 - (874 + 705)) < (499 + 3061)) and v130 and (v130:GUID() ~= v14:GUID())) then
				v10.Press(v130, v63);
			end
		end
	end;
	v30.CanDoTUnit = function(v64, v65)
		return v20.CanDoTUnit(v64, v65);
	end;
	do
		local v66 = 0 + 0;
		local v67;
		local v68;
		local v69;
		local v70;
		while true do
			if (((488 - 253) < (20 + 667)) and (v66 == (680 - (642 + 37)))) then
				v69 = nil;
				function v69()
					local v156 = 0 + 0;
					while true do
						if (((728 + 3821) > (2894 - 1741)) and (v156 == (454 - (233 + 221)))) then
							if ((v67.Nightstalker:IsAvailable() and v13:StealthUp(true, false, true)) or ((10807 - 6133) < (4113 + 559))) then
								return (1542 - (718 + 823)) + ((0.05 + 0) * v67.Nightstalker:TalentRank());
							end
							return 806 - (266 + 539);
						end
					end
				end
				v66 = 5 - 3;
			end
			if (((4893 - (636 + 589)) < (10826 - 6265)) and (v66 == (5 - 2))) then
				v67.Rupture:RegisterPMultiplier(v69, {v68.FinalityRuptureBuff,(1016.3 - (657 + 358))});
				v67.Garrote:RegisterPMultiplier(v69, v70);
				v66 = 10 - 6;
			end
			if (((8 - 4) == v66) or ((1642 - (1151 + 36)) == (3482 + 123))) then
				v67.CrimsonTempest:RegisterPMultiplier(v69);
				break;
			end
			if ((v66 == (1 + 1)) or ((7952 - 5289) == (5144 - (1552 + 280)))) then
				v70 = nil;
				function v70()
					local v157 = 834 - (64 + 770);
					while true do
						if (((2904 + 1373) <= (10158 - 5683)) and ((0 + 0) == v157)) then
							if ((v67.ImprovedGarrote:IsAvailable() and (v13:BuffUp(v67.ImprovedGarroteAura, nil, true) or v13:BuffUp(v67.ImprovedGarroteBuff, nil, true) or v13:BuffUp(v67.SepsisBuff, nil, true))) or ((2113 - (157 + 1086)) == (2379 - 1190))) then
								return 4.5 - 3;
							end
							return 1 - 0;
						end
					end
				end
				v66 = 3 - 0;
			end
			if (((2372 - (599 + 220)) <= (6238 - 3105)) and ((1931 - (1813 + 118)) == v66)) then
				v67 = v16.Rogue.Assassination;
				v68 = v16.Rogue.Subtlety;
				v66 = 1 + 0;
			end
		end
	end
	do
		local v71 = v16(194748 - (841 + 376));
		local v72 = v16(552542 - 158221);
		local v73 = v16(91602 + 302718);
		v30.CPMaxSpend = function()
			return (13 - 8) + ((v71:IsAvailable() and (860 - (464 + 395))) or (0 - 0)) + ((v72:IsAvailable() and (1 + 0)) or (837 - (467 + 370))) + ((v73:IsAvailable() and (1 - 0)) or (0 + 0));
		end;
	end
	v30.CPSpend = function()
		return v22(v13:ComboPoints(), v30.CPMaxSpend());
	end;
	do
		local v75 = 0 - 0;
		while true do
			if ((v75 == (0 + 0)) or ((5204 - 2967) >= (4031 - (150 + 370)))) then
				v30.AnimachargedCP = function()
					local v158 = 1282 - (74 + 1208);
					while true do
						if (((0 - 0) == v158) or ((6279 - 4955) > (2149 + 871))) then
							if (v13:BuffUp(v16.Rogue.Commons.EchoingReprimand2) or ((3382 - (14 + 376)) == (3262 - 1381))) then
								return 2 + 0;
							elseif (((2729 + 377) > (1456 + 70)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand3)) then
								return 8 - 5;
							elseif (((2275 + 748) < (3948 - (23 + 55))) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand4)) then
								return 9 - 5;
							elseif (((96 + 47) > (67 + 7)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand5)) then
								return 7 - 2;
							end
							return -(1 + 0);
						end
					end
				end;
				v30.EffectiveComboPoints = function(v159)
					local v160 = 901 - (652 + 249);
					while true do
						if (((48 - 30) < (3980 - (708 + 1160))) and (v160 == (0 - 0))) then
							if (((1999 - 902) <= (1655 - (10 + 17))) and (((v159 == (1 + 1)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand2)) or ((v159 == (1735 - (1400 + 332))) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand3)) or ((v159 == (7 - 3)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand4)) or ((v159 == (1913 - (242 + 1666))) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand5)))) then
								return 3 + 4;
							end
							return v159;
						end
					end
				end;
				break;
			end
		end
	end
	do
		local v76 = v16.Rogue.Assassination.DeadlyPoisonDebuff;
		local v77 = v16.Rogue.Assassination.WoundPoisonDebuff;
		local v78 = v16.Rogue.Assassination.AmplifyingPoisonDebuff;
		local v79 = v16.Rogue.Assassination.CripplingPoisonDebuff;
		local v80 = v16.Rogue.Assassination.AtrophicPoisonDebuff;
		v30.Poisoned = function(v118)
			return ((v118:DebuffUp(v76) or v118:DebuffUp(v78) or v118:DebuffUp(v79) or v118:DebuffUp(v77) or v118:DebuffUp(v80)) and true) or false;
		end;
	end
	do
		local v82 = 0 + 0;
		local v83;
		local v84;
		local v85;
		local v86;
		local v87;
		local v88;
		while true do
			if (((3946 + 684) == (5570 - (850 + 90))) and (v82 == (3 - 1))) then
				v87 = v16.Rogue.Assassination.InternalBleeding;
				v88 = 1390 - (360 + 1030);
				v82 = 3 + 0;
			end
			if (((9991 - 6451) > (3690 - 1007)) and (v82 == (1662 - (909 + 752)))) then
				v85 = v16.Rogue.Assassination.Rupture;
				v86 = v16.Rogue.Assassination.RuptureDeathmark;
				v82 = 1225 - (109 + 1114);
			end
			if (((8776 - 3982) >= (1275 + 2000)) and (v82 == (242 - (6 + 236)))) then
				v83 = v16.Rogue.Assassination.Garrote;
				v84 = v16.Rogue.Assassination.GarroteDeathmark;
				v82 = 1 + 0;
			end
			if (((1195 + 289) == (3499 - 2015)) and (v82 == (4 - 1))) then
				v30.PoisonedBleeds = function()
					local v161 = 1133 - (1076 + 57);
					while true do
						if (((236 + 1196) < (4244 - (579 + 110))) and (v161 == (1 + 0))) then
							return v88;
						end
						if ((v161 == (0 + 0)) or ((566 + 499) > (3985 - (174 + 233)))) then
							v88 = 0 - 0;
							for v222, v223 in v23(v13:GetEnemiesInRange(87 - 37)) do
								if (v30.Poisoned(v223) or ((2133 + 2662) < (2581 - (663 + 511)))) then
									if (((1654 + 199) < (1045 + 3768)) and v223:DebuffUp(v83)) then
										local v243 = 0 - 0;
										while true do
											if ((v243 == (0 + 0)) or ((6641 - 3820) < (5884 - 3453))) then
												v88 = v88 + 1 + 0;
												if (v223:DebuffUp(v84) or ((5593 - 2719) < (1555 + 626))) then
													v88 = v88 + 1 + 0;
												end
												break;
											end
										end
									end
									if (v223:DebuffUp(v85) or ((3411 - (478 + 244)) <= (860 - (440 + 77)))) then
										local v244 = 0 + 0;
										while true do
											if ((v244 == (0 - 0)) or ((3425 - (655 + 901)) == (373 + 1636))) then
												v88 = v88 + 1 + 0;
												if (v223:DebuffUp(v86) or ((2395 + 1151) < (9354 - 7032))) then
													v88 = v88 + (1446 - (695 + 750));
												end
												break;
											end
										end
									end
									if (v223:DebuffUp(v87) or ((7109 - 5027) == (7365 - 2592))) then
										v88 = v88 + (3 - 2);
									end
								end
							end
							v161 = 352 - (285 + 66);
						end
					end
				end;
				break;
			end
		end
	end
	do
		local v89 = 0 - 0;
		local v90;
		while true do
			if (((4554 - (682 + 628)) > (171 + 884)) and (v89 == (299 - (176 + 123)))) then
				v90 = v29();
				v30.RtBRemains = function(v162)
					local v163 = 0 + 0;
					local v164;
					while true do
						if ((v163 == (0 + 0)) or ((3582 - (239 + 30)) <= (484 + 1294))) then
							v164 = (v90 - v29()) - v10.RecoveryOffset(v162);
							return ((v164 >= (0 + 0)) and v164) or (0 - 0);
						end
					end
				end;
				v89 = 2 - 1;
			end
			if ((v89 == (316 - (306 + 9))) or ((4958 - 3537) >= (366 + 1738))) then
				v10:RegisterForSelfCombatEvent(function(v165, v165, v165, v165, v165, v165, v165, v165, v165, v165, v165, v166)
					if (((1112 + 700) <= (1564 + 1685)) and (v166 == (902231 - 586723))) then
						v90 = v29() + (1405 - (1140 + 235));
					end
				end, "SPELL_AURA_APPLIED");
				v10:RegisterForSelfCombatEvent(function(v167, v167, v167, v167, v167, v167, v167, v167, v167, v167, v167, v168)
					if (((1033 + 590) <= (1795 + 162)) and (v168 == (80972 + 234536))) then
						v90 = v29() + v22(92 - (33 + 19), 11 + 19 + v30.RtBRemains(true));
					end
				end, "SPELL_AURA_REFRESH");
				v89 = 5 - 3;
			end
			if (((1944 + 2468) == (8651 - 4239)) and (v89 == (2 + 0))) then
				v10:RegisterForSelfCombatEvent(function(v169, v169, v169, v169, v169, v169, v169, v169, v169, v169, v169, v170)
					if (((2439 - (586 + 103)) >= (77 + 765)) and (v170 == (971344 - 655836))) then
						v90 = v29();
					end
				end, "SPELL_AURA_REMOVED");
				break;
			end
		end
	end
	do
		local v91 = 1488 - (1309 + 179);
		local v92;
		while true do
			if (((7892 - 3520) > (806 + 1044)) and ((7 - 4) == v91)) then
				v10:RegisterForSelfCombatEvent(function(v171, v171, v171, v171, v171, v171, v171, v172, v171, v171, v171, v173)
					if (((176 + 56) < (1744 - 923)) and (v173 == (241927 - 120516))) then
						if (((1127 - (295 + 314)) < (2215 - 1313)) and (v92.CrimsonTempest[v172] ~= nil)) then
							v92.CrimsonTempest[v172] = nil;
						end
					elseif (((4956 - (1300 + 662)) > (2694 - 1836)) and (v173 == (2458 - (1178 + 577)))) then
						if ((v92.Garrote[v172] ~= nil) or ((1951 + 1804) <= (2704 - 1789))) then
							v92.Garrote[v172] = nil;
						end
					elseif (((5351 - (851 + 554)) > (3310 + 433)) and (v173 == (5388 - 3445))) then
						if ((v92.Rupture[v172] ~= nil) or ((2899 - 1564) >= (3608 - (115 + 187)))) then
							v92.Rupture[v172] = nil;
						end
					end
				end, "SPELL_AURA_REMOVED");
				v10:RegisterForCombatEvent(function(v174, v174, v174, v174, v174, v174, v174, v175)
					if (((3710 + 1134) > (2133 + 120)) and (v92.CrimsonTempest[v175] ~= nil)) then
						v92.CrimsonTempest[v175] = nil;
					end
					if (((1781 - 1329) == (1613 - (160 + 1001))) and (v92.Garrote[v175] ~= nil)) then
						v92.Garrote[v175] = nil;
					end
					if ((v92.Rupture[v175] ~= nil) or ((3987 + 570) < (1440 + 647))) then
						v92.Rupture[v175] = nil;
					end
				end, "UNIT_DIED", "UNIT_DESTROYED");
				break;
			end
			if (((7930 - 4056) == (4232 - (237 + 121))) and (v91 == (898 - (525 + 372)))) then
				v30.WillLoseExsanguinate = function(v176, v177)
					local v178 = 0 - 0;
					while true do
						if ((v178 == (0 - 0)) or ((2080 - (96 + 46)) > (5712 - (643 + 134)))) then
							if (v30.Exsanguinated(v176, v177) or ((1537 + 2718) < (8207 - 4784))) then
								return true;
							end
							return false;
						end
					end
				end;
				v30.ExsanguinatedRate = function(v179, v180)
					local v181 = 0 - 0;
					while true do
						if (((1395 + 59) <= (4888 - 2397)) and (v181 == (0 - 0))) then
							if (v30.Exsanguinated(v179, v180) or ((4876 - (316 + 403)) <= (1864 + 939))) then
								return 5 - 3;
							end
							return 1 + 0;
						end
					end
				end;
				v91 = 4 - 2;
			end
			if (((3440 + 1413) >= (962 + 2020)) and (v91 == (6 - 4))) then
				v10:RegisterForSelfCombatEvent(function(v182, v182, v182, v182, v182, v182, v182, v183, v182, v182, v182, v184)
					if (((19743 - 15609) > (6973 - 3616)) and (v184 == (11496 + 189310))) then
						for v219, v220 in v23(v92) do
							for v225, v226 in v23(v220) do
								if ((v225 == v183) or ((6726 - 3309) < (124 + 2410))) then
									v220[v225] = true;
								end
							end
						end
					end
				end, "SPELL_CAST_SUCCESS");
				v10:RegisterForSelfCombatEvent(function(v185, v185, v185, v185, v185, v185, v185, v186, v185, v185, v185, v187)
					if ((v187 == (357200 - 235789)) or ((2739 - (12 + 5)) <= (636 - 472))) then
						v92.CrimsonTempest[v186] = false;
					elseif ((v187 == (1499 - 796)) or ((5118 - 2710) < (5229 - 3120))) then
						v92.Garrote[v186] = false;
					elseif ((v187 == (395 + 1548)) or ((2006 - (1656 + 317)) == (1297 + 158))) then
						v92.Rupture[v186] = false;
					end
				end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
				v91 = 3 + 0;
			end
			if ((v91 == (0 - 0)) or ((2180 - 1737) >= (4369 - (5 + 349)))) then
				v92 = {CrimsonTempest={},Garrote={},Rupture={}};
				v30.Exsanguinated = function(v188, v189)
					local v190 = 0 - 0;
					local v191;
					local v192;
					while true do
						if (((4653 - (266 + 1005)) > (110 + 56)) and ((0 - 0) == v190)) then
							v191 = v188:GUID();
							if (not v191 or ((368 - 88) == (4755 - (561 + 1135)))) then
								return false;
							end
							v190 = 1 - 0;
						end
						if (((6182 - 4301) > (2359 - (507 + 559))) and ((2 - 1) == v190)) then
							v192 = v189:ID();
							if (((7289 - 4932) == (2745 - (212 + 176))) and (v192 == (122316 - (250 + 655)))) then
								return v92.CrimsonTempest[v191] or false;
							elseif (((335 - 212) == (214 - 91)) and (v192 == (1099 - 396))) then
								return v92.Garrote[v191] or false;
							elseif ((v192 == (3899 - (1869 + 87))) or ((3662 - 2606) >= (5293 - (484 + 1417)))) then
								return v92.Rupture[v191] or false;
							end
							v190 = 4 - 2;
						end
						if (((2 - 0) == v190) or ((1854 - (48 + 725)) < (1756 - 681))) then
							return false;
						end
					end
				end;
				v91 = 2 - 1;
			end
		end
	end
	do
		local v93 = v16(113691 + 81936);
		local v94 = 0 - 0;
		local v95 = v29();
		v30.FanTheHammerCP = function()
			local v119 = 0 + 0;
			while true do
				if (((0 + 0) == v119) or ((1902 - (152 + 701)) >= (5743 - (430 + 881)))) then
					if ((((v29() - v95) < (0.5 + 0)) and (v94 > (895 - (557 + 338)))) or ((1410 + 3358) <= (2383 - 1537))) then
						if ((v94 > v13:ComboPoints()) or ((11758 - 8400) <= (3772 - 2352))) then
							return v94;
						else
							v94 = 0 - 0;
						end
					end
					return 801 - (499 + 302);
				end
			end
		end;
		v10:RegisterForSelfCombatEvent(function(v120, v120, v120, v120, v120, v120, v120, v120, v120, v120, v120, v121, v120, v120, v122, v123)
			if ((v121 == (186629 - (39 + 827))) or ((10321 - 6582) <= (6711 - 3706))) then
				if (((v29() - v95) > (0.5 - 0)) or ((2546 - 887) >= (183 + 1951))) then
					v94 = v22(v30.CPMaxSpend(), v13:ComboPoints() + v122 + (v25(0 - 0, v122 - (1 + 0)) * v22(2 - 0, v13:BuffStack(v93) - (105 - (103 + 1)))));
					v95 = v29();
				end
			end
		end, "SPELL_ENERGIZE");
	end
	do
		local v97, v98 = 554 - (475 + 79), 0 - 0;
		local v99 = v16(889376 - 611451);
		v30.TimeToNextTornado = function()
			if (not v13:BuffUp(v99, nil, true) or ((422 + 2838) < (2073 + 282))) then
				return 1503 - (1395 + 108);
			end
			local v124 = v13:BuffRemains(v99, nil, true) % (2 - 1);
			if ((v29() == v97) or ((1873 - (7 + 1197)) == (1842 + 2381))) then
				return 0 + 0;
			elseif ((((v29() - v97) < (319.1 - (27 + 292))) and (v124 < (0.25 - 0))) or ((2157 - 465) < (2465 - 1877))) then
				return 1 - 0;
			elseif ((((v124 > (0.9 - 0)) or (v124 == (139 - (43 + 96)))) and ((v29() - v97) > (0.75 - 0))) or ((10844 - 6047) < (3030 + 621))) then
				return 0.1 + 0;
			end
			return v124;
		end;
		v10:RegisterForSelfCombatEvent(function(v125, v125, v125, v125, v125, v125, v125, v125, v125, v125, v125, v126)
			if ((v126 == (420484 - 207741)) or ((1601 + 2576) > (9089 - 4239))) then
				v97 = v29();
			elseif ((v126 == (62283 + 135552)) or ((30 + 370) > (2862 - (1414 + 337)))) then
				v98 = v29();
			end
			if (((4991 - (1642 + 298)) > (2619 - 1614)) and (v98 == v97)) then
				v97 = 0 - 0;
			end
		end, "SPELL_CAST_SUCCESS");
	end
	do
		local v101 = 0 - 0;
		local v102;
		while true do
			if (((1216 + 2477) <= (3410 + 972)) and (v101 == (972 - (357 + 615)))) then
				v102 = {Counter=(0 + 0),LastMH=(0 - 0),LastOH=(0 + 0)};
				v30.TimeToSht = function(v193)
					local v194 = 0 - 0;
					local v195;
					local v196;
					local v197;
					local v198;
					local v199;
					local v200;
					while true do
						if ((v194 == (2 + 0)) or ((224 + 3058) > (2578 + 1522))) then
							v199 = {};
							for v228 = 1301 - (384 + 917), 699 - (128 + 569) do
								local v229 = 1543 - (1407 + 136);
								while true do
									if ((v229 == (1887 - (687 + 1200))) or ((5290 - (556 + 1154)) < (10005 - 7161))) then
										v27(v199, v197 + (v228 * v195));
										v27(v199, v198 + (v228 * v196));
										break;
									end
								end
							end
							v194 = 98 - (9 + 86);
						end
						if (((510 - (275 + 146)) < (731 + 3759)) and (v194 == (64 - (29 + 35)))) then
							if ((v102.Counter >= v193) or ((22084 - 17101) < (5400 - 3592))) then
								return 0 - 0;
							end
							v195, v196 = v28("player");
							v194 = 1 + 0;
						end
						if (((4841 - (53 + 959)) > (4177 - (312 + 96))) and (v194 == (1 - 0))) then
							v197 = v25(v102.LastMH + v195, v29());
							v198 = v25(v102.LastOH + v196, v29());
							v194 = 287 - (147 + 138);
						end
						if (((2384 - (813 + 86)) <= (2625 + 279)) and (v194 == (4 - 1))) then
							table.sort(v199);
							v200 = v22(497 - (18 + 474), v25(1 + 0, v193 - v102.Counter));
							v194 = 12 - 8;
						end
						if (((5355 - (860 + 226)) == (4572 - (121 + 182))) and (v194 == (1 + 3))) then
							return v199[v200] - v29();
						end
					end
				end;
				v101 = 1241 - (988 + 252);
			end
			if (((44 + 343) <= (872 + 1910)) and (v101 == (1972 - (49 + 1921)))) then
				v10:RegisterForSelfCombatEvent(function(v201, v201, v201, v201, v201, v201, v201, v201, v201, v201, v201, v201, v201, v201, v201, v201, v201, v201, v201, v201, v201, v201, v201, v202)
					local v203 = 890 - (223 + 667);
					while true do
						if ((v203 == (52 - (51 + 1))) or ((3268 - 1369) <= (1963 - 1046))) then
							v102.Counter = v102.Counter + (1126 - (146 + 979));
							if (v202 or ((1217 + 3095) <= (1481 - (311 + 294)))) then
								v102.LastOH = v29();
							else
								v102.LastMH = v29();
							end
							break;
						end
					end
				end, "SWING_DAMAGE");
				v10:RegisterForSelfCombatEvent(function(v204, v204, v204, v204, v204, v204, v204, v204, v204, v204, v204, v204, v204, v204, v204, v205)
					if (((6224 - 3992) <= (1100 + 1496)) and v205) then
						v102.LastOH = v29();
					else
						v102.LastMH = v29();
					end
				end, "SWING_MISSED");
				break;
			end
			if (((3538 - (496 + 947)) < (5044 - (1233 + 125))) and ((1 + 0) == v101)) then
				v10:RegisterForSelfCombatEvent(function()
					v102.Counter = 0 + 0;
					v102.LastMH = v29();
					v102.LastOH = v29();
				end, "PLAYER_ENTERING_WORLD");
				v10:RegisterForSelfCombatEvent(function(v209, v209, v209, v209, v209, v209, v209, v209, v209, v209, v209, v210)
					if ((v210 == (37413 + 159498)) or ((3240 - (963 + 682)) >= (3734 + 740))) then
						v102.Counter = 1504 - (504 + 1000);
					end
				end, "SPELL_ENERGIZE");
				v101 = 2 + 0;
			end
		end
	end
	do
		local v103 = 0 + 0;
		local v104;
		local v105;
		local v106;
		while true do
			if ((v103 == (1 + 0)) or ((6810 - 2191) < (2463 + 419))) then
				v106 = nil;
				function v106()
					local v211 = 0 + 0;
					while true do
						if (((182 - (156 + 26)) == v211) or ((170 + 124) >= (7558 - 2727))) then
							if (((2193 - (149 + 15)) <= (4044 - (890 + 70))) and not v13:AffectingCombat()) then
								local v236 = 117 - (39 + 78);
								while true do
									if ((v236 == (482 - (14 + 468))) or ((4479 - 2442) == (6763 - 4343))) then
										v104 = v13:CritChancePct();
										v10.Debug("Base Crit Set to: " .. v104);
										break;
									end
								end
							end
							if (((2301 + 2157) > (2345 + 1559)) and ((v105 == nil) or (v105 < (0 + 0)))) then
								v105 = 0 + 0;
							else
								v105 = v105 - (1 + 0);
							end
							v211 = 1 - 0;
						end
						if (((431 + 5) >= (431 - 308)) and (v211 == (1 + 0))) then
							if (((551 - (12 + 39)) < (1690 + 126)) and (v105 > (0 - 0))) then
								v24.After(10 - 7, v106);
							end
							break;
						end
					end
				end
				v103 = 1 + 1;
			end
			if (((1882 + 1692) == (9062 - 5488)) and (v103 == (2 + 0))) then
				v10:RegisterForEvent(function()
					if (((1068 - 847) < (2100 - (1596 + 114))) and (v105 == (0 - 0))) then
						v24.After(716 - (164 + 549), v106);
						v105 = 1440 - (1059 + 379);
					end
				end, "PLAYER_EQUIPMENT_CHANGED");
				v30.BaseAttackCrit = function()
					return v104;
				end;
				break;
			end
			if ((v103 == (0 - 0)) or ((1147 + 1066) <= (240 + 1181))) then
				v104 = v13:CritChancePct();
				v105 = 392 - (145 + 247);
				v103 = 1 + 0;
			end
		end
	end
	do
		local v107 = v16.Rogue.Assassination;
		local v108 = v16.Rogue.Subtlety;
		local function v109()
			local v127 = 0 + 0;
			while true do
				if (((9066 - 6008) < (933 + 3927)) and (v127 == (0 + 0))) then
					if ((v107.Nightstalker:IsAvailable() and v13:StealthUp(true, false, true)) or ((2103 - 807) >= (5166 - (254 + 466)))) then
						return (561 - (544 + 16)) + ((0.05 - 0) * v107.Nightstalker:TalentRank());
					end
					return 629 - (294 + 334);
				end
			end
		end
		local function v110()
			local v128 = 253 - (236 + 17);
			while true do
				if ((v128 == (0 + 0)) or ((1085 + 308) > (16905 - 12416))) then
					if ((v107.ImprovedGarrote:IsAvailable() and (v13:BuffUp(v107.ImprovedGarroteAura, nil, true) or v13:BuffUp(v107.ImprovedGarroteBuff, nil, true) or v13:BuffUp(v107.SepsisBuff, nil, true))) or ((20945 - 16521) < (14 + 13))) then
						return 1.5 + 0;
					end
					return 795 - (413 + 381);
				end
			end
		end
		v107.Rupture:RegisterPMultiplier(v109, {v108.FinalityRuptureBuff,(2.3 - 1)});
		v107.Garrote:RegisterPMultiplier(v109, v110);
	end
end;
return v0["Epix_Rogue_Rogue.lua"]();

