local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((2087 - (839 + 194)) > (4619 - (322 + 905)))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Rogue_Rogue.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v11.Player;
	local v13 = v11.Target;
	local v14 = v11.MouseOver;
	local v15 = v9.Spell;
	local v16 = v9.MultiSpell;
	local v17 = v9.Item;
	local v18 = v9.Utils.MergeTableByKey;
	local v19 = v9.Commons.Everyone;
	local v20 = v9.Macro;
	local v21 = math.min;
	local v22 = pairs;
	local v23 = C_Timer;
	local v24 = math.max;
	local v25 = math.abs;
	local v22 = v22;
	local v26 = table.insert;
	local v27 = UnitAttackSpeed;
	local v28 = GetTime;
	local v29 = {};
	v9.Commons.Rogue = v29;
	if (not v15.Rogue or ((1287 - (602 + 9)) >= (2831 - (449 + 740)))) then
		v15.Rogue = {};
	end
	v15.Rogue.Commons = {Sanguine=v15(227382 - (826 + 46), nil, 948 - (245 + 702)),AncestralCall=v15(868160 - 593422, nil, 1 + 1),ArcanePulse=v15(262262 - (260 + 1638), nil, 443 - (382 + 58)),ArcaneTorrent=v15(80349 - 55303, nil, 4 + 0),BagofTricks=v15(645659 - 333248, nil, 14 - 9),Berserking=v15(27502 - (902 + 303), nil, 12 - 6),BloodFury=v15(49547 - 28975, nil, 1 + 6),Fireblood=v15(266911 - (1121 + 569), nil, 222 - (22 + 192)),LightsJudgment=v15(256330 - (483 + 200), nil, 1472 - (1404 + 59)),Shadowmeld=v15(161423 - 102439, nil, 13 - 3),CloakofShadows=v15(31989 - (468 + 297), nil, 573 - (334 + 228)),CrimsonVial=v15(625051 - 439740, nil, 27 - 15),Evasion=v15(9569 - 4292, nil, 4 + 9),Feint=v15(2202 - (141 + 95), nil, 14 + 0),Blind=v15(5389 - 3295, nil, 36 - 21),CheapShot=v15(430 + 1403, nil, 43 - 27),Kick=v15(1242 + 524, nil, 9 + 8),KidneyShot=v15(574 - 166, nil, 11 + 7),Sap=v15(6933 - (92 + 71), nil, 10 + 9),Shiv=v15(9983 - 4045, nil, 785 - (574 + 191)),SliceandDice=v15(260242 + 55254, nil, 52 - 31),Shadowstep=v15(18672 + 17882, nil, 871 - (254 + 595)),Sprint=v15(3109 - (55 + 71), nil, 29 - 6),TricksoftheTrade=v15(59724 - (573 + 1217), nil, 66 - 42),CripplingPoison=v15(260 + 3148, nil, 40 - 15),DeadlyPoison=v15(3762 - (714 + 225), nil, 75 - 49),InstantPoison=v15(439975 - 124391, nil, 3 + 24),AmplifyingPoison=v15(552630 - 170966, nil, 834 - (118 + 688)),NumbingPoison=v15(5809 - (25 + 23), nil, 6 + 23),WoundPoison=v15(10565 - (927 + 959), nil, 101 - 71),AtrophicPoison=v15(382369 - (16 + 716), nil, 59 - 28),AcrobaticStrikes=v15(197021 - (11 + 86), nil, 77 - 45),Alacrity=v15(193824 - (175 + 110), nil, 82 - 49),ColdBlood=v15(1885327 - 1503082, nil, 1830 - (503 + 1293)),DeeperStratagem=v15(540493 - 346962),EchoingReprimand=v15(278863 + 106753, nil, 1097 - (810 + 251)),EchoingReprimand2=v15(224542 + 99016, nil, 12 + 25),EchoingReprimand3=v15(291674 + 31885, nil, 571 - (43 + 490)),EchoingReprimand4=v15(324293 - (711 + 22), nil, 150 - 111),EchoingReprimand5=v15(355697 - (240 + 619), nil, 10 + 30),FindWeakness=v15(144790 - 53767, nil, 3 + 38),FindWeaknessDebuff=v15(317964 - (1344 + 400), nil, 447 - (255 + 150)),ImprovedAmbush=v15(300593 + 81027, nil, 24 + 19),MarkedforDeath=v15(587988 - 450369, nil, 141 - 97),Nightstalker=v15(15801 - (404 + 1335), nil, 451 - (183 + 223)),ResoundingClarity=v15(464381 - 82759, nil, 31 + 15),SealFate=v15(5107 + 9083, nil, 384 - (10 + 327)),Sepsis=v15(268394 + 117014, nil, 386 - (118 + 220)),SepsisBuff=v15(125284 + 250655, nil, 498 - (108 + 341)),ShadowDance=v15(83231 + 102082, nil, 211 - 161),ShadowDanceTalent=v15(396423 - (711 + 782), nil, 97 - 46),ShadowDanceBuff=v15(185891 - (270 + 199)),Subterfuge=v15(35080 + 73128, nil, 1872 - (580 + 1239)),SubterfugeBuff=v15(342440 - 227248, nil, 52 + 2),ThistleTea=v15(13710 + 367913, nil, 140 + 180),Vigor=v15(39119 - 24136),Stealth=v15(1109 + 675, nil, 1224 - (645 + 522)),Stealth2=v15(116981 - (1010 + 780), nil, 58 + 0),Vanish=v15(8841 - 6985, nil, 172 - 113),VanishBuff=v15(13163 - (1045 + 791), nil, 151 - 91),VanishBuff2=v15(175893 - 60700, nil, 566 - (351 + 154)),PoolEnergy=v15(1001484 - (1281 + 293), nil, 328 - (28 + 238)),Gouge=v15(3967 - 2191, nil, 1695 - (1381 + 178))};
	v15.Rogue.Assassination = v18(v15.Rogue.Commons, {Ambush=v15(8138 + 538, nil, 51 + 12),AmbushOverride=v15(183430 + 246593),AmplifyingPoisonDebuff=v15(1321788 - 938374, nil, 34 + 30),AmplifyingPoisonDebuffDeathmark=v15(394798 - (381 + 89), nil, 58 + 7),CripplingPoisonDebuff=v15(2306 + 1103, nil, 112 - 46),DeadlyPoisonDebuff=v15(3974 - (1074 + 82), nil, 146 - 79),DeadlyPoisonDebuffDeathmark=v15(396108 - (214 + 1570), nil, 1523 - (990 + 465)),Envenom=v15(13458 + 19187, nil, 31 + 38),FanofKnives=v15(50298 + 1425, nil, 275 - 205),Garrote=v15(2429 - (1668 + 58), nil, 697 - (512 + 114)),GarroteDeathmark=v15(940736 - 579906, nil, 148 - 76),Mutilate=v15(4624 - 3295, nil, 34 + 39),PoisonedKnife=v15(34737 + 150828, nil, 65 + 9),Rupture=v15(6553 - 4610, nil, 2069 - (109 + 1885)),RuptureDeathmark=v15(362295 - (1269 + 200), nil, 145 - 69),WoundPoisonDebuff=v15(9495 - (98 + 717), nil, 903 - (802 + 24)),ArterialPrecision=v15(691163 - 290380, nil, 97 - 19),AtrophicPoisonDebuff=v15(57949 + 334439, nil, 61 + 18),BlindsideBuff=v15(19900 + 101253, nil, 18 + 62),CausticSpatter=v15(1173909 - 751934),CausticSpatterDebuff=v15(1407189 - 985213),CrimsonTempest=v15(43425 + 77986, nil, 33 + 48),CutToTheChase=v15(42618 + 9049, nil, 60 + 22),DashingScoundrel=v15(178256 + 203541, nil, 1516 - (797 + 636)),Deathmark=v15(1748872 - 1388678, nil, 1703 - (1427 + 192)),Doomblade=v15(132247 + 249426, nil, 197 - 112),DragonTemperedBlades=v15(343188 + 38613, nil, 39 + 47),Elusiveness=v15(79334 - (192 + 134)),Exsanguinate=v15(202082 - (316 + 960), nil, 49 + 39),ImprovedGarrote=v15(294512 + 87120, nil, 83 + 6),ImprovedGarroteBuff=v15(1500151 - 1107750, nil, 641 - (83 + 468)),ImprovedGarroteAura=v15(394209 - (1202 + 604), nil, 424 - 333),IndiscriminateCarnage=v15(635440 - 253638, nil, 254 - 162),IndiscriminateCarnageAura=v15(386079 - (45 + 280)),IndiscriminateCarnageBuff=v15(372321 + 13426),InternalBleeding=v15(135378 + 19575, nil, 34 + 59),Kingsbane=v15(213394 + 172233, nil, 17 + 77),LightweightShiv=v15(731418 - 336435),MasterAssassin=v15(257900 - (340 + 1571), nil, 38 + 57),MasterAssassinBuff=v15(258507 - (1733 + 39), nil, 263 - 167),PreyontheWeak=v15(132545 - (125 + 909), nil, 2045 - (1096 + 852)),PreyontheWeakDebuff=v15(114795 + 141114, nil, 139 - 41),SerratedBoneSpike=v15(373836 + 11588, nil, 611 - (409 + 103)),SerratedBoneSpikeDebuff=v15(394272 - (46 + 190), nil, 195 - (51 + 44)),ShivDebuff=v15(90114 + 229390, nil, 1418 - (1114 + 203)),VenomRush=v15(152878 - (228 + 498), nil, 23 + 79),ScentOfBlood=v15(210929 + 170870, nil, 1059 - (174 + 489)),ScentOfBloodBuff=v15(1026694 - 632614),ShroudedSuffocation=v15(387383 - (830 + 1075))});
	v15.Rogue.Outlaw = v18(v15.Rogue.Commons, {AdrenalineRush=v15(14274 - (303 + 221), nil, 1372 - (231 + 1038)),Ambush=v15(7230 + 1446, nil, 1266 - (171 + 991)),AmbushOverride=v15(1772213 - 1342190),BetweentheEyes=v15(846754 - 531413, nil, 262 - 157),BladeFlurry=v15(11107 + 2770, nil, 371 - 265),Dispatch=v15(6052 - 3954, nil, 171 - 64),Elusiveness=v15(244236 - 165228),Opportunity=v15(196875 - (111 + 1137)),PistolShot=v15(185921 - (91 + 67), nil, 327 - 217),RolltheBones=v15(78721 + 236787, nil, 634 - (423 + 100)),SinisterStrike=v15(1357 + 191958, nil, 309 - 197),Audacity=v15(199026 + 182819, nil, 884 - (326 + 445)),AudacityBuff=v15(1685672 - 1299402, nil, 253 - 139),BladeRush=v15(634622 - 362745, nil, 826 - (530 + 181)),CountTheOdds=v15(382863 - (614 + 267), nil, 148 - (19 + 13)),Dreadblades=v15(558502 - 215360, nil, 272 - 155),FanTheHammer=v15(1090783 - 708937, nil, 31 + 87),GhostlyStrike=v15(346348 - 149411, nil, 246 - 127),GreenskinsWickers=v15(388635 - (1293 + 519), nil, 244 - 124),GreenskinsWickersBuff=v15(1029056 - 634925, nil, 231 - 110),HiddenOpportunity=v15(1652749 - 1269468, nil, 287 - 165),ImprovedAdrenalineRush=v15(209432 + 185990, nil, 26 + 97),ImprovedBetweenTheEyes=v15(547150 - 311666, nil, 29 + 95),KeepItRolling=v15(126900 + 255089, nil, 79 + 46),KillingSpree=v15(52786 - (709 + 387), nil, 1984 - (673 + 1185)),LoadedDice=v15(742929 - 486759, nil, 407 - 280),LoadedDiceBuff=v15(421488 - 165317, nil, 92 + 36),PreyontheWeak=v15(98265 + 33246, nil, 173 - 44),PreyontheWeakDebuff=v15(62852 + 193057, nil, 259 - 129),QuickDraw=v15(386594 - 189656, nil, 2011 - (446 + 1434)),SummarilyDispatched=v15(383273 - (1040 + 243), nil, 393 - 261),SwiftSlasher=v15(383835 - (559 + 1288), nil, 2064 - (609 + 1322)),TakeEmBySurpriseBuff=v15(386361 - (13 + 441), nil, 500 - 366),Weaponmaster=v15(525792 - 325059, nil, 672 - 537),UnderhandedUpperhand=v15(15789 + 408255),DeftManeuvers=v15(1386905 - 1005027),Crackshot=v15(150489 + 273214),Broadside=v15(84726 + 108630, nil, 406 - 269),BuriedTreasure=v15(109223 + 90377, nil, 253 - 115),GrandMelee=v15(127832 + 65526, nil, 78 + 61),RuthlessPrecision=v15(138929 + 54428, nil, 118 + 22),SkullandCrossbones=v15(195289 + 4314, nil, 574 - (153 + 280)),TrueBearing=v15(558343 - 364984, nil, 128 + 14),ViciousFollowup=v15(155915 + 238964, nil, 75 + 68)});
	v15.Rogue.Subtlety = v18(v15.Rogue.Commons, {Backstab=v15(49 + 4, nil, 105 + 39),BlackPowder=v15(486012 - 166837, nil, 90 + 55),Elusiveness=v15(79675 - (89 + 578)),Eviscerate=v15(140601 + 56218, nil, 305 - 158),Rupture=v15(2992 - (572 + 477), nil, 20 + 128),ShadowBlades=v15(72898 + 48573, nil, 18 + 131),Shadowstrike=v15(185524 - (84 + 2), nil, 247 - 97),ShurikenStorm=v15(142524 + 55311, nil, 993 - (497 + 345)),ShurikenToss=v15(2917 + 111097, nil, 26 + 126),SymbolsofDeath=v15(213616 - (605 + 728), nil, 110 + 43),DanseMacabre=v15(850467 - 467939, nil, 8 + 146),DanseMacabreBuff=v15(1456595 - 1062626, nil, 140 + 15),DeeperDaggers=v15(1059814 - 677297, nil, 118 + 38),DeeperDaggersBuff=v15(383894 - (457 + 32), nil, 67 + 90),DarkBrew=v15(383906 - (832 + 570), nil, 149 + 9),DarkShadow=v15(64070 + 181617, nil, 562 - 403),EnvelopingShadows=v15(114696 + 123408, nil, 956 - (588 + 208)),Finality=v15(1030992 - 648467, nil, 1961 - (884 + 916)),FinalityBlackPowderBuff=v15(808012 - 422064, nil, 94 + 68),FinalityEviscerateBuff=v15(386602 - (232 + 421), nil, 2052 - (1569 + 320)),FinalityRuptureBuff=v15(94691 + 291260, nil, 32 + 132),Flagellation=v15(1296135 - 911504, nil, 770 - (316 + 289)),FlagellationPersistBuff=v15(1033366 - 638608, nil, 8 + 158),Gloomblade=v15(202211 - (666 + 787), nil, 592 - (360 + 65)),GoremawsBite=v15(398678 + 27913, nil, 443 - (79 + 175)),ImprovedShadowDance=v15(621228 - 227256, nil, 132 + 36),ImprovedShurikenStorm=v15(980738 - 660787, nil, 325 - 156),InvigoratingShadowdust=v15(383422 - (503 + 396)),LingeringShadow=v15(382705 - (92 + 89), nil, 329 - 159),LingeringShadowBuff=v15(197936 + 188024, nil, 102 + 69),MasterofShadows=v15(771385 - 574409, nil, 24 + 148),PerforatedVeins=v15(872190 - 489672, nil, 151 + 22),PerforatedVeinsBuff=v15(188309 + 205945, nil, 529 - 355),PreyontheWeak=v15(16414 + 115097, nil, 266 - 91),PreyontheWeakDebuff=v15(257153 - (485 + 759), nil, 407 - 231),Premeditation=v15(344349 - (442 + 747), nil, 1312 - (832 + 303)),PremeditationBuff=v15(344119 - (88 + 858), nil, 55 + 123),SecretStratagem=v15(326340 + 67980, nil, 8 + 171),SecretTechnique=v15(281508 - (766 + 23), nil, 888 - 708),Shadowcraft=v15(583434 - 156840),ShadowFocus=v15(285098 - 176889, nil, 614 - 433),ShurikenTornado=v15(278998 - (1036 + 37), nil, 130 + 52),SilentStorm=v15(751150 - 365428, nil, 144 + 39),SilentStormBuff=v15(387202 - (641 + 839), nil, 1097 - (910 + 3)),TheFirstDance=v15(975119 - 592614, nil, 1869 - (1466 + 218)),TheRotten=v15(175570 + 206445, nil, 1334 - (556 + 592)),TheRottenBuff=v15(140177 + 254026, nil, 995 - (329 + 479)),Weaponmaster=v15(194391 - (174 + 680), nil, 645 - 457)});
	if (((8572 - 4436) > (1712 + 685)) and not v17.Rogue) then
		v17.Rogue = {};
	end
	v17.Rogue.Commons = {AlgetharPuzzleBox=v17(194440 - (396 + 343), {(1490 - (29 + 1448)),(52 - 38)}),ManicGrieftorch=v17(907248 - 712940, {(1540 - (389 + 1138)),(14 + 0)}),WindscarWhetstone=v17(76241 + 61245, {(1558 - (320 + 1225)),(9 + 5)}),Healthstone=v17(6976 - (157 + 1307)),RefreshingHealingPotion=v17(193239 - (821 + 1038)),DreamwalkersHealingPotion=v17(516520 - 309497),PotionOfWitheringDreams=v17(22643 + 184398)};
	v17.Rogue.Assassination = v18(v17.Rogue.Commons, {AlgetharPuzzleBox=v17(344064 - 150363, {(32 - 19),(1 + 13)}),AshesoftheEmbersoul=v17(53175 + 153992, {(19 - 6),(4 + 10)}),WitherbarksBranch=v17(287950 - 177951, {(6 + 7),(9 + 5)})});
	v17.Rogue.Outlaw = v18(v17.Rogue.Commons, {ManicGrieftorch=v17(100489 + 93819, {(7 + 6),(1428 - (1001 + 413))}),WindscarWhetstone=v17(306591 - 169105, {(706 - (627 + 66)),(616 - (512 + 90))}),BeaconToTheBeyond=v17(205869 - (1665 + 241), {(6 + 7),(36 - 22)}),DragonfireBombDispenser=v17(342869 - 140259, {(10 + 3),(1 + 13)})});
	v17.Rogue.Subtlety = v18(v17.Rogue.Commons, {ManicGrieftorch=v17(195544 - (298 + 938), {(1679 - (636 + 1030)),(14 + 0)}),StormEatersBoon=v17(57720 + 136582, {(234 - (55 + 166)),(2 + 12)}),BeaconToTheBeyond=v17(778949 - 574986, {(22 - 9),(6 + 8)}),AshesoftheEmbersoul=v17(160966 + 46201, {(34 - (20 + 1)),(333 - (134 + 185))}),WitherbarksBranch=v17(111132 - (549 + 584), {(44 - 31),(8 + 6)}),BandolierOfTwistedBlades=v17(208337 - (786 + 386), {(1392 - (1055 + 324)),(13 + 1)}),Mirror=v17(21830 + 185751, {(43 - 30),(34 - 20)})});
	if (not v20.Rogue or ((1542 + 2792) == (16353 - 12108))) then
		v20.Rogue = {};
	end
	v20.Rogue.Commons = {Healthstone=v20(72 - 51),BlindMouseover=v20(7 + 2),CheapShotMouseover=v20(25 - 15),KickMouseover=v20(699 - (364 + 324)),KidneyShotMouseover=v20(32 - 20),TricksoftheTradeFocus=v20(30 - 17),WindscarWhetstone=v20(9 + 17),RefreshingHealingPotion=v20(121 - 92)};
	v20.Rogue.Outlaw = v18(v20.Rogue.Commons, {Dispatch=v20(21 - 7),PistolShotMouseover=v20(45 - 30),SinisterStrikeMouseover=v20(1295 - (1249 + 19))});
	v20.Rogue.Assassination = v18(v20.Rogue.Commons, {GarroteMouseOver=v20(26 + 2)});
	v20.Rogue.Subtlety = v18(v20.Rogue.Commons, {SecretTechnique=v20(62 - 46),ShadowDance=v20(1103 - (686 + 400)),ShadowDanceSymbol=v20(21 + 5),VanishShadowstrike=v20(247 - (73 + 156)),ShurikenStormSD=v20(1 + 18),ShurikenStormVanish=v20(831 - (721 + 90)),GloombladeSD=v20(1 + 21),GloombladeVanish=v20(74 - 51),BackstabMouseover=v20(494 - (224 + 246)),RuptureMouseover=v20(40 - 15),ColdBloodTechnique=v20(55 - 25)});
	v29.StealthSpell = function()
		return (v15.Rogue.Commons.Subterfuge:IsAvailable() and v15.Rogue.Commons.Stealth2) or v15.Rogue.Commons.Stealth;
	end;
	v29.VanishBuffSpell = function()
		return (v15.Rogue.Commons.Subterfuge:IsAvailable() and v15.Rogue.Commons.VanishBuff2) or v15.Rogue.Commons.VanishBuff;
	end;
	v29.Stealth = function(v49, v50)
		local v51 = 0 + 0;
		while true do
			if ((v51 == (0 + 0)) or ((3141 + 1135) <= (6025 - 2994))) then
				if ((EpicSettings.Settings['StealthOOC'] and (v15.Rogue.Commons.Stealth:IsCastable() or v15.Rogue.Commons.Stealth2:IsCastable()) and v12:StealthDown()) or ((15913 - 11131) <= (1712 - (203 + 310)))) then
					if (v9.Press(v49, nil) or ((6857 - (1238 + 755)) < (133 + 1769))) then
						return "Cast Stealth (OOC)";
					end
				end
				return false;
			end
		end
	end;
	do
		local v52 = v15.Rogue.Commons;
		local v53 = v52.CrimsonVial;
		v29.CrimsonVial = function()
			local v117 = 1534 - (709 + 825);
			local v118;
			while true do
				if (((8916 - 4077) >= (5389 - 1689)) and (v117 == (865 - (196 + 668)))) then
					return false;
				end
				if ((v117 == (0 - 0)) or ((2226 - 1151) > (2751 - (171 + 662)))) then
					v118 = EpicSettings.Settings['CrimsonVialHP'] or (93 - (4 + 89));
					if (((1387 - 991) <= (1386 + 2418)) and v53:IsCastable() and v53:IsReady() and (v12:HealthPercentage() <= v118)) then
						if (v9.Cast(v53, nil) or ((18311 - 14142) == (858 + 1329))) then
							return "Cast Crimson Vial (Defensives)";
						end
					end
					v117 = 1487 - (35 + 1451);
				end
			end
		end;
	end
	do
		local v55 = v15.Rogue.Commons;
		local v56 = v55.Feint;
		v29.Feint = function()
			local v119 = 1453 - (28 + 1425);
			local v120;
			while true do
				if (((3399 - (941 + 1052)) == (1349 + 57)) and (v119 == (1514 - (822 + 692)))) then
					v120 = EpicSettings.Settings['FeintHP'] or (0 - 0);
					if (((722 + 809) < (4568 - (45 + 252))) and v56:IsCastable() and v12:BuffDown(v56) and (v12:HealthPercentage() <= v120)) then
						if (((629 + 6) == (219 + 416)) and v9.Cast(v56, nil)) then
							return "Cast Feint (Defensives)";
						end
					end
					break;
				end
			end
		end;
	end
	do
		local v58 = 0 - 0;
		local v59 = false;
		local function v60(v121)
			if (((3806 - (114 + 319)) <= (5104 - 1548)) and not v12:AffectingCombat() and v12:BuffRefreshable(v121)) then
				if (v9.Press(v121, nil, true) or ((4216 - 925) < (2091 + 1189))) then
					return "poison";
				end
			end
		end
		v29.Poisons = function()
			local v122 = 0 - 0;
			while true do
				if (((9189 - 4803) >= (2836 - (556 + 1407))) and (v122 == (1206 - (741 + 465)))) then
					v59 = v12:BuffUp(v15.Rogue.Commons.WoundPoison);
					if (((1386 - (170 + 295)) <= (581 + 521)) and v15.Rogue.Assassination.DragonTemperedBlades:IsAvailable()) then
						local v223 = 0 + 0;
						local v224;
						while true do
							if (((11586 - 6880) >= (799 + 164)) and (v223 == (0 + 0))) then
								v224 = v60((v59 and v15.Rogue.Commons.WoundPoison) or v15.Rogue.Commons.DeadlyPoison);
								if (v224 or ((544 + 416) <= (2106 - (957 + 273)))) then
									return v224;
								end
								v223 = 1 + 0;
							end
							if ((v223 == (1 + 0)) or ((7872 - 5806) == (2455 - 1523))) then
								if (((14737 - 9912) < (23980 - 19137)) and v15.Rogue.Commons.AmplifyingPoison:IsAvailable()) then
									local v246 = 1780 - (389 + 1391);
									while true do
										if ((v246 == (0 + 0)) or ((404 + 3473) >= (10328 - 5791))) then
											v224 = v60(v15.Rogue.Commons.AmplifyingPoison);
											if (v224 or ((5266 - (783 + 168)) < (5792 - 4066))) then
												return v224;
											end
											break;
										end
									end
								else
									v224 = v60(v15.Rogue.Commons.InstantPoison);
									if (v224 or ((3619 + 60) < (936 - (309 + 2)))) then
										return v224;
									end
								end
								break;
							end
						end
					elseif (v59 or ((14202 - 9577) < (1844 - (1090 + 122)))) then
						local v235 = v60(v15.Rogue.Commons.WoundPoison);
						if (v235 or ((27 + 56) > (5978 - 4198))) then
							return v235;
						end
					elseif (((374 + 172) <= (2195 - (628 + 490))) and v15.Rogue.Commons.AmplifyingPoison:IsAvailable() and v12:BuffDown(v15.Rogue.Commons.DeadlyPoison)) then
						local v240 = 0 + 0;
						local v241;
						while true do
							if ((v240 == (0 - 0)) or ((4551 - 3555) > (5075 - (431 + 343)))) then
								v241 = v60(v15.Rogue.Commons.AmplifyingPoison);
								if (((8219 - 4149) > (1987 - 1300)) and v241) then
									return v241;
								end
								break;
							end
						end
					elseif (v15.Rogue.Commons.DeadlyPoison:IsAvailable() or ((519 + 137) >= (426 + 2904))) then
						local v247 = v60(v15.Rogue.Commons.DeadlyPoison);
						if (v247 or ((4187 - (556 + 1139)) <= (350 - (6 + 9)))) then
							return v247;
						end
					else
						local v248 = v60(v15.Rogue.Commons.InstantPoison);
						if (((792 + 3530) >= (1313 + 1249)) and v248) then
							return v248;
						end
					end
					v122 = 170 - (28 + 141);
				end
				if ((v122 == (1 + 0)) or ((4488 - 851) >= (2671 + 1099))) then
					if (v12:BuffDown(v15.Rogue.Commons.CripplingPoison) or ((3696 - (486 + 831)) > (11912 - 7334))) then
						if (v15.Rogue.Commons.AtrophicPoison:IsAvailable() or ((1700 - 1217) > (141 + 602))) then
							local v236 = v60(v15.Rogue.Commons.AtrophicPoison);
							if (((7759 - 5305) > (1841 - (668 + 595))) and v236) then
								return v236;
							end
						elseif (((837 + 93) < (899 + 3559)) and v15.Rogue.Commons.NumbingPoison:IsAvailable()) then
							local v242 = 0 - 0;
							local v243;
							while true do
								if (((952 - (23 + 267)) <= (2916 - (1129 + 815))) and (v242 == (387 - (371 + 16)))) then
									v243 = v60(v15.Rogue.Commons.NumbingPoison);
									if (((6120 - (1326 + 424)) == (8276 - 3906)) and v243) then
										return v243;
									end
									break;
								end
							end
						else
							local v244 = 0 - 0;
							local v245;
							while true do
								if ((v244 == (118 - (88 + 30))) or ((5533 - (720 + 51)) <= (1915 - 1054))) then
									v245 = v60(v15.Rogue.Commons.CripplingPoison);
									if (v245 or ((3188 - (421 + 1355)) == (7034 - 2770))) then
										return v245;
									end
									break;
								end
							end
						end
					else
						local v225 = 0 + 0;
						local v226;
						while true do
							if ((v225 == (1083 - (286 + 797))) or ((11580 - 8412) < (3565 - 1412))) then
								v226 = v60(v15.Rogue.Commons.CripplingPoison);
								if (v226 or ((5415 - (397 + 42)) < (417 + 915))) then
									return v226;
								end
								break;
							end
						end
					end
					break;
				end
			end
		end;
	end
	v29.MfDSniping = function(v62)
		if (((5428 - (24 + 776)) == (7129 - 2501)) and v62:IsCastable()) then
			local v177, v178 = nil, 845 - (222 + 563);
			local v179 = (v14:IsInRange(66 - 36) and v14:TimeToDie()) or (8000 + 3111);
			for v180, v181 in v22(v12:GetEnemiesInRange(220 - (23 + 167))) do
				local v182 = v181:TimeToDie();
				if ((not v181:IsMfDBlacklisted() and (v182 < (v12:ComboPointsDeficit() * (1799.5 - (690 + 1108)))) and (v182 < v178)) or ((20 + 34) == (326 + 69))) then
					if (((930 - (40 + 808)) == (14 + 68)) and ((v179 - v182) > (3 - 2))) then
						v177, v178 = v181, v182;
					else
						v177, v178 = v14, v179;
					end
				end
			end
			if ((v177 and (v177:GUID() ~= v13:GUID())) or ((556 + 25) < (150 + 132))) then
				v9.Press(v177, v62);
			end
		end
	end;
	v29.CanDoTUnit = function(v63, v64)
		return v19.CanDoTUnit(v63, v64);
	end;
	do
		local v65 = 0 + 0;
		local v66;
		local v67;
		local v68;
		local v69;
		while true do
			if ((v65 == (574 - (47 + 524))) or ((2992 + 1617) < (6820 - 4325))) then
				v66.Rupture:RegisterPMultiplier(v68, {v67.FinalityRuptureBuff,(1727.3 - (1165 + 561))});
				v66.Garrote:RegisterPMultiplier(v68, v69);
				v65 = 1 + 3;
			end
			if (((3567 - 2415) == (440 + 712)) and (v65 == (480 - (341 + 138)))) then
				v68 = nil;
				function v68()
					if (((512 + 1384) <= (7061 - 3639)) and v66.Nightstalker:IsAvailable() and v12:StealthUp(true, false, true)) then
						return (327 - (89 + 237)) + ((0.05 - 0) * v66.Nightstalker:TalentRank());
					end
					return 1 - 0;
				end
				v65 = 883 - (581 + 300);
			end
			if ((v65 == (1222 - (855 + 365))) or ((2351 - 1361) > (529 + 1091))) then
				v69 = nil;
				function v69()
					local v205 = 1235 - (1030 + 205);
					while true do
						if ((v205 == (0 + 0)) or ((816 + 61) > (4981 - (156 + 130)))) then
							if (((6114 - 3423) >= (3119 - 1268)) and v66.ImprovedGarrote:IsAvailable() and (v12:BuffUp(v66.ImprovedGarroteAura, nil, true) or v12:BuffUp(v66.ImprovedGarroteBuff, nil, true) or v12:BuffUp(v66.SepsisBuff, nil, true))) then
								return 1.5 - 0;
							end
							return 1 + 0;
						end
					end
				end
				v65 = 2 + 1;
			end
			if ((v65 == (69 - (10 + 59))) or ((845 + 2140) >= (23914 - 19058))) then
				v66 = v15.Rogue.Assassination;
				v67 = v15.Rogue.Subtlety;
				v65 = 1164 - (671 + 492);
			end
			if (((3404 + 872) >= (2410 - (369 + 846))) and (v65 == (2 + 2))) then
				v66.CrimsonTempest:RegisterPMultiplier(v68);
				break;
			end
		end
	end
	do
		local v70 = v15(165159 + 28372);
		local v71 = v15(396266 - (1036 + 909));
		local v72 = v15(313515 + 80805);
		v29.CPMaxSpend = function()
			return (8 - 3) + ((v70:IsAvailable() and (204 - (11 + 192))) or (0 + 0)) + ((v71:IsAvailable() and (176 - (135 + 40))) or (0 - 0)) + ((v72:IsAvailable() and (1 + 0)) or (0 - 0));
		end;
	end
	v29.CPSpend = function()
		return v21(v12:ComboPoints(), v29.CPMaxSpend());
	end;
	do
		v29.AnimachargedCP = function()
			local v123 = 0 - 0;
			while true do
				if (((3408 - (50 + 126)) <= (13059 - 8369)) and (v123 == (0 + 0))) then
					if (v12:BuffUp(v15.Rogue.Commons.EchoingReprimand2) or ((2309 - (1233 + 180)) >= (4115 - (522 + 447)))) then
						return 1423 - (107 + 1314);
					elseif (((1421 + 1640) >= (9013 - 6055)) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand3)) then
						return 2 + 1;
					elseif (((6328 - 3141) >= (2548 - 1904)) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand4)) then
						return 1914 - (716 + 1194);
					elseif (((11 + 633) <= (76 + 628)) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand5)) then
						return 508 - (74 + 429);
					end
					return -(1 - 0);
				end
			end
		end;
		v29.EffectiveComboPoints = function(v124)
			local v125 = 0 + 0;
			while true do
				if (((2192 - 1234) > (670 + 277)) and (v125 == (0 - 0))) then
					if (((11106 - 6614) >= (3087 - (279 + 154))) and (((v124 == (780 - (454 + 324))) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand2)) or ((v124 == (3 + 0)) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand3)) or ((v124 == (21 - (12 + 5))) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand4)) or ((v124 == (3 + 2)) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand5)))) then
						return 17 - 10;
					end
					return v124;
				end
			end
		end;
	end
	do
		local v76 = 0 + 0;
		local v77;
		local v78;
		local v79;
		local v80;
		local v81;
		while true do
			if (((4535 - (277 + 816)) >= (6422 - 4919)) and (v76 == (1184 - (1058 + 125)))) then
				v79 = v15.Rogue.Assassination.AmplifyingPoisonDebuff;
				v80 = v15.Rogue.Assassination.CripplingPoisonDebuff;
				v76 = 1 + 1;
			end
			if ((v76 == (977 - (815 + 160))) or ((13601 - 10431) <= (3475 - 2011))) then
				v81 = v15.Rogue.Assassination.AtrophicPoisonDebuff;
				v29.Poisoned = function(v206)
					return ((v206:DebuffUp(v77) or v206:DebuffUp(v79) or v206:DebuffUp(v80) or v206:DebuffUp(v78) or v206:DebuffUp(v81)) and true) or false;
				end;
				break;
			end
			if ((v76 == (0 + 0)) or ((14022 - 9225) == (6286 - (41 + 1857)))) then
				v77 = v15.Rogue.Assassination.DeadlyPoisonDebuff;
				v78 = v15.Rogue.Assassination.WoundPoisonDebuff;
				v76 = 1894 - (1222 + 671);
			end
		end
	end
	do
		local v82 = 0 - 0;
		local v83;
		local v84;
		local v85;
		local v86;
		local v87;
		local v88;
		while true do
			if (((791 - 240) <= (1863 - (229 + 953))) and (v82 == (1777 - (1111 + 663)))) then
				v29.PoisonedBleeds = function()
					local v207 = 1579 - (874 + 705);
					while true do
						if (((459 + 2818) > (278 + 129)) and (v207 == (1 - 0))) then
							return v88;
						end
						if (((133 + 4562) >= (2094 - (642 + 37))) and (v207 == (0 + 0))) then
							v88 = 0 + 0;
							for v237, v238 in v22(v12:GetEnemiesInRange(125 - 75)) do
								if (v29.Poisoned(v238) or ((3666 - (233 + 221)) <= (2182 - 1238))) then
									if (v238:DebuffUp(v83) or ((2726 + 370) <= (3339 - (718 + 823)))) then
										local v249 = 0 + 0;
										while true do
											if (((4342 - (266 + 539)) == (10014 - 6477)) and ((1225 - (636 + 589)) == v249)) then
												v88 = v88 + (2 - 1);
												if (((7913 - 4076) >= (1245 + 325)) and v238:DebuffUp(v84)) then
													v88 = v88 + 1 + 0;
												end
												break;
											end
										end
									end
									if (v238:DebuffUp(v85) or ((3965 - (657 + 358)) == (10092 - 6280))) then
										v88 = v88 + (2 - 1);
										if (((5910 - (1151 + 36)) >= (2239 + 79)) and v238:DebuffUp(v86)) then
											v88 = v88 + 1 + 0;
										end
									end
									if (v238:DebuffUp(v87) or ((6053 - 4026) > (4684 - (1552 + 280)))) then
										v88 = v88 + (835 - (64 + 770));
									end
								end
							end
							v207 = 1 + 0;
						end
					end
				end;
				break;
			end
			if ((v82 == (4 - 2)) or ((202 + 934) > (5560 - (157 + 1086)))) then
				v87 = v15.Rogue.Assassination.InternalBleeding;
				v88 = 0 - 0;
				v82 = 13 - 10;
			end
			if (((7282 - 2534) == (6480 - 1732)) and (v82 == (819 - (599 + 220)))) then
				v83 = v15.Rogue.Assassination.Garrote;
				v84 = v15.Rogue.Assassination.GarroteDeathmark;
				v82 = 1 - 0;
			end
			if (((5667 - (1813 + 118)) <= (3465 + 1275)) and (v82 == (1218 - (841 + 376)))) then
				v85 = v15.Rogue.Assassination.Rupture;
				v86 = v15.Rogue.Assassination.RuptureDeathmark;
				v82 = 2 - 0;
			end
		end
	end
	do
		local v89 = v28();
		v29.RtBRemains = function(v126)
			local v127 = (v89 - v28()) - v9.RecoveryOffset(v126);
			return ((v127 >= (0 + 0)) and v127) or (0 - 0);
		end;
		v9:RegisterForSelfCombatEvent(function(v128, v128, v128, v128, v128, v128, v128, v128, v128, v128, v128, v129)
			if ((v129 == (316367 - (464 + 395))) or ((8700 - 5310) <= (1470 + 1590))) then
				v89 = v28() + (867 - (467 + 370));
			end
		end, "SPELL_AURA_APPLIED");
		v9:RegisterForSelfCombatEvent(function(v130, v130, v130, v130, v130, v130, v130, v130, v130, v130, v130, v131)
			if ((v131 == (652007 - 336499)) or ((734 + 265) > (9231 - 6538))) then
				v89 = v28() + v21(7 + 33, (69 - 39) + v29.RtBRemains(true));
			end
		end, "SPELL_AURA_REFRESH");
		v9:RegisterForSelfCombatEvent(function(v132, v132, v132, v132, v132, v132, v132, v132, v132, v132, v132, v133)
			if (((983 - (150 + 370)) < (1883 - (74 + 1208))) and (v133 == (776032 - 460524))) then
				v89 = v28();
			end
		end, "SPELL_AURA_REMOVED");
	end
	do
		local v91 = {CrimsonTempest={},Garrote={},Rupture={}};
		v29.Exsanguinated = function(v134, v135)
			local v136 = v134:GUID();
			if (not v136 or ((10353 - 8170) < (489 + 198))) then
				return false;
			end
			local v137 = v135:ID();
			if (((4939 - (14 + 376)) == (7889 - 3340)) and (v137 == (78561 + 42850))) then
				return v91.CrimsonTempest[v136] or false;
			elseif (((4105 + 567) == (4456 + 216)) and (v137 == (2059 - 1356))) then
				return v91.Garrote[v136] or false;
			elseif ((v137 == (1462 + 481)) or ((3746 - (23 + 55)) < (936 - 541))) then
				return v91.Rupture[v136] or false;
			end
			return false;
		end;
		v29.WillLoseExsanguinate = function(v138, v139)
			if (v29.Exsanguinated(v138, v139) or ((2780 + 1386) == (409 + 46))) then
				return true;
			end
			return false;
		end;
		v29.ExsanguinatedRate = function(v140, v141)
			if (v29.Exsanguinated(v140, v141) or ((6897 - 2448) == (838 + 1825))) then
				return 903 - (652 + 249);
			end
			return 2 - 1;
		end;
		v9:RegisterForSelfCombatEvent(function(v142, v142, v142, v142, v142, v142, v142, v143, v142, v142, v142, v144)
			if ((v144 == (202674 - (708 + 1160))) or ((11609 - 7332) < (5449 - 2460))) then
				for v208, v209 in v22(v91) do
					for v217, v218 in v22(v209) do
						if ((v217 == v143) or ((897 - (10 + 17)) >= (932 + 3217))) then
							v209[v217] = true;
						end
					end
				end
			end
		end, "SPELL_CAST_SUCCESS");
		v9:RegisterForSelfCombatEvent(function(v145, v145, v145, v145, v145, v145, v145, v146, v145, v145, v145, v147)
			if (((3944 - (1400 + 332)) < (6105 - 2922)) and (v147 == (123319 - (242 + 1666)))) then
				v91.CrimsonTempest[v146] = false;
			elseif (((1989 + 2657) > (1097 + 1895)) and (v147 == (600 + 103))) then
				v91.Garrote[v146] = false;
			elseif (((2374 - (850 + 90)) < (5439 - 2333)) and (v147 == (3333 - (360 + 1030)))) then
				v91.Rupture[v146] = false;
			end
		end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
		v9:RegisterForSelfCombatEvent(function(v148, v148, v148, v148, v148, v148, v148, v149, v148, v148, v148, v150)
			if (((696 + 90) < (8531 - 5508)) and (v150 == (167042 - 45631))) then
				if ((v91.CrimsonTempest[v149] ~= nil) or ((4103 - (909 + 752)) < (1297 - (109 + 1114)))) then
					v91.CrimsonTempest[v149] = nil;
				end
			elseif (((8302 - 3767) == (1766 + 2769)) and (v150 == (945 - (6 + 236)))) then
				if ((v91.Garrote[v149] ~= nil) or ((1896 + 1113) <= (1695 + 410))) then
					v91.Garrote[v149] = nil;
				end
			elseif (((4315 - 2485) < (6408 - 2739)) and (v150 == (3076 - (1076 + 57)))) then
				if ((v91.Rupture[v149] ~= nil) or ((236 + 1194) >= (4301 - (579 + 110)))) then
					v91.Rupture[v149] = nil;
				end
			end
		end, "SPELL_AURA_REMOVED");
		v9:RegisterForCombatEvent(function(v151, v151, v151, v151, v151, v151, v151, v152)
			local v153 = 0 + 0;
			while true do
				if (((2373 + 310) >= (1306 + 1154)) and (v153 == (408 - (174 + 233)))) then
					if ((v91.Rupture[v152] ~= nil) or ((5039 - 3235) >= (5748 - 2473))) then
						v91.Rupture[v152] = nil;
					end
					break;
				end
				if ((v153 == (0 + 0)) or ((2591 - (663 + 511)) > (3238 + 391))) then
					if (((1042 + 3753) > (1239 - 837)) and (v91.CrimsonTempest[v152] ~= nil)) then
						v91.CrimsonTempest[v152] = nil;
					end
					if (((2915 + 1898) > (8392 - 4827)) and (v91.Garrote[v152] ~= nil)) then
						v91.Garrote[v152] = nil;
					end
					v153 = 2 - 1;
				end
			end
		end, "UNIT_DIED", "UNIT_DESTROYED");
	end
	do
		local v95 = 0 + 0;
		local v96;
		local v97;
		local v98;
		while true do
			if (((7613 - 3701) == (2788 + 1124)) and (v95 == (1 + 0))) then
				v98 = v28();
				v29.FanTheHammerCP = function()
					local v210 = 722 - (478 + 244);
					while true do
						if (((3338 - (440 + 77)) <= (2194 + 2630)) and (v210 == (0 - 0))) then
							if (((3294 - (655 + 901)) <= (408 + 1787)) and ((v28() - v98) < (0.5 + 0)) and (v97 > (0 + 0))) then
								if (((165 - 124) <= (4463 - (695 + 750))) and (v97 > v12:ComboPoints())) then
									return v97;
								else
									v97 = 0 - 0;
								end
							end
							return 0 - 0;
						end
					end
				end;
				v95 = 7 - 5;
			end
			if (((2496 - (285 + 66)) <= (9566 - 5462)) and (v95 == (1312 - (682 + 628)))) then
				v9:RegisterForSelfCombatEvent(function(v211, v211, v211, v211, v211, v211, v211, v211, v211, v211, v211, v212, v211, v211, v213, v214)
					if (((434 + 2255) < (5144 - (176 + 123))) and (v212 == (77703 + 108060))) then
						if (((v28() - v98) > (0.5 + 0)) or ((2591 - (239 + 30)) > (713 + 1909))) then
							v97 = v21(v29.CPMaxSpend(), v12:ComboPoints() + v213 + (v24(0 + 0, v213 - (1 - 0)) * v21(5 - 3, v12:BuffStack(v96) - (316 - (306 + 9)))));
							v98 = v28();
						end
					end
				end, "SPELL_ENERGIZE");
				break;
			end
			if ((v95 == (0 - 0)) or ((789 + 3745) == (1278 + 804))) then
				v96 = v15(94164 + 101463);
				v97 = 0 - 0;
				v95 = 1376 - (1140 + 235);
			end
		end
	end
	do
		local v99, v100 = 0 + 0, 0 + 0;
		local v101 = v15(71327 + 206598);
		v29.TimeToNextTornado = function()
			local v154 = 52 - (33 + 19);
			local v155;
			while true do
				if ((v154 == (1 + 0)) or ((4708 - 3137) > (823 + 1044))) then
					if ((v28() == v99) or ((5204 - 2550) >= (2810 + 186))) then
						return 689 - (586 + 103);
					elseif (((363 + 3615) > (6477 - 4373)) and ((v28() - v99) < (1488.1 - (1309 + 179))) and (v155 < (0.25 - 0))) then
						return 1 + 0;
					elseif (((8043 - 5048) > (1164 + 377)) and ((v155 > (0.9 - 0)) or (v155 == (0 - 0))) and ((v28() - v99) > (609.75 - (295 + 314)))) then
						return 0.1 - 0;
					end
					return v155;
				end
				if (((5211 - (1300 + 662)) > (2992 - 2039)) and (v154 == (1755 - (1178 + 577)))) then
					if (not v12:BuffUp(v101, nil, true) or ((1700 + 1573) > (13518 - 8945))) then
						return 1405 - (851 + 554);
					end
					v155 = v12:BuffRemains(v101, nil, true) % (1 + 0);
					v154 = 2 - 1;
				end
			end
		end;
		v9:RegisterForSelfCombatEvent(function(v156, v156, v156, v156, v156, v156, v156, v156, v156, v156, v156, v157)
			local v158 = 0 - 0;
			while true do
				if ((v158 == (302 - (115 + 187))) or ((2414 + 737) < (1216 + 68))) then
					if ((v157 == (838355 - 625612)) or ((3011 - (160 + 1001)) == (1338 + 191))) then
						v99 = v28();
					elseif (((567 + 254) < (4345 - 2222)) and (v157 == (198193 - (237 + 121)))) then
						v100 = v28();
					end
					if (((1799 - (525 + 372)) < (4407 - 2082)) and (v100 == v99)) then
						v99 = 0 - 0;
					end
					break;
				end
			end
		end, "SPELL_CAST_SUCCESS");
	end
	do
		local v103 = {Counter=(142 - (96 + 46)),LastMH=(777 - (643 + 134)),LastOH=(0 + 0)};
		v29.TimeToSht = function(v159)
			local v160 = 0 - 0;
			local v161;
			local v162;
			local v163;
			local v164;
			local v165;
			local v166;
			while true do
				if (((3185 - 2327) <= (2841 + 121)) and (v160 == (1 - 0))) then
					v163 = v24(v103.LastMH + v161, v28());
					v164 = v24(v103.LastOH + v162, v28());
					v160 = 3 - 1;
				end
				if ((v160 == (721 - (316 + 403))) or ((2623 + 1323) < (3541 - 2253))) then
					v165 = {};
					for v221 = 0 + 0, 4 - 2 do
						local v222 = 0 + 0;
						while true do
							if ((v222 == (0 + 0)) or ((11233 - 7991) == (2707 - 2140))) then
								v26(v165, v163 + (v221 * v161));
								v26(v165, v164 + (v221 * v162));
								break;
							end
						end
					end
					v160 = 5 - 2;
				end
				if ((v160 == (1 + 3)) or ((1667 - 820) >= (62 + 1201))) then
					return v165[v166] - v28();
				end
				if ((v160 == (0 - 0)) or ((2270 - (12 + 5)) == (7189 - 5338))) then
					if ((v103.Counter >= v159) or ((4452 - 2365) > (5041 - 2669))) then
						return 0 - 0;
					end
					v161, v162 = v27("player");
					v160 = 1 + 0;
				end
				if ((v160 == (1976 - (1656 + 317))) or ((3961 + 484) < (3325 + 824))) then
					table.sort(v165);
					v166 = v21(13 - 8, v24(4 - 3, v159 - v103.Counter));
					v160 = 358 - (5 + 349);
				end
			end
		end;
		v9:RegisterForSelfCombatEvent(function()
			v103.Counter = 0 - 0;
			v103.LastMH = v28();
			v103.LastOH = v28();
		end, "PLAYER_ENTERING_WORLD");
		v9:RegisterForSelfCombatEvent(function(v170, v170, v170, v170, v170, v170, v170, v170, v170, v170, v170, v171)
			if ((v171 == (198182 - (266 + 1005))) or ((1199 + 619) == (289 - 204))) then
				v103.Counter = 0 - 0;
			end
		end, "SPELL_ENERGIZE");
		v9:RegisterForSelfCombatEvent(function(v172, v172, v172, v172, v172, v172, v172, v172, v172, v172, v172, v172, v172, v172, v172, v172, v172, v172, v172, v172, v172, v172, v172, v173)
			local v174 = 1696 - (561 + 1135);
			while true do
				if (((820 - 190) < (6991 - 4864)) and (v174 == (1066 - (507 + 559)))) then
					v103.Counter = v103.Counter + (2 - 1);
					if (v173 or ((5993 - 4055) == (2902 - (212 + 176)))) then
						v103.LastOH = v28();
					else
						v103.LastMH = v28();
					end
					break;
				end
			end
		end, "SWING_DAMAGE");
		v9:RegisterForSelfCombatEvent(function(v175, v175, v175, v175, v175, v175, v175, v175, v175, v175, v175, v175, v175, v175, v175, v176)
			if (((5160 - (250 + 655)) >= (149 - 94)) and v176) then
				v103.LastOH = v28();
			else
				v103.LastMH = v28();
			end
		end, "SWING_MISSED");
	end
	do
		local v105 = v12:CritChancePct();
		local v106 = 0 - 0;
		local function v107()
			if (((4691 - 1692) > (3112 - (1869 + 87))) and not v12:AffectingCombat()) then
				local v202 = 0 - 0;
				while true do
					if (((4251 - (484 + 1417)) > (2475 - 1320)) and (v202 == (0 - 0))) then
						v105 = v12:CritChancePct();
						v9.Debug("Base Crit Set to: " .. v105);
						break;
					end
				end
			end
			if (((4802 - (48 + 725)) <= (7927 - 3074)) and ((v106 == nil) or (v106 < (0 - 0)))) then
				v106 = 0 + 0;
			else
				v106 = v106 - (2 - 1);
			end
			if ((v106 > (0 + 0)) or ((151 + 365) > (4287 - (152 + 701)))) then
				v23.After(1314 - (430 + 881), v107);
			end
		end
		v9:RegisterForEvent(function()
			if (((1550 + 2496) >= (3928 - (557 + 338))) and (v106 == (0 + 0))) then
				v23.After(8 - 5, v107);
				v106 = 6 - 4;
			end
		end, "PLAYER_EQUIPMENT_CHANGED");
		v29.BaseAttackCrit = function()
			return v105;
		end;
	end
	do
		local v109 = 0 - 0;
		local v110;
		local v111;
		local v112;
		local v113;
		while true do
			if ((v109 == (0 - 0)) or ((3520 - (499 + 302)) <= (2313 - (39 + 827)))) then
				v110 = v15.Rogue.Assassination;
				v111 = v15.Rogue.Subtlety;
				v109 = 2 - 1;
			end
			if ((v109 == (6 - 3)) or ((16419 - 12285) < (6026 - 2100))) then
				v110.Rupture:RegisterPMultiplier(v112, {v111.FinalityRuptureBuff,(1.3 + 0)});
				v110.Garrote:RegisterPMultiplier(v112, v113);
				break;
			end
			if ((v109 == (2 - 0)) or ((268 - (103 + 1)) >= (3339 - (475 + 79)))) then
				v113 = nil;
				function v113()
					local v216 = 0 - 0;
					while true do
						if ((v216 == (0 - 0)) or ((68 + 457) == (1857 + 252))) then
							if (((1536 - (1395 + 108)) == (95 - 62)) and v110.ImprovedGarrote:IsAvailable() and (v12:BuffUp(v110.ImprovedGarroteAura, nil, true) or v12:BuffUp(v110.ImprovedGarroteBuff, nil, true) or v12:BuffUp(v110.SepsisBuff, nil, true))) then
								return 1205.5 - (7 + 1197);
							end
							return 1 + 0;
						end
					end
				end
				v109 = 2 + 1;
			end
			if (((3373 - (27 + 292)) <= (11765 - 7750)) and (v109 == (1 - 0))) then
				v112 = nil;
				function v112()
					if (((7846 - 5975) < (6669 - 3287)) and v110.Nightstalker:IsAvailable() and v12:StealthUp(true, false, true)) then
						return (1 - 0) + ((139.05 - (43 + 96)) * v110.Nightstalker:TalentRank());
					end
					return 4 - 3;
				end
				v109 = 3 - 1;
			end
		end
	end
end;
return v0["Epix_Rogue_Rogue.lua"]();

