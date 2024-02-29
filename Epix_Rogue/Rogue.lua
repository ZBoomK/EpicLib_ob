local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((4358 - (839 + 194)) > (4698 - (322 + 905)))) then
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
	if (((3844 - (602 + 9)) == (4422 - (449 + 740))) and not v15.Rogue) then
		v15.Rogue = {};
	end
	v15.Rogue.Commons = {Sanguine=v15(227382 - (826 + 46), nil, 948 - (245 + 702)),AncestralCall=v15(868160 - 593422, nil, 1 + 1),ArcanePulse=v15(262262 - (260 + 1638), nil, 443 - (382 + 58)),ArcaneTorrent=v15(80349 - 55303, nil, 4 + 0),BagofTricks=v15(645659 - 333248, nil, 14 - 9),Berserking=v15(27502 - (902 + 303), nil, 12 - 6),BloodFury=v15(49547 - 28975, nil, 1 + 6),Fireblood=v15(266911 - (1121 + 569), nil, 222 - (22 + 192)),LightsJudgment=v15(256330 - (483 + 200), nil, 1472 - (1404 + 59)),Shadowmeld=v15(161423 - 102439, nil, 13 - 3),CloakofShadows=v15(31989 - (468 + 297), nil, 573 - (334 + 228)),CrimsonVial=v15(625051 - 439740, nil, 27 - 15),Evasion=v15(9569 - 4292, nil, 4 + 9),Feint=v15(2202 - (141 + 95), nil, 14 + 0),Blind=v15(5389 - 3295, nil, 36 - 21),CheapShot=v15(430 + 1403, nil, 43 - 27),Kick=v15(1242 + 524, nil, 9 + 8),KidneyShot=v15(574 - 166, nil, 11 + 7),Sap=v15(6933 - (92 + 71), nil, 10 + 9),Shiv=v15(9983 - 4045, nil, 785 - (574 + 191)),SliceandDice=v15(260242 + 55254, nil, 52 - 31),Shadowstep=v15(18672 + 17882, nil, 871 - (254 + 595)),Sprint=v15(3109 - (55 + 71), nil, 29 - 6),TricksoftheTrade=v15(59724 - (573 + 1217), nil, 66 - 42),CripplingPoison=v15(260 + 3148, nil, 40 - 15),DeadlyPoison=v15(3762 - (714 + 225), nil, 75 - 49),InstantPoison=v15(439975 - 124391, nil, 3 + 24),AmplifyingPoison=v15(552630 - 170966, nil, 834 - (118 + 688)),NumbingPoison=v15(5809 - (25 + 23), nil, 6 + 23),WoundPoison=v15(10565 - (927 + 959), nil, 101 - 71),AtrophicPoison=v15(382369 - (16 + 716), nil, 59 - 28),AcrobaticStrikes=v15(197021 - (11 + 86), nil, 77 - 45),Alacrity=v15(193824 - (175 + 110), nil, 82 - 49),ColdBlood=v15(1885327 - 1503082, nil, 1830 - (503 + 1293)),DeeperStratagem=v15(540493 - 346962),EchoingReprimand=v15(278863 + 106753, nil, 1097 - (810 + 251)),EchoingReprimand2=v15(224542 + 99016, nil, 12 + 25),EchoingReprimand3=v15(291674 + 31885, nil, 571 - (43 + 490)),EchoingReprimand4=v15(324293 - (711 + 22), nil, 150 - 111),EchoingReprimand5=v15(355697 - (240 + 619), nil, 10 + 30),FindWeakness=v15(144790 - 53767, nil, 3 + 38),FindWeaknessDebuff=v15(317964 - (1344 + 400), nil, 447 - (255 + 150)),ImprovedAmbush=v15(300593 + 81027, nil, 24 + 19),MarkedforDeath=v15(587988 - 450369, nil, 141 - 97),Nightstalker=v15(15801 - (404 + 1335), nil, 451 - (183 + 223)),ResoundingClarity=v15(464381 - 82759, nil, 31 + 15),SealFate=v15(5107 + 9083, nil, 384 - (10 + 327)),Sepsis=v15(268394 + 117014, nil, 386 - (118 + 220)),SepsisBuff=v15(125284 + 250655, nil, 498 - (108 + 341)),ShadowDance=v15(83231 + 102082, nil, 211 - 161),ShadowDanceTalent=v15(396423 - (711 + 782), nil, 97 - 46),ShadowDanceBuff=v15(185891 - (270 + 199)),Subterfuge=v15(35080 + 73128, nil, 1872 - (580 + 1239)),SubterfugeBuff=v15(342440 - 227248, nil, 52 + 2),ThistleTea=v15(13710 + 367913, nil, 140 + 180),Vigor=v15(39119 - 24136),Stealth=v15(1109 + 675, nil, 1224 - (645 + 522)),Stealth2=v15(116981 - (1010 + 780), nil, 58 + 0),Vanish=v15(8841 - 6985, nil, 172 - 113),VanishBuff=v15(13163 - (1045 + 791), nil, 151 - 91),VanishBuff2=v15(175893 - 60700, nil, 566 - (351 + 154)),PoolEnergy=v15(1001484 - (1281 + 293), nil, 328 - (28 + 238)),Gouge=v15(3967 - 2191, nil, 1695 - (1381 + 178))};
	v15.Rogue.Assassination = v18(v15.Rogue.Commons, {Ambush=v15(8138 + 538, nil, 51 + 12),AmbushOverride=v15(183430 + 246593),AmplifyingPoisonDebuff=v15(1321788 - 938374, nil, 34 + 30),AmplifyingPoisonDebuffDeathmark=v15(394798 - (381 + 89), nil, 58 + 7),CripplingPoisonDebuff=v15(2306 + 1103, nil, 112 - 46),DeadlyPoisonDebuff=v15(3974 - (1074 + 82), nil, 146 - 79),DeadlyPoisonDebuffDeathmark=v15(396108 - (214 + 1570), nil, 1523 - (990 + 465)),Envenom=v15(13458 + 19187, nil, 31 + 38),FanofKnives=v15(50298 + 1425, nil, 275 - 205),Garrote=v15(2429 - (1668 + 58), nil, 697 - (512 + 114)),GarroteDeathmark=v15(940736 - 579906, nil, 148 - 76),Mutilate=v15(4624 - 3295, nil, 34 + 39),PoisonedKnife=v15(34737 + 150828, nil, 65 + 9),Rupture=v15(6553 - 4610, nil, 2069 - (109 + 1885)),RuptureDeathmark=v15(362295 - (1269 + 200), nil, 145 - 69),WoundPoisonDebuff=v15(9495 - (98 + 717), nil, 903 - (802 + 24)),ArterialPrecision=v15(691163 - 290380, nil, 97 - 19),AtrophicPoisonDebuff=v15(57949 + 334439, nil, 61 + 18),BlindsideBuff=v15(19900 + 101253, nil, 18 + 62),CausticSpatter=v15(1173909 - 751934),CausticSpatterDebuff=v15(1407189 - 985213),CrimsonTempest=v15(43425 + 77986, nil, 33 + 48),CutToTheChase=v15(42618 + 9049, nil, 60 + 22),DashingScoundrel=v15(178256 + 203541, nil, 1516 - (797 + 636)),Deathmark=v15(1748872 - 1388678, nil, 1703 - (1427 + 192)),Doomblade=v15(132247 + 249426, nil, 197 - 112),DragonTemperedBlades=v15(343188 + 38613, nil, 39 + 47),Elusiveness=v15(79334 - (192 + 134)),Exsanguinate=v15(202082 - (316 + 960), nil, 49 + 39),ImprovedGarrote=v15(294512 + 87120, nil, 83 + 6),ImprovedGarroteBuff=v15(1500151 - 1107750, nil, 641 - (83 + 468)),ImprovedGarroteAura=v15(394209 - (1202 + 604), nil, 424 - 333),IndiscriminateCarnage=v15(635440 - 253638, nil, 254 - 162),IndiscriminateCarnageAura=v15(386079 - (45 + 280)),IndiscriminateCarnageBuff=v15(372321 + 13426),InternalBleeding=v15(135378 + 19575, nil, 34 + 59),Kingsbane=v15(213394 + 172233, nil, 17 + 77),LightweightShiv=v15(731418 - 336435),MasterAssassin=v15(257900 - (340 + 1571), nil, 38 + 57),MasterAssassinBuff=v15(258507 - (1733 + 39), nil, 263 - 167),PreyontheWeak=v15(132545 - (125 + 909), nil, 2045 - (1096 + 852)),PreyontheWeakDebuff=v15(114795 + 141114, nil, 139 - 41),SerratedBoneSpike=v15(373836 + 11588, nil, 611 - (409 + 103)),SerratedBoneSpikeDebuff=v15(394272 - (46 + 190), nil, 195 - (51 + 44)),ShivDebuff=v15(90114 + 229390, nil, 1418 - (1114 + 203)),VenomRush=v15(152878 - (228 + 498), nil, 23 + 79),ScentOfBlood=v15(210929 + 170870, nil, 1059 - (174 + 489)),ScentOfBloodBuff=v15(1026694 - 632614),ShroudedSuffocation=v15(387383 - (830 + 1075))});
	v15.Rogue.Outlaw = v18(v15.Rogue.Commons, {AdrenalineRush=v15(14274 - (303 + 221), nil, 1372 - (231 + 1038)),Ambush=v15(7230 + 1446, nil, 1266 - (171 + 991)),AmbushOverride=v15(1772213 - 1342190),BetweentheEyes=v15(846754 - 531413, nil, 262 - 157),BladeFlurry=v15(11107 + 2770, nil, 371 - 265),Dispatch=v15(6052 - 3954, nil, 171 - 64),Elusiveness=v15(244236 - 165228),Opportunity=v15(196875 - (111 + 1137)),PistolShot=v15(185921 - (91 + 67), nil, 327 - 217),RolltheBones=v15(78721 + 236787, nil, 634 - (423 + 100)),SinisterStrike=v15(1357 + 191958, nil, 309 - 197),Audacity=v15(199026 + 182819, nil, 884 - (326 + 445)),AudacityBuff=v15(1685672 - 1299402, nil, 253 - 139),BladeRush=v15(634622 - 362745, nil, 826 - (530 + 181)),CountTheOdds=v15(382863 - (614 + 267), nil, 148 - (19 + 13)),Dreadblades=v15(558502 - 215360, nil, 272 - 155),FanTheHammer=v15(1090783 - 708937, nil, 31 + 87),GhostlyStrike=v15(346348 - 149411, nil, 246 - 127),GreenskinsWickers=v15(388635 - (1293 + 519), nil, 244 - 124),GreenskinsWickersBuff=v15(1029056 - 634925, nil, 231 - 110),HiddenOpportunity=v15(1652749 - 1269468, nil, 287 - 165),ImprovedAdrenalineRush=v15(209432 + 185990, nil, 26 + 97),ImprovedBetweenTheEyes=v15(547150 - 311666, nil, 29 + 95),KeepItRolling=v15(126900 + 255089, nil, 79 + 46),KillingSpree=v15(52786 - (709 + 387), nil, 1984 - (673 + 1185)),LoadedDice=v15(742929 - 486759, nil, 407 - 280),LoadedDiceBuff=v15(421488 - 165317, nil, 92 + 36),PreyontheWeak=v15(98265 + 33246, nil, 173 - 44),PreyontheWeakDebuff=v15(62852 + 193057, nil, 259 - 129),QuickDraw=v15(386594 - 189656, nil, 2011 - (446 + 1434)),SummarilyDispatched=v15(383273 - (1040 + 243), nil, 393 - 261),SwiftSlasher=v15(383835 - (559 + 1288), nil, 2064 - (609 + 1322)),TakeEmBySurpriseBuff=v15(386361 - (13 + 441), nil, 500 - 366),Weaponmaster=v15(525792 - 325059, nil, 672 - 537),UnderhandedUpperhand=v15(15789 + 408255),DeftManeuvers=v15(1386905 - 1005027),Crackshot=v15(150489 + 273214),Broadside=v15(84726 + 108630, nil, 406 - 269),BuriedTreasure=v15(109223 + 90377, nil, 253 - 115),GrandMelee=v15(127832 + 65526, nil, 78 + 61),RuthlessPrecision=v15(138929 + 54428, nil, 118 + 22),SkullandCrossbones=v15(195289 + 4314, nil, 574 - (153 + 280)),TrueBearing=v15(558343 - 364984, nil, 128 + 14),ViciousFollowup=v15(155915 + 238964, nil, 75 + 68)});
	v15.Rogue.Subtlety = v18(v15.Rogue.Commons, {Backstab=v15(49 + 4, nil, 105 + 39),BlackPowder=v15(486012 - 166837, nil, 90 + 55),Elusiveness=v15(79675 - (89 + 578)),Eviscerate=v15(140601 + 56218, nil, 305 - 158),Rupture=v15(2992 - (572 + 477), nil, 20 + 128),ShadowBlades=v15(72898 + 48573, nil, 18 + 131),Shadowstrike=v15(185524 - (84 + 2), nil, 247 - 97),ShurikenStorm=v15(142524 + 55311, nil, 993 - (497 + 345)),ShurikenToss=v15(2917 + 111097, nil, 26 + 126),SymbolsofDeath=v15(213616 - (605 + 728), nil, 110 + 43),DanseMacabre=v15(850467 - 467939, nil, 8 + 146),DanseMacabreBuff=v15(1456595 - 1062626, nil, 140 + 15),DeeperDaggers=v15(1059814 - 677297, nil, 118 + 38),DeeperDaggersBuff=v15(383894 - (457 + 32), nil, 67 + 90),DarkBrew=v15(383906 - (832 + 570), nil, 149 + 9),DarkShadow=v15(64070 + 181617, nil, 562 - 403),EnvelopingShadows=v15(114696 + 123408, nil, 956 - (588 + 208)),Finality=v15(1030992 - 648467, nil, 1961 - (884 + 916)),FinalityBlackPowderBuff=v15(808012 - 422064, nil, 94 + 68),FinalityEviscerateBuff=v15(386602 - (232 + 421), nil, 2052 - (1569 + 320)),FinalityRuptureBuff=v15(94691 + 291260, nil, 32 + 132),Flagellation=v15(1296135 - 911504, nil, 770 - (316 + 289)),FlagellationPersistBuff=v15(1033366 - 638608, nil, 8 + 158),Gloomblade=v15(202211 - (666 + 787), nil, 592 - (360 + 65)),GoremawsBite=v15(398678 + 27913, nil, 443 - (79 + 175)),ImprovedShadowDance=v15(621228 - 227256, nil, 132 + 36),ImprovedShurikenStorm=v15(980738 - 660787, nil, 325 - 156),InvigoratingShadowdust=v15(383422 - (503 + 396)),LingeringShadow=v15(382705 - (92 + 89), nil, 329 - 159),LingeringShadowBuff=v15(197936 + 188024, nil, 102 + 69),MasterofShadows=v15(771385 - 574409, nil, 24 + 148),PerforatedVeins=v15(872190 - 489672, nil, 151 + 22),PerforatedVeinsBuff=v15(188309 + 205945, nil, 529 - 355),PreyontheWeak=v15(16414 + 115097, nil, 266 - 91),PreyontheWeakDebuff=v15(257153 - (485 + 759), nil, 407 - 231),Premeditation=v15(344349 - (442 + 747), nil, 1312 - (832 + 303)),PremeditationBuff=v15(344119 - (88 + 858), nil, 55 + 123),SecretStratagem=v15(326340 + 67980, nil, 8 + 171),SecretTechnique=v15(281508 - (766 + 23), nil, 888 - 708),Shadowcraft=v15(583434 - 156840),ShadowFocus=v15(285098 - 176889, nil, 614 - 433),ShurikenTornado=v15(278998 - (1036 + 37), nil, 130 + 52),SilentStorm=v15(751150 - 365428, nil, 144 + 39),SilentStormBuff=v15(387202 - (641 + 839), nil, 1097 - (910 + 3)),TheFirstDance=v15(975119 - 592614, nil, 1869 - (1466 + 218)),TheRotten=v15(175570 + 206445, nil, 1334 - (556 + 592)),TheRottenBuff=v15(140177 + 254026, nil, 995 - (329 + 479)),Weaponmaster=v15(194391 - (174 + 680), nil, 645 - 457)});
	if (((3034 - 1570) <= (3126 + 1251)) and not v17.Rogue) then
		v17.Rogue = {};
	end
	v17.Rogue.Commons = {AlgetharPuzzleBox=v17(194440 - (396 + 343), {(1490 - (29 + 1448)),(52 - 38)}),ManicGrieftorch=v17(907248 - 712940, {(1540 - (389 + 1138)),(14 + 0)}),WindscarWhetstone=v17(76241 + 61245, {(1558 - (320 + 1225)),(9 + 5)}),Healthstone=v17(6976 - (157 + 1307)),RefreshingHealingPotion=v17(193239 - (821 + 1038)),DreamwalkersHealingPotion=v17(516520 - 309497)};
	v17.Rogue.Assassination = v18(v17.Rogue.Commons, {AlgetharPuzzleBox=v17(21184 + 172517, {(5 + 8),(1040 - (834 + 192))}),AshesoftheEmbersoul=v17(13171 + 193996, {(1 + 12),(318 - (300 + 4))}),WitherbarksBranch=v17(29378 + 80621, {(375 - (112 + 250)),(34 - 20)})});
	v17.Rogue.Outlaw = v18(v17.Rogue.Commons, {ManicGrieftorch=v17(111316 + 82992, {(10 + 3),(11 + 3)}),WindscarWhetstone=v17(138900 - (1001 + 413), {(895 - (244 + 638)),(41 - 27)}),BeaconToTheBeyond=v17(204565 - (512 + 90), {(730 - (373 + 344)),(4 + 10)}),DragonfireBombDispenser=v17(534429 - 331819, {(1112 - (35 + 1064)),(29 - 15)})});
	v17.Rogue.Subtlety = v18(v17.Rogue.Commons, {ManicGrieftorch=v17(776 + 193532, {(1272 - (233 + 1026)),(8 + 6)}),StormEatersBoon=v17(189788 + 4514, {(1 + 12),(3 + 11)}),BeaconToTheBeyond=v17(20511 + 183452, {(310 - (36 + 261)),(1382 - (34 + 1334))}),AshesoftheEmbersoul=v17(79641 + 127526, {(1296 - (1035 + 248)),(8 + 6)}),WitherbarksBranch=v17(110318 - (134 + 185), {(698 - (314 + 371)),(982 - (478 + 490))}),BandolierOfTwistedBlades=v17(109743 + 97422, {(41 - 28),(1354 - (1093 + 247))}),Mirror=v17(184463 + 23118, {(51 - 38),(39 - 25)})});
	if (((6757 - 4068) < (1681 + 3042)) and not v20.Rogue) then
		v20.Rogue = {};
	end
	v20.Rogue.Commons = {Healthstone=v20(80 - 59),BlindMouseover=v20(30 - 21),CheapShotMouseover=v20(8 + 2),KickMouseover=v20(28 - 17),KidneyShotMouseover=v20(700 - (364 + 324)),TricksoftheTradeFocus=v20(35 - 22),WindscarWhetstone=v20(62 - 36),RefreshingHealingPotion=v20(10 + 19)};
	v20.Rogue.Outlaw = v18(v20.Rogue.Commons, {Dispatch=v20(58 - 44),PistolShotMouseover=v20(24 - 9),SinisterStrikeMouseover=v20(81 - 54)});
	v20.Rogue.Assassination = v18(v20.Rogue.Commons, {GarroteMouseOver=v20(1296 - (1249 + 19))});
	v20.Rogue.Subtlety = v18(v20.Rogue.Commons, {SecretTechnique=v20(15 + 1),ShadowDance=v20(65 - 48),ShadowDanceSymbol=v20(1112 - (686 + 400)),VanishShadowstrike=v20(15 + 3),ShurikenStormSD=v20(248 - (73 + 156)),ShurikenStormVanish=v20(1 + 19),GloombladeSD=v20(833 - (721 + 90)),GloombladeVanish=v20(1 + 22),BackstabMouseover=v20(77 - 53),RuptureMouseover=v20(495 - (224 + 246))});
	v29.StealthSpell = function()
		return (v15.Rogue.Commons.Subterfuge:IsAvailable() and v15.Rogue.Commons.Stealth2) or v15.Rogue.Commons.Stealth;
	end;
	v29.VanishBuffSpell = function()
		return (v15.Rogue.Commons.Subterfuge:IsAvailable() and v15.Rogue.Commons.VanishBuff2) or v15.Rogue.Commons.VanishBuff;
	end;
	v29.Stealth = function(v49, v50)
		local v51 = 0 - 0;
		while true do
			if (((7615 - 3479) >= (435 + 1962)) and (v51 == (0 + 0))) then
				if ((EpicSettings.Settings['StealthOOC'] and (v15.Rogue.Commons.Stealth:IsCastable() or v15.Rogue.Commons.Stealth2:IsCastable()) and v12:StealthDown()) or ((3184 + 1150) == (8439 - 4194))) then
					if (v9.Press(v49, nil) or ((14229 - 9953) <= (3544 - (203 + 310)))) then
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
			local v115 = EpicSettings.Settings['CrimsonVialHP'] or (1993 - (1238 + 755));
			if ((v53:IsCastable() and v53:IsReady() and (v12:HealthPercentage() <= v115)) or ((335 + 4447) <= (2733 - (709 + 825)))) then
				if (v9.Cast(v53, nil) or ((8963 - 4099) < (2770 - 868))) then
					return "Cast Crimson Vial (Defensives)";
				end
			end
			return false;
		end;
	end
	do
		local v55 = v15.Rogue.Commons;
		local v56 = v55.Feint;
		v29.Feint = function()
			local v116 = 864 - (196 + 668);
			local v117;
			while true do
				if (((19105 - 14266) >= (7664 - 3964)) and (v116 == (833 - (171 + 662)))) then
					v117 = EpicSettings.Settings['FeintHP'] or (93 - (4 + 89));
					if ((v56:IsCastable() and v12:BuffDown(v56) and (v12:HealthPercentage() <= v117)) or ((3767 - 2692) > (699 + 1219))) then
						if (((1739 - 1343) <= (1492 + 2312)) and v9.Cast(v56, nil)) then
							return "Cast Feint (Defensives)";
						end
					end
					break;
				end
			end
		end;
	end
	do
		local v58 = 1486 - (35 + 1451);
		local v59;
		local v60;
		local v61;
		while true do
			if (((1454 - (28 + 1425)) == v58) or ((6162 - (941 + 1052)) == (2098 + 89))) then
				v61 = nil;
				function v61(v173)
					if (((2920 - (822 + 692)) == (2006 - 600)) and not v12:AffectingCombat() and v12:BuffRefreshable(v173)) then
						if (((722 + 809) < (4568 - (45 + 252))) and v9.Press(v173, nil, true)) then
							return "poison";
						end
					end
				end
				v58 = 2 + 0;
			end
			if (((219 + 416) == (1545 - 910)) and (v58 == (433 - (114 + 319)))) then
				v59 = 0 - 0;
				v60 = false;
				v58 = 1 - 0;
			end
			if (((2151 + 1222) <= (5297 - 1741)) and (v58 == (3 - 1))) then
				v29.Poisons = function()
					v60 = v12:BuffUp(v15.Rogue.Commons.WoundPoison);
					if (v15.Rogue.Assassination.DragonTemperedBlades:IsAvailable() or ((5254 - (556 + 1407)) < (4486 - (741 + 465)))) then
						local v217 = 465 - (170 + 295);
						local v218;
						while true do
							if (((2311 + 2075) >= (802 + 71)) and (v217 == (0 - 0))) then
								v218 = v61((v60 and v15.Rogue.Commons.WoundPoison) or v15.Rogue.Commons.DeadlyPoison);
								if (((764 + 157) <= (707 + 395)) and v218) then
									return v218;
								end
								v217 = 1 + 0;
							end
							if (((5936 - (957 + 273)) >= (258 + 705)) and (v217 == (1 + 0))) then
								if (v15.Rogue.Commons.AmplifyingPoison:IsAvailable() or ((3658 - 2698) <= (2308 - 1432))) then
									v218 = v61(v15.Rogue.Commons.AmplifyingPoison);
									if (v218 or ((6310 - 4244) == (4614 - 3682))) then
										return v218;
									end
								else
									v218 = v61(v15.Rogue.Commons.InstantPoison);
									if (((6605 - (389 + 1391)) < (3039 + 1804)) and v218) then
										return v218;
									end
								end
								break;
							end
						end
					elseif (v60 or ((404 + 3473) >= (10328 - 5791))) then
						local v228 = 951 - (783 + 168);
						local v229;
						while true do
							if ((v228 == (0 - 0)) or ((4245 + 70) < (2037 - (309 + 2)))) then
								v229 = v61(v15.Rogue.Commons.WoundPoison);
								if (v229 or ((11297 - 7618) < (1837 - (1090 + 122)))) then
									return v229;
								end
								break;
							end
						end
					elseif ((v15.Rogue.Commons.AmplifyingPoison:IsAvailable() and v12:BuffDown(v15.Rogue.Commons.DeadlyPoison)) or ((1500 + 3125) < (2122 - 1490))) then
						local v236 = 0 + 0;
						local v237;
						while true do
							if ((v236 == (1118 - (628 + 490))) or ((15 + 68) > (4407 - 2627))) then
								v237 = v61(v15.Rogue.Commons.AmplifyingPoison);
								if (((2495 - 1949) <= (1851 - (431 + 343))) and v237) then
									return v237;
								end
								break;
							end
						end
					elseif (v15.Rogue.Commons.DeadlyPoison:IsAvailable() or ((2011 - 1015) > (12442 - 8141))) then
						local v242 = 0 + 0;
						local v243;
						while true do
							if (((521 + 3549) > (2382 - (556 + 1139))) and (v242 == (15 - (6 + 9)))) then
								v243 = v61(v15.Rogue.Commons.DeadlyPoison);
								if (v243 or ((121 + 535) >= (1706 + 1624))) then
									return v243;
								end
								break;
							end
						end
					else
						local v244 = 169 - (28 + 141);
						local v245;
						while true do
							if ((v244 == (0 + 0)) or ((3075 - 583) <= (238 + 97))) then
								v245 = v61(v15.Rogue.Commons.InstantPoison);
								if (((5639 - (486 + 831)) >= (6666 - 4104)) and v245) then
									return v245;
								end
								break;
							end
						end
					end
					if (v12:BuffDown(v15.Rogue.Commons.CripplingPoison) or ((12804 - 9167) >= (713 + 3057))) then
						if (v15.Rogue.Commons.AtrophicPoison:IsAvailable() or ((7522 - 5143) > (5841 - (668 + 595)))) then
							local v230 = 0 + 0;
							local v231;
							while true do
								if ((v230 == (0 + 0)) or ((1317 - 834) > (1033 - (23 + 267)))) then
									v231 = v61(v15.Rogue.Commons.AtrophicPoison);
									if (((4398 - (1129 + 815)) > (965 - (371 + 16))) and v231) then
										return v231;
									end
									break;
								end
							end
						elseif (((2680 - (1326 + 424)) < (8443 - 3985)) and v15.Rogue.Commons.NumbingPoison:IsAvailable()) then
							local v238 = 0 - 0;
							local v239;
							while true do
								if (((780 - (88 + 30)) <= (1743 - (720 + 51))) and (v238 == (0 - 0))) then
									v239 = v61(v15.Rogue.Commons.NumbingPoison);
									if (((6146 - (421 + 1355)) == (7209 - 2839)) and v239) then
										return v239;
									end
									break;
								end
							end
						else
							local v240 = v61(v15.Rogue.Commons.CripplingPoison);
							if (v240 or ((2340 + 2422) <= (1944 - (286 + 797)))) then
								return v240;
							end
						end
					else
						local v219 = v61(v15.Rogue.Commons.CripplingPoison);
						if (v219 or ((5161 - 3749) == (7062 - 2798))) then
							return v219;
						end
					end
				end;
				break;
			end
		end
	end
	v29.MfDSniping = function(v62)
		if (v62:IsCastable() or ((3607 - (397 + 42)) < (673 + 1480))) then
			local v143, v144 = nil, 860 - (24 + 776);
			local v145 = (v14:IsInRange(46 - 16) and v14:TimeToDie()) or (11896 - (222 + 563));
			for v147, v148 in v22(v12:GetEnemiesInRange(66 - 36)) do
				local v149 = 0 + 0;
				local v150;
				while true do
					if ((v149 == (190 - (23 + 167))) or ((6774 - (690 + 1108)) < (481 + 851))) then
						v150 = v148:TimeToDie();
						if (((3818 + 810) == (5476 - (40 + 808))) and not v148:IsMfDBlacklisted() and (v150 < (v12:ComboPointsDeficit() * (1.5 + 0))) and (v150 < v144)) then
							if (((v145 - v150) > (3 - 2)) or ((52 + 2) == (209 + 186))) then
								v143, v144 = v148, v150;
							else
								v143, v144 = v14, v145;
							end
						end
						break;
					end
				end
			end
			if (((45 + 37) == (653 - (47 + 524))) and v143 and (v143:GUID() ~= v13:GUID())) then
				v9.Press(v143, v62);
			end
		end
	end;
	v29.CanDoTUnit = function(v63, v64)
		return v19.CanDoTUnit(v63, v64);
	end;
	do
		local v65 = v15.Rogue.Assassination;
		local v66 = v15.Rogue.Subtlety;
		local function v67()
			if ((v65.Nightstalker:IsAvailable() and v12:StealthUp(true, false, true)) or ((378 + 203) < (770 - 488))) then
				return (1 - 0) + ((0.05 - 0) * v65.Nightstalker:TalentRank());
			end
			return 1727 - (1165 + 561);
		end
		local function v68()
			if ((v65.ImprovedGarrote:IsAvailable() and (v12:BuffUp(v65.ImprovedGarroteAura, nil, true) or v12:BuffUp(v65.ImprovedGarroteBuff, nil, true) or v12:BuffUp(v65.SepsisBuff, nil, true))) or ((137 + 4472) < (7727 - 5232))) then
				return 1.5 + 0;
			end
			return 480 - (341 + 138);
		end
		v65.Rupture:RegisterPMultiplier(v67, {v66.FinalityRuptureBuff,(327.3 - (89 + 237))});
		v65.Garrote:RegisterPMultiplier(v67, v68);
		v65.CrimsonTempest:RegisterPMultiplier(v67);
	end
	do
		local v69 = 0 - 0;
		local v70;
		local v71;
		local v72;
		while true do
			if (((2424 - 1272) == (2033 - (581 + 300))) and (v69 == (1220 - (855 + 365)))) then
				v70 = v15(459678 - 266147);
				v71 = v15(128753 + 265568);
				v69 = 1236 - (1030 + 205);
			end
			if (((1780 + 116) <= (3184 + 238)) and (v69 == (287 - (156 + 130)))) then
				v72 = v15(895971 - 501651);
				v29.CPMaxSpend = function()
					return (8 - 3) + ((v70:IsAvailable() and (1 - 0)) or (0 + 0)) + ((v71:IsAvailable() and (1 + 0)) or (69 - (10 + 59))) + ((v72:IsAvailable() and (1 + 0)) or (0 - 0));
				end;
				break;
			end
		end
	end
	v29.CPSpend = function()
		return v21(v12:ComboPoints(), v29.CPMaxSpend());
	end;
	do
		v29.AnimachargedCP = function()
			local v118 = 1163 - (671 + 492);
			while true do
				if ((v118 == (0 + 0)) or ((2205 - (369 + 846)) > (429 + 1191))) then
					if (v12:BuffUp(v15.Rogue.Commons.EchoingReprimand2) or ((749 + 128) > (6640 - (1036 + 909)))) then
						return 2 + 0;
					elseif (((4517 - 1826) >= (2054 - (11 + 192))) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand3)) then
						return 2 + 1;
					elseif (v12:BuffUp(v15.Rogue.Commons.EchoingReprimand4) or ((3160 - (135 + 40)) >= (11765 - 6909))) then
						return 3 + 1;
					elseif (((9419 - 5143) >= (1791 - 596)) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand5)) then
						return 181 - (50 + 126);
					end
					return -(2 - 1);
				end
			end
		end;
		v29.EffectiveComboPoints = function(v119)
			local v120 = 0 + 0;
			while true do
				if (((4645 - (1233 + 180)) <= (5659 - (522 + 447))) and (v120 == (1421 - (107 + 1314)))) then
					if (((v119 == (1 + 1)) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand2)) or ((v119 == (8 - 5)) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand3)) or ((v119 == (2 + 2)) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand4)) or ((v119 == (9 - 4)) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand5)) or ((3545 - 2649) >= (5056 - (716 + 1194)))) then
						return 1 + 6;
					end
					return v119;
				end
			end
		end;
	end
	do
		local v75 = 0 + 0;
		local v76;
		local v77;
		local v78;
		local v79;
		local v80;
		while true do
			if (((3564 - (74 + 429)) >= (5705 - 2747)) and (v75 == (0 + 0))) then
				v76 = v15.Rogue.Assassination.DeadlyPoisonDebuff;
				v77 = v15.Rogue.Assassination.WoundPoisonDebuff;
				v75 = 2 - 1;
			end
			if (((2255 + 932) >= (1985 - 1341)) and (v75 == (4 - 2))) then
				v80 = v15.Rogue.Assassination.AtrophicPoisonDebuff;
				v29.Poisoned = function(v174)
					return ((v174:DebuffUp(v76) or v174:DebuffUp(v78) or v174:DebuffUp(v79) or v174:DebuffUp(v77) or v174:DebuffUp(v80)) and true) or false;
				end;
				break;
			end
			if (((1077 - (279 + 154)) <= (1482 - (454 + 324))) and (v75 == (1 + 0))) then
				v78 = v15.Rogue.Assassination.AmplifyingPoisonDebuff;
				v79 = v15.Rogue.Assassination.CripplingPoisonDebuff;
				v75 = 19 - (12 + 5);
			end
		end
	end
	do
		local v81 = 0 + 0;
		local v82;
		local v83;
		local v84;
		local v85;
		local v86;
		local v87;
		while true do
			if (((2440 - 1482) > (350 + 597)) and (v81 == (1094 - (277 + 816)))) then
				v84 = v15.Rogue.Assassination.Rupture;
				v85 = v15.Rogue.Assassination.RuptureDeathmark;
				v81 = 8 - 6;
			end
			if (((5675 - (1058 + 125)) >= (498 + 2156)) and (v81 == (977 - (815 + 160)))) then
				v86 = v15.Rogue.Assassination.InternalBleeding;
				v87 = 0 - 0;
				v81 = 7 - 4;
			end
			if (((822 + 2620) >= (4393 - 2890)) and (v81 == (1898 - (41 + 1857)))) then
				v82 = v15.Rogue.Assassination.Garrote;
				v83 = v15.Rogue.Assassination.GarroteDeathmark;
				v81 = 1894 - (1222 + 671);
			end
			if (((7 - 4) == v81) or ((4556 - 1386) <= (2646 - (229 + 953)))) then
				v29.PoisonedBleeds = function()
					local v175 = 1774 - (1111 + 663);
					while true do
						if ((v175 == (1580 - (874 + 705))) or ((672 + 4125) == (2994 + 1394))) then
							return v87;
						end
						if (((1145 - 594) <= (20 + 661)) and (v175 == (679 - (642 + 37)))) then
							v87 = 0 + 0;
							for v232, v233 in v22(v12:GetEnemiesInRange(8 + 42)) do
								if (((8227 - 4950) > (861 - (233 + 221))) and v29.Poisoned(v233)) then
									local v241 = 0 - 0;
									while true do
										if (((4133 + 562) >= (2956 - (718 + 823))) and (v241 == (0 + 0))) then
											if (v233:DebuffUp(v82) or ((4017 - (266 + 539)) <= (2672 - 1728))) then
												local v246 = 1225 - (636 + 589);
												while true do
													if (((0 - 0) == v246) or ((6385 - 3289) <= (1425 + 373))) then
														v87 = v87 + 1 + 0;
														if (((4552 - (657 + 358)) == (9364 - 5827)) and v233:DebuffUp(v83)) then
															v87 = v87 + (2 - 1);
														end
														break;
													end
												end
											end
											if (((5024 - (1151 + 36)) >= (1517 + 53)) and v233:DebuffUp(v84)) then
												local v247 = 0 + 0;
												while true do
													if ((v247 == (0 - 0)) or ((4782 - (1552 + 280)) == (4646 - (64 + 770)))) then
														v87 = v87 + 1 + 0;
														if (((10721 - 5998) >= (412 + 1906)) and v233:DebuffUp(v85)) then
															v87 = v87 + (1244 - (157 + 1086));
														end
														break;
													end
												end
											end
											v241 = 1 - 0;
										end
										if ((v241 == (4 - 3)) or ((3109 - 1082) > (3892 - 1040))) then
											if (v233:DebuffUp(v86) or ((1955 - (599 + 220)) > (8596 - 4279))) then
												v87 = v87 + (1932 - (1813 + 118));
											end
											break;
										end
									end
								end
							end
							v175 = 1 + 0;
						end
					end
				end;
				break;
			end
		end
	end
	do
		local v88 = 1217 - (841 + 376);
		local v89;
		while true do
			if (((6652 - 1904) == (1103 + 3645)) and (v88 == (5 - 3))) then
				v9:RegisterForSelfCombatEvent(function(v176, v176, v176, v176, v176, v176, v176, v176, v176, v176, v176, v177)
					if (((4595 - (464 + 395)) <= (12164 - 7424)) and (v177 == (151519 + 163989))) then
						v89 = v28();
					end
				end, "SPELL_AURA_REMOVED");
				break;
			end
			if ((v88 == (838 - (467 + 370))) or ((7005 - 3615) <= (2247 + 813))) then
				v9:RegisterForSelfCombatEvent(function(v178, v178, v178, v178, v178, v178, v178, v178, v178, v178, v178, v179)
					if ((v179 == (1081564 - 766056)) or ((156 + 843) > (6265 - 3572))) then
						v89 = v28() + (550 - (150 + 370));
					end
				end, "SPELL_AURA_APPLIED");
				v9:RegisterForSelfCombatEvent(function(v180, v180, v180, v180, v180, v180, v180, v180, v180, v180, v180, v181)
					if (((1745 - (74 + 1208)) < (1477 - 876)) and (v181 == (1496326 - 1180818))) then
						v89 = v28() + v21(29 + 11, (420 - (14 + 376)) + v29.RtBRemains(true));
					end
				end, "SPELL_AURA_REFRESH");
				v88 = 3 - 1;
			end
			if ((v88 == (0 + 0)) or ((1918 + 265) < (656 + 31))) then
				v89 = v28();
				v29.RtBRemains = function(v182)
					local v183 = (v89 - v28()) - v9.RecoveryOffset(v182);
					return ((v183 >= (0 - 0)) and v183) or (0 + 0);
				end;
				v88 = 79 - (23 + 55);
			end
		end
	end
	do
		local v90 = {CrimsonTempest={},Garrote={},Rupture={}};
		v29.Exsanguinated = function(v121, v122)
			local v123 = v121:GUID();
			if (((10780 - 6231) == (3036 + 1513)) and not v123) then
				return false;
			end
			local v124 = v122:ID();
			if (((4196 + 476) == (7243 - 2571)) and (v124 == (38192 + 83219))) then
				return v90.CrimsonTempest[v123] or false;
			elseif ((v124 == (1604 - (652 + 249))) or ((9816 - 6148) < (2263 - (708 + 1160)))) then
				return v90.Garrote[v123] or false;
			elseif ((v124 == (5274 - 3331)) or ((7595 - 3429) == (482 - (10 + 17)))) then
				return v90.Rupture[v123] or false;
			end
			return false;
		end;
		v29.WillLoseExsanguinate = function(v125, v126)
			local v127 = 0 + 0;
			while true do
				if ((v127 == (1732 - (1400 + 332))) or ((8533 - 4084) == (4571 - (242 + 1666)))) then
					if (v29.Exsanguinated(v125, v126) or ((1831 + 2446) < (1096 + 1893))) then
						return true;
					end
					return false;
				end
			end
		end;
		v29.ExsanguinatedRate = function(v128, v129)
			if (v29.Exsanguinated(v128, v129) or ((742 + 128) >= (5089 - (850 + 90)))) then
				return 3 - 1;
			end
			return 1391 - (360 + 1030);
		end;
		v9:RegisterForSelfCombatEvent(function(v130, v130, v130, v130, v130, v130, v130, v131, v130, v130, v130, v132)
			if (((1958 + 254) < (8983 - 5800)) and (v132 == (276276 - 75470))) then
				for v184, v185 in v22(v90) do
					for v213, v214 in v22(v185) do
						if (((6307 - (909 + 752)) > (4215 - (109 + 1114))) and (v213 == v131)) then
							v185[v213] = true;
						end
					end
				end
			end
		end, "SPELL_CAST_SUCCESS");
		v9:RegisterForSelfCombatEvent(function(v133, v133, v133, v133, v133, v133, v133, v134, v133, v133, v133, v135)
			if (((2624 - 1190) < (1210 + 1896)) and (v135 == (121653 - (6 + 236)))) then
				v90.CrimsonTempest[v134] = false;
			elseif (((496 + 290) < (2434 + 589)) and (v135 == (1657 - 954))) then
				v90.Garrote[v134] = false;
			elseif ((v135 == (3393 - 1450)) or ((3575 - (1076 + 57)) < (13 + 61))) then
				v90.Rupture[v134] = false;
			end
		end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
		v9:RegisterForSelfCombatEvent(function(v136, v136, v136, v136, v136, v136, v136, v137, v136, v136, v136, v138)
			if (((5224 - (579 + 110)) == (359 + 4176)) and (v138 == (107344 + 14067))) then
				if ((v90.CrimsonTempest[v137] ~= nil) or ((1597 + 1412) <= (2512 - (174 + 233)))) then
					v90.CrimsonTempest[v137] = nil;
				end
			elseif (((5111 - 3281) < (6439 - 2770)) and (v138 == (313 + 390))) then
				if ((v90.Garrote[v137] ~= nil) or ((2604 - (663 + 511)) >= (3223 + 389))) then
					v90.Garrote[v137] = nil;
				end
			elseif (((583 + 2100) >= (7584 - 5124)) and (v138 == (1177 + 766))) then
				if ((v90.Rupture[v137] ~= nil) or ((4247 - 2443) >= (7928 - 4653))) then
					v90.Rupture[v137] = nil;
				end
			end
		end, "SPELL_AURA_REMOVED");
		v9:RegisterForCombatEvent(function(v139, v139, v139, v139, v139, v139, v139, v140)
			if ((v90.CrimsonTempest[v140] ~= nil) or ((677 + 740) > (7062 - 3433))) then
				v90.CrimsonTempest[v140] = nil;
			end
			if (((3418 + 1377) > (37 + 365)) and (v90.Garrote[v140] ~= nil)) then
				v90.Garrote[v140] = nil;
			end
			if (((5535 - (478 + 244)) > (4082 - (440 + 77))) and (v90.Rupture[v140] ~= nil)) then
				v90.Rupture[v140] = nil;
			end
		end, "UNIT_DIED", "UNIT_DESTROYED");
	end
	do
		local v94 = 0 + 0;
		local v95;
		local v96;
		local v97;
		while true do
			if (((14317 - 10405) == (5468 - (655 + 901))) and (v94 == (1 + 1))) then
				v9:RegisterForSelfCombatEvent(function(v186, v186, v186, v186, v186, v186, v186, v186, v186, v186, v186, v187, v186, v186, v188, v189)
					if (((2160 + 661) <= (3258 + 1566)) and (v187 == (748371 - 562608))) then
						if (((3183 - (695 + 750)) <= (7495 - 5300)) and ((v28() - v97) > (0.5 - 0))) then
							v96 = v21(v29.CPMaxSpend(), v12:ComboPoints() + v188 + (v24(0 - 0, v188 - (352 - (285 + 66))) * v21(4 - 2, v12:BuffStack(v95) - (1311 - (682 + 628)))));
							v97 = v28();
						end
					end
				end, "SPELL_ENERGIZE");
				break;
			end
			if (((7 + 34) <= (3317 - (176 + 123))) and (v94 == (0 + 0))) then
				v95 = v15(141904 + 53723);
				v96 = 269 - (239 + 30);
				v94 = 1 + 0;
			end
			if (((2062 + 83) <= (7263 - 3159)) and (v94 == (2 - 1))) then
				v97 = v28();
				v29.FanTheHammerCP = function()
					local v190 = 315 - (306 + 9);
					while true do
						if (((9383 - 6694) < (843 + 4002)) and (v190 == (0 + 0))) then
							if ((((v28() - v97) < (0.5 + 0)) and (v96 > (0 - 0))) or ((3697 - (1140 + 235)) > (1669 + 953))) then
								if ((v96 > v12:ComboPoints()) or ((4158 + 376) == (535 + 1547))) then
									return v96;
								else
									v96 = 52 - (33 + 19);
								end
							end
							return 0 + 0;
						end
					end
				end;
				v94 = 5 - 3;
			end
		end
	end
	do
		local v98 = 0 + 0;
		local v99;
		local v100;
		local v101;
		while true do
			if (((0 - 0) == v98) or ((1474 + 97) > (2556 - (586 + 103)))) then
				v99, v100 = 0 + 0, 0 - 0;
				v101 = v15(279413 - (1309 + 179));
				v98 = 1 - 0;
			end
			if ((v98 == (1 + 0)) or ((7127 - 4473) >= (2263 + 733))) then
				v29.TimeToNextTornado = function()
					local v191 = 0 - 0;
					local v192;
					while true do
						if (((7926 - 3948) > (2713 - (295 + 314))) and ((0 - 0) == v191)) then
							if (((4957 - (1300 + 662)) > (4838 - 3297)) and not v12:BuffUp(v101, nil, true)) then
								return 1755 - (1178 + 577);
							end
							v192 = v12:BuffRemains(v101, nil, true) % (1 + 0);
							v191 = 2 - 1;
						end
						if (((4654 - (851 + 554)) > (843 + 110)) and (v191 == (2 - 1))) then
							if ((v28() == v99) or ((7108 - 3835) > (4875 - (115 + 187)))) then
								return 0 + 0;
							elseif ((((v28() - v99) < (0.1 + 0)) and (v192 < (0.25 - 0))) or ((4312 - (160 + 1001)) < (1124 + 160))) then
								return 1 + 0;
							elseif ((((v192 > (0.9 - 0)) or (v192 == (358 - (237 + 121)))) and ((v28() - v99) > (897.75 - (525 + 372)))) or ((3507 - 1657) == (5023 - 3494))) then
								return 142.1 - (96 + 46);
							end
							return v192;
						end
					end
				end;
				v9:RegisterForSelfCombatEvent(function(v193, v193, v193, v193, v193, v193, v193, v193, v193, v193, v193, v194)
					if (((1598 - (643 + 134)) < (767 + 1356)) and (v194 == (510111 - 297368))) then
						v99 = v28();
					elseif (((3348 - 2446) < (2230 + 95)) and (v194 == (388259 - 190424))) then
						v100 = v28();
					end
					if (((1753 - 895) <= (3681 - (316 + 403))) and (v100 == v99)) then
						v99 = 0 + 0;
					end
				end, "SPELL_CAST_SUCCESS");
				break;
			end
		end
	end
	do
		local v102 = 0 - 0;
		local v103;
		while true do
			if ((v102 == (1 + 0)) or ((9937 - 5991) < (913 + 375))) then
				v9:RegisterForSelfCombatEvent(function()
					v103.Counter = 0 + 0;
					v103.LastMH = v28();
					v103.LastOH = v28();
				end, "PLAYER_ENTERING_WORLD");
				v9:RegisterForSelfCombatEvent(function(v198, v198, v198, v198, v198, v198, v198, v198, v198, v198, v198, v199)
					if ((v199 == (682295 - 485384)) or ((15483 - 12241) == (1177 - 610))) then
						v103.Counter = 0 + 0;
					end
				end, "SPELL_ENERGIZE");
				v102 = 3 - 1;
			end
			if ((v102 == (1 + 1)) or ((2491 - 1644) >= (1280 - (12 + 5)))) then
				v9:RegisterForSelfCombatEvent(function(v200, v200, v200, v200, v200, v200, v200, v200, v200, v200, v200, v200, v200, v200, v200, v200, v200, v200, v200, v200, v200, v200, v200, v201)
					v103.Counter = v103.Counter + (3 - 2);
					if (v201 or ((4806 - 2553) == (3934 - 2083))) then
						v103.LastOH = v28();
					else
						v103.LastMH = v28();
					end
				end, "SWING_DAMAGE");
				v9:RegisterForSelfCombatEvent(function(v203, v203, v203, v203, v203, v203, v203, v203, v203, v203, v203, v203, v203, v203, v203, v204)
					if (v204 or ((5175 - 3088) > (482 + 1890))) then
						v103.LastOH = v28();
					else
						v103.LastMH = v28();
					end
				end, "SWING_MISSED");
				break;
			end
			if ((v102 == (1973 - (1656 + 317))) or ((3961 + 484) < (3325 + 824))) then
				v103 = {Counter=(0 - 0),LastMH=(0 - 0),LastOH=(354 - (5 + 349))};
				v29.TimeToSht = function(v205)
					local v206 = 0 - 0;
					local v207;
					local v208;
					local v209;
					local v210;
					local v211;
					local v212;
					while true do
						if ((v206 == (1274 - (266 + 1005))) or ((1199 + 619) == (289 - 204))) then
							table.sort(v211);
							v212 = v21(6 - 1, v24(1697 - (561 + 1135), v205 - v103.Counter));
							v206 = 5 - 1;
						end
						if (((2070 - 1440) < (3193 - (507 + 559))) and (v206 == (9 - 5))) then
							return v211[v212] - v28();
						end
						if ((v206 == (0 - 0)) or ((2326 - (212 + 176)) == (3419 - (250 + 655)))) then
							if (((11602 - 7347) >= (96 - 41)) and (v103.Counter >= v205)) then
								return 0 - 0;
							end
							v207, v208 = v27("player");
							v206 = 1957 - (1869 + 87);
						end
						if (((10401 - 7402) > (3057 - (484 + 1417))) and (v206 == (4 - 2))) then
							v211 = {};
							for v234 = 0 - 0, 775 - (48 + 725) do
								v26(v211, v209 + (v234 * v207));
								v26(v211, v210 + (v234 * v208));
							end
							v206 = 4 - 1;
						end
						if (((6304 - 3954) > (672 + 483)) and (v206 == (2 - 1))) then
							v209 = v24(v103.LastMH + v207, v28());
							v210 = v24(v103.LastOH + v208, v28());
							v206 = 1 + 1;
						end
					end
				end;
				v102 = 1 + 0;
			end
		end
	end
	do
		local v104 = v12:CritChancePct();
		local v105 = 853 - (152 + 701);
		local function v106()
			local v141 = 1311 - (430 + 881);
			while true do
				if (((1543 + 2486) <= (5748 - (557 + 338))) and (v141 == (0 + 0))) then
					if (not v12:AffectingCombat() or ((1454 - 938) > (12025 - 8591))) then
						v104 = v12:CritChancePct();
						v9.Debug("Base Crit Set to: " .. v104);
					end
					if (((10749 - 6703) >= (6536 - 3503)) and ((v105 == nil) or (v105 < (801 - (499 + 302))))) then
						v105 = 866 - (39 + 827);
					else
						v105 = v105 - (2 - 1);
					end
					v141 = 2 - 1;
				end
				if ((v141 == (3 - 2)) or ((4173 - 1454) <= (124 + 1323))) then
					if ((v105 > (0 - 0)) or ((662 + 3472) < (6212 - 2286))) then
						v23.After(107 - (103 + 1), v106);
					end
					break;
				end
			end
		end
		v9:RegisterForEvent(function()
			if ((v105 == (554 - (475 + 79))) or ((354 - 190) >= (8912 - 6127))) then
				local v172 = 0 + 0;
				while true do
					if ((v172 == (0 + 0)) or ((2028 - (1395 + 108)) == (6136 - 4027))) then
						v23.After(1207 - (7 + 1197), v106);
						v105 = 1 + 1;
						break;
					end
				end
			end
		end, "PLAYER_EQUIPMENT_CHANGED");
		v29.BaseAttackCrit = function()
			return v104;
		end;
	end
	do
		local v108 = v15.Rogue.Assassination;
		local v109 = v15.Rogue.Subtlety;
		local function v110()
			local v142 = 0 + 0;
			while true do
				if (((352 - (27 + 292)) == (96 - 63)) and (v142 == (0 - 0))) then
					if (((12807 - 9753) <= (7917 - 3902)) and v108.Nightstalker:IsAvailable() and v12:StealthUp(true, false, true)) then
						return (1 - 0) + ((139.05 - (43 + 96)) * v108.Nightstalker:TalentRank());
					end
					return 4 - 3;
				end
			end
		end
		local function v111()
			if (((4229 - 2358) < (2807 + 575)) and v108.ImprovedGarrote:IsAvailable() and (v12:BuffUp(v108.ImprovedGarroteAura, nil, true) or v12:BuffUp(v108.ImprovedGarroteBuff, nil, true) or v12:BuffUp(v108.SepsisBuff, nil, true))) then
				return 1.5 + 0;
			end
			return 1 - 0;
		end
		v108.Rupture:RegisterPMultiplier(v110, {v109.FinalityRuptureBuff,(1.3 + 0)});
		v108.Garrote:RegisterPMultiplier(v110, v111);
	end
end;
return v0["Epix_Rogue_Rogue.lua"]();

