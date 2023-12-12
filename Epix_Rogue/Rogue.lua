local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1739 - (404 + 1335);
	local v6;
	while true do
		if ((v5 == (407 - (183 + 223))) or ((4587 - 817) >= (2678 + 1363))) then
			return v6(...);
		end
		if ((v5 == (0 + 0)) or ((4128 - (10 + 327)) <= (1122 + 489))) then
			v6 = v0[v4];
			if (not v6 or ((4916 - (118 + 220)) <= (670 + 1338))) then
				return v1(v4, ...);
			end
			v5 = 450 - (108 + 341);
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
	if (((506 + 619) <= (8776 - 6700)) and not v16.Rogue) then
		v16.Rogue = {};
	end
	v16.Rogue.Commons = {Sanguine=v16(228003 - (711 + 782), nil, 1 - 0),AncestralCall=v16(275207 - (270 + 199), nil, 1 + 1),ArcanePulse=v16(262183 - (580 + 1239), nil, 8 - 5),ArcaneTorrent=v16(23948 + 1098, nil, 1 + 3),BagofTricks=v16(136094 + 176317, nil, 13 - 8),Berserking=v16(16338 + 9959, nil, 1173 - (645 + 522)),BloodFury=v16(22362 - (1010 + 780), nil, 7 + 0),Fireblood=v16(1263488 - 998267, nil, 23 - 15),LightsJudgment=v16(257483 - (1045 + 791), nil, 22 - 13),Shadowmeld=v16(90064 - 31080, nil, 515 - (351 + 154)),CloakofShadows=v16(32798 - (1281 + 293), nil, 277 - (28 + 238)),CrimsonVial=v16(414072 - 228761, nil, 1571 - (1381 + 178)),Evasion=v16(4950 + 327, nil, 11 + 2),Feint=v16(839 + 1127, nil, 48 - 34),Blind=v16(1085 + 1009, nil, 485 - (381 + 89)),CheapShot=v16(1626 + 207, nil, 11 + 5),Kick=v16(3024 - 1258, nil, 1173 - (1074 + 82)),KidneyShot=v16(894 - 486, nil, 1802 - (214 + 1570)),Sap=v16(8225 - (990 + 465), nil, 8 + 11),Shiv=v16(2584 + 3354, nil, 20 + 0),SliceandDice=v16(1241643 - 926147, nil, 1747 - (1668 + 58)),Shadowstep=v16(37180 - (512 + 114), nil, 57 - 35),Sprint=v16(6166 - 3183, nil, 79 - 56),TricksoftheTrade=v16(26952 + 30982, nil, 5 + 19),CripplingPoison=v16(2963 + 445, nil, 84 - 59),DeadlyPoison=v16(4817 - (109 + 1885), nil, 1495 - (1269 + 200)),InstantPoison=v16(604881 - 289297, nil, 842 - (98 + 717)),AmplifyingPoison=v16(382490 - (802 + 24), nil, 48 - 20),NumbingPoison=v16(7275 - 1514, nil, 5 + 24),WoundPoison=v16(6669 + 2010, nil, 5 + 25),AtrophicPoison=v16(82322 + 299315, nil, 86 - 55),AcrobaticStrikes=v16(656694 - 459770, nil, 12 + 20),Alacrity=v16(78783 + 114756, nil, 28 + 5),ColdBlood=v16(277943 + 104302, nil, 16 + 18),DeeperStratagem=v16(194964 - (797 + 636)),EchoingReprimand=v16(1872305 - 1486689, nil, 1655 - (1427 + 192)),EchoingReprimand2=v16(112110 + 211448, nil, 85 - 48),EchoingReprimand3=v16(290836 + 32723, nil, 18 + 20),EchoingReprimand4=v16(323886 - (192 + 134), nil, 1315 - (316 + 960)),EchoingReprimand5=v16(197467 + 157371, nil, 31 + 9),FindWeakness=v16(84134 + 6889, nil, 156 - 115),FindWeaknessDebuff=v16(316771 - (83 + 468), nil, 1848 - (1202 + 604)),ImprovedAmbush=v16(1781475 - 1399855, nil, 70 - 27),MarkedforDeath=v16(381031 - 243412, nil, 369 - (45 + 280)),Nightstalker=v16(13573 + 489, nil, 40 + 5),ResoundingClarity=v16(139346 + 242276, nil, 26 + 20),SealFate=v16(2496 + 11694, nil, 86 - 39),Sepsis=v16(387319 - (340 + 1571), nil, 19 + 29),SepsisBuff=v16(377711 - (1733 + 39), nil, 134 - 85),ShadowDance=v16(186347 - (125 + 909), nil, 1998 - (1096 + 852)),ShadowDanceTalent=v16(177156 + 217774, nil, 72 - 21),ShadowDanceBuff=v16(179847 + 5575),Subterfuge=v16(108720 - (409 + 103), nil, 289 - (46 + 190)),SubterfugeBuff=v16(115287 - (51 + 44), nil, 16 + 38),ThistleTea=v16(382940 - (1114 + 203), nil, 1046 - (228 + 498)),Vigor=v16(3247 + 11736),Stealth=v16(986 + 798, nil, 720 - (174 + 489)),Stealth2=v16(300106 - 184915, nil, 1963 - (830 + 1075)),Vanish=v16(2380 - (303 + 221), nil, 1328 - (231 + 1038)),VanishBuff=v16(9439 + 1888, nil, 1222 - (171 + 991)),VanishBuff2=v16(474733 - 359540, nil, 163 - 102),PoolEnergy=v16(2495232 - 1495322, nil, 50 + 12)};
	v16.Rogue.Assassination = v19(v16.Rogue.Commons, {Ambush=v16(30412 - 21736, nil, 181 - 118),AmbushOverride=v16(693182 - 263159),AmplifyingPoisonDebuff=v16(1185241 - 801827, nil, 1312 - (111 + 1137)),AmplifyingPoisonDebuffDeathmark=v16(394486 - (91 + 67), nil, 193 - 128),CripplingPoisonDebuff=v16(851 + 2558, nil, 589 - (423 + 100)),DeadlyPoisonDebuff=v16(20 + 2798, nil, 185 - 118),DeadlyPoisonDebuffDeathmark=v16(205530 + 188794, nil, 839 - (326 + 445)),Envenom=v16(142461 - 109816, nil, 153 - 84),FanofKnives=v16(120732 - 69009, nil, 781 - (530 + 181)),Garrote=v16(1584 - (614 + 267), nil, 103 - (19 + 13)),GarroteDeathmark=v16(587292 - 226462, nil, 167 - 95),Mutilate=v16(3796 - 2467, nil, 19 + 54),PoisonedKnife=v16(326348 - 140783, nil, 153 - 79),Rupture=v16(3755 - (1293 + 519), nil, 153 - 78),RuptureDeathmark=v16(942099 - 581273, nil, 145 - 69),WoundPoisonDebuff=v16(37429 - 28749, nil, 181 - 104),ArterialPrecision=v16(212272 + 188511, nil, 16 + 62),AtrophicPoisonDebuff=v16(911719 - 519331, nil, 19 + 60),BlindsideBuff=v16(40248 + 80905, nil, 50 + 30),CausticSpatter=v16(423071 - (709 + 387)),CausticSpatterDebuff=v16(423834 - (673 + 1185)),CrimsonTempest=v16(352109 - 230698, nil, 259 - 178),CutToTheChase=v16(85009 - 33342, nil, 59 + 23),DashingScoundrel=v16(285279 + 96518, nil, 111 - 28),Deathmark=v16(88465 + 271729, nil, 167 - 83),Doomblade=v16(749234 - 367561, nil, 1965 - (446 + 1434)),DragonTemperedBlades=v16(383084 - (1040 + 243), nil, 256 - 170),Elusiveness=v16(80855 - (559 + 1288)),Exsanguinate=v16(202737 - (609 + 1322), nil, 542 - (13 + 441)),ImprovedGarrote=v16(1426095 - 1044463, nil, 232 - 143),ImprovedGarroteBuff=v16(1954329 - 1561928, nil, 4 + 86),ImprovedGarroteAura=v16(1425129 - 1032726, nil, 33 + 58),IndiscriminateCarnage=v16(167300 + 214502, nil, 273 - 181),IndiscriminateCarnageAura=v16(211089 + 174665),IndiscriminateCarnageBuff=v16(709469 - 323722),InternalBleeding=v16(102442 + 52511, nil, 52 + 41),Kingsbane=v16(277077 + 108550, nil, 79 + 15),LightweightShiv=v16(386446 + 8537),MasterAssassin=v16(256422 - (153 + 280), nil, 274 - 179),MasterAssassinBuff=v16(230497 + 26238, nil, 38 + 58),PreyontheWeak=v16(68823 + 62688, nil, 89 + 8),PreyontheWeakDebuff=v16(185433 + 70476, nil, 149 - 51),SerratedBoneSpike=v16(238216 + 147208, nil, 766 - (89 + 578)),SerratedBoneSpikeDebuff=v16(281487 + 112549, nil, 207 - 107),ShivDebuff=v16(320553 - (572 + 477), nil, 14 + 87),VenomRush=v16(91311 + 60841, nil, 13 + 89),ScentOfBlood=v16(381885 - (84 + 2), nil, 652 - 256),ScentOfBloodBuff=v16(283901 + 110179),ShroudedSuffocation=v16(386320 - (497 + 345))});
	v16.Rogue.Outlaw = v19(v16.Rogue.Commons, {AdrenalineRush=v16(352 + 13398, nil, 18 + 85),Ambush=v16(10009 - (605 + 728), nil, 75 + 29),AmbushOverride=v16(956062 - 526039),BetweentheEyes=v16(14452 + 300889, nil, 388 - 283),BladeFlurry=v16(12511 + 1366, nil, 293 - 187),Dispatch=v16(1585 + 513, nil, 596 - (457 + 32)),Elusiveness=v16(33522 + 45486),Opportunity=v16(197029 - (832 + 570)),PistolShot=v16(175005 + 10758, nil, 29 + 81),RolltheBones=v16(1116524 - 801016, nil, 54 + 57),SinisterStrike=v16(194111 - (588 + 208), nil, 301 - 189),Audacity=v16(383645 - (884 + 916), nil, 236 - 123),AudacityBuff=v16(223966 + 162304, nil, 767 - (232 + 421)),BladeRush=v16(273766 - (1569 + 320), nil, 29 + 86),CountTheOdds=v16(72571 + 309411, nil, 390 - 274),Dreadblades=v16(343747 - (316 + 289), nil, 306 - 189),FanTheHammer=v16(17635 + 364211, nil, 1571 - (666 + 787)),GhostlyStrike=v16(197362 - (360 + 65), nil, 112 + 7),GreenskinsWickers=v16(387077 - (79 + 175), nil, 189 - 69),GreenskinsWickersBuff=v16(307558 + 86573, nil, 370 - 249),HiddenOpportunity=v16(738144 - 354863, nil, 1021 - (503 + 396)),ImprovedAdrenalineRush=v16(395603 - (92 + 89), nil, 237 - 114),ImprovedBetweenTheEyes=v16(120766 + 114718, nil, 74 + 50),KeepItRolling=v16(1495923 - 1113934, nil, 18 + 107),KillingSpree=v16(117859 - 66169, nil, 110 + 16),LoadedDice=v16(122356 + 133814, nil, 386 - 259),LoadedDiceBuff=v16(31973 + 224198, nil, 195 - 67),PreyontheWeak=v16(132755 - (485 + 759), nil, 298 - 169),PreyontheWeakDebuff=v16(257098 - (442 + 747), nil, 1265 - (832 + 303)),QuickDraw=v16(197884 - (88 + 858), nil, 40 + 91),SummarilyDispatched=v16(316135 + 65855, nil, 6 + 126),SwiftSlasher=v16(382777 - (766 + 23), nil, 656 - 523),TakeEmBySurpriseBuff=v16(527789 - 141882, nil, 352 - 218),Weaponmaster=v16(681294 - 480561, nil, 1208 - (1036 + 37)),UnderhandedUpperhand=v16(300637 + 123407),DeftManeuvers=v16(743664 - 361786),Crackshot=v16(333299 + 90404),Gouge=v16(3256 - (641 + 839), nil, 1049 - (910 + 3)),Broadside=v16(492921 - 299565, nil, 1821 - (1466 + 218)),BuriedTreasure=v16(91734 + 107866, nil, 1286 - (556 + 592)),GrandMelee=v16(68758 + 124600, nil, 947 - (329 + 479)),RuthlessPrecision=v16(194211 - (174 + 680), nil, 481 - 341),SkullandCrossbones=v16(413723 - 214120, nil, 101 + 40),TrueBearing=v16(194098 - (396 + 343), nil, 13 + 129),ViciousFollowup=v16(396356 - (29 + 1448), nil, 1532 - (135 + 1254))});
	v16.Rogue.Subtlety = v19(v16.Rogue.Commons, {Backstab=v16(199 - 146, nil, 672 - 528),BlackPowder=v16(212710 + 106465, nil, 1672 - (389 + 1138)),Elusiveness=v16(79582 - (102 + 472)),Eviscerate=v16(185737 + 11082, nil, 82 + 65),Rupture=v16(1812 + 131, nil, 1693 - (320 + 1225)),ShadowBlades=v16(216241 - 94770, nil, 92 + 57),Shadowstrike=v16(186902 - (157 + 1307), nil, 2009 - (821 + 1038)),ShurikenStorm=v16(493596 - 295761, nil, 17 + 134),ShurikenToss=v16(202519 - 88505, nil, 57 + 95),SymbolsofDeath=v16(526158 - 313875, nil, 1179 - (834 + 192)),DanseMacabre=v16(24320 + 358208, nil, 40 + 114),DanseMacabreBuff=v16(8458 + 385511, nil, 240 - 85),DeeperDaggers=v16(382821 - (300 + 4), nil, 42 + 114),DeeperDaggersBuff=v16(1003661 - 620256, nil, 519 - (112 + 250)),DarkBrew=v16(152483 + 230021, nil, 395 - 237),DarkShadow=v16(140750 + 104937, nil, 83 + 76),EnvelopingShadows=v16(178076 + 60028, nil, 80 + 80),Finality=v16(284169 + 98356, nil, 1575 - (1001 + 413)),FinalityBlackPowderBuff=v16(860657 - 474709, nil, 1044 - (244 + 638)),FinalityEviscerateBuff=v16(386642 - (627 + 66), nil, 485 - 322),FinalityRuptureBuff=v16(386553 - (512 + 90), nil, 2070 - (1665 + 241)),Flagellation=v16(385348 - (373 + 344), nil, 75 + 90),FlagellationPersistBuff=v16(104450 + 290308, nil, 437 - 271),Gloomblade=v16(339735 - 138977, nil, 1266 - (35 + 1064)),GoremawsBite=v16(310388 + 116203, nil, 403 - 214),ImprovedShadowDance=v16(1573 + 392399, nil, 1404 - (298 + 938)),ImprovedShurikenStorm=v16(321210 - (233 + 1026), nil, 1835 - (636 + 1030)),InvigoratingShadowdust=v16(195571 + 186952),LingeringShadow=v16(373637 + 8887, nil, 51 + 119),LingeringShadowBuff=v16(26078 + 359882, nil, 392 - (55 + 166)),MasterofShadows=v16(38173 + 158803, nil, 18 + 154),PerforatedVeins=v16(1460864 - 1078346, nil, 470 - (36 + 261)),PerforatedVeinsBuff=v16(689491 - 295237, nil, 1542 - (34 + 1334)),PreyontheWeak=v16(50557 + 80954, nil, 136 + 39),PreyontheWeakDebuff=v16(257192 - (1035 + 248), nil, 197 - (20 + 1)),Premeditation=v16(178781 + 164379, nil, 496 - (134 + 185)),PremeditationBuff=v16(344306 - (549 + 584), nil, 863 - (314 + 371)),SecretStratagem=v16(1353682 - 959362, nil, 1147 - (478 + 490)),SecretTechnique=v16(148707 + 132012, nil, 1352 - (786 + 386)),Shadowcraft=v16(1381736 - 955142),ShadowFocus=v16(109588 - (1055 + 324), nil, 1521 - (1093 + 247)),ShurikenTornado=v16(246973 + 30952, nil, 20 + 162),SilentStorm=v16(1531384 - 1145662, nil, 620 - 437),SilentStormBuff=v16(1097579 - 711857, nil, 462 - 278),TheFirstDance=v16(136067 + 246438, nil, 712 - 527),TheRotten=v16(1316724 - 934709, nil, 141 + 45),TheRottenBuff=v16(1008140 - 613937, nil, 875 - (364 + 324)),Weaponmaster=v16(530554 - 337017, nil, 450 - 262)});
	if (not v18.Rogue or ((247 + 496) >= (18406 - 14007))) then
		v18.Rogue = {};
	end
	v18.Rogue.Commons = {AlgetharPuzzleBox=v18(310219 - 116518, {(1281 - (1249 + 19)),(54 - 40)}),ManicGrieftorch=v18(195394 - (686 + 400), {(242 - (73 + 156)),(825 - (721 + 90))}),WindscarWhetstone=v18(1546 + 135940, {(483 - (224 + 246)),(25 - 11)}),Healthstone=v18(1000 + 4512),RefreshingHealingPotion=v18(4555 + 186825)};
	v18.Rogue.Assassination = v19(v18.Rogue.Commons, {AlgetharPuzzleBox=v18(142269 + 51432, {(42 - 29),(2007 - (1238 + 755))}),AshesoftheEmbersoul=v18(14474 + 192693, {(23 - 10),(878 - (196 + 668))}),WitherbarksBranch=v18(434307 - 324308, {(846 - (171 + 662)),(48 - 34)})});
	v18.Rogue.Outlaw = v19(v18.Rogue.Commons, {ManicGrieftorch=v18(70753 + 123555, {(6 + 7),(1467 - (28 + 1425))}),WindscarWhetstone=v18(139479 - (941 + 1052), {(1527 - (822 + 692)),(7 + 7)}),BeaconToTheBeyond=v18(204260 - (45 + 252), {(5 + 8),(447 - (114 + 319))}),DragonfireBombDispenser=v18(290907 - 88297, {(9 + 4),(29 - 15)})});
	v18.Rogue.Subtlety = v19(v18.Rogue.Commons, {ManicGrieftorch=v18(196271 - (556 + 1407), {(478 - (170 + 295)),(13 + 1)}),StormEatersBoon=v18(478381 - 284079, {(9 + 4),(1244 - (957 + 273))}),BeaconToTheBeyond=v18(54551 + 149412, {(49 - 36),(42 - 28)}),AshesoftheEmbersoul=v18(1025825 - 818658, {(9 + 4),(31 - 17)}),WitherbarksBranch=v18(110950 - (783 + 168), {(13 + 0),(42 - 28)}),BandolierOfTwistedBlades=v18(208377 - (1090 + 122), {(43 - 30),(1132 - (628 + 490))}),Mirror=v18(37223 + 170358, {(59 - 46),(27 - 13)})});
	if (((3341 - 2186) < (1322 + 351)) and not v21.Rogue) then
		v21.Rogue = {};
	end
	v21.Rogue.Commons = {Healthstone=v21(3 + 18),BlindMouseover=v21(1704 - (556 + 1139)),CheapShotMouseover=v21(25 - (6 + 9)),KickMouseover=v21(3 + 8),KidneyShotMouseover=v21(7 + 5),TricksoftheTradeFocus=v21(182 - (28 + 141)),WindscarWhetstone=v21(11 + 15)};
	v21.Rogue.Outlaw = v19(v21.Rogue.Commons, {Dispatch=v21(16 - 2),PistolShotMouseover=v21(11 + 4),SinisterStrikeMouseover=v21(1333 - (486 + 831))});
	v21.Rogue.Subtlety = v19(v21.Rogue.Commons, {SecretTechnique=v21(41 - 25),ShadowDance=v21(59 - 42),ShadowDanceSymbol=v21(5 + 21),VanishShadowstrike=v21(56 - 38),ShurikenStormSD=v21(1282 - (668 + 595)),ShurikenStormVanish=v21(18 + 2),GloombladeSD=v21(5 + 17),GloombladeVanish=v21(62 - 39),BackstabMouseover=v21(314 - (23 + 267)),RuptureMouseover=v21(1969 - (1129 + 815))});
	v30.StealthSpell = function()
		return (v16.Rogue.Commons.Subterfuge:IsAvailable() and v16.Rogue.Commons.Stealth2) or v16.Rogue.Commons.Stealth;
	end;
	v30.VanishBuffSpell = function()
		return (v16.Rogue.Commons.Subterfuge:IsAvailable() and v16.Rogue.Commons.VanishBuff2) or v16.Rogue.Commons.VanishBuff;
	end;
	v30.Stealth = function(v49, v50)
		if ((EpicSettings.Settings['StealthOOC'] and (v16.Rogue.Commons.Stealth:IsCastable() or v16.Rogue.Commons.Stealth2:IsCastable()) and v13:StealthDown()) or ((2711 - (371 + 16)) <= (2328 - (1326 + 424)))) then
			if (((7134 - 3367) == (13765 - 9998)) and v10.Press(v49, nil)) then
				return "Cast Stealth (OOC)";
			end
		end
		return false;
	end;
	do
		local v51 = v16.Rogue.Commons;
		local v52 = v51.CrimsonVial;
		v30.CrimsonVial = function()
			local v113 = 118 - (88 + 30);
			local v114;
			while true do
				if (((4860 - (720 + 51)) == (9095 - 5006)) and (v113 == (1777 - (421 + 1355)))) then
					return false;
				end
				if (((7354 - 2896) >= (823 + 851)) and (v113 == (1083 - (286 + 797)))) then
					v114 = EpicSettings.Settings['CrimsonVialHP'] or (0 - 0);
					if (((1609 - 637) <= (1857 - (397 + 42))) and v52:IsCastable() and v52:IsReady() and (v13:HealthPercentage() <= v114)) then
						if (v10.Cast(v52, nil) or ((1543 + 3395) < (5562 - (24 + 776)))) then
							return "Cast Crimson Vial (Defensives)";
						end
					end
					v113 = 1 - 0;
				end
			end
		end;
	end
	do
		local v54 = v16.Rogue.Commons;
		local v55 = v54.Feint;
		v30.Feint = function()
			local v115 = 785 - (222 + 563);
			local v116;
			while true do
				if ((v115 == (0 - 0)) or ((1803 + 701) > (4454 - (23 + 167)))) then
					v116 = EpicSettings.Settings['FeintHP'] or (1798 - (690 + 1108));
					if (((777 + 1376) == (1776 + 377)) and v55:IsCastable() and v13:BuffDown(v55) and (v13:HealthPercentage() <= v116)) then
						if (v10.Cast(v55, nil) or ((1355 - (40 + 808)) >= (427 + 2164))) then
							return "Cast Feint (Defensives)";
						end
					end
					break;
				end
			end
		end;
	end
	do
		local v57 = 0 - 0;
		local v58;
		local v59;
		local v60;
		while true do
			if (((4283 + 198) == (2371 + 2110)) and (v57 == (1 + 0))) then
				v60 = nil;
				function v60(v156)
					if ((not v13:AffectingCombat() and v13:BuffRefreshable(v156)) or ((2899 - (47 + 524)) < (450 + 243))) then
						if (((11830 - 7502) == (6471 - 2143)) and v10.Press(v156, nil, true)) then
							return "poison";
						end
					end
				end
				v57 = 4 - 2;
			end
			if (((3314 - (1165 + 561)) >= (40 + 1292)) and (v57 == (6 - 4))) then
				v30.Poisons = function()
					v59 = v13:BuffUp(v16.Rogue.Commons.WoundPoison);
					if (v16.Rogue.Assassination.DragonTemperedBlades:IsAvailable() or ((1593 + 2581) > (4727 - (341 + 138)))) then
						local v218 = 0 + 0;
						local v219;
						while true do
							if ((v218 == (1 - 0)) or ((4912 - (89 + 237)) <= (263 - 181))) then
								if (((8132 - 4269) == (4744 - (581 + 300))) and v16.Rogue.Commons.AmplifyingPoison:IsAvailable()) then
									v219 = v60(v16.Rogue.Commons.AmplifyingPoison);
									if (v219 or ((1502 - (855 + 365)) <= (99 - 57))) then
										return v219;
									end
								else
									local v257 = 0 + 0;
									while true do
										if (((5844 - (1030 + 205)) >= (720 + 46)) and ((0 + 0) == v257)) then
											v219 = v60(v16.Rogue.Commons.InstantPoison);
											if (v219 or ((1438 - (156 + 130)) == (5652 - 3164))) then
												return v219;
											end
											break;
										end
									end
								end
								break;
							end
							if (((5766 - 2344) > (6861 - 3511)) and (v218 == (0 + 0))) then
								v219 = v60((v59 and v16.Rogue.Commons.WoundPoison) or v16.Rogue.Commons.DeadlyPoison);
								if (((512 + 365) > (445 - (10 + 59))) and v219) then
									return v219;
								end
								v218 = 1 + 0;
							end
						end
					elseif (v59 or ((15355 - 12237) <= (3014 - (671 + 492)))) then
						local v232 = 0 + 0;
						local v233;
						while true do
							if ((v232 == (1215 - (369 + 846))) or ((44 + 121) >= (2981 + 511))) then
								v233 = v60(v16.Rogue.Commons.WoundPoison);
								if (((5894 - (1036 + 909)) < (3861 + 995)) and v233) then
									return v233;
								end
								break;
							end
						end
					elseif ((v16.Rogue.Commons.AmplifyingPoison:IsAvailable() and v13:BuffDown(v16.Rogue.Commons.DeadlyPoison)) or ((7178 - 2902) < (3219 - (11 + 192)))) then
						local v247 = 0 + 0;
						local v248;
						while true do
							if (((4865 - (135 + 40)) > (9994 - 5869)) and (v247 == (0 + 0))) then
								v248 = v60(v16.Rogue.Commons.AmplifyingPoison);
								if (v248 or ((110 - 60) >= (1342 - 446))) then
									return v248;
								end
								break;
							end
						end
					elseif (v16.Rogue.Commons.DeadlyPoison:IsAvailable() or ((1890 - (50 + 126)) >= (8236 - 5278))) then
						local v258 = 0 + 0;
						local v259;
						while true do
							if ((v258 == (1413 - (1233 + 180))) or ((2460 - (522 + 447)) < (2065 - (107 + 1314)))) then
								v259 = v60(v16.Rogue.Commons.DeadlyPoison);
								if (((327 + 377) < (3007 - 2020)) and v259) then
									return v259;
								end
								break;
							end
						end
					else
						local v260 = v60(v16.Rogue.Commons.InstantPoison);
						if (((1580 + 2138) > (3784 - 1878)) and v260) then
							return v260;
						end
					end
					if (v13:BuffDown(v16.Rogue.Commons.CripplingPoison) or ((3790 - 2832) > (5545 - (716 + 1194)))) then
						if (((60 + 3441) <= (482 + 4010)) and v16.Rogue.Commons.AtrophicPoison:IsAvailable()) then
							local v234 = 503 - (74 + 429);
							local v235;
							while true do
								if ((v234 == (0 - 0)) or ((1706 + 1736) < (5832 - 3284))) then
									v235 = v60(v16.Rogue.Commons.AtrophicPoison);
									if (((2034 + 841) >= (4513 - 3049)) and v235) then
										return v235;
									end
									break;
								end
							end
						elseif (v16.Rogue.Commons.NumbingPoison:IsAvailable() or ((11860 - 7063) >= (5326 - (279 + 154)))) then
							local v249 = 778 - (454 + 324);
							local v250;
							while true do
								if ((v249 == (0 + 0)) or ((568 - (12 + 5)) > (1115 + 953))) then
									v250 = v60(v16.Rogue.Commons.NumbingPoison);
									if (((5386 - 3272) > (349 + 595)) and v250) then
										return v250;
									end
									break;
								end
							end
						else
							local v251 = 1093 - (277 + 816);
							local v252;
							while true do
								if ((v251 == (0 - 0)) or ((3445 - (1058 + 125)) >= (581 + 2515))) then
									v252 = v60(v16.Rogue.Commons.CripplingPoison);
									if (v252 or ((3230 - (815 + 160)) >= (15175 - 11638))) then
										return v252;
									end
									break;
								end
							end
						end
					else
						local v220 = v60(v16.Rogue.Commons.CripplingPoison);
						if (v220 or ((9108 - 5271) < (312 + 994))) then
							return v220;
						end
					end
				end;
				break;
			end
			if (((8623 - 5673) == (4848 - (41 + 1857))) and (v57 == (1893 - (1222 + 671)))) then
				v58 = 0 - 0;
				v59 = false;
				v57 = 1 - 0;
			end
		end
	end
	v30.MfDSniping = function(v61)
		if (v61:IsCastable() or ((5905 - (229 + 953)) < (5072 - (1111 + 663)))) then
			local v123, v124 = nil, 1639 - (874 + 705);
			local v125 = (v15:IsInRange(5 + 25) and v15:TimeToDie()) or (7581 + 3530);
			for v127, v128 in v23(v13:GetEnemiesInRange(62 - 32)) do
				local v129 = 0 + 0;
				local v130;
				while true do
					if (((1815 - (642 + 37)) >= (36 + 118)) and (v129 == (0 + 0))) then
						v130 = v128:TimeToDie();
						if ((not v128:IsMfDBlacklisted() and (v130 < (v13:ComboPointsDeficit() * (2.5 - 1))) and (v130 < v124)) or ((725 - (233 + 221)) > (10979 - 6231))) then
							if (((4173 + 567) >= (4693 - (718 + 823))) and ((v125 - v130) > (1 + 0))) then
								v123, v124 = v128, v130;
							else
								v123, v124 = v15, v125;
							end
						end
						break;
					end
				end
			end
			if ((v123 and (v123:GUID() ~= v14:GUID())) or ((3383 - (266 + 539)) >= (9597 - 6207))) then
				v10.Press(v123, v61);
			end
		end
	end;
	v30.CanDoTUnit = function(v62, v63)
		return v20.CanDoTUnit(v62, v63);
	end;
	do
		local v64 = 1225 - (636 + 589);
		local v65;
		local v66;
		local v67;
		local v68;
		while true do
			if (((97 - 56) <= (3425 - 1764)) and (v64 == (0 + 0))) then
				v65 = v16.Rogue.Assassination;
				v66 = v16.Rogue.Subtlety;
				v64 = 1 + 0;
			end
			if (((1616 - (657 + 358)) < (9426 - 5866)) and (v64 == (6 - 3))) then
				v65.Rupture:RegisterPMultiplier(v67, {v66.FinalityRuptureBuff,(1.3 + 0)});
				v65.Garrote:RegisterPMultiplier(v67, v68);
				v64 = 11 - 7;
			end
			if (((2067 - (1552 + 280)) < (1521 - (64 + 770))) and (v64 == (2 + 0))) then
				v68 = nil;
				function v68()
					local v157 = 0 - 0;
					while true do
						if (((808 + 3741) > (2396 - (157 + 1086))) and (v157 == (0 - 0))) then
							if ((v65.ImprovedGarrote:IsAvailable() and (v13:BuffUp(v65.ImprovedGarroteAura, nil, true) or v13:BuffUp(v65.ImprovedGarroteBuff, nil, true) or v13:BuffUp(v65.SepsisBuff, nil, true))) or ((20470 - 15796) < (7166 - 2494))) then
								return 1.5 - 0;
							end
							return 820 - (599 + 220);
						end
					end
				end
				v64 = 5 - 2;
			end
			if (((5599 - (1813 + 118)) < (3334 + 1227)) and (v64 == (1218 - (841 + 376)))) then
				v67 = nil;
				function v67()
					local v158 = 0 - 0;
					while true do
						if (((0 + 0) == v158) or ((1241 - 786) == (4464 - (464 + 395)))) then
							if ((v65.Nightstalker:IsAvailable() and v13:StealthUp(true, false, true)) or ((6834 - 4171) == (1591 + 1721))) then
								return (838 - (467 + 370)) + ((0.05 - 0) * v65.Nightstalker:TalentRank());
							end
							return 1 + 0;
						end
					end
				end
				v64 = 6 - 4;
			end
			if (((668 + 3609) <= (10411 - 5936)) and (v64 == (524 - (150 + 370)))) then
				v65.CrimsonTempest:RegisterPMultiplier(v67);
				break;
			end
		end
	end
	do
		local v69 = v16(194813 - (74 + 1208));
		local v70 = v16(969882 - 575561);
		local v71 = v16(1870099 - 1475779);
		v30.CPMaxSpend = function()
			return 4 + 1 + ((v69:IsAvailable() and (391 - (14 + 376))) or (0 - 0)) + ((v70:IsAvailable() and (1 + 0)) or (0 + 0)) + ((v71:IsAvailable() and (1 + 0)) or (0 - 0));
		end;
	end
	v30.CPSpend = function()
		return v22(v13:ComboPoints(), v30.CPMaxSpend());
	end;
	do
		local v73 = 0 + 0;
		while true do
			if ((v73 == (78 - (23 + 55))) or ((2061 - 1191) == (794 + 395))) then
				v30.AnimachargedCP = function()
					local v159 = 0 + 0;
					while true do
						if (((2407 - 854) <= (986 + 2147)) and (v159 == (901 - (652 + 249)))) then
							if (v13:BuffUp(v16.Rogue.Commons.EchoingReprimand2) or ((5986 - 3749) >= (5379 - (708 + 1160)))) then
								return 5 - 3;
							elseif (v13:BuffUp(v16.Rogue.Commons.EchoingReprimand3) or ((2413 - 1089) > (3047 - (10 + 17)))) then
								return 1 + 2;
							elseif (v13:BuffUp(v16.Rogue.Commons.EchoingReprimand4) or ((4724 - (1400 + 332)) == (3607 - 1726))) then
								return 1912 - (242 + 1666);
							elseif (((1330 + 1776) > (560 + 966)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand5)) then
								return 5 + 0;
							end
							return -(941 - (850 + 90));
						end
					end
				end;
				v30.EffectiveComboPoints = function(v160)
					if (((5293 - 2270) < (5260 - (360 + 1030))) and (((v160 == (2 + 0)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand2)) or ((v160 == (7 - 4)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand3)) or ((v160 == (5 - 1)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand4)) or ((v160 == (1666 - (909 + 752))) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand5)))) then
						return 1230 - (109 + 1114);
					end
					return v160;
				end;
				break;
			end
		end
	end
	do
		local v74 = 0 - 0;
		local v75;
		local v76;
		local v77;
		local v78;
		local v79;
		while true do
			if (((56 + 87) > (316 - (6 + 236))) and (v74 == (1 + 0))) then
				v77 = v16.Rogue.Assassination.AmplifyingPoisonDebuff;
				v78 = v16.Rogue.Assassination.CripplingPoisonDebuff;
				v74 = 2 + 0;
			end
			if (((42 - 24) < (3688 - 1576)) and (v74 == (1133 - (1076 + 57)))) then
				v75 = v16.Rogue.Assassination.DeadlyPoisonDebuff;
				v76 = v16.Rogue.Assassination.WoundPoisonDebuff;
				v74 = 1 + 0;
			end
			if (((1786 - (579 + 110)) <= (129 + 1499)) and (v74 == (2 + 0))) then
				v79 = v16.Rogue.Assassination.AtrophicPoisonDebuff;
				v30.Poisoned = function(v161)
					return ((v161:DebuffUp(v75) or v161:DebuffUp(v77) or v161:DebuffUp(v78) or v161:DebuffUp(v76) or v161:DebuffUp(v79)) and true) or false;
				end;
				break;
			end
		end
	end
	do
		local v80 = 0 + 0;
		local v81;
		local v82;
		local v83;
		local v84;
		local v85;
		local v86;
		while true do
			if (((5037 - (174 + 233)) == (12932 - 8302)) and (v80 == (1 - 0))) then
				v83 = v16.Rogue.Assassination.Rupture;
				v84 = v16.Rogue.Assassination.RuptureDeathmark;
				v80 = 1 + 1;
			end
			if (((4714 - (663 + 511)) > (2394 + 289)) and (v80 == (1 + 2))) then
				v30.PoisonedBleeds = function()
					local v162 = 0 - 0;
					while true do
						if (((2904 + 1890) >= (7710 - 4435)) and (v162 == (2 - 1))) then
							return v86;
						end
						if (((709 + 775) == (2887 - 1403)) and ((0 + 0) == v162)) then
							v86 = 0 + 0;
							for v236, v237 in v23(v13:GetEnemiesInRange(772 - (478 + 244))) do
								if (((1949 - (440 + 77)) < (1617 + 1938)) and v30.Poisoned(v237)) then
									local v253 = 0 - 0;
									while true do
										if ((v253 == (1557 - (655 + 901))) or ((198 + 867) > (2740 + 838))) then
											if (v237:DebuffUp(v85) or ((3238 + 1557) < (5668 - 4261))) then
												v86 = v86 + (1446 - (695 + 750));
											end
											break;
										end
										if (((6327 - 4474) < (7426 - 2613)) and (v253 == (0 - 0))) then
											if (v237:DebuffUp(v81) or ((3172 - (285 + 66)) < (5666 - 3235))) then
												v86 = v86 + (1311 - (682 + 628));
												if (v237:DebuffUp(v82) or ((464 + 2410) < (2480 - (176 + 123)))) then
													v86 = v86 + 1 + 0;
												end
											end
											if (v237:DebuffUp(v83) or ((1951 + 738) <= (612 - (239 + 30)))) then
												local v262 = 0 + 0;
												while true do
													if ((v262 == (0 + 0)) or ((3307 - 1438) == (6267 - 4258))) then
														v86 = v86 + (316 - (306 + 9));
														if (v237:DebuffUp(v84) or ((12374 - 8828) < (404 + 1918))) then
															v86 = v86 + 1 + 0;
														end
														break;
													end
												end
											end
											v253 = 1 + 0;
										end
									end
								end
							end
							v162 = 2 - 1;
						end
					end
				end;
				break;
			end
			if ((v80 == (1377 - (1140 + 235))) or ((1325 + 757) == (4377 + 396))) then
				v85 = v16.Rogue.Assassination.InternalBleeding;
				v86 = 0 + 0;
				v80 = 55 - (33 + 19);
			end
			if (((1172 + 2072) > (3162 - 2107)) and (v80 == (0 + 0))) then
				v81 = v16.Rogue.Assassination.Garrote;
				v82 = v16.Rogue.Assassination.GarroteDeathmark;
				v80 = 1 - 0;
			end
		end
	end
	do
		local v87 = 0 + 0;
		local v88;
		while true do
			if (((689 - (586 + 103)) == v87) or ((302 + 3011) <= (5473 - 3695))) then
				v88 = v29();
				v30.RtBRemains = function(v163)
					local v164 = 1488 - (1309 + 179);
					local v165;
					while true do
						if ((v164 == (0 - 0)) or ((619 + 802) >= (5650 - 3546))) then
							v165 = (v88 - v29()) - v10.RecoveryOffset(v163);
							return ((v165 >= (0 + 0)) and v165) or (0 - 0);
						end
					end
				end;
				v87 = 1 - 0;
			end
			if (((2421 - (295 + 314)) <= (7979 - 4730)) and (v87 == (1963 - (1300 + 662)))) then
				v10:RegisterForSelfCombatEvent(function(v166, v166, v166, v166, v166, v166, v166, v166, v166, v166, v166, v167)
					if (((5096 - 3473) <= (3712 - (1178 + 577))) and (v167 == (163854 + 151654))) then
						v88 = v29() + (88 - 58);
					end
				end, "SPELL_AURA_APPLIED");
				v10:RegisterForSelfCombatEvent(function(v168, v168, v168, v168, v168, v168, v168, v168, v168, v168, v168, v169)
					if (((5817 - (851 + 554)) == (3902 + 510)) and (v169 == (875019 - 559511))) then
						v88 = v29() + v22(86 - 46, (332 - (115 + 187)) + v30.RtBRemains(true));
					end
				end, "SPELL_AURA_REFRESH");
				v87 = 2 + 0;
			end
			if (((1657 + 93) >= (3317 - 2475)) and (v87 == (1163 - (160 + 1001)))) then
				v10:RegisterForSelfCombatEvent(function(v170, v170, v170, v170, v170, v170, v170, v170, v170, v170, v170, v171)
					if (((3825 + 547) > (1277 + 573)) and (v171 == (645886 - 330378))) then
						v88 = v29();
					end
				end, "SPELL_AURA_REMOVED");
				break;
			end
		end
	end
	do
		local v89 = 358 - (237 + 121);
		local v90;
		while true do
			if (((1129 - (525 + 372)) < (1556 - 735)) and (v89 == (6 - 4))) then
				v10:RegisterForSelfCombatEvent(function(v172, v172, v172, v172, v172, v172, v172, v173, v172, v172, v172, v174)
					if (((660 - (96 + 46)) < (1679 - (643 + 134))) and (v174 == (72490 + 128316))) then
						for v227, v228 in v23(v90) do
							for v238, v239 in v23(v228) do
								if (((7178 - 4184) > (3185 - 2327)) and (v238 == v173)) then
									v228[v238] = true;
								end
							end
						end
					end
				end, "SPELL_CAST_SUCCESS");
				v10:RegisterForSelfCombatEvent(function(v175, v175, v175, v175, v175, v175, v175, v176, v175, v175, v175, v177)
					if ((v177 == (116437 + 4974)) or ((7369 - 3614) <= (1870 - 955))) then
						v90.CrimsonTempest[v176] = false;
					elseif (((4665 - (316 + 403)) > (2488 + 1255)) and (v177 == (1932 - 1229))) then
						v90.Garrote[v176] = false;
					elseif ((v177 == (703 + 1240)) or ((3362 - 2027) >= (2343 + 963))) then
						v90.Rupture[v176] = false;
					end
				end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
				v89 = 1 + 2;
			end
			if (((16784 - 11940) > (10759 - 8506)) and (v89 == (5 - 2))) then
				v10:RegisterForSelfCombatEvent(function(v178, v178, v178, v178, v178, v178, v178, v179, v178, v178, v178, v180)
					if (((26 + 426) == (889 - 437)) and (v180 == (5931 + 115480))) then
						if ((v90.CrimsonTempest[v179] ~= nil) or ((13407 - 8850) < (2104 - (12 + 5)))) then
							v90.CrimsonTempest[v179] = nil;
						end
					elseif (((15046 - 11172) == (8265 - 4391)) and (v180 == (1494 - 791))) then
						if ((v90.Garrote[v179] ~= nil) or ((4805 - 2867) > (1002 + 3933))) then
							v90.Garrote[v179] = nil;
						end
					elseif ((v180 == (3916 - (1656 + 317))) or ((3792 + 463) < (2743 + 680))) then
						if (((3865 - 2411) <= (12259 - 9768)) and (v90.Rupture[v179] ~= nil)) then
							v90.Rupture[v179] = nil;
						end
					end
				end, "SPELL_AURA_REMOVED");
				v10:RegisterForCombatEvent(function(v181, v181, v181, v181, v181, v181, v181, v182)
					local v183 = 354 - (5 + 349);
					while true do
						if (((0 - 0) == v183) or ((5428 - (266 + 1005)) <= (1848 + 955))) then
							if (((16558 - 11705) >= (3925 - 943)) and (v90.CrimsonTempest[v182] ~= nil)) then
								v90.CrimsonTempest[v182] = nil;
							end
							if (((5830 - (561 + 1135)) > (4374 - 1017)) and (v90.Garrote[v182] ~= nil)) then
								v90.Garrote[v182] = nil;
							end
							v183 = 3 - 2;
						end
						if ((v183 == (1067 - (507 + 559))) or ((8574 - 5157) < (7836 - 5302))) then
							if ((v90.Rupture[v182] ~= nil) or ((3110 - (212 + 176)) <= (1069 - (250 + 655)))) then
								v90.Rupture[v182] = nil;
							end
							break;
						end
					end
				end, "UNIT_DIED", "UNIT_DESTROYED");
				break;
			end
			if ((v89 == (2 - 1)) or ((4207 - 1799) < (3299 - 1190))) then
				v30.WillLoseExsanguinate = function(v184, v185)
					local v186 = 1956 - (1869 + 87);
					while true do
						if ((v186 == (0 - 0)) or ((1934 - (484 + 1417)) == (3118 - 1663))) then
							if (v30.Exsanguinated(v184, v185) or ((741 - 298) >= (4788 - (48 + 725)))) then
								return true;
							end
							return false;
						end
					end
				end;
				v30.ExsanguinatedRate = function(v187, v188)
					if (((5524 - 2142) > (444 - 278)) and v30.Exsanguinated(v187, v188)) then
						return 2 + 0;
					end
					return 2 - 1;
				end;
				v89 = 1 + 1;
			end
			if (((0 + 0) == v89) or ((1133 - (152 + 701)) == (4370 - (430 + 881)))) then
				v90 = {CrimsonTempest={},Garrote={},Rupture={}};
				v30.Exsanguinated = function(v189, v190)
					local v191 = 0 + 0;
					local v192;
					local v193;
					while true do
						if (((2776 - (557 + 338)) > (383 + 910)) and (v191 == (2 - 1))) then
							v193 = v190:ID();
							if (((8253 - 5896) == (6261 - 3904)) and (v193 == (261660 - 140249))) then
								return v90.CrimsonTempest[v192] or false;
							elseif (((924 - (499 + 302)) == (989 - (39 + 827))) and (v193 == (1940 - 1237))) then
								return v90.Garrote[v192] or false;
							elseif ((v193 == (4339 - 2396)) or ((4194 - 3138) >= (5207 - 1815))) then
								return v90.Rupture[v192] or false;
							end
							v191 = 1 + 1;
						end
						if ((v191 == (5 - 3)) or ((173 + 908) < (1701 - 626))) then
							return false;
						end
						if (((104 - (103 + 1)) == v191) or ((1603 - (475 + 79)) >= (9580 - 5148))) then
							v192 = v189:GUID();
							if (not v192 or ((15257 - 10489) <= (110 + 736))) then
								return false;
							end
							v191 = 1 + 0;
						end
					end
				end;
				v89 = 1504 - (1395 + 108);
			end
		end
	end
	do
		local v91 = v16(569274 - 373647);
		local v92 = 1204 - (7 + 1197);
		local v93 = v29();
		v30.FanTheHammerCP = function()
			local v117 = 0 + 0;
			while true do
				if ((v117 == (0 + 0)) or ((3677 - (27 + 292)) <= (4161 - 2741))) then
					if ((((v29() - v93) < (0.5 - 0)) and (v92 > (0 - 0))) or ((7373 - 3634) <= (5723 - 2718))) then
						if ((v92 > v13:ComboPoints()) or ((1798 - (43 + 96)) >= (8704 - 6570))) then
							return v92;
						else
							v92 = 0 - 0;
						end
					end
					return 0 + 0;
				end
			end
		end;
		v10:RegisterForSelfCombatEvent(function(v118, v118, v118, v118, v118, v118, v118, v118, v118, v118, v118, v119, v118, v118, v120, v121)
			if ((v119 == (52453 + 133310)) or ((6443 - 3183) < (903 + 1452))) then
				if (((v29() - v93) > (0.5 - 0)) or ((211 + 458) == (310 + 3913))) then
					local v217 = 1751 - (1414 + 337);
					while true do
						if ((v217 == (1940 - (1642 + 298))) or ((4410 - 2718) < (1691 - 1103))) then
							v92 = v22(v30.CPMaxSpend(), v13:ComboPoints() + v120 + (v25(0 - 0, v120 - (1 + 0)) * v22(2 + 0, v13:BuffStack(v91) - (973 - (357 + 615)))));
							v93 = v29();
							break;
						end
					end
				end
			end
		end, "SPELL_ENERGIZE");
	end
	do
		local v95 = 0 + 0;
		local v96;
		local v97;
		local v98;
		while true do
			if ((v95 == (2 - 1)) or ((4111 + 686) < (7824 - 4173))) then
				v30.TimeToNextTornado = function()
					local v194 = 0 + 0;
					local v195;
					while true do
						if (((0 + 0) == v194) or ((2626 + 1551) > (6151 - (384 + 917)))) then
							if (not v13:BuffUp(v98, nil, true) or ((1097 - (128 + 569)) > (2654 - (1407 + 136)))) then
								return 1887 - (687 + 1200);
							end
							v195 = v13:BuffRemains(v98, nil, true) % (1711 - (556 + 1154));
							v194 = 3 - 2;
						end
						if (((3146 - (9 + 86)) > (1426 - (275 + 146))) and (v194 == (1 + 0))) then
							if (((3757 - (29 + 35)) <= (19420 - 15038)) and (v29() == v96)) then
								return 0 - 0;
							elseif ((((v29() - v96) < (0.1 - 0)) and (v195 < (0.25 + 0))) or ((4294 - (53 + 959)) > (4508 - (312 + 96)))) then
								return 1 - 0;
							elseif ((((v195 > (285.9 - (147 + 138))) or (v195 == (899 - (813 + 86)))) and ((v29() - v96) > (0.75 + 0))) or ((6632 - 3052) < (3336 - (18 + 474)))) then
								return 0.1 + 0;
							end
							return v195;
						end
					end
				end;
				v10:RegisterForSelfCombatEvent(function(v196, v196, v196, v196, v196, v196, v196, v196, v196, v196, v196, v197)
					local v198 = 0 - 0;
					while true do
						if (((1175 - (860 + 226)) < (4793 - (121 + 182))) and (v198 == (0 + 0))) then
							if ((v197 == (213983 - (988 + 252))) or ((563 + 4420) < (567 + 1241))) then
								v96 = v29();
							elseif (((5799 - (49 + 1921)) > (4659 - (223 + 667))) and (v197 == (197887 - (51 + 1)))) then
								v97 = v29();
							end
							if (((2555 - 1070) <= (6218 - 3314)) and (v97 == v96)) then
								v96 = 1125 - (146 + 979);
							end
							break;
						end
					end
				end, "SPELL_CAST_SUCCESS");
				break;
			end
			if (((1205 + 3064) == (4874 - (311 + 294))) and (v95 == (0 - 0))) then
				v96, v97 = 0 + 0, 1443 - (496 + 947);
				v98 = v16(279283 - (1233 + 125));
				v95 = 1 + 0;
			end
		end
	end
	do
		local v99 = 0 + 0;
		local v100;
		while true do
			if (((74 + 313) <= (4427 - (963 + 682))) and (v99 == (1 + 0))) then
				v10:RegisterForSelfCombatEvent(function()
					local v199 = 1504 - (504 + 1000);
					while true do
						if ((v199 == (1 + 0)) or ((1730 + 169) <= (87 + 830))) then
							v100.LastOH = v29();
							break;
						end
						if ((v199 == (0 - 0)) or ((3685 + 627) <= (510 + 366))) then
							v100.Counter = 182 - (156 + 26);
							v100.LastMH = v29();
							v199 = 1 + 0;
						end
					end
				end, "PLAYER_ENTERING_WORLD");
				v10:RegisterForSelfCombatEvent(function(v200, v200, v200, v200, v200, v200, v200, v200, v200, v200, v200, v201)
					if (((3491 - 1259) <= (2760 - (149 + 15))) and (v201 == (197871 - (890 + 70)))) then
						v100.Counter = 117 - (39 + 78);
					end
				end, "SPELL_ENERGIZE");
				v99 = 484 - (14 + 468);
			end
			if (((4606 - 2511) < (10302 - 6616)) and (v99 == (2 + 0))) then
				v10:RegisterForSelfCombatEvent(function(v202, v202, v202, v202, v202, v202, v202, v202, v202, v202, v202, v202, v202, v202, v202, v202, v202, v202, v202, v202, v202, v202, v202, v203)
					v100.Counter = v100.Counter + 1 + 0;
					if (v203 or ((339 + 1256) >= (2021 + 2453))) then
						v100.LastOH = v29();
					else
						v100.LastMH = v29();
					end
				end, "SWING_DAMAGE");
				v10:RegisterForSelfCombatEvent(function(v205, v205, v205, v205, v205, v205, v205, v205, v205, v205, v205, v205, v205, v205, v205, v206)
					if (v206 or ((1211 + 3408) < (5516 - 2634))) then
						v100.LastOH = v29();
					else
						v100.LastMH = v29();
					end
				end, "SWING_MISSED");
				break;
			end
			if ((v99 == (0 + 0)) or ((1032 - 738) >= (122 + 4709))) then
				v100 = {Counter=(51 - (12 + 39)),LastMH=(0 + 0),LastOH=(0 - 0)};
				v30.TimeToSht = function(v207)
					local v208 = 0 - 0;
					local v209;
					local v210;
					local v211;
					local v212;
					local v213;
					local v214;
					while true do
						if (((602 + 1427) <= (1624 + 1460)) and ((4 - 2) == v208)) then
							v213 = {};
							for v242 = 0 + 0, 9 - 7 do
								v27(v213, v211 + (v242 * v209));
								v27(v213, v212 + (v242 * v210));
							end
							v208 = 1713 - (1596 + 114);
						end
						if ((v208 == (2 - 1)) or ((2750 - (164 + 549)) == (3858 - (1059 + 379)))) then
							v211 = v25(v100.LastMH + v209, v29());
							v212 = v25(v100.LastOH + v210, v29());
							v208 = 2 - 0;
						end
						if (((2311 + 2147) > (659 + 3245)) and (v208 == (392 - (145 + 247)))) then
							if (((358 + 78) >= (57 + 66)) and (v100.Counter >= v207)) then
								return 0 - 0;
							end
							v209, v210 = v28("player");
							v208 = 1 + 0;
						end
						if (((431 + 69) < (2947 - 1131)) and (v208 == (723 - (254 + 466)))) then
							table.sort(v213);
							v214 = v22(565 - (544 + 16), v25(2 - 1, v207 - v100.Counter));
							v208 = 632 - (294 + 334);
						end
						if (((3827 - (236 + 17)) == (1541 + 2033)) and (v208 == (4 + 0))) then
							return v213[v214] - v29();
						end
					end
				end;
				v99 = 3 - 2;
			end
		end
	end
	do
		local v101 = 0 - 0;
		local v102;
		local v103;
		local v104;
		while true do
			if (((114 + 107) < (322 + 68)) and (v101 == (794 - (413 + 381)))) then
				v102 = v13:CritChancePct();
				v103 = 0 + 0;
				v101 = 1 - 0;
			end
			if ((v101 == (4 - 2)) or ((4183 - (582 + 1388)) <= (2420 - 999))) then
				v10:RegisterForEvent(function()
					if (((2189 + 869) < (5224 - (326 + 38))) and (v103 == (0 - 0))) then
						v24.After(3 - 0, v104);
						v103 = 622 - (47 + 573);
					end
				end, "PLAYER_EQUIPMENT_CHANGED");
				v30.BaseAttackCrit = function()
					return v102;
				end;
				break;
			end
			if ((v101 == (1 + 0)) or ((5504 - 4208) >= (7215 - 2769))) then
				v104 = nil;
				function v104()
					local v215 = 1664 - (1269 + 395);
					while true do
						if ((v215 == (492 - (76 + 416))) or ((1836 - (319 + 124)) > (10261 - 5772))) then
							if (not v13:AffectingCombat() or ((5431 - (564 + 443)) < (74 - 47))) then
								local v246 = 458 - (337 + 121);
								while true do
									if ((v246 == (0 - 0)) or ((6652 - 4655) > (5726 - (1261 + 650)))) then
										v102 = v13:CritChancePct();
										v10.Debug("Base Crit Set to: " .. v102);
										break;
									end
								end
							end
							if (((1466 + 1999) > (3047 - 1134)) and ((v103 == nil) or (v103 < (1817 - (772 + 1045))))) then
								v103 = 0 + 0;
							else
								v103 = v103 - (145 - (102 + 42));
							end
							v215 = 1845 - (1524 + 320);
						end
						if (((2003 - (1049 + 221)) < (1975 - (18 + 138))) and (v215 == (2 - 1))) then
							if ((v103 > (1102 - (67 + 1035))) or ((4743 - (136 + 212)) == (20205 - 15450))) then
								v24.After(3 + 0, v104);
							end
							break;
						end
					end
				end
				v101 = 2 + 0;
			end
		end
	end
	do
		local v105 = 1604 - (240 + 1364);
		local v106;
		local v107;
		local v108;
		local v109;
		while true do
			if (((1082 - (1050 + 32)) == v105) or ((13543 - 9750) < (1402 + 967))) then
				v106 = v16.Rogue.Assassination;
				v107 = v16.Rogue.Subtlety;
				v105 = 1056 - (331 + 724);
			end
			if (((1 + 0) == v105) or ((4728 - (269 + 375)) == (990 - (267 + 458)))) then
				v108 = nil;
				function v108()
					local v216 = 0 + 0;
					while true do
						if (((8380 - 4022) == (5176 - (667 + 151))) and (v216 == (1497 - (1410 + 87)))) then
							if ((v106.Nightstalker:IsAvailable() and v13:StealthUp(true, false, true)) or ((5035 - (1504 + 393)) < (2684 - 1691))) then
								return (2 - 1) + ((796.05 - (461 + 335)) * v106.Nightstalker:TalentRank());
							end
							return 1 + 0;
						end
					end
				end
				v105 = 1763 - (1730 + 31);
			end
			if (((4997 - (728 + 939)) > (8227 - 5904)) and ((5 - 2) == v105)) then
				v106.Rupture:RegisterPMultiplier(v108, {v107.FinalityRuptureBuff,(1.3 + 0)});
				v106.Garrote:RegisterPMultiplier(v108, v109);
				break;
			end
			if ((v105 == (2 + 0)) or ((3108 + 518) == (16287 - 12298))) then
				v109 = nil;
				function v109()
					if ((v106.ImprovedGarrote:IsAvailable() and (v13:BuffUp(v106.ImprovedGarroteAura, nil, true) or v13:BuffUp(v106.ImprovedGarroteBuff, nil, true) or v13:BuffUp(v106.SepsisBuff, nil, true))) or ((2682 - (459 + 1307)) == (4541 - (474 + 1396)))) then
						return 1.5 - 0;
					end
					return 1 + 0;
				end
				v105 = 1 + 2;
			end
		end
	end
end;
return v0["Epix_Rogue_Rogue.lua"]();

