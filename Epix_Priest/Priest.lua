local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1070 - (842 + 228);
	local v6;
	while true do
		if (((5628 - (508 + 1446)) >= (376 + 140)) and (v5 == (998 - (915 + 82)))) then
			return v6(...);
		end
		if (((6555 - 4240) == (1349 + 966)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (not v6 or ((4330 - (1069 + 118)) > (8502 - 4754))) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
	end
end
v0["Epix_Priest_Priest.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v12.Player;
	local v14 = v12.Target;
	local v15 = v12.Pet;
	local v16 = v10.Spell;
	local v17 = v10.MultiSpell;
	local v18 = v10.Item;
	local v19 = v10.Utils.MergeTableByKey;
	local v20 = EpicLib;
	local v21 = v20.Macro;
	local v22 = UnitPower;
	local v23 = Enum.PowerType.Insanity;
	if (not v16.Priest or ((278 + 1316) > (3873 - 1693))) then
		v16.Priest = {};
	end
	v16.Priest.Commons = {AncestralCall=v16(272541 + 2197, nil, 792 - (368 + 423)),ArcanePulse=v16(818240 - 557876, nil, 20 - (10 + 8)),ArcaneTorrent=v16(894876 - 662243, nil, 445 - (416 + 26)),BagofTricks=v16(997502 - 685091, nil, 2 + 2),Berserking=v16(46530 - 20233, nil, 443 - (145 + 293)),BerserkingBuff=v16(26727 - (44 + 386), nil, 1492 - (998 + 488)),BloodFury=v16(6536 + 14036, nil, 6 + 1),BloodFuryBuff=v16(21344 - (201 + 571), nil, 1146 - (116 + 1022)),Fireblood=v16(1104186 - 838965, nil, 6 + 3),LightsJudgment=v16(933288 - 677641, nil, 35 - 25),DesperatePrayer=v16(20095 - (814 + 45), nil, 26 - 15),DispelMagic=v16(29 + 499, nil, 5 + 7),Fade=v16(1471 - (261 + 624), nil, 22 - 9),HolyNova=v16(133237 - (1020 + 60), nil, 1437 - (630 + 793)),MassDispel=v16(109707 - 77332, nil, 71 - 56),MindBlast=v16(3187 + 4905, nil, 54 - 38),MindSear=v16(49792 - (760 + 987), nil, 1930 - (1789 + 124)),PowerInfusion=v16(10826 - (745 + 21), nil, 7 + 11),PowerInfusionBuff=v16(27681 - 17621, nil, 74 - 55),PowerWordFortitude=v16(177 + 21385, nil, 16 + 4),PowerWordShield=v16(1072 - (87 + 968), nil, 92 - 71),PsychicScream=v16(7369 + 753, nil, 49 - 27),Purify=v16(1940 - (447 + 966), nil, 62 - 39),ImprovedPurify=v16(392449 - (1703 + 114), nil, 725 - (376 + 325)),ShadowWordDeath=v16(53061 - 20682, nil, 76 - 51),ShadowWordPain=v16(169 + 420, nil, 56 - 30),ShadowWordPainDebuff=v16(603 - (9 + 5), nil, 403 - (85 + 291)),Smite=v16(1850 - (243 + 1022), nil, 106 - 78),Resurrection=v16(1655 + 351, nil, 1209 - (1123 + 57)),Mindgames=v16(305850 + 70051, nil, 284 - (163 + 91)),Shadowfiend=v16(36363 - (1869 + 61), nil, 9 + 22),ShackleUndead=v16(33402 - 23918, nil, 48 - 16),DominateMind=v16(28102 + 177262, nil, 44 - 11),BodyandSoul=v16(60235 + 3894, nil, 1575 - (1329 + 145)),BodyandSoulBuff=v16(66052 - (140 + 831), nil, 1952 - (1409 + 441)),AngelicFeather=v16(122254 - (15 + 703), nil, 45 + 52),AngelicFeatherBuff=v16(121995 - (262 + 176), nil, 1819 - (345 + 1376)),FlashHeal=v16(2749 - (198 + 490), nil, 481 - 372),Renew=v16(333 - 194, nil, 1336 - (696 + 510)),RenewBuff=v16(291 - 152, nil, 1393 - (1091 + 171)),PowerWordFortitudeBuff=v16(3470 + 18092, nil, 106 - 72),Pool=v16(3316035 - 2316125, nil, 409 - (123 + 251))};
	v16.Priest.Shadow = v19(v16.Priest.Commons, {MindFlay=v16(76556 - 61149, nil, 734 - (208 + 490)),Shadowform=v16(19637 + 213061, nil, 17 + 20),VampiricTouch=v16(35750 - (660 + 176), nil, 5 + 33),VoidBolt=v16(205650 - (14 + 188), nil, 714 - (534 + 141)),VoidEruption=v16(91765 + 136495, nil, 36 + 4),AncientMadness=v16(328084 + 13156, nil, 85 - 44),Damnation=v16(541971 - 200597, nil, 117 - 75),DarkAscension=v16(210016 + 181093, nil, 28 + 15),DarkVoid=v16(263742 - (115 + 281), nil, 102 - 58),DeathSpeaker=v16(324974 + 67533, nil, 108 - 63),DevouringPlague=v16(1230090 - 894623, nil, 913 - (550 + 317)),Dispersion=v16(68749 - 21164, nil, 65 - 18),DistortedReality=v16(1143065 - 734021, nil, 333 - (134 + 151)),DivineStar=v16(123786 - (970 + 695), nil, 93 - 44),FortressOfTheMind=v16(195185 - (582 + 1408), nil, 173 - 123),Halo=v16(151796 - 31152, nil, 192 - 141),HungeringVoid=v16(347042 - (1195 + 629), nil, 68 - 16),IdolOfCthun=v16(377590 - (187 + 54), nil, 833 - (162 + 618)),IdolOfYoggSaron=v16(261552 + 111721, nil, 122 + 60),InescapableTorment=v16(796407 - 422980, nil, 90 - 36),InsidiousIre=v16(29181 + 344031, nil, 1819 - (1373 + 263)),MentalDecay=v16(376994 - (451 + 549), nil, 18 + 37),Mindbender=v16(311520 - 111346, nil, 93 - 37),MindDevourer=v16(374586 - (746 + 638), nil, 22 + 35),MindFlayInsanity=v16(594260 - 202857, nil, 399 - (218 + 123)),MindFlayInsanityTalent=v16(392980 - (1535 + 46), nil, 59 + 0),MindMelt=v16(56592 + 334498, nil, 620 - (306 + 254)),MindSpike=v16(4551 + 68959, nil, 119 - 58),MindSpikeInsanity=v16(408933 - (899 + 568), nil, 41 + 21),Misery=v16(577287 - 338729, nil, 666 - (268 + 335)),PsychicLink=v16(199774 - (60 + 230), nil, 636 - (426 + 146)),PurifyDisease=v16(25592 + 188042, nil, 1521 - (282 + 1174)),ScreamsOfTheVoid=v16(376578 - (569 + 242), nil, 190 - 124),SearingNightmare=v16(19523 + 321862, nil, 1091 - (706 + 318)),ShadowCrash=v16(206636 - (721 + 530), nil, 1339 - (945 + 326)),ShadowyInsight=v16(939320 - 563339, nil, 62 + 7),Silence=v16(16187 - (271 + 429), nil, 65 + 5),SurgeOfDarkness=v16(163948 - (1408 + 92), nil, 1157 - (461 + 625)),SurrenderToMadness=v16(321240 - (993 + 295), nil, 4 + 68),TwistofFate=v16(110313 - (418 + 753), nil, 28 + 45),UnfurlingDarkness=v16(35172 + 306101, nil, 22 + 52),VoidTorrent=v16(66509 + 196656, nil, 604 - (406 + 123)),Voidtouched=v16(409199 - (1749 + 20), nil, 19 + 57),WhisperingShadows=v16(408099 - (1249 + 73), nil, 28 + 49),VampiricEmbrace=v16(16431 - (466 + 679), nil, 435 - 254),DarkAscensionBuff=v16(1118644 - 727535, nil, 1978 - (106 + 1794)),DarkEvangelismBuff=v16(123726 + 267373, nil, 20 + 59),DarkThoughtBuff=v16(1007380 - 666173, nil, 216 - 136),DeathsTormentBuff=v16(423874 - (4 + 110), nil, 768 - (57 + 527)),DeathspeakerBuff=v16(393938 - (41 + 1386), nil, 184 - (17 + 86)),DevouredFearBuff=v16(253373 + 119946, nil, 182 - 100),DevouredPrideBuff=v16(1081102 - 707786, nil, 249 - (122 + 44)),MindDevourerBuff=v16(644647 - 271443, nil, 278 - 194),MindFlayInsanityBuff=v16(318399 + 73002, nil, 13 + 72),MindSpikeInsanityBuff=v16(825471 - 418003, nil, 151 - (30 + 35)),ShadowformBuff=v16(159936 + 72762, nil, 1344 - (1043 + 214)),ShadowyInsightBuff=v16(1421455 - 1045474, nil, 1300 - (323 + 889)),SurgeOfDarknessBuff=v16(234603 - 147443, nil, 669 - (361 + 219)),UnfurlingDarknessBuff=v16(341602 - (53 + 267), nil, 21 + 69),VoidformBuff=v16(194662 - (15 + 398), nil, 1073 - (18 + 964)),DevouringPlagueDebuff=v16(1262737 - 927270, nil, 54 + 38),HungeringVoidDebuff=v16(217501 + 127718, nil, 943 - (20 + 830)),VampiricTouchDebuff=v16(27254 + 7660, nil, 220 - (116 + 10)),DarkReveriesBuff=v16(29175 + 365788, nil, 833 - (542 + 196)),GatheringShadowsBuff=v16(846681 - 451720, nil, 29 + 67)});
	v16.Priest.Discipline = v19(v16.Priest.Commons, {AtonementBuff=v16(98761 + 95623, nil, 36 + 63),BindingHeals=v16(970437 - 602162, nil, 256 - 156),DarkReprimand=v16(401720 - (1126 + 425), nil, 508 - (118 + 287)),DivineStar=v16(434037 - 323293, nil, 1225 - (118 + 1003)),DivineStarShadow=v16(357378 - 235257, nil, 482 - (142 + 235)),EmbraceShadow=v16(1692053 - 1319068, nil, 24 + 82),Evangelism=v16(247264 - (553 + 424), nil, 202 - 95),Expiation=v16(344291 + 46541, nil, 108 + 0),Halo=v16(70172 + 50345, nil, 47 + 63),HaloShadow=v16(68897 + 51747, nil, 240 - 129),HarshDiscipline=v16(1039797 - 666617, nil, 250 - 138),HarshDisciplineBuff=v16(108519 + 264662, nil, 546 - 433),LeapofFaith=v16(74078 - (239 + 514), nil, 41 + 73),LightsWrath=v16(374507 - (797 + 532), nil, 84 + 31),LuminousBarrier=v16(91580 + 179886, nil, 272 - 156),MassResurrection=v16(213238 - (373 + 829), nil, 848 - (476 + 255)),Mindbender=v16(124170 - (369 + 761), nil, 69 + 49),PainSuppression=v16(60314 - 27108, nil, 225 - 106),PainfulPunishment=v16(390924 - (64 + 174), nil, 18 + 102),Penance=v16(70403 - 22863, nil, 457 - (144 + 192)),PurgeTheWicked=v16(204413 - (42 + 174), nil, 92 + 30),PurgeTheWickedDebuff=v16(169165 + 35048, nil, 53 + 70),PowerWordBarrier=v16(64122 - (363 + 1141), nil, 1704 - (1183 + 397)),PowerWordLife=v16(1137004 - 763523, nil, 92 + 33),PowerWordRadiance=v16(145388 + 49121, nil, 2101 - (1913 + 62)),PowerWordSolace=v16(81399 + 47851, nil, 336 - 209),RadiantProvidenceBuff=v16(412571 - (565 + 1368), nil, 481 - 353),Rapture=v16(49197 - (1477 + 184), nil, 175 - 46),RhapsodyBuff=v16(363976 + 26660, nil, 988 - (564 + 292)),Schism=v16(370312 - 155691, nil, 400 - 267),ShadowCovenant=v16(315171 - (244 + 60), nil, 104 + 30),ShadowCovenantBuff=v16(322581 - (41 + 435), nil, 1136 - (938 + 63)),ShadowFiend=v16(26482 + 7951, nil, 1261 - (936 + 189)),ShatteredPerceptions=v16(128716 + 262396, nil, 1750 - (1565 + 48)),SpiritShell=v16(67927 + 42037, nil, 1276 - (782 + 356)),SurgeofLight=v16(114522 - (176 + 91), nil, 361 - 222),TwilightEquilibrium=v16(575825 - 185120, nil, 1232 - (975 + 117)),TEHolyBuff=v16(392581 - (157 + 1718), nil, 115 + 26),TEShadowBuff=v16(1386980 - 996273, nil, 485 - 343),VoidShift=v16(109986 - (697 + 321), nil, 389 - 246),WrathUnleashed=v16(827913 - 437132, nil, 331 - 187),UltimatePenitence=v16(164048 + 257405, nil, 346 - 161)});
	v16.Priest.Holy = v19(v16.Priest.Commons, {CircleofHealing=v16(549232 - 344349, nil, 1374 - (322 + 905)),DivineHymn=v16(65454 - (602 + 9), nil, 1337 - (449 + 740)),EmpyrealBlaze=v16(373488 - (826 + 46), nil, 1096 - (245 + 702)),EmpyrealBlazeBuff=v16(1177454 - 804837, nil, 49 + 101),GuardianSpirit=v16(49686 - (260 + 1638), nil, 592 - (382 + 58)),Heal=v16(6608 - 4548, nil, 128 + 25),HolyFire=v16(30822 - 15908, nil, 457 - 303),HolyFireDebuff=v16(16119 - (902 + 303), nil, 339 - 184),HolyWordChastise=v16(213453 - 124828, nil, 14 + 143),HolyWordSanctify=v16(36551 - (1121 + 569), nil, 372 - (22 + 192)),HolyWordSerenity=v16(2733 - (483 + 200), nil, 1622 - (1404 + 59)),LeapofFaith=v16(200671 - 127346, nil, 215 - 55),Lightweaver=v16(391757 - (468 + 297), nil, 723 - (334 + 228)),LightweaverBuff=v16(1318814 - 927821, nil, 374 - 212),MassResurrection=v16(384557 - 172521, nil, 47 + 116),SymbolofHope=v16(65137 - (141 + 95), nil, 162 + 2),SurgeofLight=v16(294093 - 179838, nil, 396 - 231),PowerWordLife=v16(87483 + 285998, nil, 454 - 288),PrayerofHealing=v16(419 + 177, nil, 87 + 80),PrayerofMending=v16(46578 - 13502, nil, 100 + 68),PrayerofMendingBuff=v16(41798 - (92 + 71), nil, 84 + 85),Apotheosis=v16(336567 - 136384, nil, 939 - (574 + 191)),DivineStar=v16(91349 + 19395, nil, 438 - 263),Halo=v16(61559 + 58958, nil, 1025 - (254 + 595)),HolyWordSalvation=v16(265328 - (55 + 71), nil, 233 - 56),PrayerCircle=v16(323167 - (573 + 1217), nil, 492 - 314),PrayerCircleBuff=v16(24453 + 296926, nil, 287 - 108),RhapsodyBuff=v16(391575 - (714 + 225), nil, 526 - 346)});
	if (((4285 - 1211) == (333 + 2741)) and not v18.Priest) then
		v18.Priest = {};
	end
	v18.Priest.Commons = {Healthstone=v18(7980 - 2468),RefreshingHealingPotion=v18(192186 - (118 + 688)),PotionOfWitheringDreams=v18(207089 - (25 + 23)),BeacontotheBeyond=v18(39505 + 164458, {(43 - 30),(26 - 12)}),BelorrelostheSuncaller=v18(207269 - (11 + 86), {(298 - (175 + 110)),(69 - 55)}),DesperateInvokersCodex=v18(196106 - (503 + 1293), {(10 + 3),(10 + 4)}),EruptingSpearFragment=v18(59469 + 134300, {(546 - (43 + 490)),(53 - 39)}),NymuesUnravelingSpindle=v18(209474 - (240 + 619), {(20 - 7),(1758 - (1344 + 400))}),VoidmendersShadowgem=v18(110412 - (255 + 150), {(7 + 6),(44 - 30)}),Dreambinder=v18(210355 - (404 + 1335), {(19 - 3)}),Iridal=v18(138031 + 70290, {(353 - (10 + 327))})};
	v18.Priest.Shadow = v19(v18.Priest.Commons, {});
	v18.Priest.Discipline = v19(v18.Priest.Commons, {});
	v18.Priest.Holy = v19(v18.Priest.Commons, {});
	if (((258 + 112) >= (534 - (118 + 220))) and not v21.Priest) then
		v21.Priest = {};
	end
	v21.Priest.Commons = {AngelicFeatherPlayer=v21(7 + 12),PowerInfusionPlayer=v21(477 - (108 + 341)),PowerWordShieldPlayer=v21(14 + 15),FlashHealFocus=v21(126 - 96),PowerInfusionFocus=v21(1524 - (711 + 782)),PowerWordLifeFocus=v21(60 - 28),PurifyFocus=v21(502 - (270 + 199)),RenewFocus=v21(12 + 22),DominateMindMouseover=v21(1828 - (580 + 1239)),LeapofFaithMouseover=v21(29 - 19),PowerWordLifeMouseover=v21(11 + 0),PowerWordShieldMouseover=v21(1 + 11),PurifyMouseover=v21(6 + 7),ShadowWordDeathMouseover=v21(36 - 22),ShadowWordPainMouseover=v21(10 + 5),ShackleUndeadMouseover=v21(1183 - (645 + 522)),MassDispelCursor=v21(1807 - (1010 + 780)),Healthstone=v21(35 + 0),PowerWordFortitudePlayer=v21(85 - 67),RefreshingHealingPotion=v21(105 - 69),HaloPlayer=v21(2136 - (1045 + 791)),DivineStarPlayer=v21(761 - 460),PowerWordShieldFocus=v21(466 - 160)};
	v21.Priest.Shadow = v19(v21.Priest.Commons, {PurifyDiseaseFocus=v21(807 - (351 + 154)),FlashHealPlayer=v21(1877 - (1281 + 293)),RenewPlayer=v21(570 - (28 + 238)),ShadowCrashCursor=v21(681 - 376)});
	v21.Priest.Discipline = v19(v21.Priest.Commons, {DarkReprimandFocus=v21(1597 - (1381 + 178)),DarkReprimandMouseover=v21(37 + 2),FlashHealMouseover=v21(34 + 7),PainSuppressionFocus=v21(19 + 24),PainSuppressionMouseover=v21(151 - 107),PenanceFocus=v21(24 + 21),PenanceMouseover=v21(516 - (381 + 89)),PowerWordBarrierCursor=v21(42 + 5),PowerWordRadianceFocus=v21(34 + 16),PowerWordRadiancePlayer=v21(87 - 36),PurgeTheWickedMouseover=v21(1208 - (1074 + 82)),RaptureFocus=v21(116 - 63),ShadowCovenantFocus=v21(1839 - (214 + 1570)),RenewMouseover=v21(1511 - (990 + 465))});
	v21.Priest.Holy = v19(v21.Priest.Commons, {CircleofHealingFocus=v21(12 + 15),GuardianSpiritFocus=v21(9 + 11),HealFocus=v21(21 + 0),HolyWordSerenityFocus=v21(86 - 64),PrayerofHealingFocus=v21(1749 - (1668 + 58)),PrayerofMendingFocus=v21(650 - (512 + 114)),HolyWordSerenityMouseover=v21(65 - 40),HolyWordSanctifyCursor=v21(53 - 27)});
	v10.AddCoreOverride("Player.Insanity", function()
		local v37 = v22("Player", v23);
		if (not v13:IsCasting() or ((11023 - 7855) < (234 + 268))) then
			return v37;
		elseif (((83 + 356) == (382 + 57)) and v13:IsCasting(v16.Priest.Shadow.MindBlast)) then
			return v37 + (20 - 14);
		elseif (v13:IsCasting(v16.Priest.Shadow.VampiricTouch) or v13:IsCasting(v16.Priest.Shadow.MindSpike) or ((3258 - (109 + 1885)) < (1741 - (1269 + 200)))) then
			return v37 + (7 - 3);
		elseif (((3938 - (98 + 717)) < (4717 - (802 + 24))) and v13:IsCasting(v16.Priest.Shadow.MindFlay)) then
			return v37 + ((20 - 8) / v16.Priest.Shadow.MindFlay:BaseDuration());
		elseif (((4978 - 1036) <= (737 + 4250)) and v13:IsCasting(v16.Priest.Shadow.DarkVoid)) then
			return v37 + 12 + 3;
		elseif (((753 + 3831) == (989 + 3595)) and v13:IsCasting(v16.Priest.Shadow.DarkAscension)) then
			return v37 + (83 - 53);
		elseif (((13268 - 9289) >= (597 + 1071)) and v13:IsCasting(v16.Priest.Shadow.VoidTorrent)) then
			return v37 + ((25 + 35) / v16.Priest.Shadow.VoidTorrent:BaseDuration());
		else
			return v37;
		end
	end, 213 + 45);
	local v36;
	v36 = v10.AddCoreOverride("Spell.IsCastable", function(v38, v39, v40, v41, v42, v43)
		local v44 = 0 + 0;
		local v45;
		while true do
			if (((266 + 302) > (1861 - (797 + 636))) and (v44 == (0 - 0))) then
				v45 = v36(v38, v39, v40, v41, v42, v43);
				if (((2953 - (1427 + 192)) <= (1599 + 3014)) and (v38 == v16.Priest.Shadow.VampiricTouch)) then
					return v45 and not v16.Priest.Shadow.ShadowCrash:InFlight() and (v16.Priest.Shadow.UnfurlingDarkness:IsAvailable() or not v13:IsCasting(v38));
				elseif ((v38 == v16.Priest.Shadow.MindBlast) or ((4330 - 2465) >= (1824 + 205))) then
					return v45 and ((v38:Charges() >= (1 + 1)) or not v13:IsCasting(v38));
				elseif (((5276 - (192 + 134)) >= (2892 - (316 + 960))) and (v38 == v16.Priest.Shadow.VoidEruption)) then
					return v45 and not v13:IsCasting(v38);
				elseif (((960 + 765) == (1332 + 393)) and (v38 == v16.Priest.Shadow.VoidBolt)) then
					return v45 or v13:IsCasting(v16.Priest.Shadow.VoidEruption);
				else
					return v45;
				end
				break;
			end
		end
	end, 239 + 19);
end;
return v0["Epix_Priest_Priest.lua"]();

