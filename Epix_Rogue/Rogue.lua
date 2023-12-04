local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1691 - (507 + 1184);
	local v6;
	while true do
		if (((1410 - 307) < (3295 - (624 + 891))) and (v5 == (890 - (142 + 748)))) then
			v6 = v0[v4];
			if (((3911 - (1192 + 35)) > (1914 - 1368)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
		if (((2309 - 844) <= (6071 - (1134 + 636))) and (v5 == (496 - (263 + 232)))) then
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
	if (((3820 - 2116) > (2074 - 649)) and not v16.Rogue) then
		v16.Rogue = {};
	end
	v16.Rogue.Commons = {Sanguine=v16(226667 - (26 + 131), nil, 1 + 0),AncestralCall=v16(1062743 - 788005, nil, 861 - (240 + 619)),ArcanePulse=v16(62830 + 197534, nil, 4 - 1),ArcaneTorrent=v16(1658 + 23388, nil, 1748 - (1344 + 400)),BagofTricks=v16(312816 - (255 + 150), nil, 4 + 1),Berserking=v16(14079 + 12218, nil, 25 - 19),BloodFury=v16(66445 - 45873, nil, 1746 - (404 + 1335)),Fireblood=v16(265627 - (183 + 223), nil, 9 - 1),LightsJudgment=v16(169389 + 86258, nil, 4 + 5),Shadowmeld=v16(59321 - (10 + 327), nil, 7 + 3),CloakofShadows=v16(31562 - (118 + 220), nil, 4 + 7),CrimsonVial=v16(185760 - (108 + 341), nil, 6 + 6),Evasion=v16(22309 - 17032, nil, 1506 - (711 + 782)),Feint=v16(3768 - 1802, nil, 483 - (270 + 199)),Blind=v16(679 + 1415, nil, 1834 - (580 + 1239)),CheapShot=v16(5449 - 3616, nil, 16 + 0),Kick=v16(64 + 1702, nil, 8 + 9),KidneyShot=v16(1064 - 656, nil, 12 + 6),Sap=v16(7937 - (645 + 522), nil, 1809 - (1010 + 780)),Shiv=v16(5936 + 2, nil, 95 - 75),SliceandDice=v16(924547 - 609051, nil, 1857 - (1045 + 791)),Shadowstep=v16(92528 - 55974, nil, 32 - 10),Sprint=v16(3488 - (351 + 154), nil, 1597 - (1281 + 293)),TricksoftheTrade=v16(58200 - (28 + 238), nil, 53 - 29),CripplingPoison=v16(4967 - (1381 + 178), nil, 24 + 1),DeadlyPoison=v16(2277 + 546, nil, 12 + 14),InstantPoison=v16(1087950 - 772366, nil, 14 + 13),AmplifyingPoison=v16(382134 - (381 + 89), nil, 25 + 3),NumbingPoison=v16(3897 + 1864, nil, 49 - 20),WoundPoison=v16(9835 - (1074 + 82), nil, 65 - 35),AtrophicPoison=v16(383421 - (214 + 1570), nil, 1486 - (990 + 465)),AcrobaticStrikes=v16(81181 + 115743, nil, 14 + 18),Alacrity=v16(188207 + 5332, nil, 129 - 96),ColdBlood=v16(383971 - (1668 + 58), nil, 660 - (512 + 114)),DeeperStratagem=v16(504563 - 311032),EchoingReprimand=v16(797200 - 411584, nil, 125 - 89),EchoingReprimand2=v16(150523 + 173035, nil, 7 + 30),EchoingReprimand3=v16(281282 + 42277, nil, 128 - 90),EchoingReprimand4=v16(325554 - (109 + 1885), nil, 1508 - (1269 + 200)),EchoingReprimand5=v16(680119 - 325281, nil, 855 - (98 + 717)),FindWeakness=v16(91849 - (802 + 24), nil, 70 - 29),FindWeaknessDebuff=v16(399371 - 83151, nil, 7 + 35),ImprovedAmbush=v16(293208 + 88412, nil, 8 + 35),MarkedforDeath=v16(29686 + 107933, nil, 122 - 78),Nightstalker=v16(46893 - 32831, nil, 17 + 28),ResoundingClarity=v16(155344 + 226278, nil, 38 + 8),SealFate=v16(10319 + 3871, nil, 22 + 25),Sepsis=v16(386841 - (797 + 636), nil, 233 - 185),SepsisBuff=v16(377558 - (1427 + 192), nil, 17 + 32),ShadowDance=v16(430254 - 244941, nil, 45 + 5),ShadowDanceTalent=v16(178976 + 215954, nil, 377 - (192 + 134)),ShadowDanceBuff=v16(186698 - (316 + 960)),Subterfuge=v16(60218 + 47990, nil, 41 + 12),SubterfugeBuff=v16(106473 + 8719, nil, 206 - 152),ThistleTea=v16(382174 - (83 + 468), nil, 2126 - (1202 + 604)),Vigor=v16(69943 - 54960),Stealth=v16(2968 - 1184, nil, 157 - 100),Stealth2=v16(115516 - (45 + 280), nil, 56 + 2),Vanish=v16(1622 + 234, nil, 22 + 37),VanishBuff=v16(6268 + 5059, nil, 11 + 49),VanishBuff2=v16(213310 - 98117, nil, 1972 - (340 + 1571)),PoolEnergy=v16(394388 + 605522, nil, 1834 - (1733 + 39))};
	v16.Rogue.Assassination = v19(v16.Rogue.Commons, {Ambush=v16(23840 - 15164, nil, 1097 - (125 + 909)),AmplifyingPoisonDebuff=v16(385362 - (1096 + 852), nil, 29 + 35),AmplifyingPoisonDebuffDeathmark=v16(563142 - 168814, nil, 64 + 1),CripplingPoisonDebuff=v16(3921 - (409 + 103), nil, 302 - (46 + 190)),DeadlyPoisonDebuff=v16(2913 - (51 + 44), nil, 19 + 48),DeadlyPoisonDebuffDeathmark=v16(395641 - (1114 + 203), nil, 794 - (228 + 498)),Envenom=v16(7073 + 25572, nil, 39 + 30),FanofKnives=v16(52386 - (174 + 489), nil, 182 - 112),Garrote=v16(2608 - (830 + 1075), nil, 595 - (303 + 221)),GarroteDeathmark=v16(362099 - (231 + 1038), nil, 60 + 12),Mutilate=v16(2491 - (171 + 991), nil, 300 - 227),PoisonedKnife=v16(498279 - 312714, nil, 184 - 110),Rupture=v16(1556 + 387, nil, 262 - 187),RuptureDeathmark=v16(1040912 - 680086, nil, 122 - 46),WoundPoisonDebuff=v16(26832 - 18152, nil, 1325 - (111 + 1137)),ArterialPrecision=v16(400941 - (91 + 67), nil, 232 - 154),AtrophicPoisonDebuff=v16(97903 + 294485, nil, 602 - (423 + 100)),BlindsideBuff=v16(851 + 120302, nil, 221 - 141),CrimsonTempest=v16(63282 + 58129, nil, 852 - (326 + 445)),CutToTheChase=v16(225473 - 173806, nil, 182 - 100),DashingScoundrel=v16(891200 - 509403, nil, 794 - (530 + 181)),Deathmark=v16(361075 - (614 + 267), nil, 116 - (19 + 13)),Doomblade=v16(621215 - 239542, nil, 197 - 112),DragonTemperedBlades=v16(1090655 - 708854, nil, 23 + 63),Elusiveness=v16(138949 - 59941),Exsanguinate=v16(416440 - 215634, nil, 1900 - (1293 + 519)),ImprovedGarrote=v16(778648 - 397016, nil, 231 - 142),ImprovedGarroteBuff=v16(750397 - 357996, nil, 388 - 298),ImprovedGarroteAura=v16(924398 - 531995, nil, 49 + 42),IndiscriminateCarnage=v16(77895 + 303907, nil, 213 - 121),InternalBleeding=v16(35807 + 119146, nil, 31 + 62),Kingsbane=v16(240985 + 144642, nil, 1190 - (709 + 387)),LightweightShiv=v16(396841 - (673 + 1185)),MasterAssassin=v16(742404 - 486415, nil, 305 - 210),MasterAssassinBuff=v16(422416 - 165681, nil, 69 + 27),PreyontheWeak=v16(98265 + 33246, nil, 130 - 33),PreyontheWeakDebuff=v16(62852 + 193057, nil, 195 - 97),SerratedBoneSpike=v16(756598 - 371174, nil, 1979 - (446 + 1434)),SerratedBoneSpikeDebuff=v16(395319 - (1040 + 243), nil, 298 - 198),ShivDebuff=v16(321351 - (559 + 1288), nil, 2032 - (609 + 1322)),VenomRush=v16(152606 - (13 + 441), nil, 380 - 278),ScentOfBlood=v16(1000070 - 618271, nil, 1972 - 1576),ScentOfBloodBuff=v16(14674 + 379406)});
	v16.Rogue.Outlaw = v19(v16.Rogue.Commons, {AdrenalineRush=v16(49937 - 36187, nil, 37 + 66),Ambush=v16(3802 + 4874, nil, 308 - 204),BetweentheEyes=v16(172558 + 142783, nil, 192 - 87),BladeFlurry=v16(9175 + 4702, nil, 59 + 47),Dispatch=v16(1508 + 590, nil, 90 + 17),Elusiveness=v16(77301 + 1707),Opportunity=v16(196060 - (153 + 280)),PistolShot=v16(536409 - 350646, nil, 99 + 11),RolltheBones=v16(124576 + 190932, nil, 59 + 52),SinisterStrike=v16(175430 + 17885, nil, 82 + 30),Audacity=v16(581441 - 199596, nil, 70 + 43),AudacityBuff=v16(386937 - (89 + 578), nil, 82 + 32),BladeRush=v16(565226 - 293349, nil, 1164 - (572 + 477)),CountTheOdds=v16(51517 + 330465, nil, 70 + 46),Dreadblades=v16(40959 + 302183, nil, 203 - (84 + 2)),FanTheHammer=v16(629309 - 247463, nil, 86 + 32),GhostlyStrike=v16(197779 - (497 + 345), nil, 4 + 115),GreenskinsWickers=v16(65390 + 321433, nil, 1453 - (605 + 728)),GreenskinsWickersBuff=v16(281205 + 112926, nil, 268 - 147),HiddenOpportunity=v16(17566 + 365715, nil, 450 - 328),ImprovedAdrenalineRush=v16(356471 + 38951, nil, 340 - 217),ImprovedBetweenTheEyes=v16(177803 + 57681, nil, 613 - (457 + 32)),KeepItRolling=v16(162069 + 219920, nil, 1527 - (832 + 570)),KillingSpree=v16(48697 + 2993, nil, 33 + 93),LoadedDice=v16(906538 - 650368, nil, 62 + 65),LoadedDiceBuff=v16(256967 - (588 + 208), nil, 344 - 216),PreyontheWeak=v16(133311 - (884 + 916), nil, 269 - 140),PreyontheWeakDebuff=v16(148380 + 107529, nil, 783 - (232 + 421)),QuickDraw=v16(198827 - (1569 + 320), nil, 33 + 98),SummarilyDispatched=v16(72573 + 309417, nil, 444 - 312),SwiftSlasher=v16(382593 - (316 + 289), nil, 347 - 214),TakeEmBySurpriseBuff=v16(17822 + 368085, nil, 1587 - (666 + 787)),Weaponmaster=v16(201158 - (360 + 65), nil, 127 + 8),UnderhandedUpperhand=v16(424298 - (79 + 175)),DeftManeuvers=v16(602158 - 220280),Crackshot=v16(330635 + 93068),Gouge=v16(5443 - 3667, nil, 261 - 125),Broadside=v16(194255 - (503 + 396), nil, 318 - (92 + 89)),BuriedTreasure=v16(387215 - 187615, nil, 71 + 67),GrandMelee=v16(114439 + 78919, nil, 544 - 405),RuthlessPrecision=v16(26442 + 166915, nil, 319 - 179),SkullandCrossbones=v16(174152 + 25451, nil, 68 + 73),TrueBearing=v16(588907 - 395548, nil, 18 + 124),ViciousFollowup=v16(602196 - 207317, nil, 1387 - (485 + 759))});
	v16.Rogue.Subtlety = v19(v16.Rogue.Commons, {Backstab=v16(122 - 69, nil, 1333 - (442 + 747)),BlackPowder=v16(320310 - (832 + 303), nil, 1091 - (88 + 858)),Elusiveness=v16(24081 + 54927),Eviscerate=v16(162888 + 33931, nil, 7 + 140),Rupture=v16(2732 - (766 + 23), nil, 730 - 582),ShadowBlades=v16(166130 - 44659, nil, 392 - 243),Shadowstrike=v16(629382 - 443944, nil, 1223 - (1036 + 37)),ShurikenStorm=v16(140261 + 57574, nil, 293 - 142),ShurikenToss=v16(89688 + 24326, nil, 1632 - (641 + 839)),SymbolsofDeath=v16(213196 - (910 + 3), nil, 389 - 236),DanseMacabre=v16(384212 - (1466 + 218), nil, 71 + 83),DanseMacabreBuff=v16(395117 - (556 + 592), nil, 56 + 99),DeeperDaggers=v16(383325 - (329 + 479), nil, 1010 - (174 + 680)),DeeperDaggersBuff=v16(1317446 - 934041, nil, 325 - 168),DarkBrew=v16(273097 + 109407, nil, 897 - (396 + 343)),DarkShadow=v16(21738 + 223949, nil, 1636 - (29 + 1448)),EnvelopingShadows=v16(239493 - (135 + 1254), nil, 602 - 442),Finality=v16(1786057 - 1403532, nil, 108 + 53),FinalityBlackPowderBuff=v16(387475 - (389 + 1138), nil, 736 - (102 + 472)),FinalityEviscerateBuff=v16(364217 + 21732, nil, 91 + 72),FinalityRuptureBuff=v16(359872 + 26079, nil, 1709 - (320 + 1225)),Flagellation=v16(684716 - 300085, nil, 101 + 64),FlagellationPersistBuff=v16(396222 - (157 + 1307), nil, 2025 - (821 + 1038)),Gloomblade=v16(500889 - 300131, nil, 19 + 148),ImprovedShadowDance=v16(699799 - 305827, nil, 63 + 105),ImprovedShurikenStorm=v16(793021 - 473070, nil, 1195 - (834 + 192)),LingeringShadow=v16(24320 + 358204, nil, 44 + 126),LingeringShadowBuff=v16(8286 + 377674, nil, 264 - 93),MasterofShadows=v16(197280 - (300 + 4), nil, 46 + 126),PerforatedVeins=v16(1001339 - 618821, nil, 535 - (112 + 250)),PerforatedVeinsBuff=v16(157167 + 237087, nil, 435 - 261),PreyontheWeak=v16(75340 + 56171, nil, 91 + 84),PreyontheWeakDebuff=v16(191392 + 64517, nil, 88 + 88),Premeditation=v16(254926 + 88234, nil, 1591 - (1001 + 413)),PremeditationBuff=v16(765269 - 422096, nil, 1060 - (244 + 638)),SecretStratagem=v16(395013 - (627 + 66), nil, 533 - 354),SecretTechnique=v16(281321 - (512 + 90), nil, 2086 - (1665 + 241)),ShadowFocus=v16(108926 - (373 + 344), nil, 82 + 99),ShurikenTornado=v16(73537 + 204388, nil, 479 - 297),SilentStorm=v16(652742 - 267020, nil, 1282 - (35 + 1064)),SilentStormBuff=v16(280652 + 105070, nil, 393 - 209),TheFirstDance=v16(1527 + 380978, nil, 1421 - (298 + 938)),TheRotten=v16(383274 - (233 + 1026), nil, 1852 - (636 + 1030)),TheRottenBuff=v16(201543 + 192660, nil, 183 + 4),Weaponmaster=v16(57493 + 136044, nil, 13 + 175)});
	if (not v18.Rogue or ((908 - (55 + 166)) == (821 + 3413))) then
		v18.Rogue = {};
	end
	v18.Rogue.Commons = {AlgetharPuzzleBox=v18(19479 + 174222, {(310 - (36 + 261)),(1382 - (34 + 1334))}),ManicGrieftorch=v18(74698 + 119610, {(1296 - (1035 + 248)),(8 + 6)}),WindscarWhetstone=v18(137805 - (134 + 185), {(698 - (314 + 371)),(982 - (478 + 490))}),Healthstone=v18(2920 + 2592),RefreshingHealingPotion=v18(192552 - (786 + 386))};
	v18.Rogue.Assassination = v19(v18.Rogue.Commons, {AlgetharPuzzleBox=v18(627396 - 433695, {(1353 - (1093 + 247)),(2 + 12)}),AshesoftheEmbersoul=v18(822489 - 615322, {(36 - 23),(5 + 9)}),WitherbarksBranch=v18(423765 - 313766, {(10 + 3),(702 - (364 + 324))})});
	v18.Rogue.Outlaw = v19(v18.Rogue.Commons, {ManicGrieftorch=v18(532667 - 338359, {(5 + 8),(21 - 7)}),WindscarWhetstone=v18(417561 - 280075, {(12 + 1),(1100 - (686 + 400))}),BeaconToTheBeyond=v18(160030 + 43933, {(1 + 12),(1 + 13)}),DragonfireBombDispenser=v18(657851 - 455241, {(20 - 7),(3 + 11)})});
	v18.Rogue.Subtlety = v19(v18.Rogue.Commons, {ManicGrieftorch=v18(4624 + 189684, {(25 - 12),(527 - (203 + 310))}),StormEatersBoon=v18(196295 - (1238 + 755), {(1547 - (709 + 825)),(20 - 6)}),BeaconToTheBeyond=v18(204827 - (196 + 668), {(26 - 13),(107 - (4 + 89))})});
	if (not v21.Rogue or ((11671 - 8341) < (521 + 908))) then
		v21.Rogue = {};
	end
	v21.Rogue.Commons = {Healthstone=v21(92 - 71),BlindMouseover=v21(4 + 5),CheapShotMouseover=v21(1496 - (35 + 1451)),KickMouseover=v21(1464 - (28 + 1425)),KidneyShotMouseover=v21(2005 - (941 + 1052)),TricksoftheTradeFocus=v21(13 + 0),WindscarWhetstone=v21(1540 - (822 + 692))};
	v21.Rogue.Outlaw = v19(v21.Rogue.Commons, {Dispatch=v21(19 - 5),PistolShotMouseover=v21(8 + 7),SinisterStrikeMouseover=v21(313 - (45 + 252))});
	v21.Rogue.Subtlety = v19(v21.Rogue.Commons, {SecretTechnique=v21(16 + 0),ShadowDance=v21(6 + 11),ShadowDanceSymbol=v21(63 - 37),VanishShadowstrike=v21(451 - (114 + 319)),ShurikenStormSD=v21(26 - 7),ShurikenStormVanish=v21(25 - 5),GloombladeSD=v21(15 + 7),GloombladeVanish=v21(34 - 11),BackstabMouseover=v21(50 - 26),RuptureMouseover=v21(1988 - (556 + 1407))});
	v30.StealthSpell = function()
		return (v16.Rogue.Commons.Subterfuge:IsAvailable() and v16.Rogue.Commons.Stealth2) or v16.Rogue.Commons.Stealth;
	end;
	v30.VanishBuffSpell = function()
		return (v16.Rogue.Commons.Subterfuge:IsAvailable() and v16.Rogue.Commons.VanishBuff2) or v16.Rogue.Commons.VanishBuff;
	end;
	v30.Stealth = function(v49, v50)
		local v51 = 1206 - (741 + 465);
		while true do
			if (((1612 - (170 + 295)) >= (177 + 158)) and (v51 == (0 + 0))) then
				if (((8456 - 5021) > (1739 + 358)) and EpicSettings.Settings['StealthOOC'] and (v16.Rogue.Commons.Stealth:IsCastable() or v16.Rogue.Commons.Stealth2:IsCastable()) and v13:StealthDown()) then
					if (v10.Press(v49, nil) or ((2418 + 1352) >= (2289 + 1752))) then
						return "Cast Stealth (OOC)";
					end
				end
				return false;
			end
		end
	end;
	do
		local v52 = 1230 - (957 + 273);
		local v53;
		while true do
			if ((v52 == (0 + 0)) or ((1518 + 2273) <= (6138 - 4527))) then
				v53 = v16(488336 - 303025);
				v30.CrimsonVial = function()
					local v200 = 0 - 0;
					local v201;
					while true do
						if ((v200 == (0 - 0)) or ((6358 - (389 + 1391)) <= (1260 + 748))) then
							v201 = EpicSettings.Settings['CrimsonVialHP'] or (0 + 0);
							if (((2561 - 1436) <= (3027 - (783 + 168))) and v53:IsCastable() and (v13:HealthPercentage() <= v201)) then
								if (v10.Cast(v53, nil) or ((2493 - 1750) >= (4327 + 72))) then
									return "Cast Crimson Vial (Defensives)";
								end
							end
							v200 = 312 - (309 + 2);
						end
						if (((3546 - 2391) < (2885 - (1090 + 122))) and (v200 == (1 + 0))) then
							return false;
						end
					end
				end;
				break;
			end
		end
	end
	do
		local v54 = v16(6602 - 4636);
		v30.Feint = function()
			local v113 = 0 + 0;
			local v114;
			while true do
				if ((v113 == (1118 - (628 + 490))) or ((417 + 1907) <= (1430 - 852))) then
					v114 = EpicSettings.Settings['FeintHP'] or (0 - 0);
					if (((4541 - (431 + 343)) == (7607 - 3840)) and v54:IsCastable() and v13:BuffDown(v54) and (v13:HealthPercentage() <= v114)) then
						if (((11829 - 7740) == (3231 + 858)) and v10.Cast(v54, nil)) then
							return "Cast Feint (Defensives)";
						end
					end
					break;
				end
			end
		end;
	end
	do
		local v56 = 0 + 0;
		local v57;
		local v58;
		local v59;
		while true do
			if (((6153 - (556 + 1139)) >= (1689 - (6 + 9))) and (v56 == (1 + 1))) then
				v30.Poisons = function()
					local v202 = 0 + 0;
					while true do
						if (((1141 - (28 + 141)) <= (550 + 868)) and (v202 == (0 - 0))) then
							v58 = v13:BuffUp(v16.Rogue.Commons.WoundPoison);
							if (v16.Rogue.Assassination.DragonTemperedBlades:IsAvailable() or ((3498 + 1440) < (6079 - (486 + 831)))) then
								local v237 = 0 - 0;
								local v238;
								while true do
									if (((0 - 0) == v237) or ((474 + 2030) > (13482 - 9218))) then
										v238 = v59((v58 and v16.Rogue.Commons.WoundPoison) or v16.Rogue.Commons.DeadlyPoison);
										if (((3416 - (668 + 595)) == (1938 + 215)) and v238) then
											return v238;
										end
										v237 = 1 + 0;
									end
									if ((v237 == (2 - 1)) or ((797 - (23 + 267)) >= (4535 - (1129 + 815)))) then
										if (((4868 - (371 + 16)) == (6231 - (1326 + 424))) and v16.Rogue.Commons.AmplifyingPoison:IsAvailable()) then
											local v254 = 0 - 0;
											while true do
												if ((v254 == (0 - 0)) or ((2446 - (88 + 30)) < (1464 - (720 + 51)))) then
													v238 = v59(v16.Rogue.Commons.AmplifyingPoison);
													if (((9627 - 5299) == (6104 - (421 + 1355))) and v238) then
														return v238;
													end
													break;
												end
											end
										else
											v238 = v59(v16.Rogue.Commons.InstantPoison);
											if (((2619 - 1031) >= (655 + 677)) and v238) then
												return v238;
											end
										end
										break;
									end
								end
							elseif (v58 or ((5257 - (286 + 797)) > (15529 - 11281))) then
								local v243 = 0 - 0;
								local v244;
								while true do
									if ((v243 == (439 - (397 + 42))) or ((1433 + 3153) <= (882 - (24 + 776)))) then
										v244 = v59(v16.Rogue.Commons.WoundPoison);
										if (((5951 - 2088) == (4648 - (222 + 563))) and v244) then
											return v244;
										end
										break;
									end
								end
							elseif ((v16.Rogue.Commons.AmplifyingPoison:IsAvailable() and v13:BuffDown(v16.Rogue.Commons.DeadlyPoison)) or ((620 - 338) <= (31 + 11))) then
								local v249 = 190 - (23 + 167);
								local v250;
								while true do
									if (((6407 - (690 + 1108)) >= (277 + 489)) and (v249 == (0 + 0))) then
										v250 = v59(v16.Rogue.Commons.AmplifyingPoison);
										if (v250 or ((2000 - (40 + 808)) == (410 + 2078))) then
											return v250;
										end
										break;
									end
								end
							elseif (((13085 - 9663) > (3202 + 148)) and v16.Rogue.Commons.DeadlyPoison:IsAvailable()) then
								local v255 = 0 + 0;
								local v256;
								while true do
									if (((481 + 396) > (947 - (47 + 524))) and (v255 == (0 + 0))) then
										v256 = v59(v16.Rogue.Commons.DeadlyPoison);
										if (v256 or ((8523 - 5405) <= (2767 - 916))) then
											return v256;
										end
										break;
									end
								end
							else
								local v257 = 0 - 0;
								local v258;
								while true do
									if (((1726 - (1165 + 561)) == v257) or ((5 + 160) >= (10815 - 7323))) then
										v258 = v59(v16.Rogue.Commons.InstantPoison);
										if (((1507 + 2442) < (5335 - (341 + 138))) and v258) then
											return v258;
										end
										break;
									end
								end
							end
							v202 = 1 + 0;
						end
						if ((v202 == (1 - 0)) or ((4602 - (89 + 237)) < (9702 - 6686))) then
							if (((9873 - 5183) > (5006 - (581 + 300))) and v13:BuffDown(v16.Rogue.Commons.CripplingPoison)) then
								if (v16.Rogue.Commons.AtrophicPoison:IsAvailable() or ((1270 - (855 + 365)) >= (2127 - 1231))) then
									local v245 = 0 + 0;
									local v246;
									while true do
										if ((v245 == (1235 - (1030 + 205))) or ((1610 + 104) >= (2752 + 206))) then
											v246 = v59(v16.Rogue.Commons.AtrophicPoison);
											if (v246 or ((1777 - (156 + 130)) < (1462 - 818))) then
												return v246;
											end
											break;
										end
									end
								elseif (((1186 - 482) < (2020 - 1033)) and v16.Rogue.Commons.NumbingPoison:IsAvailable()) then
									local v251 = 0 + 0;
									local v252;
									while true do
										if (((2169 + 1549) > (1975 - (10 + 59))) and ((0 + 0) == v251)) then
											v252 = v59(v16.Rogue.Commons.NumbingPoison);
											if (v252 or ((4717 - 3759) > (4798 - (671 + 492)))) then
												return v252;
											end
											break;
										end
									end
								else
									local v253 = v59(v16.Rogue.Commons.CripplingPoison);
									if (((2787 + 714) <= (5707 - (369 + 846))) and v253) then
										return v253;
									end
								end
							else
								local v239 = 0 + 0;
								local v240;
								while true do
									if (((0 + 0) == v239) or ((5387 - (1036 + 909)) < (2026 + 522))) then
										v240 = v59(v16.Rogue.Commons.CripplingPoison);
										if (((4826 - 1951) >= (1667 - (11 + 192))) and v240) then
											return v240;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end;
				break;
			end
			if ((v56 == (1 + 0)) or ((4972 - (135 + 40)) >= (11854 - 6961))) then
				v59 = nil;
				function v59(v203)
					if ((not v13:AffectingCombat() and v13:BuffRefreshable(v203)) or ((333 + 218) > (4555 - 2487))) then
						if (((3168 - 1054) > (1120 - (50 + 126))) and v10.Press(v203, nil, true)) then
							return "poison";
						end
					end
				end
				v56 = 5 - 3;
			end
			if (((0 + 0) == v56) or ((3675 - (1233 + 180)) >= (4065 - (522 + 447)))) then
				v57 = 1421 - (107 + 1314);
				v58 = false;
				v56 = 1 + 0;
			end
		end
	end
	v30.MfDSniping = function(v60)
		if (v60:IsCastable() or ((6871 - 4616) >= (1503 + 2034))) then
			local v168 = 0 - 0;
			local v169;
			local v170;
			local v171;
			while true do
				if ((v168 == (3 - 2)) or ((5747 - (716 + 1194)) < (23 + 1283))) then
					for v226, v227 in v23(v13:GetEnemiesInRange(4 + 26)) do
						local v228 = 503 - (74 + 429);
						local v229;
						while true do
							if (((5690 - 2740) == (1463 + 1487)) and (v228 == (0 - 0))) then
								v229 = v227:TimeToDie();
								if ((not v227:IsMfDBlacklisted() and (v229 < (v13:ComboPointsDeficit() * (1.5 + 0))) and (v229 < v170)) or ((14560 - 9837) < (8154 - 4856))) then
									if (((1569 - (279 + 154)) >= (932 - (454 + 324))) and ((v171 - v229) > (1 + 0))) then
										v169, v170 = v227, v229;
									else
										v169, v170 = v15, v171;
									end
								end
								break;
							end
						end
					end
					if ((v169 and (v169:GUID() ~= v14:GUID())) or ((288 - (12 + 5)) > (2560 + 2188))) then
						v10.Press(v169, v60);
					end
					break;
				end
				if (((12077 - 7337) >= (1165 + 1987)) and ((1093 - (277 + 816)) == v168)) then
					v169, v170 = nil, 256 - 196;
					v171 = (v15:IsInRange(1213 - (1058 + 125)) and v15:TimeToDie()) or (2084 + 9027);
					v168 = 976 - (815 + 160);
				end
			end
		end
	end;
	v30.CanDoTUnit = function(v61, v62)
		return v20.CanDoTUnit(v61, v62);
	end;
	do
		local v63 = 0 - 0;
		local v64;
		local v65;
		local v66;
		local v67;
		while true do
			if ((v63 == (7 - 4)) or ((615 + 1963) >= (9909 - 6519))) then
				v64.Rupture:RegisterPMultiplier(v66, {v65.FinalityRuptureBuff,(2.3 - 1)});
				v64.Garrote:RegisterPMultiplier(v66, v67);
				v63 = 5 - 1;
			end
			if (((1223 - (229 + 953)) <= (3435 - (1111 + 663))) and (v63 == (1581 - (874 + 705)))) then
				v67 = nil;
				function v67()
					local v204 = 0 + 0;
					while true do
						if (((411 + 190) < (7399 - 3839)) and (v204 == (0 + 0))) then
							if (((914 - (642 + 37)) < (157 + 530)) and v64.ImprovedGarrote:IsAvailable() and (v13:BuffUp(v64.ImprovedGarroteAura, nil, true) or v13:BuffUp(v64.ImprovedGarroteBuff, nil, true) or v13:BuffUp(v64.SepsisBuff, nil, true))) then
								return 1.5 + 0;
							end
							return 2 - 1;
						end
					end
				end
				v63 = 457 - (233 + 221);
			end
			if (((10518 - 5969) > (1015 + 138)) and (v63 == (1545 - (718 + 823)))) then
				v64.CrimsonTempest:RegisterPMultiplier(v66);
				break;
			end
			if ((v63 == (1 + 0)) or ((5479 - (266 + 539)) < (13227 - 8555))) then
				v66 = nil;
				function v66()
					local v205 = 1225 - (636 + 589);
					while true do
						if (((8706 - 5038) < (9407 - 4846)) and (v205 == (0 + 0))) then
							if ((v64.Nightstalker:IsAvailable() and v13:StealthUp(true, false, true)) or ((166 + 289) == (4620 - (657 + 358)))) then
								return (2 - 1) + ((0.05 - 0) * v64.Nightstalker:TalentRank());
							end
							return 1188 - (1151 + 36);
						end
					end
				end
				v63 = 2 + 0;
			end
			if ((v63 == (0 + 0)) or ((7952 - 5289) == (5144 - (1552 + 280)))) then
				v64 = v16.Rogue.Assassination;
				v65 = v16.Rogue.Subtlety;
				v63 = 835 - (64 + 770);
			end
		end
	end
	do
		local v68 = 0 + 0;
		local v69;
		local v70;
		local v71;
		while true do
			if (((9708 - 5431) <= (795 + 3680)) and (v68 == (1244 - (157 + 1086)))) then
				v71 = v16(789276 - 394956);
				v30.CPMaxSpend = function()
					return (21 - 16) + ((v69:IsAvailable() and (1 - 0)) or (0 - 0)) + ((v70:IsAvailable() and (820 - (599 + 220))) or (0 - 0)) + ((v71:IsAvailable() and (1932 - (1813 + 118))) or (0 + 0));
				end;
				break;
			end
			if ((v68 == (1217 - (841 + 376))) or ((1219 - 349) == (277 + 912))) then
				v69 = v16(528247 - 334716);
				v70 = v16(395180 - (464 + 395));
				v68 = 2 - 1;
			end
		end
	end
	v30.CPSpend = function()
		return v22(v13:ComboPoints(), v30.CPMaxSpend());
	end;
	do
		local v72 = 0 + 0;
		while true do
			if (((2390 - (467 + 370)) <= (6473 - 3340)) and (v72 == (0 + 0))) then
				v30.AnimachargedCP = function()
					if (v13:BuffUp(v16.Rogue.Commons.EchoingReprimand2) or ((7668 - 5431) >= (548 + 2963))) then
						return 4 - 2;
					elseif (v13:BuffUp(v16.Rogue.Commons.EchoingReprimand3) or ((1844 - (150 + 370)) > (4302 - (74 + 1208)))) then
						return 7 - 4;
					elseif (v13:BuffUp(v16.Rogue.Commons.EchoingReprimand4) or ((14189 - 11197) == (1339 + 542))) then
						return 394 - (14 + 376);
					elseif (((5387 - 2281) > (988 + 538)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand5)) then
						return 5 + 0;
					end
					return -(1 + 0);
				end;
				v30.EffectiveComboPoints = function(v206)
					if (((8857 - 5834) < (2912 + 958)) and (((v206 == (80 - (23 + 55))) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand2)) or ((v206 == (6 - 3)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand3)) or ((v206 == (3 + 1)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand4)) or ((v206 == (5 + 0)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand5)))) then
						return 10 - 3;
					end
					return v206;
				end;
				break;
			end
		end
	end
	do
		local v73 = 0 + 0;
		local v74;
		local v75;
		local v76;
		local v77;
		local v78;
		while true do
			if (((1044 - (652 + 249)) > (197 - 123)) and (v73 == (1870 - (708 + 1160)))) then
				v78 = v16.Rogue.Assassination.AtrophicPoisonDebuff;
				v30.Poisoned = function(v207)
					return ((v207:DebuffUp(v74) or v207:DebuffUp(v76) or v207:DebuffUp(v77) or v207:DebuffUp(v75) or v207:DebuffUp(v78)) and true) or false;
				end;
				break;
			end
			if (((48 - 30) < (3850 - 1738)) and (v73 == (27 - (10 + 17)))) then
				v74 = v16.Rogue.Assassination.DeadlyPoisonDebuff;
				v75 = v16.Rogue.Assassination.WoundPoisonDebuff;
				v73 = 1 + 0;
			end
			if (((2829 - (1400 + 332)) <= (3122 - 1494)) and (v73 == (1909 - (242 + 1666)))) then
				v76 = v16.Rogue.Assassination.AmplifyingPoisonDebuff;
				v77 = v16.Rogue.Assassination.CripplingPoisonDebuff;
				v73 = 1 + 1;
			end
		end
	end
	do
		local v79 = 0 + 0;
		local v80;
		local v81;
		local v82;
		local v83;
		local v84;
		local v85;
		while true do
			if (((3946 + 684) == (5570 - (850 + 90))) and (v79 == (1 - 0))) then
				v82 = v16.Rogue.Assassination.Rupture;
				v83 = v16.Rogue.Assassination.RuptureDeathmark;
				v79 = 1392 - (360 + 1030);
			end
			if (((3133 + 407) > (7572 - 4889)) and (v79 == (0 - 0))) then
				v80 = v16.Rogue.Assassination.Garrote;
				v81 = v16.Rogue.Assassination.GarroteDeathmark;
				v79 = 1662 - (909 + 752);
			end
			if (((6017 - (109 + 1114)) >= (5995 - 2720)) and (v79 == (2 + 1))) then
				v30.PoisonedBleeds = function()
					local v208 = 242 - (6 + 236);
					while true do
						if (((935 + 549) == (1195 + 289)) and ((0 - 0) == v208)) then
							v85 = 0 - 0;
							for v235, v236 in v23(v13:GetEnemiesInRange(1183 - (1076 + 57))) do
								if (((236 + 1196) < (4244 - (579 + 110))) and v30.Poisoned(v236)) then
									if (v236:DebuffUp(v80) or ((85 + 980) > (3164 + 414))) then
										local v247 = 0 + 0;
										while true do
											if ((v247 == (407 - (174 + 233))) or ((13393 - 8598) < (2469 - 1062))) then
												v85 = v85 + 1 + 0;
												if (((3027 - (663 + 511)) < (4294 + 519)) and v236:DebuffUp(v81)) then
													v85 = v85 + 1 + 0;
												end
												break;
											end
										end
									end
									if (v236:DebuffUp(v82) or ((8696 - 5875) < (1473 + 958))) then
										local v248 = 0 - 0;
										while true do
											if ((v248 == (0 - 0)) or ((1372 + 1502) < (4244 - 2063))) then
												v85 = v85 + 1 + 0;
												if (v236:DebuffUp(v83) or ((246 + 2443) <= (1065 - (478 + 244)))) then
													v85 = v85 + (518 - (440 + 77));
												end
												break;
											end
										end
									end
									if (v236:DebuffUp(v84) or ((850 + 1019) == (7352 - 5343))) then
										v85 = v85 + (1557 - (655 + 901));
									end
								end
							end
							v208 = 1 + 0;
						end
						if ((v208 == (1 + 0)) or ((2395 + 1151) < (9354 - 7032))) then
							return v85;
						end
					end
				end;
				break;
			end
			if (((1447 - (695 + 750)) == v79) or ((7109 - 5027) == (7365 - 2592))) then
				v84 = v16.Rogue.Assassination.InternalBleeding;
				v85 = 0 - 0;
				v79 = 354 - (285 + 66);
			end
		end
	end
	do
		local v86 = v29();
		v30.RtBRemains = function(v115)
			local v116 = 0 - 0;
			local v117;
			while true do
				if (((4554 - (682 + 628)) > (171 + 884)) and ((299 - (176 + 123)) == v116)) then
					v117 = (v86 - v29()) - v10.RecoveryOffset(v115);
					return ((v117 >= (0 + 0)) and v117) or (0 + 0);
				end
			end
		end;
		v10:RegisterForSelfCombatEvent(function(v118, v118, v118, v118, v118, v118, v118, v118, v118, v118, v118, v119)
			if ((v119 == (315777 - (239 + 30))) or ((901 + 2412) <= (1709 + 69))) then
				v86 = v29() + (53 - 23);
			end
		end, "SPELL_AURA_APPLIED");
		v10:RegisterForSelfCombatEvent(function(v120, v120, v120, v120, v120, v120, v120, v120, v120, v120, v120, v121)
			if ((v121 == (984356 - 668848)) or ((1736 - (306 + 9)) >= (7341 - 5237))) then
				v86 = v29() + v22(7 + 33, 19 + 11 + v30.RtBRemains(true));
			end
		end, "SPELL_AURA_REFRESH");
		v10:RegisterForSelfCombatEvent(function(v122, v122, v122, v122, v122, v122, v122, v122, v122, v122, v122, v123)
			if (((873 + 939) <= (9290 - 6041)) and (v123 == (316883 - (1140 + 235)))) then
				v86 = v29();
			end
		end, "SPELL_AURA_REMOVED");
	end
	do
		local v88 = {CrimsonTempest={},Garrote={},Rupture={}};
		v30.Exsanguinated = function(v124, v125)
			local v126 = v124:GUID();
			if (((1033 + 590) <= (1795 + 162)) and not v126) then
				return false;
			end
			local v127 = v125:ID();
			if (((1133 + 3279) == (4464 - (33 + 19))) and (v127 == (43838 + 77573))) then
				return v88.CrimsonTempest[v126] or false;
			elseif (((5245 - 3495) >= (371 + 471)) and (v127 == (1378 - 675))) then
				return v88.Garrote[v126] or false;
			elseif (((4100 + 272) > (2539 - (586 + 103))) and (v127 == (177 + 1766))) then
				return v88.Rupture[v126] or false;
			end
			return false;
		end;
		v30.WillLoseExsanguinate = function(v128, v129)
			if (((713 - 481) < (2309 - (1309 + 179))) and v30.Exsanguinated(v128, v129)) then
				return true;
			end
			return false;
		end;
		v30.ExsanguinatedRate = function(v130, v131)
			local v132 = 0 - 0;
			while true do
				if (((226 + 292) < (2422 - 1520)) and (v132 == (0 + 0))) then
					if (((6360 - 3366) > (1709 - 851)) and v30.Exsanguinated(v130, v131)) then
						return 611 - (295 + 314);
					end
					return 2 - 1;
				end
			end
		end;
		v10:RegisterForSelfCombatEvent(function(v133, v133, v133, v133, v133, v133, v133, v134, v133, v133, v133, v135)
			if ((v135 == (202768 - (1300 + 662))) or ((11791 - 8036) <= (2670 - (1178 + 577)))) then
				for v209, v210 in v23(v88) do
					for v221, v222 in v23(v210) do
						if (((2050 + 1896) > (11064 - 7321)) and (v221 == v134)) then
							v210[v221] = true;
						end
					end
				end
			end
		end, "SPELL_CAST_SUCCESS");
		v10:RegisterForSelfCombatEvent(function(v136, v136, v136, v136, v136, v136, v136, v137, v136, v136, v136, v138)
			if ((v138 == (122816 - (851 + 554))) or ((1181 + 154) >= (9168 - 5862))) then
				v88.CrimsonTempest[v137] = false;
			elseif (((10520 - 5676) > (2555 - (115 + 187))) and (v138 == (539 + 164))) then
				v88.Garrote[v137] = false;
			elseif (((428 + 24) == (1781 - 1329)) and (v138 == (3104 - (160 + 1001)))) then
				v88.Rupture[v137] = false;
			end
		end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
		v10:RegisterForSelfCombatEvent(function(v139, v139, v139, v139, v139, v139, v139, v140, v139, v139, v139, v141)
			if ((v141 == (106216 + 15195)) or ((3145 + 1412) < (4271 - 2184))) then
				if (((4232 - (237 + 121)) == (4771 - (525 + 372))) and (v88.CrimsonTempest[v140] ~= nil)) then
					v88.CrimsonTempest[v140] = nil;
				end
			elseif ((v141 == (1332 - 629)) or ((6367 - 4429) > (5077 - (96 + 46)))) then
				if ((v88.Garrote[v140] ~= nil) or ((5032 - (643 + 134)) < (1236 + 2187))) then
					v88.Garrote[v140] = nil;
				end
			elseif (((3486 - 2032) <= (9248 - 6757)) and (v141 == (1864 + 79))) then
				if ((v88.Rupture[v140] ~= nil) or ((8157 - 4000) <= (5729 - 2926))) then
					v88.Rupture[v140] = nil;
				end
			end
		end, "SPELL_AURA_REMOVED");
		v10:RegisterForCombatEvent(function(v142, v142, v142, v142, v142, v142, v142, v143)
			if (((5572 - (316 + 403)) >= (1983 + 999)) and (v88.CrimsonTempest[v143] ~= nil)) then
				v88.CrimsonTempest[v143] = nil;
			end
			if (((11365 - 7231) > (1214 + 2143)) and (v88.Garrote[v143] ~= nil)) then
				v88.Garrote[v143] = nil;
			end
			if ((v88.Rupture[v143] ~= nil) or ((8605 - 5188) < (1796 + 738))) then
				v88.Rupture[v143] = nil;
			end
		end, "UNIT_DIED", "UNIT_DESTROYED");
	end
	do
		local v92 = 0 + 0;
		local v93;
		local v94;
		local v95;
		while true do
			if (((0 - 0) == v92) or ((12999 - 10277) <= (340 - 176))) then
				v93 = v16(11199 + 184428);
				v94 = 0 - 0;
				v92 = 1 + 0;
			end
			if ((v92 == (2 - 1)) or ((2425 - (12 + 5)) < (8191 - 6082))) then
				v95 = v29();
				v30.FanTheHammerCP = function()
					local v211 = 0 - 0;
					while true do
						if ((v211 == (0 - 0)) or ((81 - 48) == (296 + 1159))) then
							if ((((v29() - v95) < (1973.5 - (1656 + 317))) and (v94 > (0 + 0))) or ((355 + 88) >= (10675 - 6660))) then
								if (((16644 - 13262) > (520 - (5 + 349))) and (v94 > v13:ComboPoints())) then
									return v94;
								else
									v94 = 0 - 0;
								end
							end
							return 1271 - (266 + 1005);
						end
					end
				end;
				v92 = 2 + 0;
			end
			if ((v92 == (6 - 4)) or ((368 - 88) == (4755 - (561 + 1135)))) then
				v10:RegisterForSelfCombatEvent(function(v212, v212, v212, v212, v212, v212, v212, v212, v212, v212, v212, v213, v212, v212, v214, v215)
					if (((2450 - 569) > (4250 - 2957)) and (v213 == (186829 - (507 + 559)))) then
						if (((5914 - 3557) == (7289 - 4932)) and ((v29() - v95) > (388.5 - (212 + 176)))) then
							v94 = v22(v30.CPMaxSpend(), v13:ComboPoints() + v214 + (v25(905 - (250 + 655), v214 - (2 - 1)) * v22(2 - 0, v13:BuffStack(v93) - (1 - 0))));
							v95 = v29();
						end
					end
				end, "SPELL_ENERGIZE");
				break;
			end
		end
	end
	do
		local v96, v97 = 1956 - (1869 + 87), 0 - 0;
		local v98 = v16(279826 - (484 + 1417));
		v30.TimeToNextTornado = function()
			local v144 = 0 - 0;
			local v145;
			while true do
				if (((205 - 82) == (896 - (48 + 725))) and (v144 == (1 - 0))) then
					if ((v29() == v96) or ((2832 - 1776) >= (1972 + 1420))) then
						return 0 - 0;
					elseif ((((v29() - v96) < (0.1 + 0)) and (v145 < (0.25 + 0))) or ((1934 - (152 + 701)) < (2386 - (430 + 881)))) then
						return 1 + 0;
					elseif ((((v145 > (895.9 - (557 + 338))) or (v145 == (0 + 0))) and ((v29() - v96) > (0.75 - 0))) or ((3673 - 2624) >= (11774 - 7342))) then
						return 0.1 - 0;
					end
					return v145;
				end
				if ((v144 == (801 - (499 + 302))) or ((5634 - (39 + 827)) <= (2334 - 1488))) then
					if (not v13:BuffUp(v98, nil, true) or ((7499 - 4141) <= (5640 - 4220))) then
						return 0 - 0;
					end
					v145 = v13:BuffRemains(v98, nil, true) % (1 + 0);
					v144 = 2 - 1;
				end
			end
		end;
		v10:RegisterForSelfCombatEvent(function(v146, v146, v146, v146, v146, v146, v146, v146, v146, v146, v146, v147)
			local v148 = 0 + 0;
			while true do
				if ((v148 == (0 - 0)) or ((3843 - (103 + 1)) <= (3559 - (475 + 79)))) then
					if ((v147 == (459908 - 247165)) or ((5308 - 3649) >= (276 + 1858))) then
						v96 = v29();
					elseif ((v147 == (174110 + 23725)) or ((4763 - (1395 + 108)) < (6853 - 4498))) then
						v97 = v29();
					end
					if ((v97 == v96) or ((1873 - (7 + 1197)) == (1842 + 2381))) then
						v96 = 0 + 0;
					end
					break;
				end
			end
		end, "SPELL_CAST_SUCCESS");
	end
	do
		local v100 = {Counter=(319 - (27 + 292)),LastMH=(0 - 0),LastOH=(0 - 0)};
		v30.TimeToSht = function(v149)
			local v150 = 0 - 0;
			local v151;
			local v152;
			local v153;
			local v154;
			local v155;
			local v156;
			while true do
				if ((v150 == (1 - 0)) or ((3222 - 1530) < (727 - (43 + 96)))) then
					v153 = v25(v100.LastMH + v151, v29());
					v154 = v25(v100.LastOH + v152, v29());
					v150 = 8 - 6;
				end
				if ((v150 == (8 - 4)) or ((3981 + 816) < (1031 + 2620))) then
					return v155[v156] - v29();
				end
				if ((v150 == (5 - 2)) or ((1601 + 2576) > (9089 - 4239))) then
					table.sort(v155);
					v156 = v22(2 + 3, v25(1 + 0, v149 - v100.Counter));
					v150 = 1755 - (1414 + 337);
				end
				if ((v150 == (1942 - (1642 + 298))) or ((1042 - 642) > (3196 - 2085))) then
					v155 = {};
					for v225 = 0 - 0, 1 + 1 do
						v27(v155, v153 + (v225 * v151));
						v27(v155, v154 + (v225 * v152));
					end
					v150 = 3 + 0;
				end
				if (((4023 - (357 + 615)) > (706 + 299)) and ((0 - 0) == v150)) then
					if (((3165 + 528) <= (9390 - 5008)) and (v100.Counter >= v149)) then
						return 0 + 0;
					end
					v151, v152 = v28("player");
					v150 = 1 + 0;
				end
			end
		end;
		v10:RegisterForSelfCombatEvent(function()
			local v157 = 0 + 0;
			while true do
				if ((v157 == (1301 - (384 + 917))) or ((3979 - (128 + 569)) > (5643 - (1407 + 136)))) then
					v100.Counter = 1887 - (687 + 1200);
					v100.LastMH = v29();
					v157 = 1711 - (556 + 1154);
				end
				if ((v157 == (3 - 2)) or ((3675 - (9 + 86)) < (3265 - (275 + 146)))) then
					v100.LastOH = v29();
					break;
				end
			end
		end, "PLAYER_ENTERING_WORLD");
		v10:RegisterForSelfCombatEvent(function(v158, v158, v158, v158, v158, v158, v158, v158, v158, v158, v158, v159)
			if (((15 + 74) < (4554 - (29 + 35))) and (v159 == (872698 - 675787))) then
				v100.Counter = 0 - 0;
			end
		end, "SPELL_ENERGIZE");
		v10:RegisterForSelfCombatEvent(function(v160, v160, v160, v160, v160, v160, v160, v160, v160, v160, v160, v160, v160, v160, v160, v160, v160, v160, v160, v160, v160, v160, v160, v161)
			local v162 = 0 - 0;
			while true do
				if (((0 + 0) == v162) or ((5995 - (53 + 959)) < (2216 - (312 + 96)))) then
					v100.Counter = v100.Counter + (1 - 0);
					if (((4114 - (147 + 138)) > (4668 - (813 + 86))) and v161) then
						v100.LastOH = v29();
					else
						v100.LastMH = v29();
					end
					break;
				end
			end
		end, "SWING_DAMAGE");
		v10:RegisterForSelfCombatEvent(function(v163, v163, v163, v163, v163, v163, v163, v163, v163, v163, v163, v163, v163, v163, v163, v164)
			if (((1342 + 143) <= (5380 - 2476)) and v164) then
				v100.LastOH = v29();
			else
				v100.LastMH = v29();
			end
		end, "SWING_MISSED");
	end
	do
		local v102 = 492 - (18 + 474);
		local v103;
		local v104;
		local v105;
		while true do
			if (((1441 + 2828) == (13933 - 9664)) and (v102 == (1086 - (860 + 226)))) then
				v103 = v13:CritChancePct();
				v104 = 303 - (121 + 182);
				v102 = 1 + 0;
			end
			if (((1627 - (988 + 252)) <= (315 + 2467)) and (v102 == (1 + 1))) then
				v10:RegisterForEvent(function()
					if ((v104 == (1970 - (49 + 1921))) or ((2789 - (223 + 667)) <= (969 - (51 + 1)))) then
						v24.After(5 - 2, v105);
						v104 = 3 - 1;
					end
				end, "PLAYER_EQUIPMENT_CHANGED");
				v30.BaseAttackCrit = function()
					return v103;
				end;
				break;
			end
			if ((v102 == (1126 - (146 + 979))) or ((1217 + 3095) <= (1481 - (311 + 294)))) then
				v105 = nil;
				function v105()
					local v220 = 0 - 0;
					while true do
						if (((946 + 1286) <= (4039 - (496 + 947))) and (v220 == (1359 - (1233 + 125)))) then
							if (((851 + 1244) < (3307 + 379)) and (v104 > (0 + 0))) then
								v24.After(1648 - (963 + 682), v105);
							end
							break;
						end
						if ((v220 == (0 + 0)) or ((3099 - (504 + 1000)) >= (3013 + 1461))) then
							if (not v13:AffectingCombat() or ((4207 + 412) < (272 + 2610))) then
								local v242 = 0 - 0;
								while true do
									if ((v242 == (0 + 0)) or ((171 + 123) >= (5013 - (156 + 26)))) then
										v103 = v13:CritChancePct();
										v10.Debug("Base Crit Set to: " .. v103);
										break;
									end
								end
							end
							if (((1169 + 860) <= (4824 - 1740)) and ((v104 == nil) or (v104 < (164 - (149 + 15))))) then
								v104 = 960 - (890 + 70);
							else
								v104 = v104 - (118 - (39 + 78));
							end
							v220 = 483 - (14 + 468);
						end
					end
				end
				v102 = 4 - 2;
			end
		end
	end
	do
		local v106 = v16.Rogue.Assassination;
		local v107 = v16.Rogue.Subtlety;
		local function v108()
			local v165 = 0 - 0;
			while true do
				if ((v165 == (0 + 0)) or ((1224 + 813) == (515 + 1905))) then
					if (((2014 + 2444) > (1023 + 2881)) and v106.Nightstalker:IsAvailable() and v13:StealthUp(true, false, true)) then
						return (1 - 0) + ((0.05 + 0) * v106.Nightstalker:TalentRank());
					end
					return 3 - 2;
				end
			end
		end
		local function v109()
			local v166 = 0 + 0;
			while true do
				if (((487 - (12 + 39)) >= (115 + 8)) and (v166 == (0 - 0))) then
					if (((1780 - 1280) < (539 + 1277)) and v106.ImprovedGarrote:IsAvailable() and (v13:BuffUp(v106.ImprovedGarroteAura, nil, true) or v13:BuffUp(v106.ImprovedGarroteBuff, nil, true) or v13:BuffUp(v106.SepsisBuff, nil, true))) then
						return 1.5 + 0;
					end
					return 2 - 1;
				end
			end
		end
		v106.Rupture:RegisterPMultiplier(v108, {v107.FinalityRuptureBuff,(1711.3 - (1596 + 114))});
		v106.Garrote:RegisterPMultiplier(v108, v109);
	end
end;
return v0["Epix_Rogue_Rogue.lua"]();

