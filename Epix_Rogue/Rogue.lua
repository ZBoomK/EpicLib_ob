local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((2889 - 1601) > (1511 - (112 + 148))) and not v5) then
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
	if (not v15.Rogue or ((59 + 4454) < (1667 + 1685))) then
		v15.Rogue = {};
	end
	v15.Rogue.Commons = {Sanguine=v15(227882 - (1168 + 204), nil, 961 - (271 + 689)),AncestralCall=v15(276342 - (963 + 641), nil, 196 - (48 + 146)),ArcanePulse=v15(260952 - (294 + 294), nil, 4 - 1),ArcaneTorrent=v15(4223 + 20823, nil, 2 + 2),BagofTricks=v15(314024 - (1565 + 48), nil, 4 + 1),Berserking=v15(27435 - (782 + 356), nil, 273 - (176 + 91)),BloodFury=v15(53596 - 33024, nil, 9 - 2),Fireblood=v15(266313 - (975 + 117), nil, 1883 - (157 + 1718)),LightsJudgment=v15(207472 + 48175, nil, 31 - 22),Shadowmeld=v15(201654 - 142670, nil, 1028 - (697 + 321)),CloakofShadows=v15(85057 - 53833, nil, 23 - 12),CrimsonVial=v15(427212 - 241901, nil, 5 + 7),Evasion=v15(9887 - 4610, nil, 34 - 21),Feint=v15(3193 - (322 + 905), nil, 625 - (602 + 9)),Blind=v15(3283 - (449 + 740), nil, 887 - (826 + 46)),CheapShot=v15(2780 - (245 + 702), nil, 50 - 34),Kick=v15(568 + 1198, nil, 1915 - (260 + 1638)),KidneyShot=v15(848 - (382 + 58), nil, 57 - 39),Sap=v15(5626 + 1144, nil, 38 - 19),Shiv=v15(17651 - 11713, nil, 1225 - (902 + 303)),SliceandDice=v15(692715 - 377219, nil, 50 - 29),Shadowstep=v15(3142 + 33412, nil, 1712 - (1121 + 569)),Sprint=v15(3197 - (22 + 192), nil, 706 - (483 + 200)),TricksoftheTrade=v15(59397 - (1404 + 59), nil, 65 - 41),CripplingPoison=v15(4579 - 1171, nil, 790 - (468 + 297)),DeadlyPoison=v15(3385 - (334 + 228), nil, 87 - 61),InstantPoison=v15(731495 - 415911, nil, 48 - 21),AmplifyingPoison=v15(108379 + 273285, nil, 264 - (141 + 95)),NumbingPoison=v15(5660 + 101, nil, 74 - 45),WoundPoison=v15(20863 - 12184, nil, 8 + 22),AtrophicPoison=v15(1045639 - 664002, nil, 22 + 9),AcrobaticStrikes=v15(102544 + 94380, nil, 44 - 12),Alacrity=v15(114161 + 79378, nil, 196 - (92 + 71)),ColdBlood=v15(188808 + 193437, nil, 56 - 22),DeeperStratagem=v15(194296 - (574 + 191)),EchoingReprimand=v15(318081 + 67535, nil, 89 - 53),EchoingReprimand2=v15(165270 + 158288, nil, 886 - (254 + 595)),EchoingReprimand3=v15(323685 - (55 + 71), nil, 49 - 11),EchoingReprimand4=v15(325350 - (573 + 1217), nil, 107 - 68),EchoingReprimand5=v15(26999 + 327839, nil, 64 - 24),FindWeakness=v15(91962 - (714 + 225), nil, 119 - 78),FindWeaknessDebuff=v15(440862 - 124642, nil, 5 + 37),ImprovedAmbush=v15(552566 - 170946, nil, 849 - (118 + 688)),MarkedforDeath=v15(137667 - (25 + 23), nil, 9 + 35),Nightstalker=v15(15948 - (927 + 959), nil, 151 - 106),ResoundingClarity=v15(382354 - (16 + 716), nil, 88 - 42),SealFate=v15(14287 - (11 + 86), nil, 114 - 67),Sepsis=v15(385693 - (175 + 110), nil, 120 - 72),SepsisBuff=v15(1854225 - 1478286, nil, 1845 - (503 + 1293)),ShadowDance=v15(517542 - 332229, nil, 37 + 13),ShadowDanceTalent=v15(395991 - (810 + 251), nil, 36 + 15),ShadowDanceBuff=v15(56907 + 128515),Subterfuge=v15(97545 + 10663, nil, 586 - (43 + 490)),SubterfugeBuff=v15(115925 - (711 + 22), nil, 208 - 154),ThistleTea=v15(382482 - (240 + 619), nil, 78 + 242),Vigor=v15(23833 - 8850),Stealth=v15(119 + 1665, nil, 1801 - (1344 + 400)),Stealth2=v15(115596 - (255 + 150), nil, 46 + 12),Vanish=v15(994 + 862, nil, 251 - 192),VanishBuff=v15(36585 - 25258, nil, 1799 - (404 + 1335)),VanishBuff2=v15(115599 - (183 + 223), nil, 74 - 13),PoolEnergy=v15(662528 + 337382, nil, 23 + 39)};
	v15.Rogue.Assassination = v18(v15.Rogue.Commons, {Ambush=v15(9013 - (10 + 327), nil, 44 + 19),AmbushOverride=v15(430361 - (118 + 220)),AmplifyingPoisonDebuff=v15(127775 + 255639, nil, 513 - (108 + 341)),AmplifyingPoisonDebuffDeathmark=v15(177107 + 217221, nil, 274 - 209),CripplingPoisonDebuff=v15(4902 - (711 + 782), nil, 126 - 60),DeadlyPoisonDebuff=v15(3287 - (270 + 199), nil, 22 + 45),DeadlyPoisonDebuffDeathmark=v15(396143 - (580 + 1239), nil, 202 - 134),Envenom=v15(31214 + 1431, nil, 3 + 66),FanofKnives=v15(22532 + 29191, nil, 182 - 112),Garrote=v15(437 + 266, nil, 1238 - (645 + 522)),GarroteDeathmark=v15(362620 - (1010 + 780), nil, 72 + 0),Mutilate=v15(6331 - 5002, nil, 213 - 140),PoisonedKnife=v15(187401 - (1045 + 791), nil, 186 - 112),Rupture=v15(2966 - 1023, nil, 580 - (351 + 154)),RuptureDeathmark=v15(362400 - (1281 + 293), nil, 342 - (28 + 238)),WoundPoisonDebuff=v15(19395 - 10715, nil, 1636 - (1381 + 178)),ArterialPrecision=v15(375910 + 24873, nil, 63 + 15),AtrophicPoisonDebuff=v15(167377 + 225011, nil, 272 - 193),BlindsideBuff=v15(62765 + 58388, nil, 550 - (381 + 89)),CausticSpatter=v15(374203 + 47772),CausticSpatterDebuff=v15(285378 + 136598),CrimsonTempest=v15(207975 - 86564, nil, 1237 - (1074 + 82)),CutToTheChase=v15(113226 - 61559, nil, 1866 - (214 + 1570)),DashingScoundrel=v15(383252 - (990 + 465), nil, 35 + 48),Deathmark=v15(156729 + 203465, nil, 82 + 2),Doomblade=v15(1502085 - 1120412, nil, 1811 - (1668 + 58)),DragonTemperedBlades=v15(382427 - (512 + 114), nil, 224 - 138),Elusiveness=v15(163336 - 84328),Exsanguinate=v15(698736 - 497930, nil, 41 + 47),ImprovedGarrote=v15(71439 + 310193, nil, 78 + 11),ImprovedGarroteBuff=v15(1323555 - 931154, nil, 2084 - (109 + 1885)),ImprovedGarroteAura=v15(393872 - (1269 + 200), nil, 174 - 83),IndiscriminateCarnage=v15(382617 - (98 + 717), nil, 918 - (802 + 24)),IndiscriminateCarnageAura=v15(665245 - 279491),IndiscriminateCarnageBuff=v15(487180 - 101433),InternalBleeding=v15(22884 + 132069, nil, 72 + 21),Kingsbane=v15(63341 + 322286, nil, 21 + 73),LightweightShiv=v15(1098818 - 703835),MasterAssassin=v15(853662 - 597673, nil, 34 + 61),MasterAssassinBuff=v15(104507 + 152228, nil, 80 + 16),PreyontheWeak=v15(95626 + 35885, nil, 46 + 51),PreyontheWeakDebuff=v15(257342 - (797 + 636), nil, 475 - 377),SerratedBoneSpike=v15(387043 - (1427 + 192), nil, 35 + 64),SerratedBoneSpikeDebuff=v15(914863 - 520827, nil, 90 + 10),ShivDebuff=v15(144794 + 174710, nil, 427 - (192 + 134)),VenomRush=v15(153428 - (316 + 960), nil, 57 + 45),ScentOfBlood=v15(294641 + 87158, nil, 367 + 29),ScentOfBloodBuff=v15(1506570 - 1112490),ShroudedSuffocation=v15(386029 - (83 + 468))});
	v15.Rogue.Outlaw = v18(v15.Rogue.Commons, {AdrenalineRush=v15(15556 - (1202 + 604), nil, 480 - 377),Ambush=v15(14439 - 5763, nil, 287 - 183),AmbushOverride=v15(430348 - (45 + 280)),BetweentheEyes=v15(304366 + 10975, nil, 92 + 13),BladeFlurry=v15(5068 + 8809, nil, 59 + 47),Dispatch=v15(370 + 1728, nil, 197 - 90),Elusiveness=v15(80919 - (340 + 1571)),Opportunity=v15(77160 + 118467),PistolShot=v15(187535 - (1733 + 39), nil, 302 - 192),RolltheBones=v15(316542 - (125 + 909), nil, 2059 - (1096 + 852)),SinisterStrike=v15(86717 + 106598, nil, 159 - 47),Audacity=v15(370364 + 11481, nil, 625 - (409 + 103)),AudacityBuff=v15(386506 - (46 + 190), nil, 209 - (51 + 44)),BladeRush=v15(76681 + 195196, nil, 1432 - (1114 + 203)),CountTheOdds=v15(382708 - (228 + 498), nil, 26 + 90),Dreadblades=v15(189573 + 153569, nil, 780 - (174 + 489)),FanTheHammer=v15(994821 - 612975, nil, 2023 - (830 + 1075)),GhostlyStrike=v15(197461 - (303 + 221), nil, 1388 - (231 + 1038)),GreenskinsWickers=v15(322344 + 64479, nil, 1282 - (171 + 991)),GreenskinsWickersBuff=v15(1624294 - 1230163, nil, 324 - 203),HiddenOpportunity=v15(956461 - 573180, nil, 98 + 24),ImprovedAdrenalineRush=v15(1386095 - 990673, nil, 354 - 231),ImprovedBetweenTheEyes=v15(379591 - 144107, nil, 383 - 259),KeepItRolling=v15(383237 - (111 + 1137), nil, 283 - (91 + 67)),KillingSpree=v15(153842 - 102152, nil, 32 + 94),LoadedDice=v15(256693 - (423 + 100), nil, 1 + 126),LoadedDiceBuff=v15(709300 - 453129, nil, 67 + 61),PreyontheWeak=v15(132282 - (326 + 445), nil, 562 - 433),PreyontheWeakDebuff=v15(570119 - 314210, nil, 303 - 173),QuickDraw=v15(197649 - (530 + 181), nil, 1012 - (614 + 267)),SummarilyDispatched=v15(382022 - (19 + 13), nil, 214 - 82),SwiftSlasher=v15(890162 - 508174, nil, 379 - 246),TakeEmBySurpriseBuff=v15(100224 + 285683, nil, 235 - 101),Weaponmaster=v15(416289 - 215556, nil, 1947 - (1293 + 519)),UnderhandedUpperhand=v15(865182 - 441138),DeftManeuvers=v15(997064 - 615186),Crackshot=v15(810256 - 386553),Gouge=v15(7658 - 5882, nil, 320 - 184),Broadside=v15(102410 + 90946, nil, 28 + 109),BuriedTreasure=v15(463773 - 264173, nil, 32 + 106),GrandMelee=v15(64235 + 129123, nil, 87 + 52),RuthlessPrecision=v15(194453 - (709 + 387), nil, 1998 - (673 + 1185)),SkullandCrossbones=v15(578877 - 379274, nil, 452 - 311),TrueBearing=v15(318140 - 124781, nil, 102 + 40),ViciousFollowup=v15(295054 + 99825, nil, 192 - 49)});
	v15.Rogue.Subtlety = v18(v15.Rogue.Commons, {Backstab=v15(14 + 39, nil, 286 - 142),BlackPowder=v15(626549 - 307374, nil, 2025 - (446 + 1434)),Elusiveness=v15(80291 - (1040 + 243)),Eviscerate=v15(587429 - 390610, nil, 1994 - (559 + 1288)),Rupture=v15(3874 - (609 + 1322), nil, 602 - (13 + 441)),ShadowBlades=v15(453917 - 332446, nil, 390 - 241),Shadowstrike=v15(923562 - 738124, nil, 6 + 144),ShurikenStorm=v15(718497 - 520662, nil, 54 + 97),ShurikenToss=v15(49960 + 64054, nil, 451 - 299),SymbolsofDeath=v15(116164 + 96119, nil, 280 - 127),DanseMacabre=v15(252894 + 129634, nil, 86 + 68),DanseMacabreBuff=v15(283070 + 110899, nil, 131 + 24),DeeperDaggers=v15(374249 + 8268, nil, 589 - (153 + 280)),DeeperDaggersBuff=v15(1107120 - 723715, nil, 141 + 16),DarkBrew=v15(151029 + 231475, nil, 83 + 75),DarkShadow=v15(222957 + 22730, nil, 116 + 43),EnvelopingShadows=v15(362564 - 124460, nil, 99 + 61),Finality=v15(383192 - (89 + 578), nil, 116 + 45),FinalityBlackPowderBuff=v15(802378 - 416430, nil, 1211 - (572 + 477)),FinalityEviscerateBuff=v15(52052 + 333897, nil, 98 + 65),FinalityRuptureBuff=v15(46069 + 339882, nil, 250 - (84 + 2)),Flagellation=v15(633899 - 249268, nil, 119 + 46),FlagellationPersistBuff=v15(395600 - (497 + 345), nil, 5 + 161),Gloomblade=v15(33937 + 166821, nil, 1500 - (605 + 728)),GoremawsBite=v15(304364 + 122227, nil, 419 - 230),ImprovedShadowDance=v15(18056 + 375916, nil, 621 - 453),ImprovedShurikenStorm=v15(288435 + 31516, nil, 467 - 298),InvigoratingShadowdust=v15(288825 + 93698),LingeringShadow=v15(383013 - (457 + 32), nil, 73 + 97),LingeringShadowBuff=v15(387362 - (832 + 570), nil, 162 + 9),MasterofShadows=v15(51367 + 145609, nil, 608 - 436),PerforatedVeins=v15(184261 + 198257, nil, 969 - (588 + 208)),PerforatedVeinsBuff=v15(1062605 - 668351, nil, 1974 - (884 + 916)),PreyontheWeak=v15(275328 - 143817, nil, 102 + 73),PreyontheWeakDebuff=v15(256562 - (232 + 421), nil, 2065 - (1569 + 320)),Premeditation=v15(84192 + 258968, nil, 34 + 143),PremeditationBuff=v15(1156429 - 813256, nil, 783 - (316 + 289)),SecretStratagem=v15(1032219 - 637899, nil, 9 + 170),SecretTechnique=v15(282172 - (666 + 787), nil, 605 - (360 + 65)),Shadowcraft=v15(398680 + 27914),ShadowFocus=v15(108463 - (79 + 175), nil, 285 - 104),ShurikenTornado=v15(216878 + 61047, nil, 557 - 375),SilentStorm=v15(742845 - 357123, nil, 1082 - (503 + 396)),SilentStormBuff=v15(385903 - (92 + 89), nil, 356 - 172),TheFirstDance=v15(196165 + 186340, nil, 110 + 75),TheRotten=v15(1496025 - 1114010, nil, 26 + 160),TheRottenBuff=v15(898833 - 504630, nil, 164 + 23),Weaponmaster=v15(92440 + 101097, nil, 572 - 384)});
	if (not v17.Rogue or ((258 + 1807) >= (4873 - 1677))) then
		v17.Rogue = {};
	end
	v17.Rogue.Commons = {AlgetharPuzzleBox=v17(194945 - (485 + 759), {(1202 - (442 + 747)),(960 - (88 + 858))}),ManicGrieftorch=v17(59222 + 135086, {(1 + 12),(69 - 55)}),WindscarWhetstone=v17(188033 - 50547, {(44 - 31),(10 + 4)}),Healthstone=v17(10733 - 5221),RefreshingHealingPotion=v17(150546 + 40834)};
	v17.Rogue.Assassination = v18(v17.Rogue.Commons, {AlgetharPuzzleBox=v17(195181 - (641 + 839), {(32 - 19),(7 + 7)}),AshesoftheEmbersoul=v17(208315 - (556 + 592), {(821 - (329 + 479)),(47 - 33)}),WitherbarksBranch=v17(227998 - 117999, {(752 - (396 + 343)),(1491 - (29 + 1448))})});
	v17.Rogue.Outlaw = v18(v17.Rogue.Commons, {ManicGrieftorch=v17(195697 - (135 + 1254), {(60 - 47),(1541 - (389 + 1138))}),WindscarWhetstone=v17(138060 - (102 + 472), {(8 + 5),(1559 - (320 + 1225))}),BeaconToTheBeyond=v17(363093 - 159130, {(1477 - (157 + 1307)),(34 - 20)}),DragonfireBombDispenser=v17(22158 + 180452, {(5 + 8),(1040 - (834 + 192))})});
	v17.Rogue.Subtlety = v18(v17.Rogue.Commons, {ManicGrieftorch=v17(12354 + 181954, {(1 + 12),(318 - (300 + 4))}),StormEatersBoon=v17(51892 + 142410, {(375 - (112 + 250)),(34 - 20)}),BeaconToTheBeyond=v17(116847 + 87116, {(10 + 3),(11 + 3)}),AshesoftheEmbersoul=v17(208581 - (1001 + 413), {(895 - (244 + 638)),(41 - 27)}),WitherbarksBranch=v17(110601 - (512 + 90), {(730 - (373 + 344)),(4 + 10)}),BandolierOfTwistedBlades=v17(546444 - 339279, {(1112 - (35 + 1064)),(29 - 15)}),Mirror=v17(829 + 206752, {(1272 - (233 + 1026)),(8 + 6)})});
	if (not v20.Rogue or ((4275 + 101) <= (440 + 1041))) then
		v20.Rogue = {};
	end
	v20.Rogue.Commons = {Healthstone=v20(2 + 19),BlindMouseover=v20(230 - (55 + 166)),CheapShotMouseover=v20(2 + 8),KickMouseover=v20(2 + 9),KidneyShotMouseover=v20(45 - 33),TricksoftheTradeFocus=v20(310 - (36 + 261)),WindscarWhetstone=v20(44 - 18)};
	v20.Rogue.Outlaw = v18(v20.Rogue.Commons, {Dispatch=v20(1382 - (34 + 1334)),PistolShotMouseover=v20(6 + 9),SinisterStrikeMouseover=v20(13 + 3)});
	v20.Rogue.Subtlety = v18(v20.Rogue.Commons, {SecretTechnique=v20(1299 - (1035 + 248)),ShadowDance=v20(38 - (20 + 1)),ShadowDanceSymbol=v20(14 + 12),VanishShadowstrike=v20(337 - (134 + 185)),ShurikenStormSD=v20(1152 - (549 + 584)),ShurikenStormVanish=v20(705 - (314 + 371)),GloombladeSD=v20(75 - 53),GloombladeVanish=v20(991 - (478 + 490)),BackstabMouseover=v20(13 + 11),RuptureMouseover=v20(1197 - (786 + 386))});
	v29.StealthSpell = function()
		return (v15.Rogue.Commons.Subterfuge:IsAvailable() and v15.Rogue.Commons.Stealth2) or v15.Rogue.Commons.Stealth;
	end;
	v29.VanishBuffSpell = function()
		return (v15.Rogue.Commons.Subterfuge:IsAvailable() and v15.Rogue.Commons.VanishBuff2) or v15.Rogue.Commons.VanishBuff;
	end;
	v29.Stealth = function(v48, v49)
		local v50 = 0 - 0;
		while true do
			if ((v50 == (1379 - (1055 + 324))) or ((4732 - (1093 + 247)) >= (4214 + 527))) then
				if (((350 + 2975) >= (8551 - 6397)) and EpicSettings.Settings['StealthOOC'] and (v15.Rogue.Commons.Stealth:IsCastable() or v15.Rogue.Commons.Stealth2:IsCastable()) and v12:StealthDown()) then
					if (v9.Press(v48, nil) or ((4394 - 3099) >= (9199 - 5966))) then
						return "Cast Stealth (OOC)";
					end
				end
				return false;
			end
		end
	end;
	do
		local v51 = v15(465670 - 280359);
		v29.CrimsonVial = function()
			local v111 = 0 + 0;
			local v112;
			while true do
				if (((16862 - 12485) > (5659 - 4017)) and (v111 == (1 + 0))) then
					return false;
				end
				if (((12078 - 7355) > (2044 - (364 + 324))) and (v111 == (0 - 0))) then
					v112 = EpicSettings.Settings['CrimsonVialHP'] or (0 - 0);
					if ((v51:IsCastable() and (v12:HealthPercentage() <= v112)) or ((1371 + 2765) <= (14364 - 10931))) then
						if (((6798 - 2553) <= (14064 - 9433)) and v9.Cast(v51, nil)) then
							return "Cast Crimson Vial (Defensives)";
						end
					end
					v111 = 1269 - (1249 + 19);
				end
			end
		end;
	end
	do
		local v53 = v15(1775 + 191);
		v29.Feint = function()
			local v113 = 0 - 0;
			local v114;
			while true do
				if (((5362 - (686 + 400)) >= (3071 + 843)) and (v113 == (229 - (73 + 156)))) then
					v114 = EpicSettings.Settings['FeintHP'] or (0 + 0);
					if (((1009 - (721 + 90)) <= (50 + 4315)) and v53:IsCastable() and v12:BuffDown(v53) and (v12:HealthPercentage() <= v114)) then
						if (((15526 - 10744) > (5146 - (224 + 246))) and v9.Cast(v53, nil)) then
							return "Cast Feint (Defensives)";
						end
					end
					break;
				end
			end
		end;
	end
	do
		local v55 = 0 - 0;
		local v56 = false;
		local function v57(v115)
			if (((8955 - 4091) > (399 + 1798)) and not v12:AffectingCombat() and v12:BuffRefreshable(v115)) then
				if (v9.Press(v115, nil, true) or ((89 + 3611) == (1842 + 665))) then
					return "poison";
				end
			end
		end
		v29.Poisons = function()
			local v116 = 0 - 0;
			while true do
				if (((14888 - 10414) >= (787 - (203 + 310))) and (v116 == (1994 - (1238 + 755)))) then
					if (v12:BuffDown(v15.Rogue.Commons.CripplingPoison) or ((133 + 1761) <= (2940 - (709 + 825)))) then
						if (((2896 - 1324) >= (2229 - 698)) and v15.Rogue.Commons.AtrophicPoison:IsAvailable()) then
							local v224 = 864 - (196 + 668);
							local v225;
							while true do
								if ((v224 == (0 - 0)) or ((9708 - 5021) < (5375 - (171 + 662)))) then
									v225 = v57(v15.Rogue.Commons.AtrophicPoison);
									if (((3384 - (4 + 89)) > (5842 - 4175)) and v225) then
										return v225;
									end
									break;
								end
							end
						elseif (v15.Rogue.Commons.NumbingPoison:IsAvailable() or ((318 + 555) == (8933 - 6899))) then
							local v233 = 0 + 0;
							local v234;
							while true do
								if ((v233 == (1486 - (35 + 1451))) or ((4269 - (28 + 1425)) < (2004 - (941 + 1052)))) then
									v234 = v57(v15.Rogue.Commons.NumbingPoison);
									if (((3547 + 152) < (6220 - (822 + 692))) and v234) then
										return v234;
									end
									break;
								end
							end
						else
							local v235 = 0 - 0;
							local v236;
							while true do
								if (((1247 + 1399) >= (1173 - (45 + 252))) and ((0 + 0) == v235)) then
									v236 = v57(v15.Rogue.Commons.CripplingPoison);
									if (((212 + 402) <= (7748 - 4564)) and v236) then
										return v236;
									end
									break;
								end
							end
						end
					else
						local v206 = v57(v15.Rogue.Commons.CripplingPoison);
						if (((3559 - (114 + 319)) == (4487 - 1361)) and v206) then
							return v206;
						end
					end
					break;
				end
				if ((v116 == (0 - 0)) or ((1395 + 792) >= (7380 - 2426))) then
					v56 = v12:BuffUp(v15.Rogue.Commons.WoundPoison);
					if (v15.Rogue.Assassination.DragonTemperedBlades:IsAvailable() or ((8123 - 4246) == (5538 - (556 + 1407)))) then
						local v207 = v57((v56 and v15.Rogue.Commons.WoundPoison) or v15.Rogue.Commons.DeadlyPoison);
						if (((1913 - (741 + 465)) > (1097 - (170 + 295))) and v207) then
							return v207;
						end
						if (v15.Rogue.Commons.AmplifyingPoison:IsAvailable() or ((288 + 258) >= (2466 + 218))) then
							local v226 = 0 - 0;
							while true do
								if (((1215 + 250) <= (2759 + 1542)) and (v226 == (0 + 0))) then
									v207 = v57(v15.Rogue.Commons.AmplifyingPoison);
									if (((2934 - (957 + 273)) > (382 + 1043)) and v207) then
										return v207;
									end
									break;
								end
							end
						else
							local v227 = 0 + 0;
							while true do
								if ((v227 == (0 - 0)) or ((1810 - 1123) == (12932 - 8698))) then
									v207 = v57(v15.Rogue.Commons.InstantPoison);
									if (v207 or ((16489 - 13159) < (3209 - (389 + 1391)))) then
										return v207;
									end
									break;
								end
							end
						end
					elseif (((720 + 427) >= (35 + 300)) and v56) then
						local v228 = v57(v15.Rogue.Commons.WoundPoison);
						if (((7820 - 4385) > (3048 - (783 + 168))) and v228) then
							return v228;
						end
					elseif ((v15.Rogue.Commons.AmplifyingPoison:IsAvailable() and v12:BuffDown(v15.Rogue.Commons.DeadlyPoison)) or ((12652 - 8882) >= (3975 + 66))) then
						local v237 = 311 - (309 + 2);
						local v238;
						while true do
							if ((v237 == (0 - 0)) or ((5003 - (1090 + 122)) <= (523 + 1088))) then
								v238 = v57(v15.Rogue.Commons.AmplifyingPoison);
								if (v238 or ((15375 - 10797) <= (1375 + 633))) then
									return v238;
								end
								break;
							end
						end
					elseif (((2243 - (628 + 490)) <= (373 + 1703)) and v15.Rogue.Commons.DeadlyPoison:IsAvailable()) then
						local v239 = v57(v15.Rogue.Commons.DeadlyPoison);
						if (v239 or ((1839 - 1096) >= (20103 - 15704))) then
							return v239;
						end
					else
						local v240 = v57(v15.Rogue.Commons.InstantPoison);
						if (((1929 - (431 + 343)) < (3378 - 1705)) and v240) then
							return v240;
						end
					end
					v116 = 2 - 1;
				end
			end
		end;
	end
	v29.MfDSniping = function(v59)
		if (v59:IsCastable() or ((1836 + 488) <= (74 + 504))) then
			local v153 = 1695 - (556 + 1139);
			local v154;
			local v155;
			local v156;
			while true do
				if (((3782 - (6 + 9)) == (690 + 3077)) and (v153 == (0 + 0))) then
					v154, v155 = nil, 229 - (28 + 141);
					v156 = (v14:IsInRange(12 + 18) and v14:TimeToDie()) or (13714 - 2603);
					v153 = 1 + 0;
				end
				if (((5406 - (486 + 831)) == (10640 - 6551)) and (v153 == (3 - 2))) then
					for v208, v209 in v22(v12:GetEnemiesInRange(6 + 24)) do
						local v210 = 0 - 0;
						local v211;
						while true do
							if (((5721 - (668 + 595)) >= (1507 + 167)) and ((0 + 0) == v210)) then
								v211 = v209:TimeToDie();
								if (((2650 - 1678) <= (1708 - (23 + 267))) and not v209:IsMfDBlacklisted() and (v211 < (v12:ComboPointsDeficit() * (1945.5 - (1129 + 815)))) and (v211 < v155)) then
									if (((v156 - v211) > (388 - (371 + 16))) or ((6688 - (1326 + 424)) < (9018 - 4256))) then
										v154, v155 = v209, v211;
									else
										v154, v155 = v14, v156;
									end
								end
								break;
							end
						end
					end
					if ((v154 and (v154:GUID() ~= v13:GUID())) or ((9150 - 6646) > (4382 - (88 + 30)))) then
						v9.Press(v154, v59);
					end
					break;
				end
			end
		end
	end;
	v29.CanDoTUnit = function(v60, v61)
		return v19.CanDoTUnit(v60, v61);
	end;
	do
		local v62 = v15.Rogue.Assassination;
		local v63 = v15.Rogue.Subtlety;
		local function v64()
			local v117 = 771 - (720 + 51);
			while true do
				if (((4789 - 2636) == (3929 - (421 + 1355))) and (v117 == (0 - 0))) then
					if ((v62.Nightstalker:IsAvailable() and v12:StealthUp(true, false, true)) or ((250 + 257) >= (3674 - (286 + 797)))) then
						return (3 - 2) + ((0.05 - 0) * v62.Nightstalker:TalentRank());
					end
					return 440 - (397 + 42);
				end
			end
		end
		local function v65()
			local v118 = 0 + 0;
			while true do
				if (((5281 - (24 + 776)) == (6903 - 2422)) and (v118 == (785 - (222 + 563)))) then
					if ((v62.ImprovedGarrote:IsAvailable() and (v12:BuffUp(v62.ImprovedGarroteAura, nil, true) or v12:BuffUp(v62.ImprovedGarroteBuff, nil, true) or v12:BuffUp(v62.SepsisBuff, nil, true))) or ((5129 - 2801) < (499 + 194))) then
						return 191.5 - (23 + 167);
					end
					return 1799 - (690 + 1108);
				end
			end
		end
		v62.Rupture:RegisterPMultiplier(v64, {v63.FinalityRuptureBuff,(849.3 - (40 + 808))});
		v62.Garrote:RegisterPMultiplier(v64, v65);
		v62.CrimsonTempest:RegisterPMultiplier(v64);
	end
	do
		local v66 = v15(31864 + 161667);
		local v67 = v15(1507885 - 1113564);
		local v68 = v15(376882 + 17438);
		v29.CPMaxSpend = function()
			return 3 + 2 + ((v66:IsAvailable() and (1 + 0)) or (571 - (47 + 524))) + ((v67:IsAvailable() and (1 + 0)) or (0 - 0)) + ((v68:IsAvailable() and (1 - 0)) or (0 - 0));
		end;
	end
	v29.CPSpend = function()
		return v21(v12:ComboPoints(), v29.CPMaxSpend());
	end;
	do
		local v70 = 1726 - (1165 + 561);
		while true do
			if (((129 + 4199) == (13404 - 9076)) and (v70 == (0 + 0))) then
				v29.AnimachargedCP = function()
					local v170 = 479 - (341 + 138);
					while true do
						if (((429 + 1159) >= (2748 - 1416)) and (v170 == (326 - (89 + 237)))) then
							if (v12:BuffUp(v15.Rogue.Commons.EchoingReprimand2) or ((13427 - 9253) > (8943 - 4695))) then
								return 883 - (581 + 300);
							elseif (v12:BuffUp(v15.Rogue.Commons.EchoingReprimand3) or ((5806 - (855 + 365)) <= (194 - 112))) then
								return 1 + 2;
							elseif (((5098 - (1030 + 205)) == (3627 + 236)) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand4)) then
								return 4 + 0;
							elseif (v12:BuffUp(v15.Rogue.Commons.EchoingReprimand5) or ((568 - (156 + 130)) <= (95 - 53))) then
								return 8 - 3;
							end
							return -(1 - 0);
						end
					end
				end;
				v29.EffectiveComboPoints = function(v171)
					local v172 = 0 + 0;
					while true do
						if (((2688 + 1921) >= (835 - (10 + 59))) and (v172 == (0 + 0))) then
							if (((v171 == (9 - 7)) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand2)) or ((v171 == (1166 - (671 + 492))) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand3)) or ((v171 == (4 + 0)) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand4)) or ((v171 == (1220 - (369 + 846))) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand5)) or ((305 + 847) == (2124 + 364))) then
								return 1952 - (1036 + 909);
							end
							return v171;
						end
					end
				end;
				break;
			end
		end
	end
	do
		local v71 = v15.Rogue.Assassination.DeadlyPoisonDebuff;
		local v72 = v15.Rogue.Assassination.WoundPoisonDebuff;
		local v73 = v15.Rogue.Assassination.AmplifyingPoisonDebuff;
		local v74 = v15.Rogue.Assassination.CripplingPoisonDebuff;
		local v75 = v15.Rogue.Assassination.AtrophicPoisonDebuff;
		v29.Poisoned = function(v119)
			return ((v119:DebuffUp(v71) or v119:DebuffUp(v73) or v119:DebuffUp(v74) or v119:DebuffUp(v72) or v119:DebuffUp(v75)) and true) or false;
		end;
	end
	do
		local v77 = 0 + 0;
		local v78;
		local v79;
		local v80;
		local v81;
		local v82;
		local v83;
		while true do
			if (((5744 - 2322) > (3553 - (11 + 192))) and (v77 == (2 + 0))) then
				v82 = v15.Rogue.Assassination.InternalBleeding;
				v83 = 175 - (135 + 40);
				v77 = 6 - 3;
			end
			if (((529 + 348) > (827 - 451)) and (v77 == (0 - 0))) then
				v78 = v15.Rogue.Assassination.Garrote;
				v79 = v15.Rogue.Assassination.GarroteDeathmark;
				v77 = 177 - (50 + 126);
			end
			if ((v77 == (2 - 1)) or ((691 + 2427) <= (3264 - (1233 + 180)))) then
				v80 = v15.Rogue.Assassination.Rupture;
				v81 = v15.Rogue.Assassination.RuptureDeathmark;
				v77 = 971 - (522 + 447);
			end
			if ((v77 == (1424 - (107 + 1314))) or ((77 + 88) >= (10640 - 7148))) then
				v29.PoisonedBleeds = function()
					v83 = 0 + 0;
					for v200, v201 in v22(v12:GetEnemiesInRange(99 - 49)) do
						if (((15624 - 11675) < (6766 - (716 + 1194))) and v29.Poisoned(v201)) then
							if (v201:DebuffUp(v78) or ((74 + 4202) < (324 + 2692))) then
								v83 = v83 + (504 - (74 + 429));
								if (((9047 - 4357) > (2045 + 2080)) and v201:DebuffUp(v79)) then
									v83 = v83 + (2 - 1);
								end
							end
							if (v201:DebuffUp(v80) or ((36 + 14) >= (2761 - 1865))) then
								local v231 = 0 - 0;
								while true do
									if (((433 - (279 + 154)) == v231) or ((2492 - (454 + 324)) >= (2328 + 630))) then
										v83 = v83 + (18 - (12 + 5));
										if (v201:DebuffUp(v81) or ((804 + 687) < (1640 - 996))) then
											v83 = v83 + 1 + 0;
										end
										break;
									end
								end
							end
							if (((1797 - (277 + 816)) < (4217 - 3230)) and v201:DebuffUp(v82)) then
								v83 = v83 + (1184 - (1058 + 125));
							end
						end
					end
					return v83;
				end;
				break;
			end
		end
	end
	do
		local v84 = v28();
		v29.RtBRemains = function(v120)
			local v121 = 0 + 0;
			local v122;
			while true do
				if (((4693 - (815 + 160)) > (8177 - 6271)) and ((0 - 0) == v121)) then
					v122 = (v84 - v28()) - v9.RecoveryOffset(v120);
					return ((v122 >= (0 + 0)) and v122) or (0 - 0);
				end
			end
		end;
		v9:RegisterForSelfCombatEvent(function(v123, v123, v123, v123, v123, v123, v123, v123, v123, v123, v123, v124)
			if ((v124 == (317406 - (41 + 1857))) or ((2851 - (1222 + 671)) > (9394 - 5759))) then
				v84 = v28() + (43 - 13);
			end
		end, "SPELL_AURA_APPLIED");
		v9:RegisterForSelfCombatEvent(function(v125, v125, v125, v125, v125, v125, v125, v125, v125, v125, v125, v126)
			if (((4683 - (229 + 953)) <= (6266 - (1111 + 663))) and (v126 == (317087 - (874 + 705)))) then
				v84 = v28() + v21(6 + 34, 21 + 9 + v29.RtBRemains(true));
			end
		end, "SPELL_AURA_REFRESH");
		v9:RegisterForSelfCombatEvent(function(v127, v127, v127, v127, v127, v127, v127, v127, v127, v127, v127, v128)
			if ((v128 == (655826 - 340318)) or ((97 + 3345) < (3227 - (642 + 37)))) then
				v84 = v28();
			end
		end, "SPELL_AURA_REMOVED");
	end
	do
		local v86 = {CrimsonTempest={},Garrote={},Rupture={}};
		v29.Exsanguinated = function(v129, v130)
			local v131 = v129:GUID();
			if (((656 + 2219) >= (235 + 1229)) and not v131) then
				return false;
			end
			local v132 = v130:ID();
			if ((v132 == (304838 - 183427)) or ((5251 - (233 + 221)) >= (11314 - 6421))) then
				return v86.CrimsonTempest[v131] or false;
			elseif ((v132 == (619 + 84)) or ((2092 - (718 + 823)) > (1302 + 766))) then
				return v86.Garrote[v131] or false;
			elseif (((2919 - (266 + 539)) > (2672 - 1728)) and (v132 == (3168 - (636 + 589)))) then
				return v86.Rupture[v131] or false;
			end
			return false;
		end;
		v29.WillLoseExsanguinate = function(v133, v134)
			local v135 = 0 - 0;
			while true do
				if ((v135 == (0 - 0)) or ((1793 + 469) >= (1125 + 1971))) then
					if (v29.Exsanguinated(v133, v134) or ((3270 - (657 + 358)) >= (9364 - 5827))) then
						return true;
					end
					return false;
				end
			end
		end;
		v29.ExsanguinatedRate = function(v136, v137)
			local v138 = 0 - 0;
			while true do
				if ((v138 == (1187 - (1151 + 36))) or ((3706 + 131) < (344 + 962))) then
					if (((8809 - 5859) == (4782 - (1552 + 280))) and v29.Exsanguinated(v136, v137)) then
						return 836 - (64 + 770);
					end
					return 1 + 0;
				end
			end
		end;
		v9:RegisterForSelfCombatEvent(function(v139, v139, v139, v139, v139, v139, v139, v140, v139, v139, v139, v141)
			if ((v141 == (455842 - 255036)) or ((839 + 3884) < (4541 - (157 + 1086)))) then
				for v173, v174 in v22(v86) do
					for v202, v203 in v22(v174) do
						if (((2273 - 1137) >= (674 - 520)) and (v202 == v140)) then
							v174[v202] = true;
						end
					end
				end
			end
		end, "SPELL_CAST_SUCCESS");
		v9:RegisterForSelfCombatEvent(function(v142, v142, v142, v142, v142, v142, v142, v143, v142, v142, v142, v144)
			if ((v144 == (186242 - 64831)) or ((369 - 98) > (5567 - (599 + 220)))) then
				v86.CrimsonTempest[v143] = false;
			elseif (((9439 - 4699) >= (5083 - (1813 + 118))) and (v144 == (514 + 189))) then
				v86.Garrote[v143] = false;
			elseif ((v144 == (3160 - (841 + 376))) or ((3612 - 1034) >= (788 + 2602))) then
				v86.Rupture[v143] = false;
			end
		end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
		v9:RegisterForSelfCombatEvent(function(v145, v145, v145, v145, v145, v145, v145, v146, v145, v145, v145, v147)
			if (((111 - 70) <= (2520 - (464 + 395))) and (v147 == (311588 - 190177))) then
				if (((289 + 312) < (4397 - (467 + 370))) and (v86.CrimsonTempest[v146] ~= nil)) then
					v86.CrimsonTempest[v146] = nil;
				end
			elseif (((485 - 250) < (505 + 182)) and (v147 == (2409 - 1706))) then
				if (((710 + 3839) > (2682 - 1529)) and (v86.Garrote[v146] ~= nil)) then
					v86.Garrote[v146] = nil;
				end
			elseif ((v147 == (2463 - (150 + 370))) or ((5956 - (74 + 1208)) < (11490 - 6818))) then
				if (((17395 - 13727) < (3246 + 1315)) and (v86.Rupture[v146] ~= nil)) then
					v86.Rupture[v146] = nil;
				end
			end
		end, "SPELL_AURA_REMOVED");
		v9:RegisterForCombatEvent(function(v148, v148, v148, v148, v148, v148, v148, v149)
			local v150 = 390 - (14 + 376);
			while true do
				if ((v150 == (1 - 0)) or ((295 + 160) == (3167 + 438))) then
					if ((v86.Rupture[v149] ~= nil) or ((2540 + 123) == (9704 - 6392))) then
						v86.Rupture[v149] = nil;
					end
					break;
				end
				if (((3218 + 1059) <= (4553 - (23 + 55))) and (v150 == (0 - 0))) then
					if ((v86.CrimsonTempest[v149] ~= nil) or ((581 + 289) == (1068 + 121))) then
						v86.CrimsonTempest[v149] = nil;
					end
					if (((2407 - 854) <= (986 + 2147)) and (v86.Garrote[v149] ~= nil)) then
						v86.Garrote[v149] = nil;
					end
					v150 = 902 - (652 + 249);
				end
			end
		end, "UNIT_DIED", "UNIT_DESTROYED");
	end
	do
		local v90 = 0 - 0;
		local v91;
		local v92;
		local v93;
		while true do
			if (((1870 - (708 + 1160)) == v90) or ((6072 - 3835) >= (6401 - 2890))) then
				v9:RegisterForSelfCombatEvent(function(v175, v175, v175, v175, v175, v175, v175, v175, v175, v175, v175, v176, v175, v175, v177, v178)
					if ((v176 == (185790 - (10 + 17))) or ((298 + 1026) > (4752 - (1400 + 332)))) then
						if (((v28() - v93) > (0.5 - 0)) or ((4900 - (242 + 1666)) == (805 + 1076))) then
							local v229 = 0 + 0;
							while true do
								if (((2648 + 458) > (2466 - (850 + 90))) and (v229 == (0 - 0))) then
									v92 = v21(v29.CPMaxSpend(), v12:ComboPoints() + v177 + (v24(1390 - (360 + 1030), v177 - (1 + 0)) * v21(5 - 3, v12:BuffStack(v91) - (1 - 0))));
									v93 = v28();
									break;
								end
							end
						end
					end
				end, "SPELL_ENERGIZE");
				break;
			end
			if (((4684 - (909 + 752)) < (5093 - (109 + 1114))) and (v90 == (1 - 0))) then
				v93 = v28();
				v29.FanTheHammerCP = function()
					if (((56 + 87) > (316 - (6 + 236))) and ((v28() - v93) < (0.5 + 0)) and (v92 > (0 + 0))) then
						if (((42 - 24) < (3688 - 1576)) and (v92 > v12:ComboPoints())) then
							return v92;
						else
							v92 = 1133 - (1076 + 57);
						end
					end
					return 0 + 0;
				end;
				v90 = 691 - (579 + 110);
			end
			if (((87 + 1010) <= (1440 + 188)) and (v90 == (0 + 0))) then
				v91 = v15(196034 - (174 + 233));
				v92 = 0 - 0;
				v90 = 1 - 0;
			end
		end
	end
	do
		local v94 = 0 + 0;
		local v95;
		local v96;
		local v97;
		while true do
			if (((5804 - (663 + 511)) == (4131 + 499)) and ((0 + 0) == v94)) then
				v95, v96 = 0 - 0, 0 + 0;
				v97 = v15(654323 - 376398);
				v94 = 2 - 1;
			end
			if (((1690 + 1850) > (5221 - 2538)) and (v94 == (1 + 0))) then
				v29.TimeToNextTornado = function()
					if (((439 + 4355) >= (3997 - (478 + 244))) and not v12:BuffUp(v97, nil, true)) then
						return 517 - (440 + 77);
					end
					local v179 = v12:BuffRemains(v97, nil, true) % (1 + 0);
					if (((5431 - 3947) == (3040 - (655 + 901))) and (v28() == v95)) then
						return 0 + 0;
					elseif (((1097 + 335) < (2401 + 1154)) and ((v28() - v95) < (0.1 - 0)) and (v179 < (1445.25 - (695 + 750)))) then
						return 3 - 2;
					elseif ((((v179 > (0.9 - 0)) or (v179 == (0 - 0))) and ((v28() - v95) > (351.75 - (285 + 66)))) or ((2482 - 1417) > (4888 - (682 + 628)))) then
						return 0.1 + 0;
					end
					return v179;
				end;
				v9:RegisterForSelfCombatEvent(function(v180, v180, v180, v180, v180, v180, v180, v180, v180, v180, v180, v181)
					if ((v181 == (213042 - (176 + 123))) or ((2006 + 2789) < (1021 + 386))) then
						v95 = v28();
					elseif (((2122 - (239 + 30)) < (1309 + 3504)) and (v181 == (190148 + 7687))) then
						v96 = v28();
					end
					if ((v96 == v95) or ((4992 - 2171) < (7584 - 5153))) then
						v95 = 315 - (306 + 9);
					end
				end, "SPELL_CAST_SUCCESS");
				break;
			end
		end
	end
	do
		local v98 = 0 - 0;
		local v99;
		while true do
			if ((v98 == (0 + 0)) or ((1764 + 1110) < (1050 + 1131))) then
				v99 = {Counter=(0 - 0),LastMH=(1375 - (1140 + 235)),LastOH=(0 + 0)};
				v29.TimeToSht = function(v182)
					local v183 = 0 + 0;
					local v184;
					local v185;
					local v186;
					local v187;
					local v188;
					local v189;
					while true do
						if ((v183 == (1 + 1)) or ((2741 - (33 + 19)) <= (124 + 219))) then
							v188 = {};
							for v230 = 0 - 0, 1 + 1 do
								v26(v188, v186 + (v230 * v184));
								v26(v188, v187 + (v230 * v185));
							end
							v183 = 5 - 2;
						end
						if ((v183 == (0 + 0)) or ((2558 - (586 + 103)) == (183 + 1826))) then
							if ((v99.Counter >= v182) or ((10916 - 7370) < (3810 - (1309 + 179)))) then
								return 0 - 0;
							end
							v184, v185 = v27("player");
							v183 = 1 + 0;
						end
						if ((v183 == (2 - 1)) or ((1573 + 509) == (10140 - 5367))) then
							v186 = v24(v99.LastMH + v184, v28());
							v187 = v24(v99.LastOH + v185, v28());
							v183 = 3 - 1;
						end
						if (((3853 - (295 + 314)) > (2591 - 1536)) and (v183 == (1965 - (1300 + 662)))) then
							table.sort(v188);
							v189 = v21(15 - 10, v24(1756 - (1178 + 577), v182 - v99.Counter));
							v183 = 3 + 1;
						end
						if ((v183 == (11 - 7)) or ((4718 - (851 + 554)) <= (1573 + 205))) then
							return v188[v189] - v28();
						end
					end
				end;
				v98 = 2 - 1;
			end
			if ((v98 == (3 - 1)) or ((1723 - (115 + 187)) >= (1612 + 492))) then
				v9:RegisterForSelfCombatEvent(function(v190, v190, v190, v190, v190, v190, v190, v190, v190, v190, v190, v190, v190, v190, v190, v190, v190, v190, v190, v190, v190, v190, v190, v191)
					v99.Counter = v99.Counter + 1 + 0;
					if (((7140 - 5328) <= (4410 - (160 + 1001))) and v191) then
						v99.LastOH = v28();
					else
						v99.LastMH = v28();
					end
				end, "SWING_DAMAGE");
				v9:RegisterForSelfCombatEvent(function(v193, v193, v193, v193, v193, v193, v193, v193, v193, v193, v193, v193, v193, v193, v193, v194)
					if (((1420 + 203) <= (1351 + 606)) and v194) then
						v99.LastOH = v28();
					else
						v99.LastMH = v28();
					end
				end, "SWING_MISSED");
				break;
			end
			if (((9031 - 4619) == (4770 - (237 + 121))) and ((898 - (525 + 372)) == v98)) then
				v9:RegisterForSelfCombatEvent(function()
					v99.Counter = 0 - 0;
					v99.LastMH = v28();
					v99.LastOH = v28();
				end, "PLAYER_ENTERING_WORLD");
				v9:RegisterForSelfCombatEvent(function(v198, v198, v198, v198, v198, v198, v198, v198, v198, v198, v198, v199)
					if (((5749 - 3999) >= (984 - (96 + 46))) and (v199 == (197688 - (643 + 134)))) then
						v99.Counter = 0 + 0;
					end
				end, "SPELL_ENERGIZE");
				v98 = 4 - 2;
			end
		end
	end
	do
		local v100 = v12:CritChancePct();
		local v101 = 0 - 0;
		local function v102()
			local v151 = 0 + 0;
			while true do
				if (((8579 - 4207) > (3781 - 1931)) and (v151 == (720 - (316 + 403)))) then
					if (((155 + 77) < (2257 - 1436)) and (v101 > (0 + 0))) then
						v23.After(7 - 4, v102);
					end
					break;
				end
				if (((368 + 150) < (291 + 611)) and (v151 == (0 - 0))) then
					if (((14298 - 11304) > (1782 - 924)) and not v12:AffectingCombat()) then
						local v220 = 0 + 0;
						while true do
							if ((v220 == (0 - 0)) or ((184 + 3571) <= (2692 - 1777))) then
								v100 = v12:CritChancePct();
								v9.Debug("Base Crit Set to: " .. v100);
								break;
							end
						end
					end
					if (((3963 - (12 + 5)) > (14537 - 10794)) and ((v101 == nil) or (v101 < (0 - 0)))) then
						v101 = 0 - 0;
					else
						v101 = v101 - (2 - 1);
					end
					v151 = 1 + 0;
				end
			end
		end
		v9:RegisterForEvent(function()
			if ((v101 == (1973 - (1656 + 317))) or ((1190 + 145) >= (2650 + 656))) then
				local v169 = 0 - 0;
				while true do
					if (((23839 - 18995) > (2607 - (5 + 349))) and (v169 == (0 - 0))) then
						v23.After(1274 - (266 + 1005), v102);
						v101 = 2 + 0;
						break;
					end
				end
			end
		end, "PLAYER_EQUIPMENT_CHANGED");
		v29.BaseAttackCrit = function()
			return v100;
		end;
	end
	do
		local v104 = v15.Rogue.Assassination;
		local v105 = v15.Rogue.Subtlety;
		local function v106()
			local v152 = 0 - 0;
			while true do
				if (((594 - 142) == (2148 - (561 + 1135))) and (v152 == (0 - 0))) then
					if ((v104.Nightstalker:IsAvailable() and v12:StealthUp(true, false, true)) or ((14979 - 10422) < (3153 - (507 + 559)))) then
						return (2 - 1) + ((0.05 - 0) * v104.Nightstalker:TalentRank());
					end
					return 389 - (212 + 176);
				end
			end
		end
		local function v107()
			if (((4779 - (250 + 655)) == (10563 - 6689)) and v104.ImprovedGarrote:IsAvailable() and (v12:BuffUp(v104.ImprovedGarroteAura, nil, true) or v12:BuffUp(v104.ImprovedGarroteBuff, nil, true) or v12:BuffUp(v104.SepsisBuff, nil, true))) then
				return 1.5 - 0;
			end
			return 1 - 0;
		end
		v104.Rupture:RegisterPMultiplier(v106, {v105.FinalityRuptureBuff,(1902.3 - (484 + 1417))});
		v104.Garrote:RegisterPMultiplier(v106, v107);
	end
end;
return v0["Epix_Rogue_Rogue.lua"]();

