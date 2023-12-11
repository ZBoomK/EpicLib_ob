local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1144 - (700 + 444);
	local v6;
	while true do
		if ((v5 == (1 - 0)) or ((3970 - 2489) >= (3885 - (322 + 905)))) then
			return v6(...);
		end
		if ((v5 == (611 - (602 + 9))) or ((4409 - (449 + 740)) == (2236 - (826 + 46)))) then
			v6 = v0[v4];
			if (not v6 or ((2001 - (245 + 702)) > (10718 - 7326))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
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
	if (not v16.Rogue or ((2574 - (260 + 1638)) >= (2082 - (382 + 58)))) then
		v16.Rogue = {};
	end
	v16.Rogue.Commons = {Sanguine=v16(726660 - 500150, nil, 1 + 0),AncestralCall=v16(567800 - 293062, nil, 5 - 3),ArcanePulse=v16(261569 - (902 + 303), nil, 5 - 2),ArcaneTorrent=v16(60323 - 35277, nil, 1 + 3),BagofTricks=v16(314101 - (1121 + 569), nil, 219 - (22 + 192)),Berserking=v16(26980 - (483 + 200), nil, 1469 - (1404 + 59)),BloodFury=v16(56300 - 35728, nil, 9 - 2),Fireblood=v16(265986 - (468 + 297), nil, 570 - (334 + 228)),LightsJudgment=v16(862293 - 606646, nil, 20 - 11),Shadowmeld=v16(106975 - 47991, nil, 3 + 7),CloakofShadows=v16(31460 - (141 + 95), nil, 11 + 0),CrimsonVial=v16(476991 - 291680, nil, 28 - 16),Evasion=v16(1237 + 4040, nil, 35 - 22),Feint=v16(1383 + 583, nil, 8 + 6),Blind=v16(2948 - 854, nil, 9 + 6),CheapShot=v16(1996 - (92 + 71), nil, 8 + 8),Kick=v16(2968 - 1202, nil, 782 - (574 + 191)),KidneyShot=v16(337 + 71, nil, 44 - 26),Sap=v16(3459 + 3311, nil, 868 - (254 + 595)),Shiv=v16(6064 - (55 + 71), nil, 26 - 6),SliceandDice=v16(317286 - (573 + 1217), nil, 58 - 37),Shadowstep=v16(2782 + 33772, nil, 34 - 12),Sprint=v16(3922 - (714 + 225), nil, 66 - 43),TricksoftheTrade=v16(80769 - 22835, nil, 3 + 21),CripplingPoison=v16(4934 - 1526, nil, 831 - (118 + 688)),DeadlyPoison=v16(2871 - (25 + 23), nil, 6 + 20),InstantPoison=v16(317470 - (927 + 959), nil, 90 - 63),AmplifyingPoison=v16(382396 - (16 + 716), nil, 53 - 25),NumbingPoison=v16(5858 - (11 + 86), nil, 70 - 41),WoundPoison=v16(8964 - (175 + 110), nil, 75 - 45),AtrophicPoison=v16(1882329 - 1500692, nil, 1827 - (503 + 1293)),AcrobaticStrikes=v16(549969 - 353045, nil, 24 + 8),Alacrity=v16(194600 - (810 + 251), nil, 23 + 10),ColdBlood=v16(117312 + 264933, nil, 31 + 3),DeeperStratagem=v16(194064 - (43 + 490)),EchoingReprimand=v16(386349 - (711 + 22), nil, 139 - 103),EchoingReprimand2=v16(324417 - (240 + 619), nil, 9 + 28),EchoingReprimand3=v16(514686 - 191127, nil, 3 + 35),EchoingReprimand4=v16(325304 - (1344 + 400), nil, 444 - (255 + 150)),EchoingReprimand5=v16(279498 + 75340, nil, 22 + 18),FindWeakness=v16(388902 - 297879, nil, 132 - 91),FindWeaknessDebuff=v16(317959 - (404 + 1335), nil, 448 - (183 + 223)),ImprovedAmbush=v16(464379 - 82759, nil, 29 + 14),MarkedforDeath=v16(49526 + 88093, nil, 381 - (10 + 327)),Nightstalker=v16(9793 + 4269, nil, 383 - (118 + 220)),ResoundingClarity=v16(127177 + 254445, nil, 495 - (108 + 341)),SealFate=v16(6374 + 7816, nil, 198 - 151),Sepsis=v16(386901 - (711 + 782), nil, 91 - 43),SepsisBuff=v16(376408 - (270 + 199), nil, 16 + 33),ShadowDance=v16(187132 - (580 + 1239), nil, 148 - 98),ShadowDanceTalent=v16(377614 + 17316, nil, 2 + 49),ShadowDanceBuff=v16(80775 + 104647),Subterfuge=v16(282527 - 174319, nil, 33 + 20),SubterfugeBuff=v16(116359 - (645 + 522), nil, 1844 - (1010 + 780)),ThistleTea=v16(381435 + 188, nil, 1524 - 1204),Vigor=v16(43907 - 28924),Stealth=v16(3620 - (1045 + 791), nil, 144 - 87),Stealth2=v16(175890 - 60699, nil, 563 - (351 + 154)),Vanish=v16(3430 - (1281 + 293), nil, 325 - (28 + 238)),VanishBuff=v16(25309 - 13982, nil, 1619 - (1381 + 178)),VanishBuff2=v16(108044 + 7149, nil, 50 + 11),PoolEnergy=v16(426520 + 573390, nil, 213 - 151)};
	v16.Rogue.Assassination = v19(v16.Rogue.Commons, {Ambush=v16(4495 + 4181, nil, 533 - (381 + 89)),AmbushOverride=v16(381340 + 48683),AmplifyingPoisonDebuff=v16(259299 + 124115, nil, 109 - 45),AmplifyingPoisonDebuffDeathmark=v16(395484 - (1074 + 82), nil, 142 - 77),CripplingPoisonDebuff=v16(5193 - (214 + 1570), nil, 1521 - (990 + 465)),DeadlyPoisonDebuff=v16(1162 + 1656, nil, 30 + 37),DeadlyPoisonDebuffDeathmark=v16(383460 + 10864, nil, 267 - 199),Envenom=v16(34371 - (1668 + 58), nil, 695 - (512 + 114)),FanofKnives=v16(134849 - 83126, nil, 144 - 74),Garrote=v16(2446 - 1743, nil, 34 + 37),GarroteDeathmark=v16(67545 + 293285, nil, 63 + 9),Mutilate=v16(4482 - 3153, nil, 2067 - (109 + 1885)),PoisonedKnife=v16(187034 - (1269 + 200), nil, 141 - 67),Rupture=v16(2758 - (98 + 717), nil, 901 - (802 + 24)),RuptureDeathmark=v16(622256 - 261430, nil, 95 - 19),WoundPoisonDebuff=v16(1282 + 7398, nil, 60 + 17),ArterialPrecision=v16(65831 + 334952, nil, 17 + 61),AtrophicPoisonDebuff=v16(1091599 - 699211, nil, 263 - 184),BlindsideBuff=v16(43333 + 77820, nil, 33 + 47),CausticSpatter=v16(348070 + 73905),CausticSpatterDebuff=v16(306833 + 115143),CrimsonTempest=v16(56686 + 64725, nil, 1514 - (797 + 636)),CutToTheChase=v16(250861 - 199194, nil, 1701 - (1427 + 192)),DashingScoundrel=v16(132290 + 249507, nil, 192 - 109),Deathmark=v16(323766 + 36428, nil, 39 + 45),Doomblade=v16(381999 - (192 + 134), nil, 1361 - (316 + 960)),DragonTemperedBlades=v16(212471 + 169330, nil, 67 + 19),Elusiveness=v16(73028 + 5980),Exsanguinate=v16(767682 - 566876, nil, 639 - (83 + 468)),ImprovedGarrote=v16(383438 - (1202 + 604), nil, 415 - 326),ImprovedGarroteBuff=v16(653081 - 260680, nil, 249 - 159),ImprovedGarroteAura=v16(392728 - (45 + 280), nil, 88 + 3),IndiscriminateCarnage=v16(333568 + 48234, nil, 34 + 58),IndiscriminateCarnageAura=v16(213464 + 172290),IndiscriminateCarnageBuff=v16(67849 + 317898),InternalBleeding=v16(286937 - 131984, nil, 2004 - (340 + 1571)),Kingsbane=v16(152101 + 233526, nil, 1866 - (1733 + 39)),LightweightShiv=v16(1085372 - 690389),MasterAssassin=v16(257023 - (125 + 909), nil, 2043 - (1096 + 852)),MasterAssassinBuff=v16(115165 + 141570, nil, 136 - 40),PreyontheWeak=v16(127557 + 3954, nil, 609 - (409 + 103)),PreyontheWeakDebuff=v16(256145 - (46 + 190), nil, 193 - (51 + 44)),SerratedBoneSpike=v16(108706 + 276718, nil, 1416 - (1114 + 203)),SerratedBoneSpikeDebuff=v16(394762 - (228 + 498), nil, 22 + 78),ShivDebuff=v16(176514 + 142990, nil, 764 - (174 + 489)),VenomRush=v16(396400 - 244248, nil, 2007 - (830 + 1075)),ScentOfBlood=v16(382323 - (303 + 221), nil, 1665 - (231 + 1038)),ScentOfBloodBuff=v16(328391 + 65689),ShroudedSuffocation=v16(386640 - (171 + 991))});
	v16.Rogue.Outlaw = v19(v16.Rogue.Commons, {AdrenalineRush=v16(56666 - 42916, nil, 276 - 173),Ambush=v16(21650 - 12974, nil, 84 + 20),AmbushOverride=v16(1507384 - 1077361),BetweentheEyes=v16(909697 - 594356, nil, 169 - 64),BladeFlurry=v16(42897 - 29020, nil, 1354 - (111 + 1137)),Dispatch=v16(2256 - (91 + 67), nil, 318 - 211),Elusiveness=v16(19713 + 59295),Opportunity=v16(196150 - (423 + 100)),PistolShot=v16(1304 + 184459, nil, 304 - 194),RolltheBones=v16(164450 + 151058, nil, 882 - (326 + 445)),SinisterStrike=v16(843621 - 650306, nil, 249 - 137),Audacity=v16(891312 - 509467, nil, 824 - (530 + 181)),AudacityBuff=v16(387151 - (614 + 267), nil, 146 - (19 + 13)),BladeRush=v16(442510 - 170633, nil, 267 - 152),CountTheOdds=v16(1091172 - 709190, nil, 31 + 85),Dreadblades=v16(603475 - 260333, nil, 242 - 125),FanTheHammer=v16(383658 - (1293 + 519), nil, 240 - 122),GhostlyStrike=v16(514192 - 317255, nil, 227 - 108),GreenskinsWickers=v16(1668022 - 1281199, nil, 282 - 162),GreenskinsWickersBuff=v16(208749 + 185382, nil, 25 + 96),HiddenOpportunity=v16(890559 - 507278, nil, 29 + 93),ImprovedAdrenalineRush=v16(131363 + 264059, nil, 77 + 46),ImprovedBetweenTheEyes=v16(236580 - (709 + 387), nil, 1982 - (673 + 1185)),KeepItRolling=v16(1107822 - 725833, nil, 401 - 276),KillingSpree=v16(85047 - 33357, nil, 91 + 35),LoadedDice=v16(191411 + 64759, nil, 171 - 44),LoadedDiceBuff=v16(62917 + 193254, nil, 255 - 127),PreyontheWeak=v16(258159 - 126648, nil, 2009 - (446 + 1434)),PreyontheWeakDebuff=v16(257192 - (1040 + 243), nil, 388 - 258),QuickDraw=v16(198785 - (559 + 1288), nil, 2062 - (609 + 1322)),SummarilyDispatched=v16(382444 - (13 + 441), nil, 493 - 361),SwiftSlasher=v16(1000565 - 618577, nil, 662 - 529),TakeEmBySurpriseBuff=v16(14369 + 371538, nil, 486 - 352),Weaponmaster=v16(71296 + 129437, nil, 60 + 75),UnderhandedUpperhand=v16(1258362 - 834318),DeftManeuvers=v16(208968 + 172910),Crackshot=v16(779277 - 355574),Gouge=v16(1175 + 601, nil, 76 + 60),Broadside=v16(138928 + 54428, nil, 116 + 21),BuriedTreasure=v16(195286 + 4314, nil, 571 - (153 + 280)),GrandMelee=v16(558340 - 364982, nil, 125 + 14),RuthlessPrecision=v16(76346 + 117011, nil, 74 + 66),SkullandCrossbones=v16(181136 + 18467, nil, 103 + 38),TrueBearing=v16(294430 - 101071, nil, 88 + 54),ViciousFollowup=v16(395546 - (89 + 578), nil, 103 + 40)});
	v16.Rogue.Subtlety = v19(v16.Rogue.Commons, {Backstab=v16(109 - 56, nil, 1193 - (572 + 477)),BlackPowder=v16(43047 + 276128, nil, 88 + 57),Elusiveness=v16(9431 + 69577),Eviscerate=v16(196905 - (84 + 2), nil, 241 - 94),Rupture=v16(1400 + 543, nil, 990 - (497 + 345)),ShadowBlades=v16(3108 + 118363, nil, 26 + 123),Shadowstrike=v16(186771 - (605 + 728), nil, 108 + 42),ShurikenStorm=v16(439842 - 242007, nil, 7 + 144),ShurikenToss=v16(421536 - 307522, nil, 138 + 14),SymbolsofDeath=v16(588158 - 375875, nil, 116 + 37),DanseMacabre=v16(383017 - (457 + 32), nil, 66 + 88),DanseMacabreBuff=v16(395371 - (832 + 570), nil, 147 + 8),DeeperDaggers=v16(99752 + 282765, nil, 551 - 395),DeeperDaggersBuff=v16(184688 + 198717, nil, 953 - (588 + 208)),DarkBrew=v16(1030936 - 648432, nil, 1958 - (884 + 916)),DarkShadow=v16(514364 - 268677, nil, 93 + 66),EnvelopingShadows=v16(238757 - (232 + 421), nil, 2049 - (1569 + 320)),Finality=v16(93850 + 288675, nil, 31 + 130),FinalityBlackPowderBuff=v16(1300573 - 914625, nil, 767 - (316 + 289)),FinalityEviscerateBuff=v16(1010306 - 624357, nil, 8 + 155),FinalityRuptureBuff=v16(387404 - (666 + 787), nil, 589 - (360 + 65)),Flagellation=v16(359463 + 25168, nil, 419 - (79 + 175)),FlagellationPersistBuff=v16(622467 - 227709, nil, 130 + 36),Gloomblade=v16(615378 - 414620, nil, 321 - 154),GoremawsBite=v16(427490 - (503 + 396), nil, 370 - (92 + 89)),ImprovedShadowDance=v16(764288 - 370316, nil, 87 + 81),ImprovedShurikenStorm=v16(189362 + 130589, nil, 661 - 492),InvigoratingShadowdust=v16(52311 + 330212),LingeringShadow=v16(872203 - 489679, nil, 149 + 21),LingeringShadowBuff=v16(184348 + 201612, nil, 520 - 349),MasterofShadows=v16(24585 + 172391, nil, 261 - 89),PerforatedVeins=v16(383762 - (485 + 759), nil, 400 - 227),PerforatedVeinsBuff=v16(395443 - (442 + 747), nil, 1309 - (832 + 303)),PreyontheWeak=v16(132457 - (88 + 858), nil, 54 + 121),PreyontheWeakDebuff=v16(211791 + 44118, nil, 8 + 168),Premeditation=v16(343949 - (766 + 23), nil, 873 - 696),PremeditationBuff=v16(469342 - 126169, nil, 468 - 290),SecretStratagem=v16(1338335 - 944015, nil, 1252 - (1036 + 37)),SecretTechnique=v16(199023 + 81696, nil, 350 - 170),Shadowcraft=v16(335573 + 91021),ShadowFocus=v16(109689 - (641 + 839), nil, 1094 - (910 + 3)),ShurikenTornado=v16(708513 - 430588, nil, 1866 - (1466 + 218)),SilentStorm=v16(177273 + 208449, nil, 1331 - (556 + 592)),SilentStormBuff=v16(137161 + 248561, nil, 992 - (329 + 479)),TheFirstDance=v16(383359 - (174 + 680), nil, 635 - 450),TheRotten=v16(791815 - 409800, nil, 133 + 53),TheRottenBuff=v16(394942 - (396 + 343), nil, 17 + 170),Weaponmaster=v16(195014 - (29 + 1448), nil, 1577 - (135 + 1254))});
	if (((15581 - 11445) > (11191 - 8794)) and not v18.Rogue) then
		v18.Rogue = {};
	end
	v18.Rogue.Commons = {AlgetharPuzzleBox=v18(129090 + 64611, {(587 - (102 + 472)),(8 + 6)}),ManicGrieftorch=v18(181179 + 13129, {(22 - 9),(1478 - (157 + 1307))}),WindscarWhetstone=v18(139345 - (821 + 1038), {(2 + 11),(6 + 8)}),Healthstone=v18(13661 - 8149),RefreshingHealingPotion=v18(192406 - (834 + 192))};
	v18.Rogue.Assassination = v19(v18.Rogue.Commons, {AlgetharPuzzleBox=v18(12315 + 181386, {(1 + 12),(318 - (300 + 4))}),AshesoftheEmbersoul=v18(55328 + 151839, {(375 - (112 + 250)),(34 - 20)}),WitherbarksBranch=v18(63017 + 46982, {(10 + 3),(11 + 3)})});
	v18.Rogue.Outlaw = v19(v18.Rogue.Commons, {ManicGrieftorch=v18(195722 - (1001 + 413), {(895 - (244 + 638)),(41 - 27)}),WindscarWhetstone=v18(138088 - (512 + 90), {(730 - (373 + 344)),(4 + 10)}),BeaconToTheBeyond=v18(537998 - 334035, {(1112 - (35 + 1064)),(29 - 15)}),DragonfireBombDispenser=v18(809 + 201801, {(1272 - (233 + 1026)),(8 + 6)})});
	v18.Rogue.Subtlety = v19(v18.Rogue.Commons, {ManicGrieftorch=v18(189794 + 4514, {(1 + 12),(3 + 11)}),StormEatersBoon=v18(19540 + 174762, {(310 - (36 + 261)),(1382 - (34 + 1334))}),BeaconToTheBeyond=v18(78409 + 125554, {(1296 - (1035 + 248)),(8 + 6)}),AshesoftheEmbersoul=v18(207486 - (134 + 185), {(698 - (314 + 371)),(982 - (478 + 490))}),WitherbarksBranch=v18(58271 + 51728, {(41 - 28),(1354 - (1093 + 247))}),BandolierOfTwistedBlades=v18(184094 + 23071, {(51 - 38),(39 - 25)}),Mirror=v18(521632 - 314051, {(49 - 36),(11 + 3)})});
	if (not v21.Rogue or ((11083 - 6749) == (4933 - (364 + 324)))) then
		v21.Rogue = {};
	end
	v21.Rogue.Commons = {Healthstone=v21(57 - 36),BlindMouseover=v21(21 - 12),CheapShotMouseover=v21(4 + 6),KickMouseover=v21(45 - 34),KidneyShotMouseover=v21(18 - 6),TricksoftheTradeFocus=v21(39 - 26),WindscarWhetstone=v21(1294 - (1249 + 19))};
	v21.Rogue.Outlaw = v19(v21.Rogue.Commons, {Dispatch=v21(13 + 1),PistolShotMouseover=v21(58 - 43),SinisterStrikeMouseover=v21(1102 - (686 + 400))});
	v21.Rogue.Subtlety = v19(v21.Rogue.Commons, {SecretTechnique=v21(13 + 3),ShadowDance=v21(246 - (73 + 156)),ShadowDanceSymbol=v21(1 + 25),VanishShadowstrike=v21(829 - (721 + 90)),ShurikenStormSD=v21(1 + 18),ShurikenStormVanish=v21(64 - 44),GloombladeSD=v21(492 - (224 + 246)),GloombladeVanish=v21(36 - 13),BackstabMouseover=v21(43 - 19),RuptureMouseover=v21(5 + 20)});
	v30.StealthSpell = function()
		return (v16.Rogue.Commons.Subterfuge:IsAvailable() and v16.Rogue.Commons.Stealth2) or v16.Rogue.Commons.Stealth;
	end;
	v30.VanishBuffSpell = function()
		return (v16.Rogue.Commons.Subterfuge:IsAvailable() and v16.Rogue.Commons.VanishBuff2) or v16.Rogue.Commons.VanishBuff;
	end;
	v30.Stealth = function(v49, v50)
		if ((EpicSettings.Settings['StealthOOC'] and (v16.Rogue.Commons.Stealth:IsCastable() or v16.Rogue.Commons.Stealth2:IsCastable()) and v13:StealthDown()) or ((102 + 4174) <= (2227 + 804))) then
			if (v10.Press(v49, nil) or ((9506 - 4724) <= (3989 - 2790))) then
				return "Cast Stealth (OOC)";
			end
		end
		return false;
	end;
	do
		local v51 = v16(185824 - (203 + 310));
		v30.CrimsonVial = function()
			local v109 = 1993 - (1238 + 755);
			local v110;
			while true do
				if ((v109 == (0 + 0)) or ((6398 - (709 + 825)) < (3504 - 1602))) then
					v110 = EpicSettings.Settings['CrimsonVialHP'] or (0 - 0);
					if (((5703 - (196 + 668)) >= (14608 - 10908)) and v51:IsCastable() and v51:IsReady() and (v13:HealthPercentage() <= v110)) then
						if (v10.Cast(v51, nil) or ((2226 - 1151) > (2751 - (171 + 662)))) then
							return "Cast Crimson Vial (Defensives)";
						end
					end
					v109 = 94 - (4 + 89);
				end
				if (((1387 - 991) <= (1386 + 2418)) and (v109 == (4 - 3))) then
					return false;
				end
			end
		end;
	end
	do
		local v53 = v16(771 + 1195);
		v30.Feint = function()
			local v111 = 1486 - (35 + 1451);
			local v112;
			while true do
				if ((v111 == (1453 - (28 + 1425))) or ((6162 - (941 + 1052)) == (2098 + 89))) then
					v112 = EpicSettings.Settings['FeintHP'] or (1514 - (822 + 692));
					if (((2006 - 600) == (663 + 743)) and v53:IsCastable() and v13:BuffDown(v53) and (v13:HealthPercentage() <= v112)) then
						if (((1828 - (45 + 252)) < (4226 + 45)) and v10.Cast(v53, nil)) then
							return "Cast Feint (Defensives)";
						end
					end
					break;
				end
			end
		end;
	end
	do
		local v55 = 0 + 0;
		local v56;
		local v57;
		local v58;
		while true do
			if (((1545 - 910) == (1068 - (114 + 319))) and (v55 == (1 - 0))) then
				v58 = nil;
				function v58(v157)
					if (((4321 - 948) <= (2267 + 1289)) and not v13:AffectingCombat() and v13:BuffRefreshable(v157)) then
						if (v10.Press(v157, nil, true) or ((4902 - 1611) < (6872 - 3592))) then
							return "poison";
						end
					end
				end
				v55 = 1965 - (556 + 1407);
			end
			if (((5592 - (741 + 465)) >= (1338 - (170 + 295))) and (v55 == (2 + 0))) then
				v30.Poisons = function()
					local v158 = 0 + 0;
					while true do
						if (((2267 - 1346) <= (914 + 188)) and (v158 == (1 + 0))) then
							if (((2665 + 2041) >= (2193 - (957 + 273))) and v13:BuffDown(v16.Rogue.Commons.CripplingPoison)) then
								if (v16.Rogue.Commons.AtrophicPoison:IsAvailable() or ((257 + 703) <= (351 + 525))) then
									local v228 = v58(v16.Rogue.Commons.AtrophicPoison);
									if (v228 or ((7872 - 5806) == (2455 - 1523))) then
										return v228;
									end
								elseif (((14737 - 9912) < (23980 - 19137)) and v16.Rogue.Commons.NumbingPoison:IsAvailable()) then
									local v231 = v58(v16.Rogue.Commons.NumbingPoison);
									if (v231 or ((5657 - (389 + 1391)) >= (2847 + 1690))) then
										return v231;
									end
								else
									local v232 = v58(v16.Rogue.Commons.CripplingPoison);
									if (v232 or ((450 + 3865) < (3929 - 2203))) then
										return v232;
									end
								end
							else
								local v217 = 951 - (783 + 168);
								local v218;
								while true do
									if ((v217 == (0 - 0)) or ((3619 + 60) < (936 - (309 + 2)))) then
										v218 = v58(v16.Rogue.Commons.CripplingPoison);
										if (v218 or ((14202 - 9577) < (1844 - (1090 + 122)))) then
											return v218;
										end
										break;
									end
								end
							end
							break;
						end
						if ((v158 == (0 + 0)) or ((278 - 195) > (1219 + 561))) then
							v57 = v13:BuffUp(v16.Rogue.Commons.WoundPoison);
							if (((1664 - (628 + 490)) <= (194 + 883)) and v16.Rogue.Assassination.DragonTemperedBlades:IsAvailable()) then
								local v219 = 0 - 0;
								local v220;
								while true do
									if ((v219 == (0 - 0)) or ((1770 - (431 + 343)) > (8686 - 4385))) then
										v220 = v58((v57 and v16.Rogue.Commons.WoundPoison) or v16.Rogue.Commons.DeadlyPoison);
										if (((11774 - 7704) > (543 + 144)) and v220) then
											return v220;
										end
										v219 = 1 + 0;
									end
									if ((v219 == (1696 - (556 + 1139))) or ((671 - (6 + 9)) >= (610 + 2720))) then
										if (v16.Rogue.Commons.AmplifyingPoison:IsAvailable() or ((1277 + 1215) <= (504 - (28 + 141)))) then
											v220 = v58(v16.Rogue.Commons.AmplifyingPoison);
											if (((1675 + 2647) >= (3162 - 600)) and v220) then
												return v220;
											end
										else
											v220 = v58(v16.Rogue.Commons.InstantPoison);
											if (v220 or ((2576 + 1061) >= (5087 - (486 + 831)))) then
												return v220;
											end
										end
										break;
									end
								end
							elseif (v57 or ((6190 - 3811) > (16117 - 11539))) then
								local v229 = v58(v16.Rogue.Commons.WoundPoison);
								if (v229 or ((92 + 391) > (2349 - 1606))) then
									return v229;
								end
							elseif (((3717 - (668 + 595)) > (521 + 57)) and v16.Rogue.Commons.AmplifyingPoison:IsAvailable() and v13:BuffDown(v16.Rogue.Commons.DeadlyPoison)) then
								local v233 = v58(v16.Rogue.Commons.AmplifyingPoison);
								if (((188 + 742) < (12157 - 7699)) and v233) then
									return v233;
								end
							elseif (((952 - (23 + 267)) <= (2916 - (1129 + 815))) and v16.Rogue.Commons.DeadlyPoison:IsAvailable()) then
								local v234 = 387 - (371 + 16);
								local v235;
								while true do
									if (((6120 - (1326 + 424)) == (8276 - 3906)) and ((0 - 0) == v234)) then
										v235 = v58(v16.Rogue.Commons.DeadlyPoison);
										if (v235 or ((4880 - (88 + 30)) <= (1632 - (720 + 51)))) then
											return v235;
										end
										break;
									end
								end
							else
								local v236 = 0 - 0;
								local v237;
								while true do
									if ((v236 == (1776 - (421 + 1355))) or ((2328 - 916) == (2095 + 2169))) then
										v237 = v58(v16.Rogue.Commons.InstantPoison);
										if (v237 or ((4251 - (286 + 797)) < (7870 - 5717))) then
											return v237;
										end
										break;
									end
								end
							end
							v158 = 1 - 0;
						end
					end
				end;
				break;
			end
			if ((v55 == (439 - (397 + 42))) or ((1555 + 3421) < (2132 - (24 + 776)))) then
				v56 = 0 - 0;
				v57 = false;
				v55 = 786 - (222 + 563);
			end
		end
	end
	v30.MfDSniping = function(v59)
		if (((10196 - 5568) == (3333 + 1295)) and v59:IsCastable()) then
			local v133 = 190 - (23 + 167);
			local v134;
			local v135;
			local v136;
			while true do
				if ((v133 == (1798 - (690 + 1108))) or ((20 + 34) == (326 + 69))) then
					v134, v135 = nil, 908 - (40 + 808);
					v136 = (v15:IsInRange(5 + 25) and v15:TimeToDie()) or (42488 - 31377);
					v133 = 1 + 0;
				end
				if (((44 + 38) == (45 + 37)) and ((572 - (47 + 524)) == v133)) then
					for v203, v204 in v23(v13:GetEnemiesInRange(20 + 10)) do
						local v205 = v204:TimeToDie();
						if ((not v204:IsMfDBlacklisted() and (v205 < (v13:ComboPointsDeficit() * (2.5 - 1))) and (v205 < v135)) or ((868 - 287) < (642 - 360))) then
							if (((v136 - v205) > (1727 - (1165 + 561))) or ((137 + 4472) < (7727 - 5232))) then
								v134, v135 = v204, v205;
							else
								v134, v135 = v15, v136;
							end
						end
					end
					if (((440 + 712) == (1631 - (341 + 138))) and v134 and (v134:GUID() ~= v14:GUID())) then
						v10.Press(v134, v59);
					end
					break;
				end
			end
		end
	end;
	v30.CanDoTUnit = function(v60, v61)
		return v20.CanDoTUnit(v60, v61);
	end;
	do
		local v62 = v16.Rogue.Assassination;
		local v63 = v16.Rogue.Subtlety;
		local function v64()
			if (((512 + 1384) <= (7061 - 3639)) and v62.Nightstalker:IsAvailable() and v13:StealthUp(true, false, true)) then
				return (327 - (89 + 237)) + ((0.05 - 0) * v62.Nightstalker:TalentRank());
			end
			return 1 - 0;
		end
		local function v65()
			if ((v62.ImprovedGarrote:IsAvailable() and (v13:BuffUp(v62.ImprovedGarroteAura, nil, true) or v13:BuffUp(v62.ImprovedGarroteBuff, nil, true) or v13:BuffUp(v62.SepsisBuff, nil, true))) or ((1871 - (581 + 300)) > (2840 - (855 + 365)))) then
				return 2.5 - 1;
			end
			return 1 + 0;
		end
		v62.Rupture:RegisterPMultiplier(v64, {v63.FinalityRuptureBuff,(1.3 + 0)});
		v62.Garrote:RegisterPMultiplier(v64, v65);
		v62.CrimsonTempest:RegisterPMultiplier(v64);
	end
	do
		local v66 = 286 - (156 + 130);
		local v67;
		local v68;
		local v69;
		while true do
			if ((v66 == (0 - 0)) or ((1477 - 600) > (9615 - 4920))) then
				v67 = v16(50996 + 142535);
				v68 = v16(229940 + 164381);
				v66 = 70 - (10 + 59);
			end
			if (((762 + 1929) >= (9115 - 7264)) and (v66 == (1164 - (671 + 492)))) then
				v69 = v16(313900 + 80420);
				v30.CPMaxSpend = function()
					return (1220 - (369 + 846)) + ((v67:IsAvailable() and (1 + 0)) or (0 + 0)) + ((v68:IsAvailable() and (1946 - (1036 + 909))) or (0 + 0)) + ((v69:IsAvailable() and (1 - 0)) or (203 - (11 + 192)));
				end;
				break;
			end
		end
	end
	v30.CPSpend = function()
		return v22(v13:ComboPoints(), v30.CPMaxSpend());
	end;
	do
		local v70 = 0 + 0;
		while true do
			if ((v70 == (175 - (135 + 40))) or ((7232 - 4247) >= (2928 + 1928))) then
				v30.AnimachargedCP = function()
					local v159 = 0 - 0;
					while true do
						if (((6409 - 2133) >= (1371 - (50 + 126))) and (v159 == (0 - 0))) then
							if (((716 + 2516) <= (6103 - (1233 + 180))) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand2)) then
								return 971 - (522 + 447);
							elseif (v13:BuffUp(v16.Rogue.Commons.EchoingReprimand3) or ((2317 - (107 + 1314)) >= (1460 + 1686))) then
								return 8 - 5;
							elseif (((1301 + 1760) >= (5873 - 2915)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand4)) then
								return 15 - 11;
							elseif (((5097 - (716 + 1194)) >= (11 + 633)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand5)) then
								return 1 + 4;
							end
							return -(504 - (74 + 429));
						end
					end
				end;
				v30.EffectiveComboPoints = function(v160)
					if (((1241 - 597) <= (349 + 355)) and (((v160 == (4 - 2)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand2)) or ((v160 == (3 + 0)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand3)) or ((v160 == (12 - 8)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand4)) or ((v160 == (12 - 7)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand5)))) then
						return 440 - (279 + 154);
					end
					return v160;
				end;
				break;
			end
		end
	end
	do
		local v71 = v16.Rogue.Assassination.DeadlyPoisonDebuff;
		local v72 = v16.Rogue.Assassination.WoundPoisonDebuff;
		local v73 = v16.Rogue.Assassination.AmplifyingPoisonDebuff;
		local v74 = v16.Rogue.Assassination.CripplingPoisonDebuff;
		local v75 = v16.Rogue.Assassination.AtrophicPoisonDebuff;
		v30.Poisoned = function(v113)
			return ((v113:DebuffUp(v71) or v113:DebuffUp(v73) or v113:DebuffUp(v74) or v113:DebuffUp(v72) or v113:DebuffUp(v75)) and true) or false;
		end;
	end
	do
		local v77 = 778 - (454 + 324);
		local v78;
		local v79;
		local v80;
		local v81;
		local v82;
		local v83;
		while true do
			if (((754 + 204) > (964 - (12 + 5))) and (v77 == (1 + 0))) then
				v80 = v16.Rogue.Assassination.Rupture;
				v81 = v16.Rogue.Assassination.RuptureDeathmark;
				v77 = 4 - 2;
			end
			if (((1660 + 2832) >= (3747 - (277 + 816))) and (v77 == (0 - 0))) then
				v78 = v16.Rogue.Assassination.Garrote;
				v79 = v16.Rogue.Assassination.GarroteDeathmark;
				v77 = 1184 - (1058 + 125);
			end
			if (((646 + 2796) >= (2478 - (815 + 160))) and (v77 == (12 - 9))) then
				v30.PoisonedBleeds = function()
					local v161 = 0 - 0;
					while true do
						if ((v161 == (1 + 0)) or ((9266 - 6096) <= (3362 - (41 + 1857)))) then
							return v83;
						end
						if ((v161 == (1893 - (1222 + 671))) or ((12398 - 7601) == (6307 - 1919))) then
							v83 = 1182 - (229 + 953);
							for v211, v212 in v23(v13:GetEnemiesInRange(1824 - (1111 + 663))) do
								if (((2130 - (874 + 705)) <= (96 + 585)) and v30.Poisoned(v212)) then
									local v224 = 0 + 0;
									while true do
										if (((6811 - 3534) > (12 + 395)) and (v224 == (679 - (642 + 37)))) then
											if (((1071 + 3624) >= (227 + 1188)) and v212:DebuffUp(v78)) then
												local v238 = 0 - 0;
												while true do
													if ((v238 == (454 - (233 + 221))) or ((7427 - 4215) <= (831 + 113))) then
														v83 = v83 + (1542 - (718 + 823));
														if (v212:DebuffUp(v79) or ((1949 + 1147) <= (2603 - (266 + 539)))) then
															v83 = v83 + (2 - 1);
														end
														break;
													end
												end
											end
											if (((4762 - (636 + 589)) == (8395 - 4858)) and v212:DebuffUp(v80)) then
												v83 = v83 + (1 - 0);
												if (((3041 + 796) >= (571 + 999)) and v212:DebuffUp(v81)) then
													v83 = v83 + (1016 - (657 + 358));
												end
											end
											v224 = 2 - 1;
										end
										if ((v224 == (2 - 1)) or ((4137 - (1151 + 36)) == (3682 + 130))) then
											if (((1242 + 3481) >= (6922 - 4604)) and v212:DebuffUp(v82)) then
												v83 = v83 + (1833 - (1552 + 280));
											end
											break;
										end
									end
								end
							end
							v161 = 835 - (64 + 770);
						end
					end
				end;
				break;
			end
			if ((v77 == (2 + 0)) or ((4601 - 2574) > (507 + 2345))) then
				v82 = v16.Rogue.Assassination.InternalBleeding;
				v83 = 1243 - (157 + 1086);
				v77 = 5 - 2;
			end
		end
	end
	do
		local v84 = 0 - 0;
		local v85;
		while true do
			if (((2 - 0) == v84) or ((1549 - 413) > (5136 - (599 + 220)))) then
				v10:RegisterForSelfCombatEvent(function(v162, v162, v162, v162, v162, v162, v162, v162, v162, v162, v162, v163)
					if (((9454 - 4706) == (6679 - (1813 + 118))) and (v163 == (230630 + 84878))) then
						v85 = v29();
					end
				end, "SPELL_AURA_REMOVED");
				break;
			end
			if (((4953 - (841 + 376)) <= (6641 - 1901)) and (v84 == (0 + 0))) then
				v85 = v29();
				v30.RtBRemains = function(v164)
					local v165 = 0 - 0;
					local v166;
					while true do
						if (((859 - (464 + 395)) == v165) or ((8700 - 5310) <= (1470 + 1590))) then
							v166 = (v85 - v29()) - v10.RecoveryOffset(v164);
							return ((v166 >= (837 - (467 + 370))) and v166) or (0 - 0);
						end
					end
				end;
				v84 = 1 + 0;
			end
			if (((3 - 2) == v84) or ((156 + 843) > (6265 - 3572))) then
				v10:RegisterForSelfCombatEvent(function(v167, v167, v167, v167, v167, v167, v167, v167, v167, v167, v167, v168)
					if (((983 - (150 + 370)) < (1883 - (74 + 1208))) and (v168 == (776032 - 460524))) then
						v85 = v29() + (142 - 112);
					end
				end, "SPELL_AURA_APPLIED");
				v10:RegisterForSelfCombatEvent(function(v169, v169, v169, v169, v169, v169, v169, v169, v169, v169, v169, v170)
					if ((v170 == (224502 + 91006)) or ((2573 - (14 + 376)) < (1191 - 504))) then
						v85 = v29() + v22(26 + 14, 27 + 3 + v30.RtBRemains(true));
					end
				end, "SPELL_AURA_REFRESH");
				v84 = 2 + 0;
			end
		end
	end
	do
		local v86 = 0 - 0;
		local v87;
		while true do
			if (((3423 + 1126) == (4627 - (23 + 55))) and (v86 == (0 - 0))) then
				v87 = {CrimsonTempest={},Garrote={},Rupture={}};
				v30.Exsanguinated = function(v171, v172)
					local v173 = 0 + 0;
					local v174;
					local v175;
					while true do
						if (((4196 + 476) == (7243 - 2571)) and (v173 == (0 + 0))) then
							v174 = v171:GUID();
							if (not v174 or ((4569 - (652 + 249)) < (1057 - 662))) then
								return false;
							end
							v173 = 1869 - (708 + 1160);
						end
						if ((v173 == (5 - 3)) or ((7595 - 3429) == (482 - (10 + 17)))) then
							return false;
						end
						if (((1 + 0) == v173) or ((6181 - (1400 + 332)) == (5107 - 2444))) then
							v175 = v172:ID();
							if ((v175 == (123319 - (242 + 1666))) or ((1831 + 2446) < (1096 + 1893))) then
								return v87.CrimsonTempest[v174] or false;
							elseif ((v175 == (600 + 103)) or ((1810 - (850 + 90)) >= (7266 - 3117))) then
								return v87.Garrote[v174] or false;
							elseif (((3602 - (360 + 1030)) < (2817 + 366)) and (v175 == (5483 - 3540))) then
								return v87.Rupture[v174] or false;
							end
							v173 = 2 - 0;
						end
					end
				end;
				v86 = 1662 - (909 + 752);
			end
			if (((5869 - (109 + 1114)) > (5477 - 2485)) and (v86 == (1 + 1))) then
				v10:RegisterForSelfCombatEvent(function(v176, v176, v176, v176, v176, v176, v176, v177, v176, v176, v176, v178)
					if (((1676 - (6 + 236)) < (1957 + 1149)) and (v178 == (161634 + 39172))) then
						for v209, v210 in v23(v87) do
							for v213, v214 in v23(v210) do
								if (((1853 - 1067) < (5279 - 2256)) and (v213 == v177)) then
									v210[v213] = true;
								end
							end
						end
					end
				end, "SPELL_CAST_SUCCESS");
				v10:RegisterForSelfCombatEvent(function(v179, v179, v179, v179, v179, v179, v179, v180, v179, v179, v179, v181)
					if ((v181 == (122544 - (1076 + 57))) or ((402 + 2040) < (763 - (579 + 110)))) then
						v87.CrimsonTempest[v180] = false;
					elseif (((359 + 4176) == (4010 + 525)) and (v181 == (374 + 329))) then
						v87.Garrote[v180] = false;
					elseif ((v181 == (2350 - (174 + 233))) or ((8404 - 5395) <= (3694 - 1589))) then
						v87.Rupture[v180] = false;
					end
				end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
				v86 = 2 + 1;
			end
			if (((3004 - (663 + 511)) < (3274 + 395)) and ((1 + 2) == v86)) then
				v10:RegisterForSelfCombatEvent(function(v182, v182, v182, v182, v182, v182, v182, v183, v182, v182, v182, v184)
					if ((v184 == (374309 - 252898)) or ((866 + 564) >= (8503 - 4891))) then
						if (((6494 - 3811) >= (1174 + 1286)) and (v87.CrimsonTempest[v183] ~= nil)) then
							v87.CrimsonTempest[v183] = nil;
						end
					elseif ((v184 == (1367 - 664)) or ((1286 + 518) >= (300 + 2975))) then
						if ((v87.Garrote[v183] ~= nil) or ((2139 - (478 + 244)) > (4146 - (440 + 77)))) then
							v87.Garrote[v183] = nil;
						end
					elseif (((2181 + 2614) > (1471 - 1069)) and (v184 == (3499 - (655 + 901)))) then
						if (((893 + 3920) > (2730 + 835)) and (v87.Rupture[v183] ~= nil)) then
							v87.Rupture[v183] = nil;
						end
					end
				end, "SPELL_AURA_REMOVED");
				v10:RegisterForCombatEvent(function(v185, v185, v185, v185, v185, v185, v185, v186)
					local v187 = 0 + 0;
					while true do
						if (((15759 - 11847) == (5357 - (695 + 750))) and (v187 == (3 - 2))) then
							if (((4353 - 1532) <= (19400 - 14576)) and (v87.Rupture[v186] ~= nil)) then
								v87.Rupture[v186] = nil;
							end
							break;
						end
						if (((2089 - (285 + 66)) <= (5116 - 2921)) and (v187 == (1310 - (682 + 628)))) then
							if (((7 + 34) <= (3317 - (176 + 123))) and (v87.CrimsonTempest[v186] ~= nil)) then
								v87.CrimsonTempest[v186] = nil;
							end
							if (((898 + 1247) <= (2977 + 1127)) and (v87.Garrote[v186] ~= nil)) then
								v87.Garrote[v186] = nil;
							end
							v187 = 270 - (239 + 30);
						end
					end
				end, "UNIT_DIED", "UNIT_DESTROYED");
				break;
			end
			if (((731 + 1958) < (4657 + 188)) and (v86 == (1 - 0))) then
				v30.WillLoseExsanguinate = function(v188, v189)
					if (v30.Exsanguinated(v188, v189) or ((7244 - 4922) > (2937 - (306 + 9)))) then
						return true;
					end
					return false;
				end;
				v30.ExsanguinatedRate = function(v190, v191)
					local v192 = 0 - 0;
					while true do
						if ((v192 == (0 + 0)) or ((2782 + 1752) == (1003 + 1079))) then
							if (v30.Exsanguinated(v190, v191) or ((4492 - 2921) > (3242 - (1140 + 235)))) then
								return 2 + 0;
							end
							return 1 + 0;
						end
					end
				end;
				v86 = 1 + 1;
			end
		end
	end
	do
		local v88 = 52 - (33 + 19);
		local v89;
		local v90;
		local v91;
		while true do
			if ((v88 == (0 + 0)) or ((7954 - 5300) >= (1320 + 1676))) then
				v89 = v16(383642 - 188015);
				v90 = 0 + 0;
				v88 = 690 - (586 + 103);
			end
			if (((363 + 3615) > (6477 - 4373)) and (v88 == (1489 - (1309 + 179)))) then
				v91 = v29();
				v30.FanTheHammerCP = function()
					local v193 = 0 - 0;
					while true do
						if (((1304 + 1691) > (4138 - 2597)) and (v193 == (0 + 0))) then
							if (((6902 - 3653) > (1898 - 945)) and ((v29() - v91) < (609.5 - (295 + 314))) and (v90 > (0 - 0))) then
								if ((v90 > v13:ComboPoints()) or ((5235 - (1300 + 662)) > (14359 - 9786))) then
									return v90;
								else
									v90 = 1755 - (1178 + 577);
								end
							end
							return 0 + 0;
						end
					end
				end;
				v88 = 5 - 3;
			end
			if ((v88 == (1407 - (851 + 554))) or ((2787 + 364) < (3560 - 2276))) then
				v10:RegisterForSelfCombatEvent(function(v194, v194, v194, v194, v194, v194, v194, v194, v194, v194, v194, v195, v194, v194, v196, v197)
					if ((v195 == (403448 - 217685)) or ((2152 - (115 + 187)) == (1171 + 358))) then
						if (((778 + 43) < (8365 - 6242)) and ((v29() - v91) > (1161.5 - (160 + 1001)))) then
							v90 = v22(v30.CPMaxSpend(), v13:ComboPoints() + v196 + (v25(0 + 0, v196 - (1 + 0)) * v22(3 - 1, v13:BuffStack(v89) - (359 - (237 + 121)))));
							v91 = v29();
						end
					end
				end, "SPELL_ENERGIZE");
				break;
			end
		end
	end
	do
		local v92 = 897 - (525 + 372);
		local v93;
		local v94;
		local v95;
		while true do
			if (((1709 - 807) < (7639 - 5314)) and (v92 == (142 - (96 + 46)))) then
				v93, v94 = 777 - (643 + 134), 0 + 0;
				v95 = v16(666404 - 388479);
				v92 = 3 - 2;
			end
			if (((823 + 35) <= (5812 - 2850)) and (v92 == (1 - 0))) then
				v30.TimeToNextTornado = function()
					if (not v13:BuffUp(v95, nil, true) or ((4665 - (316 + 403)) < (857 + 431))) then
						return 0 - 0;
					end
					local v198 = v13:BuffRemains(v95, nil, true) % (1 + 0);
					if ((v29() == v93) or ((8164 - 4922) == (402 + 165))) then
						return 0 + 0;
					elseif ((((v29() - v93) < (0.1 - 0)) and (v198 < (0.25 - 0))) or ((1759 - 912) >= (73 + 1190))) then
						return 1 - 0;
					elseif ((((v198 > (0.9 + 0)) or (v198 == (0 - 0))) and ((v29() - v93) > (17.75 - (12 + 5)))) or ((8750 - 6497) == (3949 - 2098))) then
						return 0.1 - 0;
					end
					return v198;
				end;
				v10:RegisterForSelfCombatEvent(function(v199, v199, v199, v199, v199, v199, v199, v199, v199, v199, v199, v200)
					local v201 = 0 - 0;
					while true do
						if ((v201 == (0 + 0)) or ((4060 - (1656 + 317)) > (2114 + 258))) then
							if ((v200 == (170479 + 42264)) or ((11819 - 7374) < (20419 - 16270))) then
								v93 = v29();
							elseif ((v200 == (198189 - (5 + 349))) or ((8635 - 6817) == (1356 - (266 + 1005)))) then
								v94 = v29();
							end
							if (((416 + 214) < (7257 - 5130)) and (v94 == v93)) then
								v93 = 0 - 0;
							end
							break;
						end
					end
				end, "SPELL_CAST_SUCCESS");
				break;
			end
		end
	end
	do
		local v96 = {Counter=(1696 - (561 + 1135)),LastMH=(0 - 0),LastOH=(0 - 0)};
		v30.TimeToSht = function(v114)
			if ((v96.Counter >= v114) or ((3004 - (507 + 559)) == (6308 - 3794))) then
				return 0 - 0;
			end
			local v115, v116 = v28("player");
			local v117 = v25(v96.LastMH + v115, v29());
			local v118 = v25(v96.LastOH + v116, v29());
			local v119 = {};
			for v137 = 388 - (212 + 176), 907 - (250 + 655) do
				v27(v119, v117 + (v137 * v115));
				v27(v119, v118 + (v137 * v116));
			end
			table.sort(v119);
			local v120 = v22(13 - 8, v25(1 - 0, v114 - v96.Counter));
			return v119[v120] - v29();
		end;
		v10:RegisterForSelfCombatEvent(function()
			v96.Counter = 0 - 0;
			v96.LastMH = v29();
			v96.LastOH = v29();
		end, "PLAYER_ENTERING_WORLD");
		v10:RegisterForSelfCombatEvent(function(v124, v124, v124, v124, v124, v124, v124, v124, v124, v124, v124, v125)
			if (((6211 - (1869 + 87)) >= (190 - 135)) and (v125 == (198812 - (484 + 1417)))) then
				v96.Counter = 0 - 0;
			end
		end, "SPELL_ENERGIZE");
		v10:RegisterForSelfCombatEvent(function(v126, v126, v126, v126, v126, v126, v126, v126, v126, v126, v126, v126, v126, v126, v126, v126, v126, v126, v126, v126, v126, v126, v126, v127)
			local v128 = 0 - 0;
			while true do
				if (((3772 - (48 + 725)) > (1888 - 732)) and (v128 == (0 - 0))) then
					v96.Counter = v96.Counter + 1 + 0;
					if (((6280 - 3930) > (324 + 831)) and v127) then
						v96.LastOH = v29();
					else
						v96.LastMH = v29();
					end
					break;
				end
			end
		end, "SWING_DAMAGE");
		v10:RegisterForSelfCombatEvent(function(v129, v129, v129, v129, v129, v129, v129, v129, v129, v129, v129, v129, v129, v129, v129, v130)
			if (((1175 + 2854) <= (5706 - (152 + 701))) and v130) then
				v96.LastOH = v29();
			else
				v96.LastMH = v29();
			end
		end, "SWING_MISSED");
	end
	do
		local v98 = v13:CritChancePct();
		local v99 = 1311 - (430 + 881);
		local function v100()
			if (not v13:AffectingCombat() or ((198 + 318) > (4329 - (557 + 338)))) then
				v98 = v13:CritChancePct();
				v10.Debug("Base Crit Set to: " .. v98);
			end
			if (((1196 + 2850) >= (8546 - 5513)) and ((v99 == nil) or (v99 < (0 - 0)))) then
				v99 = 0 - 0;
			else
				v99 = v99 - (2 - 1);
			end
			if ((v99 > (801 - (499 + 302))) or ((3585 - (39 + 827)) <= (3994 - 2547))) then
				v24.After(6 - 3, v100);
			end
		end
		v10:RegisterForEvent(function()
			if ((v99 == (0 - 0)) or ((6346 - 2212) < (337 + 3589))) then
				v24.After(8 - 5, v100);
				v99 = 1 + 1;
			end
		end, "PLAYER_EQUIPMENT_CHANGED");
		v30.BaseAttackCrit = function()
			return v98;
		end;
	end
	do
		local v102 = v16.Rogue.Assassination;
		local v103 = v16.Rogue.Subtlety;
		local function v104()
			local v131 = 0 - 0;
			while true do
				if (((104 - (103 + 1)) == v131) or ((718 - (475 + 79)) >= (6020 - 3235))) then
					if ((v102.Nightstalker:IsAvailable() and v13:StealthUp(true, false, true)) or ((1680 - 1155) == (273 + 1836))) then
						return 1 + 0 + ((1503.05 - (1395 + 108)) * v102.Nightstalker:TalentRank());
					end
					return 2 - 1;
				end
			end
		end
		local function v105()
			if (((1237 - (7 + 1197)) == (15 + 18)) and v102.ImprovedGarrote:IsAvailable() and (v13:BuffUp(v102.ImprovedGarroteAura, nil, true) or v13:BuffUp(v102.ImprovedGarroteBuff, nil, true) or v13:BuffUp(v102.SepsisBuff, nil, true))) then
				return 1.5 + 0;
			end
			return 320 - (27 + 292);
		end
		v102.Rupture:RegisterPMultiplier(v104, {v103.FinalityRuptureBuff,(4.3 - 3)});
		v102.Garrote:RegisterPMultiplier(v104, v105);
	end
end;
return v0["Epix_Rogue_Rogue.lua"]();

