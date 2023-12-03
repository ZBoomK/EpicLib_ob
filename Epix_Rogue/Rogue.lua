local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((3997 - 1863) == (5720 - 3586)) and (v5 == (1227 - (322 + 905)))) then
			v6 = v0[v4];
			if (not v6 or ((2765 - (602 + 9)) >= (4514 - (449 + 740)))) then
				return v1(v4, ...);
			end
			v5 = 873 - (826 + 46);
		end
		if ((v5 == (948 - (245 + 702))) or ((4092 - 2797) >= (1040 + 2193))) then
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
	if (((6275 - (260 + 1638)) > (2082 - (382 + 58))) and not v16.Rogue) then
		v16.Rogue = {};
	end
	v16.Rogue.Commons = {Sanguine=v16(726660 - 500150, nil, 1 + 0),AncestralCall=v16(567800 - 293062, nil, 5 - 3),ArcanePulse=v16(261569 - (902 + 303), nil, 5 - 2),ArcaneTorrent=v16(60323 - 35277, nil, 1 + 3),BagofTricks=v16(314101 - (1121 + 569), nil, 219 - (22 + 192)),Berserking=v16(26980 - (483 + 200), nil, 1469 - (1404 + 59)),BloodFury=v16(56300 - 35728, nil, 9 - 2),Fireblood=v16(265986 - (468 + 297), nil, 570 - (334 + 228)),LightsJudgment=v16(862293 - 606646, nil, 20 - 11),Shadowmeld=v16(106975 - 47991, nil, 3 + 7),CloakofShadows=v16(31460 - (141 + 95), nil, 11 + 0),CrimsonVial=v16(476991 - 291680, nil, 28 - 16),Evasion=v16(1237 + 4040, nil, 35 - 22),Feint=v16(1383 + 583, nil, 8 + 6),Blind=v16(2948 - 854, nil, 9 + 6),CheapShot=v16(1996 - (92 + 71), nil, 8 + 8),Kick=v16(2968 - 1202, nil, 782 - (574 + 191)),KidneyShot=v16(337 + 71, nil, 44 - 26),Sap=v16(3459 + 3311, nil, 868 - (254 + 595)),Shiv=v16(6064 - (55 + 71), nil, 26 - 6),SliceandDice=v16(317286 - (573 + 1217), nil, 58 - 37),Shadowstep=v16(2782 + 33772, nil, 34 - 12),Sprint=v16(3922 - (714 + 225), nil, 66 - 43),TricksoftheTrade=v16(80769 - 22835, nil, 3 + 21),CripplingPoison=v16(4934 - 1526, nil, 831 - (118 + 688)),DeadlyPoison=v16(2871 - (25 + 23), nil, 6 + 20),InstantPoison=v16(317470 - (927 + 959), nil, 90 - 63),AmplifyingPoison=v16(382396 - (16 + 716), nil, 53 - 25),NumbingPoison=v16(5858 - (11 + 86), nil, 70 - 41),WoundPoison=v16(8964 - (175 + 110), nil, 75 - 45),AtrophicPoison=v16(1882329 - 1500692, nil, 1827 - (503 + 1293)),AcrobaticStrikes=v16(549969 - 353045, nil, 24 + 8),Alacrity=v16(194600 - (810 + 251), nil, 23 + 10),ColdBlood=v16(117312 + 264933, nil, 31 + 3),DeeperStratagem=v16(194064 - (43 + 490)),EchoingReprimand=v16(386349 - (711 + 22), nil, 139 - 103),EchoingReprimand2=v16(324417 - (240 + 619), nil, 9 + 28),EchoingReprimand3=v16(514686 - 191127, nil, 3 + 35),EchoingReprimand4=v16(325304 - (1344 + 400), nil, 444 - (255 + 150)),EchoingReprimand5=v16(279498 + 75340, nil, 22 + 18),FindWeakness=v16(388902 - 297879, nil, 132 - 91),FindWeaknessDebuff=v16(317959 - (404 + 1335), nil, 448 - (183 + 223)),ImprovedAmbush=v16(464379 - 82759, nil, 29 + 14),MarkedforDeath=v16(49526 + 88093, nil, 381 - (10 + 327)),Nightstalker=v16(9793 + 4269, nil, 383 - (118 + 220)),ResoundingClarity=v16(127177 + 254445, nil, 495 - (108 + 341)),SealFate=v16(6374 + 7816, nil, 198 - 151),Sepsis=v16(386901 - (711 + 782), nil, 91 - 43),SepsisBuff=v16(376408 - (270 + 199), nil, 16 + 33),ShadowDance=v16(187132 - (580 + 1239), nil, 148 - 98),ShadowDanceTalent=v16(377614 + 17316, nil, 2 + 49),ShadowDanceBuff=v16(80775 + 104647),Subterfuge=v16(282527 - 174319, nil, 33 + 20),SubterfugeBuff=v16(116359 - (645 + 522), nil, 1844 - (1010 + 780)),ThistleTea=v16(381435 + 188, nil, 1524 - 1204),Vigor=v16(43907 - 28924),Stealth=v16(3620 - (1045 + 791), nil, 144 - 87),Stealth2=v16(175890 - 60699, nil, 563 - (351 + 154)),Vanish=v16(3430 - (1281 + 293), nil, 325 - (28 + 238)),VanishBuff=v16(25309 - 13982, nil, 1619 - (1381 + 178)),VanishBuff2=v16(108044 + 7149, nil, 50 + 11),PoolEnergy=v16(426520 + 573390, nil, 213 - 151)};
	v16.Rogue.Assassination = v19(v16.Rogue.Commons, {Ambush=v16(4495 + 4181, nil, 533 - (381 + 89)),AmplifyingPoisonDebuff=v16(340008 + 43406, nil, 44 + 20),AmplifyingPoisonDebuffDeathmark=v16(675479 - 281151, nil, 1221 - (1074 + 82)),CripplingPoisonDebuff=v16(7470 - 4061, nil, 1850 - (214 + 1570)),DeadlyPoisonDebuff=v16(4273 - (990 + 465), nil, 28 + 39),DeadlyPoisonDebuffDeathmark=v16(171579 + 222745, nil, 67 + 1),Envenom=v16(128475 - 95830, nil, 1795 - (1668 + 58)),FanofKnives=v16(52349 - (512 + 114), nil, 182 - 112),Garrote=v16(1452 - 749, nil, 246 - 175),GarroteDeathmark=v16(167863 + 192967, nil, 14 + 58),Mutilate=v16(1156 + 173, nil, 246 - 173),PoisonedKnife=v16(187559 - (109 + 1885), nil, 1543 - (1269 + 200)),Rupture=v16(3723 - 1780, nil, 890 - (98 + 717)),RuptureDeathmark=v16(361652 - (802 + 24), nil, 130 - 54),WoundPoisonDebuff=v16(10962 - 2282, nil, 12 + 65),ArterialPrecision=v16(307931 + 92852, nil, 13 + 65),AtrophicPoisonDebuff=v16(84641 + 307747, nil, 219 - 140),BlindsideBuff=v16(404016 - 282863, nil, 29 + 51),CrimsonTempest=v16(49422 + 71989, nil, 67 + 14),CutToTheChase=v16(37569 + 14098, nil, 39 + 43),DashingScoundrel=v16(383230 - (797 + 636), nil, 402 - 319),Deathmark=v16(361813 - (1427 + 192), nil, 30 + 54),Doomblade=v16(886158 - 504485, nil, 77 + 8),DragonTemperedBlades=v16(173026 + 208775, nil, 412 - (192 + 134)),Elusiveness=v16(80284 - (316 + 960)),Exsanguinate=v16(111748 + 89058, nil, 68 + 20),ImprovedGarrote=v16(352746 + 28886, nil, 340 - 251),ImprovedGarroteBuff=v16(392952 - (83 + 468), nil, 1896 - (1202 + 604)),ImprovedGarroteAura=v16(1831812 - 1439409, nil, 151 - 60),IndiscriminateCarnage=v16(1057110 - 675308, nil, 417 - (45 + 280)),InternalBleeding=v16(149560 + 5393, nil, 82 + 11),Kingsbane=v16(140809 + 244818, nil, 53 + 41),LightweightShiv=v16(69474 + 325509),MasterAssassin=v16(474033 - 218044, nil, 2006 - (340 + 1571)),MasterAssassinBuff=v16(101263 + 155472, nil, 1868 - (1733 + 39)),PreyontheWeak=v16(361378 - 229867, nil, 1131 - (125 + 909)),PreyontheWeakDebuff=v16(257857 - (1096 + 852), nil, 44 + 54),SerratedBoneSpike=v16(550426 - 165002, nil, 97 + 2),SerratedBoneSpikeDebuff=v16(394548 - (409 + 103), nil, 336 - (46 + 190)),ShivDebuff=v16(319599 - (51 + 44), nil, 29 + 72),VenomRush=v16(153469 - (1114 + 203), nil, 828 - (228 + 498)),ScentOfBlood=v16(82719 + 299080, nil, 219 + 177),ScentOfBloodBuff=v16(394743 - (174 + 489))});
	v16.Rogue.Outlaw = v19(v16.Rogue.Commons, {AdrenalineRush=v16(35822 - 22072, nil, 2008 - (830 + 1075)),Ambush=v16(9200 - (303 + 221), nil, 1373 - (231 + 1038)),BetweentheEyes=v16(262777 + 52564, nil, 1267 - (171 + 991)),BladeFlurry=v16(57189 - 43312, nil, 284 - 178),Dispatch=v16(5235 - 3137, nil, 86 + 21),Elusiveness=v16(276951 - 197943),Opportunity=v16(564345 - 368718),PistolShot=v16(299443 - 113680, nil, 340 - 230),RolltheBones=v16(316756 - (111 + 1137), nil, 269 - (91 + 67)),SinisterStrike=v16(575353 - 382038, nil, 28 + 84),Audacity=v16(382368 - (423 + 100), nil, 1 + 112),AudacityBuff=v16(1069526 - 683256, nil, 60 + 54),BladeRush=v16(272648 - (326 + 445), nil, 501 - 386),CountTheOdds=v16(850987 - 469005, nil, 270 - 154),Dreadblades=v16(343853 - (530 + 181), nil, 998 - (614 + 267)),FanTheHammer=v16(381878 - (19 + 13), nil, 191 - 73),GhostlyStrike=v16(458930 - 261993, nil, 339 - 220),GreenskinsWickers=v16(100462 + 286361, nil, 211 - 91),GreenskinsWickersBuff=v16(817367 - 423236, nil, 1933 - (1293 + 519)),HiddenOpportunity=v16(782013 - 398732, nil, 318 - 196),ImprovedAdrenalineRush=v16(756174 - 360752, nil, 530 - 407),ImprovedBetweenTheEyes=v16(554738 - 319254, nil, 66 + 58),KeepItRolling=v16(77933 + 304056, nil, 290 - 165),KillingSpree=v16(11945 + 39745, nil, 42 + 84),LoadedDice=v16(160085 + 96085, nil, 1223 - (709 + 387)),LoadedDiceBuff=v16(258029 - (673 + 1185), nil, 371 - 243),PreyontheWeak=v16(422306 - 290795, nil, 211 - 82),PreyontheWeakDebuff=v16(183041 + 72868, nil, 98 + 32),QuickDraw=v16(265897 - 68959, nil, 33 + 98),SummarilyDispatched=v16(761656 - 379666, nil, 258 - 126),SwiftSlasher=v16(383868 - (446 + 1434), nil, 1416 - (1040 + 243)),TakeEmBySurpriseBuff=v16(1151784 - 765877, nil, 1981 - (559 + 1288)),Weaponmaster=v16(202664 - (609 + 1322), nil, 589 - (13 + 441)),UnderhandedUpperhand=v16(1584582 - 1160538),DeftManeuvers=v16(1000277 - 618399),Crackshot=v16(2110227 - 1686524),Gouge=v16(67 + 1709, nil, 493 - 357),Broadside=v16(68676 + 124680, nil, 61 + 76),BuriedTreasure=v16(592318 - 392718, nil, 76 + 62),GrandMelee=v16(355625 - 162267, nil, 92 + 47),RuthlessPrecision=v16(107542 + 85815, nil, 101 + 39),SkullandCrossbones=v16(167598 + 32005, nil, 138 + 3),TrueBearing=v16(193792 - (153 + 280), nil, 409 - 267),ViciousFollowup=v16(354522 + 40357, nil, 57 + 86)});
	v16.Rogue.Subtlety = v19(v16.Rogue.Commons, {Backstab=v16(28 + 25, nil, 131 + 13),BlackPowder=v16(231275 + 87900, nil, 220 - 75),Elusiveness=v16(48832 + 30176),Eviscerate=v16(197486 - (89 + 578), nil, 106 + 41),Rupture=v16(4038 - 2095, nil, 1197 - (572 + 477)),ShadowBlades=v16(16383 + 105088, nil, 90 + 59),Shadowstrike=v16(22135 + 163303, nil, 236 - (84 + 2)),ShurikenStorm=v16(326046 - 128211, nil, 109 + 42),ShurikenToss=v16(114856 - (497 + 345), nil, 4 + 148),SymbolsofDeath=v16(35886 + 176397, nil, 1486 - (605 + 728)),DanseMacabre=v16(272926 + 109602, nil, 341 - 187),DanseMacabreBuff=v16(18056 + 375913, nil, 573 - 418),DeeperDaggers=v16(344838 + 37679, nil, 431 - 275),DeeperDaggersBuff=v16(289491 + 93914, nil, 646 - (457 + 32)),DarkBrew=v16(162287 + 220217, nil, 1560 - (832 + 570)),DarkShadow=v16(231459 + 14228, nil, 42 + 117),EnvelopingShadows=v16(842605 - 604501, nil, 78 + 82),Finality=v16(383321 - (588 + 208), nil, 433 - 272),FinalityBlackPowderBuff=v16(387748 - (884 + 916), nil, 338 - 176),FinalityEviscerateBuff=v16(223780 + 162169, nil, 816 - (232 + 421)),FinalityRuptureBuff=v16(387840 - (1569 + 320), nil, 41 + 123),Flagellation=v16(73075 + 311556, nil, 556 - 391),FlagellationPersistBuff=v16(395363 - (316 + 289), nil, 434 - 268),Gloomblade=v16(9272 + 191486, nil, 1620 - (666 + 787)),ImprovedShadowDance=v16(394397 - (360 + 65), nil, 158 + 10),ImprovedShurikenStorm=v16(320205 - (79 + 175), nil, 265 - 96),LingeringShadow=v16(298501 + 84023, nil, 521 - 351),LingeringShadowBuff=v16(743304 - 357344, nil, 1070 - (503 + 396)),MasterofShadows=v16(197157 - (92 + 89), nil, 333 - 161),PerforatedVeins=v16(196171 + 186347, nil, 103 + 70),PerforatedVeinsBuff=v16(1543954 - 1149700, nil, 24 + 150),PreyontheWeak=v16(299862 - 168351, nil, 153 + 22),PreyontheWeakDebuff=v16(122231 + 133678, nil, 535 - 359),Premeditation=v16(42830 + 300330, nil, 269 - 92),PremeditationBuff=v16(344417 - (485 + 759), nil, 411 - 233),SecretStratagem=v16(395509 - (442 + 747), nil, 1314 - (832 + 303)),SecretTechnique=v16(281665 - (88 + 858), nil, 55 + 125),ShadowFocus=v16(89554 + 18655, nil, 8 + 173),ShurikenTornado=v16(278714 - (766 + 23), nil, 898 - 716),SilentStorm=v16(527535 - 141813, nil, 482 - 299),SilentStormBuff=v16(1309153 - 923431, nil, 1257 - (1036 + 37)),TheFirstDance=v16(271187 + 111318, nil, 360 - 175),TheRotten=v16(300506 + 81509, nil, 1666 - (641 + 839)),TheRottenBuff=v16(395116 - (910 + 3), nil, 476 - 289),Weaponmaster=v16(195221 - (1466 + 218), nil, 87 + 101)});
	if (((5871 - (556 + 592)) > (483 + 873)) and not v18.Rogue) then
		v18.Rogue = {};
	end
	v18.Rogue.Commons = {AlgetharPuzzleBox=v18(194509 - (329 + 479), {(44 - 31),(10 + 4)}),ManicGrieftorch=v18(195047 - (396 + 343), {(1490 - (29 + 1448)),(52 - 38)}),WindscarWhetstone=v18(641939 - 504453, {(1540 - (389 + 1138)),(14 + 0)}),Healthstone=v18(3057 + 2455),RefreshingHealingPotion=v18(178449 + 12931)};
	v18.Rogue.Assassination = v19(v18.Rogue.Commons, {AlgetharPuzzleBox=v18(195246 - (320 + 1225), {(8 + 5),(1873 - (821 + 1038))}),AshesoftheEmbersoul=v18(516879 - 309712, {(22 - 9),(34 - 20)}),WitherbarksBranch=v18(111025 - (834 + 192), {(4 + 9),(21 - 7)})});
	v18.Rogue.Outlaw = v19(v18.Rogue.Commons, {ManicGrieftorch=v18(194612 - (300 + 4), {(33 - 20),(6 + 8)}),WindscarWhetstone=v18(344437 - 206951, {(7 + 6),(7 + 7)}),BeaconToTheBeyond=v18(151520 + 52443, {(28 - 15),(707 - (627 + 66))}),DragonfireBombDispenser=v18(603704 - 401094, {(1919 - (1665 + 241)),(7 + 7)})});
	v18.Rogue.Subtlety = v19(v18.Rogue.Commons, {ManicGrieftorch=v18(51413 + 142895, {(21 - 8),(11 + 3)}),StormEatersBoon=v18(415715 - 221413, {(1249 - (298 + 938)),(1680 - (636 + 1030))}),BeaconToTheBeyond=v18(104280 + 99683, {(4 + 9),(235 - (55 + 166))})});
	if (not v21.Rogue or ((802 + 3334) <= (346 + 3087))) then
		v21.Rogue = {};
	end
	v21.Rogue.Commons = {Healthstone=v21(80 - 59),BlindMouseover=v21(306 - (36 + 261)),CheapShotMouseover=v21(17 - 7),KickMouseover=v21(1379 - (34 + 1334)),KidneyShotMouseover=v21(5 + 7),TricksoftheTradeFocus=v21(11 + 2),WindscarWhetstone=v21(1309 - (1035 + 248))};
	v21.Rogue.Outlaw = v19(v21.Rogue.Commons, {Dispatch=v21(35 - (20 + 1)),PistolShotMouseover=v21(8 + 7),SinisterStrikeMouseover=v21(335 - (134 + 185))});
	v21.Rogue.Subtlety = v19(v21.Rogue.Commons, {SecretTechnique=v21(1149 - (549 + 584)),ShadowDance=v21(702 - (314 + 371)),ShadowDanceSymbol=v21(89 - 63),VanishShadowstrike=v21(986 - (478 + 490)),ShurikenStormSD=v21(11 + 8),ShurikenStormVanish=v21(1192 - (786 + 386)),GloombladeSD=v21(71 - 49),GloombladeVanish=v21(1402 - (1055 + 324)),BackstabMouseover=v21(1364 - (1093 + 247)),RuptureMouseover=v21(23 + 2)});
	v30.StealthSpell = function()
		return (v16.Rogue.Commons.Subterfuge:IsAvailable() and v16.Rogue.Commons.Stealth2) or v16.Rogue.Commons.Stealth;
	end;
	v30.VanishBuffSpell = function()
		return (v16.Rogue.Commons.Subterfuge:IsAvailable() and v16.Rogue.Commons.VanishBuff2) or v16.Rogue.Commons.VanishBuff;
	end;
	v30.Stealth = function(v49, v50)
		if (((447 + 3798) <= (18385 - 13754)) and EpicSettings.Settings['StealthOOC'] and (v16.Rogue.Commons.Stealth:IsCastable() or v16.Rogue.Commons.Stealth2:IsCastable()) and v13:StealthDown()) then
			if (((14511 - 10235) >= (11136 - 7222)) and v10.Press(v49, nil)) then
				return "Cast Stealth (OOC)";
			end
		end
		return false;
	end;
	do
		local v51 = 0 - 0;
		local v52;
		while true do
			if (((71 + 127) <= (16815 - 12450)) and (v51 == (0 - 0))) then
				v52 = v16(139731 + 45580);
				v30.CrimsonVial = function()
					local v163 = EpicSettings.Settings['CrimsonVialHP'] or (0 - 0);
					if (((5470 - (364 + 324)) > (12818 - 8142)) and v52:IsCastable() and (v13:HealthPercentage() <= v163)) then
						if (((11671 - 6807) > (729 + 1468)) and v10.Cast(v52, nil)) then
							return "Cast Crimson Vial (Defensives)";
						end
					end
					return false;
				end;
				break;
			end
		end
	end
	do
		local v53 = 0 - 0;
		local v54;
		while true do
			if ((v53 == (0 - 0)) or ((11237 - 7537) == (3775 - (1249 + 19)))) then
				v54 = v16(1775 + 191);
				v30.Feint = function()
					local v164 = EpicSettings.Settings['FeintHP'] or (0 - 0);
					if (((5560 - (686 + 400)) >= (215 + 59)) and v54:IsCastable() and v13:BuffDown(v54) and (v13:HealthPercentage() <= v164)) then
						if (v10.Cast(v54, nil) or ((2123 - (73 + 156)) <= (7 + 1399))) then
							return "Cast Feint (Defensives)";
						end
					end
				end;
				break;
			end
		end
	end
	do
		local v55 = 811 - (721 + 90);
		local v56;
		local v57;
		local v58;
		while true do
			if (((18 + 1554) >= (4970 - 3439)) and (v55 == (470 - (224 + 246)))) then
				v56 = 0 - 0;
				v57 = false;
				v55 = 1 - 0;
			end
			if ((v55 == (1 + 0)) or ((112 + 4575) < (3336 + 1206))) then
				v58 = nil;
				function v58(v165)
					if (((6542 - 3251) > (5547 - 3880)) and not v13:AffectingCombat() and v13:BuffRefreshable(v165)) then
						if (v10.Press(v165, nil, true) or ((1386 - (203 + 310)) == (4027 - (1238 + 755)))) then
							return "poison";
						end
					end
				end
				v55 = 1 + 1;
			end
			if ((v55 == (1536 - (709 + 825))) or ((5188 - 2372) < (15 - 4))) then
				v30.Poisons = function()
					v57 = v13:BuffUp(v16.Rogue.Commons.WoundPoison);
					if (((4563 - (196 + 668)) < (18580 - 13874)) and v16.Rogue.Assassination.DragonTemperedBlades:IsAvailable()) then
						local v203 = v58((v57 and v16.Rogue.Commons.WoundPoison) or v16.Rogue.Commons.DeadlyPoison);
						if (((5480 - 2834) >= (1709 - (171 + 662))) and v203) then
							return v203;
						end
						if (((707 - (4 + 89)) <= (11159 - 7975)) and v16.Rogue.Commons.AmplifyingPoison:IsAvailable()) then
							local v218 = 0 + 0;
							while true do
								if (((13729 - 10603) == (1226 + 1900)) and (v218 == (1486 - (35 + 1451)))) then
									v203 = v58(v16.Rogue.Commons.AmplifyingPoison);
									if (v203 or ((3640 - (28 + 1425)) >= (6947 - (941 + 1052)))) then
										return v203;
									end
									break;
								end
							end
						else
							local v219 = 0 + 0;
							while true do
								if ((v219 == (1514 - (822 + 692))) or ((5534 - 1657) == (1684 + 1891))) then
									v203 = v58(v16.Rogue.Commons.InstantPoison);
									if (((1004 - (45 + 252)) > (626 + 6)) and v203) then
										return v203;
									end
									break;
								end
							end
						end
					elseif (v57 or ((188 + 358) >= (6531 - 3847))) then
						local v220 = v58(v16.Rogue.Commons.WoundPoison);
						if (((1898 - (114 + 319)) <= (6175 - 1874)) and v220) then
							return v220;
						end
					elseif (((2182 - 478) > (909 + 516)) and v16.Rogue.Commons.AmplifyingPoison:IsAvailable() and v13:BuffDown(v16.Rogue.Commons.DeadlyPoison)) then
						local v228 = v58(v16.Rogue.Commons.AmplifyingPoison);
						if (v228 or ((1022 - 335) == (8871 - 4637))) then
							return v228;
						end
					elseif (v16.Rogue.Commons.DeadlyPoison:IsAvailable() or ((5293 - (556 + 1407)) < (2635 - (741 + 465)))) then
						local v236 = v58(v16.Rogue.Commons.DeadlyPoison);
						if (((1612 - (170 + 295)) >= (177 + 158)) and v236) then
							return v236;
						end
					else
						local v237 = v58(v16.Rogue.Commons.InstantPoison);
						if (((3156 + 279) > (5162 - 3065)) and v237) then
							return v237;
						end
					end
					if (v13:BuffDown(v16.Rogue.Commons.CripplingPoison) or ((3126 + 644) >= (2592 + 1449))) then
						if (v16.Rogue.Commons.AtrophicPoison:IsAvailable() or ((2147 + 1644) <= (2841 - (957 + 273)))) then
							local v221 = v58(v16.Rogue.Commons.AtrophicPoison);
							if (v221 or ((1225 + 3353) <= (804 + 1204))) then
								return v221;
							end
						elseif (((4286 - 3161) <= (5470 - 3394)) and v16.Rogue.Commons.NumbingPoison:IsAvailable()) then
							local v229 = 0 - 0;
							local v230;
							while true do
								if ((v229 == (0 - 0)) or ((2523 - (389 + 1391)) >= (2760 + 1639))) then
									v230 = v58(v16.Rogue.Commons.NumbingPoison);
									if (((121 + 1034) < (3808 - 2135)) and v230) then
										return v230;
									end
									break;
								end
							end
						else
							local v231 = v58(v16.Rogue.Commons.CripplingPoison);
							if (v231 or ((3275 - (783 + 168)) <= (1939 - 1361))) then
								return v231;
							end
						end
					else
						local v204 = v58(v16.Rogue.Commons.CripplingPoison);
						if (((3706 + 61) == (4078 - (309 + 2))) and v204) then
							return v204;
						end
					end
				end;
				break;
			end
		end
	end
	v30.MfDSniping = function(v59)
		if (((12556 - 8467) == (5301 - (1090 + 122))) and v59:IsCastable()) then
			local v135 = 0 + 0;
			local v136;
			local v137;
			local v138;
			while true do
				if (((14972 - 10514) >= (1146 + 528)) and (v135 == (1119 - (628 + 490)))) then
					for v205, v206 in v23(v13:GetEnemiesInRange(6 + 24)) do
						local v207 = v206:TimeToDie();
						if (((2406 - 1434) <= (6480 - 5062)) and not v206:IsMfDBlacklisted() and (v207 < (v13:ComboPointsDeficit() * (775.5 - (431 + 343)))) and (v207 < v137)) then
							if (((v138 - v207) > (1 - 0)) or ((14285 - 9347) < (3763 + 999))) then
								v136, v137 = v206, v207;
							else
								v136, v137 = v15, v138;
							end
						end
					end
					if ((v136 and (v136:GUID() ~= v14:GUID())) or ((321 + 2183) > (5959 - (556 + 1139)))) then
						v10.CastLeftNameplate(v136, v59);
					end
					break;
				end
				if (((2168 - (6 + 9)) == (395 + 1758)) and ((0 + 0) == v135)) then
					v136, v137 = nil, 229 - (28 + 141);
					v138 = (v15:IsInRange(12 + 18) and v15:TimeToDie()) or (13714 - 2603);
					v135 = 1 + 0;
				end
			end
		end
	end;
	v30.CanDoTUnit = function(v60, v61)
		return v20.CanDoTUnit(v60, v61);
	end;
	do
		local v62 = 1317 - (486 + 831);
		local v63;
		local v64;
		local v65;
		local v66;
		while true do
			if ((v62 == (0 - 0)) or ((1784 - 1277) >= (490 + 2101))) then
				v63 = v16.Rogue.Assassination;
				v64 = v16.Rogue.Subtlety;
				v62 = 3 - 2;
			end
			if (((5744 - (668 + 595)) == (4033 + 448)) and ((1 + 0) == v62)) then
				v65 = nil;
				function v65()
					if ((v63.Nightstalker:IsAvailable() and v13:StealthUp(true, false, true)) or ((6348 - 4020) < (983 - (23 + 267)))) then
						return (1945 - (1129 + 815)) + ((387.05 - (371 + 16)) * v63.Nightstalker:TalentRank());
					end
					return 1751 - (1326 + 424);
				end
				v62 = 3 - 1;
			end
			if (((15815 - 11487) == (4446 - (88 + 30))) and (v62 == (775 - (720 + 51)))) then
				v63.CrimsonTempest:RegisterPMultiplier(v65);
				break;
			end
			if (((3532 - 1944) >= (3108 - (421 + 1355))) and (v62 == (4 - 1))) then
				v63.Rupture:RegisterPMultiplier(v65, {v64.FinalityRuptureBuff,(3.3 - 2)});
				v63.Garrote:RegisterPMultiplier(v65, v66);
				v62 = 6 - 2;
			end
			if ((v62 == (441 - (397 + 42))) or ((1304 + 2870) > (5048 - (24 + 776)))) then
				v66 = nil;
				function v66()
					if ((v63.ImprovedGarrote:IsAvailable() and (v13:BuffUp(v63.ImprovedGarroteAura, nil, true) or v13:BuffUp(v63.ImprovedGarroteBuff, nil, true) or v13:BuffUp(v63.SepsisBuff, nil, true))) or ((7064 - 2478) <= (867 - (222 + 563)))) then
						return 1.5 - 0;
					end
					return 1 + 0;
				end
				v62 = 193 - (23 + 167);
			end
		end
	end
	do
		local v67 = v16(195329 - (690 + 1108));
		local v68 = v16(142269 + 252052);
		local v69 = v16(325253 + 69067);
		v30.CPMaxSpend = function()
			return (853 - (40 + 808)) + ((v67:IsAvailable() and (1 + 0)) or (0 - 0)) + ((v68:IsAvailable() and (1 + 0)) or (0 + 0)) + ((v69:IsAvailable() and (1 + 0)) or (571 - (47 + 524)));
		end;
	end
	v30.CPSpend = function()
		return v22(v13:ComboPoints(), v30.CPMaxSpend());
	end;
	do
		local v71 = 0 + 0;
		while true do
			if (((10559 - 6696) == (5776 - 1913)) and (v71 == (0 - 0))) then
				v30.AnimachargedCP = function()
					local v166 = 1726 - (1165 + 561);
					while true do
						if ((v166 == (0 + 0)) or ((873 - 591) <= (17 + 25))) then
							if (((5088 - (341 + 138)) >= (207 + 559)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand2)) then
								return 3 - 1;
							elseif (v13:BuffUp(v16.Rogue.Commons.EchoingReprimand3) or ((1478 - (89 + 237)) == (8003 - 5515))) then
								return 6 - 3;
							elseif (((4303 - (581 + 300)) > (4570 - (855 + 365))) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand4)) then
								return 9 - 5;
							elseif (((287 + 590) > (1611 - (1030 + 205))) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand5)) then
								return 5 + 0;
							end
							return -(1 + 0);
						end
					end
				end;
				v30.EffectiveComboPoints = function(v167)
					if (((v167 == (288 - (156 + 130))) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand2)) or ((v167 == (6 - 3)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand3)) or ((v167 == (6 - 2)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand4)) or ((v167 == (10 - 5)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand5)) or ((822 + 2296) <= (1080 + 771))) then
						return 76 - (10 + 59);
					end
					return v167;
				end;
				break;
			end
		end
	end
	do
		local v72 = v16.Rogue.Assassination.DeadlyPoisonDebuff;
		local v73 = v16.Rogue.Assassination.WoundPoisonDebuff;
		local v74 = v16.Rogue.Assassination.AmplifyingPoisonDebuff;
		local v75 = v16.Rogue.Assassination.CripplingPoisonDebuff;
		local v76 = v16.Rogue.Assassination.AtrophicPoisonDebuff;
		v30.Poisoned = function(v111)
			return ((v111:DebuffUp(v72) or v111:DebuffUp(v74) or v111:DebuffUp(v75) or v111:DebuffUp(v73) or v111:DebuffUp(v76)) and true) or false;
		end;
	end
	do
		local v78 = 0 + 0;
		local v79;
		local v80;
		local v81;
		local v82;
		local v83;
		local v84;
		while true do
			if ((v78 == (0 - 0)) or ((1328 - (671 + 492)) >= (2780 + 712))) then
				v79 = v16.Rogue.Assassination.Garrote;
				v80 = v16.Rogue.Assassination.GarroteDeathmark;
				v78 = 1216 - (369 + 846);
			end
			if (((1046 + 2903) < (4145 + 711)) and (v78 == (1947 - (1036 + 909)))) then
				v83 = v16.Rogue.Assassination.InternalBleeding;
				v84 = 0 + 0;
				v78 = 4 - 1;
			end
			if ((v78 == (204 - (11 + 192))) or ((2161 + 2115) < (3191 - (135 + 40)))) then
				v81 = v16.Rogue.Assassination.Rupture;
				v82 = v16.Rogue.Assassination.RuptureDeathmark;
				v78 = 4 - 2;
			end
			if (((2827 + 1863) > (9087 - 4962)) and (v78 == (4 - 1))) then
				v30.PoisonedBleeds = function()
					local v168 = 176 - (50 + 126);
					while true do
						if ((v168 == (0 - 0)) or ((12 + 38) >= (2309 - (1233 + 180)))) then
							v84 = 969 - (522 + 447);
							for v222, v223 in v23(v13:GetEnemiesInRange(1471 - (107 + 1314))) do
								if (v30.Poisoned(v223) or ((796 + 918) >= (9013 - 6055))) then
									local v232 = 0 + 0;
									while true do
										if ((v232 == (0 - 0)) or ((5899 - 4408) < (2554 - (716 + 1194)))) then
											if (((13 + 691) < (106 + 881)) and v223:DebuffUp(v79)) then
												v84 = v84 + (504 - (74 + 429));
												if (((7171 - 3453) > (945 + 961)) and v223:DebuffUp(v80)) then
													v84 = v84 + (2 - 1);
												end
											end
											if (v223:DebuffUp(v81) or ((678 + 280) > (11206 - 7571))) then
												v84 = v84 + (2 - 1);
												if (((3934 - (279 + 154)) <= (5270 - (454 + 324))) and v223:DebuffUp(v82)) then
													v84 = v84 + 1 + 0;
												end
											end
											v232 = 18 - (12 + 5);
										end
										if ((v232 == (1 + 0)) or ((8770 - 5328) < (942 + 1606))) then
											if (((3968 - (277 + 816)) >= (6255 - 4791)) and v223:DebuffUp(v83)) then
												v84 = v84 + (1184 - (1058 + 125));
											end
											break;
										end
									end
								end
							end
							v168 = 1 + 0;
						end
						if (((976 - (815 + 160)) == v168) or ((20582 - 15785) >= (11615 - 6722))) then
							return v84;
						end
					end
				end;
				break;
			end
		end
	end
	do
		local v85 = 0 + 0;
		local v86;
		while true do
			if ((v85 == (0 - 0)) or ((2449 - (41 + 1857)) > (3961 - (1222 + 671)))) then
				v86 = v29();
				v30.RtBRemains = function(v169)
					local v170 = (v86 - v29()) - v10.RecoveryOffset(v169);
					return ((v170 >= (0 - 0)) and v170) or (0 - 0);
				end;
				v85 = 1183 - (229 + 953);
			end
			if (((3888 - (1111 + 663)) > (2523 - (874 + 705))) and (v85 == (1 + 0))) then
				v10:RegisterForSelfCombatEvent(function(v171, v171, v171, v171, v171, v171, v171, v171, v171, v171, v171, v172)
					if ((v172 == (215262 + 100246)) or ((4701 - 2439) >= (88 + 3008))) then
						v86 = v29() + (709 - (642 + 37));
					end
				end, "SPELL_AURA_APPLIED");
				v10:RegisterForSelfCombatEvent(function(v173, v173, v173, v173, v173, v173, v173, v173, v173, v173, v173, v174)
					if ((v174 == (71939 + 243569)) or ((361 + 1894) >= (8880 - 5343))) then
						v86 = v29() + v22(494 - (233 + 221), (69 - 39) + v30.RtBRemains(true));
					end
				end, "SPELL_AURA_REFRESH");
				v85 = 2 + 0;
			end
			if ((v85 == (1543 - (718 + 823))) or ((2415 + 1422) < (2111 - (266 + 539)))) then
				v10:RegisterForSelfCombatEvent(function(v175, v175, v175, v175, v175, v175, v175, v175, v175, v175, v175, v176)
					if (((8352 - 5402) == (4175 - (636 + 589))) and (v176 == (748941 - 433433))) then
						v86 = v29();
					end
				end, "SPELL_AURA_REMOVED");
				break;
			end
		end
	end
	do
		local v87 = 0 - 0;
		local v88;
		while true do
			if ((v87 == (0 + 0)) or ((1716 + 3007) < (4313 - (657 + 358)))) then
				v88 = {CrimsonTempest={},Garrote={},Rupture={}};
				v30.Exsanguinated = function(v177, v178)
					local v179 = v177:GUID();
					if (((3007 - 1871) >= (350 - 196)) and not v179) then
						return false;
					end
					local v180 = v178:ID();
					if ((v180 == (122598 - (1151 + 36))) or ((262 + 9) > (1249 + 3499))) then
						return v88.CrimsonTempest[v179] or false;
					elseif (((14155 - 9415) >= (4984 - (1552 + 280))) and (v180 == (1537 - (64 + 770)))) then
						return v88.Garrote[v179] or false;
					elseif ((v180 == (1320 + 623)) or ((5852 - 3274) >= (602 + 2788))) then
						return v88.Rupture[v179] or false;
					end
					return false;
				end;
				v87 = 1244 - (157 + 1086);
			end
			if (((81 - 40) <= (7274 - 5613)) and (v87 == (1 - 0))) then
				v30.WillLoseExsanguinate = function(v181, v182)
					if (((819 - 218) < (4379 - (599 + 220))) and v30.Exsanguinated(v181, v182)) then
						return true;
					end
					return false;
				end;
				v30.ExsanguinatedRate = function(v183, v184)
					if (((467 - 232) < (2618 - (1813 + 118))) and v30.Exsanguinated(v183, v184)) then
						return 2 + 0;
					end
					return 1218 - (841 + 376);
				end;
				v87 = 2 - 0;
			end
			if (((1057 + 3492) > (3147 - 1994)) and ((862 - (464 + 395)) == v87)) then
				v10:RegisterForSelfCombatEvent(function(v185, v185, v185, v185, v185, v185, v185, v186, v185, v185, v185, v187)
					if ((v187 == (311588 - 190177)) or ((2245 + 2429) < (5509 - (467 + 370)))) then
						if (((7579 - 3911) < (3349 + 1212)) and (v88.CrimsonTempest[v186] ~= nil)) then
							v88.CrimsonTempest[v186] = nil;
						end
					elseif ((v187 == (2409 - 1706)) or ((71 + 384) == (8387 - 4782))) then
						if ((v88.Garrote[v186] ~= nil) or ((3183 - (150 + 370)) == (4594 - (74 + 1208)))) then
							v88.Garrote[v186] = nil;
						end
					elseif (((10519 - 6242) <= (21223 - 16748)) and (v187 == (1383 + 560))) then
						if ((v88.Rupture[v186] ~= nil) or ((1260 - (14 + 376)) == (2061 - 872))) then
							v88.Rupture[v186] = nil;
						end
					end
				end, "SPELL_AURA_REMOVED");
				v10:RegisterForCombatEvent(function(v188, v188, v188, v188, v188, v188, v188, v189)
					if (((1005 + 548) <= (2753 + 380)) and (v88.CrimsonTempest[v189] ~= nil)) then
						v88.CrimsonTempest[v189] = nil;
					end
					if ((v88.Garrote[v189] ~= nil) or ((2134 + 103) >= (10287 - 6776))) then
						v88.Garrote[v189] = nil;
					end
					if ((v88.Rupture[v189] ~= nil) or ((997 + 327) > (3098 - (23 + 55)))) then
						v88.Rupture[v189] = nil;
					end
				end, "UNIT_DIED", "UNIT_DESTROYED");
				break;
			end
			if (((4 - 2) == v87) or ((1997 + 995) == (1690 + 191))) then
				v10:RegisterForSelfCombatEvent(function(v190, v190, v190, v190, v190, v190, v190, v191, v190, v190, v190, v192)
					if (((4815 - 1709) > (481 + 1045)) and (v192 == (201707 - (652 + 249)))) then
						for v216, v217 in v23(v88) do
							for v225, v226 in v23(v217) do
								if (((8089 - 5066) < (5738 - (708 + 1160))) and (v225 == v191)) then
									v217[v225] = true;
								end
							end
						end
					end
				end, "SPELL_CAST_SUCCESS");
				v10:RegisterForSelfCombatEvent(function(v193, v193, v193, v193, v193, v193, v193, v194, v193, v193, v193, v195)
					if (((388 - 245) > (134 - 60)) and (v195 == (121438 - (10 + 17)))) then
						v88.CrimsonTempest[v194] = false;
					elseif (((5 + 13) < (3844 - (1400 + 332))) and (v195 == (1348 - 645))) then
						v88.Garrote[v194] = false;
					elseif (((3005 - (242 + 1666)) <= (697 + 931)) and (v195 == (713 + 1230))) then
						v88.Rupture[v194] = false;
					end
				end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
				v87 = 3 + 0;
			end
		end
	end
	do
		local v89 = 940 - (850 + 90);
		local v90;
		local v91;
		local v92;
		while true do
			if (((8109 - 3479) == (6020 - (360 + 1030))) and (v89 == (0 + 0))) then
				v90 = v16(552162 - 356535);
				v91 = 0 - 0;
				v89 = 1662 - (909 + 752);
			end
			if (((4763 - (109 + 1114)) > (4911 - 2228)) and ((1 + 0) == v89)) then
				v92 = v29();
				v30.FanTheHammerCP = function()
					local v196 = 242 - (6 + 236);
					while true do
						if (((3021 + 1773) >= (2637 + 638)) and (v196 == (0 - 0))) then
							if (((2591 - 1107) == (2617 - (1076 + 57))) and ((v29() - v92) < (0.5 + 0)) and (v91 > (689 - (579 + 110)))) then
								if (((114 + 1318) < (3144 + 411)) and (v91 > v13:ComboPoints())) then
									return v91;
								else
									v91 = 0 + 0;
								end
							end
							return 407 - (174 + 233);
						end
					end
				end;
				v89 = 5 - 3;
			end
			if ((v89 == (3 - 1)) or ((474 + 591) > (4752 - (663 + 511)))) then
				v10:RegisterForSelfCombatEvent(function(v197, v197, v197, v197, v197, v197, v197, v197, v197, v197, v197, v198, v197, v197, v199, v200)
					if ((v198 == (165723 + 20040)) or ((1042 + 3753) < (4337 - 2930))) then
						if (((1123 + 730) < (11330 - 6517)) and ((v29() - v92) > (0.5 - 0))) then
							v91 = v22(v30.CPMaxSpend(), v13:ComboPoints() + v199 + (v25(0 + 0, v199 - (1 - 0)) * v22(2 + 0, v13:BuffStack(v90) - (1 + 0))));
							v92 = v29();
						end
					end
				end, "SPELL_ENERGIZE");
				break;
			end
		end
	end
	do
		local v93, v94 = 722 - (478 + 244), 517 - (440 + 77);
		local v95 = v16(126366 + 151559);
		v30.TimeToNextTornado = function()
			local v112 = 0 - 0;
			local v113;
			while true do
				if ((v112 == (1557 - (655 + 901))) or ((524 + 2297) < (1862 + 569))) then
					if ((v29() == v93) or ((1941 + 933) < (8786 - 6605))) then
						return 1445 - (695 + 750);
					elseif ((((v29() - v93) < (0.1 - 0)) and (v113 < (0.25 - 0))) or ((10814 - 8125) <= (694 - (285 + 66)))) then
						return 2 - 1;
					elseif ((((v113 > (1310.9 - (682 + 628))) or (v113 == (0 + 0))) and ((v29() - v93) > (299.75 - (176 + 123)))) or ((782 + 1087) == (1458 + 551))) then
						return 269.1 - (239 + 30);
					end
					return v113;
				end
				if ((v112 == (0 + 0)) or ((3409 + 137) < (4109 - 1787))) then
					if (not v13:BuffUp(v95, nil, true) or ((6495 - 4413) == (5088 - (306 + 9)))) then
						return 0 - 0;
					end
					v113 = v13:BuffRemains(v95, nil, true) % (1 + 0);
					v112 = 1 + 0;
				end
			end
		end;
		v10:RegisterForSelfCombatEvent(function(v114, v114, v114, v114, v114, v114, v114, v114, v114, v114, v114, v115)
			if (((1562 + 1682) > (3016 - 1961)) and (v115 == (214118 - (1140 + 235)))) then
				v93 = v29();
			elseif ((v115 == (125898 + 71937)) or ((3039 + 274) <= (457 + 1321))) then
				v94 = v29();
			end
			if ((v94 == v93) or ((1473 - (33 + 19)) >= (760 + 1344))) then
				v93 = 0 - 0;
			end
		end, "SPELL_CAST_SUCCESS");
	end
	do
		local v97 = {Counter=(0 + 0),LastMH=(0 - 0),LastOH=(0 + 0)};
		v30.TimeToSht = function(v116)
			local v117 = 689 - (586 + 103);
			local v118;
			local v119;
			local v120;
			local v121;
			local v122;
			local v123;
			while true do
				if (((165 + 1647) <= (10002 - 6753)) and (v117 == (1489 - (1309 + 179)))) then
					v120 = v25(v97.LastMH + v118, v29());
					v121 = v25(v97.LastOH + v119, v29());
					v117 = 2 - 0;
				end
				if (((707 + 916) <= (5255 - 3298)) and (v117 == (3 + 0))) then
					table.sort(v122);
					v123 = v22(10 - 5, v25(1 - 0, v116 - v97.Counter));
					v117 = 613 - (295 + 314);
				end
				if (((10836 - 6424) == (6374 - (1300 + 662))) and ((12 - 8) == v117)) then
					return v122[v123] - v29();
				end
				if (((3505 - (1178 + 577)) >= (438 + 404)) and (v117 == (0 - 0))) then
					if (((5777 - (851 + 554)) > (1636 + 214)) and (v97.Counter >= v116)) then
						return 0 - 0;
					end
					v118, v119 = v28("player");
					v117 = 1 - 0;
				end
				if (((534 - (115 + 187)) < (629 + 192)) and (v117 == (2 + 0))) then
					v122 = {};
					for v202 = 0 - 0, 1163 - (160 + 1001) do
						v27(v122, v120 + (v202 * v118));
						v27(v122, v121 + (v202 * v119));
					end
					v117 = 3 + 0;
				end
			end
		end;
		v10:RegisterForSelfCombatEvent(function()
			v97.Counter = 0 + 0;
			v97.LastMH = v29();
			v97.LastOH = v29();
		end, "PLAYER_ENTERING_WORLD");
		v10:RegisterForSelfCombatEvent(function(v127, v127, v127, v127, v127, v127, v127, v127, v127, v127, v127, v128)
			if (((1060 - 542) < (1260 - (237 + 121))) and (v128 == (197808 - (525 + 372)))) then
				v97.Counter = 0 - 0;
			end
		end, "SPELL_ENERGIZE");
		v10:RegisterForSelfCombatEvent(function(v129, v129, v129, v129, v129, v129, v129, v129, v129, v129, v129, v129, v129, v129, v129, v129, v129, v129, v129, v129, v129, v129, v129, v130)
			local v131 = 0 - 0;
			while true do
				if (((3136 - (96 + 46)) > (1635 - (643 + 134))) and (v131 == (0 + 0))) then
					v97.Counter = v97.Counter + (2 - 1);
					if (v130 or ((13941 - 10186) <= (878 + 37))) then
						v97.LastOH = v29();
					else
						v97.LastMH = v29();
					end
					break;
				end
			end
		end, "SWING_DAMAGE");
		v10:RegisterForSelfCombatEvent(function(v132, v132, v132, v132, v132, v132, v132, v132, v132, v132, v132, v132, v132, v132, v132, v133)
			if (((7744 - 3798) > (7650 - 3907)) and v133) then
				v97.LastOH = v29();
			else
				v97.LastMH = v29();
			end
		end, "SWING_MISSED");
	end
	do
		local v99 = 719 - (316 + 403);
		local v100;
		local v101;
		local v102;
		while true do
			if ((v99 == (0 + 0)) or ((3670 - 2335) >= (1195 + 2111))) then
				v100 = v13:CritChancePct();
				v101 = 0 - 0;
				v99 = 1 + 0;
			end
			if (((1562 + 3282) > (7806 - 5553)) and (v99 == (4 - 3))) then
				v102 = nil;
				function v102()
					if (((938 - 486) == (26 + 426)) and not v13:AffectingCombat()) then
						local v214 = 0 - 0;
						while true do
							if ((v214 == (0 + 0)) or ((13407 - 8850) < (2104 - (12 + 5)))) then
								v100 = v13:CritChancePct();
								v10.Debug("Base Crit Set to: " .. v100);
								break;
							end
						end
					end
					if (((15046 - 11172) == (8265 - 4391)) and ((v101 == nil) or (v101 < (0 - 0)))) then
						v101 = 0 - 0;
					else
						v101 = v101 - (1 + 0);
					end
					if ((v101 > (1973 - (1656 + 317))) or ((1727 + 211) > (3955 + 980))) then
						v24.After(7 - 4, v102);
					end
				end
				v99 = 9 - 7;
			end
			if ((v99 == (356 - (5 + 349))) or ((20210 - 15955) < (4694 - (266 + 1005)))) then
				v10:RegisterForEvent(function()
					if (((959 + 495) <= (8499 - 6008)) and (v101 == (0 - 0))) then
						local v215 = 1696 - (561 + 1135);
						while true do
							if ((v215 == (0 - 0)) or ((13664 - 9507) <= (3869 - (507 + 559)))) then
								v24.After(7 - 4, v102);
								v101 = 6 - 4;
								break;
							end
						end
					end
				end, "PLAYER_EQUIPMENT_CHANGED");
				v30.BaseAttackCrit = function()
					return v100;
				end;
				break;
			end
		end
	end
	do
		local v103 = 388 - (212 + 176);
		local v104;
		local v105;
		local v106;
		local v107;
		while true do
			if (((5758 - (250 + 655)) >= (8131 - 5149)) and ((0 - 0) == v103)) then
				v104 = v16.Rogue.Assassination;
				v105 = v16.Rogue.Subtlety;
				v103 = 1 - 0;
			end
			if (((6090 - (1869 + 87)) > (11643 - 8286)) and (v103 == (1904 - (484 + 1417)))) then
				v104.Rupture:RegisterPMultiplier(v106, {v105.FinalityRuptureBuff,(774.3 - (48 + 725))});
				v104.Garrote:RegisterPMultiplier(v106, v107);
				break;
			end
			if ((v103 == (2 - 0)) or ((9167 - 5750) < (1473 + 1061))) then
				v107 = nil;
				function v107()
					if ((v104.ImprovedGarrote:IsAvailable() and (v13:BuffUp(v104.ImprovedGarroteAura, nil, true) or v13:BuffUp(v104.ImprovedGarroteBuff, nil, true) or v13:BuffUp(v104.SepsisBuff, nil, true))) or ((7273 - 4551) <= (46 + 118))) then
						return 1.5 + 0;
					end
					return 854 - (152 + 701);
				end
				v103 = 1314 - (430 + 881);
			end
			if ((v103 == (1 + 0)) or ((3303 - (557 + 338)) < (624 + 1485))) then
				v106 = nil;
				function v106()
					if ((v104.Nightstalker:IsAvailable() and v13:StealthUp(true, false, true)) or ((92 - 59) == (5094 - 3639))) then
						return (2 - 1) + ((0.05 - 0) * v104.Nightstalker:TalentRank());
					end
					return 802 - (499 + 302);
				end
				v103 = 868 - (39 + 827);
			end
		end
	end
end;
return v0["Epix_Rogue_Rogue.lua"]();

