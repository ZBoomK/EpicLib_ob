local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 960 - (271 + 689);
	local v6;
	while true do
		if ((v5 == (1605 - (963 + 641))) or ((2920 - (48 + 146)) == (4457 - (294 + 294)))) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((738 + 3638) <= (488 + 993))) then
			v6 = v0[v4];
			if (not v6 or ((5005 - (1565 + 48)) >= (2929 + 1812))) then
				return v1(v4, ...);
			end
			v5 = 1139 - (782 + 356);
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
	if (((3592 - (176 + 91)) >= (5611 - 3457)) and not v16.Rogue) then
		v16.Rogue = {};
	end
	v16.Rogue.Commons = {Sanguine=v16(333833 - 107323, nil, 1093 - (975 + 117)),AncestralCall=v16(276613 - (157 + 1718), nil, 2 + 0),ArcanePulse=v16(924272 - 663908, nil, 10 - 7),ArcaneTorrent=v16(26064 - (697 + 321), nil, 10 - 6),BagofTricks=v16(661877 - 349466, nil, 11 - 6),Berserking=v16(10236 + 16061, nil, 11 - 5),BloodFury=v16(55147 - 34575, nil, 1234 - (322 + 905)),Fireblood=v16(265832 - (602 + 9), nil, 1197 - (449 + 740)),LightsJudgment=v16(256519 - (826 + 46), nil, 956 - (245 + 702)),Shadowmeld=v16(186386 - 127402, nil, 4 + 6),CloakofShadows=v16(33122 - (260 + 1638), nil, 451 - (382 + 58)),CrimsonVial=v16(594490 - 409179, nil, 10 + 2),Evasion=v16(10905 - 5628, nil, 38 - 25),Feint=v16(3171 - (902 + 303), nil, 30 - 16),Blind=v16(5043 - 2949, nil, 2 + 13),CheapShot=v16(3523 - (1121 + 569), nil, 230 - (22 + 192)),Kick=v16(2449 - (483 + 200), nil, 1480 - (1404 + 59)),KidneyShot=v16(1116 - 708, nil, 23 - 5),Sap=v16(7535 - (468 + 297), nil, 581 - (334 + 228)),Shiv=v16(20028 - 14090, nil, 46 - 26),SliceandDice=v16(572196 - 256700, nil, 6 + 15),Shadowstep=v16(36790 - (141 + 95), nil, 22 + 0),Sprint=v16(7677 - 4694, nil, 54 - 31),TricksoftheTrade=v16(13571 + 44363, nil, 65 - 41),CripplingPoison=v16(2396 + 1012, nil, 14 + 11),DeadlyPoison=v16(3975 - 1152, nil, 16 + 10),InstantPoison=v16(315747 - (92 + 71), nil, 14 + 13),AmplifyingPoison=v16(641690 - 260026, nil, 793 - (574 + 191)),NumbingPoison=v16(4753 + 1008, nil, 72 - 43),WoundPoison=v16(4434 + 4245, nil, 879 - (254 + 595)),AtrophicPoison=v16(381763 - (55 + 71), nil, 40 - 9),AcrobaticStrikes=v16(198714 - (573 + 1217), nil, 88 - 56),Alacrity=v16(14726 + 178813, nil, 52 - 19),ColdBlood=v16(383184 - (714 + 225), nil, 99 - 65),DeeperStratagem=v16(269813 - 76282),EchoingReprimand=v16(41749 + 343867, nil, 51 - 15),EchoingReprimand2=v16(324364 - (118 + 688), nil, 85 - (25 + 23)),EchoingReprimand3=v16(62669 + 260890, nil, 1924 - (927 + 959)),EchoingReprimand4=v16(1090687 - 767127, nil, 771 - (16 + 716)),EchoingReprimand5=v16(684981 - 330143, nil, 137 - (11 + 86)),FindWeakness=v16(222020 - 130997, nil, 326 - (175 + 110)),FindWeaknessDebuff=v16(798391 - 482171, nil, 207 - 165),ImprovedAmbush=v16(383416 - (503 + 1293), nil, 120 - 77),MarkedforDeath=v16(99521 + 38098, nil, 1105 - (810 + 251)),Nightstalker=v16(9759 + 4303, nil, 14 + 31),ResoundingClarity=v16(344015 + 37607, nil, 579 - (43 + 490)),SealFate=v16(14923 - (711 + 22), nil, 181 - 134),Sepsis=v16(386267 - (240 + 619), nil, 12 + 36),SepsisBuff=v16(598007 - 222068, nil, 4 + 45),ShadowDance=v16(187057 - (1344 + 400), nil, 455 - (255 + 150)),ShadowDanceTalent=v16(311077 + 83853, nil, 28 + 23),ShadowDanceBuff=v16(792230 - 606808),Subterfuge=v16(349503 - 241295, nil, 1792 - (404 + 1335)),SubterfugeBuff=v16(115598 - (183 + 223), nil, 64 - 10),ThistleTea=v16(252859 + 128764, nil, 116 + 204),Vigor=v16(15320 - (10 + 327)),Stealth=v16(1243 + 541, nil, 395 - (118 + 220)),Stealth2=v16(38388 + 76803, nil, 507 - (108 + 341)),Vanish=v16(834 + 1022, nil, 249 - 190),VanishBuff=v16(12820 - (711 + 782), nil, 115 - 55),VanishBuff2=v16(115662 - (270 + 199), nil, 20 + 41),PoolEnergy=v16(1001729 - (580 + 1239), nil, 183 - 121),Gouge=v16(1699 + 77, nil, 5 + 131)};
	v16.Rogue.Assassination = v19(v16.Rogue.Commons, {Ambush=v16(3780 + 4896, nil, 164 - 101),AmbushOverride=v16(267155 + 162868),AmplifyingPoisonDebuff=v16(384581 - (645 + 522), nil, 1854 - (1010 + 780)),AmplifyingPoisonDebuffDeathmark=v16(394133 + 195, nil, 309 - 244),CripplingPoisonDebuff=v16(9989 - 6580, nil, 1902 - (1045 + 791)),DeadlyPoisonDebuff=v16(7132 - 4314, nil, 101 - 34),DeadlyPoisonDebuffDeathmark=v16(394829 - (351 + 154), nil, 1642 - (1281 + 293)),Envenom=v16(32911 - (28 + 238), nil, 153 - 84),FanofKnives=v16(53282 - (1381 + 178), nil, 66 + 4),Garrote=v16(567 + 136, nil, 31 + 40),GarroteDeathmark=v16(1243932 - 883102, nil, 38 + 34),Mutilate=v16(1799 - (381 + 89), nil, 65 + 8),PoisonedKnife=v16(125496 + 60069, nil, 126 - 52),Rupture=v16(3099 - (1074 + 82), nil, 164 - 89),RuptureDeathmark=v16(362610 - (214 + 1570), nil, 1531 - (990 + 465)),WoundPoisonDebuff=v16(3579 + 5101, nil, 34 + 43),ArterialPrecision=v16(389741 + 11042, nil, 306 - 228),AtrophicPoisonDebuff=v16(394114 - (1668 + 58), nil, 705 - (512 + 114)),BlindsideBuff=v16(315863 - 194710, nil, 165 - 85),CausticSpatter=v16(1468328 - 1046353),CausticSpatterDebuff=v16(196309 + 225667),CrimsonTempest=v16(22728 + 98683, nil, 71 + 10),CutToTheChase=v16(174270 - 122603, nil, 2076 - (109 + 1885)),DashingScoundrel=v16(383266 - (1269 + 200), nil, 158 - 75),Deathmark=v16(361009 - (98 + 717), nil, 910 - (802 + 24)),Doomblade=v16(658207 - 276534, nil, 107 - 22),DragonTemperedBlades=v16(56385 + 325416, nil, 67 + 19),Elusiveness=v16(12978 + 66030),Exsanguinate=v16(43316 + 157490, nil, 244 - 156),ImprovedGarrote=v16(1272651 - 891019, nil, 32 + 57),ImprovedGarroteBuff=v16(159732 + 232669, nil, 75 + 15),ImprovedGarroteAura=v16(285330 + 107073, nil, 43 + 48),IndiscriminateCarnage=v16(383235 - (797 + 636), nil, 446 - 354),IndiscriminateCarnageAura=v16(387373 - (1427 + 192)),IndiscriminateCarnageBuff=v16(133658 + 252089),InternalBleeding=v16(359765 - 204812, nil, 84 + 9),Kingsbane=v16(174760 + 210867, nil, 420 - (192 + 134)),LightweightShiv=v16(396259 - (316 + 960)),MasterAssassin=v16(142457 + 113532, nil, 74 + 21),MasterAssassinBuff=v16(237303 + 19432, nil, 366 - 270),PreyontheWeak=v16(132062 - (83 + 468), nil, 1903 - (1202 + 604)),PreyontheWeakDebuff=v16(1194632 - 938723, nil, 162 - 64),SerratedBoneSpike=v16(1067138 - 681714, nil, 424 - (45 + 280)),SerratedBoneSpikeDebuff=v16(380321 + 13715, nil, 88 + 12),ShivDebuff=v16(116664 + 202840, nil, 56 + 45),VenomRush=v16(26762 + 125390, nil, 188 - 86),ScentOfBlood=v16(383710 - (340 + 1571), nil, 157 + 239),ScentOfBloodBuff=v16(395852 - (1733 + 39)),ShroudedSuffocation=v16(1059254 - 673776)});
	v16.Rogue.Outlaw = v19(v16.Rogue.Commons, {AdrenalineRush=v16(14784 - (125 + 909), nil, 2051 - (1096 + 852)),Ambush=v16(3892 + 4784, nil, 148 - 44),AmbushOverride=v16(417094 + 12929),BetweentheEyes=v16(315853 - (409 + 103), nil, 341 - (46 + 190)),BladeFlurry=v16(13972 - (51 + 44), nil, 30 + 76),Dispatch=v16(3415 - (1114 + 203), nil, 833 - (228 + 498)),Elusiveness=v16(17118 + 61890),Opportunity=v16(108077 + 87550),PistolShot=v16(186426 - (174 + 489), nil, 286 - 176),RolltheBones=v16(317413 - (830 + 1075), nil, 635 - (303 + 221)),SinisterStrike=v16(194584 - (231 + 1038), nil, 94 + 18),Audacity=v16(383007 - (171 + 991), nil, 465 - 352),AudacityBuff=v16(1037212 - 650942, nil, 284 - 170),BladeRush=v16(217596 + 54281, nil, 403 - 288),CountTheOdds=v16(1101943 - 719961, nil, 186 - 70),Dreadblades=v16(1060749 - 717607, nil, 1365 - (111 + 1137)),FanTheHammer=v16(382004 - (91 + 67), nil, 351 - 233),GhostlyStrike=v16(49137 + 147800, nil, 642 - (423 + 100)),GreenskinsWickers=v16(2716 + 384107, nil, 332 - 212),GreenskinsWickersBuff=v16(205430 + 188701, nil, 892 - (326 + 445)),HiddenOpportunity=v16(1672628 - 1289347, nil, 271 - 149),ImprovedAdrenalineRush=v16(923004 - 527582, nil, 834 - (530 + 181)),ImprovedBetweenTheEyes=v16(236365 - (614 + 267), nil, 156 - (19 + 13)),KeepItRolling=v16(621730 - 239741, nil, 290 - 165),KillingSpree=v16(147657 - 95967, nil, 33 + 93),LoadedDice=v16(450520 - 194350, nil, 262 - 135),LoadedDiceBuff=v16(257983 - (1293 + 519), nil, 261 - 133),PreyontheWeak=v16(343368 - 211857, nil, 246 - 117),PreyontheWeakDebuff=v16(1103507 - 847598, nil, 306 - 176),QuickDraw=v16(104307 + 92631, nil, 27 + 104),SummarilyDispatched=v16(887560 - 505570, nil, 31 + 101),SwiftSlasher=v16(126900 + 255088, nil, 84 + 49),TakeEmBySurpriseBuff=v16(387003 - (709 + 387), nil, 1992 - (673 + 1185)),Weaponmaster=v16(582154 - 381421, nil, 433 - 298),UnderhandedUpperhand=v16(697696 - 273652),Ruthlessness=v16(10129 + 4032),DeftManeuvers=v16(285339 + 96539),Crackshot=v16(572066 - 148363),Broadside=v16(47489 + 145867, nil, 272 - 135),BuriedTreasure=v16(391820 - 192220, nil, 2018 - (446 + 1434)),GrandMelee=v16(194641 - (1040 + 243), nil, 414 - 275),RuthlessPrecision=v16(195204 - (559 + 1288), nil, 2071 - (609 + 1322)),SkullandCrossbones=v16(200057 - (13 + 441), nil, 526 - 385),TrueBearing=v16(506477 - 313118, nil, 707 - 565),ViciousFollowup=v16(14704 + 380175, nil, 519 - 376)});
	v16.Rogue.Subtlety = v19(v16.Rogue.Commons, {Backstab=v16(19 + 34, nil, 64 + 80),BlackPowder=v16(947160 - 627985, nil, 80 + 65),Elusiveness=v16(145311 - 66303),Eviscerate=v16(130120 + 66699, nil, 82 + 65),Rupture=v16(1397 + 546, nil, 125 + 23),ShadowBlades=v16(118846 + 2625, nil, 582 - (153 + 280)),Shadowstrike=v16(535470 - 350032, nil, 135 + 15),ShurikenStorm=v16(78114 + 119721, nil, 80 + 71),ShurikenToss=v16(103466 + 10548, nil, 111 + 41),SymbolsofDeath=v16(323246 - 110963, nil, 95 + 58),DanseMacabre=v16(383195 - (89 + 578), nil, 111 + 43),DanseMacabreBuff=v16(819053 - 425084, nil, 1204 - (572 + 477)),DeeperDaggers=v16(51590 + 330927, nil, 94 + 62),DeeperDaggersBuff=v16(45765 + 337640, nil, 243 - (84 + 2)),DarkBrew=v16(630393 - 247889, nil, 114 + 44),DarkShadow=v16(246529 - (497 + 345), nil, 5 + 154),EnvelopingShadows=v16(40250 + 197854, nil, 1493 - (605 + 728)),Finality=v16(272924 + 109601, nil, 357 - 196),FinalityBlackPowderBuff=v16(17688 + 368260, nil, 598 - 436),FinalityEviscerateBuff=v16(347932 + 38017, nil, 451 - 288),FinalityRuptureBuff=v16(291413 + 94538, nil, 653 - (457 + 32)),Flagellation=v16(163190 + 221441, nil, 1567 - (832 + 570)),FlagellationPersistBuff=v16(371897 + 22861, nil, 44 + 122),Gloomblade=v16(710445 - 509687, nil, 81 + 86),GoremawsBite=v16(427387 - (588 + 208), nil, 509 - 320),ImprovedShadowDance=v16(395772 - (884 + 916), nil, 351 - 183),ImprovedShurikenStorm=v16(185513 + 134438, nil, 822 - (232 + 421)),InvigoratingShadowdust=v16(384412 - (1569 + 320)),LingeringShadow=v16(93850 + 288674, nil, 33 + 137),LingeringShadowBuff=v16(1300614 - 914654, nil, 776 - (316 + 289)),MasterofShadows=v16(515628 - 318652, nil, 8 + 164),PerforatedVeins=v16(383971 - (666 + 787), nil, 598 - (360 + 65)),PerforatedVeinsBuff=v16(368457 + 25797, nil, 428 - (79 + 175)),PreyontheWeak=v16(207371 - 75860, nil, 137 + 38),PreyontheWeakDebuff=v16(784431 - 528522, nil, 338 - 162),Premeditation=v16(344059 - (503 + 396), nil, 358 - (92 + 89)),PremeditationBuff=v16(665740 - 322567, nil, 92 + 86),SecretStratagem=v16(233378 + 160942, nil, 700 - 521),SecretTechnique=v16(38389 + 242330, nil, 410 - 230),Shadowcraft=v16(372200 + 54394),ShadowFocus=v16(51685 + 56524, nil, 551 - 370),ShurikenTornado=v16(34688 + 243237, nil, 276 - 94),SilentStorm=v16(386966 - (485 + 759), nil, 423 - 240),SilentStormBuff=v16(386911 - (442 + 747), nil, 1319 - (832 + 303)),TheFirstDance=v16(383451 - (88 + 858), nil, 57 + 128),TheRotten=v16(316156 + 65859, nil, 8 + 178),TheRottenBuff=v16(394992 - (766 + 23), nil, 923 - 736),Weaponmaster=v16(264692 - 71155, nil, 495 - 307)});
	if (not v18.Rogue or ((4395 - 3100) >= (4306 - (1036 + 37)))) then
		v18.Rogue = {};
	end
	v18.Rogue.Commons = {AlgetharPuzzleBox=v18(137330 + 56371, {(11 + 2),(927 - (910 + 3))}),ManicGrieftorch=v18(495348 - 301040, {(6 + 7),(5 + 9)}),WindscarWhetstone=v18(138294 - (329 + 479), {(44 - 31),(10 + 4)}),Healthstone=v18(6251 - (396 + 343)),RefreshingHealingPotion=v18(16933 + 174447),DreamwalkersHealingPotion=v18(208500 - (29 + 1448))};
	v18.Rogue.Assassination = v19(v18.Rogue.Commons, {AlgetharPuzzleBox=v18(195090 - (135 + 1254), {(60 - 47),(1541 - (389 + 1138))}),AshesoftheEmbersoul=v18(207741 - (102 + 472), {(8 + 5),(1559 - (320 + 1225))}),WitherbarksBranch=v18(195818 - 85819, {(1477 - (157 + 1307)),(34 - 20)})});
	v18.Rogue.Outlaw = v19(v18.Rogue.Commons, {ManicGrieftorch=v18(21250 + 173058, {(5 + 8),(1040 - (834 + 192))}),WindscarWhetstone=v18(8741 + 128745, {(1 + 12),(318 - (300 + 4))}),BeaconToTheBeyond=v18(54472 + 149491, {(375 - (112 + 250)),(34 - 20)}),DragonfireBombDispenser=v18(116072 + 86538, {(10 + 3),(11 + 3)})});
	v18.Rogue.Subtlety = v19(v18.Rogue.Commons, {ManicGrieftorch=v18(195722 - (1001 + 413), {(895 - (244 + 638)),(41 - 27)}),StormEatersBoon=v18(194904 - (512 + 90), {(730 - (373 + 344)),(4 + 10)}),BeaconToTheBeyond=v18(537998 - 334035, {(1112 - (35 + 1064)),(29 - 15)}),AshesoftheEmbersoul=v18(827 + 206340, {(1272 - (233 + 1026)),(8 + 6)}),WitherbarksBranch=v18(107444 + 2555, {(1 + 12),(3 + 11)}),BandolierOfTwistedBlades=v18(20833 + 186332, {(310 - (36 + 261)),(1382 - (34 + 1334))}),Mirror=v18(79800 + 127781, {(1296 - (1035 + 248)),(8 + 6)})});
	if (((4696 - (134 + 185)) > (2775 - (549 + 584))) and not v21.Rogue) then
		v21.Rogue = {};
	end
	v21.Rogue.Commons = {Healthstone=v21(706 - (314 + 371)),BlindMouseover=v21(30 - 21),CheapShotMouseover=v21(978 - (478 + 490)),KickMouseover=v21(6 + 5),KidneyShotMouseover=v21(1184 - (786 + 386)),TricksoftheTradeFocus=v21(41 - 28),WindscarWhetstone=v21(1405 - (1055 + 324)),RefreshingHealingPotion=v21(1369 - (1093 + 247))};
	v21.Rogue.Outlaw = v19(v21.Rogue.Commons, {Dispatch=v21(13 + 1),PistolShotMouseover=v21(2 + 13),SinisterStrikeMouseover=v21(107 - 80)});
	v21.Rogue.Assassination = v19(v21.Rogue.Commons, {GarroteMouseOver=v21(94 - 66)});
	v21.Rogue.Subtlety = v19(v21.Rogue.Commons, {SecretTechnique=v21(45 - 29),ShadowDance=v21(42 - 25),ShadowDanceSymbol=v21(10 + 16),VanishShadowstrike=v21(69 - 51),ShurikenStormSD=v21(65 - 46),ShurikenStormVanish=v21(16 + 4),GloombladeSD=v21(56 - 34),GloombladeVanish=v21(711 - (364 + 324)),BackstabMouseover=v21(65 - 41),RuptureMouseover=v21(59 - 34)});
	v30.StealthSpell = function()
		return (v16.Rogue.Commons.Subterfuge:IsAvailable() and v16.Rogue.Commons.Stealth2) or v16.Rogue.Commons.Stealth;
	end;
	v30.VanishBuffSpell = function()
		return (v16.Rogue.Commons.Subterfuge:IsAvailable() and v16.Rogue.Commons.VanishBuff2) or v16.Rogue.Commons.VanishBuff;
	end;
	v30.Stealth = function(v50, v51)
		local v52 = 0 + 0;
		while true do
			if (((19762 - 15039) > (2171 - 815)) and (v52 == (0 - 0))) then
				if ((EpicSettings.Settings['StealthOOC'] and (v16.Rogue.Commons.Stealth:IsCastable() or v16.Rogue.Commons.Stealth2:IsCastable()) and v13:StealthDown()) or ((5404 - (1249 + 19)) <= (3099 + 334))) then
					if (((16523 - 12278) <= (5717 - (686 + 400))) and v10.Press(v50, nil)) then
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
			local v115 = EpicSettings.Settings['CrimsonVialHP'] or (0 + 0);
			if (((4505 - (73 + 156)) >= (19 + 3895)) and v54:IsCastable() and v54:IsReady() and (v13:HealthPercentage() <= v115)) then
				if (((1009 - (721 + 90)) <= (50 + 4315)) and v10.Cast(v54, nil)) then
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
			local v116 = 0 - 0;
			local v117;
			while true do
				if (((5252 - (224 + 246)) > (7575 - 2899)) and (v116 == (0 - 0))) then
					v117 = EpicSettings.Settings['FeintHP'] or (0 + 0);
					if (((116 + 4748) > (1614 + 583)) and v57:IsCastable() and v13:BuffDown(v57) and (v13:HealthPercentage() <= v117)) then
						if (v10.Cast(v57, nil) or ((7356 - 3656) == (8342 - 5835))) then
							return "Cast Feint (Defensives)";
						end
					end
					break;
				end
			end
		end;
	end
	do
		local v59 = 513 - (203 + 310);
		local v60 = false;
		local function v61(v118)
			if (((6467 - (1238 + 755)) >= (20 + 254)) and not v13:AffectingCombat() and v13:BuffRefreshable(v118)) then
				if (v10.Press(v118, nil, true) or ((3428 - (709 + 825)) <= (2590 - 1184))) then
					return "poison";
				end
			end
		end
		v30.Poisons = function()
			v60 = v13:BuffUp(v16.Rogue.Commons.WoundPoison);
			if (((2289 - 717) >= (2395 - (196 + 668))) and v16.Rogue.Assassination.DragonTemperedBlades:IsAvailable()) then
				local v161 = 0 - 0;
				local v162;
				while true do
					if ((v161 == (0 - 0)) or ((5520 - (171 + 662)) < (4635 - (4 + 89)))) then
						v162 = v61((v60 and v16.Rogue.Commons.WoundPoison) or v16.Rogue.Commons.DeadlyPoison);
						if (((11534 - 8243) > (607 + 1060)) and v162) then
							return v162;
						end
						v161 = 4 - 3;
					end
					if ((v161 == (1 + 0)) or ((2359 - (35 + 1451)) == (3487 - (28 + 1425)))) then
						if (v16.Rogue.Commons.AmplifyingPoison:IsAvailable() or ((4809 - (941 + 1052)) < (11 + 0))) then
							local v228 = 1514 - (822 + 692);
							while true do
								if (((5280 - 1581) < (2217 + 2489)) and (v228 == (297 - (45 + 252)))) then
									v162 = v61(v16.Rogue.Commons.AmplifyingPoison);
									if (((2619 + 27) >= (302 + 574)) and v162) then
										return v162;
									end
									break;
								end
							end
						else
							v162 = v61(v16.Rogue.Commons.InstantPoison);
							if (((1493 - 879) <= (3617 - (114 + 319))) and v162) then
								return v162;
							end
						end
						break;
					end
				end
			elseif (((4487 - 1361) == (4005 - 879)) and v60) then
				local v209 = v61(v16.Rogue.Commons.WoundPoison);
				if (v209 or ((1395 + 792) >= (7380 - 2426))) then
					return v209;
				end
			elseif ((v16.Rogue.Commons.AmplifyingPoison:IsAvailable() and v13:BuffDown(v16.Rogue.Commons.DeadlyPoison)) or ((8123 - 4246) == (5538 - (556 + 1407)))) then
				local v222 = v61(v16.Rogue.Commons.AmplifyingPoison);
				if (((1913 - (741 + 465)) > (1097 - (170 + 295))) and v222) then
					return v222;
				end
			elseif (v16.Rogue.Commons.DeadlyPoison:IsAvailable() or ((288 + 258) >= (2466 + 218))) then
				local v235 = 0 - 0;
				local v236;
				while true do
					if (((1215 + 250) <= (2759 + 1542)) and (v235 == (0 + 0))) then
						v236 = v61(v16.Rogue.Commons.DeadlyPoison);
						if (((2934 - (957 + 273)) > (382 + 1043)) and v236) then
							return v236;
						end
						break;
					end
				end
			else
				local v237 = v61(v16.Rogue.Commons.InstantPoison);
				if (v237 or ((276 + 411) == (16133 - 11899))) then
					return v237;
				end
			end
			if (v13:BuffDown(v16.Rogue.Commons.CripplingPoison) or ((8775 - 5445) < (4364 - 2935))) then
				if (((5679 - 4532) >= (2115 - (389 + 1391))) and v16.Rogue.Commons.AtrophicPoison:IsAvailable()) then
					local v210 = 0 + 0;
					local v211;
					while true do
						if (((358 + 3077) > (4773 - 2676)) and (v210 == (951 - (783 + 168)))) then
							v211 = v61(v16.Rogue.Commons.AtrophicPoison);
							if (v211 or ((12652 - 8882) >= (3975 + 66))) then
								return v211;
							end
							break;
						end
					end
				elseif (v16.Rogue.Commons.NumbingPoison:IsAvailable() or ((4102 - (309 + 2)) <= (4947 - 3336))) then
					local v223 = 1212 - (1090 + 122);
					local v224;
					while true do
						if (((0 + 0) == v223) or ((15375 - 10797) <= (1375 + 633))) then
							v224 = v61(v16.Rogue.Commons.NumbingPoison);
							if (((2243 - (628 + 490)) <= (373 + 1703)) and v224) then
								return v224;
							end
							break;
						end
					end
				else
					local v225 = v61(v16.Rogue.Commons.CripplingPoison);
					if (v225 or ((1839 - 1096) >= (20103 - 15704))) then
						return v225;
					end
				end
			else
				local v163 = 774 - (431 + 343);
				local v164;
				while true do
					if (((2332 - 1177) < (4839 - 3166)) and (v163 == (0 + 0))) then
						v164 = v61(v16.Rogue.Commons.CripplingPoison);
						if (v164 or ((298 + 2026) <= (2273 - (556 + 1139)))) then
							return v164;
						end
						break;
					end
				end
			end
		end;
	end
	v30.MfDSniping = function(v63)
		if (((3782 - (6 + 9)) == (690 + 3077)) and v63:IsCastable()) then
			local v155 = 0 + 0;
			local v156;
			local v157;
			local v158;
			while true do
				if (((4258 - (28 + 141)) == (1584 + 2505)) and (v155 == (1 - 0))) then
					for v213, v214 in v23(v13:GetEnemiesInRange(22 + 8)) do
						local v215 = v214:TimeToDie();
						if (((5775 - (486 + 831)) >= (4356 - 2682)) and not v214:IsMfDBlacklisted() and (v215 < (v13:ComboPointsDeficit() * (3.5 - 2))) and (v215 < v157)) then
							if (((184 + 788) <= (4483 - 3065)) and ((v158 - v215) > (1264 - (668 + 595)))) then
								v156, v157 = v214, v215;
							else
								v156, v157 = v15, v158;
							end
						end
					end
					if ((v156 and (v156:GUID() ~= v14:GUID())) or ((4444 + 494) < (961 + 3801))) then
						v10.Press(v156, v63);
					end
					break;
				end
				if (((0 - 0) == v155) or ((2794 - (23 + 267)) > (6208 - (1129 + 815)))) then
					v156, v157 = nil, 447 - (371 + 16);
					v158 = (v15:IsInRange(1780 - (1326 + 424)) and v15:TimeToDie()) or (21043 - 9932);
					v155 = 3 - 2;
				end
			end
		end
	end;
	v30.CanDoTUnit = function(v64, v65)
		return v20.CanDoTUnit(v64, v65);
	end;
	do
		local v66 = 118 - (88 + 30);
		local v67;
		local v68;
		local v69;
		local v70;
		while true do
			if (((2924 - (720 + 51)) == (4789 - 2636)) and (v66 == (1779 - (421 + 1355)))) then
				v67.Rupture:RegisterPMultiplier(v69, {v68.FinalityRuptureBuff,(1084.3 - (286 + 797))});
				v67.Garrote:RegisterPMultiplier(v69, v70);
				v66 = 14 - 10;
			end
			if ((v66 == (1 - 0)) or ((946 - (397 + 42)) >= (810 + 1781))) then
				v69 = nil;
				function v69()
					if (((5281 - (24 + 776)) == (6903 - 2422)) and v67.Nightstalker:IsAvailable() and v13:StealthUp(true, false, true)) then
						return (786 - (222 + 563)) + ((0.05 - 0) * v67.Nightstalker:TalentRank());
					end
					return 1 + 0;
				end
				v66 = 192 - (23 + 167);
			end
			if ((v66 == (1800 - (690 + 1108))) or ((840 + 1488) < (572 + 121))) then
				v70 = nil;
				function v70()
					local v183 = 848 - (40 + 808);
					while true do
						if (((713 + 3615) == (16550 - 12222)) and (v183 == (0 + 0))) then
							if (((841 + 747) >= (731 + 601)) and v67.ImprovedGarrote:IsAvailable() and (v13:BuffUp(v67.ImprovedGarroteAura, nil, true) or v13:BuffUp(v67.ImprovedGarroteBuff, nil, true) or v13:BuffUp(v67.SepsisBuff, nil, true))) then
								return 572.5 - (47 + 524);
							end
							return 1 + 0;
						end
					end
				end
				v66 = 8 - 5;
			end
			if ((v66 == (0 - 0)) or ((9518 - 5344) > (5974 - (1165 + 561)))) then
				v67 = v16.Rogue.Assassination;
				v68 = v16.Rogue.Subtlety;
				v66 = 1 + 0;
			end
			if ((v66 == (12 - 8)) or ((1750 + 2836) <= (561 - (341 + 138)))) then
				v67.CrimsonTempest:RegisterPMultiplier(v69);
				break;
			end
		end
	end
	do
		local v71 = v16(52243 + 141288);
		local v72 = v16(813779 - 419458);
		local v73 = v16(394646 - (89 + 237));
		v30.CPMaxSpend = function()
			return (16 - 11) + ((v71:IsAvailable() and (1 - 0)) or (881 - (581 + 300))) + ((v72:IsAvailable() and (1221 - (855 + 365))) or (0 - 0)) + ((v73:IsAvailable() and (1 + 0)) or (1235 - (1030 + 205)));
		end;
	end
	v30.CPSpend = function()
		return v22(v13:ComboPoints(), v30.CPMaxSpend());
	end;
	do
		local v75 = 0 + 0;
		while true do
			if (((3594 + 269) == (4149 - (156 + 130))) and (v75 == (0 - 0))) then
				v30.AnimachargedCP = function()
					if (v13:BuffUp(v16.Rogue.Commons.EchoingReprimand2) or ((474 - 192) <= (85 - 43))) then
						return 1 + 1;
					elseif (((2688 + 1921) >= (835 - (10 + 59))) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand3)) then
						return 1 + 2;
					elseif (v13:BuffUp(v16.Rogue.Commons.EchoingReprimand4) or ((5673 - 4521) == (3651 - (671 + 492)))) then
						return 4 + 0;
					elseif (((4637 - (369 + 846)) > (887 + 2463)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand5)) then
						return 5 + 0;
					end
					return -(1946 - (1036 + 909));
				end;
				v30.EffectiveComboPoints = function(v184)
					local v185 = 0 + 0;
					while true do
						if (((1471 - 594) > (579 - (11 + 192))) and (v185 == (0 + 0))) then
							if (((v184 == (177 - (135 + 40))) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand2)) or ((v184 == (6 - 3)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand3)) or ((v184 == (3 + 1)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand4)) or ((v184 == (10 - 5)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand5)) or ((4674 - 1556) <= (2027 - (50 + 126)))) then
								return 19 - 12;
							end
							return v184;
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
		v30.Poisoned = function(v119)
			return ((v119:DebuffUp(v76) or v119:DebuffUp(v78) or v119:DebuffUp(v79) or v119:DebuffUp(v77) or v119:DebuffUp(v80)) and true) or false;
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
			if ((v82 == (1414 - (1233 + 180))) or ((1134 - (522 + 447)) >= (4913 - (107 + 1314)))) then
				v85 = v16.Rogue.Assassination.Rupture;
				v86 = v16.Rogue.Assassination.RuptureDeathmark;
				v82 = 1 + 1;
			end
			if (((12032 - 8083) < (2063 + 2793)) and (v82 == (0 - 0))) then
				v83 = v16.Rogue.Assassination.Garrote;
				v84 = v16.Rogue.Assassination.GarroteDeathmark;
				v82 = 3 - 2;
			end
			if ((v82 == (1912 - (716 + 1194))) or ((74 + 4202) < (324 + 2692))) then
				v87 = v16.Rogue.Assassination.InternalBleeding;
				v88 = 503 - (74 + 429);
				v82 = 5 - 2;
			end
			if (((2325 + 2365) > (9442 - 5317)) and (v82 == (3 + 0))) then
				v30.PoisonedBleeds = function()
					local v186 = 0 - 0;
					while true do
						if ((v186 == (0 - 0)) or ((483 - (279 + 154)) >= (1674 - (454 + 324)))) then
							v88 = 0 + 0;
							for v229, v230 in v23(v13:GetEnemiesInRange(67 - (12 + 5))) do
								if (v30.Poisoned(v230) or ((925 + 789) >= (7536 - 4578))) then
									local v238 = 0 + 0;
									while true do
										if (((1094 - (277 + 816)) == v238) or ((6371 - 4880) < (1827 - (1058 + 125)))) then
											if (((132 + 572) < (1962 - (815 + 160))) and v230:DebuffUp(v87)) then
												v88 = v88 + (4 - 3);
											end
											break;
										end
										if (((8825 - 5107) > (455 + 1451)) and (v238 == (0 - 0))) then
											if (v230:DebuffUp(v83) or ((2856 - (41 + 1857)) > (5528 - (1222 + 671)))) then
												local v243 = 0 - 0;
												while true do
													if (((5032 - 1531) <= (5674 - (229 + 953))) and (v243 == (1774 - (1111 + 663)))) then
														v88 = v88 + (1580 - (874 + 705));
														if (v230:DebuffUp(v84) or ((482 + 2960) < (1739 + 809))) then
															v88 = v88 + (1 - 0);
														end
														break;
													end
												end
											end
											if (((81 + 2794) >= (2143 - (642 + 37))) and v230:DebuffUp(v85)) then
												local v244 = 0 + 0;
												while true do
													if (((0 + 0) == v244) or ((12044 - 7247) >= (5347 - (233 + 221)))) then
														v88 = v88 + (2 - 1);
														if (v230:DebuffUp(v86) or ((485 + 66) > (3609 - (718 + 823)))) then
															v88 = v88 + 1 + 0;
														end
														break;
													end
												end
											end
											v238 = 806 - (266 + 539);
										end
									end
								end
							end
							v186 = 2 - 1;
						end
						if (((3339 - (636 + 589)) > (2240 - 1296)) and (v186 == (1 - 0))) then
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
		v30.RtBRemains = function(v120)
			local v121 = 0 + 0;
			local v122;
			while true do
				if (((0 + 0) == v121) or ((3277 - (657 + 358)) >= (8197 - 5101))) then
					v122 = (v89 - v29()) - v10.RecoveryOffset(v120);
					return ((v122 >= (0 - 0)) and v122) or (1187 - (1151 + 36));
				end
			end
		end;
		v10:RegisterForSelfCombatEvent(function(v123, v123, v123, v123, v123, v123, v123, v123, v123, v123, v123, v124)
			if ((v124 == (304681 + 10827)) or ((593 + 1662) >= (10562 - 7025))) then
				v89 = v29() + (1862 - (1552 + 280));
			end
		end, "SPELL_AURA_APPLIED");
		v10:RegisterForSelfCombatEvent(function(v125, v125, v125, v125, v125, v125, v125, v125, v125, v125, v125, v126)
			if ((v126 == (316342 - (64 + 770))) or ((2606 + 1231) < (2964 - 1658))) then
				v89 = v29() + v22(8 + 32, (1273 - (157 + 1086)) + v30.RtBRemains(true));
			end
		end, "SPELL_AURA_REFRESH");
		v10:RegisterForSelfCombatEvent(function(v127, v127, v127, v127, v127, v127, v127, v127, v127, v127, v127, v128)
			if (((5904 - 2954) == (12920 - 9970)) and (v128 == (483983 - 168475))) then
				v89 = v29();
			end
		end, "SPELL_AURA_REMOVED");
	end
	do
		local v91 = 0 - 0;
		local v92;
		while true do
			if ((v91 == (821 - (599 + 220))) or ((9404 - 4681) < (5229 - (1813 + 118)))) then
				v10:RegisterForSelfCombatEvent(function(v187, v187, v187, v187, v187, v187, v187, v188, v187, v187, v187, v189)
					if (((831 + 305) >= (1371 - (841 + 376))) and (v189 == (281378 - 80572))) then
						for v226, v227 in v23(v92) do
							for v231, v232 in v23(v227) do
								if ((v231 == v188) or ((63 + 208) > (12959 - 8211))) then
									v227[v231] = true;
								end
							end
						end
					end
				end, "SPELL_CAST_SUCCESS");
				v10:RegisterForSelfCombatEvent(function(v190, v190, v190, v190, v190, v190, v190, v191, v190, v190, v190, v192)
					if (((5599 - (464 + 395)) >= (8089 - 4937)) and (v192 == (58307 + 63104))) then
						v92.CrimsonTempest[v191] = false;
					elseif ((v192 == (1540 - (467 + 370))) or ((5327 - 2749) >= (2489 + 901))) then
						v92.Garrote[v191] = false;
					elseif (((140 - 99) <= (260 + 1401)) and (v192 == (4520 - 2577))) then
						v92.Rupture[v191] = false;
					end
				end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
				v91 = 523 - (150 + 370);
			end
			if (((1883 - (74 + 1208)) < (8756 - 5196)) and (v91 == (14 - 11))) then
				v10:RegisterForSelfCombatEvent(function(v193, v193, v193, v193, v193, v193, v193, v194, v193, v193, v193, v195)
					if (((168 + 67) < (1077 - (14 + 376))) and (v195 == (210588 - 89177))) then
						if (((2944 + 1605) > (1013 + 140)) and (v92.CrimsonTempest[v194] ~= nil)) then
							v92.CrimsonTempest[v194] = nil;
						end
					elseif ((v195 == (671 + 32)) or ((13695 - 9021) < (3515 + 1157))) then
						if (((3746 - (23 + 55)) < (10809 - 6248)) and (v92.Garrote[v194] ~= nil)) then
							v92.Garrote[v194] = nil;
						end
					elseif ((v195 == (1297 + 646)) or ((409 + 46) == (5589 - 1984))) then
						if ((v92.Rupture[v194] ~= nil) or ((838 + 1825) == (4213 - (652 + 249)))) then
							v92.Rupture[v194] = nil;
						end
					end
				end, "SPELL_AURA_REMOVED");
				v10:RegisterForCombatEvent(function(v196, v196, v196, v196, v196, v196, v196, v197)
					if (((11445 - 7168) <= (6343 - (708 + 1160))) and (v92.CrimsonTempest[v197] ~= nil)) then
						v92.CrimsonTempest[v197] = nil;
					end
					if ((v92.Garrote[v197] ~= nil) or ((2361 - 1491) == (2167 - 978))) then
						v92.Garrote[v197] = nil;
					end
					if (((1580 - (10 + 17)) <= (704 + 2429)) and (v92.Rupture[v197] ~= nil)) then
						v92.Rupture[v197] = nil;
					end
				end, "UNIT_DIED", "UNIT_DESTROYED");
				break;
			end
			if ((v91 == (1732 - (1400 + 332))) or ((4290 - 2053) >= (5419 - (242 + 1666)))) then
				v92 = {CrimsonTempest={},Garrote={},Rupture={}};
				v30.Exsanguinated = function(v198, v199)
					local v200 = 0 + 0;
					local v201;
					local v202;
					while true do
						if ((v200 == (1 + 0)) or ((1129 + 195) > (3960 - (850 + 90)))) then
							v202 = v199:ID();
							if ((v202 == (212647 - 91236)) or ((4382 - (360 + 1030)) == (1665 + 216))) then
								return v92.CrimsonTempest[v201] or false;
							elseif (((8766 - 5660) > (2098 - 572)) and (v202 == (2364 - (909 + 752)))) then
								return v92.Garrote[v201] or false;
							elseif (((4246 - (109 + 1114)) < (7085 - 3215)) and (v202 == (757 + 1186))) then
								return v92.Rupture[v201] or false;
							end
							v200 = 244 - (6 + 236);
						end
						if (((91 + 52) > (60 + 14)) and (v200 == (4 - 2))) then
							return false;
						end
						if (((31 - 13) < (3245 - (1076 + 57))) and (v200 == (0 + 0))) then
							v201 = v198:GUID();
							if (((1786 - (579 + 110)) <= (129 + 1499)) and not v201) then
								return false;
							end
							v200 = 1 + 0;
						end
					end
				end;
				v91 = 1 + 0;
			end
			if (((5037 - (174 + 233)) == (12932 - 8302)) and (v91 == (1 - 0))) then
				v30.WillLoseExsanguinate = function(v203, v204)
					if (((1575 + 1965) > (3857 - (663 + 511))) and v30.Exsanguinated(v203, v204)) then
						return true;
					end
					return false;
				end;
				v30.ExsanguinatedRate = function(v205, v206)
					if (((4277 + 517) >= (712 + 2563)) and v30.Exsanguinated(v205, v206)) then
						return 5 - 3;
					end
					return 1 + 0;
				end;
				v91 = 4 - 2;
			end
		end
	end
	do
		local v93 = v16(473577 - 277950);
		local v94 = 0 + 0;
		local v95 = v29();
		v30.FanTheHammerCP = function()
			if (((2887 - 1403) == (1058 + 426)) and ((v29() - v95) < (0.5 + 0)) and (v94 > (722 - (478 + 244)))) then
				if (((1949 - (440 + 77)) < (1617 + 1938)) and (v94 > v13:ComboPoints())) then
					return v94;
				else
					v94 = 0 - 0;
				end
			end
			return 1556 - (655 + 901);
		end;
		v10:RegisterForSelfCombatEvent(function(v129, v129, v129, v129, v129, v129, v129, v129, v129, v129, v129, v130, v129, v129, v131, v132)
			if ((v130 == (34448 + 151315)) or ((816 + 249) > (2416 + 1162))) then
				if (((v29() - v95) > (0.5 - 0)) or ((6240 - (695 + 750)) < (4804 - 3397))) then
					local v212 = 0 - 0;
					while true do
						if (((7452 - 5599) < (5164 - (285 + 66))) and (v212 == (0 - 0))) then
							v94 = v22(v30.CPMaxSpend(), v13:ComboPoints() + v131 + (v25(1310 - (682 + 628), v131 - (1 + 0)) * v22(301 - (176 + 123), v13:BuffStack(v93) - (1 + 0))));
							v95 = v29();
							break;
						end
					end
				end
			end
		end, "SPELL_ENERGIZE");
	end
	do
		local v97, v98 = 0 + 0, 269 - (239 + 30);
		local v99 = v16(75553 + 202372);
		v30.TimeToNextTornado = function()
			if (not v13:BuffUp(v99, nil, true) or ((2712 + 109) < (4302 - 1871))) then
				return 0 - 0;
			end
			local v133 = v13:BuffRemains(v99, nil, true) % (316 - (306 + 9));
			if ((v29() == v97) or ((10028 - 7154) < (380 + 1801))) then
				return 0 + 0;
			elseif ((((v29() - v97) < (0.1 + 0)) and (v133 < (0.25 - 0))) or ((4064 - (1140 + 235)) <= (219 + 124))) then
				return 1 + 0;
			elseif ((((v133 > (0.9 + 0)) or (v133 == (52 - (33 + 19)))) and ((v29() - v97) > (0.75 + 0))) or ((5601 - 3732) == (886 + 1123))) then
				return 0.1 - 0;
			end
			return v133;
		end;
		v10:RegisterForSelfCombatEvent(function(v134, v134, v134, v134, v134, v134, v134, v134, v134, v134, v134, v135)
			if ((v135 == (199485 + 13258)) or ((4235 - (586 + 103)) < (212 + 2110))) then
				v97 = v29();
			elseif ((v135 == (609068 - 411233)) or ((3570 - (1309 + 179)) == (8616 - 3843))) then
				v98 = v29();
			end
			if (((1412 + 1832) > (2833 - 1778)) and (v98 == v97)) then
				v97 = 0 + 0;
			end
		end, "SPELL_CAST_SUCCESS");
	end
	do
		local v101 = {Counter=(0 - 0),LastMH=(0 - 0),LastOH=(609 - (295 + 314))};
		v30.TimeToSht = function(v136)
			if ((v101.Counter >= v136) or ((8137 - 4824) <= (3740 - (1300 + 662)))) then
				return 0 - 0;
			end
			local v137, v138 = v28("player");
			local v139 = v25(v101.LastMH + v137, v29());
			local v140 = v25(v101.LastOH + v138, v29());
			local v141 = {};
			for v159 = 1755 - (1178 + 577), 2 + 0 do
				local v160 = 0 - 0;
				while true do
					if ((v160 == (1405 - (851 + 554))) or ((1257 + 164) >= (5834 - 3730))) then
						v27(v141, v139 + (v159 * v137));
						v27(v141, v140 + (v159 * v138));
						break;
					end
				end
			end
			table.sort(v141);
			local v142 = v22(10 - 5, v25(303 - (115 + 187), v136 - v101.Counter));
			return v141[v142] - v29();
		end;
		v10:RegisterForSelfCombatEvent(function()
			v101.Counter = 0 + 0;
			v101.LastMH = v29();
			v101.LastOH = v29();
		end, "PLAYER_ENTERING_WORLD");
		v10:RegisterForSelfCombatEvent(function(v146, v146, v146, v146, v146, v146, v146, v146, v146, v146, v146, v147)
			if (((1716 + 96) <= (12803 - 9554)) and (v147 == (198072 - (160 + 1001)))) then
				v101.Counter = 0 + 0;
			end
		end, "SPELL_ENERGIZE");
		v10:RegisterForSelfCombatEvent(function(v148, v148, v148, v148, v148, v148, v148, v148, v148, v148, v148, v148, v148, v148, v148, v148, v148, v148, v148, v148, v148, v148, v148, v149)
			local v150 = 0 + 0;
			while true do
				if (((3322 - 1699) <= (2315 - (237 + 121))) and (v150 == (897 - (525 + 372)))) then
					v101.Counter = v101.Counter + (1 - 0);
					if (((14495 - 10083) == (4554 - (96 + 46))) and v149) then
						v101.LastOH = v29();
					else
						v101.LastMH = v29();
					end
					break;
				end
			end
		end, "SWING_DAMAGE");
		v10:RegisterForSelfCombatEvent(function(v151, v151, v151, v151, v151, v151, v151, v151, v151, v151, v151, v151, v151, v151, v151, v152)
			if (((2527 - (643 + 134)) >= (304 + 538)) and v152) then
				v101.LastOH = v29();
			else
				v101.LastMH = v29();
			end
		end, "SWING_MISSED");
	end
	do
		local v103 = v13:CritChancePct();
		local v104 = 0 - 0;
		local function v105()
			local v153 = 0 - 0;
			while true do
				if (((4193 + 179) > (3630 - 1780)) and (v153 == (1 - 0))) then
					if (((951 - (316 + 403)) < (546 + 275)) and (v104 > (0 - 0))) then
						v24.After(2 + 1, v105);
					end
					break;
				end
				if (((1304 - 786) < (640 + 262)) and (v153 == (0 + 0))) then
					if (((10373 - 7379) > (4097 - 3239)) and not v13:AffectingCombat()) then
						v103 = v13:CritChancePct();
						v10.Debug("Base Crit Set to: " .. v103);
					end
					if ((v104 == nil) or (v104 < (0 - 0)) or ((215 + 3540) <= (1801 - 886))) then
						v104 = 0 + 0;
					else
						v104 = v104 - (2 - 1);
					end
					v153 = 18 - (12 + 5);
				end
			end
		end
		v10:RegisterForEvent(function()
			if (((15326 - 11380) > (7985 - 4242)) and (v104 == (0 - 0))) then
				v24.After(7 - 4, v105);
				v104 = 1 + 1;
			end
		end, "PLAYER_EQUIPMENT_CHANGED");
		v30.BaseAttackCrit = function()
			return v103;
		end;
	end
	do
		local v107 = 1973 - (1656 + 317);
		local v108;
		local v109;
		local v110;
		local v111;
		while true do
			if ((v107 == (3 + 0)) or ((1070 + 265) >= (8790 - 5484))) then
				v108.Rupture:RegisterPMultiplier(v110, {v109.FinalityRuptureBuff,(4.3 - 3)});
				v108.Garrote:RegisterPMultiplier(v110, v111);
				break;
			end
			if (((6115 - (266 + 1005)) > (1485 + 768)) and (v107 == (6 - 4))) then
				v111 = nil;
				function v111()
					local v208 = 0 - 0;
					while true do
						if (((2148 - (561 + 1135)) == (588 - 136)) and (v208 == (0 - 0))) then
							if ((v108.ImprovedGarrote:IsAvailable() and (v13:BuffUp(v108.ImprovedGarroteAura, nil, true) or v13:BuffUp(v108.ImprovedGarroteBuff, nil, true) or v13:BuffUp(v108.SepsisBuff, nil, true))) or ((5623 - (507 + 559)) < (5236 - 3149))) then
								return 3.5 - 2;
							end
							return 389 - (212 + 176);
						end
					end
				end
				v107 = 908 - (250 + 655);
			end
			if (((10563 - 6689) == (6768 - 2894)) and (v107 == (0 - 0))) then
				v108 = v16.Rogue.Assassination;
				v109 = v16.Rogue.Subtlety;
				v107 = 1957 - (1869 + 87);
			end
			if ((v107 == (3 - 2)) or ((3839 - (484 + 1417)) > (10577 - 5642))) then
				v110 = nil;
				function v110()
					if ((v108.Nightstalker:IsAvailable() and v13:StealthUp(true, false, true)) or ((7130 - 2875) < (4196 - (48 + 725)))) then
						return (1 - 0) + ((0.05 - 0) * v108.Nightstalker:TalentRank());
					end
					return 1 + 0;
				end
				v107 = 4 - 2;
			end
		end
	end
end;
return v0["Epix_Rogue_Rogue.lua"]();

