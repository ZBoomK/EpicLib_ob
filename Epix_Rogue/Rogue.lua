local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((9832 - 5319) > (4173 - 1447)) and (v5 == (1 + 0))) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((5063 - 3582) >= (3676 - (697 + 321)))) then
			v6 = v0[v4];
			if (not v6 or ((8771 - 5551) == (2889 - 1525))) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
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
	if (not v16.Rogue or ((411 + 643) > (6355 - 2963))) then
		v16.Rogue = {};
	end
	v16.Rogue.Commons = {Sanguine=v16(607208 - 380698, nil, 1228 - (322 + 905)),AncestralCall=v16(275349 - (602 + 9), nil, 1191 - (449 + 740)),ArcanePulse=v16(261236 - (826 + 46), nil, 950 - (245 + 702)),ArcaneTorrent=v16(79144 - 54098, nil, 2 + 2),BagofTricks=v16(314309 - (260 + 1638), nil, 445 - (382 + 58)),Berserking=v16(84362 - 58065, nil, 5 + 1),BloodFury=v16(42515 - 21943, nil, 20 - 13),Fireblood=v16(266426 - (902 + 303), nil, 17 - 9),LightsJudgment=v16(615726 - 360079, nil, 1 + 8),Shadowmeld=v16(60674 - (1121 + 569), nil, 224 - (22 + 192)),CloakofShadows=v16(31907 - (483 + 200), nil, 1474 - (1404 + 59)),CrimsonVial=v16(507147 - 321836, nil, 15 - 3),Evasion=v16(6042 - (468 + 297), nil, 575 - (334 + 228)),Feint=v16(6631 - 4665, nil, 32 - 18),Blind=v16(3797 - 1703, nil, 5 + 10),CheapShot=v16(2069 - (141 + 95), nil, 16 + 0),Kick=v16(4545 - 2779, nil, 40 - 23),KidneyShot=v16(96 + 312, nil, 49 - 31),Sap=v16(4760 + 2010, nil, 10 + 9),Shiv=v16(8361 - 2423, nil, 12 + 8),SliceandDice=v16(315659 - (92 + 71), nil, 11 + 10),Shadowstep=v16(61457 - 24903, nil, 787 - (574 + 191)),Sprint=v16(2461 + 522, nil, 57 - 34),TricksoftheTrade=v16(29593 + 28341, nil, 873 - (254 + 595)),CripplingPoison=v16(3534 - (55 + 71), nil, 32 - 7),DeadlyPoison=v16(4613 - (573 + 1217), nil, 71 - 45),InstantPoison=v16(24012 + 291572, nil, 42 - 15),AmplifyingPoison=v16(382603 - (714 + 225), nil, 81 - 53),NumbingPoison=v16(8031 - 2270, nil, 4 + 25),WoundPoison=v16(12566 - 3887, nil, 836 - (118 + 688)),AtrophicPoison=v16(381685 - (25 + 23), nil, 7 + 24),AcrobaticStrikes=v16(198810 - (927 + 959), nil, 107 - 75),Alacrity=v16(194271 - (16 + 716), nil, 63 - 30),ColdBlood=v16(382342 - (11 + 86), nil, 82 - 48),DeeperStratagem=v16(193816 - (175 + 110)),EchoingReprimand=v16(973601 - 587985, nil, 177 - 141),EchoingReprimand2=v16(325354 - (503 + 1293), nil, 103 - 66),EchoingReprimand3=v16(233986 + 89573, nil, 1099 - (810 + 251)),EchoingReprimand4=v16(224544 + 99016, nil, 12 + 27),EchoingReprimand5=v16(319870 + 34968, nil, 573 - (43 + 490)),FindWeakness=v16(91756 - (711 + 22), nil, 158 - 117),FindWeaknessDebuff=v16(317079 - (240 + 619), nil, 11 + 31),ImprovedAmbush=v16(607044 - 225424, nil, 3 + 40),MarkedforDeath=v16(139363 - (1344 + 400), nil, 449 - (255 + 150)),Nightstalker=v16(11077 + 2985, nil, 25 + 20),ResoundingClarity=v16(1630510 - 1248888, nil, 148 - 102),SealFate=v16(15929 - (404 + 1335), nil, 453 - (183 + 223)),Sepsis=v16(468988 - 83580, nil, 32 + 16),SepsisBuff=v16(135292 + 240647, nil, 386 - (10 + 327)),ShadowDance=v16(129050 + 56263, nil, 388 - (118 + 220)),ShadowDanceTalent=v16(131612 + 263318, nil, 500 - (108 + 341)),ShadowDanceBuff=v16(83280 + 102142),Subterfuge=v16(457482 - 349274, nil, 1546 - (711 + 782)),SubterfugeBuff=v16(220826 - 105634, nil, 523 - (270 + 199)),ThistleTea=v16(123718 + 257905, nil, 2139 - (580 + 1239)),Vigor=v16(44541 - 29558),Stealth=v16(1706 + 78, nil, 3 + 54),Stealth2=v16(50180 + 65011, nil, 151 - 93),Vanish=v16(1154 + 702, nil, 1226 - (645 + 522)),VanishBuff=v16(13117 - (1010 + 780), nil, 60 + 0),VanishBuff2=v16(548769 - 433576, nil, 178 - 117),PoolEnergy=v16(1001746 - (1045 + 791), nil, 156 - 94)};
	v16.Rogue.Assassination = v19(v16.Rogue.Commons, {Ambush=v16(13247 - 4571, nil, 568 - (351 + 154)),AmplifyingPoisonDebuff=v16(384988 - (1281 + 293), nil, 330 - (28 + 238)),AmplifyingPoisonDebuffDeathmark=v16(881115 - 486787, nil, 1624 - (1381 + 178)),CripplingPoisonDebuff=v16(3198 + 211, nil, 54 + 12),DeadlyPoisonDebuff=v16(1203 + 1615, nil, 230 - 163),DeadlyPoisonDebuffDeathmark=v16(204285 + 190039, nil, 538 - (381 + 89)),Envenom=v16(28950 + 3695, nil, 47 + 22),FanofKnives=v16(88600 - 36877, nil, 1226 - (1074 + 82)),Garrote=v16(1540 - 837, nil, 1855 - (214 + 1570)),GarroteDeathmark=v16(362285 - (990 + 465), nil, 30 + 42),Mutilate=v16(579 + 750, nil, 71 + 2),PoisonedKnife=v16(730296 - 544731, nil, 1800 - (1668 + 58)),Rupture=v16(2569 - (512 + 114), nil, 195 - 120),RuptureDeathmark=v16(745950 - 385124, nil, 264 - 188),WoundPoisonDebuff=v16(4039 + 4641, nil, 15 + 62),ArterialPrecision=v16(348415 + 52368, nil, 263 - 185),AtrophicPoisonDebuff=v16(394382 - (109 + 1885), nil, 1548 - (1269 + 200)),BlindsideBuff=v16(232214 - 111061, nil, 895 - (98 + 717)),CrimsonTempest=v16(122237 - (802 + 24), nil, 139 - 58),CutToTheChase=v16(65252 - 13585, nil, 13 + 69),DashingScoundrel=v16(293344 + 88453, nil, 14 + 69),Deathmark=v16(77697 + 282497, nil, 233 - 149),Doomblade=v16(1272788 - 891115, nil, 31 + 54),DragonTemperedBlades=v16(155417 + 226384, nil, 71 + 15),Elusiveness=v16(57450 + 21558),Exsanguinate=v16(93754 + 107052, nil, 1521 - (797 + 636)),ImprovedGarrote=v16(1852961 - 1471329, nil, 1708 - (1427 + 192)),ImprovedGarroteBuff=v16(135964 + 256437, nil, 208 - 118),ImprovedGarroteAura=v16(352718 + 39685, nil, 42 + 49),IndiscriminateCarnage=v16(382128 - (192 + 134), nil, 1368 - (316 + 960)),IndiscriminateCarnageBuff=v16(214667 + 171080),InternalBleeding=v16(119580 + 35373, nil, 86 + 7),Kingsbane=v16(1474254 - 1088627, nil, 645 - (83 + 468)),LightweightShiv=v16(396789 - (1202 + 604)),MasterAssassin=v16(1195006 - 939017, nil, 157 - 62),MasterAssassinBuff=v16(710832 - 454097, nil, 421 - (45 + 280)),PreyontheWeak=v16(126934 + 4577, nil, 85 + 12),PreyontheWeakDebuff=v16(93443 + 162466, nil, 55 + 43),SerratedBoneSpike=v16(67793 + 317631, nil, 182 - 83),SerratedBoneSpikeDebuff=v16(395947 - (340 + 1571), nil, 40 + 60),ShivDebuff=v16(321276 - (1733 + 39), nil, 277 - 176),VenomRush=v16(153186 - (125 + 909), nil, 2050 - (1096 + 852)),ScentOfBlood=v16(171266 + 210533, nil, 564 - 168),ScentOfBloodBuff=v16(382231 + 11849),ShroudedSuffocation=v16(385990 - (409 + 103))});
	v16.Rogue.Outlaw = v19(v16.Rogue.Commons, {AdrenalineRush=v16(13986 - (46 + 190), nil, 198 - (51 + 44)),Ambush=v16(2447 + 6229, nil, 1421 - (1114 + 203)),AmbushOverride=v16(430749 - (228 + 498)),BetweentheEyes=v16(68320 + 247021, nil, 59 + 46),BladeFlurry=v16(14540 - (174 + 489), nil, 275 - 169),Dispatch=v16(4003 - (830 + 1075), nil, 631 - (303 + 221)),Elusiveness=v16(80277 - (231 + 1038)),Opportunity=v16(163018 + 32609),PistolShot=v16(186925 - (171 + 991), nil, 453 - 343),RolltheBones=v16(847202 - 531694, nil, 276 - 165),SinisterStrike=v16(154719 + 38596, nil, 392 - 280),Audacity=v16(1101548 - 719703, nil, 181 - 68),AudacityBuff=v16(1194070 - 807800, nil, 1362 - (111 + 1137)),BladeRush=v16(272035 - (91 + 67), nil, 342 - 227),CountTheOdds=v16(95307 + 286675, nil, 639 - (423 + 100)),Dreadblades=v16(2409 + 340733, nil, 323 - 206),FanTheHammer=v16(199027 + 182819, nil, 889 - (326 + 445)),GhostlyStrike=v16(859427 - 662490, nil, 264 - 145),GreenskinsWickers=v16(902932 - 516109, nil, 831 - (530 + 181)),GreenskinsWickersBuff=v16(395012 - (614 + 267), nil, 153 - (19 + 13)),HiddenOpportunity=v16(623833 - 240552, nil, 283 - 161),ImprovedAdrenalineRush=v16(1129565 - 734143, nil, 32 + 91),ImprovedBetweenTheEyes=v16(414140 - 178656, nil, 256 - 132),KeepItRolling=v16(383801 - (1293 + 519), nil, 255 - 130),KillingSpree=v16(134960 - 83270, nil, 240 - 114),LoadedDice=v16(1104632 - 848462, nil, 299 - 172),LoadedDiceBuff=v16(135679 + 120492, nil, 27 + 101),PreyontheWeak=v16(305567 - 174056, nil, 30 + 99),PreyontheWeakDebuff=v16(85015 + 170894, nil, 82 + 48),QuickDraw=v16(198034 - (709 + 387), nil, 1989 - (673 + 1185)),SummarilyDispatched=v16(1107825 - 725835, nil, 423 - 291),SwiftSlasher=v16(628500 - 246512, nil, 96 + 37),TakeEmBySurpriseBuff=v16(288350 + 97557, nil, 180 - 46),Weaponmaster=v16(49301 + 151432, nil, 269 - 134),UnderhandedUpperhand=v16(832410 - 408366),DeftManeuvers=v16(383758 - (446 + 1434)),Crackshot=v16(424986 - (1040 + 243)),Gouge=v16(5300 - 3524, nil, 1983 - (559 + 1288)),Broadside=v16(195287 - (609 + 1322), nil, 591 - (13 + 441)),BuriedTreasure=v16(745872 - 546272, nil, 361 - 223),GrandMelee=v16(963008 - 769650, nil, 6 + 133),RuthlessPrecision=v16(702234 - 508877, nil, 50 + 90),SkullandCrossbones=v16(87463 + 112140, nil, 418 - 277),TrueBearing=v16(105808 + 87551, nil, 260 - 118),ViciousFollowup=v16(261059 + 133820, nil, 80 + 63)});
	v16.Rogue.Subtlety = v19(v16.Rogue.Commons, {Backstab=v16(39 + 14, nil, 121 + 23),BlackPowder=v16(312277 + 6898, nil, 578 - (153 + 280)),Elusiveness=v16(228143 - 149135),Eviscerate=v16(176704 + 20115, nil, 59 + 88),Rupture=v16(1017 + 926, nil, 135 + 13),ShadowBlades=v16(88019 + 33452, nil, 226 - 77),Shadowstrike=v16(114612 + 70826, nil, 817 - (89 + 578)),ShurikenStorm=v16(141327 + 56508, nil, 313 - 162),ShurikenToss=v16(115063 - (572 + 477), nil, 21 + 131),SymbolsofDeath=v16(127397 + 84886, nil, 19 + 134),DanseMacabre=v16(382614 - (84 + 2), nil, 253 - 99),DanseMacabreBuff=v16(283821 + 110148, nil, 997 - (497 + 345)),DeeperDaggers=v16(9787 + 372730, nil, 27 + 129),DeeperDaggersBuff=v16(384738 - (605 + 728), nil, 113 + 44),DarkBrew=v16(850413 - 467909, nil, 8 + 150),DarkShadow=v16(908362 - 662675, nil, 144 + 15),EnvelopingShadows=v16(659699 - 421595, nil, 121 + 39),Finality=v16(383014 - (457 + 32), nil, 69 + 92),FinalityBlackPowderBuff=v16(387350 - (832 + 570), nil, 153 + 9),FinalityEviscerateBuff=v16(100646 + 285303, nil, 576 - 413),FinalityRuptureBuff=v16(185914 + 200037, nil, 960 - (588 + 208)),Flagellation=v16(1036669 - 652038, nil, 1965 - (884 + 916)),FlagellationPersistBuff=v16(826457 - 431699, nil, 97 + 69),Gloomblade=v16(201411 - (232 + 421), nil, 2056 - (1569 + 320)),GoremawsBite=v16(104661 + 321930),ImprovedShadowDance=v16(74849 + 319123, nil, 565 - 397),ImprovedShurikenStorm=v16(320556 - (316 + 289), nil, 441 - 272),InvigoratingShadowdust=v16(17666 + 364857),LingeringShadow=v16(383977 - (666 + 787), nil, 595 - (360 + 65)),LingeringShadowBuff=v16(360705 + 25255, nil, 425 - (79 + 175)),MasterofShadows=v16(310598 - 113622, nil, 135 + 37),PerforatedVeins=v16(1172523 - 790005, nil, 333 - 160),PerforatedVeinsBuff=v16(395153 - (503 + 396), nil, 355 - (92 + 89)),PreyontheWeak=v16(255125 - 123614, nil, 90 + 85),PreyontheWeakDebuff=v16(151459 + 104450, nil, 689 - 513),Premeditation=v16(46928 + 296232, nil, 403 - 226),PremeditationBuff=v16(299416 + 43757, nil, 86 + 92),SecretStratagem=v16(1200969 - 806649, nil, 23 + 156),SecretTechnique=v16(428100 - 147381, nil, 1424 - (485 + 759)),Shadowcraft=v16(987088 - 560494),ShadowFocus=v16(109398 - (442 + 747), nil, 1316 - (832 + 303)),ShurikenTornado=v16(278871 - (88 + 858), nil, 56 + 126),SilentStorm=v16(319224 + 66498, nil, 8 + 175),SilentStormBuff=v16(386511 - (766 + 23), nil, 908 - 724),TheFirstDance=v16(523135 - 140630, nil, 487 - 302),TheRotten=v16(1296572 - 914557, nil, 1259 - (1036 + 37)),TheRottenBuff=v16(279481 + 114722, nil, 363 - 176),Weaponmaster=v16(152243 + 41294, nil, 1668 - (641 + 839))});
	if (not v18.Rogue or ((1589 - (910 + 3)) >= (4185 - 2543))) then
		v18.Rogue = {};
	end
	v18.Rogue.Commons = {AlgetharPuzzleBox=v18(195385 - (1466 + 218), {(1161 - (556 + 592)),(822 - (329 + 479))}),ManicGrieftorch=v18(195162 - (174 + 680), {(26 - 13),(753 - (396 + 343))}),WindscarWhetstone=v18(12165 + 125321, {(1402 - (135 + 1254)),(65 - 51)}),Healthstone=v18(3674 + 1838),RefreshingHealingPotion=v18(192907 - (389 + 1138))};
	v18.Rogue.Assassination = v19(v18.Rogue.Commons, {AlgetharPuzzleBox=v18(194275 - (102 + 472), {(8 + 5),(1559 - (320 + 1225))}),AshesoftheEmbersoul=v18(368796 - 161629, {(1477 - (157 + 1307)),(34 - 20)}),WitherbarksBranch=v18(12030 + 97969, {(5 + 8),(1040 - (834 + 192))})});
	v18.Rogue.Outlaw = v19(v18.Rogue.Commons, {ManicGrieftorch=v18(12354 + 181954, {(1 + 12),(318 - (300 + 4))}),WindscarWhetstone=v18(36719 + 100767, {(375 - (112 + 250)),(34 - 20)}),BeaconToTheBeyond=v18(116847 + 87116, {(10 + 3),(11 + 3)}),DragonfireBombDispenser=v18(204024 - (1001 + 413), {(895 - (244 + 638)),(41 - 27)})});
	v18.Rogue.Subtlety = v19(v18.Rogue.Commons, {ManicGrieftorch=v18(194910 - (512 + 90), {(730 - (373 + 344)),(4 + 10)}),StormEatersBoon=v18(512515 - 318213, {(1112 - (35 + 1064)),(29 - 15)}),BeaconToTheBeyond=v18(815 + 203148, {(1272 - (233 + 1026)),(8 + 6)}),AshesoftheEmbersoul=v18(202354 + 4813, {(1 + 12),(3 + 11)}),WitherbarksBranch=v18(11062 + 98937, {(310 - (36 + 261)),(1382 - (34 + 1334))}),BandolierOfTwistedBlades=v18(79640 + 127525, {(1296 - (1035 + 248)),(8 + 6)}),Mirror=v18(207900 - (134 + 185), {(698 - (314 + 371)),(982 - (478 + 490))})});
	if (((2191 + 1945) > (3569 - (786 + 386))) and not v21.Rogue) then
		v21.Rogue = {};
	end
	v21.Rogue.Commons = {Healthstone=v21(67 - 46),BlindMouseover=v21(1388 - (1055 + 324)),CheapShotMouseover=v21(1350 - (1093 + 247)),KickMouseover=v21(10 + 1),KidneyShotMouseover=v21(2 + 10),TricksoftheTradeFocus=v21(51 - 38),WindscarWhetstone=v21(87 - 61)};
	v21.Rogue.Outlaw = v19(v21.Rogue.Commons, {Dispatch=v21(39 - 25),PistolShotMouseover=v21(37 - 22),SinisterStrikeMouseover=v21(6 + 10)});
	v21.Rogue.Subtlety = v19(v21.Rogue.Commons, {SecretTechnique=v21(61 - 45),ShadowDance=v21(58 - 41),ShadowDanceSymbol=v21(20 + 6),VanishShadowstrike=v21(45 - 27),ShurikenStormSD=v21(707 - (364 + 324)),ShurikenStormVanish=v21(54 - 34),GloombladeSD=v21(52 - 30),GloombladeVanish=v21(8 + 15),BackstabMouseover=v21(100 - 76),RuptureMouseover=v21(40 - 15)});
	v30.StealthSpell = function()
		return (v16.Rogue.Commons.Subterfuge:IsAvailable() and v16.Rogue.Commons.Stealth2) or v16.Rogue.Commons.Stealth;
	end;
	v30.VanishBuffSpell = function()
		return (v16.Rogue.Commons.Subterfuge:IsAvailable() and v16.Rogue.Commons.VanishBuff2) or v16.Rogue.Commons.VanishBuff;
	end;
	v30.Stealth = function(v49, v50)
		local v51 = 0 - 0;
		while true do
			if ((v51 == (1268 - (1249 + 19))) or ((3913 + 421) == (16523 - 12278))) then
				if ((EpicSettings.Settings['StealthOOC'] and (v16.Rogue.Commons.Stealth:IsCastable() or v16.Rogue.Commons.Stealth2:IsCastable()) and v13:StealthDown()) or ((5362 - (686 + 400)) <= (2379 + 652))) then
					if (v10.Press(v49, nil) or ((5011 - (73 + 156)) <= (6 + 1193))) then
						return "Cast Stealth (OOC)";
					end
				end
				return false;
			end
		end
	end;
	do
		local v52 = 811 - (721 + 90);
		local v53;
		while true do
			if ((v52 == (0 + 0)) or ((15792 - 10928) < (2372 - (224 + 246)))) then
				v53 = v16(300207 - 114896);
				v30.CrimsonVial = function()
					local v194 = 0 - 0;
					local v195;
					while true do
						if (((878 + 3961) >= (89 + 3611)) and (v194 == (0 + 0))) then
							v195 = EpicSettings.Settings['CrimsonVialHP'] or (0 - 0);
							if ((v53:IsCastable() and (v13:HealthPercentage() <= v195)) or ((3577 - 2502) > (2431 - (203 + 310)))) then
								if (((2389 - (1238 + 755)) <= (266 + 3538)) and v10.Cast(v53, nil)) then
									return "Cast Crimson Vial (Defensives)";
								end
							end
							v194 = 1535 - (709 + 825);
						end
						if ((v194 == (1 - 0)) or ((6072 - 1903) == (3051 - (196 + 668)))) then
							return false;
						end
					end
				end;
				break;
			end
		end
	end
	do
		local v54 = v16(7762 - 5796);
		v30.Feint = function()
			local v113 = 0 - 0;
			local v114;
			while true do
				if (((2239 - (171 + 662)) == (1499 - (4 + 89))) and (v113 == (0 - 0))) then
					v114 = EpicSettings.Settings['FeintHP'] or (0 + 0);
					if (((6724 - 5193) < (1675 + 2596)) and v54:IsCastable() and v13:BuffDown(v54) and (v13:HealthPercentage() <= v114)) then
						if (((2121 - (35 + 1451)) == (2088 - (28 + 1425))) and v10.Cast(v54, nil)) then
							return "Cast Feint (Defensives)";
						end
					end
					break;
				end
			end
		end;
	end
	do
		local v56 = 1993 - (941 + 1052);
		local v57;
		local v58;
		local v59;
		while true do
			if (((3235 + 138) <= (5070 - (822 + 692))) and (v56 == (0 - 0))) then
				v57 = 0 + 0;
				v58 = false;
				v56 = 298 - (45 + 252);
			end
			if ((v56 == (1 + 0)) or ((1133 + 2158) < (7982 - 4702))) then
				v59 = nil;
				function v59(v196)
					if (((4819 - (114 + 319)) >= (1252 - 379)) and not v13:AffectingCombat() and v13:BuffRefreshable(v196)) then
						if (((1179 - 258) <= (703 + 399)) and v10.Press(v196, nil, true)) then
							return "poison";
						end
					end
				end
				v56 = 2 - 0;
			end
			if (((9859 - 5153) >= (2926 - (556 + 1407))) and (v56 == (1208 - (741 + 465)))) then
				v30.Poisons = function()
					v58 = v13:BuffUp(v16.Rogue.Commons.WoundPoison);
					if (v16.Rogue.Assassination.DragonTemperedBlades:IsAvailable() or ((1425 - (170 + 295)) <= (462 + 414))) then
						local v221 = v59((v58 and v16.Rogue.Commons.WoundPoison) or v16.Rogue.Commons.DeadlyPoison);
						if (v221 or ((1898 + 168) == (2294 - 1362))) then
							return v221;
						end
						if (((4000 + 825) < (3106 + 1737)) and v16.Rogue.Commons.AmplifyingPoison:IsAvailable()) then
							local v227 = 0 + 0;
							while true do
								if ((v227 == (1230 - (957 + 273))) or ((1037 + 2840) >= (1817 + 2720))) then
									v221 = v59(v16.Rogue.Commons.AmplifyingPoison);
									if (v221 or ((16442 - 12127) < (4548 - 2822))) then
										return v221;
									end
									break;
								end
							end
						else
							v221 = v59(v16.Rogue.Commons.InstantPoison);
							if (v221 or ((11237 - 7558) < (3094 - 2469))) then
								return v221;
							end
						end
					elseif (v58 or ((6405 - (389 + 1391)) < (397 + 235))) then
						local v228 = v59(v16.Rogue.Commons.WoundPoison);
						if (v228 or ((9 + 74) > (4052 - 2272))) then
							return v228;
						end
					elseif (((1497 - (783 + 168)) <= (3614 - 2537)) and v16.Rogue.Commons.AmplifyingPoison:IsAvailable() and v13:BuffDown(v16.Rogue.Commons.DeadlyPoison)) then
						local v233 = 0 + 0;
						local v234;
						while true do
							if (((311 - (309 + 2)) == v233) or ((3058 - 2062) > (5513 - (1090 + 122)))) then
								v234 = v59(v16.Rogue.Commons.AmplifyingPoison);
								if (((1320 + 2750) > (2307 - 1620)) and v234) then
									return v234;
								end
								break;
							end
						end
					elseif (v16.Rogue.Commons.DeadlyPoison:IsAvailable() or ((449 + 207) >= (4448 - (628 + 490)))) then
						local v238 = 0 + 0;
						local v239;
						while true do
							if ((v238 == (0 - 0)) or ((11388 - 8896) <= (1109 - (431 + 343)))) then
								v239 = v59(v16.Rogue.Commons.DeadlyPoison);
								if (((8728 - 4406) >= (7411 - 4849)) and v239) then
									return v239;
								end
								break;
							end
						end
					else
						local v240 = v59(v16.Rogue.Commons.InstantPoison);
						if (v240 or ((2874 + 763) >= (483 + 3287))) then
							return v240;
						end
					end
					if (v13:BuffDown(v16.Rogue.Commons.CripplingPoison) or ((4074 - (556 + 1139)) > (4593 - (6 + 9)))) then
						if (v16.Rogue.Commons.AtrophicPoison:IsAvailable() or ((89 + 394) > (381 + 362))) then
							local v229 = 169 - (28 + 141);
							local v230;
							while true do
								if (((951 + 1503) > (712 - 134)) and ((0 + 0) == v229)) then
									v230 = v59(v16.Rogue.Commons.AtrophicPoison);
									if (((2247 - (486 + 831)) < (11600 - 7142)) and v230) then
										return v230;
									end
									break;
								end
							end
						elseif (((2330 - 1668) <= (184 + 788)) and v16.Rogue.Commons.NumbingPoison:IsAvailable()) then
							local v235 = 0 - 0;
							local v236;
							while true do
								if (((5633 - (668 + 595)) == (3933 + 437)) and ((0 + 0) == v235)) then
									v236 = v59(v16.Rogue.Commons.NumbingPoison);
									if (v236 or ((12986 - 8224) <= (1151 - (23 + 267)))) then
										return v236;
									end
									break;
								end
							end
						else
							local v237 = v59(v16.Rogue.Commons.CripplingPoison);
							if (v237 or ((3356 - (1129 + 815)) == (4651 - (371 + 16)))) then
								return v237;
							end
						end
					else
						local v222 = v59(v16.Rogue.Commons.CripplingPoison);
						if (v222 or ((4918 - (1326 + 424)) < (4077 - 1924))) then
							return v222;
						end
					end
				end;
				break;
			end
		end
	end
	v30.MfDSniping = function(v60)
		if (v60:IsCastable() or ((18183 - 13207) < (1450 - (88 + 30)))) then
			local v165, v166 = nil, 831 - (720 + 51);
			local v167 = (v15:IsInRange(66 - 36) and v15:TimeToDie()) or (12887 - (421 + 1355));
			for v170, v171 in v23(v13:GetEnemiesInRange(49 - 19)) do
				local v172 = v171:TimeToDie();
				if (((2274 + 2354) == (5711 - (286 + 797))) and not v171:IsMfDBlacklisted() and (v172 < (v13:ComboPointsDeficit() * (3.5 - 2))) and (v172 < v166)) then
					if (((v167 - v172) > (1 - 0)) or ((493 - (397 + 42)) == (124 + 271))) then
						v165, v166 = v171, v172;
					else
						v165, v166 = v15, v167;
					end
				end
			end
			if (((882 - (24 + 776)) == (125 - 43)) and v165 and (v165:GUID() ~= v14:GUID())) then
				v10.Press(v165, v60);
			end
		end
	end;
	v30.CanDoTUnit = function(v61, v62)
		return v20.CanDoTUnit(v61, v62);
	end;
	do
		local v63 = 785 - (222 + 563);
		local v64;
		local v65;
		local v66;
		local v67;
		while true do
			if ((v63 == (1 - 0)) or ((419 + 162) < (472 - (23 + 167)))) then
				v66 = nil;
				function v66()
					local v197 = 1798 - (690 + 1108);
					while true do
						if ((v197 == (0 + 0)) or ((3802 + 807) < (3343 - (40 + 808)))) then
							if (((190 + 962) == (4405 - 3253)) and v64.Nightstalker:IsAvailable() and v13:StealthUp(true, false, true)) then
								return 1 + 0 + ((0.05 + 0) * v64.Nightstalker:TalentRank());
							end
							return 1 + 0;
						end
					end
				end
				v63 = 573 - (47 + 524);
			end
			if (((1231 + 665) <= (9354 - 5932)) and (v63 == (5 - 1))) then
				v64.CrimsonTempest:RegisterPMultiplier(v66);
				break;
			end
			if ((v63 == (6 - 3)) or ((2716 - (1165 + 561)) > (49 + 1571))) then
				v64.Rupture:RegisterPMultiplier(v66, {v65.FinalityRuptureBuff,(480.3 - (341 + 138))});
				v64.Garrote:RegisterPMultiplier(v66, v67);
				v63 = 2 + 2;
			end
			if ((v63 == (3 - 1)) or ((1203 - (89 + 237)) > (15103 - 10408))) then
				v67 = nil;
				function v67()
					local v198 = 0 - 0;
					while true do
						if (((3572 - (581 + 300)) >= (3071 - (855 + 365))) and (v198 == (0 - 0))) then
							if ((v64.ImprovedGarrote:IsAvailable() and (v13:BuffUp(v64.ImprovedGarroteAura, nil, true) or v13:BuffUp(v64.ImprovedGarroteBuff, nil, true) or v13:BuffUp(v64.SepsisBuff, nil, true))) or ((975 + 2010) >= (6091 - (1030 + 205)))) then
								return 1.5 + 0;
							end
							return 1 + 0;
						end
					end
				end
				v63 = 289 - (156 + 130);
			end
			if (((9715 - 5439) >= (2014 - 819)) and (v63 == (0 - 0))) then
				v64 = v16.Rogue.Assassination;
				v65 = v16.Rogue.Subtlety;
				v63 = 1 + 0;
			end
		end
	end
	do
		local v68 = v16(112854 + 80677);
		local v69 = v16(394390 - (10 + 59));
		local v70 = v16(111523 + 282797);
		v30.CPMaxSpend = function()
			return (24 - 19) + ((v68:IsAvailable() and (1164 - (671 + 492))) or (0 + 0)) + ((v69:IsAvailable() and (1216 - (369 + 846))) or (0 + 0)) + ((v70:IsAvailable() and (1 + 0)) or (1945 - (1036 + 909)));
		end;
	end
	v30.CPSpend = function()
		return v22(v13:ComboPoints(), v30.CPMaxSpend());
	end;
	do
		local v72 = 0 + 0;
		while true do
			if (((5425 - 2193) <= (4893 - (11 + 192))) and (v72 == (0 + 0))) then
				v30.AnimachargedCP = function()
					local v199 = 175 - (135 + 40);
					while true do
						if ((v199 == (0 - 0)) or ((541 + 355) >= (6930 - 3784))) then
							if (((4588 - 1527) >= (3134 - (50 + 126))) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand2)) then
								return 5 - 3;
							elseif (((706 + 2481) >= (2057 - (1233 + 180))) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand3)) then
								return 972 - (522 + 447);
							elseif (((2065 - (107 + 1314)) <= (327 + 377)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand4)) then
								return 11 - 7;
							elseif (((407 + 551) > (1880 - 933)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand5)) then
								return 19 - 14;
							end
							return -(1911 - (716 + 1194));
						end
					end
				end;
				v30.EffectiveComboPoints = function(v200)
					if (((77 + 4415) >= (285 + 2369)) and (((v200 == (505 - (74 + 429))) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand2)) or ((v200 == (5 - 2)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand3)) or ((v200 == (2 + 2)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand4)) or ((v200 == (11 - 6)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand5)))) then
						return 5 + 2;
					end
					return v200;
				end;
				break;
			end
		end
	end
	do
		local v73 = 0 - 0;
		local v74;
		local v75;
		local v76;
		local v77;
		local v78;
		while true do
			if (((8510 - 5068) >= (1936 - (279 + 154))) and (v73 == (780 - (454 + 324)))) then
				v78 = v16.Rogue.Assassination.AtrophicPoisonDebuff;
				v30.Poisoned = function(v201)
					return ((v201:DebuffUp(v74) or v201:DebuffUp(v76) or v201:DebuffUp(v77) or v201:DebuffUp(v75) or v201:DebuffUp(v78)) and true) or false;
				end;
				break;
			end
			if (((1 + 0) == v73) or ((3187 - (12 + 5)) <= (790 + 674))) then
				v76 = v16.Rogue.Assassination.AmplifyingPoisonDebuff;
				v77 = v16.Rogue.Assassination.CripplingPoisonDebuff;
				v73 = 4 - 2;
			end
			if ((v73 == (0 + 0)) or ((5890 - (277 + 816)) == (18750 - 14362))) then
				v74 = v16.Rogue.Assassination.DeadlyPoisonDebuff;
				v75 = v16.Rogue.Assassination.WoundPoisonDebuff;
				v73 = 1184 - (1058 + 125);
			end
		end
	end
	do
		local v79 = v16.Rogue.Assassination.Garrote;
		local v80 = v16.Rogue.Assassination.GarroteDeathmark;
		local v81 = v16.Rogue.Assassination.Rupture;
		local v82 = v16.Rogue.Assassination.RuptureDeathmark;
		local v83 = v16.Rogue.Assassination.InternalBleeding;
		local v84 = 0 + 0;
		v30.PoisonedBleeds = function()
			local v115 = 975 - (815 + 160);
			while true do
				if (((2364 - 1813) <= (1616 - 935)) and (v115 == (1 + 0))) then
					return v84;
				end
				if (((9579 - 6302) > (2305 - (41 + 1857))) and (v115 == (1893 - (1222 + 671)))) then
					v84 = 0 - 0;
					for v213, v214 in v23(v13:GetEnemiesInRange(71 - 21)) do
						if (((5877 - (229 + 953)) >= (3189 - (1111 + 663))) and v30.Poisoned(v214)) then
							if (v214:DebuffUp(v79) or ((4791 - (874 + 705)) <= (133 + 811))) then
								v84 = v84 + 1 + 0;
								if (v214:DebuffUp(v80) or ((6435 - 3339) <= (51 + 1747))) then
									v84 = v84 + (680 - (642 + 37));
								end
							end
							if (((807 + 2730) == (566 + 2971)) and v214:DebuffUp(v81)) then
								v84 = v84 + (2 - 1);
								if (((4291 - (233 + 221)) >= (3630 - 2060)) and v214:DebuffUp(v82)) then
									v84 = v84 + 1 + 0;
								end
							end
							if (v214:DebuffUp(v83) or ((4491 - (718 + 823)) == (2399 + 1413))) then
								v84 = v84 + (806 - (266 + 539));
							end
						end
					end
					v115 = 2 - 1;
				end
			end
		end;
	end
	do
		local v86 = 1225 - (636 + 589);
		local v87;
		while true do
			if (((11210 - 6487) >= (4780 - 2462)) and ((1 + 0) == v86)) then
				v10:RegisterForSelfCombatEvent(function(v202, v202, v202, v202, v202, v202, v202, v202, v202, v202, v202, v203)
					if ((v203 == (114623 + 200885)) or ((3042 - (657 + 358)) > (7551 - 4699))) then
						v87 = v29() + (68 - 38);
					end
				end, "SPELL_AURA_APPLIED");
				v10:RegisterForSelfCombatEvent(function(v204, v204, v204, v204, v204, v204, v204, v204, v204, v204, v204, v205)
					if ((v205 == (316695 - (1151 + 36))) or ((1098 + 38) > (1135 + 3182))) then
						v87 = v29() + v22(119 - 79, (1862 - (1552 + 280)) + v30.RtBRemains(true));
					end
				end, "SPELL_AURA_REFRESH");
				v86 = 836 - (64 + 770);
			end
			if (((3224 + 1524) == (10778 - 6030)) and ((0 + 0) == v86)) then
				v87 = v29();
				v30.RtBRemains = function(v206)
					local v207 = (v87 - v29()) - v10.RecoveryOffset(v206);
					return ((v207 >= (1243 - (157 + 1086))) and v207) or (0 - 0);
				end;
				v86 = 4 - 3;
			end
			if (((5730 - 1994) <= (6469 - 1729)) and (v86 == (821 - (599 + 220)))) then
				v10:RegisterForSelfCombatEvent(function(v208, v208, v208, v208, v208, v208, v208, v208, v208, v208, v208, v209)
					if ((v209 == (628296 - 312788)) or ((5321 - (1813 + 118)) <= (2237 + 823))) then
						v87 = v29();
					end
				end, "SPELL_AURA_REMOVED");
				break;
			end
		end
	end
	do
		local v88 = {CrimsonTempest={},Garrote={},Rupture={}};
		v30.Exsanguinated = function(v116, v117)
			local v118 = v116:GUID();
			if (not v118 or ((2216 - (841 + 376)) > (3772 - 1079))) then
				return false;
			end
			local v119 = v117:ID();
			if (((108 + 355) < (1640 - 1039)) and (v119 == (122270 - (464 + 395)))) then
				return v88.CrimsonTempest[v118] or false;
			elseif ((v119 == (1804 - 1101)) or ((1049 + 1134) < (1524 - (467 + 370)))) then
				return v88.Garrote[v118] or false;
			elseif (((9400 - 4851) == (3340 + 1209)) and (v119 == (6660 - 4717))) then
				return v88.Rupture[v118] or false;
			end
			return false;
		end;
		v30.WillLoseExsanguinate = function(v120, v121)
			local v122 = 0 + 0;
			while true do
				if (((10869 - 6197) == (5192 - (150 + 370))) and (v122 == (1282 - (74 + 1208)))) then
					if (v30.Exsanguinated(v120, v121) or ((9021 - 5353) < (1873 - 1478))) then
						return true;
					end
					return false;
				end
			end
		end;
		v30.ExsanguinatedRate = function(v123, v124)
			local v125 = 0 + 0;
			while true do
				if ((v125 == (390 - (14 + 376))) or ((7225 - 3059) == (295 + 160))) then
					if (v30.Exsanguinated(v123, v124) or ((3909 + 540) == (2540 + 123))) then
						return 5 - 3;
					end
					return 1 + 0;
				end
			end
		end;
		v10:RegisterForSelfCombatEvent(function(v126, v126, v126, v126, v126, v126, v126, v127, v126, v126, v126, v128)
			if ((v128 == (200884 - (23 + 55))) or ((10135 - 5858) < (1995 + 994))) then
				for v210, v211 in v23(v88) do
					for v215, v216 in v23(v211) do
						if ((v215 == v127) or ((782 + 88) >= (6432 - 2283))) then
							v211[v215] = true;
						end
					end
				end
			end
		end, "SPELL_CAST_SUCCESS");
		v10:RegisterForSelfCombatEvent(function(v129, v129, v129, v129, v129, v129, v129, v130, v129, v129, v129, v131)
			if (((696 + 1516) < (4084 - (652 + 249))) and (v131 == (324914 - 203503))) then
				v88.CrimsonTempest[v130] = false;
			elseif (((6514 - (708 + 1160)) > (8121 - 5129)) and (v131 == (1281 - 578))) then
				v88.Garrote[v130] = false;
			elseif (((1461 - (10 + 17)) < (698 + 2408)) and (v131 == (3675 - (1400 + 332)))) then
				v88.Rupture[v130] = false;
			end
		end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
		v10:RegisterForSelfCombatEvent(function(v132, v132, v132, v132, v132, v132, v132, v133, v132, v132, v132, v134)
			if (((1507 - 721) < (4931 - (242 + 1666))) and (v134 == (51955 + 69456))) then
				if ((v88.CrimsonTempest[v133] ~= nil) or ((895 + 1547) < (64 + 10))) then
					v88.CrimsonTempest[v133] = nil;
				end
			elseif (((5475 - (850 + 90)) == (7942 - 3407)) and (v134 == (2093 - (360 + 1030)))) then
				if ((v88.Garrote[v133] ~= nil) or ((2663 + 346) <= (5941 - 3836))) then
					v88.Garrote[v133] = nil;
				end
			elseif (((2517 - 687) < (5330 - (909 + 752))) and (v134 == (3166 - (109 + 1114)))) then
				if ((v88.Rupture[v133] ~= nil) or ((2618 - 1188) >= (1407 + 2205))) then
					v88.Rupture[v133] = nil;
				end
			end
		end, "SPELL_AURA_REMOVED");
		v10:RegisterForCombatEvent(function(v135, v135, v135, v135, v135, v135, v135, v136)
			if (((2925 - (6 + 236)) >= (1550 + 910)) and (v88.CrimsonTempest[v136] ~= nil)) then
				v88.CrimsonTempest[v136] = nil;
			end
			if ((v88.Garrote[v136] ~= nil) or ((1453 + 351) >= (7723 - 4448))) then
				v88.Garrote[v136] = nil;
			end
			if ((v88.Rupture[v136] ~= nil) or ((2474 - 1057) > (4762 - (1076 + 57)))) then
				v88.Rupture[v136] = nil;
			end
		end, "UNIT_DIED", "UNIT_DESTROYED");
	end
	do
		local v92 = v16(32172 + 163455);
		local v93 = 689 - (579 + 110);
		local v94 = v29();
		v30.FanTheHammerCP = function()
			local v137 = 0 + 0;
			while true do
				if (((4240 + 555) > (214 + 188)) and ((407 - (174 + 233)) == v137)) then
					if (((13444 - 8631) > (6257 - 2692)) and ((v29() - v94) < (0.5 + 0)) and (v93 > (1174 - (663 + 511)))) then
						if (((3490 + 422) == (850 + 3062)) and (v93 > v13:ComboPoints())) then
							return v93;
						else
							v93 = 0 - 0;
						end
					end
					return 0 + 0;
				end
			end
		end;
		v10:RegisterForSelfCombatEvent(function(v138, v138, v138, v138, v138, v138, v138, v138, v138, v138, v138, v139, v138, v138, v140, v141)
			if (((6641 - 3820) <= (11677 - 6853)) and (v139 == (88643 + 97120))) then
				if (((3382 - 1644) <= (1565 + 630)) and ((v29() - v94) > (0.5 + 0))) then
					v93 = v22(v30.CPMaxSpend(), v13:ComboPoints() + v140 + (v25(722 - (478 + 244), v140 - (518 - (440 + 77))) * v22(1 + 1, v13:BuffStack(v92) - (3 - 2))));
					v94 = v29();
				end
			end
		end, "SPELL_ENERGIZE");
	end
	do
		local v96, v97 = 1556 - (655 + 901), 0 + 0;
		local v98 = v16(212771 + 65154);
		v30.TimeToNextTornado = function()
			if (((28 + 13) <= (12158 - 9140)) and not v13:BuffUp(v98, nil, true)) then
				return 1445 - (695 + 750);
			end
			local v142 = v13:BuffRemains(v98, nil, true) % (3 - 2);
			if (((3309 - 1164) <= (16505 - 12401)) and (v29() == v96)) then
				return 351 - (285 + 66);
			elseif (((6267 - 3578) < (6155 - (682 + 628))) and ((v29() - v96) < (0.1 + 0)) and (v142 < (299.25 - (176 + 123)))) then
				return 1 + 0;
			elseif ((((v142 > (0.9 + 0)) or (v142 == (269 - (239 + 30)))) and ((v29() - v96) > (0.75 + 0))) or ((2232 + 90) > (4640 - 2018))) then
				return 0.1 - 0;
			end
			return v142;
		end;
		v10:RegisterForSelfCombatEvent(function(v143, v143, v143, v143, v143, v143, v143, v143, v143, v143, v143, v144)
			if ((v144 == (213058 - (306 + 9))) or ((15821 - 11287) == (363 + 1719))) then
				v96 = v29();
			elseif ((v144 == (121382 + 76453)) or ((757 + 814) > (5338 - 3471))) then
				v97 = v29();
			end
			if ((v97 == v96) or ((4029 - (1140 + 235)) >= (1907 + 1089))) then
				v96 = 0 + 0;
			end
		end, "SPELL_CAST_SUCCESS");
	end
	do
		local v100 = {Counter=(0 + 0),LastMH=(52 - (33 + 19)),LastOH=(0 + 0)};
		v30.TimeToSht = function(v145)
			local v146 = 0 - 0;
			local v147;
			local v148;
			local v149;
			local v150;
			local v151;
			local v152;
			while true do
				if (((1753 + 2225) > (4126 - 2022)) and (v146 == (0 + 0))) then
					if (((3684 - (586 + 103)) > (141 + 1400)) and (v100.Counter >= v145)) then
						return 0 - 0;
					end
					v147, v148 = v28("player");
					v146 = 1489 - (1309 + 179);
				end
				if (((5864 - 2615) > (415 + 538)) and (v146 == (5 - 3))) then
					v151 = {};
					for v219 = 0 + 0, 3 - 1 do
						local v220 = 0 - 0;
						while true do
							if (((609 - (295 + 314)) == v220) or ((8038 - 4765) > (6535 - (1300 + 662)))) then
								v27(v151, v149 + (v219 * v147));
								v27(v151, v150 + (v219 * v148));
								break;
							end
						end
					end
					v146 = 9 - 6;
				end
				if ((v146 == (1758 - (1178 + 577))) or ((1637 + 1514) < (3795 - 2511))) then
					table.sort(v151);
					v152 = v22(1410 - (851 + 554), v25(1 + 0, v145 - v100.Counter));
					v146 = 10 - 6;
				end
				if ((v146 == (1 - 0)) or ((2152 - (115 + 187)) == (1171 + 358))) then
					v149 = v25(v100.LastMH + v147, v29());
					v150 = v25(v100.LastOH + v148, v29());
					v146 = 2 + 0;
				end
				if (((3235 - 2414) < (3284 - (160 + 1001))) and (v146 == (4 + 0))) then
					return v151[v152] - v29();
				end
			end
		end;
		v10:RegisterForSelfCombatEvent(function()
			v100.Counter = 0 + 0;
			v100.LastMH = v29();
			v100.LastOH = v29();
		end, "PLAYER_ENTERING_WORLD");
		v10:RegisterForSelfCombatEvent(function(v156, v156, v156, v156, v156, v156, v156, v156, v156, v156, v156, v157)
			if (((1845 - 943) < (2683 - (237 + 121))) and (v157 == (197808 - (525 + 372)))) then
				v100.Counter = 0 - 0;
			end
		end, "SPELL_ENERGIZE");
		v10:RegisterForSelfCombatEvent(function(v158, v158, v158, v158, v158, v158, v158, v158, v158, v158, v158, v158, v158, v158, v158, v158, v158, v158, v158, v158, v158, v158, v158, v159)
			v100.Counter = v100.Counter + (3 - 2);
			if (((1000 - (96 + 46)) <= (3739 - (643 + 134))) and v159) then
				v100.LastOH = v29();
			else
				v100.LastMH = v29();
			end
		end, "SWING_DAMAGE");
		v10:RegisterForSelfCombatEvent(function(v161, v161, v161, v161, v161, v161, v161, v161, v161, v161, v161, v161, v161, v161, v161, v162)
			if (v162 or ((1425 + 2521) < (3088 - 1800))) then
				v100.LastOH = v29();
			else
				v100.LastMH = v29();
			end
		end, "SWING_MISSED");
	end
	do
		local v102 = 0 - 0;
		local v103;
		local v104;
		local v105;
		while true do
			if ((v102 == (2 + 0)) or ((6362 - 3120) == (1158 - 591))) then
				v10:RegisterForEvent(function()
					if ((v104 == (719 - (316 + 403))) or ((563 + 284) >= (3472 - 2209))) then
						local v223 = 0 + 0;
						while true do
							if ((v223 == (0 - 0)) or ((1597 + 656) == (597 + 1254))) then
								v24.After(10 - 7, v105);
								v104 = 9 - 7;
								break;
							end
						end
					end
				end, "PLAYER_EQUIPMENT_CHANGED");
				v30.BaseAttackCrit = function()
					return v103;
				end;
				break;
			end
			if ((v102 == (1 - 0)) or ((120 + 1967) > (4669 - 2297))) then
				v105 = nil;
				function v105()
					local v212 = 0 + 0;
					while true do
						if ((v212 == (2 - 1)) or ((4462 - (12 + 5)) < (16114 - 11965))) then
							if ((v104 > (0 - 0)) or ((3864 - 2046) == (210 - 125))) then
								v24.After(1 + 2, v105);
							end
							break;
						end
						if (((2603 - (1656 + 317)) < (1896 + 231)) and (v212 == (0 + 0))) then
							if (not v13:AffectingCombat() or ((5153 - 3215) == (12372 - 9858))) then
								local v232 = 354 - (5 + 349);
								while true do
									if (((20210 - 15955) >= (1326 - (266 + 1005))) and (v232 == (0 + 0))) then
										v103 = v13:CritChancePct();
										v10.Debug("Base Crit Set to: " .. v103);
										break;
									end
								end
							end
							if (((10232 - 7233) > (1521 - 365)) and ((v104 == nil) or (v104 < (1696 - (561 + 1135))))) then
								v104 = 0 - 0;
							else
								v104 = v104 - (3 - 2);
							end
							v212 = 1067 - (507 + 559);
						end
					end
				end
				v102 = 4 - 2;
			end
			if (((7267 - 4917) > (1543 - (212 + 176))) and (v102 == (905 - (250 + 655)))) then
				v103 = v13:CritChancePct();
				v104 = 0 - 0;
				v102 = 1 - 0;
			end
		end
	end
	do
		local v106 = v16.Rogue.Assassination;
		local v107 = v16.Rogue.Subtlety;
		local function v108()
			local v163 = 0 - 0;
			while true do
				if (((5985 - (1869 + 87)) <= (16832 - 11979)) and (v163 == (1901 - (484 + 1417)))) then
					if ((v106.Nightstalker:IsAvailable() and v13:StealthUp(true, false, true)) or ((1105 - 589) > (5754 - 2320))) then
						return (774 - (48 + 725)) + ((0.05 - 0) * v106.Nightstalker:TalentRank());
					end
					return 2 - 1;
				end
			end
		end
		local function v109()
			if (((2352 + 1694) >= (8105 - 5072)) and v106.ImprovedGarrote:IsAvailable() and (v13:BuffUp(v106.ImprovedGarroteAura, nil, true) or v13:BuffUp(v106.ImprovedGarroteBuff, nil, true) or v13:BuffUp(v106.SepsisBuff, nil, true))) then
				return 1.5 + 0;
			end
			return 1 + 0;
		end
		v106.Rupture:RegisterPMultiplier(v108, {v107.FinalityRuptureBuff,(1.3 + 0)});
		v106.Garrote:RegisterPMultiplier(v108, v109);
	end
end;
return v0["Epix_Rogue_Rogue.lua"]();

