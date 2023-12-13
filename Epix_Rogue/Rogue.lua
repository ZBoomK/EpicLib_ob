local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (1908 - (957 + 950))) or ((1582 + 626) > (10558 - 7006))) then
			return v6(...);
		end
		if ((v5 == (1205 - (902 + 303))) or ((5262 - 2865) == (6796 - 3974))) then
			v6 = v0[v4];
			if (not v6 or ((365 + 3880) == (6321 - (1121 + 569)))) then
				return v1(v4, ...);
			end
			v5 = 215 - (22 + 192);
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
	if (((4959 - (483 + 200)) >= (5377 - (1404 + 59))) and not v16.Rogue) then
		v16.Rogue = {};
	end
	v16.Rogue.Commons = {Sanguine=v16(619898 - 393388, nil, 1 - 0),AncestralCall=v16(275503 - (468 + 297), nil, 564 - (334 + 228)),ArcanePulse=v16(878204 - 617840, nil, 6 - 3),ArcaneTorrent=v16(45424 - 20378, nil, 2 + 2),BagofTricks=v16(312647 - (141 + 95), nil, 5 + 0),Berserking=v16(67688 - 41391, nil, 14 - 8),BloodFury=v16(4819 + 15753, nil, 19 - 12),Fireblood=v16(186448 + 78773, nil, 5 + 3),LightsJudgment=v16(360012 - 104365, nil, 6 + 3),Shadowmeld=v16(59147 - (92 + 71), nil, 5 + 5),CloakofShadows=v16(52496 - 21272, nil, 776 - (574 + 191)),CrimsonVial=v16(152857 + 32454, nil, 29 - 17),Evasion=v16(2696 + 2581, nil, 862 - (254 + 595)),Feint=v16(2092 - (55 + 71), nil, 18 - 4),Blind=v16(3884 - (573 + 1217), nil, 41 - 26),CheapShot=v16(140 + 1693, nil, 25 - 9),Kick=v16(2705 - (714 + 225), nil, 49 - 32),KidneyShot=v16(568 - 160, nil, 2 + 16),Sap=v16(9802 - 3032, nil, 825 - (118 + 688)),Shiv=v16(5986 - (25 + 23), nil, 4 + 16),SliceandDice=v16(317382 - (927 + 959), nil, 70 - 49),Shadowstep=v16(37286 - (16 + 716), nil, 41 - 19),Sprint=v16(3080 - (11 + 86), nil, 55 - 32),TricksoftheTrade=v16(58219 - (175 + 110), nil, 60 - 36),CripplingPoison=v16(16809 - 13401, nil, 1821 - (503 + 1293)),DeadlyPoison=v16(7884 - 5061, nil, 19 + 7),InstantPoison=v16(316645 - (810 + 251), nil, 19 + 8),AmplifyingPoison=v16(117134 + 264530, nil, 26 + 2),NumbingPoison=v16(6294 - (43 + 490), nil, 762 - (711 + 22)),WoundPoison=v16(33571 - 24892, nil, 889 - (240 + 619)),AtrophicPoison=v16(92094 + 289543, nil, 48 - 17),AcrobaticStrikes=v16(13033 + 183891, nil, 1776 - (1344 + 400)),Alacrity=v16(193944 - (255 + 150), nil, 26 + 7),ColdBlood=v16(204645 + 177600, nil, 145 - 111),DeeperStratagem=v16(625089 - 431558),EchoingReprimand=v16(387355 - (404 + 1335), nil, 442 - (183 + 223)),EchoingReprimand2=v16(393725 - 70167, nil, 25 + 12),EchoingReprimand3=v16(116442 + 207117, nil, 375 - (10 + 327)),EchoingReprimand4=v16(225324 + 98236, nil, 377 - (118 + 220)),EchoingReprimand5=v16(118252 + 236586, nil, 489 - (108 + 341)),FindWeakness=v16(40882 + 50141, nil, 173 - 132),FindWeaknessDebuff=v16(317713 - (711 + 782), nil, 79 - 37),ImprovedAmbush=v16(382089 - (270 + 199), nil, 14 + 29),MarkedforDeath=v16(139438 - (580 + 1239), nil, 130 - 86),Nightstalker=v16(13446 + 616, nil, 2 + 43),ResoundingClarity=v16(166244 + 215378, nil, 119 - 73),SealFate=v16(8816 + 5374, nil, 1214 - (645 + 522)),Sepsis=v16(387198 - (1010 + 780), nil, 48 + 0),SepsisBuff=v16(1790939 - 1415000, nil, 143 - 94),ShadowDance=v16(187149 - (1045 + 791), nil, 126 - 76),ShadowDanceTalent=v16(603037 - 208107, nil, 556 - (351 + 154)),ShadowDanceBuff=v16(186996 - (1281 + 293)),Subterfuge=v16(108474 - (28 + 238), nil, 117 - 64),SubterfugeBuff=v16(116751 - (1381 + 178), nil, 51 + 3),ThistleTea=v16(307718 + 73905, nil, 137 + 183),Vigor=v16(51652 - 36669),Stealth=v16(925 + 859, nil, 527 - (381 + 89)),Stealth2=v16(102151 + 13040, nil, 40 + 18),Vanish=v16(3178 - 1322, nil, 1215 - (1074 + 82)),VanishBuff=v16(24822 - 13495, nil, 1844 - (214 + 1570)),VanishBuff2=v16(116648 - (990 + 465), nil, 26 + 35),PoolEnergy=v16(435083 + 564827, nil, 61 + 1)};
	v16.Rogue.Assassination = v19(v16.Rogue.Commons, {Ambush=v16(34144 - 25468, nil, 1789 - (1668 + 58)),AmbushOverride=v16(430649 - (512 + 114)),AmplifyingPoisonDebuff=v16(999616 - 616202, nil, 132 - 68),AmplifyingPoisonDebuffDeathmark=v16(1372126 - 977798, nil, 31 + 34),CripplingPoisonDebuff=v16(639 + 2770, nil, 58 + 8),DeadlyPoisonDebuff=v16(9504 - 6686, nil, 2061 - (109 + 1885)),DeadlyPoisonDebuffDeathmark=v16(395793 - (1269 + 200), nil, 129 - 61),Envenom=v16(33460 - (98 + 717), nil, 895 - (802 + 24)),FanofKnives=v16(89197 - 37474, nil, 88 - 18),Garrote=v16(104 + 599, nil, 55 + 16),GarroteDeathmark=v16(59268 + 301562, nil, 16 + 56),Mutilate=v16(3697 - 2368, nil, 243 - 170),PoisonedKnife=v16(66371 + 119194, nil, 31 + 43),Rupture=v16(1603 + 340, nil, 55 + 20),RuptureDeathmark=v16(168465 + 192361, nil, 1509 - (797 + 636)),WoundPoisonDebuff=v16(42144 - 33464, nil, 1696 - (1427 + 192)),ArterialPrecision=v16(138868 + 261915, nil, 180 - 102),AtrophicPoisonDebuff=v16(352704 + 39684, nil, 36 + 43),BlindsideBuff=v16(121479 - (192 + 134), nil, 1356 - (316 + 960)),CausticSpatter=v16(234828 + 187147),CausticSpatterDebuff=v16(325646 + 96330),CrimsonTempest=v16(112222 + 9189, nil, 309 - 228),CutToTheChase=v16(52218 - (83 + 468), nil, 1888 - (1202 + 604)),DashingScoundrel=v16(1782302 - 1400505, nil, 137 - 54),Deathmark=v16(997283 - 637089, nil, 409 - (45 + 280)),Doomblade=v16(368389 + 13284, nil, 75 + 10),DragonTemperedBlades=v16(139411 + 242390, nil, 48 + 38),Elusiveness=v16(13897 + 65111),Exsanguinate=v16(371847 - 171041, nil, 1999 - (340 + 1571)),ImprovedGarrote=v16(150525 + 231107, nil, 1861 - (1733 + 39)),ImprovedGarroteBuff=v16(1078277 - 685876, nil, 1124 - (125 + 909)),ImprovedGarroteAura=v16(394351 - (1096 + 852), nil, 41 + 50),IndiscriminateCarnage=v16(545253 - 163451, nil, 90 + 2),IndiscriminateCarnageAura=v16(386266 - (409 + 103)),IndiscriminateCarnageBuff=v16(385983 - (46 + 190)),InternalBleeding=v16(155048 - (51 + 44), nil, 27 + 66),Kingsbane=v16(386944 - (1114 + 203), nil, 820 - (228 + 498)),LightweightShiv=v16(85575 + 309408),MasterAssassin=v16(141424 + 114565, nil, 758 - (174 + 489)),MasterAssassinBuff=v16(668870 - 412135, nil, 2001 - (830 + 1075)),PreyontheWeak=v16(132035 - (303 + 221), nil, 1366 - (231 + 1038)),PreyontheWeakDebuff=v16(213252 + 42657, nil, 1260 - (171 + 991)),SerratedBoneSpike=v16(1588411 - 1202987, nil, 265 - 166),SerratedBoneSpikeDebuff=v16(983299 - 589263, nil, 81 + 19),ShivDebuff=v16(1119975 - 800471, nil, 291 - 190),VenomRush=v16(245263 - 93111, nil, 315 - 213),ScentOfBlood=v16(383047 - (111 + 1137), nil, 554 - (91 + 67)),ScentOfBloodBuff=v16(1172880 - 778800),ShroudedSuffocation=v16(96179 + 289299)});
	v16.Rogue.Outlaw = v19(v16.Rogue.Commons, {AdrenalineRush=v16(14273 - (423 + 100), nil, 1 + 102),Ambush=v16(24022 - 15346, nil, 55 + 49),AmbushOverride=v16(430794 - (326 + 445)),BetweentheEyes=v16(1376139 - 1060798, nil, 233 - 128),BladeFlurry=v16(32391 - 18514, nil, 817 - (530 + 181)),Dispatch=v16(2979 - (614 + 267), nil, 139 - (19 + 13)),Elusiveness=v16(128594 - 49586),Opportunity=v16(455877 - 260250),PistolShot=v16(530651 - 344888, nil, 29 + 81),RolltheBones=v16(554876 - 239368, nil, 229 - 118),SinisterStrike=v16(195127 - (1293 + 519), nil, 227 - 115),Audacity=v16(996978 - 615133, nil, 215 - 102),AudacityBuff=v16(1665638 - 1279368, nil, 268 - 154),BladeRush=v16(143998 + 127879, nil, 24 + 91),CountTheOdds=v16(887541 - 505559, nil, 27 + 89),Dreadblades=v16(113995 + 229147, nil, 74 + 43),FanTheHammer=v16(382942 - (709 + 387), nil, 1976 - (673 + 1185)),GhostlyStrike=v16(571145 - 374208, nil, 381 - 262),GreenskinsWickers=v16(636455 - 249632, nil, 86 + 34),GreenskinsWickersBuff=v16(294495 + 99636, nil, 163 - 42),HiddenOpportunity=v16(94135 + 289146, nil, 242 - 120),ImprovedAdrenalineRush=v16(776224 - 380802, nil, 2003 - (446 + 1434)),ImprovedBetweenTheEyes=v16(236767 - (1040 + 243), nil, 370 - 246),KeepItRolling=v16(383836 - (559 + 1288), nil, 2056 - (609 + 1322)),KillingSpree=v16(52144 - (13 + 441), nil, 470 - 344),LoadedDice=v16(671002 - 414832, nil, 632 - 505),LoadedDiceBuff=v16(9539 + 246632, nil, 464 - 336),PreyontheWeak=v16(46710 + 84801, nil, 57 + 72),PreyontheWeakDebuff=v16(759417 - 503508, nil, 72 + 58),QuickDraw=v16(362209 - 165271, nil, 87 + 44),SummarilyDispatched=v16(212456 + 169534, nil, 95 + 37),SwiftSlasher=v16(320738 + 61250, nil, 131 + 2),TakeEmBySurpriseBuff=v16(386340 - (153 + 280), nil, 386 - 252),Weaponmaster=v16(180218 + 20515, nil, 54 + 81),UnderhandedUpperhand=v16(221910 + 202134),DeftManeuvers=v16(346547 + 35331),Crackshot=v16(307016 + 116687),Gouge=v16(2703 - 927, nil, 85 + 51),Broadside=v16(194023 - (89 + 578), nil, 98 + 39),BuriedTreasure=v16(414964 - 215364, nil, 1187 - (572 + 477)),GrandMelee=v16(26078 + 167280, nil, 84 + 55),RuthlessPrecision=v16(23080 + 170277, nil, 226 - (84 + 2)),SkullandCrossbones=v16(328959 - 129356, nil, 102 + 39),TrueBearing=v16(194201 - (497 + 345), nil, 4 + 138),ViciousFollowup=v16(66752 + 328127, nil, 1476 - (605 + 728))});
	v16.Rogue.Subtlety = v19(v16.Rogue.Commons, {Backstab=v16(38 + 15, nil, 319 - 175),BlackPowder=v16(14628 + 304547, nil, 536 - 391),Elusiveness=v16(71226 + 7782),Eviscerate=v16(545313 - 348494, nil, 111 + 36),Rupture=v16(2432 - (457 + 32), nil, 63 + 85),ShadowBlades=v16(122873 - (832 + 570), nil, 141 + 8),Shadowstrike=v16(48358 + 137080, nil, 530 - 380),ShurikenStorm=v16(95298 + 102537, nil, 947 - (588 + 208)),ShurikenToss=v16(307293 - 193279, nil, 1952 - (884 + 916)),SymbolsofDeath=v16(444431 - 232148, nil, 89 + 64),DanseMacabre=v16(383181 - (232 + 421), nil, 2043 - (1569 + 320)),DanseMacabreBuff=v16(96658 + 297311, nil, 30 + 125),DeeperDaggers=v16(1289011 - 906494, nil, 761 - (316 + 289)),DeeperDaggersBuff=v16(1003647 - 620242, nil, 8 + 149),DarkBrew=v16(383957 - (666 + 787), nil, 583 - (360 + 65)),DarkShadow=v16(229611 + 16076, nil, 413 - (79 + 175)),EnvelopingShadows=v16(375450 - 137346, nil, 125 + 35),Finality=v16(1172545 - 790020, nil, 309 - 148),FinalityBlackPowderBuff=v16(386847 - (503 + 396), nil, 343 - (92 + 89)),FinalityEviscerateBuff=v16(748724 - 362775, nil, 84 + 79),FinalityRuptureBuff=v16(228424 + 157527, nil, 642 - 478),Flagellation=v16(52599 + 332032, nil, 376 - 211),FlagellationPersistBuff=v16(344423 + 50335, nil, 80 + 86),Gloomblade=v16(611442 - 410684, nil, 21 + 146),GoremawsBite=v16(650557 - 223966, nil, 1433 - (485 + 759)),ImprovedShadowDance=v16(911605 - 517633, nil, 1357 - (442 + 747)),ImprovedShurikenStorm=v16(321086 - (832 + 303), nil, 1115 - (88 + 858)),InvigoratingShadowdust=v16(116586 + 265937),LingeringShadow=v16(316577 + 65947, nil, 8 + 162),LingeringShadowBuff=v16(386749 - (766 + 23), nil, 844 - 673),MasterofShadows=v16(269395 - 72419, nil, 452 - 280),PerforatedVeins=v16(1298279 - 915761, nil, 1246 - (1036 + 37)),PerforatedVeinsBuff=v16(279517 + 114737, nil, 338 - 164),PreyontheWeak=v16(103451 + 28060, nil, 1655 - (641 + 839)),PreyontheWeakDebuff=v16(256822 - (910 + 3), nil, 448 - 272),Premeditation=v16(344844 - (1466 + 218), nil, 82 + 95),PremeditationBuff=v16(344321 - (556 + 592), nil, 64 + 114),SecretStratagem=v16(395128 - (329 + 479), nil, 1033 - (174 + 680)),SecretTechnique=v16(964599 - 683880, nil, 373 - 193),Shadowcraft=v16(304575 + 122019),ShadowFocus=v16(108948 - (396 + 343), nil, 17 + 164),ShurikenTornado=v16(279402 - (29 + 1448), nil, 1571 - (135 + 1254)),SilentStorm=v16(1453101 - 1067379, nil, 854 - 671),SilentStormBuff=v16(257060 + 128662, nil, 1711 - (389 + 1138)),TheFirstDance=v16(383079 - (102 + 472), nil, 175 + 10),TheRotten=v16(211840 + 170175, nil, 174 + 12),TheRottenBuff=v16(395748 - (320 + 1225), nil, 332 - 145),Weaponmaster=v16(118419 + 75118, nil, 1652 - (157 + 1307))});
	if (((2057 - (821 + 1038)) <= (10890 - 6525)) and not v18.Rogue) then
		v18.Rogue = {};
	end
	v18.Rogue.Commons = {AlgetharPuzzleBox=v18(21184 + 172517, {(5 + 8),(1040 - (834 + 192))}),ManicGrieftorch=v18(12354 + 181954, {(1 + 12),(318 - (300 + 4))}),WindscarWhetstone=v18(36719 + 100767, {(375 - (112 + 250)),(34 - 20)}),Healthstone=v18(3158 + 2354),RefreshingHealingPotion=v18(98975 + 92405)};
	v18.Rogue.Assassination = v19(v18.Rogue.Commons, {AlgetharPuzzleBox=v18(144867 + 48834, {(10 + 3),(30 - 16)}),AshesoftheEmbersoul=v18(208049 - (244 + 638), {(38 - 25),(1920 - (1665 + 241))}),WitherbarksBranch=v18(110716 - (373 + 344), {(4 + 9),(23 - 9)})});
	v18.Rogue.Outlaw = v19(v18.Rogue.Commons, {ManicGrieftorch=v18(195407 - (35 + 1064), {(27 - 14),(1250 - (298 + 938))}),WindscarWhetstone=v18(138745 - (233 + 1026), {(7 + 6),(5 + 9)}),BeaconToTheBeyond=v18(13781 + 190182, {(3 + 10),(53 - 39)}),DragonfireBombDispenser=v18(202907 - (36 + 261), {(1381 - (34 + 1334)),(11 + 3)})});
	v18.Rogue.Subtlety = v19(v18.Rogue.Commons, {ManicGrieftorch=v18(195591 - (1035 + 248), {(7 + 6),(1147 - (549 + 584))}),StormEatersBoon=v18(194987 - (314 + 371), {(981 - (478 + 490)),(1186 - (786 + 386))}),BeaconToTheBeyond=v18(660635 - 456672, {(1353 - (1093 + 247)),(2 + 12)}),AshesoftheEmbersoul=v18(822489 - 615322, {(36 - 23),(5 + 9)}),WitherbarksBranch=v18(423765 - 313766, {(10 + 3),(702 - (364 + 324))}),BandolierOfTwistedBlades=v18(567913 - 360748, {(5 + 8),(21 - 7)}),Mirror=v18(630448 - 422867, {(12 + 1),(1100 - (686 + 400))})});
	if (((3752 + 1030) > (4905 - (73 + 156))) and not v21.Rogue) then
		v21.Rogue = {};
	end
	v21.Rogue.Commons = {Healthstone=v21(1 + 20),BlindMouseover=v21(820 - (721 + 90)),CheapShotMouseover=v21(1 + 9),KickMouseover=v21(35 - 24),KidneyShotMouseover=v21(482 - (224 + 246)),TricksoftheTradeFocus=v21(20 - 7),WindscarWhetstone=v21(47 - 21)};
	v21.Rogue.Outlaw = v19(v21.Rogue.Commons, {Dispatch=v21(3 + 11),PistolShotMouseover=v21(1 + 14),SinisterStrikeMouseover=v21(20 + 7)});
	v21.Rogue.Assassination = v19(v21.Rogue.Commons, {GarroteMouseOver=v21(55 - 27)});
	v21.Rogue.Subtlety = v19(v21.Rogue.Commons, {SecretTechnique=v21(53 - 37),ShadowDance=v21(530 - (203 + 310)),ShadowDanceSymbol=v21(2019 - (1238 + 755)),VanishShadowstrike=v21(2 + 16),ShurikenStormSD=v21(1553 - (709 + 825)),ShurikenStormVanish=v21(36 - 16),GloombladeSD=v21(31 - 9),GloombladeVanish=v21(887 - (196 + 668)),BackstabMouseover=v21(94 - 70),RuptureMouseover=v21(51 - 26)});
	v30.StealthSpell = function()
		return (v16.Rogue.Commons.Subterfuge:IsAvailable() and v16.Rogue.Commons.Stealth2) or v16.Rogue.Commons.Stealth;
	end;
	v30.VanishBuffSpell = function()
		return (v16.Rogue.Commons.Subterfuge:IsAvailable() and v16.Rogue.Commons.VanishBuff2) or v16.Rogue.Commons.VanishBuff;
	end;
	v30.Stealth = function(v50, v51)
		local v52 = 833 - (171 + 662);
		while true do
			if (((4957 - (4 + 89)) > (7700 - 5503)) and (v52 == (0 + 0))) then
				if ((EpicSettings.Settings['StealthOOC'] and (v16.Rogue.Commons.Stealth:IsCastable() or v16.Rogue.Commons.Stealth2:IsCastable()) and v13:StealthDown()) or ((16251 - 12551) == (984 + 1523))) then
					if (((5960 - (35 + 1451)) >= (1727 - (28 + 1425))) and v10.Press(v50, nil)) then
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
			local v117 = EpicSettings.Settings['CrimsonVialHP'] or (1993 - (941 + 1052));
			if ((v54:IsCastable() and v54:IsReady() and (v13:HealthPercentage() <= v117)) or ((1817 + 77) <= (2920 - (822 + 692)))) then
				if (((2243 - 671) >= (722 + 809)) and v10.Cast(v54, nil)) then
					return "Cast Crimson Vial (Defensives)";
				end
			end
			return false;
		end;
	end
	do
		local v56 = v16.Rogue.Commons;
		local v57 = v56.Feint;
		v30.Feint = function()
			local v118 = 297 - (45 + 252);
			local v119;
			while true do
				if ((v118 == (0 + 0)) or ((1614 + 3073) < (11053 - 6511))) then
					v119 = EpicSettings.Settings['FeintHP'] or (433 - (114 + 319));
					if (((4724 - 1433) > (2135 - 468)) and v57:IsCastable() and v13:BuffDown(v57) and (v13:HealthPercentage() <= v119)) then
						if (v10.Cast(v57, nil) or ((557 + 316) == (3029 - 995))) then
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
			if ((v59 == (1964 - (556 + 1407))) or ((4022 - (741 + 465)) < (476 - (170 + 295)))) then
				v62 = nil;
				function v62(v199)
					if (((1949 + 1750) < (4323 + 383)) and not v13:AffectingCombat() and v13:BuffRefreshable(v199)) then
						if (((6514 - 3868) >= (727 + 149)) and v10.Press(v199, nil, true)) then
							return "poison";
						end
					end
				end
				v59 = 2 + 0;
			end
			if (((348 + 266) <= (4414 - (957 + 273))) and (v59 == (1 + 1))) then
				v30.Poisons = function()
					v61 = v13:BuffUp(v16.Rogue.Commons.WoundPoison);
					if (((1252 + 1874) == (11911 - 8785)) and v16.Rogue.Assassination.DragonTemperedBlades:IsAvailable()) then
						local v223 = v62((v61 and v16.Rogue.Commons.WoundPoison) or v16.Rogue.Commons.DeadlyPoison);
						if (v223 or ((5763 - 3576) >= (15131 - 10177))) then
							return v223;
						end
						if (v16.Rogue.Commons.AmplifyingPoison:IsAvailable() or ((19197 - 15320) == (5355 - (389 + 1391)))) then
							v223 = v62(v16.Rogue.Commons.AmplifyingPoison);
							if (((444 + 263) > (66 + 566)) and v223) then
								return v223;
							end
						else
							local v234 = 0 - 0;
							while true do
								if ((v234 == (951 - (783 + 168))) or ((1832 - 1286) >= (2641 + 43))) then
									v223 = v62(v16.Rogue.Commons.InstantPoison);
									if (((1776 - (309 + 2)) <= (13207 - 8906)) and v223) then
										return v223;
									end
									break;
								end
							end
						end
					elseif (((2916 - (1090 + 122)) > (462 + 963)) and v61) then
						local v235 = 0 - 0;
						local v236;
						while true do
							if ((v235 == (0 + 0)) or ((1805 - (628 + 490)) == (760 + 3474))) then
								v236 = v62(v16.Rogue.Commons.WoundPoison);
								if (v236 or ((8244 - 4914) < (6530 - 5101))) then
									return v236;
								end
								break;
							end
						end
					elseif (((1921 - (431 + 343)) >= (676 - 341)) and v16.Rogue.Commons.AmplifyingPoison:IsAvailable() and v13:BuffDown(v16.Rogue.Commons.DeadlyPoison)) then
						local v243 = 0 - 0;
						local v244;
						while true do
							if (((2714 + 721) > (269 + 1828)) and (v243 == (1695 - (556 + 1139)))) then
								v244 = v62(v16.Rogue.Commons.AmplifyingPoison);
								if (v244 or ((3785 - (6 + 9)) >= (740 + 3301))) then
									return v244;
								end
								break;
							end
						end
					elseif (v16.Rogue.Commons.DeadlyPoison:IsAvailable() or ((1943 + 1848) <= (1780 - (28 + 141)))) then
						local v250 = 0 + 0;
						local v251;
						while true do
							if ((v250 == (0 - 0)) or ((3243 + 1335) <= (3325 - (486 + 831)))) then
								v251 = v62(v16.Rogue.Commons.DeadlyPoison);
								if (((2927 - 1802) <= (7308 - 5232)) and v251) then
									return v251;
								end
								break;
							end
						end
					else
						local v252 = v62(v16.Rogue.Commons.InstantPoison);
						if (v252 or ((141 + 602) >= (13909 - 9510))) then
							return v252;
						end
					end
					if (((2418 - (668 + 595)) < (1506 + 167)) and v13:BuffDown(v16.Rogue.Commons.CripplingPoison)) then
						if (v16.Rogue.Commons.AtrophicPoison:IsAvailable() or ((469 + 1855) <= (1576 - 998))) then
							local v237 = 290 - (23 + 267);
							local v238;
							while true do
								if (((5711 - (1129 + 815)) == (4154 - (371 + 16))) and ((1750 - (1326 + 424)) == v237)) then
									v238 = v62(v16.Rogue.Commons.AtrophicPoison);
									if (((7744 - 3655) == (14942 - 10853)) and v238) then
										return v238;
									end
									break;
								end
							end
						elseif (((4576 - (88 + 30)) >= (2445 - (720 + 51))) and v16.Rogue.Commons.NumbingPoison:IsAvailable()) then
							local v245 = 0 - 0;
							local v246;
							while true do
								if (((2748 - (421 + 1355)) <= (2339 - 921)) and (v245 == (0 + 0))) then
									v246 = v62(v16.Rogue.Commons.NumbingPoison);
									if (v246 or ((6021 - (286 + 797)) < (17408 - 12646))) then
										return v246;
									end
									break;
								end
							end
						else
							local v247 = 0 - 0;
							local v248;
							while true do
								if (((439 - (397 + 42)) == v247) or ((783 + 1721) > (5064 - (24 + 776)))) then
									v248 = v62(v16.Rogue.Commons.CripplingPoison);
									if (((3316 - 1163) == (2938 - (222 + 563))) and v248) then
										return v248;
									end
									break;
								end
							end
						end
					else
						local v224 = 0 - 0;
						local v225;
						while true do
							if (((0 + 0) == v224) or ((697 - (23 + 167)) >= (4389 - (690 + 1108)))) then
								v225 = v62(v16.Rogue.Commons.CripplingPoison);
								if (((1617 + 2864) == (3697 + 784)) and v225) then
									return v225;
								end
								break;
							end
						end
					end
				end;
				break;
			end
			if ((v59 == (848 - (40 + 808))) or ((384 + 1944) < (2649 - 1956))) then
				v60 = 0 + 0;
				v61 = false;
				v59 = 1 + 0;
			end
		end
	end
	v30.MfDSniping = function(v63)
		if (((2374 + 1954) == (4899 - (47 + 524))) and v63:IsCastable()) then
			local v172, v173 = nil, 39 + 21;
			local v174 = (v15:IsInRange(82 - 52) and v15:TimeToDie()) or (16613 - 5502);
			for v178, v179 in v23(v13:GetEnemiesInRange(68 - 38)) do
				local v180 = v179:TimeToDie();
				if (((3314 - (1165 + 561)) >= (40 + 1292)) and not v179:IsMfDBlacklisted() and (v180 < (v13:ComboPointsDeficit() * (3.5 - 2))) and (v180 < v173)) then
					if (((v174 - v180) > (1 + 0)) or ((4653 - (341 + 138)) > (1147 + 3101))) then
						v172, v173 = v179, v180;
					else
						v172, v173 = v15, v174;
					end
				end
			end
			if ((v172 and (v172:GUID() ~= v14:GUID())) or ((9464 - 4878) <= (408 - (89 + 237)))) then
				v10.Press(v172, v63);
			end
		end
	end;
	v30.CanDoTUnit = function(v64, v65)
		return v20.CanDoTUnit(v64, v65);
	end;
	do
		local v66 = 0 - 0;
		local v67;
		local v68;
		local v69;
		local v70;
		while true do
			if (((8132 - 4269) == (4744 - (581 + 300))) and (v66 == (1221 - (855 + 365)))) then
				v69 = nil;
				function v69()
					local v200 = 0 - 0;
					while true do
						if ((v200 == (0 + 0)) or ((1517 - (1030 + 205)) <= (40 + 2))) then
							if (((4288 + 321) >= (1052 - (156 + 130))) and v67.Nightstalker:IsAvailable() and v13:StealthUp(true, false, true)) then
								return (2 - 1) + ((0.05 - 0) * v67.Nightstalker:TalentRank());
							end
							return 1 - 0;
						end
					end
				end
				v66 = 1 + 1;
			end
			if ((v66 == (3 + 1)) or ((1221 - (10 + 59)) == (704 + 1784))) then
				v67.CrimsonTempest:RegisterPMultiplier(v69);
				break;
			end
			if (((16852 - 13430) > (4513 - (671 + 492))) and (v66 == (3 + 0))) then
				v67.Rupture:RegisterPMultiplier(v69, {v68.FinalityRuptureBuff,(1.3 + 0)});
				v67.Garrote:RegisterPMultiplier(v69, v70);
				v66 = 1949 - (1036 + 909);
			end
			if (((698 + 179) > (630 - 254)) and (v66 == (205 - (11 + 192)))) then
				v70 = nil;
				function v70()
					local v201 = 0 + 0;
					while true do
						if ((v201 == (175 - (135 + 40))) or ((7554 - 4436) <= (1116 + 735))) then
							if ((v67.ImprovedGarrote:IsAvailable() and (v13:BuffUp(v67.ImprovedGarroteAura, nil, true) or v13:BuffUp(v67.ImprovedGarroteBuff, nil, true) or v13:BuffUp(v67.SepsisBuff, nil, true))) or ((363 - 198) >= (5234 - 1742))) then
								return 177.5 - (50 + 126);
							end
							return 2 - 1;
						end
					end
				end
				v66 = 1 + 2;
			end
			if (((5362 - (1233 + 180)) < (5825 - (522 + 447))) and (v66 == (1421 - (107 + 1314)))) then
				v67 = v16.Rogue.Assassination;
				v68 = v16.Rogue.Subtlety;
				v66 = 1 + 0;
			end
		end
	end
	do
		local v71 = v16(589713 - 396182);
		local v72 = v16(167480 + 226841);
		local v73 = v16(783046 - 388726);
		v30.CPMaxSpend = function()
			return (19 - 14) + ((v71:IsAvailable() and (1911 - (716 + 1194))) or (0 + 0)) + ((v72:IsAvailable() and (1 + 0)) or (503 - (74 + 429))) + ((v73:IsAvailable() and (1 - 0)) or (0 + 0));
		end;
	end
	v30.CPSpend = function()
		return v22(v13:ComboPoints(), v30.CPMaxSpend());
	end;
	do
		local v75 = 0 - 0;
		while true do
			if ((v75 == (0 + 0)) or ((13182 - 8906) < (7457 - 4441))) then
				v30.AnimachargedCP = function()
					if (((5123 - (279 + 154)) > (4903 - (454 + 324))) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand2)) then
						return 2 + 0;
					elseif (v13:BuffUp(v16.Rogue.Commons.EchoingReprimand3) or ((67 - (12 + 5)) >= (484 + 412))) then
						return 7 - 4;
					elseif (v13:BuffUp(v16.Rogue.Commons.EchoingReprimand4) or ((634 + 1080) >= (4051 - (277 + 816)))) then
						return 17 - 13;
					elseif (v13:BuffUp(v16.Rogue.Commons.EchoingReprimand5) or ((2674 - (1058 + 125)) < (121 + 523))) then
						return 980 - (815 + 160);
					end
					return -(4 - 3);
				end;
				v30.EffectiveComboPoints = function(v202)
					local v203 = 0 - 0;
					while true do
						if (((168 + 536) < (2885 - 1898)) and (v203 == (1898 - (41 + 1857)))) then
							if (((5611 - (1222 + 671)) > (4926 - 3020)) and (((v202 == (2 - 0)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand2)) or ((v202 == (1185 - (229 + 953))) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand3)) or ((v202 == (1778 - (1111 + 663))) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand4)) or ((v202 == (1584 - (874 + 705))) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand5)))) then
								return 1 + 6;
							end
							return v202;
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
		v30.Poisoned = function(v120)
			return ((v120:DebuffUp(v76) or v120:DebuffUp(v78) or v120:DebuffUp(v79) or v120:DebuffUp(v77) or v120:DebuffUp(v80)) and true) or false;
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
			if ((v82 == (3 - 1)) or ((27 + 931) > (4314 - (642 + 37)))) then
				v87 = v16.Rogue.Assassination.InternalBleeding;
				v88 = 0 + 0;
				v82 = 1 + 2;
			end
			if (((8790 - 5289) <= (4946 - (233 + 221))) and ((2 - 1) == v82)) then
				v85 = v16.Rogue.Assassination.Rupture;
				v86 = v16.Rogue.Assassination.RuptureDeathmark;
				v82 = 2 + 0;
			end
			if ((v82 == (1541 - (718 + 823))) or ((2166 + 1276) < (3353 - (266 + 539)))) then
				v83 = v16.Rogue.Assassination.Garrote;
				v84 = v16.Rogue.Assassination.GarroteDeathmark;
				v82 = 2 - 1;
			end
			if (((4100 - (636 + 589)) >= (3474 - 2010)) and (v82 == (5 - 2))) then
				v30.PoisonedBleeds = function()
					local v204 = 0 + 0;
					while true do
						if ((v204 == (0 + 0)) or ((5812 - (657 + 358)) >= (12955 - 8062))) then
							v88 = 0 - 0;
							for v239, v240 in v23(v13:GetEnemiesInRange(1237 - (1151 + 36))) do
								if (v30.Poisoned(v240) or ((533 + 18) > (544 + 1524))) then
									local v249 = 0 - 0;
									while true do
										if (((3946 - (1552 + 280)) > (1778 - (64 + 770))) and (v249 == (1 + 0))) then
											if (v240:DebuffUp(v87) or ((5134 - 2872) >= (550 + 2546))) then
												v88 = v88 + (1244 - (157 + 1086));
											end
											break;
										end
										if ((v249 == (0 - 0)) or ((9876 - 7621) >= (5425 - 1888))) then
											if (v240:DebuffUp(v83) or ((5236 - 1399) < (2125 - (599 + 220)))) then
												v88 = v88 + (1 - 0);
												if (((4881 - (1813 + 118)) == (2157 + 793)) and v240:DebuffUp(v84)) then
													v88 = v88 + (1218 - (841 + 376));
												end
											end
											if (v240:DebuffUp(v85) or ((6617 - 1894) < (767 + 2531))) then
												v88 = v88 + (2 - 1);
												if (((1995 - (464 + 395)) >= (395 - 241)) and v240:DebuffUp(v86)) then
													v88 = v88 + 1 + 0;
												end
											end
											v249 = 838 - (467 + 370);
										end
									end
								end
							end
							v204 = 1 - 0;
						end
						if ((v204 == (1 + 0)) or ((928 - 657) > (741 + 4007))) then
							return v88;
						end
					end
				end;
				break;
			end
		end
	end
	do
		local v89 = v29();
		v30.RtBRemains = function(v121)
			local v122 = (v89 - v29()) - v10.RecoveryOffset(v121);
			return ((v122 >= (0 - 0)) and v122) or (520 - (150 + 370));
		end;
		v10:RegisterForSelfCombatEvent(function(v123, v123, v123, v123, v123, v123, v123, v123, v123, v123, v123, v124)
			if (((6022 - (74 + 1208)) >= (7752 - 4600)) and (v124 == (1496326 - 1180818))) then
				v89 = v29() + 22 + 8;
			end
		end, "SPELL_AURA_APPLIED");
		v10:RegisterForSelfCombatEvent(function(v125, v125, v125, v125, v125, v125, v125, v125, v125, v125, v125, v126)
			if ((v126 == (315898 - (14 + 376))) or ((4471 - 1893) >= (2194 + 1196))) then
				v89 = v29() + v22(36 + 4, 29 + 1 + v30.RtBRemains(true));
			end
		end, "SPELL_AURA_REFRESH");
		v10:RegisterForSelfCombatEvent(function(v127, v127, v127, v127, v127, v127, v127, v127, v127, v127, v127, v128)
			if (((120 - 79) <= (1250 + 411)) and (v128 == (315586 - (23 + 55)))) then
				v89 = v29();
			end
		end, "SPELL_AURA_REMOVED");
	end
	do
		local v91 = {CrimsonTempest={},Garrote={},Rupture={}};
		v30.Exsanguinated = function(v129, v130)
			local v131 = 0 - 0;
			local v132;
			local v133;
			while true do
				if (((402 + 199) < (3197 + 363)) and (v131 == (2 - 0))) then
					return false;
				end
				if (((74 + 161) < (1588 - (652 + 249))) and (v131 == (2 - 1))) then
					v133 = v130:ID();
					if (((6417 - (708 + 1160)) > (3129 - 1976)) and (v133 == (221358 - 99947))) then
						return v91.CrimsonTempest[v132] or false;
					elseif ((v133 == (730 - (10 + 17))) or ((1050 + 3624) < (6404 - (1400 + 332)))) then
						return v91.Garrote[v132] or false;
					elseif (((7035 - 3367) < (6469 - (242 + 1666))) and (v133 == (832 + 1111))) then
						return v91.Rupture[v132] or false;
					end
					v131 = 1 + 1;
				end
				if ((v131 == (0 + 0)) or ((1395 - (850 + 90)) == (6313 - 2708))) then
					v132 = v129:GUID();
					if (not v132 or ((4053 - (360 + 1030)) == (2932 + 380))) then
						return false;
					end
					v131 = 2 - 1;
				end
			end
		end;
		v30.WillLoseExsanguinate = function(v134, v135)
			if (((5884 - 1607) <= (6136 - (909 + 752))) and v30.Exsanguinated(v134, v135)) then
				return true;
			end
			return false;
		end;
		v30.ExsanguinatedRate = function(v136, v137)
			local v138 = 1223 - (109 + 1114);
			while true do
				if ((v138 == (0 - 0)) or ((339 + 531) == (1431 - (6 + 236)))) then
					if (((979 + 574) <= (2522 + 611)) and v30.Exsanguinated(v136, v137)) then
						return 4 - 2;
					end
					return 1 - 0;
				end
			end
		end;
		v10:RegisterForSelfCombatEvent(function(v139, v139, v139, v139, v139, v139, v139, v140, v139, v139, v139, v141)
			if ((v141 == (201939 - (1076 + 57))) or ((368 + 1869) >= (4200 - (579 + 110)))) then
				for v205, v206 in v23(v91) do
					for v218, v219 in v23(v206) do
						if ((v218 == v140) or ((105 + 1219) > (2671 + 349))) then
							v206[v218] = true;
						end
					end
				end
			end
		end, "SPELL_CAST_SUCCESS");
		v10:RegisterForSelfCombatEvent(function(v142, v142, v142, v142, v142, v142, v142, v143, v142, v142, v142, v144)
			if ((v144 == (64437 + 56974)) or ((3399 - (174 + 233)) == (5254 - 3373))) then
				v91.CrimsonTempest[v143] = false;
			elseif (((5451 - 2345) > (679 + 847)) and (v144 == (1877 - (663 + 511)))) then
				v91.Garrote[v143] = false;
			elseif (((2697 + 326) < (841 + 3029)) and (v144 == (5990 - 4047))) then
				v91.Rupture[v143] = false;
			end
		end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
		v10:RegisterForSelfCombatEvent(function(v145, v145, v145, v145, v145, v145, v145, v146, v145, v145, v145, v147)
			if (((87 + 56) > (174 - 100)) and (v147 == (293913 - 172502))) then
				if (((9 + 9) < (4110 - 1998)) and (v91.CrimsonTempest[v146] ~= nil)) then
					v91.CrimsonTempest[v146] = nil;
				end
			elseif (((782 + 315) <= (149 + 1479)) and (v147 == (1425 - (478 + 244)))) then
				if (((5147 - (440 + 77)) == (2106 + 2524)) and (v91.Garrote[v146] ~= nil)) then
					v91.Garrote[v146] = nil;
				end
			elseif (((12956 - 9416) > (4239 - (655 + 901))) and (v147 == (361 + 1582))) then
				if (((3671 + 1123) >= (2212 + 1063)) and (v91.Rupture[v146] ~= nil)) then
					v91.Rupture[v146] = nil;
				end
			end
		end, "SPELL_AURA_REMOVED");
		v10:RegisterForCombatEvent(function(v148, v148, v148, v148, v148, v148, v148, v149)
			local v150 = 0 - 0;
			while true do
				if (((2929 - (695 + 750)) == (5067 - 3583)) and (v150 == (1 - 0))) then
					if (((5759 - 4327) < (3906 - (285 + 66))) and (v91.Rupture[v149] ~= nil)) then
						v91.Rupture[v149] = nil;
					end
					break;
				end
				if ((v150 == (0 - 0)) or ((2375 - (682 + 628)) > (577 + 3001))) then
					if ((v91.CrimsonTempest[v149] ~= nil) or ((5094 - (176 + 123)) < (589 + 818))) then
						v91.CrimsonTempest[v149] = nil;
					end
					if (((1345 + 508) < (5082 - (239 + 30))) and (v91.Garrote[v149] ~= nil)) then
						v91.Garrote[v149] = nil;
					end
					v150 = 1 + 0;
				end
			end
		end, "UNIT_DIED", "UNIT_DESTROYED");
	end
	do
		local v95 = v16(188026 + 7601);
		local v96 = 0 - 0;
		local v97 = v29();
		v30.FanTheHammerCP = function()
			local v151 = 0 - 0;
			while true do
				if (((315 - (306 + 9)) == v151) or ((9844 - 7023) < (423 + 2008))) then
					if ((((v29() - v97) < (0.5 + 0)) and (v96 > (0 + 0))) or ((8218 - 5344) < (3556 - (1140 + 235)))) then
						if ((v96 > v13:ComboPoints()) or ((1712 + 977) <= (315 + 28))) then
							return v96;
						else
							v96 = 0 + 0;
						end
					end
					return 52 - (33 + 19);
				end
			end
		end;
		v10:RegisterForSelfCombatEvent(function(v152, v152, v152, v152, v152, v152, v152, v152, v152, v152, v152, v153, v152, v152, v154, v155)
			if ((v153 == (67073 + 118690)) or ((5601 - 3732) == (886 + 1123))) then
				if (((v29() - v97) > (0.5 - 0)) or ((3326 + 220) < (3011 - (586 + 103)))) then
					local v222 = 0 + 0;
					while true do
						if ((v222 == (0 - 0)) or ((3570 - (1309 + 179)) == (8616 - 3843))) then
							v96 = v22(v30.CPMaxSpend(), v13:ComboPoints() + v154 + (v25(0 + 0, v154 - (2 - 1)) * v22(2 + 0, v13:BuffStack(v95) - (1 - 0))));
							v97 = v29();
							break;
						end
					end
				end
			end
		end, "SPELL_ENERGIZE");
	end
	do
		local v99 = 0 - 0;
		local v100;
		local v101;
		local v102;
		while true do
			if (((3853 - (295 + 314)) > (2591 - 1536)) and (v99 == (1963 - (1300 + 662)))) then
				v30.TimeToNextTornado = function()
					local v207 = 0 - 0;
					local v208;
					while true do
						if ((v207 == (1756 - (1178 + 577))) or ((1721 + 1592) <= (5256 - 3478))) then
							if ((v29() == v100) or ((2826 - (851 + 554)) >= (1861 + 243))) then
								return 0 - 0;
							elseif (((3934 - 2122) <= (3551 - (115 + 187))) and ((v29() - v100) < (0.1 + 0)) and (v208 < (0.25 + 0))) then
								return 3 - 2;
							elseif (((2784 - (160 + 1001)) <= (1713 + 244)) and ((v208 > (0.9 + 0)) or (v208 == (0 - 0))) and ((v29() - v100) > (358.75 - (237 + 121)))) then
								return 897.1 - (525 + 372);
							end
							return v208;
						end
						if (((8364 - 3952) == (14495 - 10083)) and (v207 == (142 - (96 + 46)))) then
							if (((2527 - (643 + 134)) >= (304 + 538)) and not v13:BuffUp(v102, nil, true)) then
								return 0 - 0;
							end
							v208 = v13:BuffRemains(v102, nil, true) % (3 - 2);
							v207 = 1 + 0;
						end
					end
				end;
				v10:RegisterForSelfCombatEvent(function(v209, v209, v209, v209, v209, v209, v209, v209, v209, v209, v209, v210)
					local v211 = 0 - 0;
					while true do
						if (((8936 - 4564) > (2569 - (316 + 403))) and (v211 == (0 + 0))) then
							if (((637 - 405) < (297 + 524)) and (v210 == (535763 - 323020))) then
								v100 = v29();
							elseif (((368 + 150) < (291 + 611)) and (v210 == (685497 - 487662))) then
								v101 = v29();
							end
							if (((14298 - 11304) > (1782 - 924)) and (v101 == v100)) then
								v100 = 0 + 0;
							end
							break;
						end
					end
				end, "SPELL_CAST_SUCCESS");
				break;
			end
			if ((v99 == (0 - 0)) or ((184 + 3571) <= (2692 - 1777))) then
				v100, v101 = 17 - (12 + 5), 0 - 0;
				v102 = v16(592985 - 315060);
				v99 = 1 - 0;
			end
		end
	end
	do
		local v103 = {Counter=(0 - 0),LastMH=(0 + 0),LastOH=(1973 - (1656 + 317))};
		v30.TimeToSht = function(v156)
			if (((3517 + 429) > (3000 + 743)) and (v103.Counter >= v156)) then
				return 0 - 0;
			end
			local v157, v158 = v28("player");
			local v159 = v25(v103.LastMH + v157, v29());
			local v160 = v25(v103.LastOH + v158, v29());
			local v161 = {};
			for v175 = 0 - 0, 356 - (5 + 349) do
				local v176 = 0 - 0;
				while true do
					if ((v176 == (1271 - (266 + 1005))) or ((880 + 455) >= (11280 - 7974))) then
						v27(v161, v159 + (v175 * v157));
						v27(v161, v160 + (v175 * v158));
						break;
					end
				end
			end
			table.sort(v161);
			local v162 = v22(6 - 1, v25(1697 - (561 + 1135), v156 - v103.Counter));
			return v161[v162] - v29();
		end;
		v10:RegisterForSelfCombatEvent(function()
			local v163 = 0 - 0;
			while true do
				if (((15922 - 11078) > (3319 - (507 + 559))) and (v163 == (0 - 0))) then
					v103.Counter = 0 - 0;
					v103.LastMH = v29();
					v163 = 389 - (212 + 176);
				end
				if (((1357 - (250 + 655)) == (1232 - 780)) and (v163 == (1 - 0))) then
					v103.LastOH = v29();
					break;
				end
			end
		end, "PLAYER_ENTERING_WORLD");
		v10:RegisterForSelfCombatEvent(function(v164, v164, v164, v164, v164, v164, v164, v164, v164, v164, v164, v165)
			if ((v165 == (308080 - 111169)) or ((6513 - (1869 + 87)) < (7238 - 5151))) then
				v103.Counter = 1901 - (484 + 1417);
			end
		end, "SPELL_ENERGIZE");
		v10:RegisterForSelfCombatEvent(function(v166, v166, v166, v166, v166, v166, v166, v166, v166, v166, v166, v166, v166, v166, v166, v166, v166, v166, v166, v166, v166, v166, v166, v167)
			local v168 = 0 - 0;
			while true do
				if (((6492 - 2618) == (4647 - (48 + 725))) and (v168 == (0 - 0))) then
					v103.Counter = v103.Counter + (2 - 1);
					if (v167 or ((1127 + 811) > (13188 - 8253))) then
						v103.LastOH = v29();
					else
						v103.LastMH = v29();
					end
					break;
				end
			end
		end, "SWING_DAMAGE");
		v10:RegisterForSelfCombatEvent(function(v169, v169, v169, v169, v169, v169, v169, v169, v169, v169, v169, v169, v169, v169, v169, v170)
			if (v170 or ((1191 + 3064) < (998 + 2425))) then
				v103.LastOH = v29();
			else
				v103.LastMH = v29();
			end
		end, "SWING_MISSED");
	end
	do
		local v105 = 853 - (152 + 701);
		local v106;
		local v107;
		local v108;
		while true do
			if (((2765 - (430 + 881)) <= (954 + 1537)) and (v105 == (895 - (557 + 338)))) then
				v106 = v13:CritChancePct();
				v107 = 0 + 0;
				v105 = 2 - 1;
			end
			if ((v105 == (3 - 2)) or ((11043 - 6886) <= (6040 - 3237))) then
				v108 = nil;
				function v108()
					local v216 = 801 - (499 + 302);
					while true do
						if (((5719 - (39 + 827)) >= (8231 - 5249)) and (v216 == (0 - 0))) then
							if (((16419 - 12285) > (5153 - 1796)) and not v13:AffectingCombat()) then
								local v242 = 0 + 0;
								while true do
									if ((v242 == (0 - 0)) or ((547 + 2870) < (4009 - 1475))) then
										v106 = v13:CritChancePct();
										v10.Debug("Base Crit Set to: " .. v106);
										break;
									end
								end
							end
							if ((v107 == nil) or (v107 < (104 - (103 + 1))) or ((3276 - (475 + 79)) <= (354 - 190))) then
								v107 = 0 - 0;
							else
								v107 = v107 - (1 + 0);
							end
							v216 = 1 + 0;
						end
						if ((v216 == (1504 - (1395 + 108))) or ((7007 - 4599) < (3313 - (7 + 1197)))) then
							if ((v107 > (0 + 0)) or ((12 + 21) == (1774 - (27 + 292)))) then
								v24.After(8 - 5, v108);
							end
							break;
						end
					end
				end
				v105 = 2 - 0;
			end
			if ((v105 == (8 - 6)) or ((872 - 429) >= (7646 - 3631))) then
				v10:RegisterForEvent(function()
					if (((3521 - (43 + 96)) > (677 - 511)) and (v107 == (0 - 0))) then
						v24.After(3 + 0, v108);
						v107 = 1 + 1;
					end
				end, "PLAYER_EQUIPMENT_CHANGED");
				v30.BaseAttackCrit = function()
					return v106;
				end;
				break;
			end
		end
	end
	do
		local v109 = 0 - 0;
		local v110;
		local v111;
		local v112;
		local v113;
		while true do
			if ((v109 == (1 + 1)) or ((524 - 244) == (964 + 2095))) then
				v113 = nil;
				function v113()
					local v217 = 0 + 0;
					while true do
						if (((3632 - (1414 + 337)) > (3233 - (1642 + 298))) and (v217 == (0 - 0))) then
							if (((6780 - 4423) == (6994 - 4637)) and v110.ImprovedGarrote:IsAvailable() and (v13:BuffUp(v110.ImprovedGarroteAura, nil, true) or v13:BuffUp(v110.ImprovedGarroteBuff, nil, true) or v13:BuffUp(v110.SepsisBuff, nil, true))) then
								return 1.5 + 0;
							end
							return 1 + 0;
						end
					end
				end
				v109 = 975 - (357 + 615);
			end
			if (((87 + 36) == (301 - 178)) and (v109 == (3 + 0))) then
				v110.Rupture:RegisterPMultiplier(v112, {v111.FinalityRuptureBuff,(1.3 + 0)});
				v110.Garrote:RegisterPMultiplier(v112, v113);
				break;
			end
			if ((v109 == (0 + 0)) or ((2357 - (384 + 917)) >= (4089 - (128 + 569)))) then
				v110 = v16.Rogue.Assassination;
				v111 = v16.Rogue.Subtlety;
				v109 = 1544 - (1407 + 136);
			end
			if ((v109 == (1888 - (687 + 1200))) or ((2791 - (556 + 1154)) < (3781 - 2706))) then
				v112 = nil;
				function v112()
					if ((v110.Nightstalker:IsAvailable() and v13:StealthUp(true, false, true)) or ((1144 - (9 + 86)) >= (4853 - (275 + 146)))) then
						return 1 + 0 + ((64.05 - (29 + 35)) * v110.Nightstalker:TalentRank());
					end
					return 4 - 3;
				end
				v109 = 5 - 3;
			end
		end
	end
end;
return v0["Epix_Rogue_Rogue.lua"]();

