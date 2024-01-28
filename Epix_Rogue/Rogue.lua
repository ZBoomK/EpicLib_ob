local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((339 + 715) > (5290 - (260 + 1638)))) then
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
	if (not v15.Rogue or ((1116 - (382 + 58)) >= (5267 - 3625))) then
		v15.Rogue = {};
	end
	v15.Rogue.Commons = {Sanguine=v15(188220 + 38290, nil, 1 - 0),AncestralCall=v15(816687 - 541949, nil, 1207 - (902 + 303)),ArcanePulse=v15(571665 - 311301, nil, 6 - 3),ArcaneTorrent=v15(2153 + 22893, nil, 1694 - (1121 + 569)),BagofTricks=v15(312625 - (22 + 192), nil, 688 - (483 + 200)),Berserking=v15(27760 - (1404 + 59), nil, 16 - 10),BloodFury=v15(27648 - 7076, nil, 772 - (468 + 297)),Fireblood=v15(265783 - (334 + 228), nil, 26 - 18),LightsJudgment=v15(592566 - 336919, nil, 15 - 6),Shadowmeld=v15(16750 + 42234, nil, 246 - (141 + 95)),CloakofShadows=v15(30672 + 552, nil, 28 - 17),CrimsonVial=v15(445471 - 260160, nil, 3 + 9),Evasion=v15(14458 - 9181, nil, 10 + 3),Feint=v15(1024 + 942, nil, 19 - 5),Blind=v15(1236 + 858, nil, 178 - (92 + 71)),CheapShot=v15(906 + 927, nil, 26 - 10),Kick=v15(2531 - (574 + 191), nil, 15 + 2),KidneyShot=v15(1021 - 613, nil, 10 + 8),Sap=v15(7619 - (254 + 595), nil, 145 - (55 + 71)),Shiv=v15(7822 - 1884, nil, 1810 - (573 + 1217)),SliceandDice=v15(873741 - 558245, nil, 2 + 19),Shadowstep=v15(58902 - 22348, nil, 961 - (714 + 225)),Sprint=v15(8717 - 5734, nil, 31 - 8),TricksoftheTrade=v15(6273 + 51661, nil, 34 - 10),CripplingPoison=v15(4214 - (118 + 688), nil, 73 - (25 + 23)),DeadlyPoison=v15(547 + 2276, nil, 1912 - (927 + 959)),InstantPoison=v15(1063801 - 748217, nil, 759 - (16 + 716)),AmplifyingPoison=v15(736766 - 355102, nil, 125 - (11 + 86)),NumbingPoison=v15(14051 - 8290, nil, 314 - (175 + 110)),WoundPoison=v15(21912 - 13233, nil, 147 - 117),AtrophicPoison=v15(383433 - (503 + 1293), nil, 86 - 55),AcrobaticStrikes=v15(142408 + 54516, nil, 1093 - (810 + 251)),Alacrity=v15(134312 + 59227, nil, 11 + 22),ColdBlood=v15(344576 + 37669, nil, 567 - (43 + 490)),DeeperStratagem=v15(194264 - (711 + 22)),EchoingReprimand=v15(1491642 - 1106026, nil, 895 - (240 + 619)),EchoingReprimand2=v15(78079 + 245479, nil, 58 - 21),EchoingReprimand3=v15(21414 + 302145, nil, 1782 - (1344 + 400)),EchoingReprimand4=v15(323965 - (255 + 150), nil, 31 + 8),EchoingReprimand5=v15(189972 + 164866, nil, 170 - 130),FindWeakness=v15(293996 - 202973, nil, 1780 - (404 + 1335)),FindWeaknessDebuff=v15(316626 - (183 + 223), nil, 50 - 8),ImprovedAmbush=v15(252857 + 128763, nil, 16 + 27),MarkedforDeath=v15(137956 - (10 + 327), nil, 31 + 13),Nightstalker=v15(14400 - (118 + 220), nil, 15 + 30),ResoundingClarity=v15(382071 - (108 + 341), nil, 21 + 25),SealFate=v15(59992 - 45802, nil, 1540 - (711 + 782)),Sepsis=v15(738839 - 353431, nil, 517 - (270 + 199)),SepsisBuff=v15(121875 + 254064, nil, 1868 - (580 + 1239)),ShadowDance=v15(550896 - 365583, nil, 48 + 2),ShadowDanceTalent=v15(14188 + 380742, nil, 23 + 28),ShadowDanceBuff=v15(484131 - 298709),Subterfuge=v15(67225 + 40983, nil, 1220 - (645 + 522)),SubterfugeBuff=v15(116982 - (1010 + 780), nil, 54 + 0),ThistleTea=v15(1818017 - 1436394, nil, 937 - 617),Vigor=v15(16819 - (1045 + 791)),Stealth=v15(4515 - 2731, nil, 86 - 29),Stealth2=v15(115696 - (351 + 154), nil, 1632 - (1281 + 293)),Vanish=v15(2122 - (28 + 238), nil, 131 - 72),VanishBuff=v15(12886 - (1381 + 178), nil, 57 + 3),VanishBuff2=v15(92885 + 22308, nil, 27 + 34),PoolEnergy=v15(3447108 - 2447198, nil, 33 + 29)};
	v15.Rogue.Assassination = v18(v15.Rogue.Commons, {Ambush=v15(9146 - (381 + 89), nil, 56 + 7),AmbushOverride=v15(290820 + 139203),AmplifyingPoisonDebuff=v15(656783 - 273369, nil, 1220 - (1074 + 82)),AmplifyingPoisonDebuffDeathmark=v15(864160 - 469832, nil, 1849 - (214 + 1570)),CripplingPoisonDebuff=v15(4864 - (990 + 465), nil, 28 + 38),DeadlyPoisonDebuff=v15(1227 + 1591, nil, 66 + 1),DeadlyPoisonDebuffDeathmark=v15(1551873 - 1157549, nil, 1794 - (1668 + 58)),Envenom=v15(33271 - (512 + 114), nil, 179 - 110),FanofKnives=v15(106928 - 55205, nil, 243 - 173),Garrote=v15(328 + 375, nil, 14 + 57),GarroteDeathmark=v15(313683 + 47147, nil, 242 - 170),Mutilate=v15(3323 - (109 + 1885), nil, 1542 - (1269 + 200)),PoisonedKnife=v15(355673 - 170108, nil, 889 - (98 + 717)),Rupture=v15(2769 - (802 + 24), nil, 129 - 54),RuptureDeathmark=v15(455706 - 94880, nil, 12 + 64),WoundPoisonDebuff=v15(6670 + 2010, nil, 13 + 64),ArterialPrecision=v15(86452 + 314331, nil, 216 - 138),AtrophicPoisonDebuff=v15(1308520 - 916132, nil, 29 + 50),BlindsideBuff=v15(49317 + 71836, nil, 66 + 14),CausticSpatter=v15(306832 + 115143),CausticSpatterDebuff=v15(197015 + 224961),CrimsonTempest=v15(122844 - (797 + 636), nil, 393 - 312),CutToTheChase=v15(53286 - (1427 + 192), nil, 29 + 53),DashingScoundrel=v15(886446 - 504649, nil, 75 + 8),Deathmark=v15(163234 + 196960, nil, 410 - (192 + 134)),Doomblade=v15(382949 - (316 + 960), nil, 48 + 37),DragonTemperedBlades=v15(294642 + 87159, nil, 80 + 6),Elusiveness=v15(302047 - 223039),Exsanguinate=v15(201357 - (83 + 468), nil, 1894 - (1202 + 604)),ImprovedGarrote=v15(1781531 - 1399899, nil, 147 - 58),ImprovedGarroteBuff=v15(1086455 - 694054, nil, 415 - (45 + 280)),ImprovedGarroteAura=v15(378745 + 13658, nil, 80 + 11),IndiscriminateCarnage=v15(139412 + 242390, nil, 51 + 41),IndiscriminateCarnageAura=v15(67851 + 317903),IndiscriminateCarnageBuff=v15(714315 - 328568),InternalBleeding=v15(156864 - (340 + 1571), nil, 37 + 56),Kingsbane=v15(387399 - (1733 + 39), nil, 258 - 164),LightweightShiv=v15(396017 - (125 + 909)),MasterAssassin=v15(257937 - (1096 + 852), nil, 43 + 52),MasterAssassinBuff=v15(366644 - 109909, nil, 94 + 2),PreyontheWeak=v15(132023 - (409 + 103), nil, 333 - (46 + 190)),PreyontheWeakDebuff=v15(256004 - (51 + 44), nil, 28 + 70),SerratedBoneSpike=v15(386741 - (1114 + 203), nil, 825 - (228 + 498)),SerratedBoneSpikeDebuff=v15(85370 + 308666, nil, 56 + 44),ShivDebuff=v15(320167 - (174 + 489), nil, 263 - 162),VenomRush=v15(154057 - (830 + 1075), nil, 626 - (303 + 221)),ScentOfBlood=v15(383068 - (231 + 1038), nil, 330 + 66),ScentOfBloodBuff=v15(395242 - (171 + 991)),ShroudedSuffocation=v15(1588634 - 1203156)});
	v15.Rogue.Outlaw = v18(v15.Rogue.Commons, {AdrenalineRush=v15(36921 - 23171, nil, 256 - 153),Ambush=v15(6944 + 1732, nil, 364 - 260),AmbushOverride=v15(1240532 - 810509),BetweentheEyes=v15(508318 - 192977, nil, 324 - 219),BladeFlurry=v15(15125 - (111 + 1137), nil, 264 - (91 + 67)),Dispatch=v15(6244 - 4146, nil, 27 + 80),Elusiveness=v15(79531 - (423 + 100)),Opportunity=v15(1374 + 194253),PistolShot=v15(514350 - 328587, nil, 58 + 52),RolltheBones=v15(316279 - (326 + 445), nil, 484 - 373),SinisterStrike=v15(430670 - 237355, nil, 261 - 149),Audacity=v15(382556 - (530 + 181), nil, 994 - (614 + 267)),AudacityBuff=v15(386302 - (19 + 13), nil, 185 - 71),BladeRush=v15(633566 - 361689, nil, 328 - 213),CountTheOdds=v15(99204 + 282778, nil, 203 - 87),Dreadblades=v15(711623 - 368481, nil, 1929 - (1293 + 519)),FanTheHammer=v15(779085 - 397239, nil, 307 - 189),GhostlyStrike=v15(376606 - 179669, nil, 513 - 394),GreenskinsWickers=v15(911253 - 524430, nil, 64 + 56),GreenskinsWickersBuff=v15(80410 + 313721, nil, 280 - 159),HiddenOpportunity=v15(88570 + 294711, nil, 41 + 81),ImprovedAdrenalineRush=v15(247106 + 148316, nil, 1219 - (709 + 387)),ImprovedBetweenTheEyes=v15(237342 - (673 + 1185), nil, 359 - 235),KeepItRolling=v15(1226639 - 844650, nil, 205 - 80),KillingSpree=v15(36972 + 14718, nil, 95 + 31),LoadedDice=v15(345870 - 89700, nil, 32 + 95),LoadedDiceBuff=v15(510783 - 254612, nil, 250 - 122),PreyontheWeak=v15(133391 - (446 + 1434), nil, 1412 - (1040 + 243)),PreyontheWeakDebuff=v15(763790 - 507881, nil, 1977 - (559 + 1288)),QuickDraw=v15(198869 - (609 + 1322), nil, 585 - (13 + 441)),SummarilyDispatched=v15(1427433 - 1045443, nil, 345 - 213),SwiftSlasher=v15(1902468 - 1520480, nil, 5 + 128),TakeEmBySurpriseBuff=v15(1401537 - 1015630, nil, 48 + 86),Weaponmaster=v15(87958 + 112775, nil, 400 - 265),UnderhandedUpperhand=v15(232041 + 192003),DeftManeuvers=v15(702352 - 320474),Crackshot=v15(280115 + 143588),Gouge=v15(988 + 788, nil, 98 + 38),Broadside=v15(162352 + 31004, nil, 135 + 2),BuriedTreasure=v15(200033 - (153 + 280), nil, 398 - 260),GrandMelee=v15(173597 + 19761, nil, 55 + 84),RuthlessPrecision=v15(101188 + 92169, nil, 128 + 12),SkullandCrossbones=v15(144633 + 54970, nil, 214 - 73),TrueBearing=v15(119508 + 73851, nil, 809 - (89 + 578)),ViciousFollowup=v15(282089 + 112790, nil, 296 - 153)});
	v15.Rogue.Subtlety = v18(v15.Rogue.Commons, {Backstab=v15(1102 - (572 + 477), nil, 20 + 124),BlackPowder=v15(191545 + 127630, nil, 18 + 127),Elusiveness=v15(79094 - (84 + 2)),Eviscerate=v15(324371 - 127552, nil, 106 + 41),Rupture=v15(2785 - (497 + 345), nil, 4 + 144),ShadowBlades=v15(20534 + 100937, nil, 1482 - (605 + 728)),Shadowstrike=v15(132307 + 53131, nil, 333 - 183),ShurikenStorm=v15(9067 + 188768, nil, 558 - 407),ShurikenToss=v15(102784 + 11230, nil, 420 - 268),SymbolsofDeath=v15(160285 + 51998, nil, 642 - (457 + 32)),DanseMacabre=v15(162297 + 220231, nil, 1556 - (832 + 570)),DanseMacabreBuff=v15(371154 + 22815, nil, 41 + 114),DeeperDaggers=v15(1353656 - 971139, nil, 76 + 80),DeeperDaggersBuff=v15(384201 - (588 + 208), nil, 422 - 265),DarkBrew=v15(384304 - (884 + 916), nil, 330 - 172),DarkShadow=v15(142454 + 103233, nil, 812 - (232 + 421)),EnvelopingShadows=v15(239993 - (1569 + 320), nil, 40 + 120),Finality=v15(72675 + 309850, nil, 542 - 381),FinalityBlackPowderBuff=v15(386553 - (316 + 289), nil, 423 - 261),FinalityEviscerateBuff=v15(17824 + 368125, nil, 1616 - (666 + 787)),FinalityRuptureBuff=v15(386376 - (360 + 65), nil, 154 + 10),Flagellation=v15(384885 - (79 + 175), nil, 260 - 95),FlagellationPersistBuff=v15(308048 + 86710, nil, 508 - 342),Gloomblade=v15(386631 - 185873, nil, 1066 - (503 + 396)),GoremawsBite=v15(426772 - (92 + 89), nil, 366 - 177),ImprovedShadowDance=v15(202045 + 191927, nil, 100 + 68),ImprovedShurikenStorm=v15(1252973 - 933022, nil, 24 + 145),InvigoratingShadowdust=v15(872201 - 489678),LingeringShadow=v15(333749 + 48775, nil, 82 + 88),LingeringShadowBuff=v15(1175507 - 789547, nil, 22 + 149),MasterofShadows=v15(300391 - 103415, nil, 1416 - (485 + 759)),PerforatedVeins=v15(885101 - 502583, nil, 1362 - (442 + 747)),PerforatedVeinsBuff=v15(395389 - (832 + 303), nil, 1120 - (88 + 858)),PreyontheWeak=v15(40082 + 91429, nil, 145 + 30),PreyontheWeakDebuff=v15(10540 + 245369, nil, 965 - (766 + 23)),Premeditation=v15(1694090 - 1350930, nil, 241 - 64),PremeditationBuff=v15(904160 - 560987, nil, 604 - 426),SecretStratagem=v15(395393 - (1036 + 37), nil, 127 + 52),SecretTechnique=v15(546668 - 265949, nil, 142 + 38),Shadowcraft=v15(428074 - (641 + 839)),ShadowFocus=v15(109122 - (910 + 3), nil, 461 - 280),ShurikenTornado=v15(279609 - (1466 + 218), nil, 84 + 98),SilentStorm=v15(386870 - (556 + 592), nil, 66 + 117),SilentStormBuff=v15(386530 - (329 + 479), nil, 1038 - (174 + 680)),TheFirstDance=v15(1314354 - 931849, nil, 383 - 198),TheRotten=v15(272747 + 109268, nil, 925 - (396 + 343)),TheRottenBuff=v15(34879 + 359324, nil, 1664 - (29 + 1448)),Weaponmaster=v15(194926 - (135 + 1254), nil, 708 - 520)});
	if (((19311 - 15175) > (1598 + 799)) and not v17.Rogue) then
		v17.Rogue = {};
	end
	v17.Rogue.Commons = {AlgetharPuzzleBox=v17(195228 - (389 + 1138), {(13 + 0),(14 + 0)}),ManicGrieftorch=v17(195853 - (320 + 1225), {(8 + 5),(1873 - (821 + 1038))}),WindscarWhetstone=v17(343026 - 205540, {(22 - 9),(34 - 20)}),Healthstone=v17(6538 - (834 + 192)),RefreshingHealingPotion=v17(12168 + 179212)};
	v17.Rogue.Assassination = v18(v17.Rogue.Commons, {AlgetharPuzzleBox=v17(49718 + 143983, {(19 - 6),(4 + 10)}),AshesoftheEmbersoul=v17(542312 - 335145, {(6 + 7),(9 + 5)}),WitherbarksBranch=v17(56888 + 53111, {(7 + 6),(1428 - (1001 + 413))})});
	v17.Rogue.Outlaw = v18(v17.Rogue.Commons, {ManicGrieftorch=v17(433303 - 238995, {(706 - (627 + 66)),(616 - (512 + 90))}),WindscarWhetstone=v17(139392 - (1665 + 241), {(6 + 7),(36 - 22)}),BeaconToTheBeyond=v17(345158 - 141195, {(10 + 3),(1 + 13)}),DragonfireBombDispenser=v17(203846 - (298 + 938), {(1679 - (636 + 1030)),(14 + 0)})});
	v17.Rogue.Subtlety = v18(v17.Rogue.Commons, {ManicGrieftorch=v17(57722 + 136586, {(234 - (55 + 166)),(2 + 12)}),StormEatersBoon=v17(742053 - 547751, {(22 - 9),(6 + 8)}),BeaconToTheBeyond=v17(158477 + 45486, {(34 - (20 + 1)),(333 - (134 + 185))}),AshesoftheEmbersoul=v17(208300 - (549 + 584), {(44 - 31),(8 + 6)}),WitherbarksBranch=v17(111171 - (786 + 386), {(1392 - (1055 + 324)),(13 + 1)}),BandolierOfTwistedBlades=v17(21786 + 185379, {(43 - 30),(34 - 20)}),Mirror=v17(73842 + 133739, {(44 - 31),(35 - 21)})});
	if (not v20.Rogue or ((5022 - (364 + 324)) == (11636 - 7391))) then
		v20.Rogue = {};
	end
	v20.Rogue.Commons = {Healthstone=v20(50 - 29),BlindMouseover=v20(3 + 6),CheapShotMouseover=v20(41 - 31),KickMouseover=v20(17 - 6),KidneyShotMouseover=v20(36 - 24),TricksoftheTradeFocus=v20(1281 - (1249 + 19)),WindscarWhetstone=v20(24 + 2),RefreshingHealingPotion=v20(112 - 83)};
	v20.Rogue.Outlaw = v18(v20.Rogue.Commons, {Dispatch=v20(1100 - (686 + 400)),PistolShotMouseover=v20(12 + 3),SinisterStrikeMouseover=v20(256 - (73 + 156))});
	v20.Rogue.Assassination = v18(v20.Rogue.Commons, {GarroteMouseOver=v20(1 + 27)});
	v20.Rogue.Subtlety = v18(v20.Rogue.Commons, {SecretTechnique=v20(827 - (721 + 90)),ShadowDance=v20(1 + 16),ShadowDanceSymbol=v20(84 - 58),VanishShadowstrike=v20(488 - (224 + 246)),ShurikenStormSD=v20(30 - 11),ShurikenStormVanish=v20(36 - 16),GloombladeSD=v20(4 + 18),GloombladeVanish=v20(1 + 22),BackstabMouseover=v20(18 + 6),RuptureMouseover=v20(49 - 24)});
	v29.StealthSpell = function()
		return (v15.Rogue.Commons.Subterfuge:IsAvailable() and v15.Rogue.Commons.Stealth2) or v15.Rogue.Commons.Stealth;
	end;
	v29.VanishBuffSpell = function()
		return (v15.Rogue.Commons.Subterfuge:IsAvailable() and v15.Rogue.Commons.VanishBuff2) or v15.Rogue.Commons.VanishBuff;
	end;
	v29.Stealth = function(v49, v50)
		local v51 = 0 - 0;
		while true do
			if ((v51 == (513 - (203 + 310))) or ((6269 - (1238 + 755)) <= (212 + 2819))) then
				if ((EpicSettings.Settings['StealthOOC'] and (v15.Rogue.Commons.Stealth:IsCastable() or v15.Rogue.Commons.Stealth2:IsCastable()) and v12:StealthDown()) or ((6316 - (709 + 825)) <= (2208 - 1009))) then
					if (v9.Press(v49, nil) or ((7085 - 2221) < (2766 - (196 + 668)))) then
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
			local v113 = 0 - 0;
			local v114;
			while true do
				if (((10023 - 5184) >= (4533 - (171 + 662))) and (v113 == (93 - (4 + 89)))) then
					v114 = EpicSettings.Settings['CrimsonVialHP'] or (0 - 0);
					if ((v53:IsCastable() and v53:IsReady() and (v12:HealthPercentage() <= v114)) or ((392 + 683) > (8424 - 6506))) then
						if (((156 + 240) <= (5290 - (35 + 1451))) and v9.Cast(v53, nil)) then
							return "Cast Crimson Vial (Defensives)";
						end
					end
					v113 = 1454 - (28 + 1425);
				end
				if ((v113 == (1994 - (941 + 1052))) or ((3998 + 171) == (3701 - (822 + 692)))) then
					return false;
				end
			end
		end;
	end
	do
		local v55 = v15.Rogue.Commons;
		local v56 = v55.Feint;
		v29.Feint = function()
			local v115 = EpicSettings.Settings['FeintHP'] or (0 - 0);
			if (((663 + 743) == (1703 - (45 + 252))) and v56:IsCastable() and v12:BuffDown(v56) and (v12:HealthPercentage() <= v115)) then
				if (((1515 + 16) < (1470 + 2801)) and v9.Cast(v56, nil)) then
					return "Cast Feint (Defensives)";
				end
			end
		end;
	end
	do
		local v58 = 0 - 0;
		local v59;
		local v60;
		local v61;
		while true do
			if (((1068 - (114 + 319)) == (911 - 276)) and ((1 - 0) == v58)) then
				v61 = nil;
				function v61(v143)
					if (((2151 + 1222) <= (5297 - 1741)) and not v12:AffectingCombat() and v12:BuffRefreshable(v143)) then
						if (v9.Press(v143, nil, true) or ((6895 - 3604) < (5243 - (556 + 1407)))) then
							return "poison";
						end
					end
				end
				v58 = 1208 - (741 + 465);
			end
			if (((4851 - (170 + 295)) >= (460 + 413)) and (v58 == (0 + 0))) then
				v59 = 0 - 0;
				v60 = false;
				v58 = 1 + 0;
			end
			if (((591 + 330) <= (625 + 477)) and (v58 == (1232 - (957 + 273)))) then
				v29.Poisons = function()
					v60 = v12:BuffUp(v15.Rogue.Commons.WoundPoison);
					if (((1259 + 3447) >= (386 + 577)) and v15.Rogue.Assassination.DragonTemperedBlades:IsAvailable()) then
						local v200 = v61((v60 and v15.Rogue.Commons.WoundPoison) or v15.Rogue.Commons.DeadlyPoison);
						if (v200 or ((3658 - 2698) <= (2308 - 1432))) then
							return v200;
						end
						if (v15.Rogue.Commons.AmplifyingPoison:IsAvailable() or ((6310 - 4244) == (4614 - 3682))) then
							local v214 = 1780 - (389 + 1391);
							while true do
								if (((3028 + 1797) < (505 + 4338)) and (v214 == (0 - 0))) then
									v200 = v61(v15.Rogue.Commons.AmplifyingPoison);
									if (v200 or ((4828 - (783 + 168)) >= (15227 - 10690))) then
										return v200;
									end
									break;
								end
							end
						else
							v200 = v61(v15.Rogue.Commons.InstantPoison);
							if (v200 or ((4245 + 70) < (2037 - (309 + 2)))) then
								return v200;
							end
						end
					elseif (v60 or ((11297 - 7618) < (1837 - (1090 + 122)))) then
						local v215 = 0 + 0;
						local v216;
						while true do
							if ((v215 == (0 - 0)) or ((3166 + 1459) < (1750 - (628 + 490)))) then
								v216 = v61(v15.Rogue.Commons.WoundPoison);
								if (v216 or ((15 + 68) > (4407 - 2627))) then
									return v216;
								end
								break;
							end
						end
					elseif (((2495 - 1949) <= (1851 - (431 + 343))) and v15.Rogue.Commons.AmplifyingPoison:IsAvailable() and v12:BuffDown(v15.Rogue.Commons.DeadlyPoison)) then
						local v230 = 0 - 0;
						local v231;
						while true do
							if ((v230 == (0 - 0)) or ((787 + 209) > (551 + 3750))) then
								v231 = v61(v15.Rogue.Commons.AmplifyingPoison);
								if (((5765 - (556 + 1139)) > (702 - (6 + 9))) and v231) then
									return v231;
								end
								break;
							end
						end
					elseif (v15.Rogue.Commons.DeadlyPoison:IsAvailable() or ((121 + 535) >= (1706 + 1624))) then
						local v238 = v61(v15.Rogue.Commons.DeadlyPoison);
						if (v238 or ((2661 - (28 + 141)) <= (130 + 205))) then
							return v238;
						end
					else
						local v239 = 0 - 0;
						local v240;
						while true do
							if (((3062 + 1260) >= (3879 - (486 + 831))) and (v239 == (0 - 0))) then
								v240 = v61(v15.Rogue.Commons.InstantPoison);
								if (v240 or ((12804 - 9167) >= (713 + 3057))) then
									return v240;
								end
								break;
							end
						end
					end
					if (v12:BuffDown(v15.Rogue.Commons.CripplingPoison) or ((7522 - 5143) > (5841 - (668 + 595)))) then
						if (v15.Rogue.Commons.AtrophicPoison:IsAvailable() or ((435 + 48) > (150 + 593))) then
							local v217 = 0 - 0;
							local v218;
							while true do
								if (((2744 - (23 + 267)) > (2522 - (1129 + 815))) and (v217 == (387 - (371 + 16)))) then
									v218 = v61(v15.Rogue.Commons.AtrophicPoison);
									if (((2680 - (1326 + 424)) < (8443 - 3985)) and v218) then
										return v218;
									end
									break;
								end
							end
						elseif (((2419 - 1757) <= (1090 - (88 + 30))) and v15.Rogue.Commons.NumbingPoison:IsAvailable()) then
							local v232 = v61(v15.Rogue.Commons.NumbingPoison);
							if (((5141 - (720 + 51)) == (9721 - 5351)) and v232) then
								return v232;
							end
						else
							local v233 = 1776 - (421 + 1355);
							local v234;
							while true do
								if (((0 - 0) == v233) or ((2340 + 2422) <= (1944 - (286 + 797)))) then
									v234 = v61(v15.Rogue.Commons.CripplingPoison);
									if (v234 or ((5161 - 3749) == (7062 - 2798))) then
										return v234;
									end
									break;
								end
							end
						end
					else
						local v201 = 439 - (397 + 42);
						local v202;
						while true do
							if ((v201 == (0 + 0)) or ((3968 - (24 + 776)) < (3316 - 1163))) then
								v202 = v61(v15.Rogue.Commons.CripplingPoison);
								if (v202 or ((5761 - (222 + 563)) < (2934 - 1602))) then
									return v202;
								end
								break;
							end
						end
					end
				end;
				break;
			end
		end
	end
	v29.MfDSniping = function(v62)
		if (((3333 + 1295) == (4818 - (23 + 167))) and v62:IsCastable()) then
			local v121, v122 = nil, 1858 - (690 + 1108);
			local v123 = (v14:IsInRange(11 + 19) and v14:TimeToDie()) or (9165 + 1946);
			for v125, v126 in v22(v12:GetEnemiesInRange(878 - (40 + 808))) do
				local v127 = 0 + 0;
				local v128;
				while true do
					if (((0 - 0) == v127) or ((52 + 2) == (209 + 186))) then
						v128 = v126:TimeToDie();
						if (((45 + 37) == (653 - (47 + 524))) and not v126:IsMfDBlacklisted() and (v128 < (v12:ComboPointsDeficit() * (1.5 + 0))) and (v128 < v122)) then
							if (((v123 - v128) > (2 - 1)) or ((868 - 287) < (642 - 360))) then
								v121, v122 = v126, v128;
							else
								v121, v122 = v14, v123;
							end
						end
						break;
					end
				end
			end
			if ((v121 and (v121:GUID() ~= v13:GUID())) or ((6335 - (1165 + 561)) < (75 + 2420))) then
				v9.Press(v121, v62);
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
			if (((3567 - 2415) == (440 + 712)) and v65.Nightstalker:IsAvailable() and v12:StealthUp(true, false, true)) then
				return (480 - (341 + 138)) + ((0.05 + 0) * v65.Nightstalker:TalentRank());
			end
			return 1 - 0;
		end
		local function v68()
			local v116 = 326 - (89 + 237);
			while true do
				if (((6099 - 4203) <= (7203 - 3781)) and ((881 - (581 + 300)) == v116)) then
					if ((v65.ImprovedGarrote:IsAvailable() and (v12:BuffUp(v65.ImprovedGarroteAura, nil, true) or v12:BuffUp(v65.ImprovedGarroteBuff, nil, true) or v12:BuffUp(v65.SepsisBuff, nil, true))) or ((2210 - (855 + 365)) > (3847 - 2227))) then
						return 1.5 + 0;
					end
					return 1236 - (1030 + 205);
				end
			end
		end
		v65.Rupture:RegisterPMultiplier(v67, {v66.FinalityRuptureBuff,(287.3 - (156 + 130))});
		v65.Garrote:RegisterPMultiplier(v67, v68);
		v65.CrimsonTempest:RegisterPMultiplier(v67);
	end
	do
		local v69 = v15(439740 - 246209);
		local v70 = v15(664587 - 270266);
		local v71 = v15(807612 - 413292);
		v29.CPMaxSpend = function()
			return 2 + 3 + ((v69:IsAvailable() and (1 + 0)) or (69 - (10 + 59))) + ((v70:IsAvailable() and (1 + 0)) or (0 - 0)) + ((v71:IsAvailable() and (1164 - (671 + 492))) or (0 + 0));
		end;
	end
	v29.CPSpend = function()
		return v21(v12:ComboPoints(), v29.CPMaxSpend());
	end;
	do
		v29.AnimachargedCP = function()
			if (v12:BuffUp(v15.Rogue.Commons.EchoingReprimand2) or ((2092 - (369 + 846)) > (1243 + 3452))) then
				return 2 + 0;
			elseif (((4636 - (1036 + 909)) >= (1472 + 379)) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand3)) then
				return 4 - 1;
			elseif (v12:BuffUp(v15.Rogue.Commons.EchoingReprimand4) or ((3188 - (11 + 192)) >= (2454 + 2402))) then
				return 179 - (135 + 40);
			elseif (((10359 - 6083) >= (721 + 474)) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand5)) then
				return 10 - 5;
			end
			return -(1 - 0);
		end;
		v29.EffectiveComboPoints = function(v117)
			local v118 = 176 - (50 + 126);
			while true do
				if (((8999 - 5767) <= (1039 + 3651)) and (v118 == (1413 - (1233 + 180)))) then
					if (((v117 == (971 - (522 + 447))) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand2)) or ((v117 == (1424 - (107 + 1314))) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand3)) or ((v117 == (2 + 2)) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand4)) or ((v117 == (15 - 10)) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand5)) or ((381 + 515) >= (6247 - 3101))) then
						return 27 - 20;
					end
					return v117;
				end
			end
		end;
	end
	do
		local v75 = 1910 - (716 + 1194);
		local v76;
		local v77;
		local v78;
		local v79;
		local v80;
		while true do
			if (((53 + 3008) >= (317 + 2641)) and (v75 == (505 - (74 + 429)))) then
				v80 = v15.Rogue.Assassination.AtrophicPoisonDebuff;
				v29.Poisoned = function(v144)
					return ((v144:DebuffUp(v76) or v144:DebuffUp(v78) or v144:DebuffUp(v79) or v144:DebuffUp(v77) or v144:DebuffUp(v80)) and true) or false;
				end;
				break;
			end
			if (((6147 - 2960) >= (320 + 324)) and (v75 == (2 - 1))) then
				v78 = v15.Rogue.Assassination.AmplifyingPoisonDebuff;
				v79 = v15.Rogue.Assassination.CripplingPoisonDebuff;
				v75 = 2 + 0;
			end
			if (((1985 - 1341) <= (1740 - 1036)) and (v75 == (433 - (279 + 154)))) then
				v76 = v15.Rogue.Assassination.DeadlyPoisonDebuff;
				v77 = v15.Rogue.Assassination.WoundPoisonDebuff;
				v75 = 779 - (454 + 324);
			end
		end
	end
	do
		local v81 = v15.Rogue.Assassination.Garrote;
		local v82 = v15.Rogue.Assassination.GarroteDeathmark;
		local v83 = v15.Rogue.Assassination.Rupture;
		local v84 = v15.Rogue.Assassination.RuptureDeathmark;
		local v85 = v15.Rogue.Assassination.InternalBleeding;
		local v86 = 0 + 0;
		v29.PoisonedBleeds = function()
			local v119 = 17 - (12 + 5);
			while true do
				if (((517 + 441) > (2412 - 1465)) and (v119 == (1 + 0))) then
					return v86;
				end
				if (((5585 - (277 + 816)) >= (11340 - 8686)) and (v119 == (1183 - (1058 + 125)))) then
					v86 = 0 + 0;
					for v198, v199 in v22(v12:GetEnemiesInRange(1025 - (815 + 160))) do
						if (((14768 - 11326) >= (3567 - 2064)) and v29.Poisoned(v199)) then
							local v207 = 0 + 0;
							while true do
								if ((v207 == (0 - 0)) or ((5068 - (41 + 1857)) <= (3357 - (1222 + 671)))) then
									if (v199:DebuffUp(v81) or ((12398 - 7601) == (6307 - 1919))) then
										v86 = v86 + (1183 - (229 + 953));
										if (((2325 - (1111 + 663)) <= (2260 - (874 + 705))) and v199:DebuffUp(v82)) then
											v86 = v86 + 1 + 0;
										end
									end
									if (((2236 + 1041) > (845 - 438)) and v199:DebuffUp(v83)) then
										v86 = v86 + 1 + 0;
										if (((5374 - (642 + 37)) >= (323 + 1092)) and v199:DebuffUp(v84)) then
											v86 = v86 + 1 + 0;
										end
									end
									v207 = 2 - 1;
								end
								if ((v207 == (455 - (233 + 221))) or ((7427 - 4215) <= (831 + 113))) then
									if (v199:DebuffUp(v85) or ((4637 - (718 + 823)) <= (1132 + 666))) then
										v86 = v86 + (806 - (266 + 539));
									end
									break;
								end
							end
						end
					end
					v119 = 2 - 1;
				end
			end
		end;
	end
	do
		local v88 = 1225 - (636 + 589);
		local v89;
		while true do
			if (((8395 - 4858) == (7295 - 3758)) and (v88 == (0 + 0))) then
				v89 = v28();
				v29.RtBRemains = function(v145)
					local v146 = (v89 - v28()) - v9.RecoveryOffset(v145);
					return ((v146 >= (0 + 0)) and v146) or (1015 - (657 + 358));
				end;
				v88 = 2 - 1;
			end
			if (((8741 - 4904) >= (2757 - (1151 + 36))) and (v88 == (2 + 0))) then
				v9:RegisterForSelfCombatEvent(function(v147, v147, v147, v147, v147, v147, v147, v147, v147, v147, v147, v148)
					if ((v148 == (82949 + 232559)) or ((8809 - 5859) == (5644 - (1552 + 280)))) then
						v89 = v28();
					end
				end, "SPELL_AURA_REMOVED");
				break;
			end
			if (((5557 - (64 + 770)) >= (1574 + 744)) and ((2 - 1) == v88)) then
				v9:RegisterForSelfCombatEvent(function(v149, v149, v149, v149, v149, v149, v149, v149, v149, v149, v149, v150)
					if ((v150 == (56019 + 259489)) or ((3270 - (157 + 1086)) > (5707 - 2855))) then
						v89 = v28() + (131 - 101);
					end
				end, "SPELL_AURA_APPLIED");
				v9:RegisterForSelfCombatEvent(function(v151, v151, v151, v151, v151, v151, v151, v151, v151, v151, v151, v152)
					if ((v152 == (483983 - 168475)) or ((1549 - 413) > (5136 - (599 + 220)))) then
						v89 = v28() + v21(79 - 39, (1961 - (1813 + 118)) + v29.RtBRemains(true));
					end
				end, "SPELL_AURA_REFRESH");
				v88 = 2 + 0;
			end
		end
	end
	do
		local v90 = 1217 - (841 + 376);
		local v91;
		while true do
			if (((6652 - 1904) == (1103 + 3645)) and (v90 == (0 - 0))) then
				v91 = {CrimsonTempest={},Garrote={},Rupture={}};
				v29.Exsanguinated = function(v153, v154)
					local v155 = v153:GUID();
					if (((4595 - (464 + 395)) <= (12164 - 7424)) and not v155) then
						return false;
					end
					local v156 = v154:ID();
					if ((v156 == (58307 + 63104)) or ((4227 - (467 + 370)) <= (6323 - 3263))) then
						return v91.CrimsonTempest[v155] or false;
					elseif ((v156 == (517 + 186)) or ((3424 - 2425) > (421 + 2272))) then
						return v91.Garrote[v155] or false;
					elseif (((1076 - 613) < (1121 - (150 + 370))) and (v156 == (3225 - (74 + 1208)))) then
						return v91.Rupture[v155] or false;
					end
					return false;
				end;
				v90 = 2 - 1;
			end
			if ((v90 == (9 - 7)) or ((1554 + 629) < (1077 - (14 + 376)))) then
				v9:RegisterForSelfCombatEvent(function(v157, v157, v157, v157, v157, v157, v157, v158, v157, v157, v157, v159)
					if (((7889 - 3340) == (2944 + 1605)) and (v159 == (176398 + 24408))) then
						for v208, v209 in v22(v91) do
							for v219, v220 in v22(v209) do
								if (((4456 + 216) == (13689 - 9017)) and (v219 == v158)) then
									v209[v219] = true;
								end
							end
						end
					end
				end, "SPELL_CAST_SUCCESS");
				v9:RegisterForSelfCombatEvent(function(v160, v160, v160, v160, v160, v160, v160, v161, v160, v160, v160, v162)
					if ((v162 == (91337 + 30074)) or ((3746 - (23 + 55)) < (936 - 541))) then
						v91.CrimsonTempest[v161] = false;
					elseif ((v162 == (470 + 233)) or ((3742 + 424) == (705 - 250))) then
						v91.Garrote[v161] = false;
					elseif ((v162 == (612 + 1331)) or ((5350 - (652 + 249)) == (7126 - 4463))) then
						v91.Rupture[v161] = false;
					end
				end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
				v90 = 1871 - (708 + 1160);
			end
			if ((v90 == (8 - 5)) or ((7797 - 3520) < (3016 - (10 + 17)))) then
				v9:RegisterForSelfCombatEvent(function(v163, v163, v163, v163, v163, v163, v163, v164, v163, v163, v163, v165)
					if ((v165 == (27270 + 94141)) or ((2602 - (1400 + 332)) >= (7957 - 3808))) then
						if (((4120 - (242 + 1666)) < (1363 + 1820)) and (v91.CrimsonTempest[v164] ~= nil)) then
							v91.CrimsonTempest[v164] = nil;
						end
					elseif (((1703 + 2943) > (2550 + 442)) and (v165 == (1643 - (850 + 90)))) then
						if (((2511 - 1077) < (4496 - (360 + 1030))) and (v91.Garrote[v164] ~= nil)) then
							v91.Garrote[v164] = nil;
						end
					elseif (((696 + 90) < (8531 - 5508)) and (v165 == (2672 - 729))) then
						if ((v91.Rupture[v164] ~= nil) or ((4103 - (909 + 752)) < (1297 - (109 + 1114)))) then
							v91.Rupture[v164] = nil;
						end
					end
				end, "SPELL_AURA_REMOVED");
				v9:RegisterForCombatEvent(function(v166, v166, v166, v166, v166, v166, v166, v167)
					local v168 = 0 - 0;
					while true do
						if (((1766 + 2769) == (4777 - (6 + 236))) and (v168 == (0 + 0))) then
							if ((v91.CrimsonTempest[v167] ~= nil) or ((2423 + 586) <= (4964 - 2859))) then
								v91.CrimsonTempest[v167] = nil;
							end
							if (((3196 - 1366) < (4802 - (1076 + 57))) and (v91.Garrote[v167] ~= nil)) then
								v91.Garrote[v167] = nil;
							end
							v168 = 1 + 0;
						end
						if ((v168 == (690 - (579 + 110))) or ((113 + 1317) >= (3194 + 418))) then
							if (((1424 + 1259) >= (2867 - (174 + 233))) and (v91.Rupture[v167] ~= nil)) then
								v91.Rupture[v167] = nil;
							end
							break;
						end
					end
				end, "UNIT_DIED", "UNIT_DESTROYED");
				break;
			end
			if ((v90 == (2 - 1)) or ((3165 - 1361) >= (1457 + 1818))) then
				v29.WillLoseExsanguinate = function(v169, v170)
					local v171 = 1174 - (663 + 511);
					while true do
						if (((0 + 0) == v171) or ((308 + 1109) > (11187 - 7558))) then
							if (((2904 + 1891) > (946 - 544)) and v29.Exsanguinated(v169, v170)) then
								return true;
							end
							return false;
						end
					end
				end;
				v29.ExsanguinatedRate = function(v172, v173)
					local v174 = 0 - 0;
					while true do
						if (((2297 + 2516) > (6938 - 3373)) and (v174 == (0 + 0))) then
							if (((358 + 3554) == (4634 - (478 + 244))) and v29.Exsanguinated(v172, v173)) then
								return 519 - (440 + 77);
							end
							return 1 + 0;
						end
					end
				end;
				v90 = 7 - 5;
			end
		end
	end
	do
		local v92 = 1556 - (655 + 901);
		local v93;
		local v94;
		local v95;
		while true do
			if (((524 + 2297) <= (3694 + 1130)) and (v92 == (0 + 0))) then
				v93 = v15(788109 - 592482);
				v94 = 1445 - (695 + 750);
				v92 = 3 - 2;
			end
			if (((2681 - 943) <= (8827 - 6632)) and (v92 == (352 - (285 + 66)))) then
				v95 = v28();
				v29.FanTheHammerCP = function()
					if (((95 - 54) <= (4328 - (682 + 628))) and ((v28() - v95) < (0.5 + 0)) and (v94 > (299 - (176 + 123)))) then
						if (((898 + 1247) <= (2977 + 1127)) and (v94 > v12:ComboPoints())) then
							return v94;
						else
							v94 = 269 - (239 + 30);
						end
					end
					return 0 + 0;
				end;
				v92 = 2 + 0;
			end
			if (((4758 - 2069) < (15115 - 10270)) and (v92 == (317 - (306 + 9)))) then
				v9:RegisterForSelfCombatEvent(function(v175, v175, v175, v175, v175, v175, v175, v175, v175, v175, v175, v176, v175, v175, v177, v178)
					if ((v176 == (648238 - 462475)) or ((404 + 1918) > (1609 + 1013))) then
						if (((v28() - v95) > (0.5 + 0)) or ((12965 - 8431) == (3457 - (1140 + 235)))) then
							local v223 = 0 + 0;
							while true do
								if (((0 + 0) == v223) or ((404 + 1167) > (1919 - (33 + 19)))) then
									v94 = v21(v29.CPMaxSpend(), v12:ComboPoints() + v177 + (v24(0 + 0, v177 - (2 - 1)) * v21(1 + 1, v12:BuffStack(v93) - (1 - 0))));
									v95 = v28();
									break;
								end
							end
						end
					end
				end, "SPELL_ENERGIZE");
				break;
			end
		end
	end
	do
		local v96 = 0 + 0;
		local v97;
		local v98;
		local v99;
		while true do
			if (((689 - (586 + 103)) == v96) or ((242 + 2412) >= (9223 - 6227))) then
				v97, v98 = 1488 - (1309 + 179), 0 - 0;
				v99 = v15(120967 + 156958);
				v96 = 2 - 1;
			end
			if (((3005 + 973) > (4469 - 2365)) and (v96 == (1 - 0))) then
				v29.TimeToNextTornado = function()
					if (((3604 - (295 + 314)) > (3784 - 2243)) and not v12:BuffUp(v99, nil, true)) then
						return 1962 - (1300 + 662);
					end
					local v179 = v12:BuffRemains(v99, nil, true) % (3 - 2);
					if (((5004 - (1178 + 577)) > (495 + 458)) and (v28() == v97)) then
						return 0 - 0;
					elseif ((((v28() - v97) < (1405.1 - (851 + 554))) and (v179 < (0.25 + 0))) or ((9077 - 5804) > (9931 - 5358))) then
						return 303 - (115 + 187);
					elseif ((((v179 > (0.9 + 0)) or (v179 == (0 + 0))) and ((v28() - v97) > (0.75 - 0))) or ((4312 - (160 + 1001)) < (1124 + 160))) then
						return 0.1 + 0;
					end
					return v179;
				end;
				v9:RegisterForSelfCombatEvent(function(v180, v180, v180, v180, v180, v180, v180, v180, v180, v180, v180, v181)
					if ((v181 == (435512 - 222769)) or ((2208 - (237 + 121)) == (2426 - (525 + 372)))) then
						v97 = v28();
					elseif (((1556 - 735) < (6975 - 4852)) and (v181 == (197977 - (96 + 46)))) then
						v98 = v28();
					end
					if (((1679 - (643 + 134)) < (840 + 1485)) and (v98 == v97)) then
						v97 = 0 - 0;
					end
				end, "SPELL_CAST_SUCCESS");
				break;
			end
		end
	end
	do
		local v100 = 0 - 0;
		local v101;
		while true do
			if (((823 + 35) <= (5812 - 2850)) and (v100 == (3 - 1))) then
				v9:RegisterForSelfCombatEvent(function(v182, v182, v182, v182, v182, v182, v182, v182, v182, v182, v182, v182, v182, v182, v182, v182, v182, v182, v182, v182, v182, v182, v182, v183)
					local v184 = 719 - (316 + 403);
					while true do
						if ((v184 == (0 + 0)) or ((10849 - 6903) < (466 + 822))) then
							v101.Counter = v101.Counter + (2 - 1);
							if (v183 or ((2298 + 944) == (183 + 384))) then
								v101.LastOH = v28();
							else
								v101.LastMH = v28();
							end
							break;
						end
					end
				end, "SWING_DAMAGE");
				v9:RegisterForSelfCombatEvent(function(v185, v185, v185, v185, v185, v185, v185, v185, v185, v185, v185, v185, v185, v185, v185, v186)
					if (v186 or ((2934 - 2087) >= (6031 - 4768))) then
						v101.LastOH = v28();
					else
						v101.LastMH = v28();
					end
				end, "SWING_MISSED");
				break;
			end
			if ((v100 == (1 - 0)) or ((129 + 2124) == (3643 - 1792))) then
				v9:RegisterForSelfCombatEvent(function()
					local v187 = 0 + 0;
					while true do
						if ((v187 == (2 - 1)) or ((2104 - (12 + 5)) > (9212 - 6840))) then
							v101.LastOH = v28();
							break;
						end
						if ((v187 == (0 - 0)) or ((9448 - 5003) < (10288 - 6139))) then
							v101.Counter = 0 + 0;
							v101.LastMH = v28();
							v187 = 1974 - (1656 + 317);
						end
					end
				end, "PLAYER_ENTERING_WORLD");
				v9:RegisterForSelfCombatEvent(function(v188, v188, v188, v188, v188, v188, v188, v188, v188, v188, v188, v189)
					if ((v189 == (175467 + 21444)) or ((1457 + 361) == (226 - 141))) then
						v101.Counter = 0 - 0;
					end
				end, "SPELL_ENERGIZE");
				v100 = 356 - (5 + 349);
			end
			if (((2992 - 2362) < (3398 - (266 + 1005))) and ((0 + 0) == v100)) then
				v101 = {Counter=(0 - 0),LastMH=(0 - 0),LastOH=(1696 - (561 + 1135))};
				v29.TimeToSht = function(v190)
					local v191 = 0 - 0;
					local v192;
					local v193;
					local v194;
					local v195;
					local v196;
					local v197;
					while true do
						if ((v191 == (12 - 8)) or ((3004 - (507 + 559)) == (6308 - 3794))) then
							return v196[v197] - v28();
						end
						if (((13159 - 8904) >= (443 - (212 + 176))) and (v191 == (907 - (250 + 655)))) then
							v196 = {};
							for v224 = 0 - 0, 2 - 0 do
								v26(v196, v194 + (v224 * v192));
								v26(v196, v195 + (v224 * v193));
							end
							v191 = 4 - 1;
						end
						if (((4955 - (1869 + 87)) > (4009 - 2853)) and (v191 == (1904 - (484 + 1417)))) then
							table.sort(v196);
							v197 = v21(10 - 5, v24(1 - 0, v190 - v101.Counter));
							v191 = 777 - (48 + 725);
						end
						if (((3838 - 1488) > (3098 - 1943)) and (v191 == (0 + 0))) then
							if (((10766 - 6737) <= (1359 + 3494)) and (v101.Counter >= v190)) then
								return 0 + 0;
							end
							v192, v193 = v27("player");
							v191 = 854 - (152 + 701);
						end
						if ((v191 == (1312 - (430 + 881))) or ((198 + 318) > (4329 - (557 + 338)))) then
							v194 = v24(v101.LastMH + v192, v28());
							v195 = v24(v101.LastOH + v193, v28());
							v191 = 1 + 1;
						end
					end
				end;
				v100 = 2 - 1;
			end
		end
	end
	do
		local v102 = 0 - 0;
		local v103;
		local v104;
		local v105;
		while true do
			if (((10749 - 6703) >= (6536 - 3503)) and ((801 - (499 + 302)) == v102)) then
				v103 = v12:CritChancePct();
				v104 = 866 - (39 + 827);
				v102 = 2 - 1;
			end
			if ((v102 == (2 - 1)) or ((10799 - 8080) <= (2221 - 774))) then
				v105 = nil;
				function v105()
					if (not v12:AffectingCombat() or ((354 + 3780) < (11490 - 7564))) then
						v103 = v12:CritChancePct();
						v9.Debug("Base Crit Set to: " .. v103);
					end
					if ((v104 == nil) or (v104 < (0 + 0)) or ((258 - 94) >= (2889 - (103 + 1)))) then
						v104 = 554 - (475 + 79);
					else
						v104 = v104 - (2 - 1);
					end
					if ((v104 > (0 - 0)) or ((68 + 457) == (1857 + 252))) then
						v23.After(1506 - (1395 + 108), v105);
					end
				end
				v102 = 5 - 3;
			end
			if (((1237 - (7 + 1197)) == (15 + 18)) and (v102 == (1 + 1))) then
				v9:RegisterForEvent(function()
					if (((3373 - (27 + 292)) <= (11765 - 7750)) and (v104 == (0 - 0))) then
						v23.After(12 - 9, v105);
						v104 = 3 - 1;
					end
				end, "PLAYER_EQUIPMENT_CHANGED");
				v29.BaseAttackCrit = function()
					return v103;
				end;
				break;
			end
		end
	end
	do
		local v106 = v15.Rogue.Assassination;
		local v107 = v15.Rogue.Subtlety;
		local function v108()
			local v120 = 0 - 0;
			while true do
				if (((2010 - (43 + 96)) < (13795 - 10413)) and (v120 == (0 - 0))) then
					if (((1073 + 220) <= (612 + 1554)) and v106.Nightstalker:IsAvailable() and v12:StealthUp(true, false, true)) then
						return (1 - 0) + ((0.05 + 0) * v106.Nightstalker:TalentRank());
					end
					return 1 - 0;
				end
			end
		end
		local function v109()
			if ((v106.ImprovedGarrote:IsAvailable() and (v12:BuffUp(v106.ImprovedGarroteAura, nil, true) or v12:BuffUp(v106.ImprovedGarroteBuff, nil, true) or v12:BuffUp(v106.SepsisBuff, nil, true))) or ((812 + 1767) < (10 + 113))) then
				return 1752.5 - (1414 + 337);
			end
			return 1941 - (1642 + 298);
		end
		v106.Rupture:RegisterPMultiplier(v108, {v107.FinalityRuptureBuff,(2.3 - 1)});
		v106.Garrote:RegisterPMultiplier(v108, v109);
	end
end;
return v0["Epix_Rogue_Rogue.lua"]();

