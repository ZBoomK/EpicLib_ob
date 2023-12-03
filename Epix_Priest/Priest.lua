local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((1162 - (294 + 296)) > (8900 - 4414))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Priest_Priest.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v11.Player;
	local v13 = v11.Target;
	local v14 = v11.Pet;
	local v15 = v9.Spell;
	local v16 = v9.MultiSpell;
	local v17 = v9.Item;
	local v18 = v9.Utils.MergeTableByKey;
	local v19 = EpicLib;
	local v20 = v19.Macro;
	local v21 = UnitPower;
	local v22 = Enum.PowerType.Insanity;
	if (((4527 - 3123) == (1434 - (5 + 25))) and not v15.Priest) then
		v15.Priest = {};
	end
	v15.Priest.Commons = {AncestralCall=v15(275925 - (1069 + 118), nil, 2 - 1),ArcanePulse=v15(569538 - 309174, nil, 1 + 1),ArcaneTorrent=v15(413341 - 180708, nil, 3 + 0),BagofTricks=v15(313202 - (368 + 423), nil, 12 - 8),Berserking=v15(26315 - (10 + 8), nil, 19 - 14),BerserkingBuff=v15(26739 - (416 + 26), nil, 19 - 13),BloodFury=v15(8829 + 11743, nil, 12 - 5),BloodFuryBuff=v15(21010 - (145 + 293), nil, 438 - (44 + 386)),Fireblood=v15(266707 - (998 + 488), nil, 3 + 6),LightsJudgment=v15(209330 + 46317, nil, 782 - (201 + 571)),DesperatePrayer=v15(20374 - (116 + 1022), nil, 45 - 34),DispelMagic=v15(310 + 218, nil, 43 - 31),Fade=v15(2080 - 1494, nil, 872 - (814 + 45)),HolyNova=v15(325629 - 193472, nil, 1 + 13),MassDispel=v15(11440 + 20935, nil, 900 - (261 + 624)),MindBlast=v15(14379 - 6287, nil, 1096 - (1020 + 60)),MindSear=v15(49468 - (630 + 793), nil, 57 - 40),PowerInfusion=v15(47631 - 37571, nil, 8 + 10),PowerInfusionBuff=v15(34637 - 24577, nil, 1766 - (760 + 987)),PowerWordFortitude=v15(23475 - (1789 + 124), nil, 786 - (745 + 21)),PowerWordShield=v15(6 + 11, nil, 57 - 36),PsychicScream=v15(31858 - 23736, nil, 1 + 21),Purify=v15(414 + 113, nil, 1078 - (87 + 968)),ImprovedPurify=v15(1719539 - 1328907, nil, 22 + 2),ShadowWordDeath=v15(73193 - 40814, nil, 1438 - (447 + 966)),ShadowWordPain=v15(1612 - 1023, nil, 1843 - (1703 + 114)),ShadowWordPainDebuff=v15(1290 - (376 + 325), nil, 43 - 16),Smite=v15(1799 - 1214, nil, 9 + 19),Resurrection=v15(4417 - 2411, nil, 43 - (9 + 5)),Mindgames=v15(376277 - (85 + 291), nil, 1295 - (243 + 1022)),Shadowfiend=v15(131023 - 96590, nil, 26 + 5),ShackleUndead=v15(10664 - (1123 + 57), nil, 27 + 5),DominateMind=v15(205618 - (163 + 91), nil, 1963 - (1869 + 61)),BodyandSoul=v15(17916 + 46213, nil, 355 - 254),BodyandSoulBuff=v15(99960 - 34879, nil, 14 + 88),AngelicFeather=v15(167019 - 45483, nil, 92 + 5),AngelicFeatherBuff=v15(123031 - (1329 + 145), nil, 1069 - (140 + 831)),FlashHeal=v15(3911 - (1409 + 441), nil, 827 - (15 + 703)),Renew=v15(65 + 74, nil, 568 - (262 + 176)),RenewBuff=v15(1860 - (345 + 1376), nil, 819 - (198 + 490)),PowerWordFortitudeBuff=v15(95260 - 73698, nil, 81 - 47),Pool=v15(1001116 - (696 + 510), nil, 73 - 38)};
	v15.Priest.Shadow = v18(v15.Priest.Commons, {MindFlay=v15(16669 - (1091 + 171), nil, 6 + 30),Shadowform=v15(732612 - 499914, nil, 122 - 85),VampiricTouch=v15(35288 - (123 + 251), nil, 188 - 150),VoidBolt=v15(206146 - (208 + 490), nil, 4 + 35),VoidEruption=v15(101678 + 126582, nil, 876 - (660 + 176)),AncientMadness=v15(40998 + 300242, nil, 243 - (14 + 188)),Damnation=v15(342049 - (534 + 141), nil, 17 + 25),DarkAscension=v15(345953 + 45156, nil, 42 + 1),DarkVoid=v15(553433 - 290087, nil, 69 - 25),DeathSpeaker=v15(1100999 - 708492, nil, 25 + 20),DevouringPlague=v15(213597 + 121870, nil, 442 - (115 + 281)),Dispersion=v15(110684 - 63099, nil, 39 + 8),DistortedReality=v15(988558 - 579514, nil, 175 - 127),DivineStar=v15(122988 - (550 + 317), nil, 70 - 21),FortressOfTheMind=v15(271549 - 78354, nil, 139 - 89),Halo=v15(120929 - (134 + 151), nil, 1716 - (970 + 695)),HungeringVoid=v15(658757 - 313539, nil, 2042 - (582 + 1408)),IdolOfCthun=v15(1308675 - 931326, nil, 66 - 13),IdolOfYoggSaron=v15(1406625 - 1033352, nil, 2006 - (1195 + 629)),InescapableTorment=v15(493856 - 120429, nil, 295 - (187 + 54)),InsidiousIre=v15(373992 - (162 + 618), nil, 129 + 54),MentalDecay=v15(250427 + 125567, nil, 117 - 62),Mindbender=v15(336530 - 136356, nil, 5 + 51),MindDevourer=v15(374838 - (1373 + 263), nil, 1057 - (451 + 549)),MindFlayInsanity=v15(123551 + 267852, nil, 89 - 31),MindFlayInsanityTalent=v15(657808 - 266409, nil, 1443 - (746 + 638)),MindMelt=v15(147182 + 243908, nil, 91 - 31),MindSpike=v15(73851 - (218 + 123), nil, 1642 - (1535 + 46)),MindSpikeInsanity=v15(404859 + 2607, nil, 9 + 53),Misery=v15(239118 - (306 + 254), nil, 4 + 59),PsychicLink=v15(391495 - 192011, nil, 1531 - (899 + 568)),PurifyDisease=v15(140422 + 73212, nil, 157 - 92),ScreamsOfTheVoid=v15(376370 - (268 + 335), nil, 356 - (60 + 230)),SearingNightmare=v15(341957 - (426 + 146), nil, 9 + 58),ShadowCrash=v15(206841 - (282 + 1174), nil, 879 - (569 + 242)),ShadowyInsight=v15(1083048 - 707067, nil, 4 + 65),Silence=v15(16511 - (706 + 318), nil, 1321 - (721 + 530)),SurgeOfDarkness=v15(163719 - (945 + 326), nil, 177 - 106),SurrenderToMadness=v15(284700 + 35252, nil, 772 - (271 + 429)),TwistofFate=v15(100259 + 8883, nil, 1573 - (1408 + 92)),UnfurlingDarkness=v15(342359 - (461 + 625), nil, 1362 - (993 + 295)),VoidTorrent=v15(13665 + 249500, nil, 1246 - (418 + 753)),Voidtouched=v15(155171 + 252259, nil, 8 + 68),WhisperingShadows=v15(118976 + 287801, nil, 20 + 57),VampiricEmbrace=v15(15815 - (406 + 123), nil, 1950 - (1749 + 20)),DarkAscensionBuff=v15(92899 + 298210, nil, 1400 - (1249 + 73)),DarkEvangelismBuff=v15(139532 + 251567, nil, 1224 - (466 + 679)),DarkThoughtBuff=v15(820763 - 479556, nil, 228 - 148),DeathsTormentBuff=v15(425660 - (106 + 1794), nil, 59 + 125),DeathspeakerBuff=v15(99219 + 293292, nil, 239 - 158),DevouredFearBuff=v15(1010925 - 637606, nil, 196 - (4 + 110)),DevouredPrideBuff=v15(373900 - (57 + 527), nil, 1510 - (41 + 1386)),MindDevourerBuff=v15(373307 - (17 + 86), nil, 58 + 26),MindFlayInsanityBuff=v15(872868 - 481467, nil, 246 - 161),MindSpikeInsanityBuff=v15(407634 - (122 + 44), nil, 148 - 62),ShadowformBuff=v15(771968 - 539270, nil, 71 + 16),ShadowyInsightBuff=v15(54376 + 321605, nil, 178 - 90),SurgeOfDarknessBuff=v15(87225 - (30 + 35), nil, 62 + 27),UnfurlingDarknessBuff=v15(342539 - (1043 + 214), nil, 340 - 250),VoidformBuff=v15(195461 - (323 + 889), nil, 244 - 153),DevouringPlagueDebuff=v15(336047 - (361 + 219), nil, 412 - (53 + 267)),HungeringVoidDebuff=v15(77992 + 267227, nil, 506 - (15 + 398)),VampiricTouchDebuff=v15(35896 - (18 + 964), nil, 353 - 259),DarkReveriesBuff=v15(228669 + 166294, nil, 60 + 35),GatheringShadowsBuff=v15(395811 - (20 + 830), nil, 75 + 21)});
	v15.Priest.Discipline = v18(v15.Priest.Commons, {AtonementBuff=v15(194510 - (116 + 10), nil, 8 + 91),BindingHeals=v15(369013 - (542 + 196), nil, 214 - 114),DarkReprimand=v15(116856 + 283313, nil, 53 + 50),DivineStar=v15(39865 + 70879, nil, 273 - 169),DivineStarShadow=v15(313092 - 190971, nil, 1656 - (1126 + 425)),EmbraceShadow=v15(373390 - (118 + 287), nil, 415 - 309),Evangelism=v15(247408 - (118 + 1003), nil, 313 - 206),Expiation=v15(391209 - (142 + 235), nil, 489 - 381),Halo=v15(26224 + 94293, nil, 1087 - (553 + 424)),HaloShadow=v15(228132 - 107488, nil, 98 + 13),HarshDiscipline=v15(370188 + 2992, nil, 66 + 46),HarshDisciplineBuff=v15(158636 + 214545, nil, 65 + 48),LeapofFaith=v15(158960 - 85635, nil, 317 - 203),LightsWrath=v15(835561 - 462383, nil, 34 + 81),LuminousBarrier=v15(1311902 - 1040436, nil, 869 - (239 + 514)),MassResurrection=v15(74470 + 137566, nil, 1446 - (797 + 532)),Mindbender=v15(89403 + 33637, nil, 40 + 78),PainSuppression=v15(78075 - 44869, nil, 1321 - (373 + 829)),PainfulPunishment=v15(391417 - (476 + 255), nil, 1250 - (369 + 761)),Penance=v15(27501 + 20039, nil, 219 - 98),PurgeTheWicked=v15(386954 - 182757, nil, 360 - (64 + 174)),PurgeTheWickedDebuff=v15(29085 + 175128, nil, 181 - 58),PowerWordBarrier=v15(62954 - (144 + 192), nil, 340 - (42 + 174)),PowerWordLife=v15(280572 + 92909, nil, 104 + 21),PowerWordRadiance=v15(82636 + 111873, nil, 1630 - (363 + 1141)),PowerWordSolace=v15(130830 - (1183 + 397), nil, 386 - 259),RadiantProvidenceBuff=v15(301017 + 109621, nil, 96 + 32),Rapture=v15(49511 - (1913 + 62), nil, 82 + 47),RhapsodyBuff=v15(1034132 - 643496, nil, 2065 - (565 + 1368)),Schism=v15(807132 - 592511, nil, 1794 - (1477 + 184)),ShadowCovenant=v15(429032 - 114165, nil, 125 + 9),ShadowCovenantBuff=v15(322961 - (564 + 292), nil, 232 - 97),ShadowFiend=v15(103786 - 69353, nil, 440 - (244 + 60)),ShatteredPerceptions=v15(300731 + 90381, nil, 613 - (41 + 435)),SpiritShell=v15(110965 - (938 + 63), nil, 107 + 31),SurgeofLight=v15(115380 - (936 + 189), nil, 46 + 93),TwilightEquilibrium=v15(392318 - (1565 + 48), nil, 87 + 53),TEHolyBuff=v15(391844 - (782 + 356), nil, 408 - (176 + 91)),TEShadowBuff=v15(1017920 - 627213, nil, 208 - 66),VoidShift=v15(110060 - (975 + 117), nil, 2018 - (157 + 1718)),WrathUnleashed=v15(317140 + 73641, nil, 511 - 367),UltimatePenitence=v15(1440868 - 1019415, nil, 1203 - (697 + 321))});
	v15.Priest.Holy = v18(v15.Priest.Commons, {CircleofHealing=v15(558127 - 353244, nil, 311 - 164),DivineHymn=v15(149487 - 84644, nil, 58 + 90),EmpyrealBlaze=v15(698154 - 325538, nil, 399 - 250),EmpyrealBlazeBuff=v15(373844 - (322 + 905), nil, 761 - (602 + 9)),GuardianSpirit=v15(48977 - (449 + 740), nil, 1024 - (826 + 46)),Heal=v15(3007 - (245 + 702), nil, 483 - 330),HolyFire=v15(4795 + 10119, nil, 2052 - (260 + 1638)),HolyFireDebuff=v15(15354 - (382 + 58), nil, 497 - 342),HolyWordChastise=v15(73644 + 14981, nil, 324 - 167),HolyWordSanctify=v15(103627 - 68766, nil, 1363 - (902 + 303)),HolyWordSerenity=v15(4501 - 2451, nil, 382 - 223),LeapofFaith=v15(6301 + 67024, nil, 1850 - (1121 + 569)),Lightweaver=v15(391206 - (22 + 192), nil, 844 - (483 + 200)),LightweaverBuff=v15(392456 - (1404 + 59), nil, 443 - 281),MassResurrection=v15(284982 - 72946, nil, 928 - (468 + 297)),SymbolofHope=v15(65463 - (334 + 228), nil, 553 - 389),SurgeofLight=v15(264832 - 150577, nil, 299 - 134),PowerWordLife=v15(106056 + 267425, nil, 402 - (141 + 95)),PrayerofHealing=v15(586 + 10, nil, 429 - 262),PrayerofMending=v15(79511 - 46435, nil, 40 + 128),PrayerofMendingBuff=v15(114074 - 72439, nil, 119 + 50),Apotheosis=v15(104241 + 95942, nil, 244 - 70),DivineStar=v15(65324 + 45420, nil, 338 - (92 + 71)),Halo=v15(59529 + 60988, nil, 295 - 119),HolyWordSalvation=v15(265967 - (574 + 191), nil, 147 + 30),PrayerCircle=v15(805147 - 483770, nil, 91 + 87),PrayerCircleBuff=v15(322228 - (254 + 595), nil, 305 - (55 + 71)),RhapsodyBuff=v15(514621 - 123985, nil, 1970 - (573 + 1217))});
	if (not v17.Priest or ((10379 - 6631) < (169 + 2043))) then
		v17.Priest = {};
	end
	v17.Priest.Commons = {Healthstone=v17(8881 - 3369),RefreshingHealingPotion=v17(192319 - (714 + 225)),BeacontotheBeyond=v17(596061 - 392098, {(2 + 11),(820 - (118 + 688))}),BelorrelostheSuncaller=v17(207220 - (25 + 23), {(1899 - (927 + 959)),(746 - (16 + 716))}),DesperateInvokersCodex=v17(375097 - 180787, {(31 - 18),(35 - 21)}),EruptingSpearFragment=v17(955717 - 761948, {(36 - 23),(1075 - (810 + 251))}),NymuesUnravelingSpindle=v17(144775 + 63840, {(12 + 1),(747 - (711 + 22))}),VoidmendersShadowgem=v17(425529 - 315522, {(4 + 9),(1 + 13)}),Dreambinder=v17(210360 - (1344 + 400), {(13 + 3)}),Iridal=v17(111530 + 96791, {(51 - 35)})};
	v17.Priest.Shadow = v18(v17.Priest.Commons, {});
	v17.Priest.Discipline = v18(v17.Priest.Commons, {});
	v17.Priest.Holy = v18(v17.Priest.Commons, {});
	if (not v20.Priest or ((2919 - (404 + 1335)) == (2586 - (183 + 223)))) then
		v20.Priest = {};
	end
	v20.Priest.Commons = {AngelicFeatherPlayer=v20(22 - 3),PowerInfusionPlayer=v20(19 + 9),PowerWordShieldPlayer=v20(11 + 18),FlashHealFocus=v20(367 - (10 + 327)),PowerInfusionFocus=v20(22 + 9),PowerWordLifeFocus=v20(370 - (118 + 220)),PurifyFocus=v20(11 + 22),RenewFocus=v20(483 - (108 + 341)),DominateMindMouseover=v20(5 + 4),LeapofFaithMouseover=v20(42 - 32),PowerWordLifeMouseover=v20(1504 - (711 + 782)),PowerWordShieldMouseover=v20(22 - 10),PurifyMouseover=v20(482 - (270 + 199)),ShadowWordDeathMouseover=v20(5 + 9),ShadowWordPainMouseover=v20(1834 - (580 + 1239)),ShackleUndeadMouseover=v20(47 - 31),MassDispelCursor=v20(17 + 0),Healthstone=v20(2 + 33),PowerWordFortitudePlayer=v20(8 + 10),RefreshingHealingPotion=v20(93 - 57),HaloPlayer=v20(187 + 113),DivineStarPlayer=v20(1468 - (645 + 522)),PowerWordShieldFocus=v20(2096 - (1010 + 780))};
	v20.Priest.Shadow = v18(v20.Priest.Commons, {PurifyDiseaseFocus=v20(302 + 0),FlashHealPlayer=v20(1443 - 1140),RenewPlayer=v20(890 - 586),ShadowCrashCursor=v20(2141 - (1045 + 791))});
	v20.Priest.Discipline = v18(v20.Priest.Commons, {DarkReprimandFocus=v20(95 - 57),DarkReprimandMouseover=v20(58 - 19),FlashHealMouseover=v20(546 - (351 + 154)),PainSuppressionFocus=v20(1617 - (1281 + 293)),PainSuppressionMouseover=v20(310 - (28 + 238)),PenanceFocus=v20(100 - 55),PenanceMouseover=v20(1605 - (1381 + 178)),PowerWordBarrierCursor=v20(45 + 2),PowerWordRadianceFocus=v20(41 + 9),PowerWordRadiancePlayer=v20(22 + 29),PurgeTheWickedMouseover=v20(179 - 127),RaptureFocus=v20(28 + 25),ShadowCovenantFocus=v20(525 - (381 + 89))});
	v20.Priest.Holy = v18(v20.Priest.Commons, {CircleofHealingFocus=v20(24 + 3),GuardianSpiritFocus=v20(14 + 6),HealFocus=v20(35 - 14),HolyWordSerenityFocus=v20(1178 - (1074 + 82)),PrayerofHealingFocus=v20(50 - 27),PrayerofMendingFocus=v20(1808 - (214 + 1570)),HolyWordSerenityMouseover=v20(1480 - (990 + 465)),HolyWordSanctifyCursor=v20(11 + 15)});
	v9.AddCoreOverride("Player.Insanity", function()
		local v36 = 0 + 0;
		local v37;
		while true do
			if (((3978 + 112) < (18311 - 13658)) and (v36 == (1726 - (1668 + 58)))) then
				v37 = v21("Player", v22);
				if (not v12:IsCasting() or ((3278 - (512 + 114)) < (510 - 314))) then
					return v37;
				elseif (((8548 - 4413) < (16761 - 11944)) and v12:IsCasting(v15.Priest.Shadow.MindBlast)) then
					return v37 + 3 + 3;
				elseif (((51 + 221) == (237 + 35)) and (v12:IsCasting(v15.Priest.Shadow.VampiricTouch) or v12:IsCasting(v15.Priest.Shadow.MindSpike))) then
					return v37 + (13 - 9);
				elseif (((2094 - (109 + 1885)) <= (4592 - (1269 + 200))) and v12:IsCasting(v15.Priest.Shadow.MindFlay)) then
					return v37 + ((22 - 10) / v15.Priest.Shadow.MindFlay:BaseDuration());
				elseif (v12:IsCasting(v15.Priest.Shadow.DarkVoid) or ((2184 - (98 + 717)) > (5813 - (802 + 24)))) then
					return v37 + (25 - 10);
				elseif (v12:IsCasting(v15.Priest.Shadow.DarkAscension) or ((1089 - 226) >= (677 + 3907))) then
					return v37 + 24 + 6;
				elseif (v12:IsCasting(v15.Priest.Shadow.VoidTorrent) or ((119 + 605) >= (360 + 1308))) then
					return v37 + ((166 - 106) / v15.Priest.Shadow.VoidTorrent:BaseDuration());
				else
					return v37;
				end
				break;
			end
		end
	end, 860 - 602);
	local v35;
	v35 = v9.AddCoreOverride("Spell.IsCastable", function(v38, v39, v40, v41, v42, v43)
		local v44 = 0 + 0;
		local v45;
		while true do
			if (((175 + 253) < (1489 + 315)) and (v44 == (0 + 0))) then
				v45 = v35(v38, v39, v40, v41, v42, v43);
				if ((v38 == v15.Priest.Shadow.VampiricTouch) or ((1553 + 1772) > (6046 - (797 + 636)))) then
					return v45 and not v15.Priest.Shadow.ShadowCrash:InFlight() and (v15.Priest.Shadow.UnfurlingDarkness:IsAvailable() or not v12:IsCasting(v38));
				elseif ((v38 == v15.Priest.Shadow.MindBlast) or ((24034 - 19084) <= (6172 - (1427 + 192)))) then
					return v45 and ((v38:Charges() >= (1 + 1)) or not v12:IsCasting(v38));
				elseif (((6187 - 3522) <= (3536 + 397)) and (v38 == v15.Priest.Shadow.VoidEruption)) then
					return v45 and not v12:IsCasting(v38);
				elseif (((1484 + 1789) == (3599 - (192 + 134))) and (v38 == v15.Priest.Shadow.VoidBolt)) then
					return v45 or v12:IsCasting(v15.Priest.Shadow.VoidEruption);
				else
					return v45;
				end
				break;
			end
		end
	end, 1534 - (316 + 960));
end;
return v0["Epix_Priest_Priest.lua"]();

