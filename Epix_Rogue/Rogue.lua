local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((2486 + 2237) > (3263 - (957 + 950))) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (not v6 or ((12294 - 8158) <= (4638 - (902 + 303)))) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
		if (((10223 - 5978) <= (398 + 4233)) and (v5 == (1691 - (1121 + 569)))) then
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
	if (((4490 - (22 + 192)) >= (4597 - (483 + 200))) and not v16.Rogue) then
		v16.Rogue = {};
	end
	v16.Rogue.Commons = {Sanguine=v16(227973 - (1404 + 59), nil, 2 - 1),AncestralCall=v16(369255 - 94517, nil, 767 - (468 + 297)),ArcanePulse=v16(260926 - (334 + 228), nil, 10 - 7),ArcaneTorrent=v16(58054 - 33008, nil, 6 - 2),BagofTricks=v16(88714 + 223697, nil, 241 - (141 + 95)),Berserking=v16(25832 + 465, nil, 15 - 9),BloodFury=v16(49453 - 28881, nil, 2 + 5),Fireblood=v16(726673 - 461452, nil, 6 + 2),LightsJudgment=v16(133122 + 122525, nil, 12 - 3),Shadowmeld=v16(34793 + 24191, nil, 173 - (92 + 71)),CloakofShadows=v16(15423 + 15801, nil, 18 - 7),CrimsonVial=v16(186076 - (574 + 191), nil, 10 + 2),Evasion=v16(13220 - 7943, nil, 7 + 6),Feint=v16(2815 - (254 + 595), nil, 140 - (55 + 71)),Blind=v16(2758 - 664, nil, 1805 - (573 + 1217)),CheapShot=v16(5076 - 3243, nil, 2 + 14),Kick=v16(2845 - 1079, nil, 956 - (714 + 225)),KidneyShot=v16(1192 - 784, nil, 24 - 6),Sap=v16(733 + 6037, nil, 26 - 7),Shiv=v16(6744 - (118 + 688), nil, 68 - (25 + 23)),SliceandDice=v16(61108 + 254388, nil, 1907 - (927 + 959)),Shadowstep=v16(123219 - 86665, nil, 754 - (16 + 716)),Sprint=v16(5758 - 2775, nil, 120 - (11 + 86)),TricksoftheTrade=v16(141310 - 83376, nil, 309 - (175 + 110)),CripplingPoison=v16(8604 - 5196, nil, 123 - 98),DeadlyPoison=v16(4619 - (503 + 1293), nil, 72 - 46),InstantPoison=v16(228219 + 87365, nil, 1088 - (810 + 251)),AmplifyingPoison=v16(264867 + 116797, nil, 9 + 19),NumbingPoison=v16(5194 + 567, nil, 562 - (43 + 490)),WoundPoison=v16(9412 - (711 + 22), nil, 116 - 86),AtrophicPoison=v16(382496 - (240 + 619), nil, 8 + 23),AcrobaticStrikes=v16(313247 - 116323, nil, 3 + 29),Alacrity=v16(195283 - (1344 + 400), nil, 438 - (255 + 150)),ColdBlood=v16(301086 + 81159, nil, 19 + 15),DeeperStratagem=v16(826876 - 633345),EchoingReprimand=v16(1245509 - 859893, nil, 1775 - (404 + 1335)),EchoingReprimand2=v16(323964 - (183 + 223), nil, 44 - 7),EchoingReprimand3=v16(214386 + 109173, nil, 14 + 24),EchoingReprimand4=v16(323897 - (10 + 327), nil, 28 + 11),EchoingReprimand5=v16(355176 - (118 + 220), nil, 14 + 26),FindWeakness=v16(91472 - (108 + 341), nil, 19 + 22),FindWeaknessDebuff=v16(1336917 - 1020697, nil, 1535 - (711 + 782)),ImprovedAmbush=v16(731578 - 349958, nil, 512 - (270 + 199)),MarkedforDeath=v16(44615 + 93004, nil, 1863 - (580 + 1239)),Nightstalker=v16(41803 - 27741, nil, 44 + 1),ResoundingClarity=v16(13710 + 367912, nil, 21 + 25),SealFate=v16(37049 - 22859, nil, 30 + 17),Sepsis=v16(386575 - (645 + 522), nil, 1838 - (1010 + 780)),SepsisBuff=v16(375753 + 186, nil, 233 - 184),ShadowDance=v16(543051 - 357738, nil, 1886 - (1045 + 791)),ShadowDanceTalent=v16(999680 - 604750, nil, 77 - 26),ShadowDanceBuff=v16(185927 - (351 + 154)),Subterfuge=v16(109782 - (1281 + 293), nil, 319 - (28 + 238)),SubterfugeBuff=v16(257393 - 142201, nil, 1613 - (1381 + 178)),ThistleTea=v16(357939 + 23684, nil, 259 + 61),Vigor=v16(6392 + 8591),Stealth=v16(6150 - 4366, nil, 30 + 27),Stealth2=v16(115661 - (381 + 89), nil, 52 + 6),Vanish=v16(1256 + 600, nil, 100 - 41),VanishBuff=v16(12483 - (1074 + 82), nil, 131 - 71),VanishBuff2=v16(116977 - (214 + 1570), nil, 1516 - (990 + 465)),PoolEnergy=v16(412205 + 587705, nil, 27 + 35)};
	v16.Rogue.Assassination = v19(v16.Rogue.Commons, {Ambush=v16(8437 + 239, nil, 247 - 184),AmplifyingPoisonDebuff=v16(385140 - (1668 + 58), nil, 690 - (512 + 114)),AmplifyingPoisonDebuffDeathmark=v16(1028070 - 633742, nil, 134 - 69),CripplingPoisonDebuff=v16(11862 - 8453, nil, 31 + 35),DeadlyPoisonDebuff=v16(528 + 2290, nil, 59 + 8),DeadlyPoisonDebuffDeathmark=v16(1330041 - 935717, nil, 2062 - (109 + 1885)),Envenom=v16(34114 - (1269 + 200), nil, 131 - 62),FanofKnives=v16(52538 - (98 + 717), nil, 896 - (802 + 24)),Garrote=v16(1212 - 509, nil, 89 - 18),GarroteDeathmark=v16(53288 + 307542, nil, 56 + 16),Mutilate=v16(219 + 1110, nil, 16 + 57),PoisonedKnife=v16(516230 - 330665, nil, 246 - 172),Rupture=v16(695 + 1248, nil, 31 + 44),RuptureDeathmark=v16(297631 + 63195, nil, 56 + 20),WoundPoisonDebuff=v16(4053 + 4627, nil, 1510 - (797 + 636)),ArterialPrecision=v16(1945946 - 1545163, nil, 1697 - (1427 + 192)),AtrophicPoisonDebuff=v16(135959 + 256429, nil, 182 - 103),BlindsideBuff=v16(108901 + 12252, nil, 37 + 43),CrimsonTempest=v16(121737 - (192 + 134), nil, 1357 - (316 + 960)),CutToTheChase=v16(28753 + 22914, nil, 64 + 18),DashingScoundrel=v16(352899 + 28898, nil, 317 - 234),Deathmark=v16(360745 - (83 + 468), nil, 1890 - (1202 + 604)),Doomblade=v16(1781723 - 1400050, nil, 141 - 56),DragonTemperedBlades=v16(1057107 - 675306, nil, 411 - (45 + 280)),Elusiveness=v16(76258 + 2750),Exsanguinate=v16(175438 + 25368, nil, 33 + 55),ImprovedGarrote=v16(211183 + 170449, nil, 16 + 73),ImprovedGarroteBuff=v16(726637 - 334236, nil, 2001 - (340 + 1571)),ImprovedGarroteAura=v16(154773 + 237630, nil, 1863 - (1733 + 39)),IndiscriminateCarnage=v16(1049152 - 667350, nil, 1126 - (125 + 909)),IndiscriminateCarnageBuff=v16(387695 - (1096 + 852)),InternalBleeding=v16(69508 + 85445, nil, 131 - 38),Kingsbane=v16(374033 + 11594, nil, 606 - (409 + 103)),LightweightShiv=v16(395219 - (46 + 190)),MasterAssassin=v16(256084 - (51 + 44), nil, 27 + 68),MasterAssassinBuff=v16(258052 - (1114 + 203), nil, 822 - (228 + 498)),PreyontheWeak=v16(28493 + 103018, nil, 54 + 43),PreyontheWeakDebuff=v16(256572 - (174 + 489), nil, 255 - 157),SerratedBoneSpike=v16(387329 - (830 + 1075), nil, 623 - (303 + 221)),SerratedBoneSpikeDebuff=v16(395305 - (231 + 1038), nil, 84 + 16),ShivDebuff=v16(320666 - (171 + 991), nil, 416 - 315),VenomRush=v16(408558 - 256406, nil, 254 - 152),ScentOfBlood=v16(305571 + 76228, nil, 1388 - 992),ScentOfBloodBuff=v16(1136844 - 742764),ShroudedSuffocation=v16(621377 - 235899)});
	v16.Rogue.Outlaw = v19(v16.Rogue.Commons, {AdrenalineRush=v16(42505 - 28755, nil, 1351 - (111 + 1137)),Ambush=v16(8834 - (91 + 67), nil, 309 - 205),AmbushOverride=v16(107293 + 322730),BetweentheEyes=v16(315864 - (423 + 100), nil, 1 + 104),BladeFlurry=v16(38423 - 24546, nil, 56 + 50),Dispatch=v16(2869 - (326 + 445), nil, 466 - 359),Elusiveness=v16(176015 - 97007),Opportunity=v16(456637 - 261010),PistolShot=v16(186474 - (530 + 181), nil, 991 - (614 + 267)),RolltheBones=v16(315540 - (19 + 13), nil, 180 - 69),SinisterStrike=v16(450489 - 257174, nil, 319 - 207),Audacity=v16(99169 + 282676, nil, 198 - 85),AudacityBuff=v16(801065 - 414795, nil, 1926 - (1293 + 519)),BladeRush=v16(554713 - 282836, nil, 300 - 185),CountTheOdds=v16(730472 - 348490, nil, 500 - 384),Dreadblades=v16(808352 - 465210, nil, 62 + 55),FanTheHammer=v16(77904 + 303942, nil, 273 - 155),GhostlyStrike=v16(45509 + 151428, nil, 40 + 79),GreenskinsWickers=v16(241732 + 145091, nil, 1216 - (709 + 387)),GreenskinsWickersBuff=v16(395989 - (673 + 1185), nil, 350 - 229),HiddenOpportunity=v16(1230788 - 847507, nil, 200 - 78),ImprovedAdrenalineRush=v16(282829 + 112593, nil, 92 + 31),ImprovedBetweenTheEyes=v16(317940 - 82456, nil, 31 + 93),KeepItRolling=v16(761653 - 379664, nil, 245 - 120),KillingSpree=v16(53570 - (446 + 1434), nil, 1409 - (1040 + 243)),LoadedDice=v16(764569 - 508399, nil, 1974 - (559 + 1288)),LoadedDiceBuff=v16(258102 - (609 + 1322), nil, 582 - (13 + 441)),PreyontheWeak=v16(491434 - 359923, nil, 337 - 208),PreyontheWeakDebuff=v16(1274539 - 1018630, nil, 5 + 125),QuickDraw=v16(715239 - 518301, nil, 47 + 84),SummarilyDispatched=v16(167382 + 214608, nil, 391 - 259),SwiftSlasher=v16(209028 + 172960, nil, 244 - 111),TakeEmBySurpriseBuff=v16(255128 + 130779, nil, 75 + 59),Weaponmaster=v16(144229 + 56504, nil, 114 + 21),UnderhandedUpperhand=v16(414879 + 9165),DeftManeuvers=v16(382311 - (153 + 280)),Crackshot=v16(1223485 - 799782),Gouge=v16(1595 + 181, nil, 54 + 82),Broadside=v16(101187 + 92169, nil, 125 + 12),BuriedTreasure=v16(144631 + 54969, nil, 209 - 71),GrandMelee=v16(119507 + 73851, nil, 806 - (89 + 578)),RuthlessPrecision=v16(138128 + 55229, nil, 291 - 151),SkullandCrossbones=v16(200652 - (572 + 477), nil, 20 + 121),TrueBearing=v16(116040 + 77319, nil, 17 + 125),ViciousFollowup=v16(394965 - (84 + 2), nil, 235 - 92)});
	v16.Rogue.Subtlety = v19(v16.Rogue.Commons, {Backstab=v16(39 + 14, nil, 986 - (497 + 345)),BlackPowder=v16(8166 + 311009, nil, 25 + 120),Elusiveness=v16(80341 - (605 + 728)),Eviscerate=v16(140427 + 56392, nil, 326 - 179),Rupture=v16(90 + 1853, nil, 547 - 399),ShadowBlades=v16(109506 + 11965, nil, 412 - 263),Shadowstrike=v16(140016 + 45422, nil, 639 - (457 + 32)),ShurikenStorm=v16(83937 + 113898, nil, 1553 - (832 + 570)),ShurikenToss=v16(107412 + 6602, nil, 40 + 112),SymbolsofDeath=v16(751230 - 538947, nil, 74 + 79),DanseMacabre=v16(383324 - (588 + 208), nil, 414 - 260),DanseMacabreBuff=v16(395769 - (884 + 916), nil, 324 - 169),DeeperDaggers=v16(221790 + 160727, nil, 809 - (232 + 421)),DeeperDaggersBuff=v16(385294 - (1569 + 320), nil, 39 + 118),DarkBrew=v16(72671 + 309833, nil, 532 - 374),DarkShadow=v16(246292 - (316 + 289), nil, 415 - 256),EnvelopingShadows=v16(10997 + 227107, nil, 1613 - (666 + 787)),Finality=v16(382950 - (360 + 65), nil, 151 + 10),FinalityBlackPowderBuff=v16(386202 - (79 + 175), nil, 255 - 93),FinalityEviscerateBuff=v16(301174 + 84775, nil, 499 - 336),FinalityRuptureBuff=v16(743286 - 357335, nil, 1063 - (503 + 396)),Flagellation=v16(384812 - (92 + 89), nil, 319 - 154),FlagellationPersistBuff=v16(202448 + 192310, nil, 99 + 67),Gloomblade=v16(786196 - 585438, nil, 23 + 144),GoremawsBite=v16(972682 - 546091, nil, 165 + 24),ImprovedShadowDance=v16(188175 + 205797, nil, 511 - 343),ImprovedShurikenStorm=v16(39933 + 280018, nil, 257 - 88),InvigoratingShadowdust=v16(383767 - (485 + 759)),LingeringShadow=v16(885115 - 502591, nil, 1359 - (442 + 747)),LingeringShadowBuff=v16(387095 - (832 + 303), nil, 1117 - (88 + 858)),MasterofShadows=v16(60035 + 136941, nil, 143 + 29),PerforatedVeins=v16(15755 + 366763, nil, 962 - (766 + 23)),PerforatedVeinsBuff=v16(1946328 - 1552074, nil, 237 - 63),PreyontheWeak=v16(346492 - 214981, nil, 593 - 418),PreyontheWeakDebuff=v16(256982 - (1036 + 37), nil, 125 + 51),Premeditation=v16(668266 - 325106, nil, 140 + 37),PremeditationBuff=v16(344653 - (641 + 839), nil, 1091 - (910 + 3)),SecretStratagem=v16(1005239 - 610919, nil, 1863 - (1466 + 218)),SecretTechnique=v16(129015 + 151704, nil, 1328 - (556 + 592)),Shadowcraft=v16(151695 + 274899),ShadowFocus=v16(109017 - (329 + 479), nil, 1035 - (174 + 680)),ShurikenTornado=v16(954998 - 677073, nil, 376 - 194),SilentStorm=v16(275394 + 110328, nil, 922 - (396 + 343)),SilentStormBuff=v16(34129 + 351593, nil, 1661 - (29 + 1448)),TheFirstDance=v16(383894 - (135 + 1254), nil, 696 - 511),TheRotten=v16(1783675 - 1401660, nil, 124 + 62),TheRottenBuff=v16(395730 - (389 + 1138), nil, 761 - (102 + 472)),Weaponmaster=v16(182640 + 10897, nil, 105 + 83)});
	if (((185 + 13) <= (5910 - (320 + 1225))) and not v18.Rogue) then
		v18.Rogue = {};
	end
	v18.Rogue.Commons = {AlgetharPuzzleBox=v18(344824 - 151123, {(1477 - (157 + 1307)),(34 - 20)}),ManicGrieftorch=v18(21250 + 173058, {(5 + 8),(1040 - (834 + 192))}),WindscarWhetstone=v18(8741 + 128745, {(1 + 12),(318 - (300 + 4))}),Healthstone=v18(1473 + 4039),RefreshingHealingPotion=v18(500986 - 309606)};
	v18.Rogue.Assassination = v19(v18.Rogue.Commons, {AlgetharPuzzleBox=v18(194063 - (112 + 250), {(32 - 19),(8 + 6)}),AshesoftheEmbersoul=v18(154938 + 52229, {(10 + 3),(30 - 16)}),WitherbarksBranch=v18(110881 - (244 + 638), {(38 - 25),(1920 - (1665 + 241))})});
	v18.Rogue.Outlaw = v19(v18.Rogue.Commons, {ManicGrieftorch=v18(195025 - (373 + 344), {(4 + 9),(23 - 9)}),WindscarWhetstone=v18(138585 - (35 + 1064), {(27 - 14),(1250 - (298 + 938))}),BeaconToTheBeyond=v18(205222 - (233 + 1026), {(7 + 6),(5 + 9)}),DragonfireBombDispenser=v18(13690 + 188920, {(3 + 10),(53 - 39)})});
	v18.Rogue.Subtlety = v19(v18.Rogue.Commons, {ManicGrieftorch=v18(194605 - (36 + 261), {(1381 - (34 + 1334)),(11 + 3)}),StormEatersBoon=v18(195585 - (1035 + 248), {(7 + 6),(1147 - (549 + 584))}),BeaconToTheBeyond=v18(204648 - (314 + 371), {(981 - (478 + 490)),(1186 - (786 + 386))}),AshesoftheEmbersoul=v18(671013 - 463846, {(1353 - (1093 + 247)),(2 + 12)}),WitherbarksBranch=v18(436715 - 326716, {(36 - 23),(5 + 9)}),BandolierOfTwistedBlades=v18(798091 - 590926, {(10 + 3),(702 - (364 + 324))}),Mirror=v18(569053 - 361472, {(5 + 8),(21 - 7)})});
	if (((14523 - 9741) > (5944 - (1249 + 19))) and not v21.Rogue) then
		v21.Rogue = {};
	end
	v21.Rogue.Commons = {Healthstone=v21(19 + 2),BlindMouseover=v21(34 - 25),CheapShotMouseover=v21(1096 - (686 + 400)),KickMouseover=v21(9 + 2),KidneyShotMouseover=v21(241 - (73 + 156)),TricksoftheTradeFocus=v21(1 + 12),WindscarWhetstone=v21(837 - (721 + 90))};
	v21.Rogue.Outlaw = v19(v21.Rogue.Commons, {Dispatch=v21(1 + 13),PistolShotMouseover=v21(48 - 33),SinisterStrikeMouseover=v21(486 - (224 + 246))});
	v21.Rogue.Subtlety = v19(v21.Rogue.Commons, {SecretTechnique=v21(25 - 9),ShadowDance=v21(30 - 13),ShadowDanceSymbol=v21(5 + 21),VanishShadowstrike=v21(1 + 17),ShurikenStormSD=v21(14 + 5),ShurikenStormVanish=v21(39 - 19),GloombladeSD=v21(73 - 51),GloombladeVanish=v21(536 - (203 + 310)),BackstabMouseover=v21(2017 - (1238 + 755)),RuptureMouseover=v21(2 + 23)});
	v30.StealthSpell = function()
		return (v16.Rogue.Commons.Subterfuge:IsAvailable() and v16.Rogue.Commons.Stealth2) or v16.Rogue.Commons.Stealth;
	end;
	v30.VanishBuffSpell = function()
		return (v16.Rogue.Commons.Subterfuge:IsAvailable() and v16.Rogue.Commons.VanishBuff2) or v16.Rogue.Commons.VanishBuff;
	end;
	v30.Stealth = function(v49, v50)
		if (((6398 - (709 + 825)) > (4048 - 1851)) and EpicSettings.Settings['StealthOOC'] and (v16.Rogue.Commons.Stealth:IsCastable() or v16.Rogue.Commons.Stealth2:IsCastable()) and v13:StealthDown()) then
			if (v10.Press(v49, nil) or ((5389 - 1689) == (3371 - (196 + 668)))) then
				return "Cast Stealth (OOC)";
			end
		end
		return false;
	end;
	do
		local v51 = v16(731661 - 546350);
		v30.CrimsonVial = function()
			local v112 = EpicSettings.Settings['CrimsonVialHP'] or (0 - 0);
			if (((5307 - (171 + 662)) >= (367 - (4 + 89))) and v51:IsCastable() and (v13:HealthPercentage() <= v112)) then
				if (v10.Cast(v51, nil) or ((6638 - 4744) <= (512 + 894))) then
					return "Cast Crimson Vial (Defensives)";
				end
			end
			return false;
		end;
	end
	do
		local v53 = 0 - 0;
		local v54;
		while true do
			if (((617 + 955) >= (3017 - (35 + 1451))) and (v53 == (1453 - (28 + 1425)))) then
				v54 = v16(3959 - (941 + 1052));
				v30.Feint = function()
					local v165 = 0 + 0;
					local v166;
					while true do
						if ((v165 == (1514 - (822 + 692))) or ((6691 - 2004) < (2140 + 2402))) then
							v166 = EpicSettings.Settings['FeintHP'] or (297 - (45 + 252));
							if (((3257 + 34) > (574 + 1093)) and v54:IsCastable() and v13:BuffDown(v54) and (v13:HealthPercentage() <= v166)) then
								if (v10.Cast(v54, nil) or ((2124 - 1251) == (2467 - (114 + 319)))) then
									return "Cast Feint (Defensives)";
								end
							end
							break;
						end
					end
				end;
				break;
			end
		end
	end
	do
		local v55 = 0 - 0;
		local v56;
		local v57;
		local v58;
		while true do
			if ((v55 == (0 - 0)) or ((1796 + 1020) < (16 - 5))) then
				v56 = 0 - 0;
				v57 = false;
				v55 = 1964 - (556 + 1407);
			end
			if (((4905 - (741 + 465)) < (5171 - (170 + 295))) and (v55 == (1 + 0))) then
				v58 = nil;
				function v58(v167)
					if (((2431 + 215) >= (2156 - 1280)) and not v13:AffectingCombat() and v13:BuffRefreshable(v167)) then
						if (((509 + 105) <= (2042 + 1142)) and v10.Press(v167, nil, true)) then
							return "poison";
						end
					end
				end
				v55 = 2 + 0;
			end
			if (((4356 - (957 + 273)) == (837 + 2289)) and (v55 == (1 + 1))) then
				v30.Poisons = function()
					v57 = v13:BuffUp(v16.Rogue.Commons.WoundPoison);
					if (v16.Rogue.Assassination.DragonTemperedBlades:IsAvailable() or ((8333 - 6146) >= (13054 - 8100))) then
						local v204 = v58((v57 and v16.Rogue.Commons.WoundPoison) or v16.Rogue.Commons.DeadlyPoison);
						if (v204 or ((11841 - 7964) == (17702 - 14127))) then
							return v204;
						end
						if (((2487 - (389 + 1391)) > (397 + 235)) and v16.Rogue.Commons.AmplifyingPoison:IsAvailable()) then
							v204 = v58(v16.Rogue.Commons.AmplifyingPoison);
							if (v204 or ((57 + 489) >= (6110 - 3426))) then
								return v204;
							end
						else
							v204 = v58(v16.Rogue.Commons.InstantPoison);
							if (((2416 - (783 + 168)) <= (14434 - 10133)) and v204) then
								return v204;
							end
						end
					elseif (((1677 + 27) > (1736 - (309 + 2))) and v57) then
						local v218 = 0 - 0;
						local v219;
						while true do
							if ((v218 == (1212 - (1090 + 122))) or ((223 + 464) == (14219 - 9985))) then
								v219 = v58(v16.Rogue.Commons.WoundPoison);
								if (v219 or ((2279 + 1051) < (2547 - (628 + 490)))) then
									return v219;
								end
								break;
							end
						end
					elseif (((206 + 941) >= (829 - 494)) and v16.Rogue.Commons.AmplifyingPoison:IsAvailable() and v13:BuffDown(v16.Rogue.Commons.DeadlyPoison)) then
						local v227 = 0 - 0;
						local v228;
						while true do
							if (((4209 - (431 + 343)) > (4234 - 2137)) and (v227 == (0 - 0))) then
								v228 = v58(v16.Rogue.Commons.AmplifyingPoison);
								if (v228 or ((2979 + 791) >= (517 + 3524))) then
									return v228;
								end
								break;
							end
						end
					elseif (v16.Rogue.Commons.DeadlyPoison:IsAvailable() or ((5486 - (556 + 1139)) <= (1626 - (6 + 9)))) then
						local v235 = v58(v16.Rogue.Commons.DeadlyPoison);
						if (v235 or ((839 + 3739) <= (1029 + 979))) then
							return v235;
						end
					else
						local v236 = 169 - (28 + 141);
						local v237;
						while true do
							if (((436 + 689) <= (2562 - 486)) and (v236 == (0 + 0))) then
								v237 = v58(v16.Rogue.Commons.InstantPoison);
								if (v237 or ((2060 - (486 + 831)) >= (11447 - 7048))) then
									return v237;
								end
								break;
							end
						end
					end
					if (((4066 - 2911) < (317 + 1356)) and v13:BuffDown(v16.Rogue.Commons.CripplingPoison)) then
						if (v16.Rogue.Commons.AtrophicPoison:IsAvailable() or ((7348 - 5024) <= (1841 - (668 + 595)))) then
							local v220 = 0 + 0;
							local v221;
							while true do
								if (((760 + 3007) == (10272 - 6505)) and ((290 - (23 + 267)) == v220)) then
									v221 = v58(v16.Rogue.Commons.AtrophicPoison);
									if (((6033 - (1129 + 815)) == (4476 - (371 + 16))) and v221) then
										return v221;
									end
									break;
								end
							end
						elseif (((6208 - (1326 + 424)) >= (3170 - 1496)) and v16.Rogue.Commons.NumbingPoison:IsAvailable()) then
							local v229 = 0 - 0;
							local v230;
							while true do
								if (((1090 - (88 + 30)) <= (2189 - (720 + 51))) and (v229 == (0 - 0))) then
									v230 = v58(v16.Rogue.Commons.NumbingPoison);
									if (v230 or ((6714 - (421 + 1355)) < (7855 - 3093))) then
										return v230;
									end
									break;
								end
							end
						else
							local v231 = v58(v16.Rogue.Commons.CripplingPoison);
							if (v231 or ((1231 + 1273) > (5347 - (286 + 797)))) then
								return v231;
							end
						end
					else
						local v205 = v58(v16.Rogue.Commons.CripplingPoison);
						if (((7870 - 5717) == (3565 - 1412)) and v205) then
							return v205;
						end
					end
				end;
				break;
			end
		end
	end
	v30.MfDSniping = function(v59)
		if (v59:IsCastable() or ((946 - (397 + 42)) >= (810 + 1781))) then
			local v147 = 800 - (24 + 776);
			local v148;
			local v149;
			local v150;
			while true do
				if (((6903 - 2422) == (5266 - (222 + 563))) and (v147 == (1 - 0))) then
					for v206, v207 in v23(v13:GetEnemiesInRange(22 + 8)) do
						local v208 = v207:TimeToDie();
						if ((not v207:IsMfDBlacklisted() and (v208 < (v13:ComboPointsDeficit() * (191.5 - (23 + 167)))) and (v208 < v149)) or ((4126 - (690 + 1108)) < (251 + 442))) then
							if (((3570 + 758) == (5176 - (40 + 808))) and ((v150 - v208) > (1 + 0))) then
								v148, v149 = v207, v208;
							else
								v148, v149 = v15, v150;
							end
						end
					end
					if (((6072 - 4484) >= (1274 + 58)) and v148 and (v148:GUID() ~= v14:GUID())) then
						v10.Press(v148, v59);
					end
					break;
				end
				if (((0 + 0) == v147) or ((2289 + 1885) > (4819 - (47 + 524)))) then
					v148, v149 = nil, 39 + 21;
					v150 = (v15:IsInRange(82 - 52) and v15:TimeToDie()) or (16613 - 5502);
					v147 = 2 - 1;
				end
			end
		end
	end;
	v30.CanDoTUnit = function(v60, v61)
		return v20.CanDoTUnit(v60, v61);
	end;
	do
		local v62 = 1726 - (1165 + 561);
		local v63;
		local v64;
		local v65;
		local v66;
		while true do
			if ((v62 == (1 + 2)) or ((14203 - 9617) <= (32 + 50))) then
				v63.Rupture:RegisterPMultiplier(v65, {v64.FinalityRuptureBuff,(1.3 - 0)});
				v63.Garrote:RegisterPMultiplier(v65, v66);
				v62 = 330 - (89 + 237);
			end
			if (((12427 - 8564) == (8132 - 4269)) and (v62 == (882 - (581 + 300)))) then
				v65 = nil;
				function v65()
					if ((v63.Nightstalker:IsAvailable() and v13:StealthUp(true, false, true)) or ((1502 - (855 + 365)) <= (99 - 57))) then
						return 1 + 0 + ((1235.05 - (1030 + 205)) * v63.Nightstalker:TalentRank());
					end
					return 1 + 0;
				end
				v62 = 2 + 0;
			end
			if (((4895 - (156 + 130)) >= (1740 - 974)) and (v62 == (2 - 0))) then
				v66 = nil;
				function v66()
					if ((v63.ImprovedGarrote:IsAvailable() and (v13:BuffUp(v63.ImprovedGarroteAura, nil, true) or v13:BuffUp(v63.ImprovedGarroteBuff, nil, true) or v13:BuffUp(v63.SepsisBuff, nil, true))) or ((2358 - 1206) == (656 + 1832))) then
						return 1.5 + 0;
					end
					return 70 - (10 + 59);
				end
				v62 = 1 + 2;
			end
			if (((16852 - 13430) > (4513 - (671 + 492))) and (v62 == (0 + 0))) then
				v63 = v16.Rogue.Assassination;
				v64 = v16.Rogue.Subtlety;
				v62 = 1216 - (369 + 846);
			end
			if (((233 + 644) > (321 + 55)) and (v62 == (1949 - (1036 + 909)))) then
				v63.CrimsonTempest:RegisterPMultiplier(v65);
				break;
			end
		end
	end
	do
		local v67 = 0 + 0;
		local v68;
		local v69;
		local v70;
		while true do
			if ((v67 == (1 - 0)) or ((3321 - (11 + 192)) <= (936 + 915))) then
				v70 = v16(394495 - (135 + 40));
				v30.CPMaxSpend = function()
					return (11 - 6) + ((v68:IsAvailable() and (1 + 0)) or (0 - 0)) + ((v69:IsAvailable() and (1 - 0)) or (176 - (50 + 126))) + ((v70:IsAvailable() and (2 - 1)) or (0 + 0));
				end;
				break;
			end
			if ((v67 == (1413 - (1233 + 180))) or ((1134 - (522 + 447)) >= (4913 - (107 + 1314)))) then
				v68 = v16(89806 + 103725);
				v69 = v16(1201546 - 807225);
				v67 = 1 + 0;
			end
		end
	end
	v30.CPSpend = function()
		return v22(v13:ComboPoints(), v30.CPMaxSpend());
	end;
	do
		v30.AnimachargedCP = function()
			if (((7841 - 3892) < (19213 - 14357)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand2)) then
				return 1912 - (716 + 1194);
			elseif (v13:BuffUp(v16.Rogue.Commons.EchoingReprimand3) or ((74 + 4202) < (324 + 2692))) then
				return 506 - (74 + 429);
			elseif (((9047 - 4357) > (2045 + 2080)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand4)) then
				return 8 - 4;
			elseif (v13:BuffUp(v16.Rogue.Commons.EchoingReprimand5) or ((36 + 14) >= (2761 - 1865))) then
				return 12 - 7;
			end
			return -(434 - (279 + 154));
		end;
		v30.EffectiveComboPoints = function(v113)
			if (((v113 == (780 - (454 + 324))) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand2)) or ((v113 == (3 + 0)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand3)) or ((v113 == (21 - (12 + 5))) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand4)) or ((v113 == (3 + 2)) and v13:BuffUp(v16.Rogue.Commons.EchoingReprimand5)) or ((4367 - 2653) >= (1094 + 1864))) then
				return 1100 - (277 + 816);
			end
			return v113;
		end;
	end
	do
		local v73 = v16.Rogue.Assassination.DeadlyPoisonDebuff;
		local v74 = v16.Rogue.Assassination.WoundPoisonDebuff;
		local v75 = v16.Rogue.Assassination.AmplifyingPoisonDebuff;
		local v76 = v16.Rogue.Assassination.CripplingPoisonDebuff;
		local v77 = v16.Rogue.Assassination.AtrophicPoisonDebuff;
		v30.Poisoned = function(v114)
			return ((v114:DebuffUp(v73) or v114:DebuffUp(v75) or v114:DebuffUp(v76) or v114:DebuffUp(v74) or v114:DebuffUp(v77)) and true) or false;
		end;
	end
	do
		local v79 = v16.Rogue.Assassination.Garrote;
		local v80 = v16.Rogue.Assassination.GarroteDeathmark;
		local v81 = v16.Rogue.Assassination.Rupture;
		local v82 = v16.Rogue.Assassination.RuptureDeathmark;
		local v83 = v16.Rogue.Assassination.InternalBleeding;
		local v84 = 0 - 0;
		v30.PoisonedBleeds = function()
			local v115 = 1183 - (1058 + 125);
			while true do
				if ((v115 == (1 + 0)) or ((2466 - (815 + 160)) < (2763 - 2119))) then
					return v84;
				end
				if (((1670 - 966) < (236 + 751)) and (v115 == (0 - 0))) then
					v84 = 1898 - (41 + 1857);
					for v200, v201 in v23(v13:GetEnemiesInRange(1943 - (1222 + 671))) do
						if (((9609 - 5891) > (2738 - 832)) and v30.Poisoned(v201)) then
							local v215 = 1182 - (229 + 953);
							while true do
								if ((v215 == (1775 - (1111 + 663))) or ((2537 - (874 + 705)) > (509 + 3126))) then
									if (((2389 + 1112) <= (9336 - 4844)) and v201:DebuffUp(v83)) then
										v84 = v84 + 1 + 0;
									end
									break;
								end
								if ((v215 == (679 - (642 + 37))) or ((785 + 2657) < (408 + 2140))) then
									if (((7218 - 4343) >= (1918 - (233 + 221))) and v201:DebuffUp(v79)) then
										v84 = v84 + (2 - 1);
										if (v201:DebuffUp(v80) or ((4223 + 574) >= (6434 - (718 + 823)))) then
											v84 = v84 + 1 + 0;
										end
									end
									if (v201:DebuffUp(v81) or ((1356 - (266 + 539)) > (5854 - 3786))) then
										local v238 = 1225 - (636 + 589);
										while true do
											if (((5017 - 2903) > (1946 - 1002)) and (v238 == (0 + 0))) then
												v84 = v84 + 1 + 0;
												if (v201:DebuffUp(v82) or ((3277 - (657 + 358)) >= (8197 - 5101))) then
													v84 = v84 + (2 - 1);
												end
												break;
											end
										end
									end
									v215 = 1188 - (1151 + 36);
								end
							end
						end
					end
					v115 = 1 + 0;
				end
			end
		end;
	end
	do
		local v86 = v29();
		v30.RtBRemains = function(v116)
			local v117 = (v86 - v29()) - v10.RecoveryOffset(v116);
			return ((v117 >= (0 + 0)) and v117) or (0 - 0);
		end;
		v10:RegisterForSelfCombatEvent(function(v118, v118, v118, v118, v118, v118, v118, v118, v118, v118, v118, v119)
			if ((v119 == (317340 - (1552 + 280))) or ((3089 - (64 + 770)) >= (2402 + 1135))) then
				v86 = v29() + (68 - 38);
			end
		end, "SPELL_AURA_APPLIED");
		v10:RegisterForSelfCombatEvent(function(v120, v120, v120, v120, v120, v120, v120, v120, v120, v120, v120, v121)
			if ((v121 == (56019 + 259489)) or ((5080 - (157 + 1086)) < (2613 - 1307))) then
				v86 = v29() + v22(175 - 135, (46 - 16) + v30.RtBRemains(true));
			end
		end, "SPELL_AURA_REFRESH");
		v10:RegisterForSelfCombatEvent(function(v122, v122, v122, v122, v122, v122, v122, v122, v122, v122, v122, v123)
			if (((4026 - 1076) == (3769 - (599 + 220))) and (v123 == (628296 - 312788))) then
				v86 = v29();
			end
		end, "SPELL_AURA_REMOVED");
	end
	do
		local v88 = 1931 - (1813 + 118);
		local v89;
		while true do
			if ((v88 == (1 + 0)) or ((5940 - (841 + 376)) < (4620 - 1322))) then
				v30.WillLoseExsanguinate = function(v168, v169)
					local v170 = 0 + 0;
					while true do
						if (((3100 - 1964) >= (1013 - (464 + 395))) and (v170 == (0 - 0))) then
							if (v30.Exsanguinated(v168, v169) or ((131 + 140) > (5585 - (467 + 370)))) then
								return true;
							end
							return false;
						end
					end
				end;
				v30.ExsanguinatedRate = function(v171, v172)
					local v173 = 0 - 0;
					while true do
						if (((3480 + 1260) >= (10804 - 7652)) and ((0 + 0) == v173)) then
							if (v30.Exsanguinated(v171, v172) or ((5997 - 3419) >= (3910 - (150 + 370)))) then
								return 1284 - (74 + 1208);
							end
							return 2 - 1;
						end
					end
				end;
				v88 = 9 - 7;
			end
			if (((30 + 11) <= (2051 - (14 + 376))) and (v88 == (0 - 0))) then
				v89 = {CrimsonTempest={},Garrote={},Rupture={}};
				v30.Exsanguinated = function(v174, v175)
					local v176 = 0 + 0;
					local v177;
					local v178;
					while true do
						if (((528 + 73) < (3396 + 164)) and ((5 - 3) == v176)) then
							return false;
						end
						if (((177 + 58) < (765 - (23 + 55))) and (v176 == (2 - 1))) then
							v178 = v175:ID();
							if (((3036 + 1513) > (1036 + 117)) and (v178 == (188249 - 66838))) then
								return v89.CrimsonTempest[v177] or false;
							elseif ((v178 == (222 + 481)) or ((5575 - (652 + 249)) < (12502 - 7830))) then
								return v89.Garrote[v177] or false;
							elseif (((5536 - (708 + 1160)) < (12380 - 7819)) and (v178 == (3542 - 1599))) then
								return v89.Rupture[v177] or false;
							end
							v176 = 29 - (10 + 17);
						end
						if ((v176 == (0 + 0)) or ((2187 - (1400 + 332)) == (6914 - 3309))) then
							v177 = v174:GUID();
							if (not v177 or ((4571 - (242 + 1666)) == (1418 + 1894))) then
								return false;
							end
							v176 = 1 + 0;
						end
					end
				end;
				v88 = 1 + 0;
			end
			if (((5217 - (850 + 90)) <= (7837 - 3362)) and (v88 == (1392 - (360 + 1030)))) then
				v10:RegisterForSelfCombatEvent(function(v179, v179, v179, v179, v179, v179, v179, v180, v179, v179, v179, v181)
					if ((v181 == (177708 + 23098)) or ((2455 - 1585) == (1635 - 446))) then
						for v216, v217 in v23(v89) do
							for v222, v223 in v23(v217) do
								if (((3214 - (909 + 752)) <= (4356 - (109 + 1114))) and (v222 == v180)) then
									v217[v222] = true;
								end
							end
						end
					end
				end, "SPELL_CAST_SUCCESS");
				v10:RegisterForSelfCombatEvent(function(v182, v182, v182, v182, v182, v182, v182, v183, v182, v182, v182, v184)
					if ((v184 == (222283 - 100872)) or ((871 + 1366) >= (3753 - (6 + 236)))) then
						v89.CrimsonTempest[v183] = false;
					elseif ((v184 == (443 + 260)) or ((1066 + 258) > (7122 - 4102))) then
						v89.Garrote[v183] = false;
					elseif ((v184 == (3393 - 1450)) or ((4125 - (1076 + 57)) == (310 + 1571))) then
						v89.Rupture[v183] = false;
					end
				end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
				v88 = 692 - (579 + 110);
			end
			if (((246 + 2860) > (1350 + 176)) and (v88 == (2 + 1))) then
				v10:RegisterForSelfCombatEvent(function(v185, v185, v185, v185, v185, v185, v185, v186, v185, v185, v185, v187)
					if (((3430 - (174 + 233)) < (10810 - 6940)) and (v187 == (213095 - 91684))) then
						if (((64 + 79) > (1248 - (663 + 511))) and (v89.CrimsonTempest[v186] ~= nil)) then
							v89.CrimsonTempest[v186] = nil;
						end
					elseif (((17 + 1) < (459 + 1653)) and (v187 == (2167 - 1464))) then
						if (((665 + 432) <= (3832 - 2204)) and (v89.Garrote[v186] ~= nil)) then
							v89.Garrote[v186] = nil;
						end
					elseif (((11208 - 6578) == (2210 + 2420)) and (v187 == (3781 - 1838))) then
						if (((2523 + 1017) > (246 + 2437)) and (v89.Rupture[v186] ~= nil)) then
							v89.Rupture[v186] = nil;
						end
					end
				end, "SPELL_AURA_REMOVED");
				v10:RegisterForCombatEvent(function(v188, v188, v188, v188, v188, v188, v188, v189)
					if (((5516 - (478 + 244)) >= (3792 - (440 + 77))) and (v89.CrimsonTempest[v189] ~= nil)) then
						v89.CrimsonTempest[v189] = nil;
					end
					if (((675 + 809) == (5431 - 3947)) and (v89.Garrote[v189] ~= nil)) then
						v89.Garrote[v189] = nil;
					end
					if (((2988 - (655 + 901)) < (660 + 2895)) and (v89.Rupture[v189] ~= nil)) then
						v89.Rupture[v189] = nil;
					end
				end, "UNIT_DIED", "UNIT_DESTROYED");
				break;
			end
		end
	end
	do
		local v90 = 0 + 0;
		local v91;
		local v92;
		local v93;
		while true do
			if ((v90 == (1 + 0)) or ((4290 - 3225) > (5023 - (695 + 750)))) then
				v93 = v29();
				v30.FanTheHammerCP = function()
					local v190 = 0 - 0;
					while true do
						if ((v190 == (0 - 0)) or ((19284 - 14489) < (1758 - (285 + 66)))) then
							if (((4319 - 2466) < (6123 - (682 + 628))) and ((v29() - v93) < (0.5 + 0)) and (v92 > (299 - (176 + 123)))) then
								if ((v92 > v13:ComboPoints()) or ((1180 + 1641) < (1764 + 667))) then
									return v92;
								else
									v92 = 269 - (239 + 30);
								end
							end
							return 0 + 0;
						end
					end
				end;
				v90 = 2 + 0;
			end
			if ((v90 == (3 - 1)) or ((8966 - 6092) < (2496 - (306 + 9)))) then
				v10:RegisterForSelfCombatEvent(function(v191, v191, v191, v191, v191, v191, v191, v191, v191, v191, v191, v192, v191, v191, v193, v194)
					if ((v192 == (648238 - 462475)) or ((468 + 2221) <= (211 + 132))) then
						if (((v29() - v93) > (0.5 + 0)) or ((5344 - 3475) == (3384 - (1140 + 235)))) then
							local v226 = 0 + 0;
							while true do
								if (((0 + 0) == v226) or ((911 + 2635) < (2374 - (33 + 19)))) then
									v92 = v22(v30.CPMaxSpend(), v13:ComboPoints() + v193 + (v25(0 + 0, v193 - (2 - 1)) * v22(1 + 1, v13:BuffStack(v91) - (1 - 0))));
									v93 = v29();
									break;
								end
							end
						end
					end
				end, "SPELL_ENERGIZE");
				break;
			end
			if ((v90 == (0 + 0)) or ((2771 - (586 + 103)) == (435 + 4338))) then
				v91 = v16(602270 - 406643);
				v92 = 1488 - (1309 + 179);
				v90 = 1 - 0;
			end
		end
	end
	do
		local v94, v95 = 0 + 0, 0 - 0;
		local v96 = v16(209928 + 67997);
		v30.TimeToNextTornado = function()
			local v124 = 0 - 0;
			local v125;
			while true do
				if (((6463 - 3219) > (1664 - (295 + 314))) and (v124 == (2 - 1))) then
					if ((v29() == v94) or ((5275 - (1300 + 662)) <= (5583 - 3805))) then
						return 1755 - (1178 + 577);
					elseif ((((v29() - v94) < (0.1 + 0)) and (v125 < (0.25 - 0))) or ((2826 - (851 + 554)) >= (1861 + 243))) then
						return 2 - 1;
					elseif (((3934 - 2122) <= (3551 - (115 + 187))) and ((v125 > (0.9 + 0)) or (v125 == (0 + 0))) and ((v29() - v94) > (0.75 - 0))) then
						return 1161.1 - (160 + 1001);
					end
					return v125;
				end
				if (((1420 + 203) <= (1351 + 606)) and (v124 == (0 - 0))) then
					if (((4770 - (237 + 121)) == (5309 - (525 + 372))) and not v13:BuffUp(v96, nil, true)) then
						return 0 - 0;
					end
					v125 = v13:BuffRemains(v96, nil, true) % (3 - 2);
					v124 = 143 - (96 + 46);
				end
			end
		end;
		v10:RegisterForSelfCombatEvent(function(v126, v126, v126, v126, v126, v126, v126, v126, v126, v126, v126, v127)
			local v128 = 777 - (643 + 134);
			while true do
				if (((632 + 1118) >= (2018 - 1176)) and (v128 == (0 - 0))) then
					if (((4193 + 179) > (3630 - 1780)) and (v127 == (434873 - 222130))) then
						v94 = v29();
					elseif (((951 - (316 + 403)) < (546 + 275)) and (v127 == (543923 - 346088))) then
						v95 = v29();
					end
					if (((188 + 330) < (2271 - 1369)) and (v95 == v94)) then
						v94 = 0 + 0;
					end
					break;
				end
			end
		end, "SPELL_CAST_SUCCESS");
	end
	do
		local v98 = {Counter=(0 + 0),LastMH=(0 - 0),LastOH=(0 - 0)};
		v30.TimeToSht = function(v129)
			local v130 = 0 - 0;
			local v131;
			local v132;
			local v133;
			local v134;
			local v135;
			local v136;
			while true do
				if (((172 + 2822) > (1688 - 830)) and (v130 == (1 + 2))) then
					table.sort(v135);
					v136 = v22(14 - 9, v25(18 - (12 + 5), v129 - v98.Counter));
					v130 = 15 - 11;
				end
				if ((v130 == (1 - 0)) or ((7982 - 4227) <= (2269 - 1354))) then
					v133 = v25(v98.LastMH + v131, v29());
					v134 = v25(v98.LastOH + v132, v29());
					v130 = 1 + 1;
				end
				if (((5919 - (1656 + 317)) > (3336 + 407)) and (v130 == (2 + 0))) then
					v135 = {};
					for v202 = 0 - 0, 9 - 7 do
						local v203 = 354 - (5 + 349);
						while true do
							if ((v203 == (0 - 0)) or ((2606 - (266 + 1005)) >= (2179 + 1127))) then
								v27(v135, v133 + (v202 * v131));
								v27(v135, v134 + (v202 * v132));
								break;
							end
						end
					end
					v130 = 10 - 7;
				end
				if (((6376 - 1532) > (3949 - (561 + 1135))) and (v130 == (5 - 1))) then
					return v135[v136] - v29();
				end
				if (((1485 - 1033) == (1518 - (507 + 559))) and (v130 == (0 - 0))) then
					if ((v98.Counter >= v129) or ((14093 - 9536) < (2475 - (212 + 176)))) then
						return 905 - (250 + 655);
					end
					v131, v132 = v28("player");
					v130 = 2 - 1;
				end
			end
		end;
		v10:RegisterForSelfCombatEvent(function()
			local v137 = 0 - 0;
			while true do
				if (((6060 - 2186) == (5830 - (1869 + 87))) and (v137 == (0 - 0))) then
					v98.Counter = 1901 - (484 + 1417);
					v98.LastMH = v29();
					v137 = 2 - 1;
				end
				if ((v137 == (1 - 0)) or ((2711 - (48 + 725)) > (8061 - 3126))) then
					v98.LastOH = v29();
					break;
				end
			end
		end, "PLAYER_ENTERING_WORLD");
		v10:RegisterForSelfCombatEvent(function(v138, v138, v138, v138, v138, v138, v138, v138, v138, v138, v138, v139)
			if ((v139 == (528295 - 331384)) or ((2473 + 1782) < (9147 - 5724))) then
				v98.Counter = 0 + 0;
			end
		end, "SPELL_ENERGIZE");
		v10:RegisterForSelfCombatEvent(function(v140, v140, v140, v140, v140, v140, v140, v140, v140, v140, v140, v140, v140, v140, v140, v140, v140, v140, v140, v140, v140, v140, v140, v141)
			local v142 = 0 + 0;
			while true do
				if (((2307 - (152 + 701)) <= (3802 - (430 + 881))) and (v142 == (0 + 0))) then
					v98.Counter = v98.Counter + (896 - (557 + 338));
					if (v141 or ((1229 + 2928) <= (7898 - 5095))) then
						v98.LastOH = v29();
					else
						v98.LastMH = v29();
					end
					break;
				end
			end
		end, "SWING_DAMAGE");
		v10:RegisterForSelfCombatEvent(function(v143, v143, v143, v143, v143, v143, v143, v143, v143, v143, v143, v143, v143, v143, v143, v144)
			if (((16993 - 12140) >= (7922 - 4940)) and v144) then
				v98.LastOH = v29();
			else
				v98.LastMH = v29();
			end
		end, "SWING_MISSED");
	end
	do
		local v100 = v13:CritChancePct();
		local v101 = 0 - 0;
		local function v102()
			local v145 = 801 - (499 + 302);
			while true do
				if (((5000 - (39 + 827)) > (9267 - 5910)) and (v145 == (0 - 0))) then
					if (not v13:AffectingCombat() or ((13571 - 10154) < (3890 - 1356))) then
						v100 = v13:CritChancePct();
						v10.Debug("Base Crit Set to: " .. v100);
					end
					if ((v101 == nil) or (v101 < (0 + 0)) or ((7966 - 5244) <= (27 + 137))) then
						v101 = 0 - 0;
					else
						v101 = v101 - (105 - (103 + 1));
					end
					v145 = 555 - (475 + 79);
				end
				if ((v145 == (2 - 1)) or ((7705 - 5297) < (273 + 1836))) then
					if ((v101 > (0 + 0)) or ((1536 - (1395 + 108)) == (4234 - 2779))) then
						v24.After(1207 - (7 + 1197), v102);
					end
					break;
				end
			end
		end
		v10:RegisterForEvent(function()
			if ((v101 == (0 + 0)) or ((155 + 288) >= (4334 - (27 + 292)))) then
				v24.After(8 - 5, v102);
				v101 = 2 - 0;
			end
		end, "PLAYER_EQUIPMENT_CHANGED");
		v30.BaseAttackCrit = function()
			return v100;
		end;
	end
	do
		local v104 = 0 - 0;
		local v105;
		local v106;
		local v107;
		local v108;
		while true do
			if (((6669 - 3287) > (315 - 149)) and (v104 == (139 - (43 + 96)))) then
				v105 = v16.Rogue.Assassination;
				v106 = v16.Rogue.Subtlety;
				v104 = 4 - 3;
			end
			if ((v104 == (3 - 1)) or ((233 + 47) == (864 + 2195))) then
				v108 = nil;
				function v108()
					if (((3717 - 1836) > (496 + 797)) and v105.ImprovedGarrote:IsAvailable() and (v13:BuffUp(v105.ImprovedGarroteAura, nil, true) or v13:BuffUp(v105.ImprovedGarroteBuff, nil, true) or v13:BuffUp(v105.SepsisBuff, nil, true))) then
						return 1.5 - 0;
					end
					return 1 + 0;
				end
				v104 = 1 + 2;
			end
			if (((4108 - (1414 + 337)) == (4297 - (1642 + 298))) and (v104 == (2 - 1))) then
				v107 = nil;
				function v107()
					local v199 = 0 - 0;
					while true do
						if (((364 - 241) == (41 + 82)) and ((0 + 0) == v199)) then
							if ((v105.Nightstalker:IsAvailable() and v13:StealthUp(true, false, true)) or ((2028 - (357 + 615)) >= (2382 + 1010))) then
								return (2 - 1) + ((0.05 + 0) * v105.Nightstalker:TalentRank());
							end
							return 2 - 1;
						end
					end
				end
				v104 = 2 + 0;
			end
			if ((v104 == (1 + 2)) or ((680 + 401) < (2376 - (384 + 917)))) then
				v105.Rupture:RegisterPMultiplier(v107, {v106.FinalityRuptureBuff,(1888.3 - (687 + 1200))});
				v105.Garrote:RegisterPMultiplier(v107, v108);
				break;
			end
		end
	end
end;
return v0["Epix_Rogue_Rogue.lua"]();

